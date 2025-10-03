@isTest
public class P2G_UpdateTcTest {

    // Test actualiza correctamente las líneas en USD
    @isTest(SeeAllData=true)
    static void testProcesarTC_WithUSDLines() {
        // 1. Buscar un Shipment__c existente que tenga al menos una Shipment_Fee_Line__c en USD
        // Esto es CRUCIAL para que la prueba funcione.
        List<Shipment_Fee_Line__c> usdLines = [
            SELECT Id, Shipment__c 
            FROM Shipment_Fee_Line__c 
            WHERE CurrencyIsoCode = 'USD' 
            AND Shipment__c != null 
            LIMIT 1
        ];

        Id targetShipmentId = usdLines[0].Shipment__c;
        Decimal testTipoCambio = 20.0; // Usamos un tipo de cambio de prueba claro (1 USD = 20 MXN)

        Test.startTest();
        // 2. Llamar al método estático que se está probando
        P2G_UpdateTc.procesarTC(targetShipmentId, testTipoCambio);
        Test.stopTest();

        // 3. VERIFICACIÓN: Consultar las líneas actualizadas y comprobar que el campo se estableció correctamente.
        // El valor esperado es 1 / tipoCambio = 1 / 20 = 0.05
        Decimal expectedConversionRate = 1 / testTipoCambio;
        List<Shipment_Fee_Line__c> updatedLines = [
            SELECT Id, Conversion_Rate_to_Buy_Currency_Header__c 
            FROM Shipment_Fee_Line__c 
            WHERE Shipment__c = :targetShipmentId 
            AND CurrencyIsoCode = 'USD'
        ];

        System.assert(!updatedLines.isEmpty(), 'Debería haber al menos una línea USD para actualizar.');
        for(Shipment_Fee_Line__c line : updatedLines) {
            System.assertEquals(expectedConversionRate, line.Conversion_Rate_to_Buy_Currency_Header__c, 
                                'El tipo de conversión no se calculó o estableció correctamente.');
        }
    }
}