global class PAK_WSMESSAGES {
	global class MESSAGE{
        webservice String Shipment {get;set;}
        webservice String Account {get;set;}
        webservice String Invoice {get;set;}
        webservice String Disbursement {get;set;}
        webservice String Order {get;set;}
        webservice String ShipmentLine {get;set;}
        webservice String Message {get;set;}
    }
    webservice static list<status> SFMESSAGES(MESSAGE[] lsEntity){
        list<status> result = new list<status>();
        Response__c RES = new Response__c();
       	Boolean Bandera = true;
        try{
            for(MESSAGE R: lsEntity){
                list<Shipment__c> S = new list<Shipment__c>();
                List<Order> order = [SELECT Id, OrdenVenta__c, Solicitud_compra__c FROM Order WHERE Id=:R.Order LIMIT 1];
                List<OrderItem> orderItems = [SELECT Id, ShipServLineId__c, ItemStatus_SAP__c FROM OrderItem WHERE ShipServLineId__c=:R.ShipmentLine LIMIT 1];
                list<Shipment_Disbursement__c> DISBURSEMENT = new list<Shipment_Disbursement__c>();
                list<Invoice__c> INVOICE = new list<Invoice__c>();
                S = [Select Id,RecordTypeId,AUTORIZAR_GASTO_EXTRA__c,NotificarGastoExtra__c,Status_Shipment__c,OrdenVenta__c,Date_Receive_from_SAP__c,SolicitudCompra__c, Account_for__r.Venta_Sap__c From Shipment__c Where Id=:R.Shipment];
                DISBURSEMENT = [Select Id,Name,Etapa__c,RecordTypeId,OrdenCompra__c,Disbursement_Status__c, Date_Receive_from_SAP__c, Total_Invoice_SAP__c, Total_Excl_VAT__c from Shipment_Disbursement__c Where Id=:R.Disbursement limit 1];
                INVOICE = [Select Id, Name, RecordTypeId, Date_Receive_from_SAP__c, Invoice_Status__c, FolioEntrega__c, Total_Invoice_SAP__c, Total_Excl_VAT__c,Shipment__c from Invoice__c Where Id=:R.Invoice limit 1];
                         
                if(R.Order != null && R.Message.contains('Solicitud de Compra creada:')){
                    //S[0].SolicitudCompra__c = R.Message.SubstringAfter('Solicitud de Compra Creada:');
                    //update S[0];
                    order[0].Solicitud_compra__c = R.Message.SubstringAfter('Solicitud de Compra creada:');
                    System.debug('To updt order');
                    update order[0];
                    System.debug('order updated');
                    Bandera = false;
                }
                RES.Type__c = 'CONFIRM';
                RES.Message__c = R.Message;
                if(R.Message.contains('Open') || R.Message.contains('Closed')){
                    Bandera = false;
                    Boolean value = R.Message == 'Open' ? false : true;
                    orderItems[0].ItemStatus_SAP__c = value;
                    update orderItems[0];
                    RES.Message__c = R.ShipmentLine + ' - ' + R.Message;
                }
                if(R.Message.contains('Orden de Venta creada')){
                    Bandera = false;
                    /*if(R.Shipment != null && (S[0].OrdenVenta__c == null || S[0].OrdenVenta__c == '')){
                        S[0].RecordTypeId = [Select Id From RecordType Where DeveloperName = 'ShipmentStatus' limit 1].Id;
                        S[0].Status_Shipment__c = 'Send to Sap';
                        //S[0].OrdenVenta__c= R.Message.SubstringAfter('Orden de Venta creada:');
                        S[0].OrdenVenta__c = R.Message.substringBetween('Orden de Venta creada:', 'Orden de Compra creada:');
                        S[0].Date_Receive_from_SAP__c = datetime.now();
                        S[0].AUTORIZAR_GASTO_EXTRA__c = false;
                        S[0].NotificarGastoExtra__c = false;
                        update S[0];                        
                    }*/
                    if(R.Order != null && (order[0].OrdenVenta__c == null || order[0].OrdenVenta__c == '')){
                        order[0].OrdenVenta__c = R.Message.substringAfter('Orden de Venta creada:');
                        order[0].Date_Receive_from_SAP__c = datetime.now();
                        update order[0];
                    }
                }
                if(R.Message.contains('Orden de Compra Creada')){
                    Bandera = false;
                    if(DISBURSEMENT[0].OrdenCompra__c == null || DISBURSEMENT[0].OrdenCompra__c == ''){
                    	DISBURSEMENT[0].RecordTypeId = [Select Id From RecordType Where DeveloperName = 'DisbursementStatus' limit 1].Id;
                        DISBURSEMENT[0].Disbursement_Status__c = 'Send to Sap';
                        DISBURSEMENT[0].Etapa__c ='En Proceso';
                        DISBURSEMENT[0].Date_Receive_from_SAP__c = Datetime.now();
                        DISBURSEMENT[0].OrdenCompra__c = R.Message.SubstringAfter('Orden de Compra Creada: ');
                        update DISBURSEMENT[0];
                    }
                }
                
                if(R.Message.contains('Entrega Creada No.')){
                    Bandera = false;
                    if(INVOICE[0].FolioEntrega__c == null || INVOICE[0].FolioEntrega__c == ''){
                    	INVOICE[0].RecordTypeId = [Select Id From RecordType Where DeveloperName = 'InvoiceStatus' limit 1].Id;
                        INVOICE[0].Invoice_Status__c = 'Send to Sap';
                        INVOICE[0].Date_Receive_from_SAP__c = Datetime.now();
                        INVOICE[0].FolioEntrega__c = R.Message.SubstringAfter('Entrega Creada No. : ');
                        update INVOICE[0];
                    }
                }
                
                if(R.message.contains('Pago efectuado')){
                    Bandera = false;
                    DISBURSEMENT[0].Total_Invoice_SAP__c = (DISBURSEMENT[0].Total_Invoice_SAP__c == null ? 0 : DISBURSEMENT[0].Total_Invoice_SAP__c) + Decimal.valueOf(R.Message.SubstringAfter('Monto de: '));
                    if(DISBURSEMENT[0].Total_Excl_VAT__c > DISBURSEMENT[0].Total_Invoice_SAP__c){
                        DISBURSEMENT[0].Etapa__c = 'Parcialidad';
                        update DISBURSEMENT[0];
                    }else if(DISBURSEMENT[0].Total_Excl_VAT__c <= DISBURSEMENT[0].Total_Invoice_SAP__c){
                        DISBURSEMENT[0].Etapa__c = 'Pagado';
                        update DISBURSEMENT[0];
                    }
                }
                
                if(R.message.contains('Devolucion')){
                    
                    list<Invoice_Service_Line__c> lslines = new list<Invoice_Service_Line__c>();
                    lslines = [Select Id From Invoice_Service_Line__c Where Invoice__c=:INVOICE[0].Id];
                    delete lslines;
                    
                    INVOICE[0].Invoice_Status__c = 'Cancel';
                    update INVOICE[0];
               
                }
                if(R.message.contains('Pago recibido')){
                    INVOICE[0].Total_Invoice_SAP__c = (INVOICE[0].Total_Invoice_SAP__c == null ? 0 : INVOICE[0].Total_Invoice_SAP__c) + Decimal.valueOf(R.Message.SubstringAfter('Monto de: '));
                     if(INVOICE[0].Total_Excl_VAT__c > INVOICE[0].Total_Invoice_SAP__c){
                        INVOICE[0].Invoice_Status__c = 'Cobrado parcial';
                        update INVOICE[0];
                    }else if(INVOICE[0].Total_Excl_VAT__c <= INVOICE[0].Total_Invoice_SAP__c){
                        INVOICE[0].Invoice_Status__c = 'Cobrado';
                        update INVOICE[0];
                    }
               
                }
                
                if(R.message.contains('Proveedor creado en SAP')){
                    List<Account> prov = [SELECT Id, Customer_Id__c FROM Account WHERE Id=:R.Account];
                    prov[0].Customer_Id__c = R.message.substringAfter('CardCode:');
                    update prov[0];
                }
                
                if(R.message.contains('Lead Creado No')){
                    //String rtCustomer = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'Customer'][0].Id;
                    List<Account> acct = [SELECT Id, Customer_Id__c FROM Account WHERE Id=:R.Account];
                    acct[0].Customer_Id__c = R.message.substringAfter('Lead Creado No. :');
                    //acct[0].RecordTypeId = rtCustomer;
                    update acct[0];
                }
                
                 if(R.Message.contains('CARTA PORTE') && !R.Message.contains('ERROR'))
                 {
                    Bandera = false;
                     
                                     String[] arrTest = R.Message.split('>');
                    
                     if(arrTest.size()>0 && arrTest.size()>6)
                     {
                         string xml = '';
                         string UUID = '';
                         string qr = '';
                         string sello = '';
                         string fechaTFD = '';
                         string cadena = '';
                         
                         xml = arrTest[1].replace('UUID','').trim();
                         UUID = arrTest[2].replace('QR','').trim();
                         QR = arrTest[3].replace('SELLO','').trim();
                         sello = arrTest[4].replace('SELLO ORGINAL','').trim();
                         cadena = arrTest[5].replace('FECHA','').trim();
                         fechaTFD = arrTest[6].trim();
                         
                         String dtString = fechaTFD.replace('T', ' ');
                         
                         // Convert the string to DateTime
                         DateTime dt = DateTime.valueOf(dtString);  
                         
                         Carta_Porte__c cpn = new Carta_Porte__c();
                         cpn.XML__c = xml;
                         cpn.QR__c = qr;
                         cpn.Sello_TFD__c = sello;
                         cpn.Fecha_TFD__c = dt;
                         cpn.UUID_TFD__c = uuid;
                         cpn.Cadena_Original__c = cadena;
                         cpn.Shipment__c = INVOICE[0].shipment__C;
                         cpn.Tipo__c = 'Ingreso';
                         //  cpn.PDF_Url__c = pdfName;
                         insert cpn;
                         
                     }
                   
                     
                }
                
                if(R.Shipment != null & R.Shipment != ''){RES.Shipment__c = R.Shipment;RES.Object__c='Shipment';}
                if(R.Order != null & R.Order != ''){RES.Order__c = R.Order;RES.Object__c='Order';}
                if(R.Account != null & R.Account != ''){RES.Account__c = R.Account;RES.Object__c='Account';}
                if(R.Invoice != null & R.Invoice != ''){RES.Invoice__c = R.Invoice;RES.Object__c='Invoice';}
                if(R.ShipmentLine != null & R.ShipmentLine != ''){RES.Object__c='ShipmentLine';}
                if(R.Disbursement != null & R.Disbursement != ''){RES.Disbursement__c = R.Disbursement;RES.Object__c='Disbursement';}
                if(Bandera == false){insert RES;}
                status st = new status();
                st.code = '1';
                st.Existe = 'NO';
                st.message = 'Exitoso- se consulto correctamente';
                st.registry = R;
                
                if(Bandera){
                    if(!R.message.contains('Actualizada') && !R.message.contains('Devolucion') && !R.message.contains('Pago recibido') && !R.message.contains('agregado en SAP correctamente') && !R.message.contains('Cliente recuperado/reasignado: OK') && !R.message.contains('Proveedor actualizado en SAP') && !R.message.contains('Proveedor creado en SAP') && !R.message.contains('Lead Creado No') && !R.Message.contains('CARTA PORTE')  || ( (R.Message.contains('CARTA PORTE') && R.Message.contains('ERROR'))) )
                    {
                        RES.Type__c = 'ERROR';
                    }
                    RES.Message__c = R.message;
                    insert RES;
                }
                String RecordTypeShipment = [Select Id From RecordType Where Developername=:'Shipment_Order' limit 1].Id;
                if(RES.Type__c == 'ERROR' && RES.Shipment__c != null && RES.Object__c=='Shipment' && (S[0].OrdenVenta__c == null || S[0].OrdenVenta__c == '')){
                    list<Shipment_Fee_Line__c> Lines = [Select Id,SAP__c From Shipment_Fee_Line__c Where Shipment__c=:R.Shipment];
                    for(Shipment_Fee_Line__c L: Lines){L.SAP__c =false;}
                    S[0].RecordTypeId=RecordTypeShipment;update S[0];update Lines;
                }
                String RecordTypeDis = [Select Id From Recordtype Where Developername='Disbursement' limit 1].Id;
                if(RES.Type__c == 'ERROR' && RES.Disbursement__c != null && RES.Object__c=='Disbursement' && (DISBURSEMENT[0].OrdenCompra__c == null || DISBURSEMENT[0].OrdenCompra__c == '')){
                    DISBURSEMENT[0].RecordTypeId = RecordTypeDis;
                    update DISBURSEMENT[0];
                }
                String RecordTypeInv = [Select Id From Recordtype Where Developername='Invoice' limit 1].Id;
                if(RES.Type__c == 'ERROR' && RES.Invoice__c != null && RES.Object__c=='Invoice' && (INVOICE[0].FolioEntrega__c == null || INVOICE[0].FolioEntrega__c == '')){
                    INVOICE[0].RecordTypeId = RecordTypeInv;
                    update INVOICE[0];
                }
                result.add(st);
            }
            
        	return result;
            
        }catch(Exception e){
            RES.Type__c = 'ERROR';
            RES.Message__c = e.getCause()+' '+e.getMessage();
            insert RES;
            System.debug(e.getCause()); System.debug(e.getMessage()); System.debug(e.getLineNumber());
			status st = new status(); st.code = '0';st.Existe = ''; st.message = 'OKExiste un error en el web services, por favor revise la trasabilidad de la transacción' + e.getCause() +' '+ e.getMessage() +' '+ e.getLineNumber();					
			result.add(st);
			return result;
        }
    }
    global class status {
        webservice String code {get; set;}
        webservice String message {get; set;}
        webservice String Existe {get;set;}
        webservice MESSAGE registry {get; set;}
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
    }
}