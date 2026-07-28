@isTest
public class P2G_NCREDITO_SERVICETest {    
    
    @isTest(SeeAllData=true)
    static void testCreateInvoiceSuccess() {
        System.debug('Inicia primer test');
        // Obtener Invoice de prueba
        Invoice__c testInv = [SELECT Id FROM Invoice__c LIMIT 1];
        
        // Preparar datos de entrada usando la clase global original
        PAK_Update_ACC.NOTA_CREDITO nota = new PAK_Update_ACC.NOTA_CREDITO();
        nota.IdInovice = testInv.Id;
        nota.ImporteTotal = '1000';
        nota.Motivo = 'Devolución';
        nota.NumeroFactura = 'FAC-001';
        nota.NumeroCredito = 'NC-001';
        
        List<PAK_Update_ACC.NOTA_CREDITO> inputList = new List<PAK_Update_ACC.NOTA_CREDITO>{nota};
            
            Test.startTest();
        List<PAK_NCREDITO_SERVICE.status> result = PAK_NCREDITO_SERVICE.CREATE(inputList);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testCreateDisbursementSuccess() {        
        Shipment_Disbursement__c testDisb = [SELECT Id FROM Shipment_Disbursement__c LIMIT 1];
        
        PAK_Update_ACC.NOTA_CREDITO nota = new PAK_Update_ACC.NOTA_CREDITO();
        nota.IdInovice = testDisb.Id;
        nota.ImporteTotal = '500';
        nota.Motivo = 'Ajuste';
        nota.NumeroFactura = 'FAC-002';
        nota.NumeroCredito = 'NC-002';
        
        List<PAK_Update_ACC.NOTA_CREDITO> inputList = new List<PAK_Update_ACC.NOTA_CREDITO>{nota};
            
            Test.startTest();
        List<PAK_NCREDITO_SERVICE.status> result = PAK_NCREDITO_SERVICE.CREATE(inputList);
        Test.stopTest();
    }
    @isTest(SeeAllData=true)
    static void testCreateMultipleNotesSuccess() {
        // Obtener registros de prueba
        Invoice__c testInv = [SELECT Id FROM Invoice__c LIMIT 1];
        Shipment_Disbursement__c testDisb = [SELECT Id FROM Shipment_Disbursement__c LIMIT 1];
        
        // Preparar múltiples notas de crédito usando las clases globales
        PAK_Update_ACC.NOTA_CREDITO nota1 = new PAK_Update_ACC.NOTA_CREDITO();
        nota1.IdInovice = testInv.Id;
        nota1.ImporteTotal = '1000';
        nota1.Motivo = 'Devolución';
        nota1.NumeroFactura = 'FAC-001';
        nota1.NumeroCredito = 'NC-001';
        
        PAK_Update_ACC.NOTA_CREDITO nota2 = new PAK_Update_ACC.NOTA_CREDITO();
        nota2.IdInovice = testDisb.Id;
        nota2.ImporteTotal = '500';
        nota2.Motivo = 'Ajuste';
        nota2.NumeroFactura = 'FAC-002';
        nota2.NumeroCredito = 'NC-002';
        
        List<PAK_Update_ACC.NOTA_CREDITO> inputList = new List<PAK_Update_ACC.NOTA_CREDITO>{nota1, nota2};
            
            Test.startTest();
        List<PAK_NCREDITO_SERVICE.status> result = PAK_NCREDITO_SERVICE.CREATE(inputList);
        Test.stopTest();
    }
        
}