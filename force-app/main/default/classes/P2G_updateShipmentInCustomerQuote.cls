public class P2G_updateShipmentInCustomerQuote {
    public static void updateShipment(Customer_Quote__c quote){
        List<Shipment__c> listShip = new List<Shipment__c>();
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
        update ship;
    }
}