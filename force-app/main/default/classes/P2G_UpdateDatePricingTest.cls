@isTest
private class P2G_UpdateDatePricingTest {
    @TestSetup
    static void Setup(){
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
    }


    @isTest
    static void test_UpdateDateFields() {
        Test.startTest();
        
        // Crear una cuenta de prueba
        Account account_test = new Account(Name = 'Test Account', Segment__c = 'Nuevo');
        insert account_test;
        // Crear un Customer_Quote__c que NO cumpla con los criterios del trigger
        Customer_Quote__c quote_test = new Customer_Quote__c(
            Account_for__c = account_test.Id,
            Freight_Mode__c = 'Sea',
            Service_Mode__c = 'Import',
            Service_Type__c = 'LCL Cargo',
            Move_Type__c = 'Door to Door',
            Origin_Address__c = 'Address Test',
            Destination_Address__c = 'Address Test',
            Team__c = 'P2G',
            Pricing_Executive__c = UserInfo.getUserId(),
            Quotation_Status__c = 'Sent awaiting response'
        );
        insert quote_test;
        
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
        cargoLine.Import_Export_Quote__c=quote_test.Id;
        cargoLine.Name='cargo12';
        //cargoLine.Item_Name__c=cargo.idItem;
        cargoLine.Extension_Item_Name__c='Papel';
        cargoLine.CurrencyIsoCode='MXN';
        cargoLine.Conversion_Rate_to_Currency_Header__c=1;
        cargoLine.Units__c=1;
        cargoLine.Total_Shipping_Weight_Kgs__c=1;
        cargoLine.Peso_Neto__c=1;
        cargoLine.Total_Shipping_Volume_m3__c=1;
        insert cargoLine;

        // **PRIMERA REGLA**: Actualizar el registro para que CUMPLA con la primera condición del trigger
		quote_test.Quotation_Status__c ='Awaiting costs suppliers';
		update quote_test;
        
        Test.stopTest();
    }
}