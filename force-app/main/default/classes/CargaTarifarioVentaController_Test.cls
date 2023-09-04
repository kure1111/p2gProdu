@isTest
public class CargaTarifarioVentaController_Test {
    @isTest
    public static void test(){
        SAP_Service_Type__c sst = new SAP_Service_Type__c();
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
        
        string json = '[{"Route":"-","RateName":"Flete 3","ValidFrom":"01/10/2020","ValidUntil":"30/10/2020","CustomerID":"DADA","AccountFor":"test","TTDays":"5","ContainerType":"test","SellRate":"50000", "Grupo":"Fletes", "SAPST":"test", "Comments":"N/A"}]';
        CargaTarifarioVentaController.cargarTarifario(json);
    }
}