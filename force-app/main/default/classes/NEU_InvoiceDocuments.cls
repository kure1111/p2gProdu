public class NEU_InvoiceDocuments 
{
    @AuraEnabled
    public static List<Associated_Document__c> getDocuments()
    {
        return [SELECT Id, Name, CreatedDate, Document_Type__c, Document_Reference__c, Document_Description__c, Document_URL__c, Type__c
       	FROM Associated_Document__c WHERE Invoice__c != null AND Available_for_Community__c = true];
    }
}