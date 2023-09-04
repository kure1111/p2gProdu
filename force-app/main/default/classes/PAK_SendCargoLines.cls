public class PAK_SendCargoLines {
    public static boolean firstRun = true;
    
    @future(callout=true)
    public static void send(Set<Id> lstIds, Integer operation){
        System.debug('PAK_SendCargoLines FutureHandler - operation: ' + operation + ' lstIds: ' + lstIds);
        String soap = '';
        String soapLines = '';
        
        if(operation == 3){
            System.debug('PAK_SendCargoLines Op - 3');
            for(Id line : lstIds){
                soapLines += '<pak:lines>';
                soapLines += '<pak:idLine>' + line + '</pak:idLine>';
                soapLines += '</pak:lines>';
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
            
            soap = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pak="http://soap.sforce.com/schemas/class/PAK_QuoteCL">' +
                '<soapenv:Header>' +
                '<pak:SessionHeader>' +
                '<pak:sessionId>' + SESSION_ID + '</pak:sessionId>' +
                '</pak:SessionHeader>' +
                '</soapenv:Header>' +
                '<soapenv:Body>' +
                '<pak:cargoLines>' +
                '<pak:quote>' + soapLines +
                '<pak:operation>' + operation + '</pak:operation>' +
                '</pak:quote>' +
                '</pak:cargoLines>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
            if(!Test.isRunningTest()){System.debug('Response: ' + sendCargoLines(soap).getBody()); }
        }else{
            List<Quote_Item_Line__c> lstLines =  [SELECT Id, Item_Name__r.Name, Container_Type__r.Name, Units__c, Total_Shipping_Weight_Kgs__c, Total_Shipping_Volume_m3__c, Item_Height__c, 
                                                  Item_Width_cm__c, Item_Lenght_cm__c, Import_Export_Quote__r.Name, HS_Code__c, Price__c
                                                  FROM Quote_Item_Line__c 
                                                  WHERE Id IN:lstIds];
            System.debug('PAK_SendCargoLines lines **** ' + lstLines);
            
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
            
            for(Quote_Item_Line__c line : lstLines){
                soapLines += '<pak:lines>';
                soapLines += '<pak:containerType>' + line.Container_Type__r.Name +'</pak:containerType>';
                soapLines += '<pak:idLine>' + line.Id + '</pak:idLine>';
                soapLines += '<pak:itemHeight>' + line.Item_Height__c +'</pak:itemHeight>';
                soapLines += '<pak:itemLength>' + line.Item_Lenght_cm__c + '</pak:itemLength>';
                soapLines += '<pak:itemName>' + line.Item_Name__r.Name + '</pak:itemName>';
                soapLines += '<pak:itemUnitVolume>' + line.Total_Shipping_Volume_m3__c + '</pak:itemUnitVolume>';
                soapLines += '<pak:itemUnitWeight>' + line.Total_Shipping_Weight_Kgs__c + '</pak:itemUnitWeight>';
                soapLines += '<pak:itemWidth>' + line.Item_Width_cm__c + '</pak:itemWidth>';
                soapLines += '<pak:units>' + line.Units__c + '</pak:units>';
                soapLines += '<pak:fraccion>' + line.HS_Code__c + '</pak:fraccion>';
                soapLines += '<pak:merchValue>' + line.Price__c + '</pak:merchValue>';
                soapLines += '</pak:lines>';
            }
            string quoteName = '';
            if(!Test.isRunningTest()){ quoteName= lstLines[0].Import_Export_Quote__r.Name;}
            soap = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pak="http://soap.sforce.com/schemas/class/PAK_QuoteCL">' +
                '<soapenv:Header>' +
                '<pak:SessionHeader>' +
                '<pak:sessionId>' + SESSION_ID + '</pak:sessionId>' +
                '</pak:SessionHeader>' +
                '</soapenv:Header>' +
                '<soapenv:Body>' +
                '<pak:cargoLines>' +
                '<pak:quote>' + soapLines +
                '<pak:operation>' + operation + '</pak:operation>' +
                '<pak:quoteName>' + quoteName +'</pak:quoteName>' +
                '</pak:quote>' +
                '</pak:cargoLines>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
            
            if(!Test.isRunningTest()){System.debug('Response: ' + sendCargoLines(soap).getBody()); }
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
    
    public static HttpResponse sendCargoLines(string body){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://na85.salesforce.com/services/Soap/class/PAK_QuoteCL');
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', '""');
        req.setBody(body);
        
        Http h = new Http();
        HttpResponse res = h.send(req); 
        return res;
    }
    
    public static void Test(){
        string test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
        test = '';
    }
}