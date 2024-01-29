public class PAK_ShipmentBLOQ {
    public String IdShip {get;set;}
    public String ImportExportId {get;set;}
    public Shipment__c Shipment {get;set;}
    public Boolean Bandera {get;set;}
    public list<Shipment_Fee_Line__c> FeeLines {get;set;}
    public list<Shipment_Line__c> CargoLines {get;set;}
    public list<Invoice__c> Invoices {get;set;}
    public list<Shipment_Disbursement__c> Disbursements {get;set;}
    public list<Disbursement_Line__c> DisLines {get;set;}
    public list<Invoice_Line__c> InvoiceLines {get;set;}
    public PAK_ShipmentBLOQ(Apexpages.StandardController Controller){
        IdShip ='';
        Shipment = new Shipment__c();
        system.debug('IdShip -----> '+ IdShip);
        if(!Test.isRunningTest()){IdShip = Controller.getId();Shipment = [Select Id,Name,Account_for__c,Operation_Executive__c                                                                                                From Shipment__c Where Id=:IdShip limit 1];}
        
        List<Shipment_Consolidation_Data__c> shipment_consolidation_data = [select Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name from Shipment_Consolidation_Data__c where Shipment__c =: IdShip];
        if(shipment_consolidation_data.size() > 0)
        {
            ImportExportId = shipment_consolidation_data[0].Import_Export_Quote__c;
        }
        system.debug('Shipment -----> '+ Shipment);
        CargoLines = [Select Id,Name,Item_Name__r.Name,Units_Shipped__c,Unit_of_measure__c,Shipping_Weight_Kg__c,Shipping_Volume_m3__c,Delivered__c,Container_Type__c	
                      From Shipment_Line__c Where Shipment__c=:IdShip];
       	
        FeeLines = [Select Id,Name,Service_Rate_Name__r.Name,Carrier__c,SAP_Service_Type__c,SAP_Service_Type_Buy__c,Container_Type__c,Units__c,Service_Std_Profit__c,Shipment_Sell_Net_Price__c,Std_Buy_Amount__c,Sell_Amount__c,SAP__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c
                    From Shipment_Fee_Line__c Where Shipment__c=:IdShip];
        
        list<Shipment_Fee_Line__c> Feess = [Select Id,Name,Service_Rate_Name__r.Name,Service_Rate_Category__c,Rate_Type__c,Container_Type__c,Units__c,Service_Std_Profit__c,Std_Buy_Amount__c,Shipment_Sell_Net_Price__c,Sell_Amount__c,
                                            Block__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c
                    From Shipment_Fee_Line__c Where Shipment__c=:IdShip and SAP__c=false];
                                                       
        if(Feess.size() > 0){Bandera=true;}
        
        Disbursements = [Select Id,Name,Disbursment_Concept__c,Account__r.Name,Invoice_Ref__c,Payment_Date__c,Total_Incl_VAT__c From Shipment_Disbursement__c Where Shipment__c=:IdShip];
        
        Invoices = [Select Id,Name,Date_of_Invoice__c,Invoice_Concept__c,Payable_Before__c,Account__r.Name,Invoiced__c,Invoice_Status__c,Total_Excl_VAT__c From Invoice__c Where Shipment__c=:IdShip];
        
        DisLines = [Select Id,Name,Disbursement__r.Name,Concept__c,Units__c,Unit_Price__c,Amount__c,VAT__c,Total_VAT__c,Total_Incl_VAT__c From Disbursement_Line__c Where Shipment__c=:IdShip];
        
        InvoiceLines = [Select Id,Name,Invoice__r.Name,Concept__c,Units__c,Unit_Price__c,Amount__c,VAT__c,Total_VAT__c,Total_Incl_VAT__c From Invoice_Line__c Where Shipment__c=:IdShip];
    }
    public pagereference Desbloquear(){
        try{
            for(Shipment_Fee_Line__c fee : FeeLines){if(fee.SAP__c){fee.SAP__c = false;fee.Block__c = false;}else{fee.SAP__c = true;fee.Block__c = true;}}update FeeLines;return null;
        }catch(exception ex){
            system.debug(ex.getMessage());
        }
        return null;
    }

}