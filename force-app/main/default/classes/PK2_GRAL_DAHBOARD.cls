public class PK2_GRAL_DAHBOARD {
    public list<Customer_Quote__c> ls {get;set;}
    public list<Customer_Quote__c> lsStates {get;set;}
    public static Transient list<Customer_Quote__c> lsStatesFI {get;set;}
    public list<Customer_Quote__c> lsMonitoreo {get;set;}
    public list<Customer_Quote__History> lsQuoteCanel {get;set;}
    public list<Customer_Quote__History> lsQuoteCanelShConfirmed {get;set;}
    public static Transient list<Customer_Quote__c> lsMonitoreoFI {get;set;}
    public list<Shipment__c> lsShipments {get;set;}
    public list<Shipment__c> CrearDisbursements {get;set;}
    public list<Customer_Quote__c> lsClient {get;set;}
    public String Direccion {get;set;}
    public Date Hoy {get;set;}
    public Time Hora {get;set;}
    public list<Task> lsTask {get;set;}
    public PK2_GRAL_DAHBOARD(){
        Id UserId = UserInfo.getUserId();
       	lsTask = new list<Task>();
        lsTask = [Select Id,ActivityDate,Status,Subject,What.Name,Who.Name From Task Where CreatedById=:UserId and Status !='Completed' and Subject=:'Meeting'];
        map<String,String> mapQuote = new map<String,String>();
		Hoy = Date.today();
        Hora = Datetime.now().time().addHours(3);
        User usr = [Select Id,State_of_Load__c,State_of_Load_2__c,State_of_Load_3__c,State_of_Load_4__c,State_of_Load_5__c,Workplace__c From User Where Id=:UserInfo.getUserId() limit 1];
        Date Lunes = Date.today().toStartOfWeek();
        Date Domingo = Date.today().toStartOfWeek()+6;
        Datetime Mayo1 = Datetime.valueOf('2018-05-01 00:00:00');
        Direccion = 'monterrey, nuevo leon, mexico';
        lsClient = [Select Id,
              Name,
              Freight_Mode__c,
              Service_Mode__c,
              Mode__c,
              Service_Type__c,
              Site_of_Load__c,
              Site_of_Discharge__c,
              Route__c,
              Customer_Reference__c,
              CreatedDate,
              Awaiting_load_time__c,
              Account_for__r.Name,
              CreatedBy.Name,
              Last_Shipment__c,
              Last_Shipment__r.Operation_Executive__c,
              Last_Shipment__r.Shipment_Status__c,
              Last_Shipment__r.Shipment_Status_Plann__c,
              Last_Shipment__r.Shipment_Status_Mon__c,
              Pricing_Executive__r.Name,(Select Container_Type__r.Name From Import_Export_Items_Lines__r),
              Operations_Exec__r.Name,Quotation_Status__c From Customer_Quote__c Where Freight_Mode__c = 'Road' and Service_Mode__c = 'NATIONAL' and Last_Shipment__r.Shipment_Status_Mon__c !='Finished'
              and Service_Type__c != 'PAQUETERIA' and Account_for__r.Customer_Id__c = 'CMTY3748' and  Service_Type__c != 'TARIMAS' and Name LIKE 'FN-%' and Quotation_Status__c IN ('Shipped', 'Approved as Succesful') Order by Quotation_Status__c desc];
        
        ls = [Select Id,
              Name,
              Freight_Mode__c,
              Service_Mode__c,
              Mode__c,
              Service_Type__c,
              Site_of_Load__c,
              Site_of_Discharge__c,
              Route__c,
              CreatedDate,
              Account_for__r.Name,
              CreatedBy.Name,
              Last_Shipment__c,
              Last_Shipment__r.Operation_Executive__c,
              Last_Shipment__r.Shipment_Status__c,
              Last_Shipment__r.Shipment_Status_Plann__c,
              Last_Shipment__r.Shipment_Status_Mon__c,
              Pricing_Executive__r.Name,(Select Container_Type__r.Name From Import_Export_Items_Lines__r),
              Operations_Exec__r.Name,Quotation_Status__c From Customer_Quote__c Where Freight_Mode__c = 'Road' and Service_Mode__c = 'NATIONAL' and Last_Shipment__r.Shipment_Status_Plann__c !='Confirmed' and Last_Shipment__r.Shipment_Status_Plann__c !='False' and Last_Shipment__r.Shipment_Status_Plann__c !='Cancel'
              and Service_Type__c != 'PAQUETERIA' and  Service_Type__c != 'TARIMAS' and Name LIKE 'FN-%' and Quotation_Status__c IN ('Shipped', 'Approved as Succesful') Order by Quotation_Status__c desc];
        
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
              Operations_Exec__r.Name,Quotation_Status__c From Customer_Quote__c Where Account_for__r.Customer_Id__c !='CMTY3748'  and Freight_Mode__c = 'Road' and Service_Mode__c = 'NATIONAL' 
              and Name LIKE 'FN-%' and Quotation_Status__c IN ('Shipped', 'Approved as Succesful') and Last_Shipment__r.Shipment_Status_Plann__c !='Confirmed' and Last_Shipment__r.Shipment_Status_Plann__c !='False' and Last_Shipment__r.Shipment_Status_Plann__c !='Cancel'
              and (Last_Shipment__r.Operation_Executive__r.Workplace__c =:usr.Workplace__c or State_of_Load__r.Name =: usr.State_of_Load__c or State_of_Load__r.Name =: usr.State_of_Load_2__c or State_of_Load__r.Name =: usr.State_of_Load_3__c or State_of_Load__r.Name =: usr.State_of_Load_4__c or State_of_Load__r.Name =: usr.State_of_Load_5__c) Order by Quotation_Status__c,ETD__c asc];
        
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
              Operations_Exec__r.Name,Quotation_Status__c From Customer_Quote__c Where Account_for__r.Customer_Id__c !='CMTY3748' and Name LIKE 'FI-%' 
              and Quotation_Status__c IN ('Shipped', 'Approved as Succesful') and Last_Shipment__r.Shipment_Status_Plann__c !='Confirmed' 
              and Last_Shipment__r.Shipment_Status_Plann__c !='False' and Last_Shipment__r.Shipment_Status_Plann__c !='Cancel' and CreatedDate>:Mayo1 Order by Quotation_Status__c,ETD__c asc];
        
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
        
        CrearDisbursements = new list<Shipment__c>();
        map<String,String> mapDis = new map<String,String>();
        for(Shipment_Disbursement__c Dis: [Select Id,Shipment__c From Shipment_Disbursement__c]){
        	mapDis.put(Dis.Shipment__c, Dis.Id);    
        }
        for(Shipment__c SHIP:[Select Id,Name,SolicitudCompra__c,OrdenVenta__c, Account_for__r.Owner.Name, Operation_Executive__r.Workplace__c, Operation_Executive__r.Name From Shipment__c Where SolicitudCompra__c != '']){
            if(!mapDis.containsKey(SHIP.Id)){
                CrearDisbursements.add(SHIP);
            }    
        } 
    }
    
    public pagereference getHistoria(){
        Datetime Treinta= Datetime.now().date().addDays(-30);
        lsQuoteCanel = new list<Customer_Quote__History>();
        lsQuoteCanelShConfirmed = new list<Customer_Quote__History>();
        /*lsQuoteCanel = [Select OldValue,NewValue,Parent.Id,Parent.Name,Field,CreatedDate,CreatedById
                        From Customer_Quote__History Where Field='Quotation_Status__c' and Parent.Id=:DATA.Import_Export_Quote__c Order by Parent.Name,CreatedDate desc];*/
        list<String> lsShipment = new list<String>();
        for(Shipment_Consolidation_Data__c DATA: [Select Import_Export_Quote__c From Shipment_Consolidation_Data__c Where Import_Export_Quote__r.Quotation_Status__c IN('Quote Declined') and Shipment__r.Shipment_Status_Plann__c IN('Confirmed') and CreatedDate<:Treinta]){   
            for(Customer_Quote__History Historia: [Select OldValue,NewValue,Parent.Id,Parent.Name,Field,CreatedDate,CreatedById From Customer_Quote__History Where Field='Quotation_Status__c' and Parent.Id=:DATA.Import_Export_Quote__c Order by Parent.Name,CreatedDate desc]){
                if(Historia.NewValue == 'Quote Declined'){lsQuoteCanelShConfirmed.add(Historia);} 
            }
        }
        return null;
    }
}