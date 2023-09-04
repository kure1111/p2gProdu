public class exportXLSController {
    public Date startDate {get;set;}
    public Date endDate {get;set;}
    public List<Status_Datetime__c> obRep {get;set;}
    public List<Data> lstData {get;set;}
    public Data d {get;set;}
    public String servicio {get;set;}
    public List<List<Data>> lstDataQuery {get;set;}    
    public Boolean fnServ {get;set;}
    public Boolean airServ {get;set;}
    public Boolean seaServ {get;set;}
    public Boolean seaRServ {get;set;}
    
    public class Data{
        public String servicio {get;set;}
        public String folio {get;set;}
        public String serviceMode {get;set;}
        public String serviceType {get;set;}
        public String cliente {get;set;}
        public String venta {get;set;}
        public String plaza {get;set;}
        public String vendedor {get;set;}
        public String divIeq {get;set;}
        public Decimal ventaQ {get;set;}
        public Decimal costoQ {get;set;}
        public String divShip {get;set;}
        public Decimal ventaShip {get;set;}
        public Decimal costoShip {get;set;}
        public DateTime createDate {get;set;}
        public DateTime createDateShipment {get;set;}
        public DateTime quote1 {get;set;}
        public DateTime quote2 {get;set;}
        public DateTime quote3 {get;set;}
        public DateTime quote4 {get;set;}
        public DateTime quote5 {get;set;}      
        public DateTime shipPlan1 {get;set;}
        public DateTime shipPlan2 {get;set;}
        public DateTime shipPlan3 {get;set;}
        public DateTime shipPlan4 {get;set;}
        //public DateTime shipPlan5 {get;set;}
        public DateTime shipPlan6 {get;set;}
        public DateTime shipPlan7 {get;set;}
        public DateTime shipPlan8 {get;set;}
        public DateTime shipMon1 {get;set;}
        public DateTime shipMon2 {get;set;}
        public DateTime shipMon3 {get;set;}
        public DateTime shipMon4 {get;set;}
        public DateTime shipMon5 {get;set;}
        public DateTime shipMon6 {get;set;}
        public DateTime shipMon7 {get;set;}
        public DateTime shipMon8 {get;set;}
        public DateTime shipMon9 {get;set;}
        public DateTime shipMon10 {get;set;}
        public DateTime shipMon11 {get;set;}
        public DateTime shipMon12 {get;set;}
        public DateTime shipMon13 {get;set;}
        public DateTime shipMon14 {get;set;}
        public Boolean shipMon1Flag {get;set;}
        public Boolean shipMon2Flag {get;set;}
        public Boolean shipMon3Flag {get;set;}
        public DateTime shipAirImpo1 {get;set;}
        public DateTime shipAirImpo2 {get;set;}
        public DateTime shipAirImpo3 {get;set;}
        public DateTime shipAirImpo4 {get;set;}
        public DateTime shipAirImpo5 {get;set;}
        public DateTime shipAirImpo6 {get;set;}
        public DateTime shipAirImpo7 {get;set;}
        public DateTime shipAirImpo8 {get;set;}
        public DateTime shipAirImpo9 {get;set;}
        public DateTime shipAirExpo1 {get;set;}
        public DateTime shipAirExpo2 {get;set;}
        public DateTime shipAirExpo3 {get;set;}
        public DateTime shipAirExpo4 {get;set;}
        public DateTime shipAirExpo5 {get;set;}
        public DateTime shipAirExpo6 {get;set;}
        public DateTime shipAirExpo7 {get;set;}
        public DateTime shipAirExpo8 {get;set;}
        public DateTime shipAirExpo9 {get;set;}
        public DateTime shipSeaImpo1 {get;set;}
        public DateTime shipSeaImpo2 {get;set;}
        public DateTime shipSeaImpo3 {get;set;}
        public DateTime shipSeaImpo4 {get;set;}
        public DateTime shipSeaImpo5 {get;set;}
        public DateTime shipSeaImpo6 {get;set;}
        public DateTime shipSeaImpo7 {get;set;}
        public DateTime shipSeaImpo8 {get;set;}
        public DateTime shipSeaImpo9 {get;set;}
        public DateTime shipSeaImpo10 {get;set;}
        public DateTime shipSeaImpo11 {get;set;}
        public DateTime shipSeaImpo12 {get;set;}
        public DateTime shipSeaImpo13 {get;set;}
        public DateTime shipSeaImpo14 {get;set;}
        public DateTime shipSeaExpo1 {get;set;}
        public DateTime shipSeaExpo2 {get;set;}
        public DateTime shipSeaExpo3 {get;set;}
        public DateTime shipSeaExpo4 {get;set;}
        public DateTime shipSeaExpo5 {get;set;}
        public DateTime shipSeaExpo6 {get;set;}
        public DateTime shipSeaExpo7 {get;set;}
        public DateTime shipSeaExpo8 {get;set;}
        public DateTime shipSeaExpo9 {get;set;}
        public DateTime shipSeaExpo10 {get;set;}
        public DateTime shipSeaExpo11 {get;set;}
        public DateTime shipSeaExpo12 {get;set;}
        public DateTime shipSeaExpo13 {get;set;}
        public DateTime shipSeaExpo14 {get;set;}
        public DateTime shipSeaExpo15 {get;set;}
        public DateTime shipSeaExpo16 {get;set;}
        public DateTime shipSeaExpo17 {get;set;}
        public DateTime shipSeaExpo18 {get;set;}
        public DateTime shipSeaExpo19 {get;set;}
         public DateTime shipR1 {get;set;}
         public DateTime shipR2 {get;set;}
         public DateTime shipR3 {get;set;}
         public DateTime shipR4 {get;set;}
         public DateTime shipR5 {get;set;}
         public DateTime shipR6 {get;set;}
         public DateTime shipR7 {get;set;}
         public DateTime shipR8 {get;set;}
        
     
    }
    
    public exportXLSController(){
        startDate = Date.valueOf(ApexPages.currentPage().getParameters().get('startDate'));
        endDate  = Date.valueOf(ApexPages.currentPage().getParameters().get('endDate'));
        
        String servMode = ApexPages.currentPage().getParameters().get('service');
        if(servMode == 'M'){
            seaServ = true;
             seaRServ = false;
            airServ = false;
            fnServ = false;
        }else if(servMode == 'A'){
            seaServ = false;
            seaRServ = false;
            airServ = true;
            fnServ = false;
        }
         else if(servMode == 'R'){
             seaRServ = true;
            seaServ = false;
            airServ = false;
            fnServ = false;
        }
    else{
            seaServ = false;
            airServ = false;
            fnServ = true;
        seaRServ = false;
        }
        
        String service = servMode + '%';
        Time startTime = Time.newInstance(0, 0, 0, 0);
        Time endTime = Time.newInstance(23, 59, 59, 999);
        obRep = new List<Status_Datetime__c>();
        lstData = new List<Data>();
        obRep = [SELECT Customer_Quote__r.FolioResume__c, Customer_Quote__r.Name, IEQ_Status__c, IEQ_Modifield_Date__c, Status_Value__c, ModifieldDate__c, IEQ_Create_date__c, 
                 Customer_Quote__r.Account_for__r.Name, Customer_Quote__r.Account_for__r.Venta_Sap__c, Customer_Quote__r.Account_for__r.Workplace_AccOwner__c, Customer_Quote__r.Account_for__r.Owner.Name, Shipment__c,
                 Shipment__r.Total_Services_Sell_Amount__c, ShipFreightMode__c, ShipServiceMode__c, ShipServiceType__c, Shipment__r.Total_Services_Std_Buy_Amount__c,
                 Customer_Quote__r.Total_Services_Sell_Amount__c, Customer_Quote__r.Total_Services_Std_Buy_Amount__c, Customer_Quote__r.CurrencyIsoCode, Shipment__r.CurrencyIsoCode, Shipment__r.CreatedDate
                 FROM Status_Datetime__c 
                 WHERE Customer_Quote__c != null AND Customer_Quote__r.Name LIKE :service
                 AND (IEQ_Create_date__c >= :Datetime.newInstance(startDate, startTime) AND IEQ_Create_date__c <= :Datetime.newInstance(endDate, endTime))  
                 ORDER BY Customer_Quote__r.Name, createddate desc];
        
        system.debug('obRep ' + obRep);
        
        if(obRep.size()>0){
            d = new Data();
            
            d.folio = obRep[0].Customer_Quote__r.Name;
            d.servicio = obRep[0].Customer_Quote__r.FolioResume__c;
            d.cliente = obRep[0].Customer_Quote__r.Account_for__r.Name;
            d.venta = obRep[0].Customer_Quote__r.Account_for__r.Venta_Sap__c;
            d.plaza = obRep[0].Customer_Quote__r.Account_for__r.Workplace_AccOwner__c;
            d.vendedor = obRep[0].Customer_Quote__r.Account_for__r.Owner.Name;
            d.divIeq = obRep[0].Customer_Quote__r.CurrencyIsoCode;
            d.ventaQ = obRep[0].Customer_Quote__r.Total_Services_Sell_Amount__c;
            d.costoQ = obRep[0].Customer_Quote__r.Total_Services_Std_Buy_Amount__c;
            
            if(obRep[0].Shipment__c != null)
            {
                d.ventaShip = obRep[0].Shipment__r.Total_Services_Sell_Amount__c;
                d.costoShip = obRep[0].Shipment__r.Total_Services_Std_Buy_Amount__c;
            }
            
            d.createDate = obRep[0].IEQ_Create_date__c;
            for(Status_Datetime__c q : obRep)
            {            
                if(d.folio == q.Customer_Quote__r.Name)
                {
                    if(q.Shipment__r.CreatedDate != null){d.createDateShipment = q.Shipment__r.CreatedDate;}
                    d.divIeq = q.Customer_Quote__r.CurrencyIsoCode;
                    d.ventaQ = q.Customer_Quote__r.Total_Services_Sell_Amount__c;
                    d.costoQ = q.Customer_Quote__r.Total_Services_Std_Buy_Amount__c;
                    if(q.Shipment__c != null){d.divShip = q.Shipment__r.CurrencyIsoCode;d.ventaShip = q.Shipment__r.Total_Services_Sell_Amount__c;d.costoShip = q.Shipment__r.Total_Services_Std_Buy_Amount__c;}
                    if(q.ShipServiceMode__c != null && q.ShipServiceMode__c != ''){
                        d.serviceMode = q.ShipServiceMode__c;
                    }
                    if(q.ShipServiceMode__c != null && q.ShipServiceType__c != ''){
                        d.serviceType = q.ShipServiceType__c;
                    }
                    if(q.IEQ_Status__c == 'Quote being prepared'){
                        d.quote1 = q.IEQ_Modifield_Date__c;
                    }else if(q.IEQ_Status__c == 'Awaiting costs suppliers'){
                        d.quote2 = q.IEQ_Modifield_Date__c;
                    }else if(q.IEQ_Status__c == 'Sent awaiting response'){
                        d.quote3 = q.IEQ_Modifield_Date__c;
                    }else if(q.IEQ_Status__c == 'Approved as Succesful'){
                        d.quote4 = q.IEQ_Modifield_Date__c;
                    }else if(q.IEQ_Status__c == 'Quote Declined'){
                        d.quote5 = q.IEQ_Modifield_Date__c;
                    }
                    
                    if(q.Status_Value__c == 'Pending'){
                        d.shipPlan1 = q.ModifieldDate__c;                    
                    }else if(q.Status_Value__c == 'In Progress'){
                        d.shipPlan2 = q.ModifieldDate__c; 
                    }else if(q.Status_Value__c == 'Confirmed'){
                        d.shipPlan3 = q.ModifieldDate__c; 
                    }else if(q.Status_Value__c == 'Re assigned'){
                        d.shipPlan4 = q.ModifieldDate__c; 
                    }
                    else if(q.Status_Value__c == 'Closed'){
                        d.shipPlan8 = q.ModifieldDate__c; 
                    }
                    /*else if(q.Status_Value__c == 'False'){
d.shipPlan5 = q.ModifieldDate__c; 
}*/
                    else if(q.Status_Value__c == 'Cancel'){
                        d.shipPlan6 = q.ModifieldDate__c; 
                    }else if(q.Status_Value__c == 'Rejected PakControl'){
                        d.shipPlan7 = q.ModifieldDate__c; 
                    }
                    
                    if(q.Status_Value__c == 'Planned_M' || q.Status_Value__c == 'Planned'){
                        d.shipMon1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'In Progress' || q.Status_Value__c == 'In Progress_M'){
                        if(q.Status_Value__c == 'In Progress'){
                            d.shipMon1Flag = true;
                        }else{
                            d.shipMon1Flag = false;
                        }                    
                        d.shipMon2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Awaiting load_M' || q.Status_Value__c == 'Awaiting load'){
                        d.shipMon3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Loading_M' || q.Status_Value__c == 'Loading'){
                        d.shipMon4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Delivery on Route_M' || q.Status_Value__c == 'Delivery on Route'){
                        d.shipMon5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Awaiting Unload_M' || q.Status_Value__c == 'Awaiting Unload'){
                        d.shipMon6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Unloading_M' || q.Status_Value__c == 'Unloading'){
                        d.shipMon7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finished_M' || q.Status_Value__c == 'Finished'){
                        d.shipMon8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Failure_M' || q.Status_Value__c == 'Failure'){
                        d.shipMon9 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Incident_M' || q.Status_Value__c == 'Incident'){
                        d.shipMon10 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Cancel_M'){
                        /*if(q.Status_Value__c == 'Cancel'){
d.shipMon2Flag = true;
}else{
d.shipMon2Flag = false;
}*/  
                        d.shipMon2Flag = false;
                        d.shipMon11 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'In Warehouse_M' || q.Status_Value__c == 'In Warehouse'){
                        d.shipMon12 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'False_M' || q.Status_Value__c == 'False'){
                        if(q.Status_Value__c == 'False'){
                            d.shipMon3Flag = true;
                        }else{
                            d.shipMon3Flag = false;
                        }  
                        d.shipMon13 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Operative Failure_M' || q.Status_Value__c == 'Operative Failure'){
                        d.shipMon14 = q.ModifieldDate__c;
                    }
                    
                    if(q.Status_Value__c == 'Contact with Origin' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pickup and Delivery to Airline' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Documentation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Flight Confirmation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Layover' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Arrival Confirmation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pending with Customs Broker' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Final Delivery' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finish' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo9 = q.ModifieldDate__c;
                    }
                    
                    if(q.Status_Value__c == 'Contact with Origin' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pickup and Delivery to Airline' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Documentation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Flight Confirmation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Layover' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Arrival Confirmation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pending with Customs Broker' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Final Delivery' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finish' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo9 = q.ModifieldDate__c;
                    }
                    
                    if(q.Status_Value__c == 'Booking Request' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo14 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Booking Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pickup Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Documents' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETD' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA-15' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA-10' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA-7' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA-4' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo9 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Telex Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo10 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Customs Clearences' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo11 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Final Delivery' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo12 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finished' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo13 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Notificación al consignatario' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR1 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Liberación de embarque' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR2 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Confirmación de revalidación' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR3 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Recuperación de EIR' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR4 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Gastos Extras' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR5 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Finalizado' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR6 = q.ModifieldDate__c;
                    }
                      else if(q.Status_Value__c == 'Closed' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR7 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Gestión de Documentos' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR8 = q.ModifieldDate__c;
                    }
                    
                      
                    
                    if(q.Status_Value__c == 'Pending but Pre-Captured' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Schedules
                        d.shipSeaExpo1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Booking Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Planned for delivery - Not yet on route' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Pickup
                        d.shipSeaExpo3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Captured but not yet sent EDI' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Documents
                        d.shipSeaExpo4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pending - Missing Documents/Instructions' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Shipping Instructions / VGM
                        d.shipSeaExpo5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Submitted to Customs' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Cut Off
                        d.shipSeaExpo6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Cleared but Awaiting Vessel' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//BL Draft
                        d.shipSeaExpo7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Delivered' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//ETD
                        d.shipSeaExpo8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Cleared but Stopped' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Invoice
                        d.shipSeaExpo9 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Delivered to Depot' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//MBL/HBL
                        d.shipSeaExpo10 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Agent Notified' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Payment
                        d.shipSeaExpo11 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA -15' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo12 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA -10' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo13 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA -7' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo14 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA -4' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo15 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'In Progress' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//ETA
                        d.shipSeaExpo16 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'TLX Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo17 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Delivery On route' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo18 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finished' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo19 = q.ModifieldDate__c;
                    }
                       else if(q.Status_Value__c == 'Notificación al consignatario' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR1 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Liberación de embarque' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR2 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Confirmación de revalidación' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR3 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Recuperación de EIR' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR4 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Gastos Extras' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR5 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Finalizado' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR6 = q.ModifieldDate__c;
                    }
                     else if(q.Status_Value__c == 'Closed' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR7 = q.ModifieldDate__c;
                    }
                     else if(q.Status_Value__c == 'Gestión de Documentos' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR8 = q.ModifieldDate__c;
                    }
                    
                }
                else
                {
                    lstData.add(d);
                    d = new Data();
                    
                    d.folio = q.Customer_Quote__r.Name;
                    d.servicio = q.Customer_Quote__r.FolioResume__c;
                    if(q.ShipServiceMode__c != null && q.ShipServiceMode__c != ''){
                        d.serviceMode = q.ShipServiceMode__c;
                    }
                    if(q.ShipServiceMode__c != null && q.ShipServiceType__c != ''){
                        d.serviceType = q.ShipServiceType__c;
                    }
                    d.cliente = q.Customer_Quote__r.Account_for__r.Name;
                    d.venta = q.Customer_Quote__r.Account_for__r.Venta_Sap__c;
                    d.plaza = q.Customer_Quote__r.Account_for__r.Workplace_AccOwner__c;
                    d.vendedor = q.Customer_Quote__r.Account_for__r.Owner.Name;
                    d.divIeq = q.Customer_Quote__r.CurrencyIsoCode;
                    d.ventaQ = q.Customer_Quote__r.Total_Services_Sell_Amount__c;
                    d.costoQ = q.Customer_Quote__r.Total_Services_Std_Buy_Amount__c;
                    if(q.Shipment__c != null){d.divShip = q.Shipment__r.CurrencyIsoCode;d.ventaShip = q.Shipment__r.Total_Services_Sell_Amount__c;d.costoShip = q.Shipment__r.Total_Services_Std_Buy_Amount__c;}
                    d.createDate = q.IEQ_Create_date__c;
                    d.createDateShipment = q.Shipment__r.CreatedDate;
                    if(q.IEQ_Status__c == 'Quote being prepared'){
                        d.quote1 = q.IEQ_Modifield_Date__c;
                    }else if(q.IEQ_Status__c == 'Awaiting costs suppliers'){
                        d.quote2 = q.IEQ_Modifield_Date__c;
                    }else if(q.IEQ_Status__c == 'Sent awaiting response'){
                        d.quote3 = q.IEQ_Modifield_Date__c;
                    }else if(q.IEQ_Status__c == 'Approved as Succesful'){
                        d.quote4 = q.IEQ_Modifield_Date__c;
                    }else if(q.IEQ_Status__c == 'Quote Declined'){
                        d.quote5 = q.IEQ_Modifield_Date__c;
                    }
                    else if(q.Status_Value__c == 'Closed'){
                        d.shipPlan8 = q.ModifieldDate__c; 
                    }
                    
                    if(q.Status_Value__c == 'Pending'){
                        d.shipPlan1 = q.ModifieldDate__c;                    
                    }else if(q.Status_Value__c == 'In Progress'){
                        d.shipPlan2 = q.ModifieldDate__c; 
                    }else if(q.Status_Value__c == 'Confirmed'){
                        d.shipPlan3 = q.ModifieldDate__c; 
                    }else if(q.Status_Value__c == 'Re assigned'){
                        d.shipPlan4 = q.ModifieldDate__c; 
                    }/*else if(q.Status_Value__c == 'False'){
d.shipPlan5 = q.ModifieldDate__c; 
}*/else if(q.Status_Value__c == 'Cancel'){
    d.shipPlan6 = q.ModifieldDate__c; 
}else if(q.Status_Value__c == 'Rejected PakControl'){
    d.shipPlan7 = q.ModifieldDate__c; 
}
                    
                    if(q.Status_Value__c == 'Planned_M' || q.Status_Value__c == 'Planned'){
                        d.shipMon1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'In Progress' || q.Status_Value__c == 'In Progress_M'){
                        if(q.Status_Value__c == 'In Progress'){
                            d.shipMon1Flag = true;
                        }else{
                            d.shipMon1Flag = false;
                        }                    
                        d.shipMon2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Awaiting load_M' || q.Status_Value__c == 'Awaiting load'){
                        d.shipMon3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Loading_M' || q.Status_Value__c == 'Loading'){
                        d.shipMon4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Delivery on Route_M' || q.Status_Value__c == 'Delivery on Route'){
                        d.shipMon5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Awaiting Unload_M' || q.Status_Value__c == 'Awaiting Unload'){
                        d.shipMon6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Unloading_M' || q.Status_Value__c == 'Unloading'){
                        d.shipMon7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finished_M' || q.Status_Value__c == 'Finished'){
                        d.shipMon8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Failure_M' || q.Status_Value__c == 'Failure'){
                        d.shipMon9 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Incident_M' || q.Status_Value__c == 'Incident'){
                        d.shipMon10 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Cancel_M'){
                        /*if(q.Status_Value__c == 'Cancel'){
d.shipMon2Flag = true;
}else{
d.shipMon2Flag = false;
}*/ 
                        d.shipMon2Flag = false;
                        d.shipMon11 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'In Warehouse_M'){
                        d.shipMon12 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'False_M' || q.Status_Value__c == 'False'){
                        if(q.Status_Value__c == 'False'){
                            d.shipMon3Flag = true;
                        }else{
                            d.shipMon3Flag = false;
                        }  
                        d.shipMon13 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Operative Failure_M'){
                        d.shipMon14 = q.ModifieldDate__c;
                    } 
                    
                    if(q.Status_Value__c == 'Contact with Origin' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pickup and Delivery to Airline' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Documentation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Flight Confirmation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Layover' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Arrival Confirmation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pending with Customs Broker' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Final Delivery' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finish' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipAirImpo9 = q.ModifieldDate__c;
                    }
                    
                    if(q.Status_Value__c == 'Contact with Origin' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pickup and Delivery to Airline' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Documentation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Flight Confirmation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Layover' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Arrival Confirmation' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pending with Customs Broker' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Final Delivery' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finish' && q.ShipFreightMode__c == 'Air' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipAirExpo9 = q.ModifieldDate__c;
                    }
                    
                    if(q.Status_Value__c == 'Booking Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pickup Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Documents' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETD' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA-15' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA-10' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA-7' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA-4' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo9 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Telex Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo10 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Customs Clearences' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo11 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Final Delivery' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo12 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finished' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo13 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Booking Request' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipSeaImpo14 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Notificación al consignatario' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR1 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Liberación de embarque' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR2 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Confirmación de revalidación' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR3 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Recuperación de EIR' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR4 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Gastos Extras' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR5 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Finalizado' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR6 = q.ModifieldDate__c;
                    }
                     else if(q.Status_Value__c == 'Closed' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR7 = q.ModifieldDate__c;
                    }
                      else if(q.Status_Value__c == 'Gestión de Documentos' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'IMPORT'){
                        d.shipR8 = q.ModifieldDate__c;
                    }
                    
                    if(q.Status_Value__c == 'Pending but Pre-Captured' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Schedules
                        d.shipSeaExpo1 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Booking Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo2 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Planned for delivery - Not yet on route' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Pickup
                        d.shipSeaExpo3 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Captured but not yet sent EDI' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Documents
                        d.shipSeaExpo4 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Pending - Missing Documents/Instructions' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Shipping Instructions / VGM
                        d.shipSeaExpo5 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Submitted to Customs' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Cut Off
                        d.shipSeaExpo6 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Cleared but Awaiting Vessel' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//BL Draft
                        d.shipSeaExpo7 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Delivered' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//ETD
                        d.shipSeaExpo8 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Cleared but Stopped' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Invoice
                        d.shipSeaExpo9 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Delivered to Depot' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//MBL/HBL
                        d.shipSeaExpo10 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Agent Notified' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//Payment
                        d.shipSeaExpo11 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA -15' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo12 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA -10' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo13 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA -7' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo14 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'ETA -4' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo15 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'In Progress' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){//ETA
                        d.shipSeaExpo16 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'TLX Confirmation' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo17 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Delivery On route' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo18 = q.ModifieldDate__c;
                    }else if(q.Status_Value__c == 'Finished' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipSeaExpo19 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Notificación al consignatario' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR1 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Liberación de embarque' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR2 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Confirmación de revalidación' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR3 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Recuperación de EIR' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR4 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Gastos Extras' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR5 = q.ModifieldDate__c;
                    }
                    else if(q.Status_Value__c == 'Finalizado' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR6 = q.ModifieldDate__c;
                    }
                     else if(q.Status_Value__c == 'Closed' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR7 = q.ModifieldDate__c;
                    }
                      else if(q.Status_Value__c == 'Gestión de Documentos' && q.ShipFreightMode__c == 'Sea' && q.ShipServiceMode__c == 'EXPORT'){
                        d.shipR8 = q.ModifieldDate__c;
                    }
                }
            }
            lstData.add(d);
            System.debug('query mod: ' + lstData);
            lstDataQuery = new List<List<Data>>();
            List<Data> temp = new List<Data>();
            
            for(Data data : lstData){
                if(temp.size() < 1000){
                    temp.add(data);
                }else{
                    lstDataQuery.add(temp);
                    temp = new List<Data>();
                    temp.add(data);
                }
            }
            lstDataQuery.add(temp);
        } 
    }
    
    public void tstMethod(){
        String tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
    }
}