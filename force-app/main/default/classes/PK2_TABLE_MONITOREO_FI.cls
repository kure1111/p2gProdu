public class PK2_TABLE_MONITOREO_FI {
    public static Transient list<Customer_Quote__c> lsMonitoreoFI {get;set;}
    Datetime Mayo1 = Datetime.valueOf('2018-05-01 00:00:00');
    
    public PK2_TABLE_MONITOREO_FI(){
        lsMonitoreoFI = [Select Id,
                         Name,
                         Mode__c,
                         Route__r.Name,
                         Container_Type__r.Name,
                         Account_for__r.Name,
                         Last_Shipment__r.VERIFY_PAK_CONTROL__c,
                         Last_Shipment__r.Name,
                         Last_Shipment__c,
                         Last_Shipment__r.Shipment_Status_Plann__c,
                         Last_Shipment__r.Shipment_Status_Mon__c,
                         Last_Shipment__r.Equip_Placed__c,
                         Last_Shipment__r.Equip_Loaded__c,
                         Last_Shipment__r.Departure_Time__c,
                         Last_Shipment__r.ATD__c,
                         Last_Shipment__r.Equip_Reserved__c,
                         Last_Shipment__r.Equip_Solicited__c,
                         Last_Shipment__r.Equip_Unloaded__c,
                         Last_Shipment__r.National_Operator__r.Name,
                         Last_Shipment__r.ATA__c,
                         Last_Shipment__r.Vehicle__r.Name,
                         Last_Shipment__r.Special_Notes__c,
                         Last_Shipment__r.Operation_Executive__r.Name,
                         (Select Container_Type__r.Name From Import_Export_Items_Lines__r)
                         From Customer_Quote__c Where Name LIKE 'FI-%' and Quotation_Status__c IN ('Shipped') and Last_Shipment__r.Shipment_Status_Plann__c ='Confirmed' and
                         Last_Shipment__r.Shipment_Status_Mon__c != 'Finished' and CreatedDate>:Mayo1 Order by Quotation_Status__c,ETD__c asc];
    }
}