/**
 * Created by jamarin on 11/12/2018.
 */

public with sharing class NEU_create_shipmet_pallets {
	
    //variables
    //public Customer_Quote__c record;
    public List<pallet_warehouse__c> palletShipments {get;set;}
    public pallet_warehouse__c newPallet {get;set;}

    //init page values
    public NEU_create_shipmet_pallets(ApexPages.StandardController stdController)
    {
        try
        {
       		 //record = [select Id, Name from Customer_Quote__c where id =: stdController.getRecord().id limit 1];
             palletShipments = [select Id, Name, Height_cm__c, lenght_cm__c, width_cm__c, Volume_m3__c from pallet_warehouse__c order by createdDate desc Limit 10];
            
        }
        catch(Exception ee){System.debug(ee);}
        
        newPallet = new pallet_warehouse__c();
        //newPallet.Import_export__c = record.Id;

    }
    
    //create new lines
    public void createNewPallet(){
        try
        {
            insert newPallet;
            //cleanning new pallet && refresh pallets
            newPallet = new pallet_warehouse__c();
            palletShipments = [select Id, Name, Height_cm__c, lenght_cm__c, width_cm__c, Volume_m3__c from pallet_warehouse__c order by createdDate desc Limit 10];

        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating Pallet: ' + e));
        }
        
    }
}