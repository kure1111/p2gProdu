@isTest
public class P2G_NEU_Allocate_Costs_Ship_Ser_LinTest {
@isTest(SeeAllData=true)
    static void test_NEU_Allocate_Costs_to_Ship_Service_Lines3() 
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Carrier_Line_Load_Point__c route2 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route2;
        Shipment_Program__c ship_prog3 = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10', Route__c =route2.Id);
        insert ship_prog3;
        NEU_Allocate_Costs_to_Ship_Service_Lines acssl2 = new NEU_Allocate_Costs_to_Ship_Service_Lines(new ApexPages.StandardController(ship_prog3));
        ApexPages.currentPage().getParameters().put('pes', 'Warehouse');
        
        acssl2.getnewcategories();
        acssl2.all_carriers_filter();
        acssl2.filter_new_carrier();
        acssl2.getFee_List_Price2();
        acssl2.go_compare_fees_filtro2();
        
        List<Fee__c>feesToAdd=new List<Fee__c>();
        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Warehouse',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Fixed', Account_for__c = a.Id, Min__c = 80, Max_Kgs__c = 80, Volumetric_Factor__c = 80);
        feesToAdd.add( fee10);
        Fee__c fee24 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee24); 
        Fee__c fee25 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee25); 
        Fee__c fee26 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee26); 
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee14); 
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee15); 
        Fee__c fee16 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee16); 
        Fee__c fee27 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee27); 
        Fee__c fee28 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee28); 
        Fee__c fee29 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee29); 
        Fee__c fee17 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee17); 
        Fee__c fee18 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee18); 
        Fee__c fee19 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee19); 
        Fee__c fee30 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee30); 
        Fee__c fee11 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee11); 
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee12);
        Fee__c fee20 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id);
        feesToAdd.add(fee20);
        Fee__c fee21 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee21);
        Fee__c fee22 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10);
        feesToAdd.add(fee22);
        insert feesToAdd; 
        acssl2.setnewcategory('Disbursement');
        acssl2.Fee_List_Price = null;
        acssl2.getFee_List_Price();
        
        acssl2.setnewcategory('Warehouse');
        acssl2.Fee_List_Price = null;
        acssl2.getFee_List_Price();
        Shipment__c ship2 = new Shipment__c(Name = 'SP-TS-003', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog3.Id, Route__c = route2.Id, Site_of_Discharge__c =localizacion.Id , Site_of_Load__c = localizacion.Id,Country_of_Discharge__c= Country.Id, Country_of_Load__c = Country.Id, Only_Warehouse_Service__c = true);
        insert ship2;
        Shipment__c ship3 = new Shipment__c(Name = 'SP-TS-004', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Inbound_Consolidation_Program__c = ship_prog3.Id, Route__c = route2.Id, Only_Warehouse_Service__c = true);
        insert ship3;
        Customer_Quote__c importexportquote = [SELECT Id, Margen_Operativo__c, Pricing_Executive__c FROM Customer_Quote__c WHERE Margen_Operativo__c !=null AND Pricing_Executive__c!=null LIMIT 1];
        Shipment_Consolidation_Data__c new_shipment_consolidation_data = new Shipment_Consolidation_Data__c(Shipment__c = ship2.Id, Import_Export_Quote__c = importexportquote.Id);
        insert new_shipment_consolidation_data;
        Import_Export_Fee_Line__c quote_line = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee28.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote_line;
        Import_Export_Fee_Line__c quote_line2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee28.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10 );
        insert quote_line2;
        Shipment_Fee_Line__c ship_fee_line = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee28.Id , Shipment__c= ship2.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line2.Id);
        insert ship_fee_line;
        Shipment_Fee_Line__c ship_fee_line2 = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee28.Id , Shipment__c= ship2.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10, Import_Export_Service_Line__c = quote_line.Id);
        insert ship_fee_line2;
        Shipment_Program_Line__c  ship_prog_line3 = new Shipment_Program_Line__c (Name = 'test' , Shipments_Program__c = ship_prog3.Id, Units__c = 10, Service_Rate_Name__c = fee28.Id, Inbound_Shipment__c = ship2.Id);
        insert ship_prog_line3;
        
        Ship_Service_Consol__c new_ship_service_consol3 = new Ship_Service_Consol__c(Shipment_Service_Line__c = ship_fee_line.Id, Shipments_Program_Service_Line__c = ship_prog_line3.Id);
        insert new_ship_service_consol3;
        acssl2.List_Fee_Shipment_Import_Export = null;
        acssl2.getList_Fee_Shipment_Import_Export();
        acssl2.setnewcategory('Disbursement');
        acssl2.List_Fee_Shipment_Import_Export = null; 
        acssl2.getList_Fee_Shipment_Import_Export();
        
    }
}