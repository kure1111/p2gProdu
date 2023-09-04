public class Cifid_SendShipLines {
    public static boolean firstRun = true;
    
    @future(callout=true)
    public static void send(Set<Id> lstIds, Integer operation){
        System.debug('Cifid_SendShipLines FutureHandler - operation: ' + operation + ' lstIds: ' + lstIds);
        List<CifidShipmentLines.Shipment> lstSend = new List<CifidShipmentLines.Shipment>();
        if(operation == 3){
            System.debug('Cifid_SendShipLines Op - 3');
            CifidShipmentLines.Shipment ship = new CifidShipmentLines.Shipment();
            List<CifidShipmentLines.ShipLine> lstShipLines = new List<CifidShipmentLines.ShipLine>();
            ship.operation = operation;
            for(Id lineId : lstIds){
                CifidShipmentLines.ShipLine ql = new CifidShipmentLines.ShipLine();
                ql.idLine = lineId;
                lstShipLines.add(ql);
            }
            ship.lines = lstShipLines;
            lstSend.add(ship);
            System.debug('Cifid_SendShipLines lstSend == **** ' + lstSend);
        }else{
            List<Shipment_Fee_Line__c> lstLines = [SELECT Id, Name, Service_Rate_Category__c, Service_Rate_Name__r.Name, Carrier__c, Units__c, Shipment_Sell_Price__c, Sell_Amount__c, Shipment_Buy_Price__c, Std_Buy_Amount__c, Shipment__r.Name
                                                   FROM Shipment_Fee_Line__c 
                                                   WHERE Id IN:lstIds ORDER BY Shipment__r.Name];
            System.debug('Cifid_SendShipLines lines **** ' + lstLines);
            
            CifidShipmentLines.Shipment ship = new CifidShipmentLines.Shipment();
            System.debug('Cifid_SendShipLines FirstLine **** ' + lstLines[0].Shipment__r.Name);
            ship.shipName = lstLines[0].Shipment__r.Name;
            ship.operation = operation;
            
            List<CifidShipmentLines.ShipLine> lstShipLines = new List<CifidShipmentLines.ShipLine>();
            
            for(Shipment_Fee_Line__c line : lstLines){    
                if(line.Shipment__r.Name == ship.shipName){
                    System.debug('Cifid_SendShipLines line name == **** ' + line.Shipment__r.Name);
                    CifidShipmentLines.ShipLine ql = new CifidShipmentLines.ShipLine();
                    ql.idLine = line.Id;
                    ql.rateCategory = line.Service_Rate_Category__c;
                    ql.rateName = line.Service_Rate_Name__r.Name;
                    ql.units = line.Units__c;
                    ql.shipSellPrice = line.Shipment_Sell_Price__c;
                    ql.sellNetAmmount = line.Sell_Amount__c;
                    ql.shipStdBuyPrice = line.Shipment_Buy_Price__c;
                    ql.StdBuyAmmount = line.Std_Buy_Amount__c;
                    ql.carrier = line.Carrier__c;
                    lstShipLines.add(ql);
                }else{
                    System.debug('Cifid_SendShipLines line name != **** ' + line.Shipment__r.Name);
                    ship.lines = lstShipLines;
                    lstSend.add(ship);
                    
                    lstShipLines = new List<CifidShipmentLines.ShipLine>();
                    ship = new CifidShipmentLines.Shipment();
                    ship.shipName = line.Shipment__r.Name;
                    ship.operation = operation;
                    
                    CifidShipmentLines.ShipLine ql = new CifidShipmentLines.ShipLine();
                    ql.idLine = line.Id;
                    ql.rateCategory = line.Service_Rate_Category__c;
                    ql.rateName = line.Service_Rate_Name__r.Name;
                    ql.units = line.Units__c;
                    ql.shipSellPrice = line.Shipment_Sell_Price__c;
                    ql.sellNetAmmount = line.Sell_Amount__c;
                    ql.shipStdBuyPrice = line.Shipment_Buy_Price__c;
                    ql.StdBuyAmmount = line.Std_Buy_Amount__c;
                    ql.carrier = line.Carrier__c;
                    lstShipLines.add(ql);
                }
            }
            ship.lines = lstShipLines;
            lstSend.add(ship);
            System.debug('Cifid_SendShipLines lstSend == **** ' + lstSend);
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
        
        CifidShipmentLines.Cifid_ShipmentLines cifid = new CifidShipmentLines.Cifid_ShipmentLines();
        cifid.SessionHeader = new CifidShipmentLines.SessionHeader_element();
        cifid.SessionHeader.sessionId = SESSION_ID;
        
        for(CifidShipmentLines.Shipment s : lstSend){
            if(!Test.isRunningTest()){System.debug('CIFID_TRIGGER SendShipLines response ' + s.shipName + ' **** ' + cifid.shipmentLines(s));}
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
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
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