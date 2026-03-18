@isTest
public class P2G_PAK_PagoContadoTest {
        
    @isTest(SeeAllData=true)
    static void testPagoContadoExitoso() {
        
        Shipment__c shipment = [SELECT Id, Pago_Contado_SAP__c, CurrencyIsoCode,  Account_for__r.Credit_Terms__c
                                FROM Shipment__c where Account_for__r.Credit_Terms__c!=null ORDER BY CreatedDate DESC LIMIT 1 ];
                
        PAK_PagoContado.pago pagoObj = new PAK_PagoContado.pago();
        pagoObj.shipmentId = shipment.Id;
        pagoObj.montoPago = '50.00';
        pagoObj.currencyIsoCode = 'USD';
        
        Test.startTest();        
        PAK_PagoContado.status resultado = PAK_PagoContado.pagoContado(pagoObj);
        Test.stopTest();
                        
    }
    
    
    @isTest(SeeAllData=true)
    static void testPagoContadoSinCurrencyIsoCode() {
        
        Shipment__c shipment = [SELECT Id, Pago_Contado_SAP__c, CurrencyIsoCode,  Account_for__r.Credit_Terms__c
                                FROM Shipment__c where Account_for__r.Credit_Terms__c!=null ORDER BY CreatedDate DESC LIMIT 1 ];
        String currencyOriginal = shipment.CurrencyIsoCode;
                
        PAK_PagoContado.pago pagoObj = new PAK_PagoContado.pago();
        pagoObj.shipmentId = shipment.Id;
        pagoObj.montoPago = '200.00';
        pagoObj.currencyIsoCode = '';
        
        Test.startTest();
        PAK_PagoContado.status resultado = PAK_PagoContado.pagoContado(pagoObj);
        Test.stopTest();
                
    }  
    
}