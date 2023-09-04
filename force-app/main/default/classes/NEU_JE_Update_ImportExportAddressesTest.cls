@isTest
public class NEU_JE_Update_ImportExportAddressesTest {

    
    @isTest
    public static void runTest(){
                               
        Test.startTest();
            //user        
            User userT = TestDataFactory.createUserAdmin();
            Rol_Margen__c rolMargen = TestDataFactory.createRolMargen('Director Comercial');
            //Account     
            Account accCustomer = TestDataFactory.createAccounts('Cuenta customer', 'Customer');
			Account accCustomer1 = TestDataFactory.createAccounts('Cuenta customer1', 'Customer');        
            Account accCarrier = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');                        
            Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125', 'Unidad Peso'); 
            Carrier_Line_Load_Point__c route = TestDataFactory.createRoute('Tlaxcala - Tlaxco',null);
        	Catalogo_SAT__c cp = TestDataFactory.createCatalogoSat('980828','980828','Codigo Postal');	
        	Account_Address__c ad = TestDataFactory.createAddressAccount('accAddress', accCustomer.Id, cp.Id);        	        
        	//Customer_Quote__c folio = TestDataFactory.createFolio(accCustomer.Id, catalogo.Id, route.Id, 'Road', 'NATIONAL', 'FTL', false);
        	//Customer_Quote__c folio1 = TestDataFactory.createFolio(accCustomer.Id,catalogo.Id,route.Id,'Road','NATIONAL','FTL',false);
        
        	Customer_Quote__c folio = new Customer_Quote__c();
            folio.Account_for__c = accCustomer.Id;
            folio.Freight_Mode__c = 'Air';
            folio.Service_Mode__c = 'Import'; 
            folio.Service_Type__c = 'LCL Cargo';
            folio.Move_Type__c = 'Door to Door';
            folio.Origin_Address__c = 'Address Test'; 
            folio.Destination_Address__c = 'Address Test';            
            folio.Impak_Request__c = true;
            folio.Date_Pricing_responded__c = System.today();
            folio.Clave_de_Unidad_de_Peso__c = catalogo.Id;    
        	folio.Pricing_Executive__c = userT.Id;
        	folio.ByPass__c = true;
        	folio.Supplier_Account__c = accCustomer.Id;
        	folio.Consignee__c = accCustomer1.Id;
            insert folio;          	
        	folio.Account_Origin_Address__c = ad.Id;
        	update folio;
        
        	Customer_Quote__c folio1 = new Customer_Quote__c();
            folio1.Account_for__c = accCustomer1.Id;
            folio1.Freight_Mode__c = 'Air';
            folio1.Service_Mode__c = 'Import'; 
            folio1.Service_Type__c = 'LCL Cargo';
            folio1.Move_Type__c = 'Door to Door';
            folio1.Origin_Address__c = 'Address Test';             
            folio1.ByPass__c = true;
            folio1.Impak_Request__c = true;
            folio1.Date_Pricing_responded__c = System.today();
            folio1.Clave_de_Unidad_de_Peso__c = catalogo.Id;    
        	folio1.Pricing_Executive__c = userT.Id;              
        	folio1.Supplier_Account__c = accCustomer1.Id;
        	folio1.Consignee__c = accCustomer.Id;
        	folio1.Destination_Address__c = 'Address Test';
            insert folio1;  
                	         
        	//folio1.Account_Origin_Address__c = ad.Id;        	
        	folio1.Supplier_Account__c = accCustomer1.Id;
        	folio1.Destination_Address__c = 'Address Test1';
        	update folio1;
        Test.stopTest();
        
    }
}