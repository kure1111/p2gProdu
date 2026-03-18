@isTest(seeAllData=true)
private class PAK_CANCEL_INV_SERVICETest {
    
    @isTest
    static void testCANCEL_Pedido() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
        
        PAK_Update_ACC.CANCEL_INV cancelInv = new PAK_Update_ACC.CANCEL_INV();
        cancelInv.Tipo = 'PEDIDO';
        cancelInv.IdInovice = shipment.Id;
        
        List<PAK_Update_ACC.CANCEL_INV> cancels = new List<PAK_Update_ACC.CANCEL_INV>{cancelInv};
        
        Test.startTest();
        List<PAK_CANCEL_INV_SERVICE.status> results = PAK_CANCEL_INV_SERVICE.CANCEL(cancels);
        Test.stopTest();
    }
    
    @isTest
    static void testCANCEL_Proveedor() {
        Shipment_Disbursement__c disbursement = [SELECT Id FROM Shipment_Disbursement__c LIMIT 1];
        
        PAK_Update_ACC.CANCEL_INV cancelInv = new PAK_Update_ACC.CANCEL_INV();
        cancelInv.Tipo = 'PROVEEDOR';
        cancelInv.IdInovice = disbursement.Id;
        
        List<PAK_Update_ACC.CANCEL_INV> cancels = new List<PAK_Update_ACC.CANCEL_INV>{cancelInv};
        
        Test.startTest();
        List<PAK_CANCEL_INV_SERVICE.status> results = PAK_CANCEL_INV_SERVICE.CANCEL(cancels);
        Test.stopTest();
    }
    
    @isTest
    static void testCANCEL_OrdenVenta() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
        
        PAK_Update_ACC.CANCEL_INV cancelInv = new PAK_Update_ACC.CANCEL_INV();
        cancelInv.Tipo = 'ORDENVENTA';
        cancelInv.IdInovice = shipment.Id;
        
        List<PAK_Update_ACC.CANCEL_INV> cancels = new List<PAK_Update_ACC.CANCEL_INV>{cancelInv};
        
        Test.startTest();
        List<PAK_CANCEL_INV_SERVICE.status> results = PAK_CANCEL_INV_SERVICE.CANCEL(cancels);
        Test.stopTest();
    }
    
    @isTest
    static void testCANCEL_Error() {
        PAK_Update_ACC.CANCEL_INV cancelInv = new PAK_Update_ACC.CANCEL_INV();
        cancelInv.Tipo = 'PEDIDO';
        cancelInv.IdInovice = '001000000000000';
        
        List<PAK_Update_ACC.CANCEL_INV> cancels = new List<PAK_Update_ACC.CANCEL_INV>{cancelInv};
        
        Test.startTest();
        List<PAK_CANCEL_INV_SERVICE.status> results = PAK_CANCEL_INV_SERVICE.CANCEL(cancels);
        Test.stopTest();
    }
}