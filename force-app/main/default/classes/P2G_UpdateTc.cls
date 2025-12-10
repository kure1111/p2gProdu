public class P2G_UpdateTc {
    //@future
    public static void procesarTC(Id shipmentId, Decimal tipoCambio) {
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Shipment_Fee_Line__c> feeLinesToUpdate = new List<Shipment_Fee_Line__c>();

        for (Shipment_Fee_Line__c feeLine : [
            SELECT Id, Conversion_Rate_to_Buy_Currency_Header__c,CurrencyIsoCode
            FROM Shipment_Fee_Line__c
            WHERE Shipment__c = :shipmentId
            AND CurrencyIsoCode = 'USD'
        ]) {
            feeLine.Conversion_Rate_to_Buy_Currency_Header__c = 1/tipoCambio;
            feeLinesToUpdate.add(feeLine);
        }

        if (!feeLinesToUpdate.isEmpty()) {
            try{
                update feeLinesToUpdate;
            }catch(Exception e){
                System.debug('Error al actualzar lneas');
                
            }
            
        } else {
            System.debug('Error No se encontraron registros a actualizar.');
        }
    }
}