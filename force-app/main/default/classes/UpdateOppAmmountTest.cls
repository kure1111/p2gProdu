@isTest
public class UpdateOppAmmountTest {
    @isTest
    public static void test(){
        User us = TestDataFactory.createUserAdmin();
        Account a = new Account();
        a.Name = 'test';
        a.Customer_Id__c = '58SQL1256';
        a.OwnerId = us.Id;
        a.Venta_Sap__c = 'Contado';         
        insert a;
                
        Rol_Margen__c rm = TestDataFactory.createRolMargen('Director Comercial'); 
        Opportunity op = new Opportunity();
        op.AccountId = a.Id;
        op.Name = 'Test OP';
        op.Service_Type__c = 'FN';
        op.StageName = 'Prospecting';
        op.CloseDate = date.today() + 3;
        insert op;
        
        /*Customer_Quote__c q = new Customer_Quote__c();
        q.Name = 'Test';
        q.Account_for__c = a.Id;
        q.Only_Warehouse_Service__c = true;
        q.Opportunity__c = op.Id;
        q.Pricing_Executive__c=userinfo.getUserId();
        insert q;*/   
        
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso'); 
        
        Customer_Quote__c folio = new Customer_Quote__c();
        folio.Account_for__c = a.Id;
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
        folio.Only_Warehouse_Service__c = true;
        folio.Pricing_Executive__c = UserInfo.getUserId();
        folio.Opportunity__c = op.Id;
        insert folio;
        
        Import_Export_Fee_Line__c l = new Import_Export_Fee_Line__c();
        l.Name = '001';
        l.Import_Export_Quote__c = folio.Id;
        l.Units__c = 1;
        l.Quote_Sell_Price__c = 100;
        insert l;
    }
}