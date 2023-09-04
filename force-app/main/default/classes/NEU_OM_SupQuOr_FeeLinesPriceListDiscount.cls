public with sharing class NEU_OM_SupQuOr_FeeLinesPriceListDiscount {

    public Supplier_Quote__c record=null;
    public Boolean chekeados{get;set;}
    
    private List<Supplier_Quote_Order_Fee_Line__c> sup_quote_order_feeLines =null;
    public Supplier_Quote__c supplier_quote_filter_filter = null;
    public Boolean editPriceList{get;set;}
    public  List<Supplier_QuoteOrder_Fee_Line_s> Fee_List_Price = null;
    
    public String nombre_route {get;set;}
    public String lista_routes {get;set;}
    
    public String id_oi {get;set;}
    
    private List<SelectOption> newcategories=null;
    public  List<SelectOption> getnewcategories()
    {
        if(newcategories==null)
        {
            mynewcategory=null;
            newcategories=new List<SelectOption>();
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Fee__c.Fee_Category__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                newcategories.add(new SelectOption(f.getValue(),f.getValue()));       
                 if(String.IsEmpty(mynewcategory)&&Apexpages.currentPage().getParameters().get('pes') ==null)
                    mynewcategory=f.getValue();
                else
                    if(Apexpages.currentPage().getParameters().get('pes') !=null)
                        if(f.getValue() == Apexpages.currentPage().getParameters().get('pes'))
                             mynewcategory=f.getValue();
            }
        }
        return newcategories;
    }
    private String mynewcategory=null;
    public String getnewcategory()
    {
        if(mynewcategory==null)
            getnewcategories();
        return mynewcategory;
    }
    public void setnewcategory(String value)
    {
        if(mynewcategory!=value)
        {
            mynewcategory=value;
            categories();
        }
    }
    
    public Supplier_Quote__c getsupplier_quote_filter_filter()
    {
      
      return supplier_quote_filter_filter;
    }
    
    public void setsupplier_quote_filter_filter(Supplier_Quote__c value)
    {
        if(supplier_quote_filter_filter !=value && value != null)
        {
            supplier_quote_filter_filter=value;
        }
    }
    
    private String recordtype=null;
    public String getrecordtype()
    {
      if(recordtype==null)
      {
        List<Supplier_Quote_Order_Fee_Line__c> fees=getsup_quote_order_feeLines();
        if(fees.size()>0)
          if(fees[0].Fee_Name__r.RecordTypeId!=null)
            recordtype=Schema.SObjectType.Fee__c.getRecordTypeInfosById().get(fees[0].Fee_Name__r.RecordTypeId).getName();
      }
      if(recordtype==null)
      {
        List<Supplier_QuoteOrder_Fee_Line_s> fees=getFee_List_Price();
        if(fees.size()>0)
          if(fees[0].line.RecordTypeId!=null)
            recordtype=Schema.SObjectType.Fee__c.getRecordTypeInfosById().get(fees[0].line.RecordTypeId).getName();
      }
      return recordtype;
    }
    public void setrecordtype(String val){}
    
        public NEU_OM_SupQuOr_FeeLinesPriceListDiscount(ApexPages.StandardController stdController) {
            editPriceList=true;
            if (!Test.isRunningTest()) {
            stdController.AddFields(new String[]
                {
                    'Id',
                    'Name',
                    'Customer__c',
                    'Customer__r.Business_Area__c',
                    'Place_of_Delivery__c',
                    'Place_of_Receipt__c',
                    'Delivery_Zone__c',
                    'Total_Volume_m3_2__c',
                    'Total_Weight_Kg2__c',
                    'Port_Airport_of_Load__c',
                    'Service_Charges_Calculated__c',
                    'Taxes_Calculated__c',
                    'Incoterm__c',
                    'Supply_Project__r.Sales_Incoterm__c',
                    'Total_Weight_Kg2__c',
                    'Port_Airport_of_Discharge__c',
                    'Country_ofLoad__c',
                    'Country_ofDischarge__c',
                    'Delivery_Account__c',
                    'Route__r.Name',
                    'Route__c',
                    (UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode' : 'Production_Time_Days__c')
                });
            }
            record=(Supplier_Quote__c)stdController.getRecord();
            lista_routes = '';
            List<Carrier_Line_Load_Point__c> listado_routes = [select Name from Carrier_Line_Load_Point__c];
            for(Carrier_Line_Load_Point__c ca: listado_routes)
                lista_routes +=ca.Name+'_&_';
           if(record.Route__c != null)
                nombre_route = record.Route__r.Name;
                
           if(supplier_quote_filter_filter == null)
           {
              supplier_quote_filter_filter = new Supplier_Quote__c();
              supplier_quote_filter_filter.Route__c = record.Route__c;
              supplier_quote_filter_filter.Customer__c = record.Customer__c;
              supplier_quote_filter_filter.Incoterm__c = record.Incoterm__c;
              supplier_quote_filter_filter.Supply_Project__r = record.Supply_Project__r;//para el sales incoterm
              //supplier_quote_filter_filter.Sales_Incoterm__c = record.Sales_Incoterm__c;
              supplier_quote_filter_filter.Delivery_Zone__c = record.Delivery_Zone__c;
              //supplier_quote_filter_filter.Carrier__c = record.Carrier__c;
           }     

        }
        
        
        public void categories()
        {
             recordtype=null;
             sup_quote_order_feeLines = null;
        }
        
        
         public void all_accounts_filter()
        {
            recordtype=null;
            sup_quote_order_feeLines=null;
            Fee_List_Price = null;
            if(supplier_quote_filter_filter != null)
              supplier_quote_filter_filter.Customer__c = null; 
        }
        
            //Consultar las lineas insertadas
        public List<Supplier_Quote_Order_Fee_Line__c> getsup_quote_order_feeLines()
        {
            
            if(String.isNotEmpty(getnewcategory()))
                sup_quote_order_feeLines = [select Id, Name, Fee_Name__r.Name, Fee_Name__r.Carrier_Account__r.Name, Fee_Name__r.TT_Days__c, Fee_Name__r.Valid_Until__c, Fee_Name__r.Fee__c, Fee_Name__r.RecordTypeId,  Extension_Fee_Name__c, Fee_Name__r.Master_Allocation__c, Fee_Name__r.Sub_Allocation__c, Rate_Type__c, Fee_Rate__c, Units__c, Fee_Name__c, Fee_Name__r.Fee_Category__c, Discount__c, Sell_Amount__c, Supplier_Quote_Order_Buy_Amount__c, Supplier_Quote_Order_Buy_Price__c, Supplier_Quote_Order_Sell_Net_Price__c, Supplier_Quote_Order_Sell_Price__c, Fee_Name__r.Delivery_Zone__c, Fee_Name__r.Port_Airport__c , Fee_Name__r.Account_for__c, Fee_Name__r.Container_Type__c, Fee_Name__r.Pallet_Type__c from Supplier_Quote_Order_Fee_Line__c where Supplier_Quote_Order__c =: record.Id and Fee_Name__r.Fee_Category__c =: getnewcategory() order by Name];
            else
                sup_quote_order_feeLines = [select Id, Name, Fee_Name__r.Name,  Fee_Name__r.Carrier_Account__r.Name, Fee_Name__r.TT_Days__c, Fee_Name__r.Valid_Until__c,  Fee_Name__r.Fee__c, Fee_Name__r.RecordTypeId, Extension_Fee_Name__c, Fee_Name__r.Master_Allocation__c, Fee_Name__r.Sub_Allocation__c, Rate_Type__c, Fee_Rate__c, Units__c, Fee_Name__c, Fee_Name__r.Fee_Category__c, Discount__c, Sell_Amount__c, Supplier_Quote_Order_Buy_Amount__c, Supplier_Quote_Order_Buy_Price__c, Supplier_Quote_Order_Sell_Net_Price__c, Supplier_Quote_Order_Sell_Price__c, Fee_Name__r.Delivery_Zone__c, Fee_Name__r.Port_Airport__c, Fee_Name__r.Account_for__c, Fee_Name__r.Container_Type__c, Fee_Name__r.Pallet_Type__c from Supplier_Quote_Order_Fee_Line__c where Supplier_Quote_Order__c =: record.Id order by Name];
        
            return sup_quote_order_feeLines;
        }
    
        public List<Supplier_QuoteOrder_Fee_Line_s> getFee_List_Price()
        {
                  //lista monedas
                 List<SelectOption> options = new List<SelectOption>(); 
                 integer contador=0;
                 string moneda_usuario ='';
               if(UserInfo.isMultiCurrencyOrganization()== true)
                {
                    /*  Schema.DescribeFieldResult fieldResult = Supplier_Quote__c.CurrencyIsoCode.getDescribe();
                   //  Schema.DescribeFieldResult fieldResult = record.get('CurrencyIsoCode');
                     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                      for( Schema.PicklistEntry f : ple)
                     {
                            if(f.getValue() == record.CurrencyIsoCode)
                            {
                                options.add(new SelectOption(f.getValue(),f.getValue()));
                                break;
                            }
                     }
                     
                     for( Schema.PicklistEntry f : ple)
                     {
                            if(f.getValue() != record.CurrencyIsoCode)
                            options.add(new SelectOption(f.getValue(),f.getValue())); 
                     } */
                     for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                     {
                         if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
                        {
                            options.add(new SelectOption(lu,lu));
                            break;
                        }
                     }
                     
                     for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                     {
                        if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
                            options.add(new SelectOption(lu,lu));
                     }
                }
                else
                    options.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));
             //---------------- 
    
                Fee_List_Price=new List<Supplier_QuoteOrder_Fee_Line_s>();
                List<Fee__c> lista_fee =new List<Fee__c>();
                
                if(String.IsNotEmpty(getnewcategory()))//
                    lista_fee = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Valid_Until__c, Container_Type__c,  Container_Type__r.Cargo_Volume_m3__c, Container_Type__r.Cargo_Weight_Kg__c, Pallet_Type__c,  Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c, Account_for__r.Name,Carrier_Account__c, Port_Airport__r.Name, Delivery_Zone__c, TT_Days__c, RecordTypeId, Route__c, Port_Airport__c, Fee__c, Fee_Category__c, Rate_Type__c, Fee_Rate__c, Buy_Rate__c, Carrier_Account__r.Name, Applicable_to_Purchase_Incoterms__c, Applicable_to_Sales_Incoterms__c, Account_for__c  from Fee__c where Fee_Category__c = \''+  getnewcategory()+'\'   and Active__c = true order by Rate_Type__c, Buy_Rate__c asc');
                else
                    lista_fee = Database.query('select Id, Name, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Valid_Until__c, Container_Type__c,  Container_Type__r.Cargo_Volume_m3__c, Container_Type__r.Cargo_Weight_Kg__c, Pallet_Type__c,  Pallet_Type__r.Cargo_Volume_m3__c, Pallet_Type__r.Cargo_Weight_Kg__c, Account_for__r.Name,Carrier_Account__c, Port_Airport__r.Name, Delivery_Zone__c, TT_Days__c, RecordTypeId, Route__c, Port_Airport__c, Fee__c, Fee_Category__c, Rate_Type__c, Fee_Rate__c, Buy_Rate__c, Carrier_Account__r.Name, Applicable_to_Purchase_Incoterms__c, Applicable_to_Sales_Incoterms__c, Account_for__c from Fee__c where Active__c = true order by Rate_Type__c, Buy_Rate__c asc');
               
                boolean insertar = true;
                 decimal unidades_calculadas = 1;
                 decimal unidades_calculadas2 = 1;
                for(Fee__c lp: lista_fee)
                {
                    if(insertar|| ApexPages.currentPage().getParameters().get('test') != null)
                    {
                        if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId())
                        {
                        
                             if((record.Place_of_Delivery__c != null || record.Place_of_Receipt__c != null || string.isnotEmpty(record.Port_Airport_of_Load__c) || string.isnotEmpty(record.Port_Airport_of_Discharge__c) ) 
                              && (lp.Port_Airport__c != null && record.Place_of_Delivery__c != lp.Port_Airport__c && record.Place_of_Receipt__c != lp.Port_Airport__c 
                              && record.Port_Airport_of_Load__c != lp.Port_Airport__r.Name && record.Port_Airport_of_Discharge__c != lp.Port_Airport__r.Name))  
                                continue;
                                
                            if(record.Delivery_Zone__c != null && record.Delivery_Zone__c != lp.Delivery_Zone__c && lp.Delivery_Zone__c != null)
                                continue;
                                
                            //if(record.Delivery_Account__c != null && record.Delivery_Account__c != lp.Account_for__c && lp.Account_for__c != null)
                              //  continue;
                            
                            if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                if(record.Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(record.Incoterm__c))
                                   continue;
                              
                              if(lp.Applicable_to_Sales_Incoterms__c != null)
                                 if(record.Supply_Project__r.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(record.Supply_Project__r.Sales_Incoterm__c))
                                    continue;
                            
                                if(lp.Rate_Type__c == 'Per Kg')
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                                if(lp.Rate_Type__c == 'Per TON')
                                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                                if(lp.Rate_Type__c == 'Per M3')
                                     unidades_calculadas = (record.Total_Volume_m3_2__c>0 ? record.Total_Volume_m3_2__c: 1); 
                                if(lp.Rate_Type__c == 'Per Container')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                   if(unidades_calculadas2 > unidades_calculadas)
                                       unidades_calculadas = unidades_calculadas2; 
                                   
                                }  
                                if(lp.Rate_Type__c == 'Per Pallet')
                                {
                                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                   if(unidades_calculadas2 > unidades_calculadas)
                                       unidades_calculadas = unidades_calculadas2; 
                                   
                                }  
                                    
                               // unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                                unidades_calculadas = unidades_calculadas.setScale(2);
                                Decimal buyrate=(lp.Buy_rate__c==null)?lp.Fee_Rate__c:lp.Buy_rate__c;
                                Decimal sellrate=(lp.Fee_rate__c==null)?lp.Buy_Rate__c:lp.Fee_rate__c;
                                
                                Supplier_Quote_Order_Fee_Line__c sqo_fee_line = new Supplier_Quote_Order_Fee_Line__c();
                                sqo_fee_line.Units__c = unidades_calculadas;
                                sqo_fee_line.Supplier_Quote_Order_Sell_Price__c = sellrate;
                                sqo_fee_line.Discount__c = 0;
                                sqo_fee_line.Supplier_Quote_Order_Buy_Price__c = buyrate;
                                
                            Fee_List_Price.add(new Supplier_QuoteOrder_Fee_Line_s(sqo_fee_line,lp,false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate),options, NEU_CurrencyUtils.getCurrencyIsoCode(lp)));//lp.CurrencyIsoCode)
                            
                        }
                        else
                        {
                            if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                            {
                                if(record.Route__c == null || lp.Route__c == null || record.Route__c == lp.Route__c)
                                {
                                   if(supplier_quote_filter_filter.Customer__c == lp.Account_for__c || supplier_quote_filter_filter.Customer__c == null)
                                  {
                                        if(lp.Applicable_to_Purchase_Incoterms__c != null)
                                            if(record.Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(record.Incoterm__c))
                                               continue;
                                      
                                        if(lp.Applicable_to_Sales_Incoterms__c != null)
                                             if(record.Supply_Project__r.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(record.Supply_Project__r.Sales_Incoterm__c))
                                                continue;
                                        
                                        if(lp.Rate_Type__c == 'Per Kg')
                                            unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                                        if(lp.Rate_Type__c == 'Per TON')
                                            unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                                        if(lp.Rate_Type__c == 'Per M3')
                                             unidades_calculadas = (record.Total_Volume_m3_2__c>0 ? record.Total_Volume_m3_2__c: 1); 
                                        if(lp.Rate_Type__c == 'Per Container')
                                        {
                                            unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                                            unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                                           if(unidades_calculadas2 > unidades_calculadas)
                                               unidades_calculadas = unidades_calculadas2; 
                                           
                                        }    
                                        if(lp.Rate_Type__c == 'Per Pallet')
                                        {
                                            unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                                            unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                                           if(unidades_calculadas2 > unidades_calculadas)
                                               unidades_calculadas = unidades_calculadas2; 
                                           
                                        }    
                                       // unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                                        unidades_calculadas = unidades_calculadas.setScale(2);
                                        Decimal buyrate=(lp.Buy_rate__c==null)?lp.Fee_Rate__c:lp.Buy_rate__c;
                                        Decimal sellrate=(lp.Fee_rate__c==null)?lp.Buy_Rate__c:lp.Fee_rate__c;
                                        
                                        
                                        Supplier_Quote_Order_Fee_Line__c sqo_fee_line = new Supplier_Quote_Order_Fee_Line__c();
                                        sqo_fee_line.Units__c = unidades_calculadas;
                                        sqo_fee_line.Supplier_Quote_Order_Sell_Price__c = sellrate;
                                        sqo_fee_line.Discount__c = 0;
                                        sqo_fee_line.Supplier_Quote_Order_Buy_Price__c = buyrate;
                                    
                                        Fee_List_Price.add(new Supplier_QuoteOrder_Fee_Line_s(sqo_fee_line, lp,false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate),options,NEU_CurrencyUtils.getCurrencyIsoCode(lp)));//lp.CurrencyIsoCode)
                                    }
                                }
                            }
                             else
                             {
                                 if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId())
                                 { 
                                    if(supplier_quote_filter_filter.Customer__c == lp.Account_for__c || supplier_quote_filter_filter.Customer__c == null)
                                    {
	                                    if(lp.Applicable_to_Purchase_Incoterms__c != null)
	                                        if(record.Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(record.Incoterm__c))
	                                           continue;
	                              
	                                    if(lp.Applicable_to_Sales_Incoterms__c != null)
	                                         if(record.Supply_Project__r.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(record.Supply_Project__r.Sales_Incoterm__c))
	                                            continue;
	                                    
	                                     if(lp.Rate_Type__c == 'Per Kg')
	                                        unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
	                                    if(lp.Rate_Type__c == 'Per TON')
	                                        unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
	                                    if(lp.Rate_Type__c == 'Per M3')
	                                         unidades_calculadas = (record.Total_Volume_m3_2__c>0 ? record.Total_Volume_m3_2__c: 1); 
	                                    if(lp.Rate_Type__c == 'Per Container')
	                                    {
	                                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
	                                        unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
	                                       if(unidades_calculadas2 > unidades_calculadas)
	                                           unidades_calculadas = unidades_calculadas2; 
	                                       
	                                    }     
	                                    if(lp.Rate_Type__c == 'Per Pallet')
	                                    {
	                                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
	                                        unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
	                                       if(unidades_calculadas2 > unidades_calculadas)
	                                           unidades_calculadas = unidades_calculadas2; 
	                                       
	                                    }     
	                                    //unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
	                                     unidades_calculadas = unidades_calculadas.setScale(2);
	                                    Decimal buyrate=(lp.Buy_rate__c==null)?lp.Fee_Rate__c:lp.Buy_rate__c;
	                                    Decimal sellrate=(lp.Fee_rate__c==null)?lp.Buy_Rate__c:lp.Fee_rate__c;
	                                    
	                                    Supplier_Quote_Order_Fee_Line__c sqo_fee_line = new Supplier_Quote_Order_Fee_Line__c();
	                                    sqo_fee_line.Units__c = unidades_calculadas;
	                                    sqo_fee_line.Supplier_Quote_Order_Sell_Price__c = sellrate;
	                                    sqo_fee_line.Discount__c = 0;
	                                    sqo_fee_line.Supplier_Quote_Order_Buy_Price__c = buyrate;
	                                    
	                                     Fee_List_Price.add(new Supplier_QuoteOrder_Fee_Line_s(sqo_fee_line, lp,false, '', string.valueof(unidades_calculadas), string.valueof(sellrate), '0', string.valueof(buyrate),options,NEU_CurrencyUtils.getCurrencyIsoCode(lp)));//lp.CurrencyIsoCode)
	                                 	
                                 	}
                                 }
                             }
                        }
                             unidades_calculadas2 = 1;
                             unidades_calculadas = 1;
                        //  Family_Item_List_Price.add(new Supplier_QuoteOrder_Fee_Line_s(lp,false, '', '1', (lp.List_Rate__c != null ? string.valueof(lp.List_Rate__c) : string.valueof(lp.Fee_Name__r.Fee_Rate__c)), '0', (lp.List_Rate__c != null ? string.valueof(lp.List_Rate__c) : string.valueof(lp.Fee_Name__r.Fee_Rate__c)),options,'' ));//(lp.List_Rate__c > 0 ? lp.CurrencyIsoCode : lp.Fee_Name__r.CurrencyIsoCode)
                   //-------------------------------
                    }
                    insertar = true;
                }
                return Fee_List_Price;
    
        }
        
        //clase nuevo objeto
        public class Supplier_QuoteOrder_Fee_Line_s
        {
            public Fee__c line {get; set;}
            public Supplier_Quote_Order_Fee_Line__c sqo_fee_line {get; set;}
            public boolean selected {get; set;}
            public String extensionfeename {get; set;}
            public String units {get; set;}
            public String sellprice {get; set;}
            public String discount {get; set;}
            public String buyprice {get; set;}
            public List<SelectOption> currencys {get; set;}
            public String currency_user {get; set;}
            
            public Supplier_QuoteOrder_Fee_Line_s(Supplier_Quote_Order_Fee_Line__c sqo_fee_line, Fee__c line,boolean selected, String extensionfeename, String units, String sellprice, String discount, String buyprice, List<SelectOption> currencys, String currency_user)
            {
                this.sqo_fee_line=sqo_fee_line;
                this.line=line;
                this.selected=selected;
                this.extensionfeename=extensionfeename;
                this.units=units;
                this.sellprice=sellprice;
                this.discount=discount;
                this.buyprice=buyprice;
                this.currencys = currencys;
                this.currency_user = currency_user;
            }
            
        }   
    
        //Consultar las insertadas nuevo objet    
        public void crearlineaquoteitem()
        {   
            if(Fee_List_Price != null)
            {
                List<Supplier_Quote_Order_Fee_Line__c>  Ship_fee = [select Id, Name, Supplier_Quote_Order__c from Supplier_Quote_Order_Fee_Line__c where Supplier_Quote_Order__c =: record.Id  order by Name];
                    
                integer contadordelineas = 0;
                contadordelineas =Ship_fee.size();

                for (Supplier_QuoteOrder_Fee_Line_s lines:Fee_List_Price)
                {
                    
                    if(lines.selected)
                    {
                        chekeados=true;
                        contadordelineas ++;
                        Supplier_Quote_Order_Fee_Line__c myLine= new Supplier_Quote_Order_Fee_Line__c();
                        myline.Supplier_Quote_Order__c=record.Id;
                        myline.Name = string.valueof(contadordelineas);
                        if(lines.extensionfeename != null)
                            myline.Extension_Fee_Name__c=lines.extensionfeename;
                        myline.Fee_Name__c = lines.line.Id;
                        if(lines.sqo_fee_line != null)
                            myline.Units__c = lines.sqo_fee_line.Units__c;
                        if(lines.sqo_fee_line != null)    
                            myline.Supplier_Quote_Order_Sell_Price__c = lines.sqo_fee_line.Supplier_Quote_Order_Sell_Price__c;
                        if(lines.sqo_fee_line != null)
                            myline.Discount__c = lines.sqo_fee_line.Discount__c;
                        if(lines.sqo_fee_line != null)
                            myline.Supplier_Quote_Order_Buy_Price__c = lines.sqo_fee_line.Supplier_Quote_Order_Buy_Price__c;
                        if(lines.line.Valid_Until__c != null)
                            myline.Valid_Until__c = lines.line.Valid_Until__c;
                        
                        NEU_CurrencyUtils.setCurrencyIsoCode(myLine,lines.currency_user);
                        
                        try
                        {
                            insert myLine;
                
                        }
                        catch(Exception e){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ e));
                        }
                    }
                }
                
                 
               
                if(chekeados)
                {
                    Fee_List_Price=null;
                    try
                    {
                      boolean tiene_modificacion = false;
                      if(record.Route__c == null && supplier_quote_filter_filter.Route__c != null)
                      {
                        record.Route__c = supplier_quote_filter_filter.Route__c;
                        tiene_modificacion = true;
                      }
                      if(record.Customer__c == null && supplier_quote_filter_filter.Customer__c != null)
                      {
                        record.Customer__c = supplier_quote_filter_filter.Customer__c;
                        tiene_modificacion = true;
                      }
                      if(record.Incoterm__c == null && supplier_quote_filter_filter.Incoterm__c != null)
                      {
                        record.Incoterm__c = supplier_quote_filter_filter.Incoterm__c;
                        tiene_modificacion = true;
                      }        
                      if(record.Delivery_Zone__c == null && supplier_quote_filter_filter.Delivery_Zone__c != null)
                      {
                        record.Delivery_Zone__c = supplier_quote_filter_filter.Delivery_Zone__c;
                        tiene_modificacion = true;
                      }
                      /*
                      if(shipment_filter.Carrier__c != null)
                      {
                        record.Carrier__c = shipment_filter.Carrier__c;
                        tiene_modificacion = true;
                      }*/
                      system.debug('update_route_service2'+tiene_modificacion);
                      
                      //if(tiene_modificacion == true)
                     // {
                        record.Service_Charges_Calculated__c = true;
                        update record;
                      //}  
                    }
                    catch(Exception ex)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex));
                    }
                    editPriceList=false;
                }
            }
            
        }
        
      public void delete_fee_select()
      {
          List<Supplier_Quote_Order_Fee_Line__c> lines_del = null;
          lines_del=[select Id,Name, Fee_Name__c from Supplier_Quote_Order_Fee_Line__c where  Id =:id_oi];
          try
          {
            delete lines_del;
            sup_quote_order_feeLines = null;
          } 
         catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex));}
      }
      
    public PageReference return_supplier_quote()
    {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
        
    public void update_route()
    {
    
            try
            {
                boolean tiene_modificacion = false;
                  if(record.Route__c == null && supplier_quote_filter_filter.Route__c != null)
                  {
                    record.Route__c = supplier_quote_filter_filter.Route__c;
                    tiene_modificacion = true;
                  }
                  if(record.Customer__c == null && supplier_quote_filter_filter.Customer__c != null)
                  {
                    record.Customer__c = supplier_quote_filter_filter.Customer__c;
                    tiene_modificacion = true;
                  }
                  if(record.Incoterm__c == null && supplier_quote_filter_filter.Incoterm__c != null)
                  {
                    record.Incoterm__c = supplier_quote_filter_filter.Incoterm__c;
                    tiene_modificacion = true;
                  }        
                  if(record.Delivery_Zone__c == null && supplier_quote_filter_filter.Delivery_Zone__c != null)
                  {
                    record.Delivery_Zone__c = supplier_quote_filter_filter.Delivery_Zone__c;
                    tiene_modificacion = true;
                  }
                  /*
                  if(shipment_filter.Carrier__c != null)
                  {
                    record.Carrier__c = shipment_filter.Carrier__c;
                    tiene_modificacion = true;
                  }*/
                      system.debug('update_route_service'+tiene_modificacion);
                if(tiene_modificacion == true)      
                    update record;
            }
            catch(Exception ex) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex)); }
        
        
        /*String returnUrl = '/apex/NEU_OM_SupQuOr_FeeLinesPriceListDiscount'; 
        PageReference pgReturnPage  = new PageReference(returnUrl);
        pgReturnPage.getParameters().put('id', record.Id);
        pgReturnPage.getParameters().put('pes', getnewcategory());
        pgReturnPage.setRedirect(true);
        return pgReturnPage;*/
 
    }
}