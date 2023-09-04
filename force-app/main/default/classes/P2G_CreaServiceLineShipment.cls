public class P2G_CreaServiceLineShipment implements Queueable {
    private String IdQuote;
    
    public P2G_CreaServiceLineShipment(String IdQuote) {
        this.IdQuote = IdQuote;
    }
    
    public void execute(QueueableContext context) {
        Customer_Quote__c shipmet = [Select Last_Shipment__c From Customer_Quote__c Where Id =: IdQuote limit : 1];
        list<Import_Export_Fee_Line__c> line = [Select id, Name, Import_Export_Quote__c, Conversion_Rate_to_Currency_Header__c,Units__c, CurrencyIsoCode, Service_Rate_Name__c, Quote_Sell_Price__c, Quote_Buy_Price__c From Import_Export_Fee_Line__c Where Import_Export_Quote__c =: IdQuote];
        list<Shipment_Fee_Line__c> listShipmentLine = new List<Shipment_Fee_Line__c>();
          
        for(Integer i=0; i<1; i++){
            Shipment_Fee_Line__c ShipmentLine = new Shipment_Fee_Line__c();
            ShipmentLine.Shipment__c = shipmet.Last_Shipment__c;
            ShipmentLine.Name = line[i].Name;
            ShipmentLine.Import_Export_Quote__c = line[i].Import_Export_Quote__c;
            ShipmentLine.Conversion_Rate_to_Currency_Header__c = line[i].Conversion_Rate_to_Currency_Header__c;
            ShipmentLine.Units__c = line[i].Units__c;
            ShipmentLine.CurrencyIsoCode = line[i].CurrencyIsoCode;
            ShipmentLine.Service_Rate_Name__c = line[i].Service_Rate_Name__c;
            ShipmentLine.Shipment_Sell_Price__c = line[i].Quote_Sell_Price__c;
            ShipmentLine.Shipment_Buy_Price__c = line[i].Quote_Buy_Price__c;
            listShipmentLine.add(ShipmentLine);
        }
        if(!Test.isRunningTest()){
            insert listShipmentLine;    
        }
    }
}