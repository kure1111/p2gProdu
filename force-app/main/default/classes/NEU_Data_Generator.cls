public with sharing class NEU_Data_Generator
{
    public static Map<string, string> List_Record_Types = null;
    public static List<Account>getAccounts(String record_type_api_names)
    {
        List<Account> New_Account_List = new List<Account>();
        if(List_Record_Types == null)
        {
            List_Record_Types = new Map<string, string>();
            List<RecordType> query_recordtype = [select Id, Name, DeveloperName from RecordType where IsActive = true and SobjectType ='Account'];
            for(RecordType rt: query_recordtype )
                List_Record_Types.put(rt.DeveloperName, rt.Id);
        }

        List<String> record_type_api = record_type_api_names.split(',');
        integer name_accounts = 0;

        for(String st: record_type_api)
        {
            Account New_Account = new Account();
            New_Account.Name = name_accounts+'' + NEU_Utils.safeString(DateTime.now().getTime());
            New_Account.RecordTypeId = List_Record_Types.get(st);
            //New_Account.RecordTypeId = '0120E0000004MVB';
            New_Account.Business_Area__c = 'Other Services';
            New_Account.Credit_Limit__c = 100;
            New_Account.Status_Account__c = 'Active';
            New_Account.BillingPostalCode = '01001';
            New_Account.NEU_Email__c = 'email'+name_accounts+'@domain.com';
            New_Account.Secret__c = '0000';
            New_Account.Credit_Terms__c = '15 days';
            New_Account.BillingStreet = 'Street';
            New_Account.BillingCity = 'Vitoria-Gasteiz';
            //New_Account.Type = 'Installer';
            //New_Account.Location_Type__c ='Installer';
            New_Account.BillingState = 'Álava';
            New_Account.BillingCountry ='ES';
            //Especific Required Fields for Cosentino
            try
            {
                New_Account.put('BillingCountryCode','ES');
                New_Account.put('BillingStateCode','01');
            }catch(exception e){}

            //New_Account.SAM_ID__c = '222222';
            // New_Account.ShippingCountry = 'United States';
            New_Account_List.add(New_Account);
            name_accounts++;
        }
        return New_Account_List;
    }

    public static List<Customer_Quote__c> getImportExport(Account account, String freight_mode, Integer num)
    {
        List<Customer_Quote__c> New_CustomerQuote_List = new List<Customer_Quote__c>();

        for(Integer i=0; i<num; i++)
        {
            if(freight_mode == 'Air')
            {
                Customer_Quote__c New_CustomerQuote = new Customer_Quote__c();
                New_CustomerQuote.Account_for__c = account.Id;
                New_CustomerQuote.Freight_Mode__c = freight_mode;
                New_CustomerQuote.Service_Mode__c = 'Import';
                New_CustomerQuote.Service_Type__c = 'LCL Cargo';
                New_CustomerQuote.Move_Type__c = 'Door to Door';
                New_CustomerQuote.Origin_Address__c = 'test adrress';
                New_CustomerQuote.Destination_Address__c = 'test address';
                New_CustomerQuote.Max_Deliveries__c = 10;
                New_CustomerQuote.Conversion_Rate_Date__c = system.today();
                New_CustomerQuote.DO_Release_Date__c = system.today();
                New_CustomerQuote.DO_Release_Valid_To__c = system.today().adddays(3);
                New_CustomerQuote.Authorized_Credit__c = true;
                New_CustomerQuote.Quotation_Status__c ='Awaiting costs suppliers';
                New_CustomerQuote.Quotation_Status__c='Quote being prepared';
                New_CustomerQuote.Only_Warehouse_Service__c = true;
                New_CustomerQuote_List.add(New_CustomerQuote);

            }
            else if(freight_mode == 'Sea')
            {
                Customer_Quote__c New_CustomerQuote = new Customer_Quote__c();
                New_CustomerQuote.Account_for__c = account.Id;
                New_CustomerQuote.Freight_Mode__c = freight_mode;
                New_CustomerQuote.Service_Mode__c = 'Import';
                New_CustomerQuote.Service_Type__c='LCL Cargo';
                New_CustomerQuote.Move_Type__c='Door to Door';
                New_CustomerQuote.Origin_Address__c='tst adrress';
                New_CustomerQuote.Destination_Address__c = 'test address';
                New_CustomerQuote.Max_Deliveries__c = 10;
                New_CustomerQuote.Conversion_Rate_Date__c = system.today();
                New_CustomerQuote.DO_Release_Date__c = system.today();
                New_CustomerQuote.DO_Release_Valid_To__c = system.today().adddays(3);
                New_CustomerQuote.Authorized_Credit__c = true;
                New_CustomerQuote.Quotation_Status__c ='Awaiting costs suppliers';
                New_CustomerQuote.Order_in_Progress_Date__c=system.today();
                New_CustomerQuote.Quotation_Status__c='Quote being prepared';
                New_CustomerQuote.Only_Warehouse_Service__c = true;
                New_CustomerQuote_List.add(New_CustomerQuote);
            }
        }
        return New_CustomerQuote_List;
    }

    public static List<Price_List__c> getPriceList(Account account, Product_Family__c family)
    {
        List<Price_List__c> New_PriceList_List = new List<Price_List__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Price_List__c New_PriceList = new Price_List__c();
        New_PriceList.Items_Account_Owner__c = account.Id;
        if(family != null)
            New_PriceList.Family__c = family.Id;
        New_PriceList.Name = 'Test lista';
        New_PriceList.Business_Area__c = 'Auto-Parts';
        New_PriceList_List.add(New_PriceList);
        //}
        return New_PriceList_List;
    }

    public static List<Shipment__c> getShipment(Account account, String freight_mode)
    {
        List<Shipment__c> New_Shipment_List = new List<Shipment__c>();

        if(freight_mode == 'Sea')
        {
            Shipment__c New_Shipment = new Shipment__c();
            New_Shipment.Account_for__c = account.Id;
            New_Shipment.Freight_Mode__c = freight_mode;
            New_Shipment.Service_Mode__c = 'Import';
            New_Shipment.Port_of_Transshipment_3__c = 'test transshipment 3';
            New_Shipment.Port_of_Transshipment_2__c = 'test transshipment 2';
            New_Shipment.Port_of_Transshipment_1__c = 'test transshipment 1';
            New_Shipment.External_Reference_OI__c = '12344';
            New_Shipment.Marketplace_Auction__c = true;
            New_Shipment.Projected_Date_Time__c= system.today();
            New_Shipment.Only_Warehouse_Service__c  = true;
            New_Shipment_List.add(New_Shipment);
        }
        return New_Shipment_List;
    }

    public static List<Shipment_Consolidation_Data__c> getShipmentConsolidation(Shipment__c ship, Customer_Quote__c importexport)
    {
        List<Shipment_Consolidation_Data__c> New_ShipmentConsolidation_List = new List<Shipment_Consolidation_Data__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Shipment_Consolidation_Data__c New_ShipmentConsolidation = new Shipment_Consolidation_Data__c();
        New_ShipmentConsolidation.Name = 'test';
        New_ShipmentConsolidation.Shipment__c = ship.Id;
        if(importexport != null)
            New_ShipmentConsolidation.Import_Export_Quote__c = importexport.Id;
        New_ShipmentConsolidation_List.add(New_ShipmentConsolidation);
        //}
        return New_ShipmentConsolidation_List;
    }

    public static List<Supply_Project__c> getSupplyProject(Account account)
    {
        List<Supply_Project__c> New_SupplyProject_List = new List<Supply_Project__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Supply_Project__c New_SupplyProject = new Supply_Project__c();
        New_SupplyProject.Name = 'project test';
        New_SupplyProject.Customer__c = account.Id;
        New_SupplyProject_List.add(New_SupplyProject);
        //}
        return New_SupplyProject_List;
    }

    public static List<Supplier_Quote__c> getSupplierQuote(Account sup, Supply_Project__c project,
            Supplier_Request_RFP__c supplierequest)
    {
        List<Supplier_Quote__c> New_SupplierQuote_List = new List<Supplier_Quote__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Supplier_Quote__c New_SupplierQuote = new Supplier_Quote__c();
        if(project != null)
            New_SupplierQuote.Supply_Project__c = project.Id;
        New_SupplierQuote.Supplier__c = sup.Id;
        if(supplierequest != null)
            New_SupplierQuote.Supplier_Request_RFP__c = supplierequest.Id;
        New_SupplierQuote.Supplier_Quote_Status__c='Consolidated';
        New_SupplierQuote.Delivery_Date__c = system.today();
        New_SupplierQuote_List.add(New_SupplierQuote);
        //}
        return New_SupplierQuote_List;
    }

    public static List<Supplier_Request_RFP__c> getSupplierRequestRFP(Account sup, Supply_Project__c supplyproject)
    {
        List<Supplier_Request_RFP__c> New_SupplierRequestRFP_List = new List<Supplier_Request_RFP__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Supplier_Request_RFP__c New_SupplierRequestRFP = new Supplier_Request_RFP__c();
        if(supplyproject != null)
            New_SupplierRequestRFP.Supply_Project__c = supplyproject.Id;
        New_SupplierRequestRFP.Supplier__c = sup.Id;
        New_SupplierRequestRFP.Max_Shipment__c = 10;
        New_SupplierRequestRFP.Contract_Duration__c = 10;
        New_SupplierRequestRFP_List.add(New_SupplierRequestRFP);
        //}
        return New_SupplierRequestRFP_List;
    }

    public static List<Associated_Document__c> getAssociatedDocument(Account account, Customer_Quote__c importexport)
    {
        List<Associated_Document__c> New_AssociatedDocument_List = new List<Associated_Document__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Associated_Document__c New_AssociatedDocument = new Associated_Document__c();

        if(importexport != null)
        {
            New_AssociatedDocument.Name = importexport.Name +'%';
            New_AssociatedDocument.Import_Export_Quote__c = importexport.Id;
        }
        else
                New_AssociatedDocument.Name = 'test';
        New_AssociatedDocument.Account__c = account.Id;
        New_AssociatedDocument_List.add(New_AssociatedDocument);
        //}
        return New_AssociatedDocument_List;
    }

    public static List<Shopping_Cart__c> getShopping(Account account)
    {
        List<Shopping_Cart__c> New_Shopping_List = new List<Shopping_Cart__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Shopping_Cart__c New_Shopping = new Shopping_Cart__c();
        New_Shopping.Customer__c = account.Id;
        New_Shopping.Status__c='Close';
        New_Shopping.Authorized_Credit__c=true;
        New_Shopping_List.add(New_Shopping);
        //}
        return New_Shopping_List;
    }

    public static List<Claim__c> getClaim(Account account)
    {
        List<Claim__c> New_Claim_List = new List<Claim__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Claim__c New_Claim = new Claim__c();
        New_Claim.Customer__c = account.Id;
        New_Claim_List.add(New_Claim);
        //}
        return New_Claim_List;
    }

    public static List<Transport_Packaging_Data__c> getTransport(Shipment__c ship)
    {
        List<Transport_Packaging_Data__c> New_Transport_List = new List<Transport_Packaging_Data__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Transport_Packaging_Data__c New_Transport = new Transport_Packaging_Data__c();
        New_Transport.Name='transporpack';
        New_Transport.Shipment__c = ship.Id;
        New_Transport_List.add(New_Transport);
        //}
        return New_Transport_List;
    }

    public static List<Shipment_Disbursement__c> getShipmentDisbursement(Account account)
    {
        List<Shipment_Disbursement__c> New_ShipmentDisbursement_List = new List<Shipment_Disbursement__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Shipment_Disbursement__c New_ShipmentDisbursement = new Shipment_Disbursement__c();
        New_ShipmentDisbursement.Account__c = account.Id;
        New_ShipmentDisbursement_List.add(New_ShipmentDisbursement);
        //}
        return New_ShipmentDisbursement_List;
    }

    public static List<Product_Family__c> getFamilies(Integer num)
    {
        List<Product_Family__c> New_ProductFamily_List = new List<Product_Family__c>();

        for(Integer i=0; i<num; i++)
        {
            Product_Family__c New_ProductFamily = new Product_Family__c();
            New_ProductFamily.Name = 'Test acount';
            New_ProductFamily.Business_Area__c = 'Auto-Parts';
            New_ProductFamily.Ecommerce__c= true;
            New_ProductFamily_List.add(New_ProductFamily);
        }
        return New_ProductFamily_List;
    }


    public static List<Subfamily__c> getSubFamilies(Product_Family__c family)
    {
        List<Subfamily__c> New_SubFamily_List = new List<Subfamily__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Subfamily__c New_SubFamily = new Subfamily__c();
        New_SubFamily.Product_Family__c = family.Id;
        New_SubFamily.Name = 'test subfamily';
        New_SubFamily.E_Commerce__c = true;
        New_SubFamily_List.add(New_SubFamily);
        //}
        return New_SubFamily_List;
    }

    public static List<Sourcing_Item__c> getSourcingItems(Account account, Product_Family__c family, Subfamily__c subfamily)
    {
        List<Sourcing_Item__c> New_SourcingItem_List = new List<Sourcing_Item__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Sourcing_Item__c New_SourcingItem = new Sourcing_Item__c();
        New_SourcingItem.Name = 'Test item';
        if(subfamily != null)
            New_SourcingItem.Subfamily__c = subfamily.Id;
        if(family != null)
            New_SourcingItem.Sourcing_Family__c = family.Id;
        New_SourcingItem.Account_Owner__c = account.Id;
        New_SourcingItem.Weight_Kgs__c = 100;
        New_SourcingItem.Master_Box_Height_cm__c = 1000;
        New_SourcingItem.Master_Box_Length_cm__c = 1000;
        New_SourcingItem.Units_x_Master_Box__c = 10;
        New_SourcingItem.HS_Code_Text__c = '56489';
        New_SourcingItem.E_Commerce__c = true;
        New_SourcingItem.ABC_Classification__c='A';
        New_SourcingItem.RecordTypeId = Schema.SobjectType.Sourcing_Item__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        New_SourcingItem_List.add(New_SourcingItem);
        //}
        return New_SourcingItem_List;
    }

    public static List<Supplier_Quote_Line__c> getSupplierQuoteLine(Supplier_Quote__c supquote, Sourcing_Item__c item,
            Supplier_Request_RFP__c supplierequest)
    {
        List<Supplier_Quote_Line__c> New_SupplierQuoteLine_List = new List<Supplier_Quote_Line__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Supplier_Quote_Line__c New_SupplierQuoteLine = new Supplier_Quote_Line__c();
        New_SupplierQuoteLine.Supplier_Quote__c = supquote.Id;
        New_SupplierQuoteLine.Name = 'test quote line';
        if(item != null)
            New_SupplierQuoteLine.Item__c = item.Id;
        New_SupplierQuoteLine.Quantity__c = 1000;
        New_SupplierQuoteLine.Expense_Amount__c = 10;
        New_SupplierQuoteLine.Price__c = 10;
        New_SupplierQuoteLine.Quantity__c=10;
        New_SupplierQuoteLine.Consolidated__c=false;
        if(supplierequest != null)
            New_SupplierQuoteLine.Supplier_Request_RFP__c = supplierequest.Id;
        New_SupplierQuoteLine_List.add(New_SupplierQuoteLine);
        //}
        return New_SupplierQuoteLine_List;
    }

    public static List<Quote_Item_Line__c> getQuoteItemLine(Customer_Quote__c importexport, Integer num)
    {
        List<Quote_Item_Line__c> New_QuoteItemLine_List = new List<Quote_Item_Line__c>();

        for(Integer i=0; i<num; i++)
        {
            Quote_Item_Line__c New_QuoteItemLine = new Quote_Item_Line__c();
            New_QuoteItemLine.Import_Export_Quote__c = importexport.Id;
            New_QuoteItemLine.Name = 'lineas items';
            New_QuoteItemLine.Units__c = 9000;
            New_QuoteItemLine.Expense_Amount__c = 100;
            New_QuoteItemLine.Total_Shipping_Weight_Kgs__c = 10;
            New_QuoteItemLine.Total_Shipping_Volume_m3__c = 8;
            New_QuoteItemLine.Margin_at_Destination__c = 10;
            New_QuoteItemLine.Customs_Value__c = 1000;
            New_QuoteItemLine.Delivery_Number__c = 1;
            New_QuoteItemLine.Consolidated__c = false;
            New_QuoteItemLine_List.add(New_QuoteItemLine);
        }
        return New_QuoteItemLine_List;
    }

    public static List<Fee__c> getFee(Account account, Integer num)
    {
        List<Fee__c> New_Fee_List = new List<Fee__c>();

        for(Integer i=0; i<num; i++)
        {
            Fee__c New_Fee = new Fee__c();
            New_Fee.Account_for__c = account.Id;
            New_Fee.Name = 'test fees' + NEU_Utils.safeString(DateTime.now().getTime());
            New_Fee.Fee_Category__c = 'Disbursement';
            New_Fee.Rate_Type__c = 'Fixed';
            New_Fee.Valid_Until__c = Date.newInstance(2017,11,11);
            New_Fee.Valid_From__c = Date.newInstance(2017,10,10);
            New_Fee.Buy_Rate__c = 12;
            New_Fee.Fee_Rate__c = 23;
            New_Fee.Active__c = true;
            New_Fee.Standard_Rate__c = true;
            New_Fee.Fuel__c = 100;
            New_Fee.Risk__c = 100;
            New_Fee.Normal__c = 10;
            New_Fee.Volumetric_Factor__c = 1;
            New_Fee.Max_Kgs__c = 10;
            New_Fee.q200__c = 100;
            New_Fee.q25__c = 100;
            New_Fee.q45__c = 100;
            New_Fee.q50__c = 100;
            New_Fee.q80__c = 100;
            New_Fee.q100__c = 100;
            New_Fee.q125__c = 100;
            New_Fee.q150__c = 100;
            New_Fee.q250__c =100;
            New_Fee.q300__c = 100;
            New_Fee.q500__c = 100;
            New_Fee.q1000__c = 100;
            New_Fee.q1500__c = 100;
            New_Fee.q2000__c = 100;
            New_Fee.q2500__c = 100;
            New_Fee.q3000__c = 100;
            New_Fee.q5000__c = 100;
            New_Fee.q7500__c = 100;
            New_Fee.q10000__c = 100;
            New_Fee_List.add(New_Fee);
        }
        return New_Fee_List;
    }

    public static List<Import_Export_Fee_Line__c> getImportExportFeeLine(Fee__c fee, Customer_Quote__c importexport)
    {
        List<Import_Export_Fee_Line__c> New_ImportExportFeeLine_List = new List<Import_Export_Fee_Line__c>();

        /*for(Integer i=0; i<num; i++)
        {*/
        Import_Export_Fee_Line__c New_ImportExportFeeLine = new Import_Export_Fee_Line__c();
        New_ImportExportFeeLine.Import_Export_Quote__c = importexport.Id;
        if(fee != null)
            New_ImportExportFeeLine.Service_Rate_Name__c = fee.Id;
        New_ImportExportFeeLine.Name = 'lineas items';
        New_ImportExportFeeLine.Extension_Service_Name__c = 'test extension fee name';
        New_ImportExportFeeLine.Discount__c = 10;
        New_ImportExportFeeLine.Quote_Buy_Price__c = 10;
        New_ImportExportFeeLine.Quote_Sell_Price__c = 10;
        New_ImportExportFeeLine.Units__c = 10;
        New_ImportExportFeeLine.Concept_1_Sell_Price__c = 10;
        New_ImportExportFeeLine.Concept_2_Sell_Price__c = 10;
        New_ImportExportFeeLine.Concept_3_Sell_Price__c = 10;
        New_ImportExportFeeLine.Concept_4_Sell_Price__c = 10;
        New_ImportExportFeeLine.Concept_5_Sell_Price__c = 10;
        New_ImportExportFeeLine_List.add(New_ImportExportFeeLine);
        //}
        return New_ImportExportFeeLine_List;
    }



}