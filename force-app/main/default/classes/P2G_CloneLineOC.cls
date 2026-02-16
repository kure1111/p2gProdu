public with sharing class P2G_CloneLineOC {
    
    public static String cloneShipmentLine(String shipmentLineId) {
        try {
            // Validar entrada
            if (String.isBlank(shipmentLineId)) {
                return 'ERROR: El ID del registro no puede estar vacío.';
            }
            
            // Obtener el registro original con todos los campos
            Shipment_Fee_Line__c originalRecord = [
                SELECT Id, Name, Shipment__c, Import_Export_Quote__c, Service_Rate_Name__c, CurrencyIsoCode,
                       Record_Locked__c, Email_Sales_ExecutiveSP__c, Units__c, Shipment_Sell_Price__c, Sell_Amount__c,
                       Shipment_Buy_Price__c, Campo_Control__c
                FROM Shipment_Fee_Line__c 
                WHERE Id = :shipmentLineId
                LIMIT 1
            ];
            
            if (originalRecord == null) {
                return 'ERROR: No se encontró el registro con ID: ' + shipmentLineId;
            }
            
            // Clonar el registro
            Shipment_Fee_Line__c clonedRecord = originalRecord.clone(false, true, false, false);
            
            // Modificar solo el nombre para indicar que es un clon
            clonedRecord.Name = originalRecord.Name + ' - Buy Only';
            clonedRecord.Shipment_Sell_Price__c = 0;
            clonedRecord.Campo_Control__c = false;
            // Insertar el nuevo registro
            insert clonedRecord;
            
            // Llamar al método futuro para actualizar el original
            actualizarOriginalAsync(originalRecord.Id);
            
            // Retornar el ID del registro clonado
            return clonedRecord.Id;
            
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            return 'ERROR: ' + e.getMessage();
        }
    }
    
    @future
    public static void actualizarOriginalAsync(Id shipmentLineId) {
        try {
            Shipment_Fee_Line__c originalRecord = new Shipment_Fee_Line__c(
                Id = shipmentLineId,
                Shipment_Buy_Price__c = 0,
                Campo_Control__c = true
            );
            NEU_StaticVariableHelper.setBoolean1(true);
            update originalRecord;
        } catch(Exception e) {
            System.debug('Error en actualización asíncrona: ' + e.getMessage());
        }
    }
}