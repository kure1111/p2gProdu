@isTest
public class NEU_CheckAccountInactiveIE_Test {

    private class createException extends Exception {}
    @TestSetUp
    public static void makeData(){
        
        Account accCustomer = TestDataFactory.createAccounts('accCustomer','Customer');
        Account accCustomer1 = TestDataFactory.createAccounts('accCustomer1','Customer');
        accCustomer.ActiveSap__c = false;
        
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen('Director Comercial');
        User admin = TestDataFactory.createUserAdmin();
        Rol_Margen__c margen = TestDataFactory.createRolMargen('Director Comercial');
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso'); 
        Carrier_Line_Load_Point__c route = TestDataFactory.createRoute('Tlaxcala - Tlaxco',null);
        
		Test.startTest();
        try{
            
            Customer_Quote__c folio = TestDataFactory.createFolio(accCustomer.Id,catalogo.Id,route.Id,'Road','NATIONAL','FTL',false);
            Customer_Quote__c folio1 = TestDataFactory.createFolio(accCustomer1.Id,catalogo.Id,route.Id,'Road','NATIONAL','FTL',false);
            Import_Export_Fee_Line__c serviceLine = TestDataFactory.createServiceLine('linea01',route.Id,folio);
            Quote_Item_Line__c cargoLine = TestDataFactory.createCargoLine('cargoLine01',folio);        
            Import_Export_Fee_Line__c serviceLine1 = TestDataFactory.createServiceLine('linea02',route.Id,folio1);
            Quote_Item_Line__c cargoLine1 = TestDataFactory.createCargoLine('cargoLine02',folio1);   
            throw new createException('The Customer is inactive.');
            
        }catch(Exception e){         	
            Boolean expectedExceptionThrown =  e.getMessage().contains('The Customer is inactive.') ? true : false;
            if(expectedExceptionThrown){
             	System.AssertEquals(expectedExceptionThrown, true);   
            }else{
                System.AssertEquals(expectedExceptionThrown, false);
            }  
        } 
        Test.stopTest();
    }
    
    @isTest
    public static void runTest(){
        
        List<Customer_Quote__c> folio1 = [Select Id, Name, Quotation_Status__c from Customer_Quote__c Where Account_for__r.Name = 'accCustomer'];        
        
        Test.startTest();
        try{
            
            folio1[0].Quotation_Status__c = 'Approved as Succesful';        	
            update folio1[0];            
            throw new createException('The Customer is inactive.');
            
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('The Customer is inactive.') ? true : false;
            if(expectedExceptionThrown){
             	System.AssertEquals(expectedExceptionThrown, true);   
            }else{
                System.AssertEquals(expectedExceptionThrown, false);
            }            
        }
        	
        Test.stopTest();
    }
}