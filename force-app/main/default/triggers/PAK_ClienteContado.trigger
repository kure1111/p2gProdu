trigger PAK_ClienteContado on Shipment__c (before update) {
    if(NEU_StaticVariableHelper.getBoolean1()){return;}
       
    String tipoShipment;
    Set<Id> stIdAcct = new Set<Id>();
    Map<Id, String> mapTipoCliente = new Map<Id, String>();
    //Map<Id, String> mapPlazaCuenta = new Map<Id, String>();
    Boolean isValid = false;
    //Boolean rtiContado = [SELECT Contado_Mgm__c FROM User WHERE Id =: UserInfo.getUserId()][0].Contado_Mgm__c;
    //Set<String> plazas = new Set<String>();plazas.add('MTY');plazas.add('SAL');plazas.add('TOR');plazas.add('GDL');plazas.add('MEX');plazas.add('TOL');plazas.add('PUE');plazas.add('LEO');plazas.add('SLP');plazas.add('QUE');
    
    /*if(test.isRunningTest())
    {
        string a='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+=''; 
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
    }*/
    if(!RecursiveCheck.triggerMonitor.contains('PAK_ClienteContado')){
        RecursiveCheck.triggerMonitor.add('PAK_ClienteContado');
        for(Shipment__c s : Trigger.new){if(s.Account_for__c != null && !stIdAcct.contains(s.Account_for__c)){stIdAcct.add(s.Account_for__c);}}
        
        for(Account a : [SELECT Id, Venta_Sap__c, Workplace_AccOwner__c FROM Account WHERE Id IN:stIdAcct]){ mapTipoCliente.put(a.Id, a.Venta_Sap__c);}
        
        System.debug('Map tipo cuenta: ' + mapTipoCliente);
        
        for(Shipment__c s: trigger.new)
        {
            Shipment__c oldship = Trigger.oldMap.get(s.ID);
            
            if(s.Account_for__c != null && mapTipoCliente.get(s.Account_for__c) == 'Contado'){
                System.debug('Entro');
                
                if(s.Pago_Contado_SAP__c != null && s.Pago_Contado_SAP__c >= s.Total_Services_Sell_Amount__c /*Total_SP_Service_Sell_Net_Amount__c*/){isValid = true;}else{isValid = false;}
                
                tipoShipment = s.Name.substringBetween('-','-');
                
                System.debug('Tipo s: ' + tipoShipment);
                
                if(!isValid && (tipoShipment == 'FN' || tipoShipment == 'FI' || tipoShipment == 'PTO') && s.Shipment_Status_Plann__c == 'Confirmed' && oldship.Shipment_Status_Plann__c != s.Shipment_Status_Plann__c) {s.addError('Cliente de contado: No se ha recibido el pago');}
                if(!isValid && tipoShipment == 'A' && (s.Air_Shipment_Status__c == 'Layover' || s.Air_Shipment_Status__c == 'Arrival Confirmation' || s.Air_Shipment_Status__c == 'Pending with Customs Broker' || s.Air_Shipment_Status__c == 'Final Delivery' || s.Air_Shipment_Status__c == 'Finish') && oldship.Air_Shipment_Status__c != s.Air_Shipment_Status__c){s.addError('Cliente de contado: No se ha recibido el pago');}
                
                if(!isValid && tipoShipment == 'M' && s.Service_Mode__c == 'IMPORT'  && (s.Ocean_Shipment_Status__c == 'ETA-4' || s.Ocean_Shipment_Status__c == 'ETA' || s.Ocean_Shipment_Status__c == 'Telex Confirmation' || s.Ocean_Shipment_Status__c == 'Customs Clearences' || s.Ocean_Shipment_Status__c == 'Final Delivery' || s.Ocean_Shipment_Status__c == 'Finished' || s.Ocean_Shipment_Status__c == 'Pending Information') && oldship.Ocean_Shipment_Status__c != s.Ocean_Shipment_Status__c){s.addError('Cliente de contado: No se ha recibido el pago');}
                
                if(!isValid && tipoShipment == 'M' && s.Service_Mode__c == 'EXPORT' && (s.Shipment_Status__c == 'Cleared but Stopped' || s.Shipment_Status__c == 'Delivered to Depot' || s.Shipment_Status__c == 'Agent Notified' || s.Shipment_Status__c == 'ETA -15' || s.Shipment_Status__c == 'ETA -10' || s.Shipment_Status__c == 'ETA -7' || s.Shipment_Status__c == 'ETA -4' || s.Shipment_Status__c == 'In Progress' || s.Shipment_Status__c == 'TLX Confirmation' || s.Shipment_Status__c == 'Delivery On route' || s.Shipment_Status__c == 'Finished')&& oldship.Shipment_Status__c != s.Shipment_Status__c) {s.addError('Cliente de contado: No se ha recibido el pago');}
            }
        }
    }
}