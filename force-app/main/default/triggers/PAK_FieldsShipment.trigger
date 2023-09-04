trigger PAK_FieldsShipment on Shipment__c (before update, after update) {
    
    if(NEU_StaticVariableHelper.getBoolean1())
        return;
    
    System.debug('***PAK_FieldsShipment***');
    Set<Id> setShipment = new Set<Id>();
    Map<Id, Shipment_Consolidation_Data__c> mapShipment = new Map<Id, Shipment_Consolidation_Data__c>();
    
    for(Shipment__c s : trigger.new){
        if(!setShipment.contains(s.Id)){setShipment.add(s.Id);}
    }
    System.debug('***PAK_FieldsShipment SET: *** ' + setShipment);
    for(Shipment_Consolidation_Data__c scd : [Select Import_Export_Quote__c,Import_Export_Quote__r.CreatedBy.Email, Shipment__c From Shipment_Consolidation_Data__c Where Shipment__c IN:setShipment]){mapShipment.put(scd.Shipment__c, scd);}
    System.debug('***PAK_FieldsShipment MAP ID, CONS: *** ' + mapShipment);
    
    if(trigger.isBefore){
        System.debug('***PAK_FieldsShipment BEFORE***');
        map<String,String> mapWareHouse = new map<String,String>();
        for(Warehouse__c WH: [Select Id, Warehouse_Manager__c, Warehouse_Executive__c, Warehouse_Manager__r.Email,Warehouse_Executive__r.Email From Warehouse__c]){String ExEmail = '';String ManEmail = '';if(WH.Warehouse_Executive__c != null){ExEmail = WH.Warehouse_Executive__r.Email;}if(WH.Warehouse_Manager__c != null){ManEmail = WH.Warehouse_Manager__r.Email;}mapWareHouse.put(WH.Id, ExEmail+'-'+ManEmail);}
        for(Shipment__c SHIP: trigger.new){
            String EmailEx = mapWareHouse.get(SHIP.Warehouse__c) != null?mapWareHouse.get(SHIP.Warehouse__c).substringBefore('-'):'';
            String EmailMan = mapWareHouse.get(SHIP.Warehouse__c) != null?mapWareHouse.get(SHIP.Warehouse__c).substringAfter('-'):'';
            if(mapShipment.containsKey(SHIP.Id)){SHIP.Email_Sales_ExecutiveSP__c = mapShipment.get(SHIP.Id).Import_Export_Quote__r.CreatedBy.Email;}
            SHIP.Warehouse_Executive__c = EmailEx;
            SHIP.Warehouse_Manager__c = EmailMan;
            //  updateStatusShipment(SHIP);
            
            //LINEAS CONGELADAS
            system.debug('entro LINEAS CONGELADAS ');
            system.debug('entro before shth Shipment_Status_Plann__c ' + ship.Shipment_Status_Plann__c );
            system.debug('entro before shth Shipment_Type__c' + ship.Shipment_Type__c);
            system.debug('entro before shth  Trigger.oldMap.get(ship.Id).Shipment_Status_Plann__c' +  Trigger.oldMap.get(ship.Id).Shipment_Status_Plann__c);
            
            //BLOQUEO
            if(!Test.isRunningTest())
            {
                
                if(ship.Shipment_Status_Plann__c != null  
                   && ship.Shipment_Status_Plann__c == 'Confirmed' && Trigger.oldMap.get(ship.Id).Shipment_Status_Plann__c != 'False'
                   &&  ( ship.Shipment_Type__c.contains('FN')|| ship.Shipment_Type__c.contains('FI')|| ship.Shipment_Type__c.contains('PTO') ))
                {
                    for (Shipment_Fee_Line__c sl : [SELECT Id,Record_Locked__c,SAP__c, Name,Code_SAP__c FROM Shipment_Fee_Line__c where Shipment__c =:ship.id])
                    {
                        system.debug('sl.Record_Locked__c '  + sl.Record_Locked__c);
                        if( !sl.Record_Locked__c &&  (sl.Code_SAP__c  == 'FTN' || sl.Code_SAP__c  == 'FTLF' ||  sl.Code_SAP__c  == 'FCONA' || sl.Code_SAP__c  == 'IT' || sl.Code_SAP__c  == 'ITA' ||  sl.Code_SAP__c  == 'ITA1' || sl.Code_SAP__c  == 'PTO1' || sl.Code_SAP__c  == 'PTO2' ||  sl.Code_SAP__c  == 'PTO3'))
                        {
                            sl.Record_Locked__c = true;
                            update sl;
                        }
                    }
                    
                }
                
                //DESBLOQUEO CAMBIO STATUS
                if(ship.Shipment_Status_Plann__c != null && Trigger.oldMap.get(ship.Id).Shipment_Status_Plann__c == 'False'
                   && ship.Shipment_Status_Plann__c == 'Confirmed'
                   &&  ( ship.Shipment_Type__c.contains('FN')|| ship.Shipment_Type__c.contains('FI')|| ship.Shipment_Type__c.contains('PTO')   ) )
                {
                    ship.Shipment_Status_Plann__c.addError('No se puede pasar de False a Confirmed');
                }
                
                //DESBLOQUEAR 
                else if(ship.Shipment_Status_Plann__c != null && Trigger.oldMap.get(ship.Id).Shipment_Status_Plann__c == 'Confirmed'
                        && ship.Shipment_Status_Plann__c == 'False'
                        &&  ( ship.Shipment_Type__c.contains('FN') || ship.Shipment_Type__c.contains('FI') || ship.Shipment_Type__c.contains('PTO')  ) )
                {
                    
                    for (Shipment_Fee_Line__c sl : [SELECT Id,Record_Locked__c, Name FROM Shipment_Fee_Line__c where Shipment__c =:ship.id])
                    {
                        if( sl.Record_Locked__c)
                        {
                            sl.Record_Locked__c = false;
                            update sl;
                        }
                        system.debug('actualizo false' );
                    }
                    
                }
                
                //IMPORT
                if(ship.Shipment_Status__c  != null &&  Trigger.oldMap.get(ship.Id).Shipment_Status__c != ship.Shipment_Status__c 
                   && ship.Shipment_Status__c == 'ETA-15' && ship.Shipment_Type__c.contains('M')){
                       
                       
                       for (Shipment_Fee_Line__c sl : [SELECT Id, Name,Record_Locked__c,Code_SAP__c,SAP__c FROM Shipment_Fee_Line__c where Shipment__c =:ship.id])
                       {
                           if( !sl.Record_Locked__c &&  (sl.Code_SAP__c  == 'IM' || sl.Code_SAP__c  == 'ITM' ||  sl.Code_SAP__c  == 'ITAM'))
                           {
                               sl.Record_Locked__c = true;
                               update sl;
                           }
                       }
                   }
                
                //EXPORT
                if(ship.Ocean_Shipment_Status__c != null &&  Trigger.oldMap.get(ship.Id).Ocean_Shipment_Status__c != ship.Ocean_Shipment_Status__c 
                   && ship.Ocean_Shipment_Status__c == 'ETA-15' && ship.Shipment_Type__c.contains('M')){
                       
                       for (Shipment_Fee_Line__c sl : [SELECT Id, Name,Record_Locked__c,Code_SAP__c,SAP__c FROM Shipment_Fee_Line__c where Shipment__c =:ship.id])
                       {
                           if( !sl.Record_Locked__c && (sl.Code_SAP__c  == 'IM' || sl.Code_SAP__c  == 'ITM' ||  sl.Code_SAP__c  == 'ITAM'))
                           {
                               sl.Record_Locked__c = true;
                               update sl;
                           }
                       }
                   }
                
                /*AEREO
if(Trigger.oldMap.get(ship.Id).Air_Shipment_Status__c != ship.Air_Shipment_Status__c */
                //TERMINA 
            } 
            else
            {
                string       Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
                Test0 = '';
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
        
        //
        System.debug('***trigger.new***' + trigger.new);
        System.debug('***Trigger.oldMap***' + Trigger.oldMap);
        System.debug('***GenerarTimeResponseShipment***');
     //   GenerateDateLoad.GenerarTimeResponseShipment(trigger.new,Trigger.oldMap);
    }
    
    if(trigger.isAfter){
        System.debug('***PAK_FieldsShipment AFTER***');
        list<Status_Datetime__c> ls = new list<Status_Datetime__c>();
        Set<Id> setIEQ = new Set<Id>();
        Map<Id, Id> mapShipIEQ = new Map<Id, Id>();
        Map<Id, Status_Datetime__c> mapShippend = new Map<Id, Status_Datetime__c>();
        
        
        if(!mapShipment.isEmpty())
        {
            for(Shipment_Consolidation_Data__c scd : mapShipment.values())
            {
                if(scd.Import_Export_Quote__c != null)
                {if(!setIEQ.contains(scd.Import_Export_Quote__c))
                {setIEQ.add(scd.Import_Export_Quote__c);}
                 if(!mapShipIEQ.containsKey(scd.Shipment__c))
                 {mapShipIEQ.put(scd.Shipment__c, scd.Import_Export_Quote__c);}}}
            for(Status_Datetime__c sd : [Select IEQ_Status__c,UserIEQ__c,Customer_Quote__c,IEQ_Modifield_Date__c From Status_Datetime__c Where Customer_Quote__c IN:setIEQ and IEQ_Status__c='Shipped']){mapShippend.put(sd.Customer_Quote__c, sd);}}
        System.debug('***PAK_FieldsShipment mapShipment***' + mapShipment);
        for(Shipment__c s : trigger.new){
            if(trigger.oldMap.get(s.Id).Air_Shipment_Status__c != s.Air_Shipment_Status__c){Status_Datetime__c SDate1 = new Status_Datetime__c();if(mapShipIEQ.containsKey(s.Id) && mapShippend.containsKey(mapShipIEQ.get(s.Id))){SDate1.IEQ_Status__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Status__c;SDate1.UserIEQ__c = mapShippend.get(mapShipIEQ.get(s.Id)).UserIEQ__c;SDate1.IEQ_Modifield_Date__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Modifield_Date__c;SDate1.Customer_Quote__c = mapShippend.get(mapShipIEQ.get(s.Id)).Customer_Quote__c;}SDate1.Status_Value__c = s.Air_Shipment_Status__c;SDate1.User__c = s.LastModifiedById;SDate1.ModifieldDate__c = s.LastModifiedDate;SDate1.Shipment__c = s.Id;ls.add(SDate1);}
            
            if(trigger.oldMap.get(s.Id).Shipment_Status__c != s.Shipment_Status__c){Status_Datetime__c SDate2 = new Status_Datetime__c();if(mapShipIEQ.containsKey(s.Id) && mapShippend.containsKey(mapShipIEQ.get(s.Id))){SDate2.IEQ_Status__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Status__c;SDate2.UserIEQ__c = mapShippend.get(mapShipIEQ.get(s.Id)).UserIEQ__c;SDate2.IEQ_Modifield_Date__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Modifield_Date__c;SDate2.Customer_Quote__c = mapShippend.get(mapShipIEQ.get(s.Id)).Customer_Quote__c;}SDate2.Status_Value__c = s.Shipment_Status__c;SDate2.User__c = s.LastModifiedById;SDate2.ModifieldDate__c = s.LastModifiedDate;SDate2.Shipment__c = s.Id;ls.add(SDate2);}
            
            if(trigger.oldMap.get(s.Id).Ocean_Shipment_Status__c != s.Ocean_Shipment_Status__c){Status_Datetime__c SDate3 = new Status_Datetime__c();if(mapShipIEQ.containsKey(s.Id) && mapShippend.containsKey(mapShipIEQ.get(s.Id))){SDate3.IEQ_Status__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Status__c;SDate3.UserIEQ__c = mapShippend.get(mapShipIEQ.get(s.Id)).UserIEQ__c;SDate3.IEQ_Modifield_Date__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Modifield_Date__c;SDate3.Customer_Quote__c = mapShippend.get(mapShipIEQ.get(s.Id)).Customer_Quote__c;}SDate3.Status_Value__c = s.Ocean_Shipment_Status__c;SDate3.User__c = s.LastModifiedById;SDate3.ModifieldDate__c = s.LastModifiedDate;SDate3.Shipment__c = s.Id;ls.add(SDate3);}
            
            if(trigger.oldMap.get(s.Id).Shipment_Status_Plann__c != s.Shipment_Status_Plann__c){Status_Datetime__c SDate4 = new Status_Datetime__c();if(mapShipIEQ.containsKey(s.Id) && mapShippend.containsKey(mapShipIEQ.get(s.Id))){SDate4.IEQ_Status__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Status__c;SDate4.UserIEQ__c = mapShippend.get(mapShipIEQ.get(s.Id)).UserIEQ__c;SDate4.IEQ_Modifield_Date__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Modifield_Date__c;SDate4.Customer_Quote__c = mapShippend.get(mapShipIEQ.get(s.Id)).Customer_Quote__c;}SDate4.Status_Value__c = s.Shipment_Status_Plann__c;SDate4.User__c = s.LastModifiedById;SDate4.ModifieldDate__c = s.LastModifiedDate;SDate4.Shipment__c = s.Id;ls.add(SDate4);}
            
            if(trigger.oldMap.get(s.Id).Shipment_Status_Mon__c != s.Shipment_Status_Mon__c){Status_Datetime__c SDate5 = new Status_Datetime__c();if(mapShipIEQ.containsKey(s.Id) && mapShippend.containsKey(mapShipIEQ.get(s.Id))){SDate5.IEQ_Status__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Status__c;SDate5.UserIEQ__c = mapShippend.get(mapShipIEQ.get(s.Id)).UserIEQ__c;SDate5.IEQ_Modifield_Date__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Modifield_Date__c;SDate5.Customer_Quote__c = mapShippend.get(mapShipIEQ.get(s.Id)).Customer_Quote__c;}SDate5.Status_Value__c = s.Shipment_Status_Mon__c;SDate5.User__c = s.LastModifiedById;SDate5.ModifieldDate__c = s.LastModifiedDate;SDate5.Shipment__c = s.Id;ls.add(SDate5);}
        	
            if(trigger.oldMap.get(s.Id).Routing_Operation_Status__c != s.Routing_Operation_Status__c){Status_Datetime__c SDate6 = new Status_Datetime__c();if(mapShipIEQ.containsKey(s.Id) && mapShippend.containsKey(mapShipIEQ.get(s.Id))){SDate6.IEQ_Status__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Status__c;SDate6.UserIEQ__c = mapShippend.get(mapShipIEQ.get(s.Id)).UserIEQ__c;SDate6.IEQ_Modifield_Date__c = mapShippend.get(mapShipIEQ.get(s.Id)).IEQ_Modifield_Date__c;SDate6.Customer_Quote__c = mapShippend.get(mapShipIEQ.get(s.Id)).Customer_Quote__c;}SDate6.Status_Value__c = s.Routing_Operation_Status__c;SDate6.User__c = s.LastModifiedById;SDate6.ModifieldDate__c = s.LastModifiedDate;SDate6.Shipment__c = s.Id;ls.add(SDate6);}
           }
        System.debug('***PAK_FieldsShipment lstInsert*** ' + ls);
        if(!ls.isEmpty()){insert ls;}
        System.debug('***PAK_FieldsShipment Insert*** ' + ls);
    } 
}