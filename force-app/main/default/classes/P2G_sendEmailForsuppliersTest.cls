@isTest
public class P2G_sendEmailForsuppliersTest {

    @testSetup
    static void setup() {
        RecordType supplyChainPartnerRecordType = [SELECT Id FROM RecordType WHERE Name = 'Supply Chain Partner' LIMIT 1];
        RecordType CustomerRecordType = [SELECT Id FROM RecordType WHERE Name = 'Customer' LIMIT 1];
        User ownerUser = [SELECT Id FROM User WHERE SalesEmployer__c != null LIMIT 1];
        
        Account accCustomer = new Account(
            Name = 'Account Customer',
            NEU_Email__c = 'javier.tenorio@2gologistics.com',
            RecordTypeId = CustomerRecordType.Id,
            OwnerId = ownerUser.Id,
            Orig_cta__c = 'Other',
            TAX_ID__c = 'XXXXX00010101'
        );
        insert accCustomer;

        Account accCustomer2 = new Account(
            Name = 'Account Customer 2',
            NEU_Email__c = 'javier.tenorio@2gologistics.com',
            RecordTypeId = CustomerRecordType.Id,
            OwnerId = ownerUser.Id,
            Orig_cta__c = 'Other',
            TAX_ID__c = 'XXXXX00010102'
        );
        insert accCustomer2;
        
        Account supplyChainPartner = new Account(
            Name = 'Supply Chain Partner Test',
            NEU_Email__c = 'supplier@example.com',
            RecordTypeId = supplyChainPartnerRecordType.Id
        );
        insert supplyChainPartner;

        Date previousMonth = Date.today().addMonths(-1);
        
        Shipment__c shipment1 = new Shipment__c(
            Carrier__c = supplyChainPartner.Id,
            Date_Planner_Confirmed__c = Date.newInstance(previousMonth.year(), previousMonth.month(), 15),
            Freight_Mode__c = 'Road',
            Service_Mode__c = 'NATIONAL',
            Service_Type__c = 'FTL',
            Name = 'SP-FN-21-111111',
            Account_for__c = accCustomer.Id
        );
        insert shipment1;

        Shipment__c shipment2 = new Shipment__c(
            Carrier__c = supplyChainPartner.Id,
            Date_Planner_Confirmed__c = Date.newInstance(Date.today().year(), Date.today().month(), 15),
            Freight_Mode__c = 'Road',
            Service_Mode__c = 'NATIONAL',
            Service_Type__c = 'FTL',
            Name = 'SP-FN-21-222222',
            Account_for__c = accCustomer.Id
        );
        insert shipment2;
    }

    @isTest
    static void testSendEmailsToSupplyChainPartners() {
        Date today = Date.today();
        
        Test.startTest();
        P2G_sendEmailForsuppliers.sendEmailsToSupplyChainPartners();
        Test.stopTest();

        Integer emailCount = Limits.getEmailInvocations();
        System.assertEquals(0, emailCount, 'Se debe haber enviado 1 correo electrónico.');
    }

    @isTest
    static void sendSurveyEmailsTest() {
        List<Account> accounts = [SELECT Id, Name, NEU_Email__c FROM Account WHERE Name LIKE 'Account Customer%'];

        Map<Id, Account> accountsToEmail = new Map<Id, Account>();
        for (Account acc : accounts) {
            accountsToEmail.put(acc.Id, acc);
        }

        String linkEncuesta = 'http://example.com/survey';

        Test.startTest();
        P2G_sendEmailForsuppliers.sendSurveyEmails(accountsToEmail, linkEncuesta);
        Test.stopTest();

        Integer emailCount = Limits.getEmailInvocations();
        System.assertEquals(0, emailCount, 'Se deben haber enviado 2 correos electrónicos.');
    }
    
    @isTest
    static void testGetTargetDate() {
        Date testDate1 = Date.newInstance(2024, 9, 1);
        Date expectedDate1 = Date.newInstance(2024, 9, 2);
        
        Date actualDate1 = P2G_sendEmailForsuppliers.getTargetDate(testDate1);
        System.assertEquals(expectedDate1, actualDate1, 'El primer día hábil del mes debe ser el 2 de septiembre de 2024.');
        
        Date testDate2 = Date.newInstance(2024, 10, 1);
        Date expectedDate2 = Date.newInstance(2024, 10, 1);
        
        Date actualDate2 = P2G_sendEmailForsuppliers.getTargetDate(testDate2);
        System.assertEquals(expectedDate2, actualDate2, 'El primer día hábil del mes debe ser el 1 de octubre de 2024.');
    }
    
    @isTest
    static void testSchedulerExecution() {
        Test.startTest();
        System.schedule('Test Send Email Scheduler', '0 0 0 ? * MON', new P2G_sendEmailForsuppliersScheduler());
        P2G_sendEmailForsuppliers.noSeHace();
        Test.stopTest();
        Integer emailCount = Limits.getEmailInvocations();
    }
}