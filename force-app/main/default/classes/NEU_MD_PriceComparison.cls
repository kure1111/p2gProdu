public with sharing class NEU_MD_PriceComparison 
{
    public String string_prueba {get;set;} 
    public String id_oi{get;set;}
    public Integer indice{get;set;}
    public Integer total_de_consultas{get;set;}
    public string errores_duty{get;set;}
    public Integer indice2 {get;set;}
    public Integer indice3 {get;set;}
    public string id_supplier_quote{get;set;}
    public String api_key='a5deae30a6c690c9';
    public Integer contador_de_llamadas {get;set;}
    public List<Supplier_Quote_Line__c> supplier_Item_Line = null;
    public List<Supplier_Quote__c> update_cabeceras_check = null;
    public List<Supplier_Quote_Line__c> supplier_Item_Line_insert = null;
    
    public string id_supplier_quote_update{get;set;}
     
    public Date fecha_de_hoy {get;set;}
    //GRAFICO 1
    public List<Data_1> datos_grafico_1 {get;set;}

    public class Data_1 
    {
        public String SUPPLIER {get;set;}
        public Decimal AMOUNT {get;set;}
        public Data_1(String SUPPLIER, Decimal AMOUNT) 
        {
            this.SUPPLIER = SUPPLIER;
            this.AMOUNT = AMOUNT;
        }
    }
    
    //GRAFICO 2
    public List<Data_2> datos_grafico_2 {get;set;}

    public class Data_2 
    {
        public Decimal AMOUNT {get;set;}
        public String SUPPLIER_NAME {get;set;}
        public String ITEM {get;set;}
        public Data_2(Decimal AMOUNT, String SUPPLIER_NAME, String ITEM) 
        {
            this.AMOUNT = AMOUNT;
            this.SUPPLIER_NAME = SUPPLIER_NAME;
            this.ITEM = ITEM;
        }
    }
    
    public Supply_Project__c record;
    public String suppliers {get;set;}
    public String items {get;set;}
    
    public String sup_list {get;set;}
    public String it_list {get;set;}
    public String url_export_excel {get;set;}
    public String url_export_pdf {get;set;}
    
    public String orden_suppliers {get;set;}
    public String orden_quotes {get;set;}
    public String orden_lines {get;set;}
    
    public String resultado {get;set;}
    
    public List<Supplier_to_Invite__c> suppliers_to_invite {get;set;}
    public List<Supplier_Quote__c> supplier_quotes {get;set;}
    public List<Supplier_Quote_Line__c> supplier_quote_lines {get;set;}
    
    public Decimal total_amount_filter {get;set;}
    public Decimal net_price_filter {get;set;}
    public Decimal target_price_filter {get;set;}
    public String operator_total_amount {get;set;}
    public String operator_net_price {get;set;}
    public String operator_target_price {get;set;}
    public Boolean check_delivery_zone{get;set;}
    public Boolean check_total_amount {get;set;}
    public Boolean check_net_price {get;set;}
    public Boolean check_target_price {get;set;}
    public String select_delivery_zone{get;set;}
    public String delivery_zone_selected{get;set;}
    
   
    public string container_selected{get;set;}
    
    ApexPages.StandardController con;
    
    
    
    
    public NEU_MD_PriceComparison(ApexPages.StandardController stdController) 
    {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name from Supply_Project__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Supply_Project__c();
        }
        fecha_de_hoy = system.today();
        
        total_amount_filter = 0;
        net_price_filter = 0;
        target_price_filter = 0;
        
        string_prueba = 'SUPPLIER1,SUPPLIER2,SUPPLIER3,SUPPLIER4';
        
        List<Container_Type__c> lista_contenedores = new List<Container_Type__c>();
        lista_contenedores = [select Id, Name, Cargo_Volume_m3__c, Cargo_Weight_Kg__c from Container_Type__c order by Name];
    
        container_selected  = '';
   
        for(Container_Type__c cp : lista_contenedores)
        {
                if(cp.Id == 'a2qg0000000PGLI')
                    container_selected +='<option value="'+cp.Cargo_Volume_m3__c+';'+cp.Cargo_Weight_Kg__c+'" selected="selected">'+cp.Name+'</option>_&_';
                else
                   container_selected +='<option value="'+cp.Cargo_Volume_m3__c+';'+cp.Cargo_Weight_Kg__c+'">'+cp.Name+'</option>_&_'; 
        }
        
         List<Supplier_Quote_Order_Fee_Line__c> lista_new_fees = new List<Supplier_Quote_Order_Fee_Line__c>();
         contador_de_llamadas = 0;
         supplier_Item_Line_insert = new List<Supplier_Quote_Line__c>();
         update_cabeceras_check  = new List<Supplier_Quote__c>();
        if(ApexPages.currentPage().getParameters().get('zind') != null)
        {
            indice = integer.valueOf(ApexPages.currentPage().getParameters().get('zind'));
            contador_de_llamadas = 0;
        }
        else
            indice = 0;
        
        if(ApexPages.currentPage().getParameters().get('xind') != null)
        {
            indice2 = integer.valueOf(ApexPages.currentPage().getParameters().get('xind'));
            contador_de_llamadas = 0;
        }
        else
            indice2 = 0;
            
        if(ApexPages.currentPage().getParameters().get('yind') != null)
        {
            indice3 = integer.valueOf(ApexPages.currentPage().getParameters().get('yind'));
            contador_de_llamadas = 0;
        }
        else
            indice3 = 0;
       if(ApexPages.currentPage().getParameters().get('squo') != null)
       {
            id_supplier_quote=ApexPages.currentPage().getParameters().get('squo');
            contador_de_llamadas = 0;
       }
        else
            id_supplier_quote='';
       
        if(ApexPages.currentPage().getParameters().get('er') != null)
            errores_duty = ApexPages.currentPage().getParameters().get('er') ;
            
       List<Supplier_Quote__c> listado_supplier_quote = [select Id, Supply_Project__c, 
        Name,
        Customer__c,
        Customer__r.Business_Area__c,
        Place_of_Delivery__c,
        Place_of_Receipt__c,
        Delivery_Zone__c,
        Total_Volume_m3_2__c,
        Total_Weight_Kg2__c,
        Port_Airport_of_Load__c,
        Port_Airport_of_Discharge__c,
        Country_ofLoad__c,
        Country_ofDischarge__c,
        Delivery_Account__c,
        Route__r.Name,
        Route__c from Supplier_Quote__c where Supply_Project__c =: record.id and Supplier_Quote_Status__c != 'Draft'];//
        total_de_consultas = listado_supplier_quote.size();
        //errores_duty = '';
      
    }
    
    public PageReference carga_filtros()
    {
        //FILTRO SUPPLIERS
        suppliers = '';
        List<Supplier_to_Invite__c> suppliers_project = [select Id, Name, Account__c, Supply_Project__c from Supplier_to_Invite__c where Supply_Project__c =: record.Id];
        for(Supplier_to_Invite__c sp : suppliers_project)
        {
            suppliers +=    '<input type="button" value="'+sp.Name+'" class="btn filter_button filter_button_sup" name="'+sp.Account__c+'"/>';
        }
        
        //FILTRO ITEMS
        items = '';
        List<Items_to_Supply__c> items_to_supply = [select Id, Name, Sourcing_Item__c, Sourcing_Item__r.Name, Supply_Project__c, Quantity__c from Items_to_Supply__c where Supply_Project__c =: record.Id];
        for(Items_to_Supply__c is : items_to_supply)
        {                                                   //string.escapeSingleQuotes(                                         
            items +=    '<input type="button" value="'+(is.Sourcing_Item__r.Name.contains('\"') ? is.Sourcing_Item__r.Name.replace('\"','´´'):(is.Sourcing_Item__r.Name.contains('\'') ? is.Sourcing_Item__r.Name.replace('\'','´'):is.Sourcing_Item__r.Name ))+' - '+ is.Quantity__c+'" class="btn filter_button filter_button_it" name="'+is.Id+'"/>';
        }
        
        //FILTRO DELIVERY ZONE
        select_delivery_zone = '';
        string comparador_de_deliverys_zone = '';
        List<Supplier_Quote__c> suppliers_quotes_ordes= [select Id, Name, Supply_Project__c , Delivery_Zone__c, Delivery_Zone__r.Name from Supplier_Quote__c where Supply_Project__c =: record.Id and Delivery_Zone__c != null];
         for( Supplier_Quote__c f : suppliers_quotes_ordes)
         {
               if(comparador_de_deliverys_zone.contains(f.Delivery_Zone__c) == false)
                   select_delivery_zone  +=    '<input type="button" value="'+f.Delivery_Zone__r.Name+'" class="btn filter_button filter_button_dz" name="'+f.Delivery_Zone__c+'"/>';
           
           comparador_de_deliverys_zone += f.Delivery_Zone__c;
         }
         
      
        
        return null;
    }
    
    public String decimalSep
   {
       get
       {
         if(decimalSep==null)
           decimalSep=NEU_Utils.getDecimalSep();
         return decimalSep;
       }
       set
       {
         decimalSep=value;
       }
   }
   public String thousandSep
   {
       get
       {
         if(thousandSep==null)
           thousandSep=NEU_Utils.getThousandSep();
         return thousandSep;
       }
       set
       {
         thousandSep=value;
       }
   }
    
    public void update_supplier_quote_approved()
    {
        List<Supplier_Quote__c> lista_supplier_quote = [select Id, Name, Supplier_Quote_Status__c from Supplier_Quote__c where id =:id_supplier_quote_update];
        for(Supplier_Quote__c sq: lista_supplier_quote)
        {
            sq.Supplier_Quote_Status__c = 'Approved';
        }
        if(lista_supplier_quote != null)
            update lista_supplier_quote;
    }
    
    public void go_compare()
    {
        String[] sup = (sup_list != null ? sup_list.replace('[','').replace(']','').split(',',0) : new String[]{});

        String sup_values = '';
        for(String s : sup)
        {
            sup_values += '\''+s+'\''+',';
        }
        
        String[] it = (it_list != null ? it_list.replace('[','').replace(']','').split(',',0) : new String[]{});
        
        String it_values = '';
        for(String i : it)
        {
            it_values += '\''+i+'\''+',';
        }
        
        String[] zd = (delivery_zone_selected!= null ? delivery_zone_selected.replace('[','').replace(']','').split(',',0) : new String[]{});
        
        String zd_values = '';
        for(String i : zd)
        {
            zd_values += '\''+i+'\''+',';
        }
        
        //CONSULTA SUPPLIERS TO INVITE
        String[] ordenacion_suppliers = new String[]{};
        if(orden_suppliers != null)
            ordenacion_suppliers = orden_suppliers.split('-');

        String consulta_suppliers = '';
        consulta_suppliers += 'SELECT Id, Name, Account__c, Account__r.Status_Account__c, Responsible_for_the_Project__r.Name, Account__r.SUM_Destination_Amount_Supplier_Quote__c, Account__r.Quality_Products__c, ';
        consulta_suppliers += 'Account__r.Prices__c, Account__r.Colaboration__c, Account__r.Delivery_Times__c, Account__r.Efficiency_Level__c';     
        consulta_suppliers += ' FROM Supplier_to_Invite__c'; 
        consulta_suppliers += ' WHERE Supply_Project__c = \''+record.Id+'\'';
	
        consulta_suppliers += ' '+(sup_list != '[]' ? 'and Account__c IN :sup' : ''); 
    	consulta_suppliers += (ordenacion_suppliers.size() > 1 ? ' order by '+String.escapeSingleQuotes(ordenacion_suppliers[0]+' '+ordenacion_suppliers[1]) : ' order by Name asc');
         
        List<sObject> query_suppliers = Database.query(consulta_suppliers);
        suppliers_to_invite = query_suppliers;
        //-------------------------------
        
        //CONSULTA SUPPLIER QUOTES
        String[] ordenacion_quotes = new String[]{};
        if(orden_quotes != null)
            ordenacion_quotes = orden_quotes.split('-');

        String op_ta = 'equal';
        if(operator_total_amount == 'equal') op_ta = '=';
        if(operator_total_amount == 'greater_than') op_ta = '>';
        if(operator_total_amount == 'less_than') op_ta = '<';
        if(operator_total_amount == 'greater_or_equal') op_ta = '>=';
        if(operator_total_amount == 'less_or_equal') op_ta = '<=';

        String consulta_quotes = '';
        
        consulta_quotes += 'SELECT Id, Name, Supplier_Quote_Status__c, MIN_Valid_Until__c, Taxes_Calculated__c , Service_Charges_Calculated__c , Total_Amount_Number__c, Supplier__r.Name, SUM_Total_Taxes_Number__c, SUM_Destination_Amount__c, Incoterm__c, Incoterm_Place__c, Production_Time_Days__c, Valid_Until__c, Delivery_Zone__c, Delivery_Zone__r.Name, Total_Amount__c'; 
        consulta_quotes += ' FROM Supplier_Quote__c'; 
        consulta_quotes += ' WHERE Supply_Project__c = \''+record.Id+'\'';
        
        consulta_quotes += ' '+(sup_list != '[]' ? 'and Supplier__c IN :sup' : ''); 
		consulta_quotes += ' and Supplier_Quote_Status__c != \'Not Valid\' and  Supplier_Quote_Status__c != \'Draft\'';
        consulta_quotes += ' '+(check_total_amount == true ? 'and Total_Amount__c '+op_ta+' '+total_amount_filter : ''); 
        consulta_quotes += ' and Number_Active_Lines__c > 0';
         
		consulta_quotes += ' '+(delivery_zone_selected!= '[]' ? 'and Delivery_Zone__c IN :zd' : ''); 
        
        consulta_quotes += (ordenacion_quotes.size() > 1 ? ' order by '+String.escapeSingleQuotes(ordenacion_quotes[0]+' '+ordenacion_quotes[1]) : ' order by Name asc');
         
        List<sObject> query_quotes = Database.query(consulta_quotes);
        supplier_quotes = query_quotes;
        //-------------------------------
        
        //CONSULTA SUPPLIER QUOTE LINES
        String[] ordenacion_lines = new String[]{};
        if(orden_lines != null)
            ordenacion_lines = orden_lines.split('-');
        
        String op_np = 'equal';
        if(operator_net_price == 'equal') op_np = '=';
        if(operator_net_price == 'greater_than') op_np = '>';
        if(operator_net_price == 'less_than') op_np = '<';
        if(operator_net_price == 'greater_or_equal') op_np = '>=';
        if(operator_net_price == 'less_or_equal') op_np = '<=';
        
        String op_tp = 'equal';
        if(operator_target_price == 'equal') op_tp = '=';
        if(operator_target_price == 'greater_than') op_tp = '>';
        if(operator_target_price == 'less_than') op_tp = '<';
        if(operator_target_price == 'greater_or_equal') op_tp = '>=';
        if(operator_target_price == 'less_or_equal') op_tp = '<=';
        
        String consulta_lines = '';
        consulta_lines += 'SELECT Id, Name, Supplier_Quote__r.Supply_Project__c, Percent_Duty__c, Imp_Exp_Charges_Assigned_Percent__c, Total_Weight_Kg__c , Supplier_Quote__r.Supplier__c, Total_Volume_m3__c , Supplier__c, Item__r.Name, Quantity__c, Supplier_Quote__r.Supplier__r.Name,';  
        consulta_lines += ' Unit_of_measure__c, Net_Price__c,Total_Taxes__c , Supplier_Quote__r.MIN_Valid_Until__c, Supplier_Quote__r.Delivery_Zone__c, Active__c, Number_of_Containers__c,  Total_Amount__c, Production_Time_Days__c , Unit_Origin_Price__c, Total_Destination_Amount__c, Unit_Destination_Price__c, Imp_Exp_Charges_Assigned__c, Net_Amount__c, Expense_Amount__c, Supplier_Quote__r.Name, Item__r.Item_Price__c, Supplier_Quote__r.Supplier_Name__c';        
        consulta_lines += ' FROM Supplier_Quote_Line__c'; 
        consulta_lines += ' WHERE Supplier_Quote__r.Supply_Project__c = \''+record.Id+'\'';
       
		consulta_lines += ' '+(sup_list != '[]' ? 'and Supplier_Quote__r.Supplier__c IN :sup' : ''); 
		consulta_lines += ' '+(it_list != '[]' ? 'and Item_to_Supply__c IN :it' : ''); 
        
        consulta_lines += ' '+(check_net_price == true  ? 'and Net_Price__c '+op_np+' '+net_price_filter : '');
        consulta_lines += ' '+(check_target_price == true  ? 'and Item__r.Item_Price__c '+op_tp+' '+target_price_filter : '');
        consulta_lines += ' '+(delivery_zone_selected!= '[]' ? 'and Supplier_Quote__r.Delivery_Zone__c IN :zd' : '');
        consulta_lines += ' and Supplier_Quote__r.Supplier_Quote_Status__c != \'Not Valid\' and  Supplier_Quote__r.Supplier_Quote_Status__c != \'Draft\'';
        consulta_lines += ' and Active__c = true';
        
    	consulta_lines += (ordenacion_lines.size() > 1 ? ' order by '+String.escapeSingleQuotes(ordenacion_lines[0]+' '+ordenacion_lines[1]) : ' order by Name asc');

        List<sObject> query_lines = Database.query(consulta_lines);
        supplier_quote_lines = query_lines;
        //-------------------------------

        //GRAFICO 1
        List<Data_1> datos_1 = new List<Data_1>();
        
        for(Supplier_Quote__c sq : supplier_quotes)
        {
            datos_1.add(new Data_1(sq.Supplier__r.Name, sq.Total_Amount__c));
        }
        
        datos_grafico_1 = datos_1;
        
        //GRAFICO 2
        List<Data_2> datos_2 = new List<Data_2>();
        
        Decimal Supplier1 = 0;
        Decimal Supplier2 = 0;
        Decimal Supplier3 = 0;
        Decimal Supplier4 = 0;
        
        List<Items_to_Supply__c> items_to_supply = [select Id, Name, Sourcing_Item__c, Sourcing_Item__r.Name, Supply_Project__c from Items_to_Supply__c where Supply_Project__c =: record.Id];
        for(Items_to_Supply__c is : items_to_supply)
        {
            for(Supplier_Quote_Line__c sql : supplier_quote_lines)
            {
                if(is.Sourcing_Item__c == sql.Item__c)
                {
                    datos_2.add(new Data_2(sql.Net_Price__c, sql.Supplier_Quote__r.Supplier__r.Name, is.Sourcing_Item__r.Name));
                }
            }
        }

        datos_grafico_2 = datos_2;
    }
    
    
    
    public PageReference calculate_std_fees()
    {
        List<Supplier_Quote__c> listado_supplier_quote = [select Id, Supply_Project__c, 
        Name,
        Customer__c,
        Customer__r.Business_Area__c,
        Place_of_Delivery__c,
        Place_of_Receipt__c,
        Delivery_Zone__c,
        Total_Volume_m3_2__c,
        Total_Weight_Kg2__c,
        Port_Airport_of_Load__c,
        Port_Airport_of_Discharge__c,
        Country_ofLoad__c,
        Country_ofDischarge__c,
        Delivery_Account__c,
        Service_Charges_Calculated__c,
        Route__r.Name,
        Incoterm__c,
        Supply_Project__r.Sales_Incoterm__c,
        Route__c from Supplier_Quote__c where Supply_Project__c =: record.id and  Supplier_Quote_Status__c != 'Draft'];//
        
        total_de_consultas = listado_supplier_quote.size();
   
        integer contador = 0;
        integer contador_de_llamada = 0;
        
        if(indice <= listado_supplier_quote.size())
            for(Supplier_Quote__c sq: listado_supplier_quote)
            {
                if( contador >= indice)
                {
                    NEU_Standard_Fee_Calculation sfc = new NEU_Standard_Fee_Calculation(sq);
                    sfc.crear_fee_estandar();
                    indice ++ ; 
                    sq.Service_Charges_Calculated__c = true;
                    contador ++;
                    contador_de_llamada ++;
                }
                else
                    contador ++;
                if(contador_de_llamada == 15)
                {
                    
                    update listado_supplier_quote;
                    PageReference pgReturnPage;
                    String returnUrl = '/apex/NEU_MD_PriceComparison?id=' + record.Id;
                    pgReturnPage = new PageReference(returnUrl);
                    if(indice >0)
                        pgReturnPage.getParameters().put('zind', string.valueOf(indice));
                    
                    pgReturnPage.setRedirect(true);
                    return pgReturnPage;
                }
            }
        
        update listado_supplier_quote;
        PageReference pgReturnPage;
        String returnUrl = '/apex/NEU_MD_PriceComparison?id=' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        return pgReturnPage;
    }
        
        
    public PageReference calculate_duty()
    {
        integer contador = 0;
        integer contador_de_llamada = 0;
        //
        List<Supplier_Quote__c> listado_supplier_quote = [select Id, Name, Supply_Project__c, Route__c, Taxes_Calculated__c from Supplier_Quote__c where Supply_Project__c =: record.id and  Supplier_Quote_Status__c != 'Draft' and Supplier_Quote_Status__c != 'Not Valid' and Number_Active_Lines__c > 0];
        if(indice3 <= listado_supplier_quote.size())
            for(Supplier_Quote__c sq: listado_supplier_quote)
            {
                if( contador >= indice3)
                {
                    id_supplier_quote = sq.Id;
                   
                    calcular_tasas();
                    indice3 ++; 
                    contador ++;
                    contador_de_llamada ++;
                }
                else
                    contador ++;
                    
                if(contador_de_llamada == 10)
                {
                    if(supplier_Item_Line_insert != null)
                    {
                        try
                        {
                            update supplier_Item_Line_insert;
                            update update_cabeceras_check; 
                        }
                        catch(Exception ex){}
                    }
                    PageReference pgReturnPage;
                    String returnUrl = '/apex/NEU_MD_PriceComparison?id=' + record.Id;
                    pgReturnPage = new PageReference(returnUrl);
                    if(indice3 >0)
                        pgReturnPage.getParameters().put('yind', string.valueOf(indice3));
                    
                    pgReturnPage.setRedirect(true);
                    return pgReturnPage;
                }
            }
            
            if(supplier_Item_Line_insert != null)
            {
                try
                {
                    update supplier_Item_Line_insert;
                    update update_cabeceras_check;
                }
                catch(Exception ex){}
            }
        
        if(errores_duty != null && errores_duty!= '')
            return null;
        else
        {   
            PageReference pgReturnPage;
            String returnUrl = '/apex/NEU_MD_PriceComparison?id=' + record.Id;
            pgReturnPage = new PageReference(returnUrl);
            return pgReturnPage;
        }
        
    }
    
    
    //-----------------------------------------
    public PageReference calcular_tasas() 
    {
        string url='';
        string body_test2 = '';
        //errores_duty = '';
        
        supplier_Item_Line = new List<Supplier_Quote_Line__c>();
        supplier_Item_Line = [select Id, Name, Price__c, List_Price__c, HS_Code__c , Percent_Duty__c, Percent_Taxes__c, 
        Total_Taxes__c , Imp_Exp_Charges_Assigned__c,  Supplier_Quote__r.Route__c, Supplier_Quote__r.Taxes_Calculated__c, Supplier_Quote__r.Name,
        Supplier_Quote__r.Route__r.Country_of_Load__r.ISO_Code__c, Supplier_Quote__r.Route__r.Country_of_Discharge__r.ISO_Code__c, 
        Product_Item_DC_Value__c, Category_DC_Value__c, Subcategory_DC_Value__c, Sales_Tax__c,Additional_Import_Taxes_Detail__c,
        Duty__c, Customs_Value__c, Customs_Incoterm__c, Item__r.Name, Unit_Origin_Price__c, Item__r.Product_Item__c, Item__r.Subcategory__c, Item__r.Category__c,
        Supplier_Quote__r.Country_ofDischarge__r.ISO_Code__c, Supplier_Quote__r.Country_ofLoad__r.ISO_Code__c,
        Category_DC__c, Subcategory_DC__c, Product_Item_DC__c, Item__c, Item__r.Category_DC_Value__c, 
        Quantity__c, Item__r.Subcategory_DC_Value__c, Item__r.Product_Item_DC_Value__c,
        Item__r.HS_Code_Text__c from Supplier_Quote_Line__c where Supplier_Quote__c =: id_supplier_quote ];//id =: idlineactualizar
        
        decimal valoritems = 0;
     //   integer contador_de_llamadas = 0;
        integer posicion_seguir = 0;
        
        indice2 = 0;
        if(ApexPages.currentPage().getParameters().get('er') != null)
            errores_duty += ApexPages.currentPage().getParameters().get('er') ;
            
        if(ApexPages.currentPage().getParameters().get('xind') != null)
            posicion_seguir = integer.valueOf(ApexPages.currentPage().getParameters().get('xind'));
        else
            posicion_seguir = 0;
        if(supplier_Item_Line.Size()>0)
        {
            
        if(supplier_Item_Line[0].Supplier_Quote__r.Route__c != null)
        {   
            for (Supplier_Quote_Line__c ql: supplier_Item_Line)
            {
                
                if(indice2 >= posicion_seguir)
                {
                    
                    if(ql.Item__r.HS_Code_Text__c != '' && ql.Item__r.HS_Code_Text__c != null)
                    {
                        if(contador_de_llamadas < 10 )
                        {
                           
                            
                            url = '';
                            valoritems = ql.Unit_Origin_Price__c;
                            if(ql.Item__r.Category_DC_Value__c != '' )
                                ql.Category_DC_Value__c = ql.Item__r.Category_DC_Value__c;
                            if(ql.Item__r.Subcategory_DC_Value__c != '')
                                ql.Subcategory_DC_Value__c = ql.Item__r.Subcategory_DC_Value__c;
                            if(ql.Item__r.Product_Item_DC_Value__c != '')
                                ql.Product_Item_DC_Value__c = ql.Item__r.Product_Item_DC_Value__c;
                            
                            if(ql.Item__r.Category__c != '')
                                ql.Category_DC__c = ql.Item__r.Category__c;
                            if(ql.Item__r.Subcategory__c != '')
                                ql.Subcategory_DC__c = ql.Item__r.Subcategory__c;
                            if(ql.Item__r.Product_Item__c != '')
                                ql.Product_Item_DC__c = ql.Item__r.Product_Item__c;    
                            if(ql.Item__r.HS_Code_Text__c !='')
                                ql.HS_Code__c = ql.Item__r.HS_Code_Text__c;    
                            
                            url += 'https://www.dutycalculator.com/api2.1/'+api_key+'/calculation';
                            url += '?from='+ ql.Supplier_Quote__r.Route__r.Country_of_Load__r.ISO_Code__c ;
                            url += '&to='+ql.Supplier_Quote__r.Route__r.Country_of_Discharge__r.ISO_Code__c;
                            url += '&hs[0]='+ql.Item__r.HS_Code_Text__c;
                        //  url += '&country_of_hs_code[0]={ISO  alpha-3 country code or alpha-2 country code} \';
                            url += '&desc[0]='+EncodingUtil.urlEncode(ql.Item__r.Name, 'UTF-8');
                            url += '&value[0]='+valoritems;
                        //  url += '&weight[0]={weight of one item} \';
                            url += '&qty[0]='+ql.Quantity__c;
                            url += '&shipping='+ql.Imp_Exp_Charges_Assigned__c;
                            url += '&insurance=0';
                            url += '&currency='+NEU_CurrencyUtils.getCurrencyIsoCode(ql);
                            //url += '&shipment_wt='+ql.Import_Export_Quote__r.Total_Weight_Kg2__c;
                            url += '&output_currency='+NEU_CurrencyUtils.getCurrencyIsoCode(ql); //NEU_CurrencyUtils.getCurrencyIsoCode(ql.Import_Export_Quote__r);
                            //url += '&preferential_rates={1 to apply FTA and preferential rates, 0 to ignore FTA and preferential rates} \';
                            url += '&classify_by=hs';
                             if(ApexPages.currentPage().getParameters().get('test') != null)
                                    url='http://api.salesforce.com/foo/bar';
                            
                            try
                            {
                                Http h = new Http(); 
                                HttpRequest req = new HttpRequest();
                                
                                req.setEndpoint(url); 
                                req.setMethod('GET');
                                HttpResponse res = new HttpResponse();
                                contador_de_llamadas ++;
                                
                                if (!Test.isRunningTest())
                                    res = h.send(req); 
                                else
                                {
                                    body_test2 ='<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"><soap:Header></soap:Header>';
                                    body_test2 +='<soap:Body>';
                                    body_test2 +='<duty-calculation id="190484994">';
                                    body_test2 +='<item id="3752" hs-code="84295299" reference="3752" quality-score="validated">';
                                    body_test2 +='<customs-value name="CIF">';
                                    body_test2 +='<amount currency="EUR">200000</amount>';
                                    body_test2 +='</customs-value>';
                                    body_test2 +='<duty>';
                                    body_test2 +='<amount currency="EUR">0</amount>';
                                    body_test2 +='</duty>';
                                    body_test2 +='<sales-tax name="VAT">';
                                    body_test2 +='<amount currency="EUR">32256</amount>';
                                    body_test2 +='</sales-tax>';
                                    body_test2 +='<additional-import-taxes>';
                                    body_test2 +='<tax name="DTA">';
                                    body_test2 +='<amount currency="EUR">1600</amount>';
                                    body_test2 +='</tax>';
                                    body_test2 +='<tax name="Pro-rated order-level charges">';
                                    body_test2 +='<amount currency="EUR">1600</amount>';
                                    body_test2 +='</tax>';
                                    body_test2 +='</additional-import-taxes>';
                                    body_test2 +='<total>';
                                    body_test2 +='<amount currency="EUR">33856</amount>';
                                    body_test2 +='</total>';
                                    body_test2 +='</item>';
                                    body_test2 +='<total-charges>';
                                    body_test2 +='<customs-value name="CIF">';
                                    body_test2 +='<amount currency="EUR">200000</amount>';
                                    body_test2 +='</customs-value>';
                                    body_test2 +='<duty>';
                                    body_test2 +='<amount currency="EUR">0</amount>';
                                    body_test2 +='</duty>';
                                    body_test2 +='<sales-tax name="VAT">';
                                    body_test2 +='<amount currency="EUR">32256</amount>';
                                    body_test2 +='</sales-tax>';
                                    body_test2 +='<additional-import-taxes>';
                                    body_test2 +='<tax name="DTA">';
                                    body_test2 +='<amount currency="EUR">1600</amount>';
                                    body_test2 +='</tax>';
                                    body_test2 +='</additional-import-taxes>';
                                    body_test2 +='<total>';
                                    body_test2 +='<amount currency="EUR">33856</amount>';
                                    body_test2 +='</total>';
                                    body_test2 +='</total-charges>';
                                    body_test2 +='</duty-calculation>';
                                    body_test2 +='</soap:Body></soap:Envelope>';
                                }  
                                 
                                Dom.Document doc = new Dom.Document();
                                if (!Test.isRunningTest())
                                     doc = res.getBodyDocument();   
                                else
                                    doc.load(body_test2);   
                                    
                                //Retrieve the root element for this document.
                                Dom.XMLNode Envelope = doc.getRootElement();        
                                Dom.XMLNode Body = Envelope.getChildElements()[0];  
                                //RECOPILACIÓN INFO
                                for(Dom.XMLNode child : Envelope.getChildElements()) 
                                {
                                    for(Dom.XMLNode child2 : child.getChildElements())
                                    { 
                                         if(child2.getName() == 'customs-value')
                                            ql.Customs_Incoterm__c = child2.getAttribute('name','');
                    
                                        for(Dom.XMLNode child3 : child2.getChildElements())
                                        {
                                            if(child2.getName() == 'customs-value')
                                                ql.Customs_Value__c = decimal.valueof(child3.getText());
                                            if(child2.getName() == 'duty')
                                                ql.Duty__c = decimal.valueof(child3.getText());
                                            if(child2.getName() == 'sales-tax')
                                                ql.Sales_Tax__c = decimal.valueof(child3.getText());
                                                
                                             
                                           if(child.getName() == 'total-charges')         
                                            if(child2.getName() == 'additional-import-taxes')
                                            {
                                                ql.Additional_Import_Taxes_Detail__c ='';
                                                ql.Additional_Import_Taxes_Amount__c = 0;   
                                                for(Dom.XMLNode child4 : child3.getChildElements())
                                                {
                                                        if(ql.Additional_Import_Taxes_Detail__c == null)
                                                            ql.Additional_Import_Taxes_Detail__c ='';
                                                        if(child3.getAttribute('name','') != null && child3.getAttribute('name','') !='' && child4.getText() != null && child4.getText() != '')
                                                            ql.Additional_Import_Taxes_Detail__c += '- ' + child3.getAttribute('name','') + ': ' + child4.getText() + '\n\n';
                                                        if(child4.getText() != null && child4.getText() != '' && child4.getText() !='null')
                                                        {
                                                            if(ql.Additional_Import_Taxes_Amount__c == null)
                                                                ql.Additional_Import_Taxes_Amount__c = 0;
                                                                
                                                            ql.Additional_Import_Taxes_Amount__c += decimal.valueof(child4.getText());
                                                        }
                                                    
                                                }
                                            }
                                            
                                        }
                                        
                                        if(ql.Customs_Value__c == null || ql.Customs_Value__c < 0 )
                                              errores_duty +=  (child2.getName() == 'code' ? 'Line'+ ql.Name+' Error'+  child2.getText()+(child2.getName() == 'message'?  child2.getText():''):'');
                                    }
                                }
                                
                                if(ql.Sales_Tax__c >0 && ql.Customs_Value__c >0)
                                    ql.Percent_Taxes__c = ql.Sales_Tax__c/ql.Customs_Value__c*100;
                                else
                                    ql.Percent_Taxes__c = 0;
                                if(ql.Duty__c  >0 && ql.Customs_Value__c >0)
                                     ql.Percent_Duty__c = ql.Duty__c /ql.Customs_Value__c*100;
                                else
                                   ql.Percent_Duty__c =0; 
                            }
                            catch(Exception ex)
                            {
                                 system.debug('Send request errors'+ ex);
                                if(ql.Supplier_Quote__r.Route__r.Country_of_Load__r.ISO_Code__c == null)
                                    errores_duty +=supplier_Item_Line[0].Supplier_Quote__r.Name+' Country of Delivery is empty';
                                else if(ql.Supplier_Quote__r.Route__r.Country_of_Discharge__r.ISO_Code__c== null)   
                                    errores_duty +=supplier_Item_Line[0].Supplier_Quote__r.Name+' Country of Receipt is empty';
                                else if(ql.Item__c == null)
                                    errores_duty +=supplier_Item_Line[0].Supplier_Quote__r.Name+' Item Name is empty';
                                else if(ql.Quantity__c == null || ql.Quantity__c ==0)
                                    errores_duty +=supplier_Item_Line[0].Supplier_Quote__r.Name+' Units is 0';
                                else if(ql.Price__c == null || ql.Price__c ==0)
                                    errores_duty +=supplier_Item_Line[0].Supplier_Quote__r.Name+' Price is 0';
                                else
                                    errores_duty +=supplier_Item_Line[0].Supplier_Quote__r.Name+ ' Error countries';
                            }
                            
                             supplier_Item_Line_insert.add(ql);
                             ql.Supplier_Quote__r.Taxes_Calculated__c = true;
                             update_cabeceras_check.add(ql.Supplier_Quote__r);
                             
                        }
                        else
                        {       
                                return refresh();
                                break;
                        }
                    }
                    else
                         errores_duty += supplier_Item_Line[0].Supplier_Quote__r.Name+ ' Line'+ ql.Name+' Error HS Code empty \n <br/>';
                    indice2 ++;
                }
                else
                    indice2 ++;
            }
        

        }
        else
        {
            errores_duty +=supplier_Item_Line[0].Supplier_Quote__r.Name+' Route is empty <br/>';
             system.debug('price_comparison error'+ errores_duty);
        }
        }
        
        id_supplier_quote = '';
        return null;
       
    }
    
    public PageReference refresh()
    {
        if(supplier_Item_Line != null)
        {
            try
            {
                update supplier_Item_Line;
                update supplier_Item_Line_insert;
                update update_cabeceras_check;
            }
            catch(Exception ex) { }
        }
        
        String returnUrl = '/apex/NEU_MD_PriceComparison'; 
        PageReference pgReturnPage  = new PageReference(returnUrl);
        pgReturnPage.getParameters().put('id', record.Id);
        if(indice2 >0)
            pgReturnPage.getParameters().put('xind', string.valueOf(indice2));
        if(errores_duty != null && errores_duty != '')
            pgReturnPage.getParameters().put('er', errores_duty);
        if(id_supplier_quote != null && id_supplier_quote != '')
            pgReturnPage.getParameters().put('squo', id_supplier_quote);
        
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    
    
    
    
    //----------------------------------------------------
    
    
     public void desactive_lines()
    {
        
        List<Supplier_Quote_Line__c> lines_update=[select Id, Name, Active__c from Supplier_Quote_Line__c where Id =: id_oi];
        
        try
        {
            if(lines_update.size()>0)
            {
               lines_update[0].Active__c = false;
               update lines_update;
             }
        } 
        catch(Exception ex){system.debug('error'+ex);}
    }
}