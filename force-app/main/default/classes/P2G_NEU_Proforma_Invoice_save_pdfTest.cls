@isTest
public class P2G_NEU_Proforma_Invoice_save_pdfTest {
    @isTest
    static void test_NEU_Proforma_Invoice_save_pdf()
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;
        Account a= new Account();
        a.Name='Test';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a.OwnerId=UserInfo.getUserId();
        insert a;
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00032', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_Proforma_Invoice_save_pdf uda = new NEU_Proforma_Invoice_save_pdf(new ApexPages.StandardController( ship ));
        Blob b = Blob.valueOf('Test Data');
        uda.documento_asociado.Name='Test document.test';
        uda.documento_asociado.AuthorId = UserInfo.getUserId();
        uda.documento_asociado.IsPublic=true;
        uda.documento_asociado.Body = b;
        uda.crear();
    }
    
    
}