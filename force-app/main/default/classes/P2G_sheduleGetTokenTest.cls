@isTest
public class P2G_sheduleGetTokenTest {
    @isTest
    static void jobGetTokenRC(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new P2G_MockHttpResponse(1));
        P2G_sheduleGetToken actu = new P2G_sheduleGetToken();
        actu.execute(null);
        Test.stopTest(); 
    } 
}