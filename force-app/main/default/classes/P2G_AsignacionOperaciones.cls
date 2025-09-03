public class P2G_AsignacionOperaciones {
    public static void actualizarRegistros() {
        try {
            DateTime decemberStart = DateTime.newInstance(2023, 8, 1); // a partir de agosto del 2023
            DateTime twoHoursAgo = System.now().addHours(-2);
            String operationExecutiveId; //id de nayeli
            if(!Test.isRunningTest()){
            operationExecutiveId = System.Label.Operation_Executive;
        	}
            Set<Id> allowedAccountRecordTypes = new Set<Id>{
                Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                Schema.SobjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId()
            };

            List<Shipment__c> listaShipment = [
                SELECT Id, Name, Operation_Executive__c, Account_for__c
                FROM Shipment__c
                WHERE (LastModifiedDate <= :twoHoursAgo OR Operation_Executive__c = :operationExecutiveId)
                    AND Shipment_Status_Plann__c = 'Pending'
                    AND Account_for__r.RecordTypeId IN :allowedAccountRecordTypes
                    AND CreatedDate >= :decemberStart LIMIT 500
            ];

            for (Shipment__c shipment : listaShipment) {
                shipment.Operation_Executive__c = null;
            }
            NEU_StaticVariableHelper.setBoolean1(true);
            P2G_llamadoWebHelper.setWebServiceUpdate(true);
            Database.SaveResult[] updateResults = Database.update(listaShipment, false);
            NEU_StaticVariableHelper.setBoolean1(false);
            P2G_llamadoWebHelper.setWebServiceUpdate(false);
        } catch (Exception e) {
            System.debug('Error en P2G_AsignacionOperaciones' + e.getMessage());
        }
    }
    
}