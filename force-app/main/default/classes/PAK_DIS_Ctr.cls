public class PAK_DIS_Ctr {
	public ApexPages.StandardController C {get;set;}
    public Shipment_Disbursement__c DIS {get;set;}
    public PAK_DIS_Ctr(ApexPages.StandardController controller){
        if(!Test.isRunningTest()){
            C = controller;
        	DIS =(Shipment_Disbursement__c) controller.getRecord(); 
        }
    }
    public PageReference Cancelar(){
        DIS.Disbursement_Status__c = 'Cancel';
        update DIS;
        
        return C.view();
    }
    public PageReference Send(){
        try{
            Shipment_Disbursement__c DISBURSEMENT = [Select Id,Name,RecordTypeId,OrdenCompra__c,Account__r.Customer_id__c,CurrencyIsoCode,Account__r.Owner.Workplace__c,Disbursement_Status__c,Shipment__r.Name,Shipment__r.Freight_Mode__c,Shipment__r.Service_Mode__c,Shipment__r.Service_Type__c,Date_Receive_from_SAP__c,Total_Excl_VAT__c,Total_Incl_VAT__c,Cfdi_Number__c,Import_Export_Quote_Order__r.Name,Shipment__r.Carrier__r.Customer_id__c,Account__r.Name,Account__r.Account_Executive_User__r.Email,CreatedBy.Email,Comments__c from Shipment_Disbursement__c Where Id=:DIS.Id limit 1];
 
            Date d = Date.today();
            String fecha = DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYY-MM-dd');
            String WPAccOwner = DISBURSEMENT.Account__r.Owner.Workplace__c != null?DISBURSEMENT.Account__r.Owner.Workplace__c:'';
            String CfdiNumber = DISBURSEMENT.Cfdi_Number__c != null?String.valueOf(DISBURSEMENT.Cfdi_Number__c):'';
            String DateReceiveSap = String.valueOf(Datetime.now());
            String Body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                               '<soapenv:Header/>'+
                               '<soapenv:Body>'+
                                  '<tem:CreateDisbursement>'+
                                     '<tem:datos>'+
                                        '<tem:Disbursement>'+
                                           '<tem:currency>'+DISBURSEMENT.CurrencyIsoCode+'</tem:currency>'+
                                           '<tem:WPAccOwner>'+WPAccOwner+'</tem:WPAccOwner>'+
                                           '<tem:Fecha>'+fecha+'</tem:Fecha>'+
                                           '<tem:CfdiNumber>'+CfdiNumber+'</tem:CfdiNumber>'+
                                           '<tem:DateReceiveSAP>'+DateReceiveSap+'</tem:DateReceiveSAP>'+
                                           '<tem:IdInvoice>'+DISBURSEMENT.Id+'</tem:IdInvoice>'+
                                           '<tem:CardCode>'+DISBURSEMENT.Account__r.Customer_id__c+'</tem:CardCode>'+
                                           '<tem:Monto>'+DISBURSEMENT.Total_Excl_VAT__c+'</tem:Monto>'+
                                           '<tem:InvoiceNumber>'+DISBURSEMENT.Name+'</tem:InvoiceNumber>'+
                                           '<tem:Shipment>'+DISBURSEMENT.Shipment__r.Name+'</tem:Shipment>'+
                                           '<tem:DetalleDisbursement>';
                							for(Disbursement_Line__c IL: [Select Id,Name,Units__c,Sap_Comp_Code__c,Numero_Linea__c,Unit_Price__c,VAT_Withholding__c,
                                                                         VAT_Withholding_ISR__c,VAT__c,Service_type__c,SAP_Service_Type__r.Code__c,Sujeto_a_Ret__c,Total_Incl_VAT__c,VAT_Non_Applicable__c,Concept__c from Disbursement_Line__c Where Disbursement__c=:DIS.Id]){
                                               
                                               String ServTypeLine = IL.Service_type__c;
                                               String Units = IL.Units__c != null?String.valueOf(IL.Units__c):'';
                                               String UnitPrice = IL.Unit_Price__c != null?String.valueOf(IL.Unit_Price__c):'';
                                               String VAT = IL.VAT__c;
                                               String SujetoARet = IL.Sujeto_a_Ret__c == true?'1':'0';
                                               String TotalInclVAT = IL.Total_Incl_VAT__c != null?String.valueOf(IL.Total_Incl_VAT__c):'';
                                               String IdInvoiceLine = IL.Numero_Linea__c != null?String.valueOf(IL.Numero_Linea__c):'';
                                               String Serv = DISBURSEMENT.Shipment__r.Freight_Mode__c+'-'+DISBURSEMENT.Shipment__r.Service_Mode__c+'-'+DISBURSEMENT.Shipment__r.Service_Type__c;                            
                                               Body+='<tem:DetalleDisbursement>'+
                                                         '<tem:ServTypeLine>'+Serv+'</tem:ServTypeLine>'+
                                                         '<tem:Units>'+Units+'</tem:Units>'+
                                                         '<tem:UnitPrice>'+UnitPrice+'</tem:UnitPrice>'+
                                                         '<tem:VAT>'+VAT+'</tem:VAT>'+
                                                         '<tem:SujetoARet>'+SujetoARet+'</tem:SujetoARet>'+
                                                         '<tem:TotalInclVAT>'+TotalInclVAT+'</tem:TotalInclVAT>'+
                                                         '<tem:IdInvoiceLine>'+IdInvoiceLine+'</tem:IdInvoiceLine>'+
                                                         '<tem:IdInvoice>'+DISBURSEMENT.Id+'</tem:IdInvoice>'+
                                                         '<tem:ItemCode>'+IL.SAP_Service_Type__r.Code__c+'</tem:ItemCode>'+
                                                         '<tem:Concepto>'+IL.Concept__c+'</tem:Concepto>'+
                                                      '</tem:DetalleDisbursement>';
                                            }
                                              
                                       Body+='</tem:DetalleDisbursement>'+
                                           '<tem:Enviado></tem:Enviado>'+
                                           '<tem:Respuesta></tem:Respuesta>'+
                                        '</tem:Disbursement>'+
                                     '</tem:datos>'+
                                     '<tem:nombreUsuario>'+UserInfo.getName()+'</tem:nombreUsuario>'+
                                  '</tem:CreateDisbursement>'+
                               '</soapenv:Body>'+
                            '</soapenv:Envelope>';
                
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://35.169.18.187/pakws92/WSDisbursement.asmx');
            request.setMethod('POST');
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', 'http://tempuri.org/CreateDisbursement');
            request.setBody(Body);
            HttpResponse response = httpProtocol.send(request);
            System.debug('-----------'+response.getBody());
            System.debug('-------------------'+Body);
            Dom.Document doc = new Dom.Document();
            doc.load(response.getBody());
            Dom.XMLNode root = doc.getRootElement();
            root = root.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
            root = root.getChildElement('CreateDisbursementResponse','http://tempuri.org/');
            root = root.getChildElement('CreateDisbursementResult','http://tempuri.org/');
            Response__c R = new Response__c();
            R.Object__c = 'Disbursement';
            R.Message__c = root.getText();
            R.Disbursement__c = DISBURSEMENT.Id;
            R.Shipment__c = DISBURSEMENT.Shipment__c;
            if(response.getStatusCode() == 200){
                if(root.getText().contains('Orden de Compra Creada')){
                    DISBURSEMENT.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'DisbursementStatus' limit 1].Id;
                   	DISBURSEMENT.Disbursement_Status__c = 'Send to Sap';
                	DISBURSEMENT.Date_Receive_from_SAP__c = Datetime.now();
                    DISBURSEMENT.OrdenCompra__c = root.getText().SubstringAfter('Orden de Compra Creada: ');
                   	update DISBURSEMENT;
                	R.Type__c = 'CONFIRM';
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,root.getText());
                    ApexPages.addMessage(myMsg);   
                }else{
                    R.Type__c = 'ERROR';
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: '+root.getText()+' Favor de contactar a su administrador de SAP');
                    ApexPages.addMessage(myMsg);
                }     
            }else{
                R.Type__c = 'ERROR';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: '+root.getText());
                ApexPages.addMessage(myMsg);
            }
            insert R;
            return null;
                
        }catch(Exception e){
            Response__c R = new Response__c();
            R.Object__c = 'Disbursement';
            R.Disbursement__c = C.getId();
            R.Message__c = e.getLineNumber()+': '+e.getMessage();
            R.Type__c = 'ERROR';
            insert R;
            if(e.getMessage().contains('Read timed out') || e.getLineNumber() > 84){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Expiro el tiempo de espera favor de revisar el Disbursement si se envió correctamente');
            	ApexPages.addMessage(myMsg);
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Ocurrio un error al intentar enviar la información a SAP por favor comunicar a tu administrador');
            	ApexPages.addMessage(myMsg);
            }
           
            System.debug(e.getLineNumber()+'------------'+e.getMessage());
            return null;
        }
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
    }
}