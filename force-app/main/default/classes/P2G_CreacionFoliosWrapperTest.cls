@isTest
public class P2G_CreacionFoliosWrapperTest {
    
    @testSetup
    static void setup() {
        List<SAP_Service_Type__c> sstList = new List<SAP_Service_Type__c>();
        sstList.add(new SAP_Service_Type__c(Name='FLETE NACIONAL', Code__c='FN', Group__c='SP-FN-FLETE NACIONAL', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='FLETE INTERNACIONAL', Code__c='FI', Group__c='SP-FI-FLETE INTER', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='AEREO', Code__c='A', Group__c='SP-A-AEREO', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='COMERCIO EXT', Code__c='CE', Group__c='SP-CE-COMERCIO EXT', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='MARITIMO', Code__c='M', Group__c='SP-M-MARITIMO', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='PUERTOS', Code__c='PTO', Group__c='SP-PTO-PUERTOS', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='GLOBAL ROUTIN', Code__c='R', Group__c='SP-R-GLOBAL ROUTING', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='ALMACENAJE', Code__c='WH', Group__c='SP-WH-ALMACENAJE', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='CONSOLIDADO', Code__c='T', Group__c='SP-T-CONSOLIDADO', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='SEGUROS', Code__c='EX', Group__c='SP-EX-SEGUROS', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='GLOBAL MARITIMO', Code__c='W', Group__c='SP-W-GLOBAL MARITIMO', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='GLOBAL AEREO', Code__c='AW', Group__c='SP-AW-GLOBAL AEREO', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='PAQUETERIA', Code__c='PQ', Group__c='SP-PQ-PAQUETERIA', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='REFRIGERADO NACIONAL', Code__c='RN', Group__c='SP-RN-RefrigeradoNacional', Activo__c=true));
        sstList.add(new SAP_Service_Type__c(Name='REFRIGERADO INTER', Code__c='RI', Group__c='SP-RI-RefrigeradoInter', Activo__c=true));
        insert sstList;
    }

    @isTest
    static void testGetwrapper2() {
        Test.startTest();
        P2G_CreacionFoliosWrapper.getwrapper2();
        Test.stopTest();
    }

    @isTest
    static void testGetCargoline2() {
        Test.startTest();
        P2G_CreacionFoliosWrapper.getCargoline2();
        Test.stopTest();
    }

    @isTest
    static void testGetSapServiceTypeFound() {
        Test.startTest();
        P2G_CreacionFoliosWrapper.getSapServiceType('NACIONAL', 'SP-FN-FLETE NACIONAL');
        Test.stopTest();
    }

    @isTest
    static void testGetSapServiceTypeNotFound() {
        Test.startTest();
        try {
            P2G_CreacionFoliosWrapper.getSapServiceType('INEXISTENTE', 'SP-FN-FLETE NACIONAL');
        } catch (AuraHandledException e) {}
        Test.stopTest();
    }

    @isTest
    static void testTipoServicio() {
        Test.startTest();
        
        List<String> grupos = new List<String>{
            'SP-FN-FLETE NACIONAL',
            'SP-FI-FLETE INTER',
            'SP-A-AEREO',
            'SP-CE-COMERCIO EXT',
            'SP-M-MARITIMO',
            'SP-PTO-PUERTOS',
            'SP-R-GLOBAL ROUTING',
            'SP-WH-ALMACENAJE',
            'SP-T-CONSOLIDADO',
            'SP-EX-SEGUROS',
            'SP-W-GLOBAL MARITIMO',
            'SP-AW-GLOBAL AEREO',
            'SP-PQ-PAQUETERIA',
            'SP-RN-RefrigeradoNacional',
            'SP-RI-RefrigeradoInter',
            'GRUPO_INEXISTENTE'
        };
        
        for (String grupo : grupos) {
            P2G_CreacionFoliosWrapper.folio f = new P2G_CreacionFoliosWrapper.folio();
            f.grupo = grupo;
            P2G_CreacionFoliosWrapper.tipoServicio(f);
        }
        
        Test.stopTest();
    }

    @isTest
    static void testInnerClasses() {
        P2G_CreacionFoliosWrapper.folio f = new P2G_CreacionFoliosWrapper.folio();
        f.id = 'a0IRL00000BQZ3p2AH';
        f.Name = 'RN-26-000094';
        f.numFoliosCrear = 1;
        f.comercioExterior = 'No';
        f.freighMode = 'Road';
        f.serviceMode = 'NATIONAL';
        f.servicetype = 'FTL';
        f.reference = 'REF123';
        f.rurrencyIsoCode = 'MXN';
        f.currencyIsoCode = 'MXN';
        f.etd = '2026-07-22';
        f.eta = '2026-07-23';
        f.team = 'P2G';
        f.quotationStatus = 'Quote being prepared';
        f.CommunityStatus = 'CUSTOMER CREATED';
        f.Awaitingloadtime = '08:00:00.000';
        f.Awaitingunloadtime = '18:00:00.000';
        f.grupo = 'SP-RN-Refrigerado Nacional';
        f.border = 'Norte';
        f.customs = 'Nuevo Laredo';
        f.impak = 'IMPAK123';
        f.servicioIMPAK = 'Servicio Test';
        f.salesIncoterm = 'FOB';
        f.warehouseService = false;
        f.idSideLoad = 'a030R000008RxCbQAK';
        f.idSideDischarged = 'a034T000004FHZxQAO';
        f.idAccount = '0014T00000BIs6PQAT';
        f.idReferenceForm = 'a0IRL00000BQZ3p2AH';
        f.recordTypeUnidad = 'a3n0R000000ETiqQAG';
        f.idConteinerType = 'a0F4T000000R9qxUAC';
        f.accountOriginAddress = 'Address 123';
        f.accountDestinAddress = 'Address 456';
        f.buyPrice = '100';
        f.sellPrice = '150';
        f.refrigerado = true;
        f.error = 'sin error';
        
        P2G_CreacionFoliosWrapper.cargoLine c = new P2G_CreacionFoliosWrapper.cargoLine();
        c.idQuote = 'a0IRL00000BQZ3p2AH';
        c.idItem = 'a0ORL00000FgGKf2AN';
        c.idConteinerType = 'a0F4T000000R9qxUAC';
        c.idClaveSat = 'a3n0R000000EZWrQAO';
        c.idItemSuplienerOwner = '0014T00000BIs6PQAT';
        c.extencionItemName = 'Pescado congelado';
        c.description = 'Pescado fresco';
        c.currencyIsoCode = 'MXN';
        c.units = '10';
        c.pesoBruto = '100';
        c.pesoNeto = '90';
        c.itemPrice = '50';
        c.totalShipping = '1';
        c.MaterialPeligroso = 'a3n0R000000EZWrQAO';
        c.Embalaje = 'a3n0R000000EZWrQAO';
        c.idSST = 'a1nRL00000OTPMzYAP';
        c.length = '100';
        c.width = '50';
        c.height = '40';
        c.weight = '80';
        c.idFraccionArancelaria = 'a3n0R000000EZWrQAO';
        c.pedimento = '123456';
        c.temperatura = '10°C';
        
        P2G_CreacionFoliosWrapper.namesIds n = new P2G_CreacionFoliosWrapper.namesIds();
        n.vacio = false;
        n.idQuote = 'a0IRL00000BQZ3p2AH';
        n.name = 'RN-26-000094';
        
        P2G_CreacionFoliosWrapper.folioMasivo fm = new P2G_CreacionFoliosWrapper.folioMasivo();
        fm.folio = f;
        fm.cargo = c;
        
        P2G_CreacionFoliosWrapper.folioM fm2 = new P2G_CreacionFoliosWrapper.folioM();
        fm2.folio = new List<Customer_Quote__c>();
        fm2.cargo = new List<P2G_CreacionFoliosWrapper.cargoLine>();
        fm2.cargo.add(c);
    }
}