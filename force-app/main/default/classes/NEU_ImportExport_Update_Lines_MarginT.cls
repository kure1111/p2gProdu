@isTest
public class NEU_ImportExport_Update_Lines_MarginT {

    
    @TestSetUp
    public static void makeData(){
        
        //Account accCustomer = TestDataFactory.createAccounts('accCustomer','Customer');        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account accCustomer = list_accounts[0];
        accCustomer.ActiveSap__c = true;
        accCustomer.Credit_Terms__c = '1 Día';
        insert accCustomer;
        User userT = TestDataFactory.createUserAdmin();        
        Account accCarrier = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen('Director Comercial');              
        Contact con = TestDataFactory.createContact(accCustomer.Id, 'contactTest');
		Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso'); 
        Carrier_Line_Load_Point__c route = TestDataFactory.createRoute('Tlaxcala - Tlaxco',null);                
        
        Test.startTest();     
        try{         
            Customer_Quote__c folio = TestDataFactory.createFolio(accCustomer.Id, catalogo.Id, route.Id, 'Road', 'NATIONAL', 'FTL', false);
           	Import_Export_Fee_Line__c il = TestDataFactory.createServiceLine('001Test', route.Id, folio);
            Quote_Item_Line__c cl = TestDataFactory.createCargoLine('oo1Test', folio);
                        
        }catch(Exception e){
            system.debug('capturando el error: ' + e.getMessage());
        } 
        Test.stopTest();
    }
    
    
    @isTest
    public static void runTest(){
                
        
        Test.startTest();
        	List<Customer_Quote__c> sp1 = [Select Id, Name,Account_for__c from Customer_Quote__c where Account_for__r.Name = 'accCustomer'];        
            if(sp1.size() != 0){
                sp1[0].Margin_at_Destination_by_Default__c = 20;        	    		
            	update sp1[0];
            }	                	    
        Test.stopTest();        
    }
}