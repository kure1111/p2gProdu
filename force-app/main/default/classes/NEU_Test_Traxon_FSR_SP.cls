@isTest
public class NEU_Test_Traxon_FSR_SP {
	static testMethod void NEU_Traxon_FSR_SP()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account b = list_accounts[0];
        insert b;
        Account a = list_accounts[1];
        a.Airline_Prefix__c='000';
        a.PIMA_Address__c='PIMA';
        insert a;
        Shipment_Program__c ship = new Shipment_Program__c(Freight_Mode__c='Sea');
        ship.MAWB_Number__c='000-0123456';
        insert ship;
        NEU_Traxon_FSR_SP t=new NEU_Traxon_FSR_SP(new ApexPages.StandardController(NEU_Utils.populate(NEU_Traxon_FSR_SP.usedFields,'Shipment_Program__c',ship.Id)));
        //t.sendToTraxon();
        //t.cancel();
    }
}