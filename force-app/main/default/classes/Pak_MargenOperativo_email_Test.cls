@isTest
public class Pak_MargenOperativo_email_Test {
    
    private class createException extends Exception {}
    @isTest
    public static void runTestFN(){
                

        Test.startTest();        	
            try{
                List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,');
                Account accCustomer = list_accounts[0];
                Account accCustomer1 = list_accounts[1];
                accCustomer1.Order_to_Cash__c = false;
                accCustomer1.ActiveSap__c = true;
                accCustomer.ActiveSap__c = true;
                insert accCustomer;
                //insert accCustomer1;
                //Rol_Margen__c rolMargen = TestDataFactory.createRolMargen('Director Regional');
                User admin = TestDataFactory.createUserAdmin();
                Rol_Margen__c margen = TestDataFactory.createRolMargen('Director Regional');// original: Director Comercial 
                Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso'); 
                Carrier_Line_Load_Point__c route = TestDataFactory.createRoute('Tlaxcala - Tlaxco',null);
                Customer_Quote__c folio = TestDataFactory.createFolio(accCustomer.Id,catalogo.Id,route.Id,'Road','NATIONAL','FN',false);
                //Customer_Quote__c folio1 = TestDataFactory.createFolio(accCustomer1.Id,catalogo.Id,route.Id,'Road','NATIONAL','FTL',false);
                Import_Export_Fee_Line__c serviceLine = TestDataFactory.createServiceLine('linea01',route.Id,folio);
                Quote_Item_Line__c cargoLine = TestDataFactory.createCargoLine('cargoLine01',folio);        
                //Import_Export_Fee_Line__c serviceLine1 = TestDataFactory.createServiceLine('linea02',route.Id,folio1);
                //Quote_Item_Line__c cargoLine1 = TestDataFactory.createCargoLine('cargoLine02',folio1); 
                //serviceLine1.Quote_Buy_Price__c = 0;   
                //serviceLine1.Quote_Sell_Price__c = 0;
                //update serviceLine1;        	
                folio.Quotation_Status__c = 'Approved as Succesful';  
                //folio1.Quotation_Status__c = 'Sent awaiting response';           	       	       	        	
                system.debug('acc1 Order_to_Cash__c: ' + accCustomer1.Order_to_Cash__c); 
                system.debug('status actualizado: ' + folio.Quotation_Status__c);            
                //system.debug('status actualizado: ' + folio1.Quotation_Status__c);
                //system.debug('serviceLine1.Quote_Buy_Price__c: ' + serviceLine1.Quote_Buy_Price__c);
                //List<Customer_Quote__c> folios = new List<Customer_Quote__c>{folio,folio1};
        		//update folios;                 
                throw new createException('The Import-Export Order is Approved. Sell Amount is locked.');
            }catch(Exception e){
                system.debug('Error e: ' + e.getMessage());                
                Boolean expectedExceptionThrown =  e.getMessage().contains('The Import-Export Order is Approved. Sell Amount is locked.') ? true : false;                
                if(expectedExceptionThrown){
                    System.AssertEquals(expectedExceptionThrown, true);   
                }else{
                    System.AssertEquals(expectedExceptionThrown, false);                    
                }
            }
        Test.stopTest();        
    }

}