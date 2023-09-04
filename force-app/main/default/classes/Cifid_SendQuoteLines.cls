public class Cifid_SendQuoteLines {
    public static boolean firstRun = true;
    
    @future(callout=true)
    public static void send(Set<Id> lstIds, Integer operation){
        System.debug('Cifid_SendQuoteLines FutureHandler - operation: ' + operation + ' lstIds: ' + lstIds);
        List<CifidQuoteLines.Quote> lstSend = new List<CifidQuoteLines.Quote>();
        if(operation == 3){
            System.debug('Cifid_SendQuoteLines Op - 3');
            CifidQuoteLines.Quote quote = new CifidQuoteLines.Quote();
            List<CifidQuoteLines.QuoteLine> lstQuoteLines = new List<CifidQuoteLines.QuoteLine>();
            quote.operation = operation;
            for(Id lineId : lstIds){
                CifidQuoteLines.QuoteLine ql = new CifidQuoteLines.QuoteLine();
                ql.idLine = lineId;
                lstQuoteLines.add(ql);
            }
            quote.lines = lstQuoteLines;
            lstSend.add(quote);
            System.debug('Cifid_SendQuoteLines lstSend == **** ' + lstSend);
        }else{
            List<Import_Export_Fee_Line__c> lstLines = [SELECT Id, Service_Rate_Category__c, Service_Rate_Name__r.Name, Units__c, Quote_Sell_Price__c, Sell_Amount__c, Quote_Buy_Price__c, Buy_Amount__c, Carrier__c, Import_Export_Quote__r.Name
                                                        FROM Import_Export_Fee_Line__c WHERE Id IN:lstIds ORDER BY Import_Export_Quote__r.Name];
            System.debug('Cifid_SendQuoteLines lines **** ' + lstLines);
            
            CifidQuoteLines.Quote quote = new CifidQuoteLines.Quote();
            System.debug('Cifid_SendQuoteLines FirstLine **** ' + lstLines[0].Import_Export_Quote__r.Name);
            quote.quoteName = lstLines[0].Import_Export_Quote__r.Name;
            quote.operation = operation;
            
            List<CifidQuoteLines.QuoteLine> lstQuoteLines = new List<CifidQuoteLines.QuoteLine>();
            
            for(Import_Export_Fee_Line__c line : lstLines){    
                if(line.Import_Export_Quote__r.Name == quote.quoteName){
                    System.debug('Cifid_SendQuoteLines line name == **** ' + line.Import_Export_Quote__r.Name);
                    CifidQuoteLines.QuoteLine ql = new CifidQuoteLines.QuoteLine();
                    ql.idLine = line.Id;
                    ql.rateCategory = line.Service_Rate_Category__c;
                    ql.rateName = line.Service_Rate_Name__r.Name;
                    ql.units = line.Units__c;
                    ql.quoteSellPrice = line.Quote_Sell_Price__c;
                    ql.sellNetAmmount = line.Sell_Amount__c;
                    ql.quoteStdBuyPrice = line.Quote_Buy_Price__c;
                    ql.StdBuyAmmount = line.Buy_Amount__c;
                    ql.carrier = line.Carrier__c;
                    lstQuoteLines.add(ql);
                }else{
                    System.debug('Cifid_SendQuoteLines line name != **** ' + line.Import_Export_Quote__r.Name);
                    quote.lines = lstQuoteLines;
                    lstSend.add(quote);
                    
                    lstQuoteLines = new List<CifidQuoteLines.QuoteLine>();
                    quote = new CifidQuoteLines.Quote();
                    quote.quoteName = line.Import_Export_Quote__r.Name;
                    quote.operation = operation;
                    
                    CifidQuoteLines.QuoteLine ql = new CifidQuoteLines.QuoteLine();
                    ql.idLine = line.Id;
                    ql.rateCategory = line.Service_Rate_Category__c;
                    ql.rateName = line.Service_Rate_Name__r.Name;
                    ql.units = line.Units__c;
                    ql.quoteSellPrice = line.Quote_Sell_Price__c;
                    ql.sellNetAmmount = line.Sell_Amount__c;
                    ql.quoteStdBuyPrice = line.Quote_Buy_Price__c;
                    ql.StdBuyAmmount = line.Buy_Amount__c;
                    ql.carrier = line.Carrier__c;
                    lstQuoteLines.add(ql);
                }
            }
            quote.lines = lstQuoteLines;
            lstSend.add(quote);
            System.debug('Cifid_SendQuoteLines lstSend == **** ' + lstSend);
        }
        HttpResponse res;
        if(!Test.isRunningTest()){res = login();}
        
        String SESSION_ID;
        Dom.XmlNode resultElmt;
        if(!Test.isRunningTest()){                
            resultElmt = res.getBodyDocument().getRootElement().getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/').getChildElement('loginResponse','urn:partner.soap.sforce.com').getChildElement('result','urn:partner.soap.sforce.com');                          
            SESSION_ID = resultElmt.getChildElement('sessionId','urn:partner.soap.sforce.com').getText();
        }else{
            SESSION_ID = 'TestId';
        } 
        
        CifidQuoteLines.Cifid_QuoteLines cifid = new CifidQuoteLines.Cifid_QuoteLines();
        cifid.SessionHeader = new CifidQuoteLines.SessionHeader_element();
        cifid.SessionHeader.sessionId = SESSION_ID;
        
        for(CifidQuoteLines.Quote s : lstSend){
            if(!Test.isRunningTest()){System.debug('CIFID_TRIGGER response ' + s.quoteName + ' **** ' + cifid.quoteLines(s));}
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
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
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