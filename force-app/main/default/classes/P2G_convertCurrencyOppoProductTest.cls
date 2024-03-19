@isTest
public class P2G_convertCurrencyOppoProductTest {
@isTest(SeeAllData=true)
    public static void load(){
        OpportunityLineItem convertEUR = P2G_convertCurrencyOppoProduct.actualizarBuyPriceCurrency('Sales Price', 23, 'MXN', 'EUR');
        OpportunityLineItem convertUSD = P2G_convertCurrencyOppoProduct.actualizarBuyPriceCurrency('Buy Price', 23, 'EUR', 'USD');
        
        OpportunityLineItem oli = [SELECT Id FROM OpportunityLineItem WHERE Opportunity.Account.Name LIKE : '%Ejemplo%' LIMIT 1];
        oli.Buy_Price__c = 39;
        oli.UnitPrice = 20;
        oli.Tipo_de_moneda__c = 'USD';
        update oli;
    }
}