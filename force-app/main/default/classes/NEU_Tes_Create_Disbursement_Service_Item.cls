@isTest
public class NEU_Tes_Create_Disbursement_Service_Item {
	@isTest(SeeAllData=true)
    static void NEU_Create_Disbursement_Service_Item()
    {

        NEU_StaticVariableHelper.setBoolean1(true);

        //Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        //insert a;

        //Account b = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId(),Business_Area__c = 'Sales');
        //insert b;

        Account a = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
        RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
        AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];   

        Account b = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
        RecordType.DeveloperName, RecordType.Name 
        FROM Account WHERE  Owner.isActive=true AND Owner.SalesEmployer__c!=null 
        AND RecordType.Name= 'Supply Chain Partner' limit 1];
        

        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = a.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.Name = 'SP-TS-00005';
        insert shipment_test;

        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = shipment_test.Id, Name= 'test ship line');
        insert shipline;

        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;

        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= shipment_test.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;

        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;

        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC', IATA_Code__c='IAC');
        insert localizacion;

        Customer_Quote__c importexportquote = new Customer_Quote__c(Account_for__c = a.Id, Pricing_Executive__c=userInfo.getUserId(),
                Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress',
                Country_ofLoad__c= Country.Id, Site_of_Load__c =localizacion.Id,Country_ofDischarge__c= Country.Id,
                Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');
        insert importexportquote;

        Import_Export_Fee_Line__c quote = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id, Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10, Quote_Sell_Price__c=10,Units__c=10);
        insert quote;

        Shipment_Disbursement__c shipdis = new Shipment_Disbursement__c(Shipment__c=shipment_test.Id, Account__c=b.Id, Conversion_Rate_to_Imp_Exp_Currency__c = 1, Import_Export_Quote_Order__c = importexportquote.id);
        insert shipdis;

        Disbursement_Line__c dl = new Disbursement_Line__c(Name='Test DL', Disbursement__c=shipdis.Id);
        insert dl;

        Shipment_Service_Line_Disbursement__c shipDisLine = new Shipment_Service_Line_Disbursement__c(Shipment_Disbursement__c = shipdis.Id, Shipment_Service_Line__c = shipfeeline.Id);
        insert shipDisLine;

        Shipment_Item_Line_Disbursement__c shipItemLine = new Shipment_Item_Line_Disbursement__c(Shipment_Disbursement__c = shipdis.Id, Shipment_Item_Line__c = shipline.Id);
        insert shipItemLine;

        NEU_Create_Disbursement_Service_Item c=new NEU_Create_Disbursement_Service_Item(new ApexPages.StandardController(shipdis));
        for(NEU_Create_Disbursement_Service_Item.Disbursement_ie_services_s l:c.Lines_ie_services)
        {
            l.selected=true;
            string qbps = l.Quote_Buy_Price_String;
            string bas = l.Buy_Amount_String;
            decimal dob = l.Disbursement_Outstanding_Balance;
            string dobs = l.Disbursement_Outstanding_Balance_String;
            decimal dobb = l.Disbursement_Outstanding_Base;
            break;
        }
        for(NEU_Create_Disbursement_Service_Item.DisbursementS_s l:c.Lines_shipment_services)
        {
            l.selected=true;
            string sbps = l.Shipment_Buy_Price_String;
            string bas = l.Buy_Amount_String;
            decimal dob = l.Disbursement_Outstanding_Balance;
            string dobs = l.Disbursement_Outstanding_Balance_String;
            decimal dobb = l.Disbursement_Outstanding_Base;
            string compareField = 'selected';
            l.getValue(compareField);
            break;
        }
        c.sorting(0,'selected',1);
        c.sorting(1,'selected',1);
        c.generate();
        c.cancel();
        c.generate();
        c.decimalSep=c.decimalSep;
        c.thousandSep=c.thousandSep;
        c.new_disbursement_line();
        c.new_line_disbursementline_empty();

        string dcs=c.Disbursement_Currency_String;
        c.quit_line_select();
        c.delete_line_select();
        String compareField ='selected';
        /*c.getValue(compareField);
        c.*/
    }
}