public class PK2_FI_TABLE_STATES {
    public static Transient list<Customer_Quote__c> lsStatesFI {get;set;}
    public Date Hoy {get;set;}
    public Time Hora {get;set;}
    
    public PK2_FI_TABLE_STATES(){
        Hoy = Date.today();
        Hora = Datetime.now().time().addHours(3);
        Datetime Mayo1 = Datetime.valueOf('2018-05-01 00:00:00');
        lsStatesFI = [Select Id,
                      Name,
                      Freight_Mode__c,
                      Service_Mode__c,
                      Mode__c,
                      Service_Type__c,
                      Site_of_Load__c,
                      Site_of_Discharge__c,
                      Route__c,
                      ETD__c,
                      Awaiting_load_time__c,
                      CreatedDate,
                      Account_for__r.Name,
                      Account_for__r.Venta_Sap__c,
                      CreatedBy.Name,
                      Last_Shipment__c,
                      Last_Shipment__r.Operation_Executive__c,
                      Last_Shipment__r.Shipment_Status__c,
                      Last_Shipment__r.Shipment_Status_Plann__c,
                      Last_Shipment__r.Shipment_Status_Mon__c,
                      Last_Shipment__r.VERIFY_PAK_CONTROL__c,
                      Pricing_Executive__r.Name,(Select Container_Type__r.Name From Import_Export_Items_Lines__r),
                      Operations_Exec__r.Name,Quotation_Status__c, Last_Shipment__r.Pago_Contado_SAP__c
                      From Customer_Quote__c 
                      Where Account_for__r.Customer_Id__c !='CMTY3748' 
                      and Name LIKE 'FI-%' 
                      and Quotation_Status__c IN ('Shipped', 'Approved as Succesful') and Last_Shipment__r.Shipment_Status_Plann__c !='Confirmed' 
                      and Last_Shipment__r.Shipment_Status_Plann__c !='False' and Last_Shipment__r.Shipment_Status_Plann__c !='Cancel' and CreatedDate>:Mayo1 Order by Quotation_Status__c,ETD__c asc];
    }
}