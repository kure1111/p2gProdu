@IsTest(seeAllData=true)
public class P2G_PAK_SalesOrderTest {
    @IsTest
    static void main_test(){
        User u = [SELECT Id, SalesEmployer__c  FROM User WHERE Id =:UserInfo.getUserId()]; 
        Account acc_test = [SELECT Id, Name FROM Account WHERE Venta_Sap__c = 'Contado' AND ActiveSap__c = true LIMIT 1];
        Shipment__c ship = [Select Id,Name,RecordTypeId,Account_for__r.Owner.Workplace__c,CurrencyIsoCode,Sell_Amount_Bloq__c,Shipment_Status__c,Ocean_Shipment_Status__c,Air_Shipment_Status__c,Shipment_Status_Plann__c,Account_for__r.Customer_Id__c,Account_for__r.Owner.SalesEmployer__c,Freight_Mode__c,Service_Mode__c,State_of_Load__c,State_of_Load__r.Name,State_of_Discharge__r.Name, Account_for__r.Venta_Sap__c,
                             Acuse_en_SAP__c,ShipmentLineNoSap__c,ShipmentLineSap__c,AUTORIZAR_GASTO_EXTRA__c,NotificarGastoExtra__c,Total_Services_Sell_Amount__c,OrdenVenta__c,Carrier__r.Customer_Id__c,Orden_de_Compra__c,Status_Shipment__c,Date_Receive_from_SAP__c,Plaza_Vendedor__c,Vendedor_Adicional__c,Service_Type__c, Operation_Executive__r.Name, Operation_Executive_2__r.Name, 
                             Site_of_Load__r.Frontera__c, Site_of_Discharge__r.Frontera__c, Route__r.Name,VerificacionPak__c From Shipment__c WHERE Freight_Mode__c = 'Road' AND Service_Mode__c = 'NATIONAL' AND Shipment_Status_Plann__c = 'Confirmed' AND Carrier__r.Customer_Id__c != null ORDER BY createdDate DESC LIMIT 1];
        String shipId = ship.Id;
        String region = [SELECT Zona_Comercial__c FROM User WHERE Id = :UserInfo.getUserId()][0].Zona_Comercial__c;
        
        list<Shipment_Fee_Line__c> Lines = [SELECT Id,Name,Units__c,CurrencyIsoCode,Shipment_Sell_Price__c,Shipment_Sell_Net_Price__c,Std_Buy_Amount__c,Shipment_Buy_Price__c,Concept_1__c,SAP__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.SAP_Service_Type__r.Group__c,Service_Rate_Name__r.SAP_Service_Type__r.Name, Currency_Buy_Price__c,
                                                Conversion_Rate_to_Buy_Currency_Header__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c,Service_Rate_Name__r.Tipo_RetencionProveedores__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT__c,Service_Rate_Name__r.Carrier_Account__r.Name,SST_Orden_compra__c,SST_Estatus_orden_compra__c/*,SST_Sociedad__c*/
                                                FROM Shipment_Fee_Line__c WHERE Shipment__c=:ship.Id and SAP__c=false];
        
        list<Shipment_Consolidation_Data__c> Quote = [Select Id,Import_Export_Quote__r.Total_Services_Lines_Order_Amount__c From Shipment_Consolidation_Data__c where Shipment__c=:ship.Id];
            
	Test.startTest();
    //Test.setMock(HttpCalloutMock.class, new P2G_MockHttpResponse(7));
    ApexPages.StandardController sc = new ApexPages.StandardController(ship);
    PAK_SalesOrder so = new PAK_SalesOrder(sc);
    so.IdShipment = ship.Id;
    so.SendWS();
    Test.stopTest();
	}
       @IsTest
    static void emptyLinesError_test(){
        User u = [SELECT Id, SalesEmployer__c  FROM User WHERE Id =:UserInfo.getUserId()]; 
        Account acc_test = [SELECT Id, Name FROM Account WHERE Name = 'CLIENTE EJEMPLO DE PRUEBA' LIMIT 1];
        Shipment__c ship = [Select Id,Name,RecordTypeId,Account_for__r.Owner.Workplace__c,CurrencyIsoCode,Sell_Amount_Bloq__c,Shipment_Status__c,Ocean_Shipment_Status__c,Air_Shipment_Status__c,Shipment_Status_Plann__c,Account_for__r.Customer_Id__c,Account_for__r.Owner.SalesEmployer__c,Freight_Mode__c,Service_Mode__c,State_of_Load__c,State_of_Load__r.Name,State_of_Discharge__r.Name, Account_for__r.Venta_Sap__c,
                             Acuse_en_SAP__c,ShipmentLineNoSap__c,ShipmentLineSap__c,AUTORIZAR_GASTO_EXTRA__c,/*SeDesabilitoParaPaseUAT NotificarGastoExtra__c,*/Total_Services_Sell_Amount__c,OrdenVenta__c,Carrier__r.Customer_Id__c,Orden_de_Compra__c,Status_Shipment__c,Date_Receive_from_SAP__c,Plaza_Vendedor__c,Vendedor_Adicional__c,Service_Type__c, Operation_Executive__r.Name, Operation_Executive_2__r.Name, 
                             Site_of_Load__r.Frontera__c, Site_of_Discharge__r.Frontera__c, Route__r.Name,VerificacionPak__c From Shipment__c LIMIT 1];
        String shipId = ship.Id;
        String region = [SELECT Zona_Comercial__c FROM User WHERE Id = :UserInfo.getUserId()][0].Zona_Comercial__c;
        System.debug('imprime region: ' + region);
        //list<Shipment_Fee_Line__c> Lines = [SELECT Id,Name,Units__c,CurrencyIsoCode,Shipment_Sell_Price__c,Shipment_Sell_Net_Price__c,Std_Buy_Amount__c,Shipment_Buy_Price__c,Concept_1__c,SAP__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.SAP_Service_Type__r.Group__c,Service_Rate_Name__r.SAP_Service_Type__r.Name, Currency_Buy_Price__c,
                                                //Conversion_Rate_to_Buy_Currency_Header__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c,Service_Rate_Name__r.Tipo_RetencionProveedores__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT__c,Service_Rate_Name__r.Carrier_Account__r.Name,SST_Orden_compra__c,SST_Estatus_orden_compra__c/*,SST_Sociedad__c*/
                                                //FROM Shipment_Fee_Line__c WHERE Shipment__c=:ship.Id and SAP__c=false];
        
        //list<Shipment_Consolidation_Data__c> Quote = [Select Id,Import_Export_Quote__r.Total_Services_Lines_Order_Amount__c From Shipment_Consolidation_Data__c where Shipment__c=:ship.Id];
            
	Test.startTest();
    Test.setMock(HttpCalloutMock.class, new P2G_MockHttpResponse(7));
    ApexPages.StandardController sc = new ApexPages.StandardController(ship);
    PAK_SalesOrder so = new PAK_SalesOrder(sc);
    so.IdShipment = ship.Id;
    so.SendWS();
    Test.stopTest();
	}
}