public class P2G_globalVariable {
    public static String getToken() {
        P2G_token__c token = [SELECT Name,token__c FROM P2G_token__c WHERE Name='tokenRC' limit 1];
        return token.token__c;
    }
    public static void setToken(String newToken) {
        P2G_token__c token = [SELECT Name,token__c FROM P2G_token__c WHERE Name='tokenRC' limit 1];
        token.token__c = newToken;
        update token;
    }
}