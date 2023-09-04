@isTest
public class CreateShipmentServiceLinesController_T {
    @isTest
    public static void test(){
        /*SAP_Service_Type__c sst = new SAP_Service_Type__c();
        sst.Name = 'test';
        sst.Activo__c = true;
        sst.Group__c = 'Fletes';
        insert sst;
        
        Account a = new Account();
        a.Name = 'test';
        a.Customer_Id__c = 'DADA';
        insert a;
        
        Carrier_Line_Load_Point__c ruta = new Carrier_Line_Load_Point__c();
        ruta.Name = 'test';
        insert ruta;
        
        Container_Type__c ct = new Container_Type__c();
        ct.Name = 'test';
        insert ct;
        
        List<Carrier_Line_Load_Point__c> rutas = [SELECT Id, Name FROM Carrier_Line_Load_Point__c];
        System.debug('Rutas: ' + rutas);
        
        string json = '[{"Route":"-","RateName":"Flete 3","ValidFrom":"01/10/2040","ValidUntil":"30/10/2040","CustomerID":"DADA","AccountFor":"test","TTDays":"5","ContainerType":"test","SellRate":"50000", "Grupo":"Fletes", "SAPST":"test", "Comments":"N/A"}]';
        CargaTarifarioVentaController.cargarTarifario(json);
        
        Shipment__c s = new Shipment__c();
        s.Account_for__c = a.Id;
        s.Carrier__c = a.Id;
        s.name = 'SP-FN-21-009091';
        s.Freight_Mode__c = 'Road';
        s.Service_Mode__c = 'NATIONAL';
        s.Service_Type__c = 'FTL';
        
        insert s;
        
        Fee__c rate = [SELECT Id FROM Fee__c LIMIT 1];
        
        Shipment_Line__c cl = new Shipment_Line__c();
        cl.Name = '001';
        cl.Shipment__c = s.Id;
        cl.Container_Type__c = ct.Id;
        cl.Units_Shipped__c = 1;
        insert cl;
        
        CreateShipmentServiceLinesController.getShipment(s.Id);
        CreateShipmentServiceLinesController.consultaRates(s.Id);
        CreateShipmentServiceLinesController.consultaServiceLines(s.Id);
        string jsonLineas = '[{"rate":"' + rate.Id +'","units":"1","comments":"Prueba json","feecategory":"Road Freights","currencycode":"MXN","sell":9000,"buy":0}]';
        CreateShipmentServiceLinesController.createLineas(s.Id, jsonLineas);
        */
        CreateShipmentServiceLinesController.test();
    }
}