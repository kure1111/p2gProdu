@isTest(SeeAllData=true)
public class OpportunityNameTest {
    @isTest
    public static void test(){
        Opportunity oppac = [SELECT Id, Name, AccountId, RecordTypeId FROM Opportunity WHERE Group__c = 'SP-PQ-PAQUETERIA' AND TotalOpportunityQuantity > 0 AND SLA_Entendimiento__c != null AND SLA_Cotizacion__c != null AND Account.Record_Type_Name__c = 'Customer' LIMIT 1];
        oppac.StageName = 'Ganada';
        update oppac;
        oppac.StageName = 'Negociación';
        update oppac;
        oppac.StageName = 'Ejecución';
        update oppac;
        Opportunity op = [SELECT Id, Name, AccountId FROM Opportunity WHERE RecordType.Name='Proyecto' AND Group__c != 'SP-PQ-PAQUETERIA' AND TotalOpportunityQuantity > 0 AND SLA_Entendimiento__c != null AND Account.Record_Type_Name__c = 'Customer' LIMIT 1];
        op.StageName = 'Cotización';
        update op;
        Quote quote = [SELECT Id, OpportunityId FROM Quote WHERE Vendido__c = True AND Opportunity.Realizacion_de_Kickoff__c = false AND Opportunity.Group__c = 'SP-PQ-PAQUETERIA' AND Opportunity.SLA_Entendimiento__c != null AND Account.Record_Type_Name__c = 'Customer' LIMIT 1];
        Opportunity oppo = new Opportunity();
        oppo.Id = quote.OpportunityId;
        oppo.StageName = 'Ejecución';
        oppo.Realizacion_de_Kickoff__c = true;
        update oppo;
        oppo.StageName = 'Ganada';
        update oppo;
        oppo.StageName = 'Negociación';
        update oppo;
        Opportunity newOppo = new Opportunity();
        newOppo.Name = 'Test Name';
        newOppo.RecordTypeId = oppac.RecordTypeId;
        newOppo.Service_Type__c = 'PQ';
        newOppo.AccountId = oppo.AccountId;
        newOppo.StageName = 'Entendimiento';
        newOppo.CloseDate = System.today()+5;
        insert newOppo;
        newOppo.Group__c = 'SP-PQ-PAQUETERIA';
        newOppo.StageName = 'Ganada';
        update newOppo;
    }
}