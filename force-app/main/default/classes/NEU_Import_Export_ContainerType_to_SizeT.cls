@isTest
public class NEU_Import_Export_ContainerType_to_SizeT {

    
    @isTest
    public static void runTest(){
        
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.ActiveSap__c = true;
        insert a;
        Account sup = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');
		//Account sup1 = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');        
        User usr = TestDataFactory.createUserAdmin();
		Rol_Margen__c rm = TestDataFactory.createRolMargen('Director Comercial');
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso'); 
        //Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Approved as Succesful', Container_Size__c = '20" Container');
        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Consignee__c = a.Id, Supplier_Account__c = sup.Id, Quotation_Status__c=' Quote being prepared', Container_Size__c = '20" Container', Origin_Address__c = '', Destination_Address__c = '', Only_Warehouse_Service__c = true,Pricing_Executive__c=userinfo.getUserId(),Clave_de_Unidad_de_Peso__c = catalogo.Id);
        insert importexportquote;       
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items',Units__c=10);
        insert quote;
        
        Fee__c service_rate = new Fee__c();
        service_rate.Name = 'Sercie Rate Test';
        service_rate.Fee_Category__c = 'Disbursement';
        service_rate.Rate_Type__c = 'Per Kg';
        service_rate.Account_for__c = a.Id;
        insert service_rate;
        
        Import_Export_Fee_Line__c ie_service_line = new Import_Export_Fee_Line__c();
        ie_service_line.Import_Export_Quote__c = importexportquote.Id;
        ie_service_line.Name = '001';
        ie_service_line.Service_Rate_Name__c = service_rate.Id;
        ie_service_line.Extension_Service_Name__c = 'Test Name';
        ie_service_line.Discount__c = 10;
        ie_service_line.Quote_Buy_Price__c = 10;
        ie_service_line.Quote_Sell_Price__c = 10;
        ie_service_line.Units__c = 10;
        insert ie_service_line;
        
        importexportquote.Quotation_Status__c ='Approved as Succesful';
        update importexportquote;
        Test.stopTest();
    }
}