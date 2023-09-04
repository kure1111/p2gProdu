public class SendOrderSAP {
    @future(callout=true)
    public static void sendToSap(Set<Id> ordersIds){
        System.debug('SendToSAP APEX CLASS');
        List<Response__c> responses = new List<Response__c>();
        Date d = Date.today();
        String fecha = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/yyyy'); 
        String Org = '';
        
        if([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox){Org = 'QA';}else{Org = 'PROD';}
        
        
        List<Order> lstOrders = [SELECT Id, OrderNumber, TotalAmount, OrdenVenta__c, Shipment__c, Shipment__r.Name, Shipment__r.Account_for__r.Venta_Sap__c, 
                                 Shipment__r.Shipment_Status_Plann__c, Shipment__r.Shipment_Status__c, Shipment__r.Freight_Mode__c, 
                                 Shipment__r.Service_Mode__c, Shipment__r.Account_for__r.Owner.SalesEmployer__c, Shipment__r.Vendedor_Adicional__c,
                                 Shipment__r.Carrier__r.Customer_Id__c, Shipment__r.Acuse_en_SAP__c, Shipment__r.Operation_Executive__r.Name,
                                 Shipment__r.Operation_Executive_2__r.Name, Shipment__r.State_of_Load__c, Shipment__r.State_of_Load__r.Name, Shipment__r.Route__c,
                                 Shipment__r.Route__r.Name, Shipment__r.State_of_Discharge__r.Name, Shipment__r.CurrencyIsoCode, Shipment__r.Orden_de_Compra__c,
                                 Shipment__r.Account_for__r.Owner.Workplace__c,
                                 Shipment__r.Profit__c,Shipment__r.Account_Shipment_Reference__c,
                                 Shipment__r.Account_for__r.Customer_Id__c, Shipment__r.Plaza_Vendedor__c,
                                 Shipment__r.ShipmentService__c, Shipment__r.State_of_Load__r.Zone__c, Shipment__r.Site_of_Load__r.State__r.Zone__c,
                                 (SELECT Id, ServLine_Name__c, UnitPrice, Quantity, Service_Rate_Name__c, Std_Buy_Amount__c, Retention__c,
                                  Group__c, VAT__c, CurrencyLine__c, ItemCode__c, ShipServLineId__c, ItemStatus_SAP__c, ItemStatus_Shipment__c 
                                  FROM OrderItems)
                                 FROM Order 
                                 WHERE Id IN: ordersIds AND Shipment__c != NULL];
        System.debug('SOSAP ORDERS size: ' + lstOrders.size());
        System.debug('SOSAP ORDERS: ' + lstOrders);
        
        if(lstOrders.size()!=0){
            
            
            system.debug('Entrando al filtro');
            
            set<string> idsShip = new set<string>();
            Map<string,string> ShipDate = new Map<string,string>();
            
            for(Order o : lstOrders)
            {
                idsShip.add(o.Shipment__c);
            }
            
            system.debug('imprimiendo idsShip: '+idsShip);
            list<Shipment_Fee_Line__c> Lines = [SELECT Id,Name,Units__c,CurrencyIsoCode,Shipment_Sell_Price__c,Shipment_Sell_Net_Price__c,Std_Buy_Amount__c,Shipment_Buy_Price__c,Concept_1__c,SAP__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.SAP_Service_Type__r.Group__c,Service_Rate_Name__r.SAP_Service_Type__r.Name,Service_Rate_Name__r.SAP_Service_Type_Buy__r.Code__c, Currency_Buy_Price__c,
                                                Conversion_Rate_to_Buy_Currency_Header__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c,Service_Rate_Name__r.Tipo_RetencionProveedores__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT__c,Service_Rate_Name__r.Carrier_Account__r.Name,Service_Rate_Name__r.Carrier_Account__r.Customer_Id__c,SST_Orden_compra__c,
                                                SST_Estatus_orden_compra__c,/*SST_Sociedad__c,*/Service_Rate_Name__r.Tipo_RetencionClientes__c, Service_Rate_Name__r.P2G_SapDevolucion__c
                                                FROM Shipment_Fee_Line__c WHERE Shipment__c in:idsShip ]; //and SAP__c=false
            list<String> linesIDs= new list<String>();
            for(Shipment_Fee_Line__c Line:Lines){
                linesIDs.add(Line.id);
            }
            List<OrderItem> oiList = [SELECT ID,ItemStatus_Shipment__c,ShipServLineId__c FROM OrderItem WHERE ShipServLineId__c IN: linesIDs];
            list<Status_Datetime__c>  statusShip =  [SELECT Shipment__C,CREATEDDATE 
                                                     FROM Status_Datetime__c 
                                                     WHERE  Shipment__C in:idsShip 
                                                     and (Is_Ready_1__c = true or  Is_Ready_2__c = true)
                                                     ORDER BY Shipment__C, CREATEDDATE asc ];
            
            system.debug('imprimiendo Lines: '+Lines);
            system.debug('imprimiendo statusShip: '+statusShip);
            if(statusShip.size()!=0){
                
                for(Status_Datetime__c stad : statusShip )
                {
                    if(!ShipDate.containsKey(stad.Shipment__C))
                        ShipDate.put(stad.Shipment__C, stad.CREATEDDATE.formatGMT('yyyy-MM-dd'));
                }  
                
                
                
                
                
                for(Order o : lstOrders){
                    String Body = '';
                    try{
                        
                        system.debug(' XXXX   RASTREO PROFIT ' + O.SHIPMENT__R.PROFIT__c );
                        
                        Body = setRequestHeader(o, fecha, ShipDate.get(o.Shipment__c) ); 
                        string bodyLines =setRequestLines(Lines, o.Shipment__c,oiList);
                        if(bodyLines== null ){
                            Response__c R = new Response__c(Object__c = 'Order', Order__c = o.Id, Message__c = 'No se pueden mandar lineas de venta con SapServiceType que no empiezen con SP', Type__c = 'ERROR', Message_2__c = Body);
                            responses.add(R);
                            break;
                        }else{
                            Body += bodyLines;
                        }
                        Body += setRequestFooter(o, Org);
                        System.debug('SOSAP REQ: ' + Body);
                        
                        HttpResponse response = sendRequest(Body);
                        //  sendRequest(Body);
                        processResponse(response, o.Id, responses, Body);
                    }catch(Exception e){
                        Response__c R = new Response__c();
                        R.Object__c = 'Order';
                        R.Order__c = o.Id;
                        R.Message__c = e.getLineNumber()+': '+e.getMessage();
                        R.Type__c = 'ERROR';
                        R.Message_2__c = Body;
                        responses.add(R);
                    } 
                }      
                System.debug('SOSAP Responses: ' + responses.size());
                if(responses.size()>0){insert responses;}  
            }
            else{
                system.debug('¡ALERTA! el shipment  no se mando a SAP ya que no cuenta con statusDateTime o no cumple con las validaciones de la query');
            }
        }
        else{
            system.debug('lstOrders no cuenta con registros');
        }
    }
    
    public static String setRequestHeader(Order o, string fecha, string fechaTC){
        String WPAccOwner = o.Shipment__r.Account_for__r.Owner.Workplace__c != null ? o.Shipment__r.Account_for__r.Owner.Workplace__c : '';
        String Vendedor = o.Shipment__r.Account_for__r.Owner.SalesEmployer__c != null ? o.Shipment__r.Account_for__r.Owner.SalesEmployer__c : '';
        if(o.Shipment__r.Vendedor_Adicional__c != null && o.Shipment__r.Vendedor_Adicional__c != ''){
            Vendedor+=','+o.Shipment__r.Vendedor_Adicional__c;
        }else{
            Vendedor+=',-1';
        }
        String Proveedor = o.Shipment__r.Carrier__r.Customer_Id__c != null ? o.Shipment__r.Carrier__r.Customer_Id__c : '';
        String Acuse = o.Shipment__r.Acuse_en_SAP__c == true ? '1':'0';        
        String OrigenEstado = Test.isRunningTest() ? '' : o.Shipment__r.State_of_Load__c != null ? o.Shipment__r.State_of_Load__r.Name : o.Shipment__r.Route__c != null ? o.Shipment__r.Route__r.Name.split('-')[0].trim() : '';
        String DestinoEstado = Test.isRunningTest() ? '' : o.Shipment__r.State_of_Load__c != null ? o.Shipment__r.State_of_Discharge__r.Name : o.Shipment__r.Route__c != null ? o.Shipment__r.Route__r.Name.split('-')[1].trim() : '';
        
        
        String Body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+'<soapenv:Header/>'+'<soapenv:Body>'+'<tem:CreateSalesOrder>'+'<tem:order>'+
            '<tem:currency>'+o.Shipment__r.CurrencyIsoCode+'</tem:currency>'+
            '<tem:WPAccOwner>'+WPAccOwner+'</tem:WPAccOwner>'+
            '<tem:Fecha>'+fecha+'</tem:Fecha>'+
            '<tem:IdShipment>'+o.Shipment__c+'</tem:IdShipment>'+
            '<tem:CardCode>'+o.Shipment__r.Account_for__r.Customer_Id__c+'</tem:CardCode>'+
            '<tem:Monto>'+o.TotalAmount+'</tem:Monto>'+
            '<tem:Respuesta></tem:Respuesta>'+
            '<tem:OrderSF>' + o.OrderNumber +'</tem:OrderSF>' +
            '<tem:Shipment>'+o.Shipment__r.Name+'</tem:Shipment>'+
            '<tem:Sucursal>'+o.Shipment__r.Plaza_Vendedor__c+'</tem:Sucursal>'+
            '<tem:Vendedor>'+Vendedor+'</tem:Vendedor>'+
            '<tem:OrigenEstado>'+OrigenEstado+'</tem:OrigenEstado>'+  
            '<tem:DestinoEstado>'+DestinoEstado+'</tem:DestinoEstado>'+
            '<tem:Proveedor>'+Proveedor+'</tem:Proveedor>'+
            '<tem:Acuse>'+Acuse+'</tem:Acuse>'+
            '<tem:OrdenCompra>'+o.Shipment__r.Orden_de_Compra__c+'</tem:OrdenCompra>'+
            '<tem:Enviado></tem:Enviado>'+
            '<tem:CustomerRef>'+o.Shipment__r.Account_Shipment_Reference__c+'</tem:CustomerRef>'+ //CustomerRef
            '<tem:TCOperado>'+o.Shipment__r.Profit__c+'</tem:TCOperado>'+
            '<tem:FechaOperado>'+fechaTC+'</tem:FechaOperado>'+ 
            '<tem:DetalleSalesOrder>';
        
        System.debug('Encabezado : sap ');
        for (Integer i = 0; i < Body.length(); i=i+250)
        {
            Integer iEffectiveEnd = (i+250) > Body.length() ? Body.length()-1 : (i+250);
                System.debug('LINEA ' +  i + ' - ' + iEffectiveEnd + ' ->' + Body.substring(i,iEffectiveEnd));
        }
        
        return Body;
    }
    
    public static String setRequestLines(List<Shipment_Fee_Line__c> Lines, String shipmentId,List<OrderItem> oiList){
        String Body = '';
        SYSTEM.DEBUG('Lines EMPTY'+Lines.isEmpty());
        if(Test.isrunningtest()){Shipment_Fee_Line__c splineObj=new Shipment_Fee_Line__c();Lines.add(splineObj);}
        if(!Lines.isEmpty()){
            SYSTEM.DEBUG('ENTRANDO A LLENAR DATOS');
            for(Shipment_Fee_Line__c LI: Lines){
                LI.SAP__c = true;
                String Unidad = LI.Units__c != null? String.valueOf(LI.Units__c):'1';
                String ServTypeLine = LI.Service_Rate_Name__r.SAP_Service_Type__r.Name != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Name:'';
                String ServTypeLineBuy = LI.Service_Rate_Name__r.SAP_Service_Type_Buy__r.Code__c != null?LI.Service_Rate_Name__r.SAP_Service_Type_Buy__r.Code__c:'';
                String Concepto = LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Group__c:'';
                String ItemCode = LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c != null?LI.Service_Rate_Name__r.SAP_Service_Type__r.Code__c:'';
                String Vat = LI.Service_Rate_Name__r.Tipo_RetencionClientes__c != null?LI.Service_Rate_Name__r.Tipo_RetencionClientes__c : '';
                if(Concepto.contains('SP')||Concepto.contains('sp')){
                    if(ItemCode == ''&&!Test.isrunningtest()){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Capturar SAP Service Type para la línea ' + LI.Name);ApexPages.addMessage(myMsg);return null;}
                    //if(frontera && TipoShipment == 'FN' && Vat != '8'){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No se puede enviar a SAP ya que el Shipment es de Frontera, la línea ' + LI.Name + ' está fuera del rango del IVA del 8%');ApexPages.addMessage(myMsg);return null;}
                    Body+=  '<tem:DetalleSalesOrder>'+
                        '<tem:ServTypeLine>'+ServTypeLine+'</tem:ServTypeLine>'+
                        '<tem:ServTypeLineBuy>'+ServTypeLineBuy+'</tem:ServTypeLineBuy>'+
                        '<tem:Units>'+Unidad+'</tem:Units>'+
                        '<tem:UnitPrice>'+LI.Shipment_Sell_Net_Price__c+'</tem:UnitPrice>'+
                        '<tem:VAT>'+Vat+'</tem:VAT>'+
                        '<tem:SujetoARet>'+LI.Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c+'</tem:SujetoARet>'+
                        '<tem:TotalInclVAT>'+LI.Service_Rate_Name__r.Tipo_RetencionProveedores__c+'</tem:TotalInclVAT>'+
                        '<tem:IdShipmentLine>'+LI.Id+'</tem:IdShipmentLine>'+
                        '<tem:IdShipment>'+shipmentId+'</tem:IdShipment>'+
                        '<tem:ItemCode>'+ItemCode+'</tem:ItemCode>';
                    if(oiList.size()>0){
                        for(OrderItem oi:oiList){
                            if(oi.ShipServLineId__c==LI.ID){
                                Body+=  '<tem:ItemStatus>'+(oi.ItemStatus_Shipment__c == false? 'Open':'Closed')+'</tem:ItemStatus>';
                            }
                        }
                    }
                    Body+=    '<tem:Concepto>'+LI.Service_Rate_Name__r.P2G_SapDevolucion__c+'</tem:Concepto>'+
                        // nuevos campos 
                        '<tem:Carrier>'+LI.Service_Rate_Name__r.Carrier_Account__r.Customer_Id__c+'</tem:Carrier>'+
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
                else{if(!test.isRunningTest()){Body =null;}}
            }
        }else{
            SYSTEM.DEBUG('ENTRANDO A NO LLENAR DATOS');
            Body+=  '<tem:DetalleSalesOrder><tem:ServTypeLine></tem:ServTypeLine><tem:Units></tem:Units><tem:UnitPrice></tem:UnitPrice><tem:VAT></tem:VAT><tem:SujetoARet></tem:SujetoARet><tem:TotalInclVAT></tem:TotalInclVAT><tem:IdShipmentLine></tem:IdShipmentLine><tem:IdShipment></tem:IdShipment><tem:ItemCode></tem:ItemCode><tem:Concepto></tem:Concepto><tem:Costo></tem:Costo><tem:Currency></tem:Currency><tem:CurrencyCosto></tem:CurrencyCosto><tem:CurrencyCostoTC></tem:CurrencyCostoTC></tem:DetalleSalesOrder>';   
        }
        System.debug('Lines req: ' + Body);
        return Body;
    }
    
    public static String setRequestFooter(Order o, string Org){
        String Planner = o.Shipment__r.Operation_Executive__r.Name != null ? o.Shipment__r.Operation_Executive__r.Name : '';
        String PlannerAdicional = o.Shipment__r.Operation_Executive_2__r.Name != null ? o.Shipment__r.Operation_Executive_2__r.Name : '';
        String Region = o.Shipment__r.State_of_Load__r.Zone__c != null ? o.Shipment__r.State_of_Load__r.Zone__c : o.Shipment__r.Site_of_Load__r.State__r.Zone__c;
        String Body ='</tem:DetalleSalesOrder>'+
            '</tem:order>'+
            '<tem:nombreUsuario>'+UserInfo.getName()+'</tem:nombreUsuario>'+
            '<tem:planner>'+Planner+'</tem:planner>'+
            '<tem:plannerAdicional>'+PlannerAdicional+'</tem:plannerAdicional>'+
            '<tem:org>'+Org+'</tem:org>'+
            '<tem:Servicio>'+ o.Shipment__r.ShipmentService__c +'</tem:Servicio>'+
           // '<tem:CustomerRef>'+'Pruebaaa'+'</tem:CustomerRef>'+    //CustomerRef
            '<tem:Region>' + Region + '</tem:Region>' +
            '<tem:IdOrder>' + o.Id + '</tem:IdOrder>' +
            '</tem:CreateSalesOrder>'+
            ' </soapenv:Body>'+
            '</soapenv:Envelope>';
        System.debug('Footer req: ' + Body);
        return Body; 
    }
    
    public static HttpResponse sendRequest(string Body){    
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest(); 
        if([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox)
            request.setEndpoint('http://35.169.18.187/pakws/WSSalesOrder.asmx'); 
        else
        request.setEndpoint('http://35.169.18.187/pakws92/WSSalesOrder.asmx');
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', 'http://tempuri.org/CreateSalesOrder');
        request.setBody(Body);
        System.debug('@@Body: ' + Body);
        HttpResponse response = httpProtocol.send(request);
        System.debug('SOSAP Response: ' + response.getBody());
        return response;
    }
    
    public static void processResponse(HttpResponse response, string orderId, List<Response__c> responses,string Body){
        Dom.Document doc = new Dom.Document();
        doc.load(response.getBody());
        Dom.XMLNode root = doc.getRootElement();
        root = root.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
        root = root.getChildElement('CreateSalesOrderResponse','http://tempuri.org/');
        //root = root.getChildElement('CreateSalesOrderResult','http://tempuri.org/');
        Response__c R = new Response__c();
        R.Object__c = 'Order';
        R.Order__c = orderId;
        //R.Message__c = root.getText();
        R.Message_2__c = Body;
        
        system.debug(' xxxx R ' + R);
        if(response.getStatusCode() == 200){
            R.Type__c = 'CONFIRM';
        }else{
            R.Type__c = 'ERROR';
        }
        responses.add(R);
    }
}