public with sharing class P2G_EventMeeting {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getRecordName(Id recordId) {
        Map<String, String> resultMap = new Map<String, String>();
        String recordIdStr = recordId.toString();
        System.debug('recordIdStr---> ' + recordIdStr);
        
        if (recordIdStr.startsWith('001')) {
            Account account = [SELECT Name, RecordType.Name FROM Account WHERE Id = :recordId LIMIT 1];
            resultMap.put('Name', account.Name);
            resultMap.put('RecordTypeName', account.RecordType.Name);
        } else if (recordIdStr.startsWith('006')) {
            System.debug('Opportunity getRecordName');
            Opportunity opportunity = [SELECT Name FROM Opportunity WHERE Id = :recordId LIMIT 1];
            System.debug('Opportunity getRecordName :::: ' +opportunity);
            resultMap.put('Name', opportunity.Name);
            resultMap.put('RecordTypeName', null);
        } else {
            resultMap.put('Name', '');
            resultMap.put('RecordTypeName', '');
        }
        System.debug('resultMap::::> ' + resultMap);
        return resultMap;
    }
    
    @AuraEnabled
    public static void createEvent(String subject, String motivoMinuta, String tipoMeeting, String ownerId, String whatId, String tipoVisita, DateTime startDateTime, DateTime endDateTime, String servicio) {
        System.debug('subject: ' + subject);
        System.debug('motivoMinuta: ' + motivoMinuta);
        System.debug('tipoMeeting: ' + tipoMeeting);
        System.debug('ownerId: ' + ownerId);
        System.debug('whatId: ' + whatId);
        System.debug('tipoVisita: ' + tipoVisita);
        // System.debug('startDateTime: ' + startDateTime);
        System.debug('endDateTime: ' + endDateTime);

        String whatName = '';
        if (whatId != null) {
            if (whatId.startsWith('001')) { // Cuenta
                Account relatedAccount = [SELECT Name FROM Account WHERE Id = :whatId LIMIT 1];
                whatName = relatedAccount.Name;
            } else if (whatId.startsWith('006')) { // Oportunidad
                Opportunity relatedOpportunity = [SELECT Name FROM Opportunity WHERE Id = :whatId LIMIT 1];
                whatName = relatedOpportunity.Name;
            }
        }

        User owner = [SELECT Name FROM User WHERE Id = :ownerId LIMIT 1];
        String concatenatedSubject = subject + ' - ' + whatName + ' - ' + owner.Name;

        Event newEvent = new Event(
            Subject = concatenatedSubject,
            Motivo_Minuta__c = motivoMinuta,
            TipoMeeting__c = tipoMeeting,
            OwnerId = ownerId,
            WhatId = whatId,
            Tipo_Visita__c = tipoVisita,
            Servicio__c = servicio,
            Status_Event__c = 'Not Started',
            StartDateTime = startDateTime,
            EndDateTime = endDateTime
        );
        insert newEvent;
    }

    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesForAccount(Id accountId, String recordTypeName, String reason) {
        System.debug('recordTypeName--> ' + recordTypeName);
        System.debug('reason-->' + reason);
        System.debug('accountId-->  ' + accountId);
        String query = 'SELECT Id, Name, Account.Name, CloseDate, StageName FROM Opportunity WHERE AccountId = :accountId';
        
        if (recordTypeName == 'Prospect') {
            query += ' AND StageName IN (\'Entendimiento\', \'Cotización\', \'Negociacion\', \'Ejecucion\')';
            
        } else if (recordTypeName == 'Customer') {
            query += ' AND StageName IN (\'Entendimiento\', \'Cotización\', \'Negociacion\', \'Ejecucion\')';
        }
        System.debug('query---> ' + query);
        return Database.query(query);
    }
    
    @AuraEnabled
    public static List<Account> searchAccounts(String searchKey) {
        return [SELECT Id, Name FROM Account WHERE Name LIKE :('%' + searchKey + '%') LIMIT 5];
    }
    
}