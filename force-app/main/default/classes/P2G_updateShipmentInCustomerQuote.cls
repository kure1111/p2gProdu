public class P2G_updateShipmentInCustomerQuote {

    public static void updateShipment(Customer_Quote__c quote){
        updateShipments(new List<Customer_Quote__c>{ quote });
    }

    public static void updateShipments(List<Customer_Quote__c> quotes){
        Map<Id, Customer_Quote__c> quotePorShipment = new Map<Id, Customer_Quote__c>();
        for(Customer_Quote__c quote : quotes){
            if(quote.Last_Shipment__c != null){
                quotePorShipment.put(quote.Last_Shipment__c, quote);
            }
        }
        if(quotePorShipment.isEmpty()){ return; }

        List<Shipment__c> listShip = new List<Shipment__c>();
        for(Shipment__c actual : [SELECT Id, Route__c, Account_for__c, Border__c, Customs__c,
                                         ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c,
                                         ETD_Time_from_Point_of_Load__c, ETA_Time_Point_of_Discharge__c,
                                         Country_of_Load__c, State_of_Load__c, Site_of_Load__c,
                                         Country_of_Discharge__c, State_of_Discharge__c, Site_of_Discharge__c,
                                         Account_Origin_Address__c, Account_Destination_Address__c
                                  FROM Shipment__c WHERE Id IN :quotePorShipment.keySet()]){
            Customer_Quote__c quote = quotePorShipment.get(actual.Id);
            // si el Shipment ya tiene exactamente estos valores, actualizarlo solo
            // re-dispararia toda su cadena de triggers sin cambiar nada
            Boolean sinCambios =
                actual.Route__c == quote.Route__c &&
                actual.Account_for__c == quote.Account_for__c &&
                actual.Border__c == quote.Border__c &&
                actual.Customs__c == quote.Customs__c &&
                actual.ETD_from_Point_of_Load__c == quote.ETD__c &&
                actual.ETA_Point_of_Discharge__c == quote.ETA__c &&
                actual.ETD_Time_from_Point_of_Load__c == quote.Awaiting_load_time__c &&
                actual.ETA_Time_Point_of_Discharge__c == quote.Awaiting_unload_time__c &&
                actual.Country_of_Load__c == quote.Country_ofLoad__c &&
                actual.State_of_Load__c == quote.State_of_Load__c &&
                actual.Site_of_Load__c == quote.Site_of_Load__c &&
                actual.Country_of_Discharge__c == quote.Country_ofDischarge__c &&
                actual.State_of_Discharge__c == quote.State_of_Discharge__c &&
                actual.Site_of_Discharge__c == quote.Site_of_Discharge__c &&
                actual.Account_Origin_Address__c == quote.Account_Origin_Address__c &&
                actual.Account_Destination_Address__c == quote.Account_Destination_Address__c;
            if(sinCambios){ continue; }

            Shipment__c ship = new Shipment__c();
            ship.Route__c = quote.Route__c;
            ship.Account_for__c = quote.Account_for__c;
            ship.Border__c = quote.Border__c;
            ship.Customs__c = quote.Customs__c;
            ship.ETD_from_Point_of_Load__c = quote.ETD__c;
            ship.ETA_Point_of_Discharge__c = quote.ETA__c;
            ship.ETD_Time_from_Point_of_Load__c = quote.Awaiting_load_time__c;
            ship.ETA_Time_Point_of_Discharge__c = quote.Awaiting_unload_time__c;
            ship.Country_of_Load__c = quote.Country_ofLoad__c;
            ship.State_of_Load__c = quote.State_of_Load__c;
            ship.Site_of_Load__c = quote.Site_of_Load__c;
            ship.Country_of_Discharge__c = quote.Country_ofDischarge__c;
            ship.State_of_Discharge__c = quote.State_of_Discharge__c;
            ship.Site_of_Discharge__c = quote.Site_of_Discharge__c;
            ship.Account_Origin_Address__c = quote.Account_Origin_Address__c;
            ship.Account_Destination_Address__c = quote.Account_Destination_Address__c;
            ship.Id = quote.Last_Shipment__c;
            listShip.add(ship);
        }
        if(!listShip.isEmpty()){ update listShip; }
    }
}
