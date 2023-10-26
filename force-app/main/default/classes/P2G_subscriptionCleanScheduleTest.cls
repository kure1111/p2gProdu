@isTest
public class P2G_subscriptionCleanScheduleTest {
    @isTest
    static void testExecute() {
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Account account_test = new Account();
        account_test.RecordTypeId = prospectRecordTypeId;
        account_test.Estatus_Recuperado__c='Cliente Visitado';
        account_test.Name='prueba';
        account_test.Name = 'Ejemplo de Cuenta';
        account_test.Credit_Terms__c = '15 days';
        insert account_test;
		Id userId = UserInfo.getUserId();

        //EntitySubscription subscription = new EntitySubscription(ParentId = account_test.Id, SubscriberId = userId);
        //insert subscription;
        P2G_subscriptionCleanSchedule schedule = new P2G_subscriptionCleanSchedule();

        Test.startTest();
        schedule.execute(null);
        Test.stopTest();
    }

}