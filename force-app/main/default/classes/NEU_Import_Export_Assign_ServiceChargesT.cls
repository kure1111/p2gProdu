@isTest
public with sharing class NEU_Import_Export_Assign_ServiceChargesT {
    
    //private class createException extends Exception {}
    
    @TestSetup
    static void makeData(){
        
        //Account 
        /*try{
          
            Account accCustomer = TestDataFactory.createAccounts('Cuenta customer', 'Customer');        
            Account accCarrier = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');    
            User usr = TestDataFactory.createUserAdmin();
            Rol_Margen__c margen = TestDataFactory.createRolMargen('Director Comercial');
            Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso'); 
            Carrier_Line_Load_Point__c route = TestDataFactory.createRoute('Tlaxcala - Tlaxco',null);
            Customer_Quote__c folio = TestDataFactory.createFolio(accCustomer.Id,catalogo.Id,route.Id,'Sea','EXPORT','FCL',false);        
            Import_Export_Fee_Line__c serviceLine = TestDataFactory.createServiceLine('linea01',route.Id,folio);
            Quote_Item_Line__c cargoLine = TestDataFactory.createCargoLine('cargoLine01',folio);
        }catch(Exception e){
            System.debug('catch: ' + e.getMessage());
        }*/   
        
        Account accCustomer = TestDataFactory.createAccounts('Cuenta customer', 'Customer');        
        Account accCarrier = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');    
        User usr = TestDataFactory.createUserAdmin();
        Rol_Margen__c margen = TestDataFactory.createRolMargen('Director Comercial');
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso'); 
        Carrier_Line_Load_Point__c route = TestDataFactory.createRoute('Tlaxcala - Tlaxco',null);
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
    }

    @isTest
    public static void runTest(){

        List<Customer_Quote__c> folios = [Select Id, Name, IMPAK__c,Clave_de_Unidad_de_Peso__c from Customer_Quote__c where  Clave_de_Unidad_de_Peso__r.Name = 'Caja de acero test'];
        Customer_Quote__c folio = folios.get(0);
        system.debug('folio creado: ' + folio);
        Import_Export_Fee_Line__c serviceLine = [SELECT Id,Name,Quote_Sell_Price__c,Quote_Buy_Price__c  FROM Import_Export_Fee_Line__c WHERE Import_Export_Quote__c =:folios[0].Id];

        Test.startTest();

        serviceLine.Quote_Sell_Price__c = 0;
        serviceLine.Quote_Buy_Price__c = 0;
        update serviceLine;
        folio.IMPAK__c = 'Si';
        update folio;
            /*try{
             
                
                //throw new createException('The Import-Export Order is Approved. Sell Amount is locked.');
                
            }catch(Exception e){
                //catch para el error del trigger NEU_Disable_Approved_Quotes
                Boolean expectedExceptionThrown =  e.getMessage().contains('The Import-Export Order is Approved. Sell Amount is locked.') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
            }*/            
        
        Test.stopTest();
        
    }
}