@isTest()
public class Pak_MargenOperativo_Test {
    @isTest
    public static void pruebaFN(){
        
         Test.startTest();

   // try {
   
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        list<User> users = [select Alias,Email,LastName from user where UserName = 'testfn2@testorg.com'];
        
        UserRole obj=new UserRole(Name= 'Asesor Comercial'); 
        insert obj; 
        
        
        
        User u = users.size() > 0 ? users[0] : new User(Alias = 'testfn2', Email='testfn2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='testfn2', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testfn2@testorg.com',FN_Marg_Op__c=40);
          u.UserRoleId = obj.Id;
      //  update u;

        System.runAs(u) {
            
            Rol_Margen__c rolm = new Rol_Margen__c();
        rolm.Name = 'Asesor Comercial';
        rolm.FN_Margen_Operativo__c = 1;
        rolm.FI_Margen_Operativo__c  = 1;
        
        insert rolm;
            
            NEU_StaticVariableHelper.setBoolean1(false);
            
            List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
            Account a = list_accounts[0];
            a.ActiveSap__c = true;
            insert a;   Account_Address__c address = new Account_Address__c();
            address.Name = 'Bonafont Cln';
            address.Account__c = a.id;
            address.Address__c ='Conocida';
            address.Address_Coordinates__Latitude__s=  22.023033;
            address.Address_Coordinates__Longitude__s=-102.285602;
            address.Type__c = 'Shipping Address	';
            insert address;
            
            Account_Address__c address2 = new Account_Address__c();
            address2.Name = 'Cln';
            address2.Account__c = a.id;
            address2.Address__c ='Conocida';
            address2.Address_Coordinates__Latitude__s=19.6248115;
            address2.Address_Coordinates__Longitude__s=-99.18076289999999;
            address2.Type__c = 'Shipping Address	';
            insert address2;
            
            Customer_Quote__c cq = new Customer_Quote__c();
            cq.Team__c = 'P2G';
            cq.Account_for__c = a.id;
            cq.Quotation_status__c ='Quote being prepared';
            cq.Only_Warehouse_Service__c  = true;
            cq.Freight_Mode__c = 'Road';
            cq.Service_Mode__c = 'NATIONAL';
            cq.Name = 'FN-21-003507';
            cq.Destination_Address__c = 'Hola';
            cq.Origin_Address__c = 'Hola';
            cq.Account_Origin_Address__c = address.id;
            cq.Account_Destination_Address__c = address2.id;
            cq.Motivo__c = 'dada';
            cq.Pricing_Executive__c = u.id;
            
            insert cq;
            
            Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = cq.id,Name = 'lineas items', Units__c = 1,Total_Shipping_Weight_Kgs__c= 1);
            insert quote;
            Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
            insert fee;
            Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = cq.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
            insert quote2;
            
            cq.Quotation_status__c = 'Approved as Succesful';
            update cq;
        } 
        
           
  /*  } catch (Exception e) {
       System.debug('An error occurred');
    }*/

   Test.stopTest();
        
    }
    
    @isTest
    public static void pruebaFI(){
         Test.startTest();
       // try
        //{
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
       list<User>  users = [select Alias,Email,LastName from user where UserName = 'testfi2@testorg.com'];
        
        UserRole obj=new UserRole(Name= 'Asesor Comercial'); 
        insert obj; 
        
        
        
        User u = users.size()>0 ? users[0] : new User(Alias = 'testfi2', Email='testfi2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='testfi2', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testfi2@testorg.com',FI_Marg_Op__c = 30);
        
        u.UserRoleId = obj.Id;
     //   update u;
        
        System.runAs(u) {
            
              Rol_Margen__c rolm = new Rol_Margen__c();
        rolm.Name = 'Asesor Comercial';
        rolm.FN_Margen_Operativo__c = 1;
        rolm.FI_Margen_Operativo__c  = 1;
        insert rolm;
            
            NEU_StaticVariableHelper.setBoolean1(false);
            
            List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
            Account a = list_accounts[0];
            a.ActiveSap__c = true;
            insert a;
            
            Customer_Quote__c cq = new Customer_Quote__c();
            cq.Team__c = 'P2G';
            cq.Account_for__c = a.id;
            cq.Quotation_status__c ='Quote being prepared';
            cq.Only_Warehouse_Service__c  = true;
            cq.Freight_Mode__c = 'Road';
            cq.Service_Mode__c = 'NATIONAL';
            cq.Name = 'AW-21-003507';
            cq.Motivo__c = 'dada';
            cq.Pricing_Executive__c = u.id;
            
            cq.Destination_Address__c = 'Hola';
            cq.Origin_Address__c = 'Hola';
            insert cq;
            
            
            Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = cq.id,Name = 'lineas items', Units__c = 1,Total_Shipping_Weight_Kgs__c= 1);
            insert quote;
            Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
            insert fee;
            Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = cq.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
            insert quote2;
            
            cq.Quotation_status__c = 'Approved as Succesful';
            update cq;
        }
            

  /*  } catch (Exception e) {
       System.debug('An error occurred');
    }*/

   Test.stopTest();
        
    }
    
    
}