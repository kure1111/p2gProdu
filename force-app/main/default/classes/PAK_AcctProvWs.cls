public class PAK_AcctProvWs {
    public ApexPages.StandardController c {get;set;}
    Public Account prov {get;set;}
    public String idProv {get;set;}
    
    public PAK_AcctProvWs(ApexPages.StandardController Controller){
        c = Controller;
        prov = (Account)Controller.getRecord();
        idProv = Controller.getId(); 
    }
    
    public PageReference sendWs(){
        System.debug('PAK_AcctProvWs - id: ' + idProv);
        string body = '';
        List<Account> lstProvedores = new List<Account>();
        List<Response__c> lstResponses = new List<Response__c>();
        try{
            lstProvedores = [SELECT Id, Name, TAX_ID__c, Customer_Id__c, Phone, NEU_Email__c, Workplace_AccOwner__c, ActiveSap__c, Grupo_SAP_PICK__c, 
                             CurrencyIsoCode, Carrier_Class__c, Carrier_Evaluation__c, Credit_Terms__c, Bank_Name_Supplier_Form2__c, Bank_Account_Name__c, 
                             Bank_Account_Number__c, Swift_Number__c, Credit_Limit__c, Anticipo__c, Factoraje__c, Indicador_de_impuestos__c, C_digo_IVA_Permitido__c, BillingAddress, 
                             BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry, Sujeto_a_retencion__c,
                             (SELECT Tipcon_cont__c, Id, FirstName, LastName, Phone, MobilePhone, Email  FROM Contacts)
                             FROM Account 
                             WHERE Id = :idProv];
            body ='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                '<soapenv:Header/>'+
                '<soapenv:Body>'+
                '<tem:altaProveedor>'+
                '<tem:proveedores>';
            for(Account prov : lstProvedores){
                string active = prov.ActiveSap__c == true ? '1' : '0';
                string retencion = prov.Sujeto_a_retencion__c != null ? prov.Sujeto_a_retencion__c : '';
                body += '<tem:Proveedor>' +
                    '<tem:salesforceId>'+prov.Id+'</tem:salesforceId>'+
                    '<tem:nombre>'+prov.Name+'</tem:nombre>'+
                    '<tem:rfc>'+(prov.TAX_ID__c == null ? '': prov.TAX_ID__c)+'</tem:rfc>'+
                    '<tem:cardCode>'+(prov.Customer_Id__c == null ? '': prov.Customer_Id__c)+'</tem:cardCode>'+
                    '<tem:phone>'+(prov.Phone == null ? '' : prov.Phone)+'</tem:phone>'+
                    '<tem:email>'+(prov.NEU_Email__c == null ? '' : prov.NEU_Email__c)+'</tem:email>'+
                    '<tem:workplaceOwner>'+(prov.Workplace_AccOwner__c == null ? '':prov.Workplace_AccOwner__c)+'</tem:workplaceOwner>'+
                    '<tem:active>'+active+'</tem:active>'+                    
                    '<tem:grupoSap>'+(prov.Grupo_SAP_PICK__c == null ? '':prov.Grupo_SAP_PICK__c)+'</tem:grupoSap>'+
                    '<tem:moneda>'+(prov.CurrencyIsoCode == null ? '':prov.CurrencyIsoCode)+'</tem:moneda>'+
                    '<tem:clasificacion>'+(prov.Carrier_Class__c == null ? '':prov.Carrier_Class__c)+'</tem:clasificacion>'+
                    '<tem:evaluacion>'+(prov.Carrier_Evaluation__c == null ? '':prov.Carrier_Evaluation__c)+'</tem:evaluacion>' +
                    '<tem:credTerms>'+(prov.Credit_Terms__c == null ? '':prov.Credit_Terms__c)+'</tem:credTerms>' +
                    '<tem:bankName>'+(prov.Bank_Name_Supplier_Form2__c == null ? '':prov.Bank_Name_Supplier_Form2__c)+'</tem:bankName>' +
                    '<tem:bankAcctName>'+(prov.Bank_Account_Name__c == null ? '':prov.Bank_Account_Name__c)+'</tem:bankAcctName>' +
                    '<tem:bankAcctNumber>'+(prov.Bank_Account_Number__c == null ? '':prov.Bank_Account_Number__c)+'</tem:bankAcctNumber>' +
                    '<tem:swiftNumber>'+(prov.Swift_Number__c == null ? '':prov.Swift_Number__c)+'</tem:swiftNumber>' +                    
                    '<tem:creditLimit>'+(prov.Credit_Limit__c == null ? 0: prov.Credit_Limit__c)+'</tem:creditLimit>' +
                    '<tem:anticipo>'+(prov.Anticipo__c == null ? '':prov.Anticipo__c)+'</tem:anticipo>' +                    
                    '<tem:billingAddress>'+(prov.BillingAddress == null ? '': (prov.BillingStreet + '|' + prov.BillingCity + '|' + prov.BillingPostalCode + '|' + prov.BillingState + '|' + prov.BillingCountry))+'</tem:billingAddress>' +
                    '<tem:factoraje>'+(prov.Factoraje__c == null ? '':prov.Factoraje__c)+'</tem:factoraje>' +
                    '<tem:indicadorImpuestos>'+(prov.Indicador_de_impuestos__c == null ? '':prov.Indicador_de_impuestos__c)+'</tem:indicadorImpuestos>' +
                    '<tem:codigoIva>'+(prov.C_digo_IVA_Permitido__c == null ? '':prov.C_digo_IVA_Permitido__c)+'</tem:codigoIva>' +
                    '<tem:retencion>' + retencion +'</tem:retencion>';
                if(prov.Contacts.size()>0){
                    body += '<tem:Contactos>';
                    for(Contact contact : prov.Contacts){
                        body += '<tem:ContactoProveedor>' +
                            '<tem:salesforceAcctId>'+prov.Id+'</tem:salesforceAcctId>' +
                            '<tem:salesforceId>'+contact.Id+'</tem:salesforceId>' +
                            '<tem:nombre>'+(contact.FirstName == null ? '':contact.FirstName)+'</tem:nombre>' + 
                            '<tem:apellido>'+(contact.LastName == null ? '':contact.LastName)+'</tem:apellido>' + 
                            '<tem:telefono>'+(contact.Phone == null ? '':contact.Phone)+'</tem:telefono>' + 
                            '<tem:celular>'+(contact.MobilePhone == null ? '':contact.MobilePhone)+'</tem:celular>' + 
                            '<tem:correo>'+(contact.Email == null ? '':contact.Email)+'</tem:correo>' + 
                            '<tem:tipoContacto>'+(contact.Tipcon_cont__c == null ? '':contact.Tipcon_cont__c)+'</tem:tipoContacto>' + 
                            '</tem:ContactoProveedor>'; 
                    }
                    body += '</tem:Contactos>';
                }
                body += '</tem:Proveedor>';
            }
            body += '</tem:proveedores>' +
                '</tem:altaProveedor>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
            
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://35.169.18.187/pakws92/WSAltaProveedores.asmx');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', 'http://tempuri.org/altaProveedor');
            request.setBody(body);
            HttpResponse response = httpProtocol.send(request);
            System.debug('Response: '+response.getBody());
            System.debug('Request Body: '+body);
            if(response.getStatusCode() == 200){
                // OK - Enviar response si hay error en alguno
                System.debug('PAK_AcctProvWS: OK');
                Dom.Document doc = new Dom.Document();doc.load(response.getBody());
                Dom.XMLNode root = doc.getRootElement();
                root = root.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('altaProveedorResponse','http://tempuri.org/').getChildElement('altaProveedorResult','http://tempuri.org/');
                System.debug('Respuesta: ' + root.getText());
                List<String> respuestas = (List<string>)JSON.deserialize(root.getText(), List<string>.class);
                System.debug('Respuestas: ' + respuestas);
                Integer count = 0;
                for(String r : respuestas){
                    if(r != 'OK'){
                        Response__c res = new Response__c();res.Object__c = 'Account';res.Account__c = lstProvedores[count].Id;res.Type__c = 'ERROR';res.Message__c = r;
                        lstResponses.add(res);
                    }   
                    count++;
                }
                if(lstResponses.size()>0){
                    insert lstResponses;
                }
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Proveedor enviado correctamente a SAP. Esperar respuesta en área de responses.');
                ApexPages.addMessage(myMsg); 
            }else{
                //Error
                System.debug('PAK_AcctProvWS: Ocurrio un error porfavor de comunicarse con el administrador del sistema');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Ocurrio un error porfavor de comunicarse con el administrador del sistema');
                ApexPages.addMessage(myMsg);
            } 
        }catch(Exception e){
            System.debug('PAK_AcctProvWS: Error: ' + e.getLineNumber()+'------------'+e.getMessage() + '------' + e.getStackTraceString());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: ' + e.getLineNumber()+'------------'+e.getMessage() + '------' + e.getStackTraceString());
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
    /*@future(callout=true)
public static void updateProvAcct(Set<Id> ids){
System.debug('PAK_AcctProvWs - ids: ' + ids);
string body = '';
List<Account> lstProvedores = new List<Account>();
List<Response__c> lstResponses = new List<Response__c>();
try{
lstProvedores = [SELECT Id, Name, TAX_ID__c, Customer_Id__c, Phone, NEU_Email__c, Workplace_AccOwner__c, ActiveSap__c, Grupo_SAP__c, 
CurrencyIsoCode, Carrier_Class__c, Carrier_Evaluation__c, Credit_Terms__c, Bank_Name_Supplier_Form__c, Bank_Account_Name__c, 
Bank_Account_Number__c, Swift_Number__c, Credit_Limit__c, Anticipo__c, Factoraje__c, Indicador_de_impuestos__c, C_digo_IVA_Permitido__c, BillingAddress, 
BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry, Sujeto_a_retencion__c,
(SELECT Tipcon_cont__c, Id, FirstName, LastName, Phone, MobilePhone, Email  FROM Contacts)
FROM Account 
WHERE Id IN :ids];
body ='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
'<soapenv:Header/>'+
'<soapenv:Body>'+
'<tem:altaProveedor>'+
'<tem:proveedores>';
for(Account prov : lstProvedores){
string active = prov.ActiveSap__c == true ? '1' : '0';
string retencion = prov.Sujeto_a_retencion__c != null ? prov.Sujeto_a_retencion__c : '';
body += '<tem:Proveedor>' +
'<tem:salesforceId>'+prov.Id+'</tem:salesforceId>'+
'<tem:nombre>'+prov.Name+'</tem:nombre>'+
'<tem:rfc>'+(prov.TAX_ID__c == null ? '': prov.TAX_ID__c)+'</tem:rfc>'+
'<tem:cardCode>'+(prov.Customer_Id__c == null ? '': prov.Customer_Id__c)+'</tem:cardCode>'+
'<tem:phone>'+(prov.Phone == null ? '' : prov.Phone)+'</tem:phone>'+
'<tem:email>'+(prov.NEU_Email__c == null ? '' : prov.NEU_Email__c)+'</tem:email>'+
'<tem:workplaceOwner>'+(prov.Workplace_AccOwner__c == null ? '':prov.Workplace_AccOwner__c)+'</tem:workplaceOwner>'+
'<tem:active>'+active+'</tem:active>'+                    
'<tem:grupoSap>'+(prov.Grupo_SAP__c == null ? '':prov.Grupo_SAP__c)+'</tem:grupoSap>'+
'<tem:moneda>'+(prov.CurrencyIsoCode == null ? '':prov.CurrencyIsoCode)+'</tem:moneda>'+
'<tem:clasificacion>'+(prov.Carrier_Class__c == null ? '':prov.Carrier_Class__c)+'</tem:clasificacion>'+
'<tem:evaluacion>'+(prov.Carrier_Evaluation__c == null ? '':prov.Carrier_Evaluation__c)+'</tem:evaluacion>' +
'<tem:credTerms>'+(prov.Credit_Terms__c == null ? '':prov.Credit_Terms__c)+'</tem:credTerms>' +
'<tem:bankName>'+(prov.Bank_Name_Supplier_Form__c == null ? '':prov.Bank_Name_Supplier_Form__c)+'</tem:bankName>' +
'<tem:bankAcctName>'+(prov.Bank_Account_Name__c == null ? '':prov.Bank_Account_Name__c)+'</tem:bankAcctName>' +
'<tem:bankAcctNumber>'+(prov.Bank_Account_Number__c == null ? '':prov.Bank_Account_Number__c)+'</tem:bankAcctNumber>' +
'<tem:swiftNumber>'+(prov.Swift_Number__c == null ? '':prov.Swift_Number__c)+'</tem:swiftNumber>' +                    
'<tem:creditLimit>'+(prov.Credit_Limit__c == null ? 0: prov.Credit_Limit__c)+'</tem:creditLimit>' +
'<tem:anticipo>'+(prov.Anticipo__c == null ? '':prov.Anticipo__c)+'</tem:anticipo>' +                    
'<tem:billingAddress>'+(prov.BillingAddress == null ? '': (prov.BillingStreet + '|' + prov.BillingCity + '|' + prov.BillingPostalCode + '|' + prov.BillingState + '|' + prov.BillingCountry))+'</tem:billingAddress>' +
'<tem:factoraje>'+(prov.Factoraje__c == null ? '':prov.Factoraje__c)+'</tem:factoraje>' +
'<tem:indicadorImpuestos>'+(prov.Indicador_de_impuestos__c == null ? '':prov.Indicador_de_impuestos__c)+'</tem:indicadorImpuestos>' +
'<tem:codigoIva>'+(prov.C_digo_IVA_Permitido__c == null ? '':prov.C_digo_IVA_Permitido__c)+'</tem:codigoIva>' +
'<tem:retencion>' + retencion +'</tem:retencion>';
if(prov.Contacts.size()>0){
body += '<tem:Contactos>';
for(Contact contact : prov.Contacts){
body += '<tem:ContactoProveedor>' +
'<tem:salesforceAcctId>'+prov.Id+'</tem:salesforceAcctId>' +
'<tem:salesforceId>'+contact.Id+'</tem:salesforceId>' +
'<tem:nombre>'+(contact.FirstName == null ? '':contact.FirstName)+'</tem:nombre>' + 
'<tem:apellido>'+(contact.LastName == null ? '':contact.LastName)+'</tem:apellido>' + 
'<tem:telefono>'+(contact.Phone == null ? '':contact.Phone)+'</tem:telefono>' + 
'<tem:celular>'+(contact.MobilePhone == null ? '':contact.MobilePhone)+'</tem:celular>' + 
'<tem:correo>'+(contact.Email == null ? '':contact.Email)+'</tem:correo>' + 
'<tem:tipoContacto>'+(contact.Tipcon_cont__c == null ? '':contact.Tipcon_cont__c)+'</tem:tipoContacto>' + 
'</tem:ContactoProveedor>'; 
}
body += '</tem:Contactos>';
}
body += '</tem:Proveedor>';
}
body += '</tem:proveedores>' +
'</tem:altaProveedor>' +
'</soapenv:Body>' +
'</soapenv:Envelope>';

Http httpProtocol = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('http://35.169.18.187/pakws/WSAltaProveedores.asmx');
request.setMethod('POST');
request.setHeader('Content-Type', 'text/xml;charset=utf-8');
request.setHeader('SOAPAction', 'http://tempuri.org/altaProveedor');
request.setBody(body);
HttpResponse response = httpProtocol.send(request);
System.debug('Response: '+response.getBody());
System.debug('Request Body: '+body);
if(response.getStatusCode() == 200){
// OK - Enviar response si hay error en alguno
System.debug('PAK_AcctProvWS: OK');
Dom.Document doc = new Dom.Document();doc.load(response.getBody());
Dom.XMLNode root = doc.getRootElement();
root = root.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('altaProveedorResponse','http://tempuri.org/').getChildElement('altaProveedorResult','http://tempuri.org/');
System.debug('Respuesta: ' + root.getText());
List<String> respuestas = (List<string>)JSON.deserialize(root.getText(), List<string>.class);
System.debug('Respuestas: ' + respuestas);
Integer count = 0;
for(String r : respuestas){
if(r != 'OK'){
Response__c res = new Response__c();res.Object__c = 'Account';res.Account__c = lstProvedores[count].Id;res.Type__c = 'ERROR';res.Message__c = r;
lstResponses.add(res);
}   
count++;
}
if(lstResponses.size()>0){
insert lstResponses;
}
}else{
//Error
System.debug('PAK_AcctProvWS: Ocurrio un error porfavor de comunicarse con el administrador del sistema');
} 
}catch(Exception e){
System.debug('PAK_AcctProvWS: Error: ' + e.getLineNumber()+'------------'+e.getMessage() + '------' + e.getStackTraceString());
}
}*/
}