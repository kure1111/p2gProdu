public with sharing class NEU_MD_GenerateShipment 
{
    public Customer_Quote__c record;
    public String result {get;set;}
    public String errores {get;set;}
    public String id_shipment {get;set;}
    ApexPages.StandardController con;
            
    public NEU_MD_GenerateShipment(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        try { 
        record = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Account_for__c, Vessel_Flight__c, Container_Type__c, Sales_Incoterm__c, Account_Origin_Address__c, Supplier_Account__c, Consignee__c, Consignee_Contact__c, Account_Destination_Address__c, Supplier_Shipper_Contact__c, Supply_Project_Name__c , Route__c, Incoterm_Place__c, Total_Services_Std_Buy_Amount_Number__c, Nature_Merchandise__c, Equipment__c,         Account_for_Record_Type__c, Account_for_Price_List__c, Catalog_Price_List__c, Contact__c, Quote_Export_Company__c, Freight_Mode__c, Service_Mode__c, Service_Type__c,          Move_Type__c, Origin_Address__c, Country_ofLoad__c, State_of_Load__c, Site_of_Load__c, Country_ofDischarge__c, State_of_Discharge__c, Site_of_Discharge__c, Destination_Address__c, Margin_at_Destination_by_Default__c,Origin_Location__Latitude__s,Origin_Location__Longitude__s,Destination_Location__Latitude__s,Destination_Location__Longitude__s from Customer_Quote__c where id = \''+ con.getRecord().id+'\'');
        system.debug('Record: '+ record);
        } catch( Exception ee) { 
            record = new Customer_Quote__c();
        }
        errores = '';
        id_shipment = '';
    }
    
    public Pagereference generate_shipment()
    {
        Integer cont = 1;
        system.debug('Record: '+ record);
        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Margin_at_Destination_by_Default__c = record.Margin_at_Destination_by_Default__c;
        new_shipment.Account_for__c = record.Account_for__c;
        new_shipment.Contact__c = record.Contact__c;
        
        new_shipment.Freight_Mode__c = record.Freight_Mode__c;
        new_shipment.Service_Mode__c = record.Service_Mode__c;
        new_shipment.Service_Type__c = record.Service_Type__c;
        new_shipment.Move_Type__c = record.Move_Type__c;
        new_shipment.Origin_Address__c = record.Origin_Address__c;
        new_shipment.Country_of_Load__c = record.Country_ofLoad__c;
        new_shipment.State_of_Load__c = record.State_of_Load__c;
        new_shipment.Site_of_Load__c = record.Site_of_Load__c;
        new_shipment.Truck_Vessel_Flight__c = record.Vessel_Flight__c; 
        new_shipment.Container_Type__c = record.Container_Type__c;
        new_shipment.Country_of_Discharge__c = record.Country_ofDischarge__c;
        new_shipment.State_of_Discharge__c = record.State_of_Discharge__c;
        new_shipment.Site_of_Discharge__c = record.Site_of_Discharge__c;
        new_shipment.Destination_Address__c = record.Destination_Address__c;
        new_shipment.Supplier_Account__c= record.Supplier_Account__c;
        new_shipment.Shipper_Contact__c = record.Supplier_Shipper_Contact__c;
        new_shipment.Account_Origin_Address__c = record.Account_Origin_Address__c;
        new_shipment.Consignee__c = record.Consignee__c; 
        new_shipment.Consignee_Contact__c = record.Consignee_Contact__c;
        new_shipment.Account_Destination_Address__c = record.Account_Destination_Address__c;
        new_shipment.Nature_Merchandise__c = record.Nature_Merchandise__c;
        new_shipment.Equipment__c = record.Equipment__c;
        new_shipment.Origin_Location__Latitude__s = record.Origin_Location__Latitude__s;
        new_shipment.Origin_Location__Longitude__s = record.Origin_Location__Longitude__s;
        new_shipment.Destination_Location__Latitude__s = record.Destination_Location__Latitude__s;
        new_shipment.Destination_Location__Longitude__s = record.Destination_Location__Longitude__s;
        if(record.Account_for_Price_List__c != null)
            new_shipment.Account_for_Catalog_Price_List__c = record.Account_for_Price_List__c;
        if(record.Catalog_Price_List__c != null)
            new_shipment.Catalog_Price_List__c = record.Catalog_Price_List__c;
          
         if(record.Route__c!= null)
            new_shipment.Route__c = record.Route__c;
        /*if(record.Supply_Project_Name__c != null)
            new_shipment.Supply_Project__c = record.Supply_Project_Name__c;*/
            
        if(record.Sales_Incoterm__c != null)
            new_shipment.Sales_Incoterm__c = record.Sales_Incoterm__c;
        if(record.Incoterm_Place__c != null)
            new_shipment.Incoterm_Place__c = record.Incoterm_Place__c;

         NEU_CurrencyUtils.setCurrencyIsoCode(new_shipment, NEU_CurrencyUtils.getCurrencyIsoCode(record));
        
        List<Shipment_Fee_Line__c> shipment_fee_lines = new List<Shipment_Fee_Line__c>();
                        
        List<Import_Export_Fee_Line__c> quote_line = [select Id, Name, Discount__c,  Extension_Service_Name__c, Concept_1_Sell_Price__c, Concept_2_Sell_Price__c, Concept_3_Sell_Price__c, Concept_4_Sell_Price__c, Concept_5_Sell_Price__c, Service_Rate_Name__c, Quote_Buy_Price__c, Quote_Sell_Price__c, Units__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =: record.Id];
    
        
        List<Quote_Item_Line__c> quote_line_items = [select Id, Name, Import_Export_Quote__c, Additional_Import_Taxes_Detail__c, Category__c, 
        Customs_Value__c, Duty__c, Extension_Item_Name__c, Family__c, Incoterm__c, Item_Name__c,
        Product_Item_DC__c, Sales_Tax__c, Subcategory_DC__c, Subfamily__c, Additional_Import_Taxes_Amount__c, Total_Shipping_Weight_Kgs__c,
        Total_Taxes_Form__c, Total_Shipping_Volume_m3__c, Percent_Taxes__c, Percent_Duty__c,  Units__c, Amount__c  from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id];
        
        if(quote_line_items.size()==0)
        {
            errores += 'No Quote Item Lines';
            return null;
        }
        
            if(quote_line.size()==0)
        {
                errores += 'No Quote Fee Lines';
                return null;
        }
                            
        try
        {
            insert new_shipment;
            id_shipment = new_shipment.Id;
            
            
            
            for(Import_Export_Fee_Line__c ql : quote_line)
            {
                Shipment_Fee_Line__c new_shipment_fee_line = new Shipment_Fee_Line__c();
                if(String.valueof(cont).length() < 2)
                    new_shipment_fee_line.Name = '00'+cont;
                else
                {
                    if(String.valueof(cont).length() < 3)
                        new_shipment_fee_line.Name = '0'+cont; 
                }
                new_shipment_fee_line.Import_Export_Quote__c = record.Id;
                new_shipment_fee_line.Discount_Charge__c = ql.Discount__c;
                new_shipment_fee_line.Extension_Service_Name__c = ql.Extension_Service_Name__c;
                new_shipment_fee_line.Service_Rate_Name__c = ql.Service_Rate_Name__c;
                new_shipment_fee_line.Shipment__c = new_shipment.Id;
                if(ql.Concept_1_Sell_Price__c != null)
                    new_shipment_fee_line.Concept_1_Sell_Price__c = ql.Concept_1_Sell_Price__c;
                if(ql.Concept_2_Sell_Price__c != null)
                    new_shipment_fee_line.Concept_2_Sell_Price__c = ql.Concept_2_Sell_Price__c;
                if(ql.Concept_3_Sell_Price__c != null)
                    new_shipment_fee_line.Concept_3_Sell_Price__c = ql.Concept_3_Sell_Price__c;
                if(ql.Concept_4_Sell_Price__c != null)
                    new_shipment_fee_line.Concept_4_Sell_Price__c = ql.Concept_4_Sell_Price__c;
                if(ql.Concept_5_Sell_Price__c != null)
                    new_shipment_fee_line.Concept_5_Sell_Price__c = ql.Concept_5_Sell_Price__c;
                new_shipment_fee_line.Shipment_Buy_Price__c = ql.Quote_Buy_Price__c;
                new_shipment_fee_line.Shipment_Sell_Price__c = ql.Quote_Sell_Price__c;
                new_shipment_fee_line.Units__c = ql.Units__c;
                
                if(!test.isRunningTest()){NEU_CurrencyUtils.setCurrencyIsoCode(new_shipment_fee_line,NEU_CurrencyUtils.getCurrencyIsoCode(ql));} 
                   
                shipment_fee_lines.add(new_shipment_fee_line);
                cont++;
            }
            
            insert shipment_fee_lines;
            cont=0;
            String Name_line='';
            Decimal TotalUnitsShipped = 0;
            Decimal TotalProductValueShipped = 0;
            
                        
            
            Shipment_Consolidation_Data__c new_shipment_consolidation_data = new Shipment_Consolidation_Data__c();
            if(record.Account_for_Record_Type__c =='Customer')
                new_shipment_consolidation_data.Customer_Buyer__c = record.Account_for__c;
            else
                new_shipment_consolidation_data.Supplier__c = record.Account_for__c;
            new_shipment_consolidation_data.Import_Export_Quote__c = record.Id;
            new_shipment_consolidation_data.Shipment__c = new_shipment.Id;
            new_shipment_consolidation_data.Name='001';
            NEU_CurrencyUtils.setCurrencyIsoCode(new_shipment_consolidation_data,NEU_CurrencyUtils.getCurrencyIsoCode(record));

            insert new_shipment_consolidation_data;
                
            List<Shipment_Line__c> shipment_items_lines = new List<Shipment_Line__c>();

            NEU_CurrencyUtils cutils=new NEU_CurrencyUtils();
            for(Quote_Item_Line__c ql : quote_line_items)
            {
                
                Shipment_Line__c new_shipment_line = new Shipment_Line__c();
                cont ++;
                Name_line=String.valueOf(cont);
                while(Name_line.Length()<3)
                    Name_line='0'+Name_line;
                new_shipment_line.Name=Name_line;
                new_shipment_line.Additional_Import_Taxes_Detail__c = ql.Additional_Import_Taxes_Detail__c;
                new_shipment_line.Category_DC__c = ql.Category__c;
                new_shipment_line.Customs_Value__c = ql.Customs_Value__c;
                new_shipment_line.Duty__c = ql.Duty__c;
                new_shipment_line.Extension_Item_Name__c = ql.Extension_Item_Name__c;
                new_shipment_line.Family__c = ql.Family__c;
                new_shipment_line.Import_Export_Quote__c = ql.Import_Export_Quote__c;
                new_shipment_line.Customs_Incoterm__c = ql.Incoterm__c;
                new_shipment_line.Item_Name__c = ql.Item_Name__c;
                new_shipment_line.Product_Item_DC__c = ql.Product_Item_DC__c;
                new_shipment_line.Quote_Item_Line__c = ql.Id;
                new_shipment_line.Sales_Tax__c = ql.Sales_Tax__c;
                new_shipment_line.Shipment__c = new_shipment.Id;
                new_shipment_line.Additional_Import_Taxes_Amount__c = ql.Additional_Import_Taxes_Amount__c;
                new_shipment_line.Percent_Taxes__c = ql.Percent_Taxes__c;
                new_shipment_line.Percent_Duty__c = ql.Percent_Duty__c;
                new_shipment_line.Shipment_Consolidation_Data__c = new_shipment_consolidation_data.Id;
                new_shipment_line.Subcategory_DC__c = ql.Subcategory_DC__c;
                new_shipment_line.Subfamily__c = ql.Subfamily__c;
                new_shipment_line.Shipping_Volume_m3__c = ql.Total_Shipping_Volume_m3__c;
                new_shipment_line.Shipping_Weight_Kg__c = ql.Total_Shipping_Weight_Kgs__c;
                //new_shipment_line.Total_Taxes__c = ql.Total_Taxes_Form__c;
                if(!test.isRunningTest()){NEU_CurrencyUtils.setCurrencyIsoCode(new_shipment_line,NEU_CurrencyUtils.getCurrencyIsoCode(ql));}
                if(!test.isRunningTest()){TotalUnitsShipped += ql.Units__c;}
                if(!test.isRunningTest()){TotalProductValueShipped += cutils.changeCurrency(ql.Amount__c, NEU_CurrencyUtils.getCurrencyIsoCode(ql) ,NEU_CurrencyUtils.getCurrencyIsoCode(record));}
                shipment_items_lines.add(new_shipment_line);
            }
            
            
            insert shipment_items_lines;
            
            
            new_shipment_consolidation_data.Total_Product_Value_Shipped__c =TotalProductValueShipped;
            new_shipment_consolidation_data.Total_Units_Shipped__c =TotalUnitsShipped;
            //update shipment;
            update new_shipment_consolidation_data;
            
            record.Quotation_Status__c = 'Shipped';
            update record;
            return null;
       
        }
        catch(Exception ex)
        {
            errores += 'error';
            result = ''+ex;
            system.debug('Error: '+ result);
            return null;
        }
    }
}