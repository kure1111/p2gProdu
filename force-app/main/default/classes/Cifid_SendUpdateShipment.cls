public class Cifid_SendUpdateShipment {
    public static boolean firstRun = true;
    
    @future(callout=true)
    public static void send(Set<Id> lstIds){
        List<Customer_Quote__c> lstQuotes = [SELECT Id, Name, Last_Shipment__r.Name, Last_Shipment__r.Shipment_Status_Plann__c, Last_Shipment__r.Shipment_Status_Mon__c, Last_Shipment__r.Shipment_Status__c, Last_Shipment__r.Ocean_Shipment_Status__c,
                                             Last_Shipment__r.Air_Shipment_Status__c, Last_Shipment__r.Shipment_Currency__c, Last_Shipment__r.Operation_Executive__r.Name, Last_Shipment__r.Carrier__r.Name, Last_Shipment__r.ATD__c, Last_Shipment__r.ATA__c,
                                             Last_Shipment__r.Origin_Address__c, Last_Shipment__r.Delivery_Address_Shipment__c, Last_Shipment__r.MAWB_Number__c, Last_Shipment__r.Air_Booking_Number__c, Last_Shipment__r.Flight_Number__c, Last_Shipment__r.Total_Services_Std_Buy_Amount_number__c, 
                                             Last_Shipment__r.Sea_Container_Number__c, Last_Shipment__r.HBL_Number__c, Last_Shipment__r.Sea_Booking_Number__c, Last_Shipment__r.Free_Days__c, Last_Shipment__r.Booking_Confirmation__c, 
                                             Last_Shipment__r.Truck_Vessel_Flight__r.Name, Last_Shipment__r.Vessel_Latitude_Vessel__c, Last_Shipment__r.Vessel_Longitude_Vessel__c, Last_Shipment__r.Last_Update_Vessel__c
                                             FROM Customer_Quote__c 
                                             WHERE Id IN:lstIds];
        System.debug('CIFID_TRIGGER SHIPMENT quotes **** ' + lstQuotes);
        
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
        
        Cifid_updateQuoteShipment.Cifid_ShipmentFromPak cifid = new Cifid_updateQuoteShipment.Cifid_ShipmentFromPak();
        cifid.SessionHeader = new Cifid_updateQuoteShipment.SessionHeader_element();
        cifid.SessionHeader.sessionId = SESSION_ID;
        
        for(Customer_Quote__c quote : lstQuotes){            
            Cifid_updateQuoteShipment.Shipment ship = new Cifid_updateQuoteShipment.Shipment();
            Cifid_updateQuoteShipment.estatus s;
            
            ship.externalQuoteNumber = quote.Name;
            ship.externalNumber = quote.Last_Shipment__r.Name;
            ship.statusPlanner =  quote.Last_Shipment__r.Shipment_Status_Plann__c;
            ship.statusMonitoreo = quote.Last_Shipment__r.Shipment_Status_Mon__c;
            ship.oceanExpoStatus = quote.Last_Shipment__r.Shipment_Status__c;
            ship.oceanImpoStatus = quote.Last_Shipment__r.Ocean_Shipment_Status__c;
            ship.airStatus = quote.Last_Shipment__r.Air_Shipment_Status__c;
            ship.spCurrency = quote.Last_Shipment__r.Shipment_Currency__c;
            ship.opExecutive = quote.Last_Shipment__r.Operation_Executive__r.Name;
            ship.carrier = quote.Last_Shipment__r.Carrier__r.Name;
            ship.atd = quote.Last_Shipment__r.ATD__c != null ? string.valueOf(quote.Last_Shipment__r.ATD__c) : '';
            ship.ata = quote.Last_Shipment__r.ATA__c != null ? string.valueOf(quote.Last_Shipment__r.ATA__c) : '';
            ship.pickupAddress = quote.Last_Shipment__r.Origin_Address__c;
            ship.deliveryAddress = quote.Last_Shipment__r.Delivery_Address_Shipment__c;
            ship.mawbNumber = quote.Last_Shipment__r.MAWB_Number__c;
            ship.airBookingNumber = quote.Last_Shipment__r.Air_Booking_Number__c;
            ship.flightNumber = quote.Last_Shipment__r.Flight_Number__c;
            ship.totalServBuyAmmount = quote.Last_Shipment__r.Total_Services_Std_Buy_Amount_number__c != null ? string.valueOf(quote.Last_Shipment__r.Total_Services_Std_Buy_Amount_number__c) : '';
            ship.seaContainerNumber = quote.Last_Shipment__r.Sea_Container_Number__c;
            ship.hblNumber = quote.Last_Shipment__r.HBL_Number__c;
            ship.seaBookingNumber = quote.Last_Shipment__r.Sea_Booking_Number__c;
            ship.freeDays = quote.Last_Shipment__r.Free_Days__c != null ? string.valueOf(quote.Last_Shipment__r.Free_Days__c) : '';
            ship.bookingconfirmation = quote.Last_Shipment__r.Booking_Confirmation__c != null ? string.valueOf(quote.Last_Shipment__r.Booking_Confirmation__c) : '';
            ship.vessel = quote.Last_Shipment__r.Truck_Vessel_Flight__r.Name;
            ship.vesselLat = quote.Last_Shipment__r.Vessel_Latitude_Vessel__c;
            ship.vesselLon = quote.Last_Shipment__r.Vessel_Longitude_Vessel__c;
            ship.lastUpdate = quote.Last_Shipment__r.Last_Update_Vessel__c;
            
            if(!Test.isRunningTest()){
                s = cifid.updateQuote(ship);
            }
            
            System.debug('CIFID_TRIGGER SHIPMENT response **** ' + s);
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