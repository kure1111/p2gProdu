/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class NEU_test_FR_Management 
{
    static testMethod void NEU_Freight_Rates_Management() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account a2 = list_accounts[1];
        insert a2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='CHN');
        insert Country;
        Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='ESP');
        insert Country2;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Location__c localizacion2 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion2;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country2.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion2.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Carrier_Line_Load_Point__c route2 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route2;
        NEU_Freight_Rates_Management c=new NEU_Freight_Rates_Management();
        List<Container_Type__c>conts=new List<Container_Type__c>();
        Container_Type__c container=new Container_Type__c(Name=c.containerNames[0]);
        conts.add(container);
        conts.add(new Container_Type__c(Name=c.containerNames[1]));
        conts.add(new Container_Type__c(Name=c.containerNames[2]));
        insert conts;
        Fee__c fee = new Fee__c(Account_for__c=a.id,Name = 'test fees', Fee_Category__c = 'Multimodal Freights', Rate_Type__c = 'Per Container',Container_Type__c=container.id, Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route.id, Carrier_Account__c=a2.id,Valid_From__c=system.today(),Valid_Until__c=system.today());
        NEU_CurrencyUtils.setCurrencyISOCode(fee,'MXN');
        insert fee;
        Fee__c fee2 = new Fee__c(Account_for__c=a.id,Name = 'test fees', Fee_Category__c = 'Multimodal Freights', Rate_Type__c = 'Per Container',Container_Type__c=container.id, Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route.id, Carrier_Account__c=a2.id,Valid_From__c=system.today(),Valid_Until__c=system.today());
        NEU_CurrencyUtils.setCurrencyISOCode(fee2,'MXN');
        insert fee2;
        Fee__c fee3 = new Fee__c(Account_for__c=a.id,Name = 'test fees', Fee_Category__c = 'Multimodal Freights', Rate_Type__c = 'Per Container',Container_Type__c=container.id, Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route2.id, Carrier_Account__c=a2.id,Valid_From__c=system.today(),Valid_Until__c=system.today());
        NEU_CurrencyUtils.setCurrencyISOCode(fee3,'MXN');
        insert fee3;
        
        Fee__c fee_test = new Fee__c();
        fee_test.Account_for__c = a.Id;
        fee_test.Name = 'Fee Test'; 
        fee_test.Fee_Category__c = 'Sea Freights'; 
        fee_test.Rate_Type__c = 'Per Container';
        fee_test.Fee_Rate__c = 1;
        fee_test.Standard_Rate__c = true; 
        fee_test.Route__c = route.id;
        fee_test.Carrier_Account__c = a2.Id;
        fee_test.Valid_Until__c = system.today();
        insert fee_test;
        
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Freight_Mode__c = 'Sea'; 
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Forwarder__c = a2.Id;
        shipment_test.Country_of_Load__c = Country.Id;
        shipment_test.Site_of_Load__c = localizacion.Id;
        shipment_test.Account_for__c = a.Id;
        shipment_test.Country_of_Discharge__c = Country2.Id;
        shipment_test.Site_of_Discharge__c = localizacion2.Id;
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
        
        Shipment_Fee_Line__c shipment_line_test = new Shipment_Fee_Line__c();
        shipment_line_test.Name = 'Shipment Line Test';
        shipment_line_test.Shipment__c = shipment_test.Id;
        shipment_line_test.Shipment_Buy_Price__c = 100;
        shipment_line_test.Shipment_Sell_Price__c = 100;
        shipment_line_test.Service_Rate_Name__c = fee_test.Id;
        insert shipment_line_test;
        
        c=new NEU_Freight_Rates_Management();
        c.validationOK=c.validationOK;
        c.buyselllist=c.buyselllist;
        c.updatefilters();
        c.DisplayConcepts=1;
        c.DisplayConcepts=0;
        c.displayMinslist=c.displayMinslist;
        c.decimalSep=c.decimalSep;
        c.thousandSep=c.thousandSep;
        c.BuySell=c.BuySell;
        c.allcountries=c.allcountries;
        c.allcountries=null;
        c.alllocations=c.alllocations;
        c.alllocations=null;
        List<NEU_Freight_Rates_Management.Country_Locations_s> cl=c.alllocations;
        c.myList=c.myList;
        c.filterCurrencyISOCode='MXN';
        c.filter.Account_for__c=a.id;
        c.filter.Carrier_Account__c=a2.id;
        c.filter.Fee_Category__c='Multimodal Freights';
        c.filter.Rate_Type__c='Per Container';
        c.filter.Route__r=new Carrier_Line_Load_Point__c();
        c.filter.Route__r.Country_of_Load__c=Country.id;
        c.filter.Route__r.Port_Airport_of_Load__c=localizacion.id;
        c.filter.Route__r.Country_of_Discharge__c=Country2.id;
        c.filter.Route__r.Port_Airport_of_Discharge__c=localizacion2.id;
        c.filter.Valid_From__c=fee.Valid_From__c;
        c.filter.Valid_Until__c=fee.Valid_Until__c;
        
        c.id_service = fee_test.Id;
        c.id_carrier = a2.id;
        c.buy_rate_filter = 100;
        c.sell_rate_filter = 100;
        c.get_carrier_contact_details();
        c.get_historical_prices();
        
        c.resetList();
        for(NEU_Freight_Rates_Management.ServiceRate_s s:c.myList)
        {
            String t=s.margin0;
            t=s.margin1;
            t=s.margin2;
            t=s.margin3;
            s.Port_Airport_of_Load=s.Port_Airport_of_Load;
            s.Port_Airport_of_Discharge=s.Port_Airport_of_Discharge;
            s.getValue('Margin0');
            s.getValue('Margin1');
            s.getValue('Margin2');
            s.getValue('Margin3');
            s.getValue('Buy_Rate1');
            s.getValue('Buy_Rate2');
            s.getValue('Buy_Rate3');
            s.getValue('Sell_Rate1');
            s.getValue('Sell_Rate2');
            s.getValue('Sell_Rate3');
            s.getValue('Name');
        }
        c.sortList(1);
        c.idLines=fee.id;
        c.firstLine=5;
        c.orderLines();
        c.numLines=10;
        c.addLines();
        c.addLine();
        for(NEU_Freight_Rates_Management.ServiceRate_s s:c.myList)
        {
            s.fee0.Name='test';
            s.fee0.Buy_Rate__c=1;
            s.fee1.Buy_Rate__c=1;
            s.fee2.Buy_Rate__c=1;
            s.fee3.Buy_Rate__c=1;
        }
        c.saveData();
        for(NEU_Freight_Rates_Management.ServiceRate_s s:c.myList)
        {
            s.fee0.Name='test';
            s.fee0.Route__r=new Carrier_Line_Load_Point__c();
            s.fee0.Route__r.Country_of_Load__c=country2.id;
            s.fee0.Route__r.Port_Airport_of_Load__c=localizacion2.id;
            s.fee1.Buy_Rate__c=1;
            s.fee2.Buy_Rate__c=1;
            s.fee3.Buy_Rate__c=1;
        }
        c.filter.Rate_Type__c='Per Container';
        c.saveData();
        c.TMin1=c.TMin1;
        c.TMin2=c.TMin2;
        c.TMin3=c.TMin3;
        c.TMin4=c.TMin4;
        c.TMin5=c.TMin5;
        c.DisplayMins = 4;
        integer contador = 0;
        for(NEU_Freight_Rates_Management.ServiceRate_s s:c.myList)
        {
            if(contador == 0)
            {
                s.fee0.Route__r=new Carrier_Line_Load_Point__c();
                s.fee0.Route__r.Country_of_Load__c=country2.id;
                s.fee0.Route__r.Port_Airport_of_Load__c=localizacion2.id;
            }   
            if(contador == 1)
            {
                s.fee0.Route__r=new Carrier_Line_Load_Point__c();
                s.fee0.Route__r.Country_of_Load__c=Country.id;
                s.fee0.Route__r.Port_Airport_of_Load__c=localizacion.id;
            }
            contador ++;        
        }
        c.updateCountriesLocations();
        String temp=c.queryString;
    }
    
    static testMethod void NEU_Freight_Rates_Management2() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account a = list_accounts[0];
        insert a;
        Account a2 = list_accounts[1];
        insert a2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='CHN');
        insert Country;
        Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='ESP');
        insert Country2;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Location__c localizacion2 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion2;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country2.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion2.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route;
        Carrier_Line_Load_Point__c route2 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
        insert route2;
        NEU_Freight_Rates_Management c=new NEU_Freight_Rates_Management();
        List<Container_Type__c>conts=new List<Container_Type__c>();
        Container_Type__c container=new Container_Type__c(Name=c.containerNames[0]);
        conts.add(container);
        conts.add(new Container_Type__c(Name=c.containerNames[1]));
        conts.add(new Container_Type__c(Name=c.containerNames[2]));
        insert conts;
        Fee__c fee = new Fee__c(Account_for__c=a.id,Name = 'test fees', Fee_Category__c = 'Sea Freights', Max_Kgs__c=100, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route.id, Carrier_Account__c=a2.id,Valid_From__c=system.today(),Valid_Until__c=system.today());
        NEU_CurrencyUtils.setCurrencyISOCode(fee,'MXN');
        insert fee;
        Fee__c fee2 = new Fee__c(Account_for__c=a.id,Name = 'test fees', Fee_Category__c = 'Sea Freights', Max_Kgs__c=200, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route.id, Carrier_Account__c=a2.id,Valid_From__c=system.today(),Valid_Until__c=system.today());
        NEU_CurrencyUtils.setCurrencyISOCode(fee2,'MXN');
        insert fee2;
        Fee__c fee3 = new Fee__c(Account_for__c=a.id,Name = 'test fees', Fee_Category__c = 'Sea Freights', Max_Kgs__c=300, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route2.id, Carrier_Account__c=a2.id,Valid_From__c=system.today(),Valid_Until__c=system.today());
        NEU_CurrencyUtils.setCurrencyISOCode(fee3,'MXN');
        insert fee3;
        Fee__c fee4 = new Fee__c(Account_for__c=a.id,Name = 'test fees', Fee_Category__c = 'Sea Freights', Max_Kgs__c=400, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route2.id, Carrier_Account__c=a2.id,Valid_From__c=system.today(),Valid_Until__c=system.today());
        NEU_CurrencyUtils.setCurrencyISOCode(fee4,'MXN');
        insert fee4;
        Fee__c fee5 = new Fee__c(Account_for__c=a.id,Name = 'test fees', Fee_Category__c = 'Sea Freights', Max_Kgs__c=500, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route2.id, Carrier_Account__c=a2.id,Valid_From__c=system.today(),Valid_Until__c=system.today());
        NEU_CurrencyUtils.setCurrencyISOCode(fee5,'MXN');
        insert fee5;
        
        c=new NEU_Freight_Rates_Management();
        c.filterCurrencyISOCode='MXN';
        c.filter.Account_for__c=a.id;
        c.filter.Carrier_Account__c=a2.id;
        c.filter.Fee_Category__c='Sea Freights';
        c.filter.Rate_Type__c='Per Kg';
        c.TMin1='100';
        c.TMin2='200';
        c.TMin3='300';
        c.TMin4='400';
        c.TMin5='500';
        c.DisplayMins = 4;
        integer contador = 0;
        for(NEU_Freight_Rates_Management.ServiceRate_s s:c.myList)
        {
            if(contador == 0)
            {
                s.fee0.Route__r=new Carrier_Line_Load_Point__c();
                s.fee0.Route__r.Country_of_Load__c=country2.id;
                s.fee0.Route__r.Port_Airport_of_Load__c=localizacion2.id;
                s.fee0.Buy_Rate__c=10;
                s.fee1.Buy_Rate__c=10;
                s.fee2.Buy_Rate__c=10;
                s.fee3.Buy_Rate__c=10;
                s.fee4.Buy_Rate__c=10;
                s.fee5.Buy_Rate__c=10;
                s.fee6.Buy_Rate__c=10;
            }   
            if(contador == 1)
            {
                s.fee0.Route__r=new Carrier_Line_Load_Point__c();
                s.fee0.Route__r.Country_of_Load__c=Country.id;
                s.fee0.Route__r.Port_Airport_of_Load__c=localizacion.id;
                s.fee0.Buy_Rate__c=1;
                s.fee1.Buy_Rate__c=1;
                s.fee2.Buy_Rate__c=11;
                s.fee3.Buy_Rate__c=1;
                s.fee4.Buy_Rate__c=11;
                s.fee5.Buy_Rate__c=1;
                s.fee6.Buy_Rate__c=10;
            }
            contador ++;        
        }
        c.updateCountriesLocations();
        c.saveData();
    }
     static testMethod void NEU_Freight_Rates_Emails_save_pdf () 
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
	        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,'); 
	        Account a = list_accounts[0];
	        insert a;

		 //Carrier
		 Account a2 = list_accounts[1];
		 insert a2;

		 //Routes and Contruies
		 Country__c Country = new Country__c(Name='test country',  ISO_Code__c='CHN');
		 insert Country;
		 Country__c Country2 = new Country__c(Name='test country',  ISO_Code__c='ESP');
		 insert Country2;
		 Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
		 insert localizacion;
		 Location__c localizacion2 = new Location__c(Name='test localizacion', City__c='test city', Country__c= country2.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
		 insert localizacion2;
		 Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country2.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion2.Id, Port_Airport_of_Load__c=localizacion.Id);
		 insert route;
		 Carrier_Line_Load_Point__c route2 = new Carrier_Line_Load_Point__c(Name='test',  Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=localizacion.Id, Port_Airport_of_Load__c=localizacion.Id);
		 insert route2;

		 //List Services Rates
		 List<Fee__c> service_rates = new List<Fee__c>();
		 Fee__c fee = new Fee__c(Account_for__c=a.id,Name = 'Freights', Fee_Category__c = 'Sea Freights', Max_Kgs__c=100, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route.id, Carrier_Account__c=a2.id, Valid_Until__c = system.today().AddDays(5));
		 NEU_CurrencyUtils.setCurrencyISOCode(fee,'MXN');
		 service_rates.add(fee);
		 Fee__c fee2 = new Fee__c(Account_for__c=a.id,Name = 'Freights', Fee_Category__c = 'Sea Freights', Max_Kgs__c=200, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route.id, Carrier_Account__c=a2.id, Valid_Until__c = system.today().AddDays(5));
		 NEU_CurrencyUtils.setCurrencyISOCode(fee2,'MXN');
		 service_rates.add(fee2);
		 Fee__c fee3 = new Fee__c(Account_for__c=a.id,Name = 'Freights', Fee_Category__c = 'Sea Freights', Max_Kgs__c=300, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route2.id, Carrier_Account__c=a2.id,Valid_Until__c = system.today().AddDays(5));
		 NEU_CurrencyUtils.setCurrencyISOCode(fee3,'MXN');
		 service_rates.add(fee3);
		 Fee__c fee4 = new Fee__c(Account_for__c=a.id,Name = 'Freights', Fee_Category__c = 'Other Service Charges', Max_Kgs__c=400, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route2.id, Carrier_Account__c=a2.id, Valid_Until__c = system.today().AddDays(5));
		 NEU_CurrencyUtils.setCurrencyISOCode(fee4,'MXN');
		 service_rates.add(fee4);
		 Fee__c fee5 = new Fee__c(Account_for__c=a.id,Name = 'Freights', Fee_Category__c = 'Other Service Charges', Max_Kgs__c=500, Rate_Type__c = 'Per Kg',Fee_Rate__c=1,Standard_Rate__c  = true, Route__c=route2.id, Carrier_Account__c=a2.id, Valid_Until__c = system.today().AddDays(5));
		 NEU_CurrencyUtils.setCurrencyISOCode(fee5,'MXN');
		 service_rates.add(fee5);
		 //Create Service rates
		 insert service_rates;

		 //Date validFrom = system.today();
		 Date validUntil = system.today().addDays(5);
		 ApexPages.currentPage().getParameters().put('id_af', NEU_Utils.safeString(a.Id));
		 //ApexPages.currentPage().getParameters().put('va_fr', validFrom.format());
		 ApexPages.currentPage().getParameters().put('va_un', validUntil.format());
		 ApexPages.currentPage().getParameters().put('ra_ct', NEU_Utils.safeString('Freights'));
		 ApexPages.currentPage().getParameters().put('rt_nm', NEU_Utils.safeString('Sea Freight'));
		 ApexPages.currentPage().getParameters().put('isoc', NEU_Utils.safeString('MXN'));
		 ApexPages.currentPage().getParameters().put('rt_ty', NEU_Utils.safeString('Per Kg'));
		 ApexPages.currentPage().getParameters().put('id_ca', NEU_Utils.safeString(a2.Id));
		 ApexPages.currentPage().getParameters().put('co_lo', NEU_Utils.safeString(Country.Id));
		 ApexPages.currentPage().getParameters().put('co_dc', NEU_Utils.safeString(Country2.Id));
		 ApexPages.currentPage().getParameters().put('st_ld', NEU_Utils.safeString(localizacion2.Id));
		 ApexPages.currentPage().getParameters().put('st_dc', NEU_Utils.safeString(localizacion.Id));


		 NEU_Freight_Rates_Emails_save_pdf  fre = new NEU_Freight_Rates_Emails_save_pdf ();

		 //Get List Form
		 List<SelectOption> currencies_list = fre.CurrencyIsoCodeOptions;
		 List<SelectOption> rates_list = fre.RateTypeList;
		 List<SelectOption> buyselllist = fre.buyselllist;

		 //fre.filter.Valid_From__c = system.today();
		 fre.filter.Valid_Until__c = system.today().addDays(5);

		 fre.documento_asociado  = fre.documento_asociado;
		 fre.updateFilters();
		 fre.documentName  = 'test document';
		 fre.filter  = fre.filter;
		 fre.querystring  = fre.querystring;



		 List<NEU_Freight_Rates_Emails_save_pdf.customFees_s>feesReportTest = new List<NEU_Freight_Rates_Emails_save_pdf.customFees_s>();
		 feesReportTest = fre.feesReport;

		 if(feesReportTest != null && feesReportTest.size()>0)
		 {
			 for(NEU_Freight_Rates_Emails_save_pdf.customFees_s cfs: feesReportTest)
			 {
				 if (cfs.NameFee.equals('Sea Freights'))
				 {
					 cfs.selectedFee = true;

				 }
				 if (cfs.NameFee.equals('Other Service Charges'))
				 {
					 cfs.selectedFee = true;
				 }
			 }
		 }
		 fre.feesReport = feesReportTest;
		 //fre.SaveSessionFeesReport();

		 //Save Document
		 fre.crear();
     }
     
     static testMethod void NEU_Freight_Rates_Send_Emails() 
     {
     	NEU_StaticVariableHelper.setBoolean1(true);
		 List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
		 Account a = list_accounts[0];
		 //a.Send_Rates__c = true;
		 insert a;
		 Contact contacto = new Contact(AccountId = a.Id, LastName='test contact', Email='oscar@neurored.com');
		 insert contacto;
		 Account sup = list_accounts[1];
		 insert sup;
		 Contact contacto2 = new Contact(AccountId = sup.Id, LastName='test contact 2', Email='oscar2@neurored.com');
		 insert contacto2;
		 Associated_Document__c documentos_asociados = new Associated_Document__c(Name='test associated document', Account__c=a.Id);
		 insert documentos_asociados;

		 ApexPages.currentPage().getParameters().put('document_id', String.valueOf(documentos_asociados.Id));
		 ApexPages.currentPage().getParameters().put('object_select', 'account');
		 ApexPages.currentPage().getParameters().put('object_id', String.valueOf(documentos_asociados.Account__c));


		 NEU_Freight_Rates_Send_Emails sendDocuments = new NEU_Freight_Rates_Send_Emails();

		 Customer_Quote__c buscador = new Customer_Quote__c();
		 buscador.Account_for__c = a.Id;

		 sendDocuments.buscador = buscador;


		 sendDocuments.load_documents();

		 List<NEU_Freight_Rates_Send_Emails.documents_s> associated_documents_new = new List<NEU_Freight_Rates_Send_Emails.documents_s>();
		 associated_documents_new.add(new NEU_Freight_Rates_Send_Emails.documents_s(true, 'pdf.pdf','pdf', 'reference', 'description', '/servlet/servlet.ImageServer?id='+documentos_asociados.Id+'&oid=' + UserInfo.getOrganizationId(), documentos_asociados.Id, 0,'10'));
		 sendDocuments.associated_documents = associated_documents_new;

		 sendDocuments.addAccountLista();

		 List<SelectOption>filterGroupEmailList = sendDocuments.filterGroupEmailList;

		 sendDocuments.put_template();

		 sendDocuments.defaultTo = 'testneurored1@yopmail.com;testneurored2@yopmail.com';
		 sendDocuments.getuserid();

		 for(NEU_Freight_Rates_Send_Emails.cuenta_s cs: sendDocuments.clientes_seleccionados)
			 {
				 for(NEU_Freight_Rates_Send_Emails.contacto_s cc: cs.contactos)
					 {
						 cc.selected = true;
					 }
			 }
		 sendDocuments.send_email();
		 sendDocuments.return_page();
     	
     }
     
    static testMethod void NEU_Freight_Rates_Emails_pdf() {
    	
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id, Only_Warehouse_Service__c = true);
        insert importexportquote;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        insert fee;
    	List<Fee__c> listado_fees = new List<Fee__c>();
        Fee__c fee2 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee2);
        Fee__c fee3 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee3);
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Fee__c fee4 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee4);
        Fee__c fee5 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee5); 
        Fee__c fee6 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee6); 
        Fee__c fee16 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee16); 
        Fee__c fee17 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee17); 
        Fee__c fee18 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee18); 
        Fee__c fee7 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee7); 
        Fee__c fee8 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
         listado_fees.add(fee8);
        Fee__c fee9 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee9);
        Fee__c fee19 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee19);
        Fee__c fee20 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee20);
        Fee__c fee21 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee21);
        Fee__c fee10 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Other Service Charges',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee10);
        Fee__c fee11 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Other Service Charges',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee11);
        Fee__c fee12 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Other Service Charges',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee12);
        Fee__c fee22 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Other Service Charges',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per W/M', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee22);
        Fee__c fee23 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Other Service Charges',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Fixed', Standard_Rate__c = true, Account_for__c = a.Id, Max_Kgs__c=10, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee23);
        Fee__c fee24 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Other Service Charges',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId(), Rate_Type__c='Per Pallet', Standard_Rate__c = true, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee24);
        
        Fee__c fee13 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per Kg', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee13);
        Fee__c fee14 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per TON', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee14);
        Fee__c fee15 = new Fee__c(Name = 'test fees', Fee_Category__c = 'Sea Freights',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId(), Rate_Type__c='Per M3', Standard_Rate__c = true, Fuel__c = 100, Risk__c = 100, Normal__c =10, Volumetric_Factor__c = 1,q200__c=100, q25__c=100, q45__c=100, q50__c=100, q80__c =100, q100__c =100, q125__c = 100, q150__c = 100, q250__c =100, q300__c=100, q500__c =100, q1000__c =100, q1500__c =100, q2000__c=100, q2500__c =100, q3000__c =100, q5000__c =100, q7500__c =100, q10000__c =100, Account_for__c = a.Id, Valid_Until__c = system.today().AddDays(5));
        listado_fees.add(fee15);
        insert listado_fees;


		//Date validFrom = system.today();
		Date validUntil = system.today().addDays(5);
		//ApexPages.currentPage().getParameters().put('va_fr', validFrom.format());
		ApexPages.currentPage().getParameters().put('va_un', validUntil.format());
		ApexPages.currentPage().getParameters().put('id_af', NEU_Utils.safeString(a.Id));

		NEU_Freight_Rates_Emails_save_pdf save =  new NEU_Freight_Rates_Emails_save_pdf();

		List<NEU_Freight_Rates_Emails_save_pdf.customFees_s>feesReportTest = new List<NEU_Freight_Rates_Emails_save_pdf.customFees_s>();
		feesReportTest = save.feesReport;

		if(feesReportTest != null && feesReportTest.size()>0)
		{
			for(NEU_Freight_Rates_Emails_save_pdf.customFees_s cfs: feesReportTest)
			{
				if (cfs.NameFee.equals('Sea Freights'))
				{
					cfs.selectedFee = true;

				}
				if (cfs.NameFee.equals('Other Service Charges'))
				{
					cfs.selectedFee = true;
				}
			}
		}

		save.feesReport = feesReportTest;
		save.SaveSessionFeesReport();
		NEU_Freight_Rates_Emails_pdf fre = new NEU_Freight_Rates_Emails_pdf();//Declare

		ApexPages.currentPage().getParameters().put('rt_ty', NEU_Utils.safeString('Per Container'));
		fre = new NEU_Freight_Rates_Emails_pdf();//Declare
    }
}