/**
 * Created by jamarin on 19/12/2018.
 */
@isTest
private class NEU_test_create_shipment_pallets {

    public static testMethod void NEU_create_shipmet_pallets()
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,Transporter,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true);
        insert importexportquote;

        NEU_create_shipmet_pallets uda = new NEU_create_shipmet_pallets(new ApexPages.StandardController( importexportquote ));

        pallet_warehouse__c pallet = new pallet_warehouse__c(Name = 'Test Pallet', lenght_cm__c = 60, width_cm__c = 60, Import_export__c = importexportquote.Id);
        insert pallet;

        uda.newPallet.Name = 'Test 2';
        uda.newPallet.width_cm__c = 60;
        uda.newPallet.lenght_cm__c = 50;

        uda.createNewPallet();
    }
}