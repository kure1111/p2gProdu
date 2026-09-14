public class P2G_InterbodegaValidator {
    public static void main (List<Shipment__c> shipments){
        Set<Id> shipmentsId = new Set<Id>();
        for(Shipment__c ships : shipments) {
            shipmentsId.add(ships.Id);
        }
        List<Shipment__c> queryShipments = [SELECT Id, Account_for__c, Account_Origin_Address__c, Account_Destination_Address__c, Interbodegas__c FROM Shipment__c WHERE id IN :shipmentsId];
        
    	Map<Id,String> shipmentInfo = getShipmentInfo(queryShipments);
        Set<Id> matches = verifyAdresses(shipmentInfo);
        
        List<Shipment__c> shipmentsToUpdate = new List<Shipment__c>();
  
        for (Shipment__c shipment : queryShipments){
            if(matches.contains(shipment.Id)) {
                shipment.Interbodegas__c = true;
                shipmentsToUpdate.add(shipment);
            }
        }
        if(!shipmentsToUpdate.isEmpty()) {
            update shipmentsToUpdate;
        }
    }

    private static Map<Id,String> getShipmentInfo(List<Shipment__c> shipmentsCreated) {
		Map<Id,String> accountsWithAddresses = new Map<Id,String>();
        for(Shipment__c shipment : shipmentsCreated) {
            

            String shipmentInfo = shipment.Account_for__c + '|' + shipment.Account_Origin_Address__c + '|' + shipment.Account_Destination_Address__c;
            
            accountsWithAddresses.put(shipment.Id, shipmentInfo);
        }
        
        return accountsWithAddresses;
    }
	// Regresa el Id del shipment que hizo match
    private static Set<Id> verifyAdresses(Map<Id,String> shipmentInfo) {
		Set<String> interbodegaCatalog = buildCatalog();
        Set<Id> shipmentsFound = new Set<Id>();
        
        for (Id shipmentId : shipmentInfo.keySet()) {
            String currentInfo = shipmentInfo.get(shipmentId);
            if (interbodegaCatalog.contains(currentInfo)){
                shipmentsFound.add(shipmentId);
            }
        }
        return shipmentsFound;
    }
    
    private static Set<String> buildCatalog() {
        Set<String> INTERBODEGA_CATALOG = new Set<String>{
            '0014T000005QuHaQAK|a0H4T0000029lf9UAA|a0H4T000002OyLzUAK',
            '0014T000005QuHaQAK|a0H4T0000029lf9UAA|a0HRQ000009veLJ2AY',
            '0014T000005QuHaQAK|a0HRQ000008WNUj2AO|a0H4T000002OyLzUAK',
            '0014T000005QuHaQAK|a0H4T000002OyLzUAK|a0H4T0000029lf9UAA',
            '0014T000005QuHaQAK|a0H4T000002OyyjUAC|a0H4T000002OyLzUAK',
            '0014T000005QuHaQAK|a0H4T000002OyyjUAC|a0HRQ000008WNUj2AO',
            '0014T000005QuHaQAK|a0HRQ000001kroj2AA|a0H4T000002OyLzUAK',
            '0014T000005QuHaQAK|a0HRQ000001kroj2AA|a0HRQ000009veLJ2AY',
            '0014T000005QuHaQAK|a0HRQ000001kroj2AA|a0HRQ000009veLJ2AY',
            '0014T000005QuHaQAK|a0HRQ000001kroj2AA|a0H4T000002OyLfUAK',
            '0014T000005Qy0JQAS|a0H4T000002OoJtUAK|a0H4T000002OTd8UAG',
            '0014T000005Qy0JQAS|a0H4T000002OoJtUAK|a0H4T0000029zuRUAQ',
            '0014T000005Qy0JQAS|a0H4T000002OoJtUAK|a0H4T000002OTd8UAG',
            '0014T000005Qy0JQAS|a0H4T000002OoJtUAK|a0H4T0000029zuRUAQ',
            '0014T000005QuLhQAK|a0HRQ000007vX1e2AE|a0H4T000002P08RUAS',
            '0014T000005QuLhQAK|a0HRQ000007vX1e2AE|a0H4T000002P08CUAS',
            '0014T000005QuLhQAK|a0HRQ000007vX1e2AE|a0H4T000002P08RUAS',
            '0014T000005QxaZQAS|a0H4T000002OyXbUAK|a0H4T000002PTRuUAO',
            '0014T000005QxaZQAS|a0HRQ000007lhDc2AI|a0H4T000002PTRuUAO',
            '0014T000005QxaZQAS|a0HRQ000007lhDc2AI|a0H4T000002Oyk0UAC',
            '0014T000005QxaZQAS|a0HRQ000007lhDc2AI|a0H4T000002P2gpUAC',
            '0014T000005QxaZQAS|a0HRQ000007lhDc2AI|a0HRQ00000EakPF2AZ',
            '0014T000005QxaZQAS|a0HRQ000007lhn32AA|a0H4T000002PTRuUAO',
            '0014T000005QxaZQAS|a0HRQ00000EakPF2AZ|a0H4T000002PTRuUAO',
            '0014T000005QxaZQAS|a0H4T0000029SUPUA2|a0H4T0000029ppsUAA',
            '0014T00000dnrbfQAA|a0H4T000003rdWgUAI|a0H4T000003rdWlUAI',
            '0014T000005Qy0JQAS|a0H4T000002P5lWUAS|a0H4T0000029zuRUAQ'
            //'0014T00000BIs6PQAT|a0HRL0000027orl2AA|a0HRL000003E6s32AC' //Pruebas UAT
        };
        return INTERBODEGA_CATALOG;
    }
    
}