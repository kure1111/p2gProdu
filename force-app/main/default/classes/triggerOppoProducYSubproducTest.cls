@isTest(SeeAllData=true)
public class triggerOppoProducYSubproducTest {
	@isTest
    static void prueba() {
        List<SubProducto__c> subProd = [SELECT Id, Name, SubProduct_Opportunity_Product__c, SubProduct_Opportunity__c,SubProducto__c.SubProduct_Grupo_Oportunidad__c,
                                  SubProduct_Opportunity_Product__r.Status__c, Status__c,SubProduct_Opportunity__r.Group__c FROM SubProducto__c
                                       WHERE SubProduct_Sell_Price__c != null AND SAP_Service_Type_Buy__c != null AND SubProduct_Grupo_Oportunidad__c != null 
                                        AND id =: 'a3CRQ000009iKib2AE'];
        Sap_Service_Type__c service = [SELECT Id, Name, Group__c FROM Sap_Service_Type__c 
                                                       WHERE Name LIKE : '%cargo%' AND Group__c =: subProd[0].SubProduct_Grupo_Oportunidad__c limit 1];
        List<String> idOppo = new List<String>();
        for(SubProducto__c sub: subProd){
            idOppo.add(sub.SubProduct_Opportunity__c);
        }
        OpportunityLineItem oliUpdate = new OpportunityLineItem();
        oliUpdate.Id = subProd[0].SubProduct_Opportunity_Product__c;
        oliUpdate.Status__c = 'Cotizada';
        oliUpdate.Tipo_de_moneda__c = 'EUR';
        update oliUpdate;
        SubProducto__c sub = new SubProducto__c();
        sub.Id = subProd[0].Id;
        sub.Status__c = 'Cotizada';
        sub.Tipo_de_moneda__c = 'USD';
        sub.CurrencyIsoCode = 'MXN';
        sub.SubProduct_Sell_Price__c = 2340;
        sub.SubProduct_Buy_Price__c = 3490;
        update sub;
        oliUpdate.Id = subProd[0].SubProduct_Opportunity_Product__c;
        oliUpdate.Status__c = 'Negociación con cliente';
        update oliUpdate;
    }
}