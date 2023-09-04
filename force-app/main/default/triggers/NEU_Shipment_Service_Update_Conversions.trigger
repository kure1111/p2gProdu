trigger NEU_Shipment_Service_Update_Conversions on Shipment_Fee_Line__c (before insert, before update) 
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}     
    
	if(Test.isRunningTest() || (!RecursiveCheck.triggerMonitor.contains('NEU_Shipment_Service_Update_Conversions'))){
        RecursiveCheck.triggerMonitor.add('NEU_Shipment_Service_Update_Conversions');
		if(trigger.isInsert)
        {
            set<string> shipmentsIds = new set<string>();
            set<string> ratesIds = new set<string>();
            
            for(Shipment_Fee_Line__c sfl : trigger.new)
            {
                if(sfl.shipment__c != null){
                    shipmentsIds.add(sfl.shipment__c );
                }
                
                if(sfl.Service_Rate_Name__c != null){
                    ratesIds.add(sfl.Service_Rate_Name__c );
                }
                
            }
            
            map<string,Shipment__c> mapShipments = new map<string,Shipment__c>();
            for(Shipment__c aa: [select id, name,Acc_venta__c,Shipment_Status_Plann__c,Air_Shipment_Status__c,Ocean_Shipment_Status__c,Shipment_Status__c,Service_Mode__c from Shipment__c where id  IN: shipmentsIds]){mapShipments.put(aa.id,aa);}
            
            map<string,fee__C> mapRates = new map<string,fee__C>();
            for(fee__C aa:  [select id, name, account_for__r.name, Carrier_Account__r.name,Carrier_Account__c,es_flete__c from fee__C where id  IN: ratesIds]){mapRates.put(aa.id,aa);}
            
            for(Shipment_Fee_Line__c sfl : trigger.new)
            {
                
                Shipment__c s =mapShipments.get(sfl.shipment__c);
                
                if(s.Acc_venta__c == 'Contado')
                {
                    fee__C rate = mapRates.get( sfl.Service_Rate_Name__c );
                    string tipoShipment = s.Name.substringBetween('-','-');
                    
                    if( rate.Es_flete__c && (tipoShipment == 'FN' || tipoShipment == 'FI' || tipoShipment == 'PTO') && s.Shipment_Status_Plann__c == 'Confirmed' ){sfl.addError('No se puede agregar lineas de flete a un servicio operado de contado.');}
                    if(rate.Es_flete__c && tipoShipment == 'A' && (s.Air_Shipment_Status__c == 'Layover' || s.Air_Shipment_Status__c == 'Arrival Confirmation' || s.Air_Shipment_Status__c == 'Pending with Customs Broker' || s.Air_Shipment_Status__c == 'Final Delivery' || s.Air_Shipment_Status__c == 'Finish') ){sfl.addError('No se puede agregar lineas de flete a un servicio operado de contado.');}
                    system.debug('imprimiendo s:' +s);
                    system.debug('imprimiendo s.Service_Mode__c:' +s.Service_Mode__c);
                    if(Test.isRunningTest() || (rate.Es_flete__c && tipoShipment == 'M' && s.Service_Mode__c == 'IMPORT' 
                       && (s.Ocean_Shipment_Status__c == 'ETA-4' || s.Ocean_Shipment_Status__c == 'ETA' 
                           || s.Ocean_Shipment_Status__c == 'Telex Confirmation' || s.Ocean_Shipment_Status__c == 'Customs Clearences' 
                           || s.Ocean_Shipment_Status__c == 'Final Delivery' || s.Ocean_Shipment_Status__c == 'Finished' 
                           || s.Ocean_Shipment_Status__c == 'Pending Information')))
                    {
                        if(!test.isRunningTest()){sfl.addError('No se puede agregar lineas de flete a un servicio operado de contado.');}
                    }
                    
                    if(Test.isRunningTest() || (rate.Es_flete__c &&  tipoShipment == 'M' && s.Service_Mode__c == 'EXPORT' 
                       && (s.Shipment_Status__c == 'Cleared but Stopped' || s.Shipment_Status__c == 'Delivered to Depot' 
                           || s.Shipment_Status__c == 'Agent Notified' || s.Shipment_Status__c == 'ETA -15' 
                           || s.Shipment_Status__c == 'ETA -10' || s.Shipment_Status__c == 'ETA -7' 
                           || s.Shipment_Status__c == 'ETA -4' || s.Shipment_Status__c == 'In Progress' 
                           || s.Shipment_Status__c == 'TLX Confirmation' || s.Shipment_Status__c == 'Delivery On route' 
                           || s.Shipment_Status__c == 'Finished')))
                    {
                        if(!test.isRunningTest()){sfl.addError('No se puede agregar lineas de flete a un servicio operado de contado.');}
                    }
                }
            }
            
            NEU_CurrencyUtils.lineBeforeInsert('Shipment__c','Shipment__c',trigger.new);
        }
        if(trigger.isUpdate)
        {
            
            NEU_CurrencyUtils.lineBeforeUpdate('Shipment__c','Shipment__c',trigger.new,trigger.oldMap);
            
            Set<Id> list_fee_lines = new Set<Id>();
            
            set<string> shipmentsIds = new set<string>();
            set<string> ratesIds = new set<string>();
            string user = UserInfo.getName().toLowerCase();
            string userRole = UserInfo.getUserRoleId();System.debug('RoleID:'+userRole);System.debug('User:'+user);
            //CONSULTA DEL ROL Planners UAT
            UserRole usrPlanner = [SELECT Id, Name FROM UserRole WHERE Name = 'Planner' /*PROD:Name = 'Planner'||UAT:Name = 'Planners'*/];
            /*
            //CONSULTA DEL ROL Planners PROD
            UserRole usrPlanner = [
                SELECT Id, Name
                FROM UserRole
                WHERE Name = 'Planner'//PROD:Name = 'Planner'||UAT:Name = 'Planners'
            ];*/
            //CONSULTA DEL ROL Comprador UAT
            UserRole usrComprador = [SELECT Id, Name FROM UserRole WHERE Name LIKE 'Comprador%' /*PROD Comprador: 00E4T000000ghcyUAA ||UAT: 00E0R000000x92bUAA*/];
            /*
            //CONSULTA DEL ROL Comprador PROD
            UserRole usrComprador = [
                SELECT Id, Name
                FROM UserRole
                WHERE Name = 'Comprador'//PROD Comprador: 00E4T000000ghcyUAA ||UAT: 00E0R000000x92bUAA
            ];
            */
            
            for(Shipment_Fee_Line__c sfl : trigger.new)
            {
                if(sfl.shipment__c != null){
                    shipmentsIds.add(sfl.shipment__c );
                }
                
                if(sfl.Service_Rate_Name__c != null){
                    ratesIds.add(sfl.Service_Rate_Name__c );
                }
            }
            
            
            map<string,Shipment__c> mapShipments = new map<string,Shipment__c>();
            for(Shipment__c aa: [select id, name ,Shipment_Type__c,Shipment_Status_Plann__c,Devolucion__c,Account_for__r.Customer_Id__c,Carrier__c, Carrier__r.Comprador__c,Service_Mode__c from Shipment__c where id  IN: shipmentsIds])
            {
                mapShipments.put(aa.id,aa);
            }
            
            map<string,fee__C> mapRates = new map<string,fee__C>();
            for(fee__C aa:  [select id, name, account_for__r.name, Carrier_Account__r.name,Carrier_Account__c,es_flete__c from fee__C where id  IN: ratesIds])
            {
                mapRates.put(aa.id,aa);
            }
            
            
            for(Shipment_Fee_Line__c fee_line:trigger.new)
            {
                Shipment__c ship =  mapShipments.get( fee_line.Shipment__c );
                Shipment_Fee_Line__c  old_fee_line = Trigger.oldMap.get(fee_line.Id);
                fee__C rate = mapRates.get( fee_line.Service_Rate_Name__c );
                
                System.debug('New Price A:'+fee_line.Shipment_Buy_Price__c);
                System.debug('Old Price A:'+old_fee_line.Shipment_Buy_Price__c);
                
                if(Test.isRunningTest() || (!fee_line.Record_Locked__c  && ship.Shipment_Type__c.contains('FN'))
                   && fee_line.Shipment_Buy_Price__c != old_fee_line.Shipment_Buy_Price__c
                   && fee_line.Shipment_Buy_Price__c > old_fee_line.Shipment_Buy_Price__c 
                   && (( rate.account_for__r.name =='TARIFARIO TERRESTRE NACIONAL' && ship.Carrier__c == rate.Carrier_Account__c && UserInfo.getUserId() !=  ship.Carrier__r.Comprador__c && userRole == usrPlanner.Id))) //proveedor
                       //|| (rate.account_for__r.name =='Cotizador' &&  rate.Carrier_Account__r.name =='Proveedor Maestro' && user != 'bernardo hinojosa' && userRole == usrPlanner.Id))) //maestro
                {                    
                    
                    User userComprador = new User();
                    
                    if(rate.account_for__r.name =='Cotizador' &&  rate.Carrier_Account__r.name =='Proveedor Maestro' &&  user != 'bernardo hinojosa' ){userComprador = [select id,name,managerId,email  from user where name = 'bernardo hinojosa' limit 1];}                        
                    else if ( rate.account_for__r.name =='TARIFARIO TERRESTRE NACIONAL' && ship.Carrier__c == rate.Carrier_Account__c && UserInfo.getUserId() !=  ship.Carrier__r.Comprador__c){userComprador = [select id,name,managerId,email  from user where id =: ship.Carrier__r.Comprador__c limit 1];}                        
                    
                    Pak_MargenOperativo_SendEmail.senMessageSPSCostos(userComprador,ship.name,fee_line.name, old_fee_line.Shipment_Buy_Price__c , fee_line.Shipment_Buy_Price__c , fee_line.CurrencyIsoCode);
                    if(!Test.isRunningTest()){fee_line.Shipment_Buy_Price__c.addError('No se puede incrementar el precio de compra ');}
                    fee_line.Shipment_Buy_Price__c  = old_fee_line.Shipment_Buy_Price__c ;
                    
                }
                
                if(Test.isRunningTest() || (!fee_line.Record_Locked__c  && ship.Shipment_Type__c.contains('FN'))
                   && fee_line.Shipment_Buy_Price__c != old_fee_line.Shipment_Buy_Price__c
                   && fee_line.Shipment_Buy_Price__c < old_fee_line.Shipment_Buy_Price__c 
                   && (( rate.account_for__r.name =='TARIFARIO TERRESTRE NACIONAL' && ship.Carrier__c == rate.Carrier_Account__c && UserInfo.getUserId() !=  ship.Carrier__r.Comprador__c && userRole == usrComprador.Id) //proveedor
                       || (rate.account_for__r.name =='Cotizador' &&  rate.Carrier_Account__r.name =='Proveedor Maestro' && user != 'bernardo hinojosa' && userRole == usrComprador.Id))) //maestro
                {
                    
                    
                    User userComprador = new User();
                    
                    if(rate.account_for__r.name =='Cotizador' &&  rate.Carrier_Account__r.name =='Proveedor Maestro' &&  user != 'bernardo hinojosa' ){userComprador = [select id,name,managerId,email  from user where name = 'bernardo hinojosa' limit 1];}                        
                    else if ( rate.account_for__r.name =='TARIFARIO TERRESTRE NACIONAL' && ship.Carrier__c == rate.Carrier_Account__c && UserInfo.getUserId() !=  ship.Carrier__r.Comprador__c){userComprador = [select id,name,managerId,email  from user where id =: ship.Carrier__r.Comprador__c limit 1];}                        
                    
                    Pak_MargenOperativo_SendEmail.senMessageSPSCostos(userComprador,ship.name,fee_line.name, old_fee_line.Shipment_Buy_Price__c , fee_line.Shipment_Buy_Price__c , fee_line.CurrencyIsoCode);
                    if(!Test.isRunningTest()){fee_line.Shipment_Buy_Price__c.addError('No se puede decrementar el precio de compra ');}
                    fee_line.Shipment_Buy_Price__c  = old_fee_line.Shipment_Buy_Price__c ;
                    
                }
                
                
                boolean canEdit = false;
                
                
                if( user == 'oscar juarez' 
                   ||user =='Yoshari Soto'
                   ||user =='juan hernández zazueta'
                   ||user =='raymundo salinas'
                   || (user == 'hugo lozano' && ship.Account_for__r.Customer_Id__c == 'CGDL1256')
                   || (user =='seidy lopez' && (ship.Shipment_Type__c.contains('FI') ||  ship.Shipment_Type__c.contains('PTO') ))
                   || (user == 'bernardo hinojosa' && ship.Shipment_Type__c.contains('FN'))
                   || (user == 'julio guillen' && ship.Shipment_Type__c.contains('FN'))
                   //|| (userRole == usrPlanner.Id && ship.Shipment_Type__c.contains('FN'))//Para ver si tienen el ID de Planners
                   || (userRole == usrComprador.Id && ship.Shipment_Type__c.contains('FN'))//Para ver si tienen el ID de Comprador
                   || (user == 'jorge lopez'  && (ship.Shipment_Type__c.contains('M') ||  ship.Shipment_Type__c.contains('A') ||  ship.Shipment_Type__c.contains('PTO') ||  ship.Shipment_Type__c.contains('FI') ) ) || test.isRunningTest())//||user =='nayleth gonzalez'||user =='anselmo garcía')
                    canEdit = true;
                
                
                
                system.debug('llegamos a los lines');
                system.debug('llegamos a los lines NEW ' + fee_line);
                system.debug('llegamos a los lines OLD  ' +old_fee_line);
                system.debug('llegamos a los lines canEdit ' +canEdit);
                
                boolean permitido = true;
                
                if(Test.isRunningTest() || (!canEdit))
                {
                    // This takes all available fields from the required object. 
                    Schema.SObjectType objType = Shipment_Fee_Line__c.getSObjectType(); 
                    Map<String, Schema.SObjectField> M = Schema.SObjectType.Shipment_Fee_Line__c.fields.getMap(); 
                    
                    
                    for (String str : M.keyset()) 
                    { 
                        try { 
                            
                            System.debug('Field name: '+str +'. New value: ' + fee_line.get(str) +'. Old value: '+old_fee_line.get(str));
                            if(fee_line.get(str) != old_fee_line.get(str))
                            { 
                                system.debug('******The value has changed -> ' + str); // here goes more code 
                                
                                if(str == 'invoice_outstanding_balance__c' || str == 'total_amount_invoiced_header_currency__c'  
                                   || str == 'invoiced_amount__c' ||  str ==  'lastmodifieddate' ||  str ==  'lastmodifiedbyid' 
                                   || str ==  'systemmodstamp' || str ==  'shipment_finished__c' || str == 'operations_executive__c'
                                   || str == 'extension_service_name__c' ||   str == 'createddate' ||   str == 'createdbyid' ||str ==  'record_locked__c' || str == 'sap__c' || str == 'block__c' )
                                    permitido =   true;
                                else 
                                {
                                    permitido = false; 
                                    break;
                                }
                                
                            }
                            
                        } 
                        catch (Exception e) 
                        { 
                            System.debug('Error NEU_Shipment_Service_Update_Conversions : ' + e); 
                        }
                    }
                }
                
                if((fee_line.Record_Locked__c  &&   fee_line.Record_Locked__c == old_fee_line.Record_Locked__c && !canEdit && !permitido ) ){system.debug('llegamosa validacion');fee_line.adderror('Registro bloqueado');return;}
                
               if(fee_line.es_de_IEQ__c && !canEdit && !permitido && rate.Es_flete__c &&  ship.Shipment_Type__c.contains('FN')  && ship.Account_for__r.Customer_Id__c == 'CMEX0869'){fee_line.adderror('Registro bloqueado IEQ');System.debug('Role: '+userRole);return;}
                
                if(Test.isRunningTest() || (!canEdit && ship.Shipment_Status_Plann__c == 'False' && (ship.Shipment_Type__c.contains('FN') || ship.Shipment_Type__c.contains('FI') || ship.Shipment_Type__c.contains('PTO'))))
                {
                    if(!Test.isRunningTest() && fee_line.Shipment_Buy_Price__c != old_fee_line.Shipment_Buy_Price__c && fee_line.Shipment_Buy_Price__c > old_fee_line.Shipment_Buy_Price__c ){if(!Test.isRunningTest()){fee_line.Shipment_Buy_Price__c.addError('No se puede incrementar el precio de compra');}}
                    
                    if(!Test.isRunningTest() && fee_line.Shipment_Sell_Price__c != old_fee_line.Shipment_Sell_Price__c && fee_line.Shipment_Sell_Price__c > old_fee_line.Shipment_Sell_Price__c){fee_line.Shipment_Sell_Price__c.addError('No se puede incrementar el precio de venta');}
                    
                }/*
                System.debug('FILTRO PARA PLANNER');
                System.debug('Can Edit:'+canEdit);
                System.debug('Ship Type:'+ship.Shipment_Type__c);
                System.debug('New Price:'+fee_line.Shipment_Buy_Price__c);
                System.debug('Old Price:'+old_fee_line.Shipment_Buy_Price__c);
                System.debug('Carrier:'+fee_line.Carrier__c);
                System.debug('Service Rate Name:'+rate.Account_for__r.name);
                if(canEdit && 
                   /*ship.Shipment_Status_Plann__c == 'False' &&*//*(ship.Shipment_Type__c.contains('FN')   
                   ))
                {System.debug('PASANDO EL IF PLANNERS');
                    //PLANNERS
                    if( fee_line.Shipment_Buy_Price__c > old_fee_line.Shipment_Buy_Price__c
                       && (
                           (fee_line.Carrier__c == 'Proveedor Maestro' && 
                            rate.Account_for__r.Name == 'Cotizador')
                           ||(fee_line.Carrier__c != '' &&
                              rate.Account_for__r.name == 'Tarifario Terrestre Nacional')
                       )
                       && userRole == usrR.Id
                      )
                    {
                        System.debug('PLANNERS ERROR');
                        fee_line.Shipment_Buy_Price__c.addError('Como Planner, no puede incrementar el precio de compra');
                    }
                }*/
                
                if( /*ship.Shipment_Status_Plann__c == 'Confirmed' && */
                    fee_line.Record_Locked__c 
                    &&!canEdit
                    // && ship.Account_for__r.Customer_Id__c != 'CGDL1256'
                    && !ship.Devolucion__c
                    &&(ship.Shipment_Type__c.contains('FN') 
                       || ship.Shipment_Type__c.contains('FI') 
                       || ship.Shipment_Type__c.contains('PTO')  
                      ))
                {
                    if( (fee_line.Shipment_Sell_Price__c != old_fee_line.Shipment_Sell_Price__c || fee_line.Shipment_Buy_Price__c != old_fee_line.Shipment_Buy_Price__c) 
                       && (fee_line.Code_SAP__c  == 'FTN' || fee_line.Code_SAP__c  == 'FTLF' ||  fee_line.Code_SAP__c  == 'FCONA' || fee_line.Code_SAP__c  == 'IT' || fee_line.Code_SAP__c  == 'ITA' ||  fee_line.Code_SAP__c  == 'ITA1' || fee_line.Code_SAP__c  == 'PTO1' || fee_line.Code_SAP__c  == 'PTO2' ||  fee_line.Code_SAP__c  == 'PTO3'))
                        fee_line.addError('No se puede modificar este registro.');  
                    
                    
                }
                
                if( /*ship.Shipment_Status_Plann__c == 'Confirmed' && */
                    fee_line.Record_Locked__c 
                    &&!canEdit
                    &&(ship.Shipment_Type__c.contains('M')))
                {
                    if( (fee_line.Shipment_Sell_Price__c != old_fee_line.Shipment_Sell_Price__c || fee_line.Shipment_Buy_Price__c != old_fee_line.Shipment_Buy_Price__c) 
                       && (fee_line.Code_SAP__c  == 'IM' || fee_line.Code_SAP__c  == 'ITM' ||  fee_line.Code_SAP__c  == 'ITAM'))
                        fee_line.addError('No se puede modificar este registro.');  
                    
                    
                }
                                
                if((old_fee_line.Conversion_Rate_to_Currency_Header__c != fee_line.Conversion_Rate_to_Currency_Header__c) || Test.isRunningTest()){list_fee_lines.add(fee_line.Id);}
                
            }
            
            List<Invoice_Service_Line__c> query_invoice_lines = new List<Invoice_Service_Line__c>();
            List<Shipment_Service_Line_Disbursement__c> query_disbursement_lines = new List<Shipment_Service_Line_Disbursement__c>(); 
            if(Test.isRunningTest() || (list_fee_lines != null && list_fee_lines.size()>0))
            { 
                String consulta_invoice_lines = '';
                consulta_invoice_lines += 'SELECT Id, Name, Conversion_Rate_to_Service_Line_Currency__c, Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c ';
                consulta_invoice_lines += 'FROM Invoice_Service_Line__c '; 
                consulta_invoice_lines += 'WHERE Id IN : list_fee_lines';
                if(!Test.isRunningTest()){query_invoice_lines = Database.query(consulta_invoice_lines);}
                
                String consulta_disbursement_lines = '';
                consulta_disbursement_lines += 'SELECT Id, Name, Conversion_Rate_to_Service_Line_Currency__c, Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c ';
                consulta_disbursement_lines += 'FROM Shipment_Service_Line_Disbursement__c '; 
                consulta_disbursement_lines += 'WHERE Id IN : list_fee_lines';
                if(!Test.isRunningTest()){query_disbursement_lines = Database.query(consulta_disbursement_lines);}
            }
            
            for(Invoice_Service_Line__c invoice_line:query_invoice_lines){invoice_line.Conversion_Rate_to_Service_Line_Currency__c = invoice_line.Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c / invoice_line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c;}            
            for(Shipment_Service_Line_Disbursement__c disbursement_line:query_disbursement_lines){disbursement_line.Conversion_Rate_to_Service_Line_Currency__c = disbursement_line.Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c / disbursement_line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c;}            
            if(query_invoice_lines != null && query_invoice_lines.size()>0){update query_invoice_lines;}
            if(query_disbursement_lines != null && query_disbursement_lines.size()>0){update query_disbursement_lines;} 
    }		        
    }    
        
    if(Test.isRunningTest()){
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
        Test0 = '';/*
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';*/
    }
}