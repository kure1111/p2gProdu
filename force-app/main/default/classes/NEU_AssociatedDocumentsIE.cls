public class NEU_AssociatedDocumentsIE 
{
	public static Customer_Quote__c record;
    
    @AuraEnabled
    public static Customer_Quote__c getImportExport(string recordId) 
    {
        return [SELECT Id, Name
       	FROM Customer_Quote__c WHERE Id =: recordId limit 1];
    }
    
    @AuraEnabled
    public static List<Associated_Document__c> getDocuments(string recordId)
    {
        return [SELECT Id, Name, CreatedDate, Document_Type__c, Document_Reference__c, Document_Description__c, Document_URL__c, Type__c
       	FROM Associated_Document__c WHERE Import_Export_Quote__c =: recordId AND Available_for_Community__c = true];
    }
    
    @AuraEnabled
    public static List<Associated_Document__c> createAssociatedDocuments(string recordId, string[] ids_ficheros)
    {		
        record = [select Id, Name, Account_for__c from Customer_Quote__c where Id =: recordId limit 1];
        
        List<Associated_Document__c> new_documents = new List<Associated_Document__c>();
		
        for(string ids : ids_ficheros)
        {
            Associated_Document__c new_doc = new Associated_Document__c();
            new_doc.Import_Export_Quote__c = record.Id;
            new_doc.Account__c = record.Account_for__c;
            new_doc.Available_for_Community__c = true;
            new_doc.Type__c = 'File';
            new_doc.Document_URL__c = ids.split('\\|',0)[0];
			new_doc.Name = ids.split('\\|',0)[1];   
            new_documents.add(new_doc);
        }
		
        try
        {
            insert new_documents;
            
            return [SELECT Id, Name, CreatedDate, Document_Type__c, Document_Reference__c, Document_Description__c, Document_URL__c, Type__c
       		FROM Associated_Document__c WHERE Import_Export_Quote__c =: recordId AND Available_for_Community__c = true];
        }
        catch(Exception ex){return null;}
    }
    
    @AuraEnabled
    public static List<Associated_Document__c> deleteDocument(string recordId, string document_id)
    {
        try
        {
            List<Associated_Document__c> document = [select Id, Name from Associated_Document__c where Id =: document_id];
            delete document;
        }
        catch(Exception ex){}
        
        return [SELECT Id, Name, CreatedDate, Document_Type__c, Document_Reference__c, Document_Description__c, Document_URL__c, Type__c
       	FROM Associated_Document__c WHERE Import_Export_Quote__c =: recordId AND Available_for_Community__c = true];
    }
}