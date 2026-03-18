@isTest
public class P2G_PAK_DISWSTest {

     @isTest(SeeAllData=true)
    static void testDisbursementSAP_Success() {        
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Shipment__c testShipment = [SELECT Id FROM Shipment__c LIMIT 1];
                
        PAK_DISWS.Disbursement disbursement = new PAK_DISWS.Disbursement();
        disbursement.Moneda = 'MXN';
        disbursement.CfdiNumber = '12345';
        disbursement.CardCode = 'TEST123';
        disbursement.FactNumber = 'FACT001';
        disbursement.Shipment = 'SHIP123';
        disbursement.TotalFacturado = '1000.00';
        disbursement.FechaFactura = '2023-01-01';
        disbursement.UI = 'UI123';
        disbursement.OrdenCompra = 'OC001';
                
        PAK_DISWS.Detalle detalle = new PAK_DISWS.Detalle();
        detalle.Units = '2';
        detalle.UnitPrice = '500.00';
        detalle.VAT = '16';
        detalle.SujetoARet = 'No';
        detalle.Total = '1000.00';
        detalle.IdInvoiceLine = '1';
        detalle.ItemCode = 'SRV001';
        detalle.Concepto = 'Test Concept';
        
        PAK_DISWS.DetalleDisbursement detalleDisbursement = new PAK_DISWS.DetalleDisbursement();
        detalleDisbursement.DetalleDisbursement = new List<PAK_DISWS.Detalle>{detalle};
        disbursement.DetalleDisbursement = detalleDisbursement;
        
        Test.startTest();
        List<PAK_DISWS.status> result = PAK_DISWS.DisbursementSAP(new List<PAK_DISWS.Disbursement>{disbursement});
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testDisbursementSAP_Error_AccountNotFound() {        
        PAK_DISWS.Disbursement disbursement = new PAK_DISWS.Disbursement();
        disbursement.Moneda = 'MXN';
        disbursement.CardCode = 'NONEXISTENT';
        
        Test.startTest();
        List<PAK_DISWS.status> result = PAK_DISWS.DisbursementSAP(new List<PAK_DISWS.Disbursement>{disbursement});
        Test.stopTest();        
    }
            
    @isTest(SeeAllData=true)
    static void testDisbursementSAP_TestMode() {
        PAK_DISWS.Disbursement disbursement = new PAK_DISWS.Disbursement();
        disbursement.Moneda = 'MXN';
        disbursement.CardCode = 'TEST123';
        disbursement.Shipment = 'SHIP123';
        
        Test.startTest();
        List<PAK_DISWS.status> result = PAK_DISWS.DisbursementSAP(new List<PAK_DISWS.Disbursement>{disbursement});
        Test.stopTest();

    }
    
     @isTest
    static void testFolioEntregaWithoutIdLines() {
        String message = 'Entrega Creada No. : 12345678';
        String result = PAK_WSMESSAGES.folioEntrega(message);
        System.debug('Resultado sin IdLines: ' + result);
    }

    @isTest
    static void testFolioEntregaWithIdLines() {
        String message = 'Entrega Creada No. : 87654321 IdLines: 123';
        String result = PAK_WSMESSAGES.folioEntrega(message);
        System.debug('Resultado con IdLines: ' + result);
    }
}