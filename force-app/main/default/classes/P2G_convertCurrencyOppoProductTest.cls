@isTest
public class P2G_convertCurrencyOppoProductTest {
@isTest(SeeAllData=true)
    public static void load(){
        OpportunityLineItem convertEUR = P2G_convertCurrencyOppoProduct.actualizarBuyPriceCurrency('Sales Price', 23, 'MXN', 'EUR');
        OpportunityLineItem convertUSD = P2G_convertCurrencyOppoProduct.actualizarBuyPriceCurrency('Buy Price', 23, 'EUR', 'USD');
        
        OpportunityLineItem oli = [SELECT Id, OpportunityId FROM OpportunityLineItem WHERE Opportunity.Account.Name LIKE : '%Ejemplo%' LIMIT 1];
        oli.Buy_Price__c = 39;
        oli.UnitPrice = 20;
        oli.Tipo_de_moneda__c = 'USD';
        update oli;
        
        SubProducto__c subProEURBuy = P2G_convertCurrencyOppoProduct.convertirBuySubProducto(23.12, 'MXN', 'EUR');
        SubProducto__c subProUSDBuy = P2G_convertCurrencyOppoProduct.convertirBuySubProducto(23.12, 'EUR', 'USD');
        SubProducto__c subProEURSell = P2G_convertCurrencyOppoProduct.convertirSellSubProducto(23.12, 'MXN', 'EUR');
        SubProducto__c subProUSDSell = P2G_convertCurrencyOppoProduct.convertirSellSubProducto(23.12, 'EUR', 'USD');
        
        SubProducto__c subProducto = new SubProducto__c();
        subProducto.Name = 'Carga Adicional';
        subProducto.SubProduct_Opportunity__c = oli.OpportunityId;
        subProducto.SubProduct_Opportunity_Product__c = oli.Id;
        subProducto.SubProduct_Grupo_Oportunidad__c = 'SP-FN-FLETE NACIONAL';
        subProducto.SubProduct_SAP_Service_Type__c = 'a1n4T000001XXY6QAO';//UAT a1n0R000001lZcYQAU  Prod a1n4T000001XXY6QAO
        subProducto.CurrencyIsoCode = 'EUR';
        subProducto.SubProduct_Buy_Price__c = 23;
        subProducto.SubProduct_Sell_Price__c = 23;
        insert subProducto;
        subProducto.CurrencyIsoCode = 'EUR';
        subProducto.SubProduct_Buy_Price__c = 32;
        subProducto.SubProduct_Sell_Price__c = 32;
        update subProducto;
    }
}