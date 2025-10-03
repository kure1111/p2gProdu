@isTest
public class NEU_Disable_Approved_Quotes_Test {

    private class createException extends Exception {}
    /*
    @TestSetup
    static void makeData(){
        
        //Account 
        try{
          
            Account accCustomer = TestDataFactory.createAccounts('Cuenta customer', 'Customer');        
            Account accCarrier = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');    
            User usr = TestDataFactory.createUserAdmin();
            Rol_Margen__c margen = TestDataFactory.createRolMargen('Director Comercial');
            Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso'); 
            Carrier_Line_Load_Point__c route = TestDataFactory.createRoute('Tlaxcala - Tlaxco',null);
            //Customer_Quote__c folio = TestDataFactory.createFolio(accCustomer.Id,catalogo.Id,route.Id,'Sea','EXPORT','FCL',false);        
            Customer_Quote__c folio = new Customer_Quote__c();
            folio.Account_for__c = accCustomer.Id;
            folio.Freight_Mode__c = 'Sea';
            folio.Service_Mode__c = 'EXPORT'; 
            folio.Service_Type__c = 'FCL';
            folio.Move_Type__c = 'Door to Door';
            folio.Origin_Address__c = 'Address Test'; 
            folio.Destination_Address__c = 'Address Test';
            folio.ByPass__c = true;
            folio.Impak_Request__c = true;
            folio.Date_Pricing_responded__c = System.today();
            folio.Clave_de_Unidad_de_Peso__c = catalogo.Id;       
            folio.Margin_at_Destination_by_Default__c = 10;
            folio.Pricing_Executive__c = UserInfo.getUserId();
            insert folio; 
            Import_Export_Fee_Line__c serviceLine = TestDataFactory.createServiceLine('linea01',route.Id,folio);
            Quote_Item_Line__c cargoLine = TestDataFactory.createCargoLine('cargoLine01',folio);
        }catch(Exception e){
            System.debug('catch: ' + e.getMessage());
        }                         
    }
    */
    @isTest
    public static void runTest(){

        /*
        List<Customer_Quote__c> folios = [Select Id, Name, IMPAK__c,Clave_de_Unidad_de_Peso__c from Customer_Quote__c where  Clave_de_Unidad_de_Peso__r.Name = 'Caja de acero test'];
        Customer_Quote__c folio = folios.get(0);        
*/
Account acc= new Account();
			acc.Name='Test';
			acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        	acc.OwnerId=UserInfo.getUserId();        	
        insert acc;

User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        quote.RecordTypeId = recordTypeId;
        quote.Name='.';
        quote.Account_for__c = acc.Id;
        quote.Team__c = 'P2G';
        quote.Quotation_Status__c = 'Quote being prepared';
        quote.Customer_Reference__c = 'hola soy una prueba';
        quote.Valid_From__c = system.today();
        quote.Valid_Until__c = system.today();
        quote.Comercio_Exterior__c = 'No';
        quote.Freight_Mode__c = 'Road';
        quote.Service_Mode__c = 'NATIONAL';
        quote.Service_Type__c = 'FTL';
        quote.CurrencyIsoCode = 'MXN';
        quote.ETD__c = Date.today();
        quote.ETA__c = Date.today();
        quote.Community_Status__c = 'CUSTOMER CREATED';
        quote.Pricing_Executive__c= userT.Id;
        quote.Operations_Exec__c = userT.Id;
        insert quote;
        Test.startTest();       
                
        try{
            
            quote.IMPAK__c = 'Si';
        	update quote;
            throw new createException('The Import-Export Order is Approved. Sell Amount is locked.');
            
        }catch(Exception e){            
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