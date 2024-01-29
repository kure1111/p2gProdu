public class PK2_FN_TABLE_STATES {
    public List<Customer_Quote__c> lsStates {get;set;}
    public Date Hoy {get;set;}
    public Time Hora {get;set;}
    public DateTime FromDate {get;set;}
    
    public PK2_FN_TABLE_STATES(){
        FromDate = DateTime.now().addMonths(-1);
        Hoy = Date.today();
        Hora = Datetime.now().time().addHours(3);
        User usr = [Select Id,State_of_Load__c,State_of_Load_2__c,State_of_Load_3__c,State_of_Load_4__c,State_of_Load_5__c,Workplace__c,Zone_of_Load__c From User Where Id=:UserInfo.getUserId() limit 1];
        lsStates = [Select Id,
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
                    Where Account_for__r.Customer_Id__c !='CMTY3748' AND CreatedDate >= :FromDate
                    and Freight_Mode__c = 'Road' and Service_Mode__c = 'NATIONAL' 
                    and Name LIKE 'FN-%' and Quotation_Status__c IN ('Shipped', 'Approved as Succesful') and Last_Shipment__r.Shipment_Status_Plann__c !='Confirmed' and Last_Shipment__r.Shipment_Status_Plann__c !='False' and Last_Shipment__r.Shipment_Status_Plann__c !='Cancel' and Last_Shipment__r.Shipment_Status_Plann__c !='Closed'
                    /*and (Last_Shipment__r.Operation_Executive__r.Workplace__c =:usr.Workplace__c or State_of_Load__r.Zone__c =:usr.Zone_of_Load__c)*/ Order by Quotation_Status__c,ETD__c asc LIMIT 1000];
    }
}