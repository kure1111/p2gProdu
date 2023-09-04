@isTest
public class TarifarioMaestroController_Test {
    @isTest
    public static void test(){
        TarifarioMaestroController.consultaRates(true, '', '', '', '', '');
        
        SAP_Service_Type__c sst = new SAP_Service_Type__c();
        sst.Name = 'test';
        sst.Activo__c = true;
        sst.Group__c = 'Fletes';
        insert sst;
        
        Account a = new Account();
        a.Name = 'test';
        insert a;
        
        Carrier_Line_Load_Point__c ruta = new Carrier_Line_Load_Point__c();
        ruta.Name = 'test';
        insert ruta;
        Carrier_Line_Load_Point__c ruta2 = new Carrier_Line_Load_Point__c();
        ruta.Name = 'test2';
        insert ruta2;
        
        Container_Type__c ct = new Container_Type__c();
        ct.Name = 'test';
        insert ct;
        
        List<Carrier_Line_Load_Point__c> rutas = [SELECT Id, Name FROM Carrier_Line_Load_Point__c];
        System.debug('Rutas: ' + rutas);
        
        string json = '[{"Route":"-","RateName":"Flete 3","ValidFrom":"01/10/2020","ValidUntil":"30/10/2020","AccountFor":"test","TTDays":"5","ContainerType":"test","SellRate":"50000", "Grupo":"Fletes", "SAPST":"test", "Comments":"N/A"}]';
        CargaTarifarioVentaController.cargarTarifario(json);
        
        List<Fee__c> rates = [SELECT Id, Buy_Rate__c, Carrier_Account__c FROM Fee__c];
        CargaTarifarioCompraController.cargarTarifario('[{"Id":"' + rates[0].Id +'", "compra" : "1200", "carrier": "test"}]');
        
        Fee__c rate = new Fee__c();
        rate.Route__c = ruta2.Id;
        rate.Name = 'Diff';
        rate.Valid_From__c = system.today();
        rate.Valid_Until__c = system.today();
        rate.Account_for__c = a.Id;
        rate.TT_Days__c = '3';
        rate.Container_Type__c = ct.Id;
        rate.Group__c = 'Fletes';
        rate.Fee_Rate__c = 1000;
        rate.SAP_Service_Type__c = sst.Id;
        rate.Buy_Rate__c = 800;
        rate.Carrier_Account__c = a.Id;
        rate.Active__c = true;
        rate.Tarifario_Compras__c = true;
        insert rate;
        
        TarifarioMaestroController.consultaRates(true, '', '', '', '', '');
    }
}