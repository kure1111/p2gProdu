@isTest
public class CreateQuoteServiceLinesController_Test {
    @isTest
    public static void test(){
       /* SAP_Service_Type__c sst = new SAP_Service_Type__c();
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
        
        Fee__c rate = [SELECT Id FROM Fee__c LIMIT 1];
        
        Customer_Quote__c quote = new Customer_Quote__c();
        quote.Name = 'test';
        quote.Account_for__c = a.Id;
        quote.CurrencyIsoCode = 'MXN';
        quote.Merchandise_Insurance__c = 'NO REQUIERE';
        quote.Motivo__c = 'NO';
        quote.Freight_Mode__c = 'Road';
        quote.Service_Mode__c = 'NATIONAL';
        quote.Service_Type__c = 'FTL';
        insert quote;
        
        Quote_Item_Line__c cl = new Quote_Item_Line__c();
        cl.Name = '001';
        cl.Import_Export_Quote__c = quote.Id;
        cl.Container_Type__c = ct.Id;
        cl.Units__c = 1;
        insert cl;
        
        CreateQuoteServiceLinesController.getQuote(quote.Id);
        CreateQuoteServiceLinesController.consultaRates(quote.Id);
        CreateQuoteServiceLinesController.consultaServiceLines(quote.Id);
        string jsonLineas = '[{"rate":"' + rate.Id +'","units":"1","comments":"Prueba json","feecategory":"Road Freights","currencycode":"MXN","sell":9000,"buy":0}]';
        CreateQuoteServiceLinesController.createLineas(quote.Id, jsonLineas);*/
        CreateQuoteServiceLinesController.test();
    }
}