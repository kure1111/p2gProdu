@isTest
public class P2G_NEU_Customers_Community_LoginTest {    
    
    @isTest
    static void testSelectLanguageWithAppCredentials() {
        String username = 'testuser@example.com';
        String password = 'testpass123';
        String credentials = username + '¡AppXamarin!' + password;
        String encodedCredentials = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(credentials)), 'UTF-8');
                
        PageReference pageRef = Page.NEU_Customers_Community_Login;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('un', encodedCredentials);
        pageRef.getParameters().put('startURL', '/s/home');
                
        NEU_Customers_Community_Login controller = new NEU_Customers_Community_Login();
        
        Test.startTest();
        PageReference result = controller.select_language();
        Test.stopTest();
                        
    }
    
    @isTest
    static void testSelectLanguageWithInvalidAppCredentials() {        
        String invalidCredentials = 'justonefield';
        String encodedCredentials = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf(invalidCredentials)), 'UTF-8');
             
        PageReference pageRef = Page.NEU_Customers_Community_Login;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('un', encodedCredentials);
        pageRef.getParameters().put('error', 'true');
        
        NEU_Customers_Community_Login controller = new NEU_Customers_Community_Login();
                
        Test.startTest();
        PageReference result = controller.select_language();
        Test.stopTest();
    }
    
    @isTest
    static void testSelectLanguageWithLangParameter() {        
        PageReference pageRef = Page.NEU_Customers_Community_Login;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('lang', 'en');
                
        NEU_Customers_Community_Login controller = new NEU_Customers_Community_Login();        
        Test.startTest();
        PageReference result = controller.select_language();
        Test.stopTest();        
    }
    
    @isTest
    static void testLoginSuccess() {        
        NEU_Customers_Community_Login controller = new NEU_Customers_Community_Login();
        controller.username = 'testuser@example.com';
        controller.password = 'testpass123';
                
        Test.startTest();
        PageReference result = controller.login();
        Test.stopTest();
        
    }
    
    @isTest
    static void testLoginMissingUsername() {        
        NEU_Customers_Community_Login controller = new NEU_Customers_Community_Login();
        controller.username = '';
        controller.password = 'testpass123';
                
        Test.startTest();
        PageReference result = controller.login();
        Test.stopTest();        
    }
    
    @isTest
    static void testLoginMissingPassword() {        
        NEU_Customers_Community_Login controller = new NEU_Customers_Community_Login();
        controller.username = 'testuser@example.com';
        controller.password = '';
                
        Test.startTest();
        PageReference result = controller.login();
        Test.stopTest();
    
    }
    
    @isTest
    static void testLoginInvalidCredentials() {        
        NEU_Customers_Community_Login controller = new NEU_Customers_Community_Login();
        controller.username = 'invalid@example.com';
        controller.password = 'wrongpass';
        
        
        Test.startTest();
        PageReference result = controller.login();
        Test.stopTest();
        
    }
}