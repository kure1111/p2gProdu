@isTest(SeeAllData=true)
public class P2G_loadProductsTest {
    @isTest
    public static void load(){
        P2G_loadProducts.csvProduct csv = P2G_loadProducts.getCsv();
        csv.origen = 'ori';
        csv.destino = 'dest';
        csv.origenId = 'a034T000004F9RnQAK';
        csv.destinoId = 'a034T000004F9RnQAK';
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
        csv.IdOli = '00kRQ0000097LXJYA2';
        List<P2G_loadProducts.csvProduct> listCsv = new List<P2G_loadProducts.csvProduct>();
        listCsv.add(csv);
        OpportunityLineItem oliop = new OpportunityLineItem(
        OpportunityId = '006RQ000007Ohe6YAC',
        Product2Id = '01tRQ000002j1QEYAY',
        PricebookEntryId = '01sRQ000000LJxJYAW',
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
        OpportunityLineItem oli = P2G_loadProducts.createOpporLi('006RQ000007Ohe6YAC','006RL0000046t18YAA','006RL0000046t18YAA',csv);
        List<P2G_loadProducts.csvProduct> getOpportunityLineItems = P2G_loadProducts.getOpportunityLineItems('006RL0000046t18YAA');
        P2G_loadProducts.quitar();
        Decimal convertirLbKg = P2G_loadProducts.convertirLbKg('234');
        OpportunityLineItem oliquote = [SELECT id, OpportunityId FROM OpportunityLineItem limit 1];
        Opportunity infoGrupo = P2G_loadProducts.infoGrupo(oliquote.OpportunityId);
        List<ContentVersion> getFiles = P2G_loadProducts.getFiles(oliquote.id);
        P2G_loadProducts.updateNotas(oliquote.id, 'Una nota test');
        List<OpportunityLineItem> getproducto = P2G_loadProducts.getproducto(oliquote.id);
        list<Catalogo_SAT__c> getCp = P2G_loadProducts.getCp('98465');
        String jsonString = JSON.serialize(csv);
        P2G_loadProducts.handleProduct(oliquote.OpportunityId,jsonString);
        String jsonStringList = JSON.serialize(listCsv);
        P2G_loadProducts.updateOli(jsonStringList);
    }
}