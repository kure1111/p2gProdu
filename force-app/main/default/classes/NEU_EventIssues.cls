/**
 * Created by jamarin on 18/01/2019.
 */

public with sharing class NEU_EventIssues {

    public Event record;
    ApexPages.StandardController con;
    public String SubjectEvent{get;set;}
    public List <Event_Issues__c> eventIssues {get;set;}
    public NEU_EventIssues(ApexPages.StandardController con)
    {
        SubjectEvent = '';
        record = [SELECT Id, Subject from Event where id = :con.getRecord().Id];
        SubjectEvent = record.Subject;
        eventIssues = [SELECT Id, Name, Date__c, Id_Calendar_Event__c, Situation__c, User__r.name, User__c FROM Event_Issues__c WHERE Id_Calendar_Event__c =: record.Id ORDER BY Date__c ASC];
    }

}