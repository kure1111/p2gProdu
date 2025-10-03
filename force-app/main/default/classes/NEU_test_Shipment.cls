@isTest
private class NEU_test_Shipment {


    
    static testMethod void test_NEU_SendDocuments_Shipment()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        a.Status_Account__c = 'Active';
        insert a;

        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact', Email='oscar@neurored.com');
        insert contacto;
        Account sup = list_accounts[1];
        insert sup;

        Contact contacto2 = new Contact(AccountId = sup.Id, LastName='test contact2', Email='oscar2@neurored.com');
        insert contacto2;
        Shipment__c ship = new Shipment__c(Name='das',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Supplier_Account__c = sup.Id, Only_Warehouse_Service__c = true);
        insert ship;
        ContentVersion cvFile = new ContentVersion();//Es el fichero en sí mismo
        cvFile.ContentLocation = 'S'; //S==SALESFORCE
        Blob blobtest = Blob.valueOf('Test Data');
        cvFile.VersionData = blobtest;
        cvFile.Title = 'Test document';
        cvFile.PathOnClient = 'Test document';
        insert cvFile;

        Associated_Document__c documentos_asociados = new Associated_Document__c(Name='test associated document', Account__c=a.Id, Shipment__c=ship.Id);
        insert documentos_asociados;

        NEU_SendDocuments_Shipment ie = new NEU_SendDocuments_Shipment(new ApexPages.StandardController( ship ));
        List<NEU_SendDocuments_Shipment.documents_s> associated_documents_new = new List<NEU_SendDocuments_Shipment.documents_s>();
        associated_documents_new.add(new NEU_SendDocuments_Shipment.documents_s(true, 'pdf.pdf','pdf', 'reference', 'description', '', documentos_asociados.Id, cvFile.Id,0,'10'));

        ie.associated_documents = associated_documents_new;

        List<NEU_SendDocuments_Shipment.contacto_s> clientes_contacntos_new = new List<NEU_SendDocuments_Shipment.contacto_s>();
        clientes_contacntos_new.add(new NEU_SendDocuments_Shipment.contacto_s(contacto, true, 'oscar@neurored.com'));

        List<NEU_SendDocuments_Shipment.cuenta_s> clientes_seleccionados_new = new List<NEU_SendDocuments_Shipment.cuenta_s>();
        clientes_seleccionados_new.add(new NEU_SendDocuments_Shipment.cuenta_s(a, clientes_contacntos_new,'Customer'));
        ie.clientes_seleccionados = clientes_seleccionados_new;
        ie.send_email();
        ie.return_shipment();

        ie.optionTemplate = 1;
        ie.load_template();
        ie.add_link_to_body();
        ie.add_link_to_body2();

    }
    
}