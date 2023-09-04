@IsTest
public class P2G_globalVariableTest {
    @testSetup
    static void Setup(){
        P2G_token__c token = new P2G_token__c();
        token.token__c = 'af6fd656-83d8-6f07-2ab4-c00f244a8139';
        token.Name = 'tokenRC';
        insert token;
    }
    @IsTest
    static void testGetToken() {
        String expectedToken = 'af6fd656-83d8-6f07-2ab4-c00f244a8139';
        String actualToken = P2G_globalVariable.getToken();
        System.assertEquals(expectedToken, actualToken, 'The token should be equal to the expected value');
    }

    @IsTest
    static void testSetToken() {
        String newToken = 'newTokenValue';
        P2G_globalVariable.setToken(newToken);
        String expectedToken = newToken;
        String actualToken = P2G_globalVariable.getToken();
        System.assertEquals(expectedToken, actualToken, 'The token should be equal to the expected value after calling setToken()');
    }
}