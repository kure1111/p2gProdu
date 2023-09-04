public class PAK_SalesOrder {
    public ApexPages.StandardController C {get;set;}
    Public Shipment__c SHI {get;set;}
    public String IdShipment {get;set;}
    public String TipoShipment; 
    private boolean Bandera {get;set;}
    private String Estatus {get;set;}
    public PAK_SalesOrder(ApexPages.StandardController Controller){
        if(!Test.isRunningTest()){
            C = Controller;
            SHI = (Shipment__c)Controller.getRecord();
            IdShipment = Controller.getId();   
        }
    }
    public PageReference SendWS(){
        try{
            Bandera = false;
            boolean frontera = false;
            Shipment__c S = [Select Id,Name,RecordTypeId,Account_for__r.Owner.Workplace__c,CurrencyIsoCode,Sell_Amount_Bloq__c,Shipment_Status__c,Ocean_Shipment_Status__c,Air_Shipment_Status__c,Shipment_Status_Plann__c,Account_for__r.Customer_Id__c,Account_for__r.Owner.SalesEmployer__c,Freight_Mode__c,Service_Mode__c,State_of_Load__c,State_of_Load__r.Name,State_of_Discharge__r.Name, Account_for__r.Venta_Sap__c,
                             Acuse_en_SAP__c,ShipmentLineNoSap__c,ShipmentLineSap__c,AUTORIZAR_GASTO_EXTRA__c,NotificarGastoExtra__c,Total_Services_Sell_Amount__c,OrdenVenta__c,Carrier__r.Customer_Id__c,Orden_de_Compra__c,Status_Shipment__c,Date_Receive_from_SAP__c,Plaza_Vendedor__c,Vendedor_Adicional__c,Service_Type__c, Operation_Executive__r.Name, Operation_Executive_2__r.Name, 
                             Site_of_Load__r.Frontera__c, Site_of_Discharge__r.Frontera__c, Route__r.Name,VerificacionPak__c
                             From Shipment__c 
                             Where Id=:IdShipment limit 1];
            String region = [SELECT Zona_Comercial__c FROM User WHERE Id = :UserInfo.getUserId()][0].Zona_Comercial__c;
            // EA 23/07/2019
            list<Shipment_Fee_Line__c> Lines = [SELECT Id,Name,Units__c,CurrencyIsoCode,Shipment_Sell_Price__c,Shipment_Sell_Net_Price__c,Std_Buy_Amount__c,Shipment_Buy_Price__c,Concept_1__c,SAP__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.SAP_Service_Type__r.Group__c,Service_Rate_Name__r.SAP_Service_Type__r.Name, Currency_Buy_Price__c,
                                                Conversion_Rate_to_Buy_Currency_Header__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c,Service_Rate_Name__r.Tipo_RetencionProveedores__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT__c,Service_Rate_Name__r.Carrier_Account__r.Name,SST_Orden_compra__c,SST_Estatus_orden_compra__c/*,SST_Sociedad__c*/
                                                FROM Shipment_Fee_Line__c WHERE Shipment__c=:IdShipment and SAP__c=false];
            list<Shipment_Consolidation_Data__c> Quote = [Select Id,Import_Export_Quote__r.Total_Services_Lines_Order_Amount__c From Shipment_Consolidation_Data__c where Shipment__c=:S.Id];
            TipoShipment = S.Name.substringBetween('-','-');
             Estatus = '';
            
            String WPAccOwner = S.Account_for__r.Owner.Workplace__c != null?S.Account_for__r.Owner.Workplace__c:'';
            //Set<String> plazas = new Set<String>();plazas.add('MTY');plazas.add('SAL');plazas.add('TOR');plazas.add('GDL');plazas.add('MEX');plazas.add('TOL');plazas.add('PUE');plazas.add('LEO');plazas.add('SLP');plazas.add('QUE');
            //plazas.add('TOL');plazas.add('PUE');plazas.add('VER');plazas.add('LEO');plazas.add('QUE');plazas.add('SLP');plazas.add('GDL');
            //if(WPAccOwner != '' && (!plazas.contains(WPAccOwner))){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Esta plaza no esta habilitada para enviar a SAP');ApexPages.addMessage(myMsg);return null;}
            
            /*if(plazas.contains(WPAccOwner)){
            if(S.Account_for__r.Venta_Sap__c == null || S.Account_for__r.Venta_Sap__c == ''){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Tipo de venta SAP no configurado para este cliente');ApexPages.addMessage(myMsg);return null;}
            if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Plann__c != 'Confirmed')){Bandera=true;Estatus ='para continuar debe ser Confirmed';}
            if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Plann__c != 'In Progress')){Bandera=true;Estatus ='para continuar debe ser In Progress';}
            }else{
            if((TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Plann__c != 'Confirmed')){Bandera=true;Estatus ='para continuar debe ser Confirmed';}
            }*/
            //Boolean rtiContado = [SELECT Contado_Mgm__c FROM User WHERE Id =: UserInfo.getUserId()][0].Contado_Mgm__c;
            if(S.Account_for__r.Venta_Sap__c == null || S.Account_for__r.Venta_Sap__c == ''){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Tipo de venta SAP no configurado para este cliente');ApexPages.addMessage(myMsg);return null;}
			ValidarEstatus(S);
			if(S.Site_of_Load__r.Frontera__c && S.Site_of_Discharge__r.Frontera__c){frontera = true;}            
            
            if(Bandera){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Validacion: Estatus Incorrecto '+Estatus);
                ApexPages.addMessage(myMsg);
                return null;
            }
            if(Lines.isEmpty()){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: agregar Shipment Service Lines');
                ApexPages.addMessage(myMsg);           
            }else{
                /*if(S.ShipmentLineNoSap__c > 0 && S.ShipmentLineSap__c >0 && S.AUTORIZAR_GASTO_EXTRA__c == false){
                S.NotificarGastoExtra__c = true;
                update S;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Validación: Al agregar nuevas linea de Shipment Service Lines se envia autorizar con su Gerente, por favor de esperar la autorización para volver a intentar a enviar a SAP');
                ApexPages.addMessage(myMsg);
                return null;   
                }*/
                                //Descomentar cuando se pase a producción
                                /*if(S.Total_Services_Sell_Amount__c < Quote[0].Import_Export_Quote__r.Total_Services_Lines_Order_Amount__c && S.Sell_Amount_Bloq__c==false){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Validación: Precio de venta es menor al precio de cotización para continuar regresa al Shipment y autoriza el envió en el campo: Autoriza Venta menor a Cotización y dar clic en el botón Sen to Sap de nuevo');
                ApexPages.addMessage(myMsg);
                return null;    
                }*/
                Date d = Date.today();
                String fecha = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY'); 
                String Vendedor = S.Account_for__r.Owner.SalesEmployer__c != null?S.Account_for__r.Owner.SalesEmployer__c:'';
                if(S.Vendedor_Adicional__c != null && S.Vendedor_Adicional__c != ''){
                    Vendedor+=','+S.Vendedor_Adicional__c;
                }else{
                    Vendedor+=',-1';
                }
                String Proveedor = S.Carrier__r.Customer_Id__c != null?S.Carrier__r.Customer_Id__c:'';
                String Acuse = S.Acuse_en_SAP__c == true?'1':'0';
                String Planner = S.Operation_Executive__r.Name != null ? S.Operation_Executive__r.Name:'';
                String PlannerAdicional = S.Operation_Executive_2__r.Name != null ? S.Operation_Executive_2__r.Name:'';
                String Org = '';
                String OrigenEstado = S.State_of_Load__c != null? S.State_of_Load__r.Name : S.Route__r.Name.split('-')[0].trim();
                String DestinoEstado = S.State_of_Load__c != null? S.State_of_Discharge__r.Name : S.Route__r.Name.split('-')[1].trim();
                if([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox){
                    Org = 'QA';
                }else{
                    Org = 'PROD';                    
                }                 
                String Body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                    '<soapenv:Header/>'+
                    '<soapenv:Body>'+
                    '<tem:CreateSalesOrder>'+
                    '<tem:order>'+
                    '<tem:currency>'+S.CurrencyIsoCode+'</tem:currency>'+
                    '<tem:WPAccOwner>'+WPAccOwner+'</tem:WPAccOwner>'+
                    '<tem:Fecha>'+fecha+'</tem:Fecha>'+
                    '<tem:IdShipment>'+S.Id+'</tem:IdShipment>'+
                    '<tem:CardCode>'+S.Account_for__r.Customer_Id__c+'</tem:CardCode>'+
                    '<tem:Monto>'+S.Total_Services_Sell_Amount__c+'</tem:Monto>'+
                    '<tem:Respuesta></tem:Respuesta>'+
                    '<tem:Shipment>'+S.Name+'</tem:Shipment>'+
                    '<tem:Sucursal>'+S.Plaza_Vendedor__c+'</tem:Sucursal>'+
                    '<tem:Vendedor>'+Vendedor+'</tem:Vendedor>'+
                    '<tem:OrigenEstado>'+OrigenEstado+'</tem:OrigenEstado>'+  
                    '<tem:DestinoEstado>'+DestinoEstado+'</tem:DestinoEstado>'+
                    '<tem:Proveedor>'+Proveedor+'</tem:Proveedor>'+
                    '<tem:Acuse>'+Acuse+'</tem:Acuse>'+
                    '<tem:OrdenCompra>'+S.Orden_de_Compra__c+'</tem:OrdenCompra>'+
                    '<tem:Enviado></tem:Enviado>'+
                    '<tem:DetalleSalesOrder>';
               
                
                if(!Lines.isEmpty()){
                    for(Shipment_Fee_Line__c LI: Lines){
                        LI.SAP__c = true;
                        String Unidad = LI.Units__c != null? String.valueOf(LI.Units__c):'1';
                        String ServTypeLine = LI.Service_Rate_Name__r.SAP_Service_Type__r.Name != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Name:'';
                        String Concepto = LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c:'';
                        String ItemCode = LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c:'';
                        String Vat = LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT__c : '';
                        if(ItemCode == ''){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Capturar SAP Service Type para la línea ' + LI.Name);ApexPages.addMessage(myMsg);return null;}
                        //if(frontera && TipoShipment == 'FN' && Vat != '8'){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No se puede enviar a SAP ya que el Shipment es de Frontera, la línea ' + LI.Name + ' está fuera del rango del IVA del 8%');ApexPages.addMessage(myMsg);return null;}
                        Body+=  '<tem:DetalleSalesOrder>'+
                            '<tem:ServTypeLine>'+ServTypeLine+'</tem:ServTypeLine>'+
                            '<tem:Units>'+Unidad+'</tem:Units>'+
                            '<tem:UnitPrice>'+LI.Shipment_Sell_Net_Price__c+'</tem:UnitPrice>'+
                            '<tem:VAT>'+Vat+'</tem:VAT>'+
                            '<tem:SujetoARet>'+LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c+'</tem:SujetoARet>'+
                            '<tem:TotalInclVAT>'+LI.Service_Rate_Name__r.Tipo_RetencionProveedores__c+'</tem:TotalInclVAT>'+
                            '<tem:IdShipmentLine>'+LI.Id+'</tem:IdShipmentLine>'+
                            '<tem:IdShipment>'+S.Id+'</tem:IdShipment>'+
                            '<tem:ItemCode>'+ItemCode+'</tem:ItemCode>'+
                            '<tem:Concepto>'+Concepto+'</tem:Concepto>'+
                            // nuevos campos 
                            '<tem:Carrier>'+LI.Service_Rate_Name__r.Carrier_Account__r.Name+'</tem:Carrier>'+
                            '<tem:OrdenCompra>'+LI.SST_Orden_compra__c+'</tem:OrdenCompra>'+
                            '<tem:EstatusOC>'+LI.SST_Estatus_orden_compra__c+'</tem:EstatusOC>'+
                            // '<tem:Sociedad>'+LI.SST_Sociedad__c+'</tem:Sociedad>'+
                            // EA 23/07/2019
                            '<tem:Costo>'+LI.Shipment_Buy_Price__c+'</tem:Costo>'+
                            '<tem:Currency>'+LI.CurrencyIsoCode+'</tem:Currency>'+
                            // EA 23/07/2019
                            '<tem:CurrencyCosto>' +'MXN'+ '</tem:CurrencyCosto>' +
                            '<tem:CurrencyCostoTC>' + 0 + '</tem:CurrencyCostoTC>' +
                           // '<tem:CurrencyCosto>' + LI.Currency_Buy_Price__c + '</tem:CurrencyCosto>' +
                            //'<tem:CurrencyCostoTC>' + LI.Conversion_Rate_to_Buy_Currency_Header__c.setScale(3) + '</tem:CurrencyCostoTC>' +
                            '</tem:DetalleSalesOrder>';   
                    }
                }else{
                    Body+=  '<tem:DetalleSalesOrder>'+
                        '<tem:ServTypeLine></tem:ServTypeLine>'+
                        '<tem:Units></tem:Units>'+
                        '<tem:UnitPrice></tem:UnitPrice>'+
                        '<tem:VAT></tem:VAT>'+
                        '<tem:SujetoARet></tem:SujetoARet>'+
                        '<tem:TotalInclVAT></tem:TotalInclVAT>'+
                        '<tem:IdShipmentLine></tem:IdShipmentLine>'+
                        '<tem:IdShipment></tem:IdShipment>'+
                        '<tem:ItemCode></tem:ItemCode>'+
                        '<tem:Concepto></tem:Concepto>'+
                        '<tem:Costo></tem:Costo>'+
                        '<tem:Currency></tem:Currency>'+
                        // EA 23/07/2019
                        '<tem:CurrencyCosto></tem:CurrencyCosto>' +
                        '<tem:CurrencyCostoTC></tem:CurrencyCostoTC>' +
                        '</tem:DetalleSalesOrder>';   
                }
                
                Body+='</tem:DetalleSalesOrder>'+
                    '</tem:order>'+
                    '<tem:nombreUsuario>'+UserInfo.getName()+'</tem:nombreUsuario>'+
                    '<tem:planner>'+Planner+'</tem:planner>'+
                    '<tem:plannerAdicional>'+PlannerAdicional+'</tem:plannerAdicional>'+
                    '<tem:org>'+Org+'</tem:org>'+
                    '<tem:Servicio>FLETE NACIONAL</tem:Servicio>'+
            		'<tem:Region>' + region + '</tem:Region>' +
                    '</tem:CreateSalesOrder>'+
                    ' </soapenv:Body>'+
                    '</soapenv:Envelope>';
                
                
                System.debug('-------------------'+Body);    
                string newBody = Body.replace('&','and');
                Body = newBody;
                Http httpProtocol = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('http://35.169.18.187/pakws92/WSSalesOrder.asmx');
                request.setMethod('POST');
                request.setTimeout(120000);
                request.setHeader('Content-Type', 'text/xml;charset=utf-8');
                request.setHeader('SOAPAction', 'http://tempuri.org/CreateSalesOrder');
                request.setBody(Body);
                HttpResponse response = httpProtocol.send(request);
                System.debug('-----------'+response.getBody());
                Dom.Document doc = new Dom.Document();
                doc.load(response.getBody());
                Dom.XMLNode root = doc.getRootElement();
                
                Response__c R = new Response__c();
                R.Object__c = 'Shipment';              
                R.Shipment__c = S.Id;
                R.Message_2__c = body;
                
                if(response.getStatusCode() == 200)
                {
                    R.Message__c = root.getText();
                    root = root.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
                    root = root.getChildElement('CreateSalesOrderResponse','http://tempuri.org/');
                    root = root.getChildElement('CreateSalesOrderResult','http://tempuri.org/');
                    R.Type__c = 'CONFIRM';
                    if(S.Account_for__r.Venta_Sap__c == 'Contado'){S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'Shipment_Status_Bloq_Contado' limit 1].Id;}else{S.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'ShipmentStatus' limit 1].Id;}                    
                    S.Status_Shipment__c = 'Send to Sap';
                    //if(root.getText().contains('Orden de Venta creada:')){S.OrdenVenta__c= root.getText().SubstringAfter('Orden de Venta creada:');}
                    S.Date_Receive_from_SAP__c = datetime.now();
                    S.AUTORIZAR_GASTO_EXTRA__c = false;
                    S.NotificarGastoExtra__c = false;
                    update S;
                    update Lines;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,root.getText());
                    ApexPages.addMessage(myMsg);  
                }else{
                    R.Type__c = 'ERROR';
                    R.Message__c = response.getBody()+ ' ' + response.getStatus() ;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: '+response.getBody()+ ' ' + response.getStatus() +' Favor de contactar a su administrador de SAP');
                    ApexPages.addMessage(myMsg);
                }
                insert R;    
            }
            return null;
        }catch(Exception e){
            Response__c R = new Response__c();
            R.Object__c = 'Shipment';
            R.Shipment__c = IdShipment;
            R.Message__c = e.getLineNumber()+': '+e.getMessage();
            R.Type__c = 'ERROR';
            insert R;
            if(e.getMessage().contains('Read timed out') || e.getLineNumber() > 145){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Expiro el tiempo de espera favor de revisar el shipment si se envió correctamente');
                ApexPages.addMessage(myMsg);
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Ocurrio un error al intentar enviar la información a SAP por favor comunicar a tu administrador');
                ApexPages.addMessage(myMsg);
            }
            
            System.debug(e.getLineNumber()+'------------'+e.getMessage());
            return null;
        }
    }
 public void ValidarEstatus(Shipment__c S)
 {
            // agregar campo VPC
            if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'FN' && S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False' && s.VerificacionPak__c != true){Bandera=true;Estatus ='para continuar debe ser Confirmed y estar validado por pack control';}
            if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False')){Bandera=true;Estatus ='para continuar debe ser Confirmed o False';}
            
            if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO')){
                if(S.Status_Shipment__c == 'Send to Sap' && S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False' && S.Shipment_Status_Plann__c != 'In Progress'){
                    Bandera=true;Estatus ='para continuar debe ser In Progress, Confirmed o False';
                }else if(S.Status_Shipment__c != 'Send to Sap' && S.Shipment_Status_Plann__c != 'In Progress' && S.Shipment_Status_Plann__c != 'False'){
                    Bandera=true;Estatus ='para continuar debe ser In Progress o False';
                }
            }
            
            if(S.Account_for__r.Venta_Sap__c == 'Contado' && (TipoShipment == 'FN' || TipoShipment == 'FI' || TipoShipment == 'PTO') && S.Shipment_Status_Plann__c != 'In Progress'){
                Bandera=true;Estatus ='para continuar debe ser In Progress (Contado)';
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
            // agregar campoVPC
            if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'FN' && S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False' && s.VerificacionPak__c != true ){Bandera=true;Estatus ='para continuar debe ser Confirmed y estar validado por pack control';}
            if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'FI' || TipoShipment == 'PTO') && (S.Shipment_Status_Plann__c != 'Confirmed' && S.Shipment_Status_Plann__c != 'False')){Bandera=true;Estatus ='para continuar debe ser Confirmed o False (Crédito)';}
            
            if(S.Account_for__r.Venta_Sap__c == 'Credito' && (TipoShipment == 'A') && (S.Air_Shipment_Status__c != 'Flight Confirmation' && S.Air_Shipment_Status__c != 'Layover' && S.Air_Shipment_Status__c != 'Arrival Confirmation' && S.Air_Shipment_Status__c != 'Pending with Customs Broker' && S.Air_Shipment_Status__c != 'Final Delivery' && S.Air_Shipment_Status__c != 'Finish')){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation, Layover, Arrival Confirmation, Pending with Customs Broker, Final Delivery o Finish (Crédito)';}
            
            if(S.Account_for__r.Venta_Sap__c == 'Credito' && TipoShipment == 'M' && S.Service_Mode__c == 'IMPORT' && (S.Ocean_Shipment_Status__c != 'ETD' && S.Ocean_Shipment_Status__c != 'ETA-15' && S.Ocean_Shipment_Status__c != 'ETA-10' && S.Ocean_Shipment_Status__c != 'ETA-7' && S.Ocean_Shipment_Status__c != 'ETA-4' && S.Ocean_Shipment_Status__c != 'ETA' && S.Ocean_Shipment_Status__c != 'Telex Confirmation' && S.Ocean_Shipment_Status__c != 'Customs Clearences' && S.Ocean_Shipment_Status__c != 'Final Delivery' && S.Ocean_Shipment_Status__c != 'Finished' && S.Ocean_Shipment_Status__c != 'Pending Information')){Bandera=true;Estatus ='para continuar debe ser ETD, ETA-15, ETA-10, ETA-7, ETA-4, ETA, Telex Confirmation, Customs Clearences, Final Delivery, Finished o Pending Information (Crédito)';}

            if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && S.Air_Shipment_Status__c != 'Flight Confirmation'){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation';}
            
            if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline'){Bandera=true;Estatus ='para continuar debe ser Pickup and Delivery to Airline';}
            
            if(TipoShipment == 'AW' && S.Service_Mode__c == 'IMPORT' && S.Air_Shipment_Status__c != 'Flight Confirmation'){Bandera=true;Estatus ='para continuar debe ser Flight Confirmation';}
            
            if(TipoShipment == 'AW' && S.Service_Mode__c == 'EXPORT' && S.Air_Shipment_Status__c != 'Pickup and Delivery to Airline'){Bandera=true;Estatus ='para continuar debe ser Pickup and Delivery to Airline';}
            
           // if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered'){Bandera=true;Estatus ='para continuar debe ser ETD';}
     		//if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered'){Bandera=true;Estatus ='para continuar debe ser ETD';}
           // if(TipoShipment == 'M' && S.Service_Mode__c == 'EXPORT' && S.Shipment_Status__c != 'Delivered' && S.Account_for__r.Venta_Sap__c == 'Credito' ){Bandera=true;Estatus ='para continuar debe ser ETD';}  
            
          
            
            if(TipoShipment == 'R' && S.Freight_Mode__c =='Air' && S.Air_Shipment_Status__c != 'Consigness Notification'){Bandera=true;Estatus ='para continuar debe ser Consigness Notification';}
           
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
     
            if(TipoShipment == 'R' && S.Freight_Mode__c =='Sea' && S.Ocean_Shipment_Status__c != 'ETA-15'){Bandera=true;Estatus ='para continuar debe ser ETA-15';}
                  
            if(s.Shipment_Status__c != null)
            {
                if(TipoShipment == 'W' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Shipment_Status__c)) {Bandera=true;Estatus ='para continuar debe ser Shipment_Status__c';}
                
                if(TipoShipment == 'M' && S.Service_Mode__c == 'EXPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Shipment_Status__c)  && S.Account_for__r.Venta_Sap__c == 'Credito') {Bandera=true;Estatus ='para continuar debe ser ETD';}
            }
            
            if(TipoShipment == 'W' && S.Service_Mode__c == 'IMPORT' && S.Freight_Mode__c =='Sea' && !setEstatus.contains(s.Ocean_Shipment_Status__c)) {Bandera=true;Estatus ='para continuar debe ser Ocean_Shipment_Status__c';}

 }
    public void TestMetodo(){
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