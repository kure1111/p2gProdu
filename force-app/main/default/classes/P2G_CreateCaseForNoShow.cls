public with sharing class P2G_CreateCaseForNoShow {

    public static Boolean isAlreadyProcessed = false;

    public static void casesNoShow(List<Shipment__c> newShipments, Map<Id, Shipment__c> oldShipments) {
        if (isAlreadyProcessed) {
            System.debug('Lógica ya procesada');
            return;
        }
    
        List<Case> casesToCreate = new List<Case>();
        Map<String, Id> recordTypeIds = getRecordTypeIds();
        Set<Id> shipmentIds = new Set<Id>();
    
        for (Shipment__c shipment : newShipments) {
            shipmentIds.add(shipment.Id);
        }
    
        Map<Id, Case> existingCases = new Map<Id, Case>(
            [SELECT Id, Shipment__c, Subject 
             FROM Case 
             WHERE Shipment__c IN :shipmentIds 
             AND (Subject LIKE 'Operado con No Show%' OR Subject LIKE '%No Show%')]
        );
    
        for (Shipment__c shipment : newShipments) {
            Shipment__c oldShipment = oldShipments.get(shipment.Id);
    
            // Validar que oldShipment no sea null
            if (oldShipment == null) {
                System.debug('No se encontró el Shipment antiguo para el ID: ' + shipment.Id);
                continue;
            }
    
            // Validar que los carriers no sean nulos
            if (shipment.Carrier__c != null && oldShipment.Carrier__c != null &&
                shipment.Carrier__c != oldShipment.Carrier__c && 
                !existingCases.containsKey(shipment.Id)) {
    
                System.debug('Creando caso por cambio de Carrier...');
                casesToCreate.add(new Case(
                    Subject = 'Operado con No Show - ' + shipment.Name,
                    Reason = 'No show',
                    Origin = 'No Show',
                    Status = 'Nuevo',
                    Motivo__c = 'Cambio Carrier Operado No Show',
                    RecordTypeId = recordTypeIds.get('No Show'),
                    Carrier_Actual__c = oldShipment.Carrier__c,
                    Carrier_Nuevo__c = shipment.Carrier__c,
                    Shipment__c = shipment.Id
                ));
            }
    
            if (shipment.declined_for__c == 'Falla operativa' &&
                oldShipment.declined_for__c != 'Falla operativa' &&
                shipment.Shipment_Status_Plann__c == 'Cancel' &&
                String.isNotBlank(shipment.Reason_for_declined__c) &&
                !existingCases.containsKey(shipment.Id)) {
    
                System.debug('Creando caso por Falla Operativa...');
                casesToCreate.add(new Case(
                    Subject = 'Declinado por Falla Operativa No Show - ' + shipment.Name,
                    Reason = 'No show',
                    Origin = 'No Show',
                    Status = 'Nuevo',
                    Motivo__c = 'Declinación Falla Operativa No Show',
                    RecordTypeId = recordTypeIds.get('No Show'),
                    Carrier_Actual__c = shipment.Carrier__c,
                    Shipment__c = shipment.Id
                ));
            }
        }
    
        if (!casesToCreate.isEmpty()) {
            try {
                insert casesToCreate;
                isAlreadyProcessed = true;
            } catch (DmlException e) {
                System.debug('Error al crear los casos: ' + e.getMessage());
            }
        }
    }
    

    private static Map<String, Id> getRecordTypeIds() {
        Map<String, Id> tiposRegistros = new Map<String, Id>();
        List<RecordType> recordsCase = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Case'];
        for (RecordType rt : recordsCase) {
            tiposRegistros.put(rt.Name, rt.Id);
        }
        return tiposRegistros;
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> getRelatedCases(Id recordId) {
        return [
            SELECT Id, Description 
            FROM Case 
            WHERE Shipment__c = :recordId
        ];
    }
}