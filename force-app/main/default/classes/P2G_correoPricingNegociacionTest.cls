@isTest(SeeAllData=true)
public class P2G_correoPricingNegociacionTest {
	@isTest
    static void prueba() {
        OpportunityLineItem oli = [SELECT Id, Name, OpportunityId, Opportunity.Name, Ruta__c,
                                       Opportunity.Account.Name, Product2.Name, PROJ_Tipo_de_mercancia__c, Quantity,
                                       PROJ_Modalidad__c,PROJ_Frecuencia__c,Comentarios__c,Buy_Price__c,UnitPrice,Target__c
                                       FROM OpportunityLineItem LIMIT 1];
        P2G_correoPricingNegociacion.enviarCorreo(oli.Id);
    }
}