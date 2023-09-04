trigger PAK_PlannerEmail on Customer_Quote__c (before insert,before update,after update) {
    if(NEU_StaticVariableHelper.getBoolean1())
    return;
    if(trigger.isBefore){
        boolean Validacion= false;
        list<String> lsShipment = new list<String>();
        if(trigger.isInsert){
            map<String,String> mapRegion = new map<String,String>();
            map<String,String> mapPlannerZoneEmail = new map<String,String>();
            map<String,String> mapWareHouse = new map<String,String>();           
            for(State__c States: [Select Id,Zone_Planner_email__c From State__c]){mapPlannerZoneEmail.put(States.Id, States.Zone_Planner_email__c);}
            for(Country__c Reg: [Select Id,Region__c From Country__c]){mapRegion.put(Reg.Id,Reg.Region__c);}
            for(Warehouse__c WH: [Select Id, Warehouse_Manager__c, Warehouse_Executive__c, Warehouse_Manager__r.Email,Warehouse_Executive__r.Email From Warehouse__c]){String ExEmail = '';String ManEmail = '';if(WH.Warehouse_Executive__c != null){ExEmail = WH.Warehouse_Executive__r.Email;}if(WH.Warehouse_Manager__c != null){ManEmail = WH.Warehouse_Manager__r.Email;}mapWareHouse.put(WH.Id, ExEmail+'-'+ManEmail);}
            for(Customer_Quote__c QUOTE: trigger.new){                            
                String EmailEx = mapWareHouse.get(QUOTE.Warehouse__c) != null?mapWareHouse.get(QUOTE.Warehouse__c).substringBefore('-'):'';
                String EmailMan = mapWareHouse.get(QUOTE.Warehouse__c) != null?mapWareHouse.get(QUOTE.Warehouse__c).substringAfter('-'):'';
                QUOTE.Planner_email_zone__c = mapPlannerZoneEmail.get(QUOTE.State_of_Load__c);
                QUOTE.Region_Country__c = mapRegion.get(QUOTE.Country_ofLoad__c);
                QUOTE.Region_CountryPOD__c =mapRegion.get(QUOTE.Country_ofDischarge__c);
                QUOTE.Warehouse_ManagerEmail__c = EmailMan;
                QUOTE.Warehouse_Executive__c = EmailEx;                
            }
            
            // Se consulta cuenta - se toma en cuenta para rtis - ok rti next
            list<Account> Cuenta = [Select ActiveSap__c, Venta_Sap__c, RecordtypeId, Owner.Workplace__c, Saldo_DisponibleOK__c From Account Where Id=: trigger.new[0].Account_for__c];
            list<Lead> leads = [SELECT Name, Id, ConvertedAccountId FROM Lead where ConvertedAccountId =: trigger.new[0].Account_for__c ]; 
            RecordType customerRt = [Select Id From Recordtype Where DeveloperName='Customer' limit 1];
            
            System.debug('Saldo: ' + Cuenta[0].Saldo_DisponibleOK__c);
            System.debug('MontoQuote: ' + trigger.new[0].Total_Services_Sell_Amount__c);
            System.debug('RtAccount: ' + Cuenta[0].RecordtypeId);
            System.debug('customerRt: ' + customerRt.Id);
            System.debug('Venta: ' + Cuenta[0].Venta_Sap__c);
            //if(!Test.isRunningTest() && trigger.isInsert && Cuenta[0].Saldo_DisponibleOK__c < trigger.new[0].Total_Services_Sell_Amount__c && Cuenta[0].RecordtypeId == customerRt.Id && Cuenta[0].Venta_Sap__c != 'Contado'){trigger.new[0].AddError('El cliente no tiene Crédito disponible para generar Cotizaciones, Saldo Disponible: '+Cuenta[0].Saldo_DisponibleOK__c);}            
            if(!Test.isRunningTest() && trigger.isInsert && Cuenta[0].Saldo_DisponibleOK__c < trigger.new[0].Total_Services_Sell_Amount__c && Cuenta[0].RecordtypeId == customerRt.Id && Cuenta[0].Venta_Sap__c != 'Contado'){trigger.new[0].AddError('CREDITO NO DISPONIBLE, favor de Verificar con "Dpto. de Creditos"');}
            if(!Test.isRunningTest() && trigger.isInsert && Cuenta[0].ActiveSap__c == false && ( (cuenta[0].RecordtypeId == '0124T000000PTuRQAW' || cuenta[0].RecordtypeId == '0124T000000PTuWQAW') && leads.size() == 0)  ){trigger.new[0].addError('No puedes generar una Import-Export Quote si el cliente esta inactivo');}
        }
        
        if(trigger.isUpdate){
            //Validar Cancelacion de IE Quote
            list<Account> Cuenta = [Select ActiveSap__c, Venta_Sap__c, RecordtypeId, Owner.Workplace__c, Saldo_DisponibleOK__c From Account Where Id=: trigger.new[0].Account_for__c];
            RecordType customerRt = [Select Id From Recordtype Where DeveloperName='Customer' limit 1];
            for(Customer_Quote__c QUOTE: trigger.new){                
                if(trigger.oldMap.get(QUOTE.Id).Quotation_Status__c != QUOTE.Quotation_Status__c){                    
                    if(QUOTE.Quotation_Status__c == 'Quote Declined'){
                        for(Shipment_Consolidation_Data__c Data:[Select Import_Export_Quote__c, Shipment__r.Shipment_Status_Plann__c,Shipment__r.Air_Shipment_Status__c,Shipment__r.Ocean_Shipment_Status__c, Shipment__r.Shipment_Status__c From Shipment_Consolidation_Data__c Where Import_Export_Quote__c=:QUOTE.Id]){
                            lsShipment.add( Data.Shipment__r.Shipment_Status_Plann__c+' '+Data.Shipment__r.Air_Shipment_Status__c+' '+Data.Shipment__r.Ocean_Shipment_Status__c+' '+Data.Shipment__r.Shipment_Status__c);
                        }if(lsShipment.size()>0){for(String VAL: lsShipment){if(!VAL.contains('Cancel')){Validacion = true;}}}if(Validacion){QUOTE.addError('No se puede cancelar la Import/Export Quotes tiene Shipments en operación');}
                    }
                    if(QUOTE.Quotation_Status__c == 'Approved as Succesful'){
                        if(!Test.isRunningTest() && Cuenta[0].Saldo_DisponibleOK__c < trigger.new[0].Total_Services_Sell_Amount__c && Cuenta[0].RecordtypeId == customerRt.Id && Cuenta[0].Venta_Sap__c != 'Contado'){trigger.new[0].AddError('CREDITO NO DISPONIBLE, favor de Verificar con "Dpto. de Creditos"');}
                    }
                }                
            }
        }
    }
    if(trigger.isAfter && trigger.isUpdate){if(trigger.old[0].Quotation_Status__c != trigger.new[0].Quotation_Status__c){Status_Datetime__c SDate = new Status_Datetime__c();SDate.IEQ_Status__c = trigger.new[0].Quotation_Status__c;SDate.UserIEQ__c = trigger.new[0].LastModifiedById;SDate.IEQ_Modifield_Date__c = trigger.new[0].LastModifiedDate;SDate.Customer_Quote__c = trigger.new[0].Id;insert SDate;}}
}