public with sharing class API_Querys {
    
    public static recordType getRecordTypeByName(string nameRecordType) {
        return[SELECT id,name FROM recordType WHERE name=:nameRecordType limit 1];
    }
    // QUERYS User
    public static User getOwner(string recordID) {
        return[SELECT Id, Name, Email FROM User WHERE Id =:recordID AND Email != null limit 1];
    }
    
    // QUERYS Account
    public static account getAccByID(string recordID) {
        return[SELECT ID,Name,is_Ready_SAP__c, Fecha_Alta_Cliente_SAP__c, Fecha_Actualizacion_Cliente_SAP__c,recordtypeId,recordtype.Name FROM Account WHERE ID=:recordID LIMIT 1];
    }
    public static List <account> getAccByListIDs(list<id> recordIDLst) {
        return[SELECT id,name FROM Account WHERE ID IN:recordIDLst];
    }

    // QUERYS Shipment
    public static Shipment__c getShipmentByID(STRING recordID) {
        return[SELECT Id, Name, Account_for__c, Account_for__r.Customer_Id__c, Account_for__r.Name, Account_for__r.OwnerId, Account_for__r.Owner.Workplace__c, Account_for__r.Owner.SalesEmployer__c, Account_for__r.Venta_Sap__c, Acuse_en_SAP__c, Air_Shipment_Status__c, AUTORIZAR_GASTO_EXTRA__c, Carrier__r.Customer_Id__c, Contact__r.Name, Contact__r.Email, Container_Type__c, Container_Type__r.Name, CreatedDate, CurrencyIsoCode, Date_Receive_from_SAP__c, ETD_from_Point_of_Load__c, Freight_Mode__c, N_Containers__c, NotificarGastoExtra__c, Ocean_Shipment_Status__c, Operation_Executive__r.Name, Operation_Executive_2__r.Name, OrdenVenta__c, Orden_de_Compra__c, order__c, Plaza_Vendedor__c, RecordTypeId, Route__c, Route__r.Name, Routing_Operation_Status__c, Sell_Amount_Bloq__c, Service_Mode__c, Service_Type__c, Shipment_Status__c, Shipment_Status_Plann__c, ShipmentLineNoSap__c, ShipmentLineSap__c, Site_of_Load__r.Frontera__c, Site_of_Discharge__r.Frontera__c, State_of_Load__c, State_of_Discharge__r.Name, State_of_Load__r.Name, Status_Shipment__c, Total_Services_Sell_Amount__c, Vendedor_Adicional__c  FROM Shipment__c WHERE Id =: recordID LIMIT 1];
    }
    public static List <Shipment__c> getShipmentListIDs(set<String> recordIDLst) {
        return[SELECT Id, Name, Account_for__c, Account_for__r.Customer_Id__c, Account_for__r.Name, Account_for__r.OwnerId, Account_for__r.Owner.Workplace__c, Account_for__r.Owner.SalesEmployer__c, Account_for__r.Venta_Sap__c, Acuse_en_SAP__c, Air_Shipment_Status__c, AUTORIZAR_GASTO_EXTRA__c, Carrier__r.Customer_Id__c, Contact__r.Name, Contact__r.Email, Container_Type__c, Container_Type__r.Name, CreatedDate, CurrencyIsoCode, Date_Receive_from_SAP__c, ETD_from_Point_of_Load__c, Freight_Mode__c, N_Containers__c, NotificarGastoExtra__c, Ocean_Shipment_Status__c, Operation_Executive__r.Name, Operation_Executive_2__r.Name, OrdenVenta__c, Orden_de_Compra__c, order__c, Plaza_Vendedor__c, RecordTypeId, Route__c, Route__r.Name, Routing_Operation_Status__c, Sell_Amount_Bloq__c, Service_Mode__c, Service_Type__c, Shipment_Status__c, Shipment_Status_Plann__c, ShipmentLineNoSap__c, ShipmentLineSap__c, Site_of_Load__r.Frontera__c, Site_of_Discharge__r.Frontera__c, State_of_Load__c, State_of_Discharge__r.Name, State_of_Load__r.Name, Status_Shipment__c, Total_Services_Sell_Amount__c, Vendedor_Adicional__c  FROM Shipment__c WHERE Id IN: recordIDLst];
    }
}