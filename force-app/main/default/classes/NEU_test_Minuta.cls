/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class NEU_test_Minuta {


    static testMethod void NEU_GenerateMinuta ()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        Account a= new Account ();
        a.name='Test Account';
        insert a;

        Event e = new Event();
        e.WhatId=a.id;
        e.StartDateTime=system.today();
        e.EndDateTime=system.today()+5;

        insert  e;

        NEU_GenerateMinuta gm = new NEU_GenerateMinuta(new ApexPages.StandardController(e));

    }

    static testMethod void NEU_SendMinutaEmail ()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        Account a= new Account ();
        a.name='Test Account';
        insert a;

        Event e = new Event();
        e.WhatId=a.id;
        e.StartDateTime=system.today();
        e.EndDateTime=system.today()+5;
        insert  e;

        Event_Issues__c ei = new Event_Issues__c();
        ei.Date__c = system.today();
        ei.Id_Calendar_Event__c = string.valueOf(e.Id);
        ei.Situation__c = 'Test';
        ei.Topic__c = 'Test';

        insert ei;

        NEU_SendMinutaEmail sm = new NEU_SendMinutaEmail(new ApexPages.StandardController(e));
        sm.defaultTo = 'Test';
        sm.html_body = 'Test';
        sm.defaultTo = 'joseantonio@neurored.com';
        sm.defaultBcc = 'joseantonio@neurored.com';
        sm.defaultCc = 'joseantonio@neurored.com';
        sm.generatePdf(e.Id);
        sm.send_email();
        sm.return_event();
    }

    static testMethod void NEU_EventIssues ()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        Account a= new Account ();
        a.name='Test Account';
        insert a;

        Event e = new Event();
        e.WhatId=a.id;
        e.StartDateTime=system.today();
        e.EndDateTime=system.today()+5;
        insert  e;

        Event_Issues__c ei = new Event_Issues__c();
        ei.Date__c = system.today();
        ei.Id_Calendar_Event__c = string.valueOf(e.Id);
        ei.Situation__c = 'Test';
        ei.Topic__c = 'Test';

        insert ei;

        NEU_EventIssues sm = new NEU_EventIssues(new ApexPages.StandardController(e));
    }

}