@isTest
public class NEU_Order_Confirmation_Shipment_pdfTest {
     static testMethod void test_NEU_Order_Confirmation_Shipment_pdf()
     {

         NEU_StaticVariableHelper.setBoolean1(true);

       List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
       Account a = list_accounts[0];
       insert a;
       Shipment__c ship = new Shipment__c(Name='ada',Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
       insert ship;
       Product_Family__c fam = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
       insert fam;
       Subfamily__c subfam = new Subfamily__c(Product_Family__c = fam.Id, Name = 'test subfamily');
       insert subfam;
       Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfam.Id, Sourcing_Family__c =fam.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
       insert item;
       Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Item_Name__c = item.Id, Expense_Amount__c = 10);
       insert shipline;
       Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Standard_Rate__c  = true, Account_for__c = a.Id);
       insert fee;
       Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
       insert shipfeeline; 
       ApexPages.currentPage().getParameters().put('services_charges', 'true');
       NEU_Order_Confirmation_Shipment_pdf uda = new NEU_Order_Confirmation_Shipment_pdf(new ApexPages.StandardController( ship ));
       
     }

}