@isTest()
public class AWSService_Test {
    
    @isTest
    public static void runTest()
    {
        Test.startTest();
        
        AWSService  aws = new AWSService();
        aws.test();
        Test.stopTest(); 
    }
}