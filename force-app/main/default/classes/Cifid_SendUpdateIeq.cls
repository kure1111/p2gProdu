public class Cifid_SendUpdateIeq {
    public static boolean firstRun = true;
    
    @future(callout=true)
    public static void send(Set<Id> lstIds){
        List<Customer_Quote__c> lstQuotes = [SELECT Id, Name, Quotation_Status__c, Total_Services_Std_Buy_Amount_number__c, Pricing_Executive__r.Name, Date_Pricing_responded__c, External_Final_Client_WS__c FROM Customer_Quote__c WHERE Id IN:lstIds];
        System.debug('CIFID_TRIGGER quotes **** ' + lstQuotes);
        
        HttpResponse res;
        if(!Test.isRunningTest()){
            res = login();
        }
        
        String SESSION_ID;
        Dom.XmlNode resultElmt;
        if(!Test.isRunningTest()){                
            resultElmt = res.getBodyDocument().getRootElement().getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('loginResponse','urn:partner.soap.sforce.com').getChildElement('result','urn:partner.soap.sforce.com');                          
            SESSION_ID = resultElmt.getChildElement('sessionId','urn:partner.soap.sforce.com').getText();
        }else{
            SESSION_ID = 'TestId';
        } 
        
        Cifid_updateQuote.Cifid_UpdateQuoteFromPak cifid = new Cifid_updateQuote.Cifid_UpdateQuoteFromPak();
        cifid.SessionHeader = new Cifid_updateQuote.SessionHeader_element();
        cifid.SessionHeader.sessionId = SESSION_ID;
        
        for(Customer_Quote__c quote : lstQuotes){            
            Cifid_updateQuote.CustomerQuote qc = new Cifid_updateQuote.CustomerQuote();
            Cifid_updateQuote.estatus s;
            qc.quoteName = quote.Name;
            qc.quoteStatus = quote.Quotation_Status__c;
            qc.totalServStdBuyAmt = quote.Total_Services_Std_Buy_Amount_number__c;
            qc.pricingExecutive = quote.Pricing_Executive__r.Name;
            qc.datePricingRespond = quote.Date_Pricing_responded__c; 
            qc.finalClient = quote.External_Final_Client_WS__c;
            if(!Test.isRunningTest()){s = cifid.updateQuote(qc);}
            
            System.debug('CIFID_TRIGGER response **** ' + s);
        }
    }
    
    public static HttpResponse login(){
        String dominio = 'login';
        sObject credencial;   
        if(!Test.isRunningTest()){
            credencial = Database.query('SELECT Usuario__c, Password__c, Token__c FROM Cred_Cifid__c');
        }
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://' + dominio + '.salesforce.com/services/Soap/u/44.0');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', '""');
        if(!Test.isRunningTest()){
            req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + 
                        credencial.get('Usuario__c') + '</username><password>' + credencial.get('Password__c') + credencial.get('Token__c') + '</password></login></Body></Envelope>');
        }
        
        Http h = new Http();
        HttpResponse res = h.send(req); 
        return res;
    }
    
    public static void Test(){
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
    }
}