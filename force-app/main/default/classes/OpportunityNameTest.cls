@isTest(SeeAllData=true)
public class OpportunityNameTest {
    @isTest
    public static void test(){
        Opportunity oppac = [SELECT Id, Name, AccountId FROM Opportunity WHERE (Group__c = 'SP-PQ-PAQUETERIA' AND TotalOpportunityQuantity > 0) LIMIT 1];
        oppac.StageName = 'Ejecución';
        oppac.Realizacion_de_Kickoff__c = true;
        
            //update oppac;
        Opportunity op = [SELECT Id, Name, AccountId FROM Opportunity WHERE RecordType.Name='Proyecto' AND Group__c != 'SP-PQ-PAQUETERIA' AND TotalOpportunityQuantity > 0 LIMIT 1];
        op.StageName = 'Cotización';
        try{
            update op;
        }catch(Exception e){
            system.debug('callo en error');
        }
    }
}