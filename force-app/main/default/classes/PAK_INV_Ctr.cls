public class PAK_INV_Ctr {
    public ApexPages.StandardController C {get;set;}
    public Invoice__c Fac {get;set;}
    public PAK_INV_Ctr(ApexPages.StandardController controller){
        C = controller;
        Fac =(Invoice__c) controller.getRecord(); 
    }
    public PageReference Cancelar(){
        if(!Test.isRunningTest()){
            Fac.Invoice_Status__c = 'Cancel';
            update Fac;
            return C.view();   
        }else{
            return null;
        }
    }
    
    // Metodos que se llama desde la VF y manda el shipment a SAP.
    public PageReference SendShipment(){
        try{
            Invoice__c INVOICE = getInvoiceByID(Fac.Id);    //metodo que consulta la invoice por medio de la IP
            ApexPages.StandardController controllerSHIPMENT = new ApexPages.StandardController(INVOICE.Shipment__r);
            PAK_SendToOrder pakship = new PAK_SendToOrder(controllerSHIPMENT);
            pakship.SendWS();
            return null;
        }catch(Exception e){
            System.debug(e.getLineNumber()+'------------'+e.getMessage());
            return null;
        }
    }
    public PageReference Send(){
        Response__c R = new Response__c();
        Invoice__c INVOICE = getInvoiceByID(Fac.Id);
        string Body=buildBODyInvoiceToSAP(INVOICE,Fac.Id);
        String validacion;
        try{
            if(!Test.isRunningTest()){
                validacion = validacion(Fac.Id);
            }else{
                validacion = 'APPROVED';
            }
            System.debug('validacion: '+validacion);
            if(validacion == 'APPROVED'){
                HttpResponse response = callInvoiceSendToSAPService(Body);
                System.debug('-----------'+response.getBody());
                System.debug('-------------------'+Body);
                Dom.Document doc = new Dom.Document();
                doc.load(response.getBody());
                
                System.debug('response.getStatusCode()-------------------'+response.getStatusCode());
                System.debug('response.getStatusCode()-------------------'+response.getBody());
                Dom.XMLNode root = doc.getRootElement();
                root = root.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
                root = root.getChildElement('CreateInvoiceResponse','http://tempuri.org/');
                root = root.getChildElement('CreateInvoiceResult','http://tempuri.org/');
                R.Object__c = 'Invoice';
                R.Message__c = root.getText();
                R.Message_2__c = body;
                R.Invoice__c = INVOICE.Id;
                R.Shipment__c = INVOICE.Shipment__c;
                if(response.getStatusCode() == 200){
                    INVOICE.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'InvoiceStatus' limit 1].Id;
                    INVOICE.Invoice_Status__c = 'Send to Sap';
                    INVOICE.Date_Receive_from_SAP__c = Datetime.now();
                    //INVOICE.FolioEntrega__c = root.getText().SubstringAfter('Entrega Creada No. : ');
                    update INVOICE;
                    R.Type__c = 'CONFIRM';
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,root.getText());
                    ApexPages.addMessage(myMsg); 
                }else{
                    R.Type__c = 'ERROR';
                    R.Message_2__c = body;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: '+root.getText());
                    ApexPages.addMessage(myMsg);
                }
                insert R;
            }else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, validacion);
                ApexPages.addMessage(msg);
            }
            return null;
        }catch(Exception e){
            R.Object__c = 'Invoice';
            R.Invoice__c = C.getId();
            R.Message__c =  e.getStackTraceString() +': '+e.getMessage();
            R.Type__c = 'ERROR';
            R.Message_2__c = body;
            insert R;
            if(e.getMessage().contains('Read timed out') || e.getLineNumber() > 96){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Expiro el tiempo de espera favor de revisar si la Invoice se envió correctamente');
                ApexPages.addMessage(myMsg);
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Ocurrio un error al intentar enviar la información a SAP. Revise lo siguiente : ' + ' ' + e.getMessage() + ' TRACE : ' + E.getStackTraceString() + ' o contacte al Administrador de Salesforce.' );
                ApexPages.addMessage(myMsg);
            }
            
            System.debug(e.getLineNumber()+'------------'+e.getMessage());
            return null;
        }
    }
    
    // metodos que hacen el timbrado desde los triggers
    public void SendSPtoSAPFromTrigger(string recID){
        try{
            Invoice__c INVOICE = getInvoiceByID(recID);
            ApexPages.StandardController controllerSHIPMENT = new ApexPages.StandardController(INVOICE.Shipment__r);
            // esto actualmente truena por los apexPage.message que estan en el servicio
            // PAK_SendToOrder pakship = new PAK_SendToOrder(controllerSHIPMENT);
            // pakship.SendWS();
        }catch(Exception e){
            System.debug(e.getLineNumber()+'------------'+e.getMessage());
        }
    }
    @Future(callout=true)
    public static void SendInvoiceToSAPFromTrigger(string recID){
        Response__c R = new Response__c();
        Invoice__c INVOICE = getInvoiceByID(recID);
        string Body=buildBODyInvoiceToSAP(INVOICE,recID);
        try{
            String validacion = validacion(INVOICE.Id);
            System.debug('validacion: '+validacion);
            if(validacion == 'APPROVED'){
                HttpResponse response = callInvoiceSendToSAPService(Body);
                System.debug('-----------'+response.getBody());
                System.debug('-------------------'+Body);
                Dom.Document doc = new Dom.Document();
                doc.load(response.getBody());
                System.debug('response.getStatusCode()-------------------'+response.getStatusCode());
                System.debug('response.getStatusCode()-------------------'+response.getBody());
                Dom.XMLNode root = doc.getRootElement();
                root = root.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
                root = root.getChildElement('CreateInvoiceResponse','http://tempuri.org/');
                root = root.getChildElement('CreateInvoiceResult','http://tempuri.org/');
                R.Object__c = 'Invoice';
                R.Message__c = root.getText();
                R.Message_2__c = body;
                R.Invoice__c = INVOICE.Id;
                R.Shipment__c = INVOICE.Shipment__c;
                if(response.getStatusCode() == 200){
                    INVOICE.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'InvoiceStatus' limit 1].Id;
                    INVOICE.Invoice_Status__c = 'Send to Sap';
                    INVOICE.Date_Receive_from_SAP__c = Datetime.now();
                    //INVOICE.FolioEntrega__c = root.getText().SubstringAfter('Entrega Creada No. : ');
                    update INVOICE;
                    R.Type__c = 'CONFIRM';
                    system.debug('El envio a SAP ha sido exitoso');
                }else{
                    system.debug('Ocurrio un error al intentar enviar a SAP: '+root.getText());
                    R.Type__c = 'ERROR';
                    R.Message_2__c = body;
                }
                insert R;
            }
        }catch(Exception e){
            R.Object__c = 'Invoice';
            R.Invoice__c = recID;
            R.Message__c =  e.getStackTraceString() +': '+e.getMessage();
            R.Type__c = 'ERROR';
            R.Message_2__c = body;
            insert R;
            if(e.getMessage().contains('Read timed out') || e.getLineNumber() > 96){
                system.debug('se ha excedido el tiempo de espera al enviar a SAP ');
            }else{
                system.debug('Ocurrio un error al intentar enviar la información a SAP. Revise lo siguiente : '+ e.getMessage() + ' TRACE : ' + E.getStackTraceString() + ' o contacte al Administrador de Salesforce.');
            }
            
            System.debug(e.getLineNumber()+'------------'+e.getMessage());
        }
    }
    
    // metodos de Consulta (Querys)
    public static Invoice__c getInvoiceByID(string recID){
        return [Select Id,Name,RecordTypeId,Account__r.Owner.Workplace__c,Invoice_Status__c,Shipment__r.id,Shipment__r.Name,CurrencyIsoCode,
                Date_Receive_from_SAP__c,Total_Excl_VAT__c,Total_Incl_VAT__c,Cfdi_Number__c,Import_Export_Quote_Order__r.Name,
                Account__r.Customer_id__c,Account__r.Name,Account__r.Account_Executive_User__r.Email,CreatedBy.Email,Comments__c,
                Shipment__r.Service_Type__c,Shipment__r.Service_Mode__c,Shipment__r.Freight_Mode__c,FolioEntrega__c,Shipment__r.Folios_para_Facturar__c,
                Shipment__r.MBL_Number__c,Shipment__r.MAWB_Number__c, Shipment__r.Traslado_Ingreso__c,Shipment__r.Shipment_Type__c
                from Invoice__c Where Id=:recID limit 1];
    }
    
    // Metodos que hacen la llamada al Servicio Invoice Send to SAP
    public static HttpResponse callInvoiceSendToSAPService(String Body ){
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        //http://35.169.18.187/pakws92/WSInvoice.asmx
        
        if([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox)
            request.setEndpoint('http://35.169.18.187/pakws/WsInvoice.asmx');
        else
            request.setEndpoint('http://35.169.18.187/pakws92/WsInvoice.asmx');  
        request.setMethod('POST');
        request.setTimeout(60000);
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', 'http://tempuri.org/CreateInvoice');
        string newBody = Body.replace('&','and');
        Body = newBody;
        request.setBody(Body);
        HttpResponse response = httpProtocol.send(request);
        return response;
    }
    
    public static String buildBODyInvoiceToSAP(Invoice__c INVOICE,string recordID){
        try{
            String Body  ='';
            system.debug('INVOICE ' + INVOICE);
            Date d = Date.today();
            String fecha = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/YYYY');
            String WPAccOwner = INVOICE.Account__r.Owner.Workplace__c != null?INVOICE.Account__r.Owner.Workplace__c:'';
            String CfdiNumber = INVOICE.Cfdi_Number__c != null?String.valueOf(INVOICE.Cfdi_Number__c):'';
            String DateReceiveSap = String.valueOf(Datetime.now());
            if(WPAccOwner != ''){
                WPAccOwner = WPAccOwner+'-'+INVOICE.Shipment__r.Freight_Mode__c+'-'+INVOICE.Shipment__r.Service_Mode__c;
            }else{
                WPAccOwner = INVOICE.Shipment__r.Freight_Mode__c+'-'+INVOICE.Shipment__r.Service_Mode__c;
            }
            
            Body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                '<soapenv:Header/>'+
                '<soapenv:Body>'+
                '<tem:CreateInvoice>'+
                '<tem:datos>'+
                '<tem:Invoice>'+
                '<tem:currency>'+INVOICE.CurrencyIsoCode+'</tem:currency>'+
                '<tem:WPAccOwner>'+WPAccOwner+'</tem:WPAccOwner>'+
                '<tem:CfdiNumber>'+CfdiNumber+'</tem:CfdiNumber>'+
                '<tem:DateReceiveSap>'+DateReceiveSap+'</tem:DateReceiveSap>'+
                '<tem:Fecha>'+fecha+'</tem:Fecha>'+
                '<tem:IdInvoice>'+INVOICE.Id+'</tem:IdInvoice>'+
                '<tem:CardCode>'+INVOICE.Account__r.Customer_id__c+'</tem:CardCode>'+
                '<tem:Monto>'+INVOICE.Total_Excl_VAT__c+'</tem:Monto>'+
                '<tem:InvoiceNumber>'+INVOICE.Name+'</tem:InvoiceNumber>'+
                '<tem:Shipment>'+INVOICE.Shipment__r.Name+'</tem:Shipment>'+
                '<tem:Enviado></tem:Enviado>'+
                '<tem:Respuesta></tem:Respuesta>'+
                '<tem:DetalleInvoice>';
            
            system.debug('INVOICE.CurrencyIsoCode ' + INVOICE.CurrencyIsoCode);
            system.debug('WPAccOwner ' + WPAccOwner);
            system.debug('CfdiNumber ' + CfdiNumber);
            system.debug('DateReceiveSap ' + DateReceiveSap);
            system.debug('fecha ' + fecha);
            system.debug('INVOICE.Id ' + INVOICE.Id);
            system.debug('INVOICE.Account__r.Customer_id__c ' + INVOICE.Account__r.Customer_id__c);
            system.debug('INVOICE.Total_Excl_VAT__c ' + INVOICE.Total_Excl_VAT__c);
            system.debug('INVOICE.Name ' + INVOICE.Name);
            system.debug('INVOICE.Shipment__r.Name ' + INVOICE.Shipment__r.Name);
            
            
            
            for(Invoice_Line__c IL: [Select Id,Name,Units__c,SAP_Service_Type__r.Code__c,Sap_Comp_Code__c,Numero_Linea__c,Unit_Price__c,VAT_Withholding__c,
                                     VAT_Withholding_ISR__c,VAT__c,Service_type__c,Shipment_Service_Line__c,Unit_Price_SAP__c,Sujeto_a_Ret__c,Total_Incl_VAT__c,VAT_Non_Applicable__c,Concept__c from Invoice_Line__c Where Invoice__c=:recordID]){
                                         
                                         String ServTypeLine = IL.Service_type__c;
                                         String Units = IL.Units__c != null?String.valueOf(IL.Units__c):'';
                                         String UnitPrice = IL.Unit_Price__c != null?String.valueOf(IL.Unit_Price__c):'';
                                         String UnitPriceSAP = IL.Unit_Price_SAP__c != null?String.valueOf(IL.Unit_Price_SAP__c):'';
                                         String VAT = IL.VAT__c;
                                         String SujetoARet = IL.Sujeto_a_Ret__c == true?'1':'0';
                                         String TotalInclVAT = IL.Total_Incl_VAT__c != null?String.valueOf(IL.Total_Incl_VAT__c):'';
                                         String IdInvoiceLine = IL.Numero_Linea__c != null?String.valueOf(IL.Numero_Linea__c):'';
                                         String Serv = INVOICE.Shipment__r.Freight_Mode__c+'-'+INVOICE.Shipment__r.Service_Mode__c+'-'+INVOICE.Shipment__r.Service_Type__c;
                                         String IdShipmentLine = IL.Shipment_Service_Line__c;
                                         Body+='<tem:DetalleInvoice>'+
                                             '<tem:ServTypeLine>'+Serv+'</tem:ServTypeLine>'+
                                             '<tem:Units>'+Units+'</tem:Units>'+
                                             '<tem:UnitPrice>'+UnitPriceSAP+'</tem:UnitPrice>'+
                                             '<tem:VAT>'+VAT+'</tem:VAT>'+
                                             '<tem:SujetoARet>'+SujetoARet+'</tem:SujetoARet>'+
                                             '<tem:TotalInclVAT>'+TotalInclVAT+'</tem:TotalInclVAT>'+
                                             '<tem:IdInvoiceLine>'+IdInvoiceLine+'</tem:IdInvoiceLine>'+
                                             '<tem:IdShipmentLine>'+IdShipmentLine+'</tem:IdShipmentLine>'+
                                             '<tem:IdInvoice>'+INVOICE.Id+'</tem:IdInvoice>'+
                                             '<tem:Concepto>'+IL.Concept__c+'</tem:Concepto>'+
                                             '<tem:ItemCode>'+IL.SAP_Service_Type__r.Code__c+'</tem:ItemCode>'+
                                             '</tem:DetalleInvoice>';  
                                         
                                         system.debug('Serv ' + Serv);
                                         system.debug('Units ' + Units);
                                         system.debug('UnitPriceSAP ' + UnitPriceSAP);
                                         system.debug('VAT ' + VAT);
                                         system.debug('SujetoARet ' + SujetoARet);
                                         system.debug('TotalInclVAT ' + TotalInclVAT);
                                         system.debug('IdInvoiceLine ' + IdInvoiceLine);
                                         system.debug('IdShipmentLine ' + IdShipmentLine);
                                         system.debug('INVOICE.Id ' + INVOICE.Id);
                                         system.debug('IL.Concept__c ' + IL.Concept__c); 
                                         system.debug('IL.SAP_Service_Type__r.Code__c ' + IL.SAP_Service_Type__r.Code__c);
                                         
                                     }
            
            // CartaPorte cp = getCartaPorte(INVOICE.Shipment__r.id);
            // string Outputget= JSON.serialize(cp); 
            
            list<Carta_Porte__c> cps= [Select id from Carta_Porte__c where Shipment__c  =: INVOICE.Shipment__r.id];
            string Outputget= '';
            
            //if(cps.size() == 0)
            //{
            if(INVOICE.Shipment__r.Traslado_Ingreso__c == 'Ingreso' && (INVOICE.Shipment__r.Shipment_Type__c == 'FN'|| INVOICE.Shipment__r.Shipment_Type__c == 'PTO' || INVOICE.Shipment__r.Shipment_Type__c == 'FI'))
            {
                try
                {
                    if(!Test.isRunningTest()){
                        CPV2.Comprobante comp = CPV2.getComprobante(INVOICE.Shipment__r.id, 'I');
                        Outputget= JSON.serialize(comp.Complemento.cartaporte); 
                    }
                }
                catch(Exception e)
                {
                    // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Al crear CP ' + e.getMessage() + ' TRACE/ ' + E.getStackTraceString() );
                    // ApexPages.addMessage(myMsg);
                    throw e;
                }
            }
            //}
            
            Body+='</tem:DetalleInvoice>'+
                /* Campos nuevos para el tema de las  Debit Note WCA e Invoice área internacional*/
                '<tem:FolioFacturar>'+INVOICE.Shipment__r.Folios_para_Facturar__c+'</tem:FolioFacturar>'+
                '<tem:MBLNumber>'+INVOICE.Shipment__r.MBL_Number__c+'</tem:MBLNumber>'+
                '<tem:MAWBNumber>'+INVOICE.Shipment__r.MAWB_Number__c+'</tem:MAWBNumber>'+
                '<tem:Json>'+ Outputget+'</tem:Json>'+
                /* Campos nuevos para el tema de las  Debit Note WCA e Invoice área internacional*/
                '</tem:Invoice>'+
                '</tem:datos>'+
                '<tem:nombreUsuario>'+UserInfo.getName()+'</tem:nombreUsuario>'+
                '</tem:CreateInvoice>'+
                '</soapenv:Body>'+
                '</soapenv:Envelope>';
            
            system.debug('INVOICE.Shipment__r.Folios_para_Facturar__c ' + INVOICE.Shipment__r.Folios_para_Facturar__c);
            system.debug('INVOICE.Shipment__r.MBL_Number__c ' + INVOICE.Shipment__r.MBL_Number__c);
            system.debug('INVOICE.Shipment__r.MAWB_Number__c ' + INVOICE.Shipment__r.MAWB_Number__c);
            system.debug('UserInfo.getName() ' + UserInfo.getName());
            
            
            
            system.debug('Body envio ');
            
            for (Integer i = 0; i < body.length(); i=i+250)
            {
                Integer iEffectiveEnd = (i+250) > body.length() ? body.length()-1 : (i+250);
                    System.debug('BODY LINEA ' +  i + ' - ' + iEffectiveEnd + ' ->' + body.substring(i,iEffectiveEnd));
            }
            return Body;
        }
        catch(Exception e){
            System.debug(e.getLineNumber()+'------------'+e.getMessage());
            return null;
        }
    }
    public static String validacion(String Id_Invo){
        String validacion = 'APPROVED';
        Invoice__c invo = [SELECT Id, shipment__c, Account__r.Requiere_Acuse_Sap__c, Shipment__r.Traslado_Ingreso__c FROM Invoice__c WHERE id =: Id_Invo];
        Invoice_Line__c invoLine = [SELECT Id, Name, IL_SapServiceType_Code__c FROM Invoice_Line__c WHERE Invoice__c =: invo.Id LIMIT 1];
        List<Associated_Document__c> documento = [SELECT Name, Document_Type__c FROM Associated_Document__c WHERE Document_Type__c =: 'Acuse' AND Shipment__c =: invo.Shipment__c Limit 1];
        if(documento.size()>0){
            System.debug('Datos de validacion '+invo.Shipment__r.Traslado_Ingreso__c+' '+documento[0].Document_Type__c+' '+' '+invoLine.IL_SapServiceType_Code__c);         
            if(invo.Shipment__r.Traslado_Ingreso__c == 'Traslado' && (invoLine.IL_SapServiceType_Code__c == 'FN-SERV_LOG_NACIO_IC'|| invoLine.IL_SapServiceType_Code__c == 'FN-SERV_LOGISTICO_IC')){
                if(invo.Account__r.Requiere_Acuse_Sap__c == 'Si'){
                    validacion = 'APPROVED';
                }else{
                    validacion = 'APPROVED';
                }
                            
            }else
                if(invoLine.IL_SapServiceType_Code__c != 'FN-SERV_LOG_NACIO_IC' && invoLine.IL_SapServiceType_Code__c != 'FN-SERV_LOGISTICO_IC'){
                    validacion = 'APPROVED';
                }
        }
        else{
            System.debug('Datos Code: '+invoLine.IL_SapServiceType_Code__c);
            if(invoLine.IL_SapServiceType_Code__c != 'FN-SERV_LOG_NACIO_IC' && invoLine.IL_SapServiceType_Code__c != 'FN-SERV_LOGISTICO_IC'){
                System.debug('Datos de validacion '+invo.Shipment__r.Traslado_Ingreso__c+' '+invoLine.IL_SapServiceType_Code__c);
                validacion = 'APPROVED';
            }
        	else{
                if(invo.Account__r.Requiere_Acuse_Sap__c != 'Si'){
                    validacion = 'APPROVED';
                }else{
                    validacion = 'Falta anexar el documento de Acuse';
                }
            }
        }
        return validacion;
    }
}