@isTest(SeeAllData=true)
public class P2G_crearSubProductosTest {
    @IsTest
    static void prueba() {
        SubProducto__c subProd = [SELECT Id, Name, SubProduct_Opportunity_Product__c, SubProduct_Opportunity__c,
                                  Status__c, SubProduct_Opportunity__r.Group__c FROM SubProducto__c LIMIT 1];
		P2G_crearSubProductos.wrapperSubProducto subwrapper = P2G_crearSubProductos.getWrapper();
        subwrapper.id = '';
        subwrapper.name = 'pruebaTest';
        subwrapper.currencyIsoCode = 'MXN';
        subwrapper.tipoMoneda = 'MXN';
        subwrapper.asesoria = '';
        subwrapper.buyPrice = '2300';
        subwrapper.sellPrice = '4562';
        subwrapper.comercializadora = '';
        subwrapper.despacho = '';
        subwrapper.detalles = '';
        subwrapper.lenght = '';
        subwrapper.width = '';
        subwrapper.height = '';
        subwrapper.hazmat = false; 
        subwrapper.reefer = false;
        subwrapper.seguroContenedor = '';
        subwrapper.seguroMercancia = '';
        subwrapper.temperatura = '';
        subwrapper.escalaTemperatura = '';
        subwrapper.trasborda = false;
        subwrapper.units = '';
        subwrapper.grupo = subProd.SubProduct_Opportunity__r.Group__c;
        subwrapper.idOpoProduct = subProd.SubProduct_Opportunity_Product__c;
        subwrapper.idOportunidad = subProd.SubProduct_Opportunity__c;
        subwrapper.idSapServiceType = '';
        subwrapper.idSapServiceTypeBuy = '';
        subwrapper.error = '';
        list<SubProducto__c> getSubProductOppo = P2G_crearSubProductos.getSubProductOppo(subProd.SubProduct_Opportunity__c);
        list<SubProducto__c> getSubProductProduct = P2G_crearSubProductos.getSubProductProduct(subProd.SubProduct_Opportunity_Product__c);
        list<OpportunityLineItem> getOppoProduct = P2G_crearSubProductos.getOppoProduct(subProd.SubProduct_Opportunity_Product__c);
        OpportunityLineItem infoProduct = P2G_crearSubProductos.infoProduct(subProd.SubProduct_Opportunity_Product__c);
        list<Sap_Service_Type__c> getSapServiceType = P2G_crearSubProductos.getSapServiceType('cargo',subProd.SubProduct_Opportunity__c);
        P2G_crearSubProductos.wrapperSubProducto crearSubProducto = P2G_crearSubProductos.crearSubProducto(subwrapper);
        P2G_crearSubProductos.cambiarStatus(subProd.SubProduct_Opportunity_Product__c);
    }
}