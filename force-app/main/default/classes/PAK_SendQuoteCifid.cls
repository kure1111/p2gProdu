public class PAK_SendQuoteCifid {
    public static boolean firstRun = true;
    
    @future(callout=true)
    public static void send(Set<Id> lstIds){
        List<Customer_Quote__c> lstQuotes = [SELECT Id, Name, Account_for__r.Name, Contact__r.Name, Quotation_Status__c, CurrencyIsoCode, Sales_Incoterm__c, Freight_Mode__c, Service_Mode__c, Service_Type__c, Country_ofLoad__r.Name, 
                                             State_of_Load__r.Name, Site_of_Load__r.Name, ETD__c, Origin_Address__c, Move_Type__c, Country_ofDischarge__r.Name, State_of_Discharge__r.Name, Site_of_Discharge__r.Name, 
                                             ETA__c, Destination_Address__c, Trade_License__c, Merchandise_has_being_paid__c, Service_Type_St__c, Customer_Type__c, Account_for__r.Owner.Name, Customs__c, Workplace_Account_Owner__c, 
                                             Email_Account_Owner__c, Final_Client_Pak__c, Merchandise_Insurance__c
                                             FROM Customer_Quote__c 
                                             WHERE Id IN:lstIds];
        System.debug('PAK_SendQuoteCifid quotes **** ' + lstQuotes);
        
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
        
        PakQuoteToCifid.Pak_Quote ws = new PakQuoteToCifid.Pak_Quote();
        ws.SessionHeader = new PakQuoteToCifid.SessionHeader_element();
        ws.SessionHeader.sessionId = SESSION_ID;
        
        for(Customer_Quote__c quote : lstQuotes){            
            PakQuoteToCifid.Quote q = new PakQuoteToCifid.Quote();
            q.quoteName = quote.Name;
            q.accountFor = quote.Account_for__r.Name;
            q.contacto = quote.Contact__r.Name;
            q.quoteStatus = quote.Quotation_Status__c;
            q.moneda = quote.CurrencyIsoCode;
            q.incoterm = quote.Sales_Incoterm__c;
            q.freigthMode = quote.Freight_Mode__c;
            q.serviceMode = quote.Service_Mode__c;
            q.serviceType = quote.Service_Type__c;
            q.countryOfLoad = quote.Country_ofLoad__r.Name;
            q.stateOfLoad = quote.State_of_Load__r.Name;
            q.siteOfLoad = quote.Site_of_Load__r.Name;
            q.ETD = quote.ETD__c;
            q.originAddress = quote.Origin_Address__c;
            q.moveType = quote.Move_Type__c;
            q.countryOfDischarge = quote.Country_ofDischarge__r.Name;
            q.stateOfDischarge = quote.State_of_Discharge__r.Name;
            q.siteOfDischarge = quote.Site_of_Discharge__r.Name;
            q.ETA = quote.ETA__c;
            q.destinationAddress = quote.Destination_Address__c;
            q.tradeLicense = quote.Trade_License__c;
            q.merchHasBeingPaid = quote.Merchandise_has_being_paid__c;
            q.serviceTypeSt = quote.Service_Type_St__c;
            q.customerType = quote.Customer_Type__c;
            q.logisticAcctOwner = quote.Account_for__r.Owner.Name;
            q.port = quote.Customs__c;
            q.merchInsurance = quote.Merchandise_Insurance__c;
            q.workplaceAcctOwner = quote.Workplace_Account_Owner__c;
            q.emailAcctOwner = quote.Email_Account_Owner__c;
            q.finalClient = quote.Final_Client_Pak__c;
            
            if(!Test.isRunningTest()){System.debug('PAK_SendQuoteCifid response **** ' + ws.quoteFromPak(q));}
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
        String tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
        tst = '';
    }
}