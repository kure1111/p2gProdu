@isTest
public with sharing class NEU_OM_UpdateRecordtypeImportExportTest {
    

    private class createException extends Exception {}
    @isTest
    public static void runTest1(){
        
        
        try{
        
            Account accCustomer = TestDataFactory.createAccounts('Account Customer', 'Customer');		
            accCustomer.ActiveSap__c = true;
            update accCustomer;
            Rol_Margen__c rolMargen = TestDataFactory.createRolMargen('Director Comercial');
            User admin = TestDataFactory.createUserAdmin();
            Rol_Margen__c margen = TestDataFactory.createRolMargen('Director Comercial');
            Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso'); 
            Carrier_Line_Load_Point__c route = TestDataFactory.createRoute('Tlaxcala - Tlaxco',null);
            Customer_Quote__c folio = TestDataFactory.createFolio(accCustomer.Id,catalogo.Id,route.Id,'Road','NATIONAL','FTL',false);
            Customer_Quote__c folio1 = TestDataFactory.createFolio(accCustomer.Id,catalogo.Id,route.Id,'Road','NATIONAL','LTL',false);
            Import_Export_Fee_Line__c serviceLine = TestDataFactory.createServiceLine('linea01',route.Id,folio);
            Quote_Item_Line__c cargoLine = TestDataFactory.createCargoLine('cargoLine01',folio);      
            Import_Export_Fee_Line__c serviceLine1 = TestDataFactory.createServiceLine('linea011',route.Id,folio1);
            Quote_Item_Line__c cargoLine1 = TestDataFactory.createCargoLine('cargoLine011',folio1);
    
            system.debug('Folio: ' + folio);
            system.debug('Folio1: ' + folio1);
            Test.startTest();      
            	RecursiveCheck.triggerMonitor.clear();
                folio1.Quotation_Status__c = 'Shipped';  
                update folio1;                                    	
                system.debug('folio1.Quotation_Status__c: ' + folio1.Quotation_Status__c);
            Test.stopTest();            
            throw new createException('The Customer is inactive.');
            
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('The Customer is inactive.') ? true : false;
            if(expectedExceptionThrown){
             	System.AssertEquals(expectedExceptionThrown, true);   
            }else{
                System.AssertEquals(expectedExceptionThrown, false);
            } 
        }
                
    }
}