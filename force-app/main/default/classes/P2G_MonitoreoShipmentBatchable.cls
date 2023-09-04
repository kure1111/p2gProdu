global class P2G_MonitoreoShipmentBatchable implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    List<Shipment__c> listShipment = new List<Shipment__c>();
    Integer cont = 0;
    global P2G_MonitoreoShipmentBatchable(List<Shipment__c> ListShipment){
        this.listShipment = ListShipment;
    }
    global List<Shipment__c> start(Database.BatchableContext bc) {
        return this.listShipment;
    }
    global void execute(Database.BatchableContext bc, List<Shipment__c> shipment){
        List<String> listaJson = new List<String>();
        List<Response__c> listaSearch = new List<Response__c>();
        List<Shipment__c> listaShip = new List<Shipment__c>();
        P2G_WS_EmbarquesWrapper.searchFilters searchFilters = new P2G_WS_EmbarquesWrapper.searchFilters();
        String tokenRC;
        for(Shipment__c ship : shipment){
            searchFilters.key = 'STOP';
            searchFilters.company_type = 'SUPPLIER';
            searchFilters.activity_num = ship.Name;
            searchFilters.shipment = ship.Name;
            String json = '{"search_filters":'+SYSTEM.Json.serialize(searchFilters)+'}';
            System.debug('json '+json);
            listaJson.add(json);
            if(Test.isRunningTest()){
                tokenRC = 'prueba test';
            }else{
            	tokenRC = P2G_getToken.getTokenRecursoC();
            }
            System.debug('token'+tokenRC);
            String message = P2G_MonitoreoShipment.callWebService(tokenRC,json,ship.Id);
            system.debug('mensaje'+message);
            Response__c SapRespnse = P2G_MonitoreoShipment.creaSAPResponse(ship.Id,message);
            listaSearch.add(SapRespnse);
            Shipment__c updateShip = P2G_MonitoreoShipment.updateShipment(ship.Id,message);
            if(updateShip != null){
                listaShip.add(updateShip);
            }
            System.debug('updateShipment: '+listaShip);
        }
        	insert listaSearch;
            P2G_llamadoWebHelper.setWebServiceUpdate(true);
            Update listaShip;
        cont++;
        System.debug('cont'+cont);
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    

}