@isTest
public class NEU_Test_InvoiceDocuments {
@isTest(SeeAllData=true)
    static void NEU_InvoiceDocuments() 
    {
		NEU_StaticVariableHelper.setBoolean1(true);
		
		List<Associated_Document__c> associated_documents = new List<Associated_Document__c>();
		
		associated_documents = NEU_InvoiceDocuments.getDocuments();
    }
}