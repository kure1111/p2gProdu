@isTest
public class P2G_loadProductsTest {
    @isTest
    public static void load(){
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
        List<P2G_loadProducts.csvProduct> getOpportunityLineItems = P2G_loadProducts.getOpportunityLineItems('006RL0000046t18YAA');
        P2G_loadProducts.quitar();
    }

}