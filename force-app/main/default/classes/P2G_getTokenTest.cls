@IsTest(SeeAllData=true)
public class P2G_getTokenTest {
    @isTest 
    static void testCallout(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new P2G_MockHttpResponse(1));
        String tokenSf = P2G_getToken.getTokenSF();
        String tokenRc = P2G_getToken.getTokenRecursoC();
        Test.stopTest();
    }
    
}