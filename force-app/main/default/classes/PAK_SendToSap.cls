public class PAK_SendToSap {
    
    public static String TipoShipment; 
    private static boolean Bandera {get;set;}
    private static String Estatus {get;set;} 
    
    public static void sendShipmentTrigger(set<String> setShipmentIds, set<String> setOrderIds){
        Bandera = false;
        Boolean frontera = false;
        List<OrderItem> lstLines = new List<OrderItem>();
        list<Shipment__c> listaShipmentUpdate = new list<Shipment__c>(); 
        
        
        try{
            Bandera = false;
            list<Shipment__c> listaShipment = [Select Id,Name,Order__c, Account_for__r.Venta_Sap__c, Shipment_Status_Plann__c, Shipment_Status__c,
                                               Freight_Mode__c, Service_Mode__c, Status_Shipment__c, Ocean_Shipment_Status__c, Air_Shipment_Status__c,RecordTypeId,
                                               Date_Receive_from_SAP__c,AUTORIZAR_GASTO_EXTRA__c,NotificarGastoExtra__c,VerificacionPak__c,Shipment_Status_Mon__c,
                                               Routing_Operation_Status__c
                                               From Shipment__c 
                                               Where Id in : setShipmentIds];
            
            map<string,Order> mapOrders = new map<string,Order>([
                SELECT Id, DefaultPbe__c, 
                DefaultProduct__c,Shipment__c FROM Order WHERE Id in : setOrderIds]);
            
            list<Shipment_Fee_Line__c> listaShipLines = new list<Shipment_Fee_Line__c>();
            
            map<string,list<Shipment_Fee_Line__c>> mapLinesShipment = new map<string,list<Shipment_Fee_Line__c>>();
            
            for(Shipment_Fee_Line__c sfl :  [Select Id,Name,Units__c,CurrencyIsoCode,Shipment_Sell_Price__c,Shipment_Sell_Net_Price__c,
                                             Shipment_Buy_Price__c,SAP__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.SAP_Service_Type__r.Group__c,
                                             Service_Rate_Name__r.SAP_Service_Type__r.Name, Service_Rate_Name__r.SAP_Service_Type__r.VAT__c, Currency_Buy_Price__c, Conversion_Rate_to_Buy_Currency_Header__c,
                                             Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c,Shipment__c,Record_Locked__c
                                             From Shipment_Fee_Line__c 
                                             Where Shipment__c in : setShipmentIds /*and SAP__c=false*/])
            {
                if(!mapLinesShipment.containsKey(sfl.Shipment__c)){
                    listaShipLines = new list<Shipment_Fee_Line__c>();
                    listaShipLines.add(sfl);
                    mapLinesShipment.put(sfl.Shipment__c,listaShipLines);	
                }                               
                else{
                    mapLinesShipment.get(sfl.Shipment__c).add(sfl);	
                }
            }
            
            for(Shipment__c s : listaShipment){
                
                TipoShipment = S.Name.substringBetween('-','-');
                Estatus = '';
                ValidarEstatus(S); 
                
                if(S.Account_for__r.Venta_Sap__c == null || S.Account_for__r.Venta_Sap__c == ''){continue;}
                
                System.debug('Estatus ruben'+ Estatus);
                system.debug('Bandera ruben'+ Bandera);	
                if(/*test.isRunningTest() &&*/ Bandera){continue;}
                
                String Body = '';
                if(!mapLinesShipment.isEmpty() && mapLinesShipment.containskey(s.id)){
                    
                    for(Shipment_Fee_Line__c LI: mapLinesShipment.get(s.id)){
                        
                        if(li.Record_Locked__c)
                            LI.Record_Locked__c = false;
                        
                        LI.SAP__c = true;
                        LI.Block__c = true;
                        String ItemCode = LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c:'';
                        // if(ItemCode == ''){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Capturar SAP Service Type para la línea ' + LI.Name);ApexPages.addMessage(myMsg);return null;}                        
                        Double units = LI.Units__c != null ? LI.Units__c: 1;
                        String ServTypeLine = LI.Service_Rate_Name__r.SAP_Service_Type__r.Name != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Name:'';
                        String Concepto = LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c:'';                        
                        String Vat = LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT__c : '';
                        String Ret = LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c != null ? LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c : '';
                        OrderItem line = new OrderItem();
                        line.ShipServLineId__c = LI.Id;
                        line.ServLine_Name__c = LI.Name;
                        line.Service_Rate_Name__c = ServTypeLine;
                        line.Retention__c = Ret;
                        line.Quantity = units;
                        line.UnitPrice = LI.Shipment_Sell_Net_Price__c;
                        line.VAT__c = Vat;
                        line.Group__c = Concepto;
                        line.ItemCode__c = ItemCode;
                        line.CurrencyLine__c = LI.CurrencyIsoCode;
                        line.Std_Buy_Amount__c = LI.Shipment_Buy_Price__c;
                        line.Product2Id = mapOrders.get(s.Order__c).DefaultProduct__c;
                        line.PricebookEntryId = mapOrders.get(s.Order__c).DefaultPbe__c;
                        line.OrderId = mapOrders.get(s.Order__c).Id;
                        lstLines.add(line); 
                        
                    }
                }
                
                if(S.Account_for__r.Venta_Sap__c == 'Contado'){S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'Shipment_Status_Bloq_Contado' limit 1].Id;}else{S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'ShipmentStatus' limit 1].Id;}                    
                S.Status_Shipment__c = 'Send to Sap';                    
                S.Date_Receive_from_SAP__c = datetime.now();
                S.AUTORIZAR_GASTO_EXTRA__c = false;
                S.NotificarGastoExtra__c = false;
                System.debug('S.RecordTypeId '+ S.RecordTypeId);
                System.debug('S.Status_Shipment__c '+ S.Status_Shipment__c);
                listaShipmentUpdate.add(s);
                
            }
            System.debug('lstLines '+ lstLines.size());
            upsert lstLines ShipServLineId__c;
            PAK_SendToSap.UpdateShipment(setShipmentIds);
            System.debug('Send to Sap Enviado ruben');
            
        }catch(Exception e){
            System.debug(e.getLineNumber()+'------------'+e.getMessage());
            
        }
    }
    
    //@future(callout=true)
    public static void UpdateShipment(Set<String> setShipmentIds)
    {
        try
        {
            SYSTEM.debug('ENTRMOS DENLO');
            list<Shipment__c> listaShipment = [Select Id,Name,Order__c, Account_for__r.Venta_Sap__c, Shipment_Status_Plann__c, Shipment_Status__c,
                                               Freight_Mode__c, Service_Mode__c, Status_Shipment__c, Ocean_Shipment_Status__c, Air_Shipment_Status__c,RecordTypeId,
                                               Date_Receive_from_SAP__c,AUTORIZAR_GASTO_EXTRA__c,NotificarGastoExtra__c 
                                               From Shipment__c 
                                               Where Id in : setShipmentIds];
            for(Shipment__c s : listaShipment){
                if(S.Account_for__r.Venta_Sap__c == 'Contado')
                {
                    S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'Shipment_Status_Bloq_Contado' limit 1].Id;
                }
                else
                {
                    S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'ShipmentStatus' limit 1].Id;
                }                    
                S.Status_Shipment__c = 'Send to Sap';                    
                S.Date_Receive_from_SAP__c = datetime.now();
                S.AUTORIZAR_GASTO_EXTRA__c = false;
                S.NotificarGastoExtra__c = false;
                s.Enviado_Sap__c = true;
            }
            
            NEU_StaticVariableHelper.setBoolean1(true);
            update listaShipment;
            NEU_StaticVariableHelper.setBoolean1(false);
            
            SYSTEM.debug('TERMINA DENLO');
        }
        catch(exception ex)
        {
            throw ex;
        }
    }
    
    /* public static void sendShipment(set<String> setShipmentIds, set<String> setOrderIds){
Bandera = false;
Boolean frontera = false;
List<OrderItem> lstLines = new List<OrderItem>();
list<Shipment__c> listaShipmentUpdate = new list<Shipment__c>(); 


try{
Bandera = false;
list<Shipment__c> listaShipment = [Select Id,Name,Order__c, Account_for__r.Venta_Sap__c, Shipment_Status_Plann__c, Shipment_Status__c,
Freight_Mode__c, Service_Mode__c, Status_Shipment__c, Ocean_Shipment_Status__c, Air_Shipment_Status__c,RecordTypeId,
Date_Receive_from_SAP__c,AUTORIZAR_GASTO_EXTRA__c,NotificarGastoExtra__c 
From Shipment__c 
Where Id in : setShipmentIds];

map<string,Order> mapOrders = new map<string,Order>([SELECT Id, DefaultPbe__c, DefaultProduct__c,Shipment__c FROM Order WHERE Id in : setOrderIds]);
list<Shipment_Fee_Line__c> listaShipLines = new list<Shipment_Fee_Line__c>();
map<string,list<Shipment_Fee_Line__c>> mapLinesShipment = new map<string,list<Shipment_Fee_Line__c>>();
for(Shipment_Fee_Line__c sfl :  [Select Id,Name,Units__c,CurrencyIsoCode,Shipment_Sell_Price__c,Shipment_Sell_Net_Price__c,
Shipment_Buy_Price__c,SAP__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.SAP_Service_Type__r.Group__c,
Service_Rate_Name__r.SAP_Service_Type__r.Name, Service_Rate_Name__r.SAP_Service_Type__r.VAT__c, Currency_Buy_Price__c, Conversion_Rate_to_Buy_Currency_Header__c,
Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c,Shipment__c
From Shipment_Fee_Line__c 
Where Shipment__c in : setShipmentIds and SAP__c=false]){
if(!mapLinesShipment.containsKey(sfl.Shipment__c)){
listaShipLines = new list<Shipment_Fee_Line__c>();
listaShipLines.add(sfl);
mapLinesShipment.put(sfl.Shipment__c,listaShipLines);	
}                               
else{
mapLinesShipment.get(sfl.Shipment__c).add(sfl);	
}
}

for(Shipment__c s : listaShipment){

TipoShipment = S.Name.substringBetween('-','-');
Estatus = '';
ValidarEstatus(S); 

if(S.Account_for__r.Venta_Sap__c == null || S.Account_for__r.Venta_Sap__c == ''){continue;}

System.debug('Estatus ruben'+ Estatus);
system.debug('Bandera ruben'+ Bandera);	
if(!test.isRunningTest() && Bandera){continue;}

String Body = '';
if(!mapLinesShipment.isEmpty() && mapLinesShipment.containskey(s.id)){

for(Shipment_Fee_Line__c LI: mapLinesShipment.get(s.id)){
LI.SAP__c = true;
LI.Block__c = true;
String ItemCode = LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c:'';
// if(ItemCode == ''){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Capturar SAP Service Type para la línea ' + LI.Name);ApexPages.addMessage(myMsg);return null;}                        
Double units = LI.Units__c != null ? LI.Units__c: 1;
String ServTypeLine = LI.Service_Rate_Name__r.SAP_Service_Type__r.Name != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Name:'';
String Concepto = LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c:'';                        
String Vat = LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT__c : '';
String Ret = LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c != null ? LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c : '';
OrderItem line = new OrderItem();
line.ShipServLineId__c = LI.Id;
line.ServLine_Name__c = LI.Name;
line.Service_Rate_Name__c = ServTypeLine;
line.Retention__c = Ret;
line.Quantity = units;
line.UnitPrice = LI.Shipment_Sell_Net_Price__c;
line.VAT__c = Vat;
line.Group__c = Concepto;
line.ItemCode__c = ItemCode;
line.CurrencyLine__c = LI.CurrencyIsoCode;
line.Std_Buy_Amount__c = LI.Shipment_Buy_Price__c;
line.Product2Id = mapOrders.get(s.Order__c).DefaultProduct__c;
line.PricebookEntryId = mapOrders.get(s.Order__c).DefaultPbe__c;
line.OrderId = mapOrders.get(s.Order__c).Id;
lstLines.add(line); 

}
}

if(S.Account_for__r.Venta_Sap__c == 'Contado'){S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'Shipment_Status_Bloq_Contado' limit 1].Id;}else{S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'ShipmentStatus' limit 1].Id;}                    
S.Status_Shipment__c = 'Send to Sap';                    
S.Date_Receive_from_SAP__c = datetime.now();
S.AUTORIZAR_GASTO_EXTRA__c = false;
S.NotificarGastoExtra__c = false;
System.debug('S.RecordTypeId '+ S.RecordTypeId);
System.debug('S.Status_Shipment__c '+ S.Status_Shipment__c);
listaShipmentUpdate.add(s);

}
System.debug('lstLines '+ lstLines.size());
upsert lstLines ShipServLineId__c;
update listaShipmentUpdate;
System.debug('Send to Sap Enviado ruben');

}catch(Exception e){
System.debug(e.getLineNumber()+'------------'+e.getMessage());

}
}
*/
    /* public static void ValidarEstatus(Shipment__c S)
{




if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False')){Bandera=true;Estatus ='para continuar debe ser Confirmed o False';}

if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO')){

if(S.Status_Shipment__c == 'Send to Sap' && S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False' && S.Shipment_Status_Plann__c != 'In Progress'){
Bandera=true;Estatus ='para continuar debe ser In Progress, Confirmed o False (Contado)';
}else if(S.Status_Shipment__c != 'Send to Sap' && S.Shipment_Status_Plann__c != 'In Progress' && S.Shipment_Status_Plann__c != 'False'){
System.debug('Else estatus sap');
Bandera=true;Estatus ='para continuar debe ser In Progress o False (Contado)';
}
}


if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'A') && (S.Air_Shipment_Status__c != 'Contact with Origin' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline' && S.Air_Shipment_Status__c != 'Documentation' && S.Air_Shipment_Status__c != 'Flight Confirmation' && S.Air_Shipment_Status__c != 'Layover' && S.Air_Shipment_Status__c != 'Arrival Confirmation' && S.Air_Shipment_Status__c != 'Pending with Customs Broker' && S.Air_Shipment_Status__c != 'Final Delivery' && S.Air_Shipment_Status__c != 'Finish')){
Bandera=true;Estatus ='para continuar debe ser Contact with Origin, Pickup and Delivery to Airline, Documentation, Flight Confirmation, Layover, Arrival Confirmation, Pending with Customs Broker, Final Delivery o Finish (Contado)';
}
if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'M') && S.Service_Mode__c == 'IMPORT' && (S.Ocean_Shipment_Status__c != 'Booking Confirmation' && S.Ocean_Shipment_Status__c != 'Pickup Confirmation' && S.Ocean_Shipment_Status__c != 'Documents' && S.Ocean_Shipment_Status__c != 'ETD' && S.Ocean_Shipment_Status__c != 'ETA-15' && S.Ocean_Shipment_Status__c != 'ETA-10' && S.Ocean_Shipment_Status__c != 'ETA-7' && S.Ocean_Shipment_Status__c != 'ETA-4' && S.Ocean_Shipment_Status__c != 'ETA' && S.Ocean_Shipment_Status__c != 'Telex Confirmation' && S.Ocean_Shipment_Status__c != 'Customs Clearences' && S.Ocean_Shipment_Status__c != 'Final Delivery' && S.Ocean_Shipment_Status__c != 'Finished' && S.Ocean_Shipment_Status__c != 'Pending Information')){
System.debug('Estatus: ' + S.Ocean_Shipment_Status__c);
Bandera=true;Estatus ='para continuar debe ser Booking Confirmation, Pickup Confirmation, Documents, ETD, ETA-15, ETA-10, ETA-7, ETA-4, ETA, Telex Confirmation, Customs Clearences, Final Delivery, Finished o Pending Information (Contado)';   
}            
if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'M') && S.Service_Mode__c == 'EXPORT' && (S.Shipment_Status__c != 'Pending but Pre-Captured' && S.Shipment_Status__c != 'Booking Confirmation' && S.Shipment_Status__c != 'Planned for delivery - Not yet on route' && S.Shipment_Status__c != 'Captured but not yet sent EDI' && S.Shipment_Status__c != 'Pending - Missing Documents/Instructions' && S.Shipment_Status__c != 'Submitted to Customs' && S.Shipment_Status__c != 'Cleared but Awaiting Vessel' && S.Shipment_Status__c != 'Delivered' && S.Shipment_Status__c != 'Cleared but Stopped' && S.Shipment_Status__c != 'Delivered to Depot' && S.Shipment_Status__c != 'Agent Notified' && S.Shipment_Status__c != 'ETA -15' && S.Shipment_Status__c != 'ETA -10' && S.Shipment_Status__c != 'ETA -7' && S.Shipment_Status__c != 'ETA -4' && S.Shipment_Status__c != 'In Progress' && S.Shipment_Status__c != 'TLX Confirmation' && S.Shipment_Status__c != 'Delivery On route' && S.Shipment_Status__c != 'Finished')){
Bandera=true;Estatus ='para continuar debe ser Schedules, Booking Confirmation, Pickup, Documents, Shipping Instructions / VGM, Cut Off, BL Draft, ETD, Invoice, MBL/HBL, Payment, ETA -15, ETA -10, ETA -7, ETA -4, ETA, TLX Confirmation, Delivery On route o Finished (Contado)';
}
if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False')){Bandera=true;Estatus ='para continuar debe ser Confirmed o False (Crédito)';}

if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'A') && (S.Air_Shipment_Status__c != 'Flight Confirmation' && S.Air_Shipment_Status__c != 'Layover' && S.Air_Shipment_Status__c != 'Arrival Confirmation' && S.Air_Shipment_Status__c != 'Pending with Customs Broker' && S.Air_Shipment_Status__c != 'Final Delivery' && S.Air_Shipment_Status__c != 'Finish')){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation, Layover, Arrival Confirmation, Pending with Customs Broker, Final Delivery o Finish (Crédito)';}

if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'M' && S.Service_Mode__c == 'IMPORT' && (S.Ocean_Shipment_Status__c != 'ETD' && S.Ocean_Shipment_Status__c != 'ETA-15' && S.Ocean_Shipment_Status__c != 'ETA-10' && S.Ocean_Shipment_Status__c != 'ETA-7' && S.Ocean_Shipment_Status__c != 'ETA-4' && S.Ocean_Shipment_Status__c != 'ETA' && S.Ocean_Shipment_Status__c != 'Telex Confirmation' && S.Ocean_Shipment_Status__c != 'Customs Clearences' && S.Ocean_Shipment_Status__c != 'Final Delivery' && S.Ocean_Shipment_Status__c != 'Finished' && S.Ocean_Shipment_Status__c != 'Pending Information')){Bandera=true;Estatus ='para continuar debe ser ETD, ETA-15, ETA-10, ETA-7, ETA-4, ETA, Telex Confirmation, Customs Clearences, Final Delivery, Finished o Pending Information (Crédito)';}

if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && S.Air_Shipment_Status__c != 'Flight Confirmation'){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation';}

if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline'){Bandera=true;Estatus ='para continuar debe ser Pickup and Delivery to Airline';}

if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && S.Air_Shipment_Status__c != 'Flight Confirmation'){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation';}

if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline'){Bandera=true;Estatus ='para continuar debe ser Pickup and Delivery to Airline';}




if(TipoShipment == 'R' && S.Freight_Mode__c =='Air' && S.Air_Shipment_Status__c != 'Consigness Notification'){Bandera=true;Estatus ='para continuar debe ser Consigness Notification';}

if((TipoShipment == 'WH' || TipoShipment == 'EX' || TipoShipment == 'ES' || TipoShipment == 'FP' || TipoShipment == 'FO' || TipoShipment == 'PQ' || TipoShipment == 'T') && S.Shipment_Status_Plann__c != 'Confirmed'){
Bandera=true;Estatus ='para continuar debe ser Confirmed';
}

set<string> setEstatus = new set<string>();
setEstatus.add('Delivered');
setEstatus.add('ETA-15');
setEstatus.add('ETD');
setEstatus.add('Cleared but Stopped');
setEstatus.add('Delivered to Depot');
setEstatus.add('Agent Notified');
setEstatus.add('ETA -10');
setEstatus.add('ETA -7');
setEstatus.add('ETA -4');
setEstatus.add('In Progress');
setEstatus.add('TLX Confirmation');
setEstatus.add('Delivery On route');
setEstatus.add('Finished');
setEstatus.add('Cancel');
setEstatus.add('Booking Confirmation');


if(TipoShipment == 'R' && S.Freight_Mode__c =='Sea' && S.Ocean_Shipment_Status__c != 'ETA-15'){Bandera=true;Estatus ='para continuar debe ser ETA-15';}

if(s.Shipment_Status__c != null)
{
if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Shipment_Status__c)) {Bandera=true;Estatus ='para continuar debe ser Shipment_Status__c';}

if(TipoShipment == 'M' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Shipment_Status__c)  && S.Account_for__r.Venta_Sap__c == 'Credito') {Bandera=true;Estatus ='para continuar debe ser ETD';}
}

if(TipoShipment == 'W' && S.Service_Mode__c == 'IMPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Ocean_Shipment_Status__c)) {Bandera=true;Estatus ='para continuar debe ser Ocean_Shipment_Status__c';}

}*/
    
    public static void ValidarEstatus(Shipment__c S)
    {
        system.debug('entro aqui  ValidarEstatus : ' + s);
        // agregar campo VPC
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'FN' && S.Shipment_Status_Mon__c != 'Delivery on Route_M' && S.Shipment_Status_Mon__c != 'Finished_M'  && s.VerificacionPak__c != true){Bandera=true;Estatus ='para continuar debe ser Delivery on Route / Finished y estar validado por pack control';}
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Mon__c != 'Delivery on Route_M' && S.Shipment_Status_Mon__c != 'Finished_M')){Bandera=true;Estatus ='para continuar debe ser Confirmed o Finished';}
        
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO')){
            System.debug('Entro contado val');
            System.debug('Values - Status_Shipment__c: ' + S.Status_Shipment__c + ' - Shipment_Status_Plann__c: ' + S.Shipment_Status_Plann__c);
            if(S.Status_Shipment__c == 'Send to Sap' && S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False' && S.Shipment_Status_Plann__c != 'In Progress'){
                System.debug('Entro val estatus sap');
                Bandera=true;Estatus ='para continuar debe ser In Progress, Confirmed o False (Contado)';
            }else if(S.Status_Shipment__c != 'Send to Sap' && S.Shipment_Status_Plann__c != 'In Progress' && S.Shipment_Status_Plann__c != 'False'){
                System.debug('Else estatus sap');
                Bandera=true;Estatus ='para continuar debe ser In Progress o False (Contado)';
            }
        }
        /*
if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && S.Shipment_Status_Plann__c != 'In Progress'){
Bandera=true;Estatus ='para continuar debe ser In Progress (Contado)';
}*/
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'A') && (S.Air_Shipment_Status__c != 'Contact with Origin' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline' && S.Air_Shipment_Status__c != 'Documentation' && S.Air_Shipment_Status__c != 'Flight Confirmation' && S.Air_Shipment_Status__c != 'Layover' && S.Air_Shipment_Status__c != 'Arrival Confirmation' && S.Air_Shipment_Status__c != 'Pending with Customs Broker' && S.Air_Shipment_Status__c != 'Final Delivery' && S.Air_Shipment_Status__c != 'Finish')){
            Bandera=true;Estatus ='para continuar debe ser Contact with Origin, Pickup and Delivery to Airline, Documentation, Flight Confirmation, Layover, Arrival Confirmation, Pending with Customs Broker, Final Delivery o Finish (Contado)';
        }
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'M') && S.Service_Mode__c == 'IMPORT' && (S.Ocean_Shipment_Status__c != 'Booking Confirmation' && S.Ocean_Shipment_Status__c != 'Pickup Confirmation' && S.Ocean_Shipment_Status__c != 'Documents' && S.Ocean_Shipment_Status__c != 'ETD' && S.Ocean_Shipment_Status__c != 'ETA-15' && S.Ocean_Shipment_Status__c != 'ETA-10' && S.Ocean_Shipment_Status__c != 'ETA-7' && S.Ocean_Shipment_Status__c != 'ETA-4' && S.Ocean_Shipment_Status__c != 'ETA' && S.Ocean_Shipment_Status__c != 'Telex Confirmation' && S.Ocean_Shipment_Status__c != 'Customs Clearences' && S.Ocean_Shipment_Status__c != 'Final Delivery' && S.Ocean_Shipment_Status__c != 'Finished' && S.Ocean_Shipment_Status__c != 'Pending Information')){
            System.debug('Estatus: ' + S.Ocean_Shipment_Status__c);
            Bandera=true;Estatus ='para continuar debe ser Booking Confirmation, Pickup Confirmation, Documents, ETD, ETA-15, ETA-10, ETA-7, ETA-4, ETA, Telex Confirmation, Customs Clearences, Final Delivery, Finished o Pending Information (Contado)';   
        }            
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'M') && S.Service_Mode__c == 'EXPORT' && (S.Shipment_Status__c != 'Pending but Pre-Captured' && S.Shipment_Status__c != 'Booking Confirmation' && S.Shipment_Status__c != 'Planned for delivery - Not yet on route' && S.Shipment_Status__c != 'Captured but not yet sent EDI' && S.Shipment_Status__c != 'Pending - Missing Documents/Instructions' && S.Shipment_Status__c != 'Submitted to Customs' && S.Shipment_Status__c != 'Cleared but Awaiting Vessel' && S.Shipment_Status__c != 'Delivered' && S.Shipment_Status__c != 'Cleared but Stopped' && S.Shipment_Status__c != 'Delivered to Depot' && S.Shipment_Status__c != 'Agent Notified' && S.Shipment_Status__c != 'ETA -15' && S.Shipment_Status__c != 'ETA -10' && S.Shipment_Status__c != 'ETA -7' && S.Shipment_Status__c != 'ETA -4' && S.Shipment_Status__c != 'In Progress' && S.Shipment_Status__c != 'TLX Confirmation' && S.Shipment_Status__c != 'Delivery On route' && S.Shipment_Status__c != 'Finished')){
            Bandera=true;Estatus ='para continuar debe ser Schedules, Booking Confirmation, Pickup, Documents, Shipping Instructions / VGM, Cut Off, BL Draft, ETD, Invoice, MBL/HBL, Payment, ETA -15, ETA -10, ETA -7, ETA -4, ETA, TLX Confirmation, Delivery On route o Finished (Contado)';
        }
        // agregar campo VPC
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'FN' && S.Shipment_Status_Mon__c != 'Delivery on Route_M' && S.Shipment_Status_Mon__c != 'Finished_M' /*S.Shipment_Status_Plann__c == 'Confirmed' && S.Shipment_Status_Plann__c != 'False'*/ && s.VerificacionPak__c != true ){Bandera=true;Estatus ='para continuar debe ser Delivery on Route y estar validado por pack control';}
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'FN' && (S.Shipment_Status_Mon__c=='Delivery on Route_M' || S.Shipment_Status_Mon__c != 'Finished_M') && s.VerificacionPak__c != true ){Bandera=false;Estatus ='entrando a mi nuev validacion ';}
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Mon__c != 'Delivery on Route_M' || S.Shipment_Status_Mon__c != 'Finished_M')){Bandera=false;Estatus ='para continuar debe ser Delivery on Route o False (Crédito)(validacion2)';}
        
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'A') && (S.Air_Shipment_Status__c != 'Flight Confirmation' && S.Air_Shipment_Status__c != 'Layover' && S.Air_Shipment_Status__c != 'Arrival Confirmation' && S.Air_Shipment_Status__c != 'Pending with Customs Broker' && S.Air_Shipment_Status__c != 'Final Delivery' && S.Air_Shipment_Status__c != 'Finish')){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation, Layover, Arrival Confirmation, Pending with Customs Broker, Final Delivery o Finish (Crédito)';}
        
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'M' && S.Service_Mode__c == 'IMPORT' && (S.Ocean_Shipment_Status__c != 'ETD' && S.Ocean_Shipment_Status__c != 'ETA-15' && S.Ocean_Shipment_Status__c != 'ETA-10' && S.Ocean_Shipment_Status__c != 'ETA-7' && S.Ocean_Shipment_Status__c != 'ETA-4' && S.Ocean_Shipment_Status__c != 'ETA' && S.Ocean_Shipment_Status__c != 'Telex Confirmation' && S.Ocean_Shipment_Status__c != 'Customs Clearences' && S.Ocean_Shipment_Status__c != 'Final Delivery' && S.Ocean_Shipment_Status__c != 'Finished' && S.Ocean_Shipment_Status__c != 'Pending Information')){Bandera=true;Estatus ='para continuar debe ser ETD, ETA-15, ETA-10, ETA-7, ETA-4, ETA, Telex Confirmation, Customs Clearences, Final Delivery, Finished o Pending Information (Crédito)';}
        if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'W') && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c == 'Delivered'){
            // Bandera=true;Estatus ='validacion de leo XD';
            Bandera=true;Estatus ='es necesario que el status sea Delivered el servicio  EXPORT y tipo contado';
            system.debug('No se mandara a llamar sendtoSap por que lo dice leo XD ');
        }
        if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'M') && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c == 'Booking Confirmation'){
            Bandera=true;Estatus ='es necesario que el status sea Booking Confirmation el servicio  EXPORT y tipo credito';
            // Bandera=true;Estatus ='validacion de leo XD';
            system.debug('No se mandara a llamar sendtoSap por que lo dice leo XD ');
        }
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && S.Air_Shipment_Status__c != 'Flight Confirmation'){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation';}
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline'){Bandera=true;Estatus ='para continuar debe ser Pickup and Delivery to Airline';}
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && S.Air_Shipment_Status__c != 'Flight Confirmation'){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation';}
        
        if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline'){Bandera=true;Estatus ='para continuar debe ser Pickup and Delivery to Airline';}
        
        // if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered'){Bandera=true;Estatus ='para continuar debe ser ETD';}
        //if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered'){Bandera=true;Estatus ='para continuar debe ser ETD';}
        // if(TipoShipment == 'M' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered' && S.Account_for__r.Venta_Sap__c == 'Credito' ){Bandera=true;Estatus ='para continuar debe ser ETD';}  
        
        
        
        //  if(TipoShipment == 'R' && S.Freight_Mode__c =='Air' && S.Air_Shipment_Status__c != 'Consigness Notification'){Bandera=true;Estatus ='para continuar debe ser Consigness Notification';}
        
        if((TipoShipment == 'WH' || TipoShipment == 'EX' || TipoShipment == 'ES' || TipoShipment == 'FP' || TipoShipment == 'FO' ) && S.Shipment_Status_Plann__c != 'Confirmed'){
            Bandera=true;Estatus ='para continuar debe ser Confirmed';
        }
        if(TipoShipment == 'PQ' || TipoShipment == 'T' ){
            if(S.Shipment_Status_Plann__c != 'Confirmed'&&S.Account_for__r.Venta_Sap__c == 'Credito'){
                Bandera=true;Estatus ='para continuar debe ser Confirmed';
            }
            if(S.Shipment_Status_Plann__c != 'In progress'&&S.Account_for__r.Venta_Sap__c == 'Contado'){
                Bandera=true;Estatus ='para continuar debe ser in progress';
            }
        }
        
        set<string> setEstatus = new set<string>();
        setEstatus.add('Delivered');
        setEstatus.add('ETA-15');
        setEstatus.add('ETD');
        setEstatus.add('Cleared but Stopped');
        setEstatus.add('Delivered to Depot');
        setEstatus.add('Agent Notified');
        setEstatus.add('ETA -10');
        setEstatus.add('ETA -7');
        setEstatus.add('ETA -4');
        setEstatus.add('In Progress');
        setEstatus.add('TLX Confirmation');
        setEstatus.add('Delivery On route');
        setEstatus.add('Finished');
        setEstatus.add('Cancel');
        setEstatus.add('Booking Confirmation');
        
        system.debug('Estaus Shipment '+ s.Shipment_Status__c);
        system.debug('TipoShipment '+ TipoShipment);
        system.debug('Freight_Mode__c '+ S.Freight_Mode__c);
        system.debug('Service_Mode__c '+ S.Service_Mode__c);
        system.debug('Se encontro: '+ setEstatus.contains(s.Shipment_Status__c));
        system.debug('llego aqui ValidarEstatus : ');
        
        if(TipoShipment == 'R' && (S.Freight_Mode__c == 'Sea' || S.Freight_Mode__c =='Air' ) && ( S.Routing_Operation_Status__c != 'Gestión de Documentos'))
        {
            Bandera=true;Estatus ='para ov';
        }
        
        if(s.Shipment_Status__c != null)
        {
            if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Shipment_Status__c)) {Bandera=true;Estatus ='para continuar debe ser Shipment_Status__c';}
            
            if(TipoShipment == 'M' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Shipment_Status__c)  && S.Account_for__r.Venta_Sap__c == 'Credito') {Bandera=true;Estatus ='para continuar debe ser ETD';}
        }
        
        if(TipoShipment == 'W' && S.Service_Mode__c == 'IMPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Ocean_Shipment_Status__c)) {Bandera=true;Estatus ='para continuar debe ser Ocean_Shipment_Status__c';}
        
    }
    
    public static void TestMetodo(){
        String Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        
    }
    
}