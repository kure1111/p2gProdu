@IsTest
public class P2G_SendBatchAddressTest {
    @IsTest
    public static void test(){
        Test.startTest();
        P2G_SendBatchAddress batch = new P2G_SendBatchAddress();
		Database.executeBatch(batch, 50);
        Test.stopTest();
    }
    
    
}