public class PK2_TABLE_MONITOREO {
    public list<Customer_Quote__c> lsMonitoreo {get;set;}
    
    public PK2_TABLE_MONITOREO(){
        Date Lunes = Date.today().toStartOfWeek();
        Date Domingo = Date.today().toStartOfWeek()+6;
        
        lsMonitoreo = [Select Id,
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
                       (Select Container_Type__r.Name From Import_Export_Items_Lines__r)
                       From Customer_Quote__c Where Name LIKE 'FN-%' and Quotation_Status__c IN ('Shipped') and Last_Shipment__r.Shipment_Status_Plann__c ='Confirmed' and CreatedDate >=:Lunes and CreatedDate <=:Domingo  Order by Quotation_Status__c,ETD__c asc];
    }
}