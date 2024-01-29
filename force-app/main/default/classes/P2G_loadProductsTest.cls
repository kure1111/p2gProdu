@isTest
public class P2G_loadProductsTest {
    @isTest
    public static void load(){
        /*
        Account a = new Account();
        a.Name = 'test';
        insert a;
        
        Opportunity op = new Opportunity();
        op.AccountId = a.Id;
        op.Name = 'Test OP';
        op.Service_Type__c = 'FN';
        op.StageName = 'Prospecting';
        op.CloseDate = date.today() + 3;
        insert op;
        
        // Crea un producto para el OpportunityLineItem
        Product2 testProduct = new Product2(
            Name = 'Test Product'
        );
        insert testProduct;
        
        // Crea una entrada en el libro de precios para el producto
        PricebookEntry testPricebookEntry = new PricebookEntry(
            Product2Id = testProduct.Id,
            UnitPrice = 100,  // Puedes ajustar el precio según sea necesario
            IsActive = true,
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert testPricebookEntry;
        
        // Crea el OpportunityLineItem asociado al Opportunity y PricebookEntry
        OpportunityLineItem testOpportunityLineItem = new OpportunityLineItem(
            OpportunityId = op.Id,
            Product2Id = testProduct.Id,
            PricebookEntryId = testPricebookEntry.Id,
            Quantity = 1,
            Precio_Sugerido__c = 1.0
        );
        insert testOpportunityLineItem;
		*/
        
        P2G_loadProducts.csvProduct csv = P2G_loadProducts.getCsv();
        csv.origen = 'ori';
        csv.destino = 'dest';
        csv.origenId = '006RL0000046t18YAA';
        csv.destinoId = '006RL0000046t18YAA';
        csv.cantidad = '1';
        csv.pesoDeCarga = '1';
        csv.unidadPorFrecuencia = '1';
        csv.tipoMercancia = 'sds';
        csv.frecuencia = 'Semanal';
        csv.tiempoCarga = '1';
        csv.tiempoDescarga = '1';
        csv.modalidad = 'Caja 53 FT';
        csv.direccionCarga = 'asdhas';
        csv.direccionDescarga = 'hksfhs';
        csv.comentarios = 'sdkh';
        csv.modificar = false;
        csv.buyPrice = '12';
        csv.sellPrice = '12';
        
        OpportunityLineItem oliop = new OpportunityLineItem(
        OpportunityId = '006RL0000046t18YAA',
        Product2Id = '006RL0000046t18YAA',
        PricebookEntryId = '006RL0000046t18YAA',
        Quantity = 10,
        UnitPrice = 100.00,
        TotalPrice = 1000.00,
        PROJ_Direccion_de_carga__c = 'DireccionCarga_Ejemplo',
        PROJ_Direccion_de_descarga__c = 'DireccionDescarga_Ejemplo',
        PROJ_Peso_de_carga__c = 500.00,
        PROJ_Unidades_por_frecuencia__c = 'UnidadesPorFrecuencia_Ejemplo',
        PROJ_Tipo_de_mercancia__c = 'TipoMercancia_Ejemplo',
        PROJ_Frecuencia__c = 'Frecuencia_Ejemplo',
        PROJ_Tiempo_de_carga__c = 2,
        PROJ_Tiempo_de_descarga__c = 1,
        PROJ_Modalidad__c = 'Modalidad_Ejemplo',
        Comentarios__c = 'Comentarios_Ejemplo',
        Buy_Price__c = 90.00
    );
        P2G_loadProducts.csvProduct csv2 = P2G_loadProducts.rellenagetItems(oliop);
        OpportunityLineItem oli2 = P2G_loadProducts.rellenaOpporLi(csv);
        OpportunityLineItem oli = P2G_loadProducts.createOpporLi('006RL0000046t18YAA','006RL0000046t18YAA','006RL0000046t18YAA',csv);
        P2G_loadProducts.quitar();
    }

}