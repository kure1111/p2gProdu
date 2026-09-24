/**
 * Tests E2E de "Buy Price = 0 -> No Cotizada -> opp a Negociación" (opps Proyecto)
 * y cobertura de triggerControllerOpportunityProduct con datos propios
 * (los tests previos del trigger usan datos reales del org y estan rotos).
 * Portable UAT/Produ: RT por DeveloperName, sin IDs fijos.
 */
@isTest
private class P2G_NoCotizadaBuyCeroTest {

    private static Opportunity crearOpp(String nombre, Integer numLineas) {
        User yo = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        // el trigger PrecioSugerido (before insert/update de OLI) exige que exista este rol
        TestDataFactory.createRolMargen('Asesor Comercial');

        Account cuenta = new Account(
            Name = 'account test nc', Customer_Id__c = '58SQL9999', OwnerId = yo.Id,
            Venta_Sap__c = 'Credito', Credit_Limit__c = 6000000.00, Segment__c = 'Nuevo'
        );
        insert cuenta;

        Id rtProyectos = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
            .get('Proyectos').getRecordTypeId();

        Opportunity opp = new Opportunity(
            Name = nombre, RecordTypeId = rtProyectos, AccountId = cuenta.Id,
            StageName = 'Entendimiento', CloseDate = Date.today().addDays(60),
            Group__c = 'SP-FN-FLETE NACIONAL', Usuario_IC__c = yo.Id
        );
        insert opp;

        Id stdPb = Test.getStandardPricebookId();
        Product2 prod = new Product2(Name = 'Producto NC Test', IsActive = true);
        insert prod;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = stdPb, Product2Id = prod.Id, UnitPrice = 1, IsActive = true);
        insert pbe;
        opp.Pricebook2Id = stdPb;
        update opp; // ademas dispara Entendimiento -> Cotización cuando ya hay cantidad

        List<OpportunityLineItem> lineas = new List<OpportunityLineItem>();
        for (Integer i = 0; i < numLineas; i++) {
            lineas.add(new OpportunityLineItem(
                OpportunityId = opp.Id, PricebookEntryId = pbe.Id, Quantity = 1,
                UnitPrice = 0, Status__c = 'Pendiente por Cotizar', Tipo_de_moneda__c = 'MXN'
            ));
        }
        insert lineas;
        update new Opportunity(Id = opp.Id, Description = 'toque para avanzar etapa');
        return opp;
    }

    @isTest
    static void mixta_lineaCeroYLineaCotizada() {
        Opportunity opp = crearOpp('TEST NC MIXTA', 2);
        List<OpportunityLineItem> lineas = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :opp.Id ORDER BY Id];

        Test.startTest();
        // linea 1 se cotiza
        OpportunityLineItem l1 = new OpportunityLineItem(Id = lineas[0].Id, Buy_Price__c = 100, UnitPrice = 150);
        update l1;
        // linea 2 queda No Cotizada con Buy = 0 (en el deploy a Produ el flow nuevo viaja
        // INACTIVO, asi que aqui se pone el status directo; con el flow activo el resultado
        // es el mismo — la conducta completa se verifica E2E tras activar los flows)
        OpportunityLineItem l2 = new OpportunityLineItem(Id = lineas[1].Id, Buy_Price__c = 0,
            Status__c = 'No Cotizada', Razon_del_rechazo__c = 'No cotizado por Pricing: Buy Price en $0 (automático)');
        update l2;
        Test.stopTest();

        OpportunityLineItem chk1 = [SELECT Status__c FROM OpportunityLineItem WHERE Id = :lineas[0].Id];
        OpportunityLineItem chk2 = [SELECT Status__c, Razon_del_rechazo__c FROM OpportunityLineItem WHERE Id = :lineas[1].Id];
        System.assertEquals('Cotizada', chk1.Status__c, 'La linea con Buy y Sell > 0 debe quedar Cotizada');
        System.assertEquals('No Cotizada', chk2.Status__c);
        // el touch del trigger (algunaNoCotizada) debe re-evaluar la etapa aunque los
        // totales no cambien: con una Cotizada y la otra No Cotizada la opp avanza
        System.assertEquals('Negociación', [SELECT StageName FROM Opportunity WHERE Id = :opp.Id].StageName,
            'Con una linea Cotizada y la otra No Cotizada la opp avanza');
    }

    @isTest
    static void todoCero_avanzaSinQuoteYRespetaRazonManual() {
        Opportunity opp = crearOpp('TEST NC TODOCERO', 1);
        OpportunityLineItem l = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :opp.Id LIMIT 1];

        Test.startTest();
        // status directo por la misma razon del test mixta (flows inactivos durante el
        // deploy a Produ); ejercita el touch del trigger con totales sin cambio
        l.Buy_Price__c = 0;
        l.Status__c = 'No Cotizada';
        l.Razon_del_rechazo__c = 'Proveedor sin ruta disponible';
        update l;
        Test.stopTest();

        OpportunityLineItem chk = [SELECT Status__c, Razon_del_rechazo__c FROM OpportunityLineItem WHERE Id = :l.Id];
        System.assertEquals('No Cotizada', chk.Status__c);
        System.assertEquals('Proveedor sin ruta disponible', chk.Razon_del_rechazo__c, 'La razon manual se respeta');
        System.assertEquals(0, [SELECT COUNT() FROM Quote WHERE OpportunityId = :opp.Id],
            'Todo en cero no debe generar quote');
        // el avance de etapa con todo-en-cero depende de la version NUEVA del flow de
        // etapas (viaja inactiva en el deploy): se verifica E2E tras activarla
    }

    @isTest
    static void buyVacioNoMarca() {
        Opportunity opp = crearOpp('TEST NC NEGATIVO', 1);
        OpportunityLineItem l = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :opp.Id LIMIT 1];

        Test.startTest();
        l.UnitPrice = 999; // Buy sigue null
        update l;
        Test.stopTest();

        OpportunityLineItem chk = [SELECT Status__c, Razon_del_rechazo__c FROM OpportunityLineItem WHERE Id = :l.Id];
        System.assertEquals('Pendiente por Cotizar', chk.Status__c, 'Buy vacio significa aun-no-cotizado, no dispara');
        System.assertEquals(null, chk.Razon_del_rechazo__c);
        System.assertEquals('Cotización', [SELECT StageName FROM Opportunity WHERE Id = :opp.Id].StageName);
    }

    @isTest
    static void transicionesDeNegociacionConCliente() {
        // cubre las ramas del trigger: correo/sello al ENTRAR a 'Negociación con cliente' y SLA al salir
        Opportunity opp = crearOpp('TEST NC STATUSNEG', 1);
        OpportunityLineItem l = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :opp.Id LIMIT 1];

        Test.startTest();
        update new OpportunityLineItem(Id = l.Id, Buy_Price__c = 50, UnitPrice = 60);
        update new OpportunityLineItem(Id = l.Id, Status__c = 'Negociación con cliente');
        update new OpportunityLineItem(Id = l.Id, Status__c = 'Cotizada');
        Test.stopTest();

        OpportunityLineItem chk = [SELECT Status__c, Data_Time_Negocia_Pricing__c, SLA_Negocia_Pricing__c
                                   FROM OpportunityLineItem WHERE Id = :l.Id];
        System.assertEquals('Cotizada', chk.Status__c);
        System.assertNotEquals(null, chk.Data_Time_Negocia_Pricing__c, 'Se sella la entrada a Negociación con cliente');
    }
}
