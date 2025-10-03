@isTest
public class Trigger_AssociatedDocument_Test {
	@isTest(SeeAllData=true)
    //Trigger afectados
    //NEU_OM_UpdateFoAssociated_Document
    //PAK_Docs_tgr
    public static void AssociatedDocument_Test(){
        Associated_Document__c updateAssociatedDocument = [SELECT Name, Account__c,Import_Export_Quote__c,Shipment__c, Account__r.Account_Executive_User__c, 
                                                           Account__r.Account_External_Follower_User__c, Account__r.OwnerId, CreatedById, LastModifiedById, 
                                                           Claim__r.CreatedById, Import_Export_Quote__r.CreatedById, SCM_Contract__r.CreatedById,Shipment__r.CreatedById, 
                                                           Shipment_Consolidation_Data__r.CreatedById, Shipment_Disbursement__r.CreatedById, Shopping_Cart__r.CreatedById,
                                                           Supplier_Quote__r.CreatedById, Supplier_Request_RFP__r.CreatedById, Supply_Project__r.CreatedById, 
                                                           Shipment_Packaging_Consolidation_Data__r.CreatedById FROM Associated_Document__c 
                                                           WHERE Import_Export_Quote__c !=null AND Shipment__c !=null LIMIT 1];
        SCM_Contract__c scm_contract = new SCM_Contract__c( Name='SCM contract name', Account_for__c = updateAssociatedDocument.Account__c);
        insert scm_contract;
        Account carrier_test = [SELECT Id, Name FROM Account WHERE Record_Type_Name__c = 'Supply Chain Partner' LIMIT 1];
        Shipment_Consolidation_Data__c shipconsodata = new Shipment_Consolidation_Data__c(Name= ' test shipconsodata', Shipment__c = updateAssociatedDocument.Shipment__c);
        insert shipconsodata;
        Claim__c claim = new Claim__c(Customer__c = updateAssociatedDocument.Account__c);
        insert claim;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=updateAssociatedDocument.Account__c);
        insert shop;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = updateAssociatedDocument.Account__c);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id, Supplier__c=carrier_test.Id);
        insert supquote;
        Supplier_Request_RFP__c suprequest = new Supplier_Request_RFP__c(Supply_Project__c = supplyproject.Id, Supplier__c=carrier_test.Id);
        insert suprequest;
        Transport_Packaging_Data__c transporpack = new Transport_Packaging_Data__c(Name='transporpack', Shipment__c =updateAssociatedDocument.Shipment__c);
        insert transporpack;
        
        Associated_Document__c newAssociatedDocument = new Associated_Document__c(Name='test',Account__c= updateAssociatedDocument.Account__c,
                                                                                  Import_Export_Quote__c=updateAssociatedDocument.Import_Export_Quote__c, 
                                                                                  Shipment__c=updateAssociatedDocument.Shipment__c,Claim__c=claim.Id, 
                                                                                  SCM_Contract__c=scm_contract.Id, Shipment_Consolidation_Data__c=shipconsodata.Id,
                                                                                  Shopping_Cart__c=shop.Id, Supplier_Quote__c=supquote.Id,
                                                                                  Supplier_Request_RFP__c=suprequest.Id , Supply_Project__c=supplyproject.Id, 
                                                                                  Shipment_Packaging_Consolidation_Data__c=  transporpack.Id);
        insert newAssociatedDocument;
        updateAssociatedDocument.Name = 'test2';
        update updateAssociatedDocument;
     }
}