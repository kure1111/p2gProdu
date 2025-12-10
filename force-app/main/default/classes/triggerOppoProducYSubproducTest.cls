@isTest(SeeAllData=true)
public class triggerOppoProducYSubproducTest {
	@isTest
    static void prueba() {
        OpportunityLineItem product = [SELECT Id, Name, OpportunityId, Status__c, Opportunity.Group__c FROM OpportunityLineItem
                                       WHERE Status__c = 'Pendiente por Cotizar' Limit 1];
        Sap_Service_Type__c service = [SELECT Id, Name, Group__c FROM Sap_Service_Type__c 
                                                       WHERE Name LIKE : '%cargo%' AND Group__c =: product.Opportunity.Group__c limit 1];
        Test.startTest();
        	Quote quote = new Quote();
                quote.Name = '001';
                quote.OpportunityId = product.OpportunityId;
        	Insert quote;
        	SubProducto__c subInsert = new SubProducto__c();
                subInsert.Status__c = 'Pendiente por Cotizar';
                subInsert.Tipo_de_moneda__c = 'USD';
                subInsert.CurrencyIsoCode = 'MXN';
                subInsert.SubProduct_Sell_Price__c = 2340;
                subInsert.SubProduct_Buy_Price__c = 3490;
                subInsert.SAP_Service_Type_Buy__c = service.Id;
                subInsert.SubProduct_SAP_Service_Type__c = service.Id;
                subInsert.SubProduct_Grupo_Oportunidad__c = product.Opportunity.Group__c;
            	subInsert.SubProduct_Opportunity_Product__c = product.Id;
        		subInsert.SubProduct_Opportunity__c = product.OpportunityId;
            Insert subInsert;
                product.Status__c = 'Cotizada';
                product.Tipo_de_moneda__c = 'EUR';
            update product;
                product.Status__c = 'Negociación con cliente';
                product.Target__c = 1200;
        	update product;
                subInsert.Tipo_de_moneda__c = 'MXN';
                subInsert.CurrencyIsoCode = 'USD';
                subInsert.SubProduct_Sell_Price__c = 3240;
                subInsert.SubProduct_Buy_Price__c = 4390;
                subInsert.Status__c = 'Rechazada';
                subInsert.SAP_Service_Type_Buy__c = service.Id;
            update subInsert;
        Test.stopTest();
    }
}