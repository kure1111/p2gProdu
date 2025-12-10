@isTest
public class NEU_Test_UpdateCoordinates {
    @isTest
    public static void testScheduleExecution() {
        Test.startTest();
        // Programar el trabajo
        String jobId = System.schedule('Test NEU_UpdateCoordinates', '0 0 1 * * ?', new NEU_UpdateCoordinates());
        Test.stopTest();
    }
}