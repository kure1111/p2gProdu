public with sharing class NEU_OM_Start_Clearance {
    public Customer_Quote__c record;
    private List<Quote_Item_Line__c> quoteItemLines=null;
    private List<Quote_Item_Line__c> quoteItemLine2=null;
    public String idlineaitem {get;set;}
    public String idsubcategory {get;set;}
    private string list_category=null;
    private string lista_subcategorias=null;
    private string lista_items=null;
   // public string api_key = '61fd618413855d0d';
    public string api_key = '0396552b6337c843';
  //  public string api_key ='5848';
    public string category_field {get;set;}
    public string subcategory_field {get;set;}
    public string item_field {get;set;}
    public string category_name {get;set;}
    public string subcategory_name {get;set;}
    public string item_name {get;set;}
    public string iso_code_countryto {get;set;}
    public string idlineactualizar {get;set;}
    public string codigohs {get;set;}
    public string urlcodigohs {get;set;}
    public string nombredelarticulo {get;set;}
    public string consultahs_code {get;set;}
    public string errores {get;set;}
    
   
    ApexPages.StandardController con;
    
    public String getlist_category()
    {
        if(list_category==null)
            getDutyCalculatorInfo();
        return list_category;
    }
    public String getlista_subcategorias()
    {
        if(lista_subcategorias==null)
            getDutyCalculatorInfo();
        return lista_subcategorias;
    }
    public String getlista_items()
    {
        if(lista_items==null)
            getDutyCalculatorInfo();
        return lista_items;
    }
    public NEU_OM_Start_Clearance(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name from Customer_Quote__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Customer_Quote__c();
        }
        idlineaitem = '';
        idsubcategory = '';
        category_field = '';
        subcategory_field = '';
        item_field = '';
        category_name = '';
        subcategory_name = '';
        item_name = '';
        iso_code_countryto = '';
        idlineactualizar = '';
        codigohs = '';
        urlcodigohs = '';
        nombredelarticulo = '';
    }
    public void getDutyCalculatorInfo()
    {
        string url = 'https://www.dutycalculator.com/api2.1/'+api_key+'/categories';
            
            if(ApexPages.currentPage().getParameters().get('test') != null)
                url='https://api.salesforce.com/foo/bar';
            
            Http h = new Http(); 
            HttpRequest req = new HttpRequest();
            req.setTimeout(100000);
            req.setEndpoint(url); 
            req.setMethod('GET');
            string body_test2='';
            HttpResponse res = new HttpResponse();
            if (!Test.isRunningTest())
                res = h.send(req); 
            else
            {
                body_test2 ='<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"><soap:Header></soap:Header>';
                body_test2 +='<soap:Body>';
                body_test2 +='<categories>';
                body_test2 +='<category name="AntiquesCollectibles" id="L18">';
                body_test2 +='<subcategory name="AntiquesYearsOld" id="L29">';
                body_test2 +='<item id="87">Antique</item><item id="2163">AntiqueSilverware</item>';
                body_test2 +='<item id="2164">AntiqueFurniture</item>';
                body_test2 +='</subcategory>';
                body_test2 +='<subcategory name="Artwork" id="L2281">';
                body_test2 +='<item id="88">OriginalArtWorkpaintingsdrawings</item>';
                body_test2 +='<item id="2564">OriginalArtWorksculpturesstatuary</item>';
                body_test2 +='</subcategory>';
                body_test2 +='</category></categories></soap:Body></soap:Envelope>';
            }
            Dom.Document doc = new Dom.Document();
            if (!Test.isRunningTest())
                 doc = res.getBodyDocument(); 
            else
                doc.load(body_test2);  
             

             
            //Retrieve the root element for this document.
            Dom.XMLNode Envelope = doc.getRootElement();        
            Dom.XMLNode Body = Envelope.getChildElements()[0];        
            
            list_category = '';     
            lista_subcategorias = '';
            lista_items = '';
            //Get Category, Subcategory and Item
            try
            {
                for(Dom.XMLNode child : Envelope.getChildElements()) 
                {
                    list_category += '<option value="'+child.getAttribute('id','')+'">'+child.getAttribute('name','')+'</option>';
                    
                    for(Dom.XMLNode child2 : child.getChildElements())
                    { 
                        lista_subcategorias += '<option value="'+child2.getAttribute('id','')+'" class="'+child.getAttribute('id','')+'">'+child2.getAttribute('name','')+'</option>';
                        
                        for(Dom.XMLNode child3 : child2.getChildElements())
                        {
                            lista_items += '<option value="'+child3.getAttribute('id','')+'" class="'+child2.getAttribute('id','')+'">'+child3.getText()+'</option>';
                        }
                    }
                }
            }
            catch(Exception ex)
            {
                
            }
        
    }
       
        
    //pintar todas las lineas del import export
    public List<Quote_Item_Line__c> getquoteItemLines()
    {
        if(quoteItemLines==null)
        {
            quoteItemLines = [select Id, Total_Shipping_Volume_m3__c, Percent_Taxes__c, Additional_Import_Taxes_Amount__c, Percent_Duty__c, HS_Code__c , Imp_Exp_Fees_assigned__c, Price__c, Amount__c,  Name, Item_Name__r.HS_Code_Text__c, Total_Taxes_Form__c , List_Price__c, Item_Price__c, Extension_Item_Name__c, Total_Shipping_Weight_Kgs__c, Import_Export_Quote__r.Country_ofLoad__r.ISO_Code__c, Import_Export_Quote__r.Country_ofDischarge__r.ISO_Code__c, Weight_Kgs__c , Units__c , Category__c, Product_Item_DC__c, Subcategory_DC__c, Item_Name__c, Item_Name__r.Name, Import_Export_Quote__c, Sales_Tax__c, Duty__c, Incoterm__c, Customs_Value__c, Additional_Import_Taxes_Detail__c from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id order by Name];
        }
        
        
        return quoteItemLines;
    }
    //pintar la linea seleccionada
    public List<Quote_Item_Line__c> getquoteItemLine2()
    {

        
        if(idlineaitem !='')
        {
            quoteItemLine2 = [select Id, Name, Item_Name__r.HS_Code_Text__c, HS_Code__c , Item_Name__r.Product_Item__c, Item_Name__r.Product_Item_DC_Value__c,  Item_Name__r.Subcategory__c, Item_Name__r.Subcategory_DC_Value__c, Item_Name__r.Category__c, Item_Name__r.Category_DC_Value__c, Additional_Import_Taxes_Amount__c, Percent_Duty__c, Percent_Taxes__c, Total_Taxes_Form__c , Price__c, Amount__c,  Imp_Exp_Fees_assigned__c, Total_Shipping_Volume_m3__c, List_Price__c, Item_Price__c, Extension_Item_Name__c, Total_Shipping_Weight_Kgs__c, Import_Export_Quote__r.Country_ofLoad__r.ISO_Code__c, Import_Export_Quote__r.Country_ofDischarge__r.ISO_Code__c, Weight_Kgs__c , Units__c ,Category__c, Product_Item_DC__c, Subcategory_DC__c, Item_Name__c, Item_Name__r.Name, Import_Export_Quote__c, Sales_Tax__c, Duty__c, Incoterm__c, Customs_Value__c, Additional_Import_Taxes_Detail__c, Item_Name__r.Url_Photo_1__c, Item_Name__r.Sourcing_Family__c, Item_Name__r.Subfamily__c from Quote_Item_Line__c where Id =: idlineaitem order by Name];
            idlineactualizar = idlineaitem;
            if(quoteItemLine2[0].Item_Name__r.Name != null && quoteItemLine2[0].Item_Name__r.Name !='')
                nombredelarticulo = quoteItemLine2[0].Item_Name__r.Name;
            else
                nombredelarticulo = quoteItemLine2[0].Extension_Item_Name__c;
            idlineaitem = '';
            return quoteItemLine2;
            
        }
        else
            return null;
        
    }
    
    //actualizar las lineas con los campos seleccionados
   public PageReference applyLines()
    {
         for (Quote_Item_Line__c lines:getquoteItemLines())
        {
            
            try
            {
                update lines;
            }
            catch(Exception e)
            {
            }
        }
        return new PageReference('/'+record.Id);
    }
    
    //calcular tasas conectar con duy
    public PageReference calculate_taxes ()
    {
        quoteItemLines=null;
        quoteItemLine2=null;
        string url='';
        string currency_val ='';
        string iditem = '';
        decimal valoritems = 0;
        string body_test2 = '';
        string hs_code_item = '';
        List<Quote_Item_Line__c> Quote_Item_Line = new List<Quote_Item_Line__c>();
        

        Quote_Item_Line = [select Id, Name, Price__c, List_Price__c, HS_Code__c , Additional_Import_Taxes_Amount__c, Percent_Duty__c, Percent_Taxes__c, Total_Taxes_Form__c , Imp_Exp_Fees_assigned__c,  Import_Export_Quote__r.Total_Weight_Kg2__c,    Import_Export_Quote__r.Route__r.Country_of_Load__r.ISO_Code__c, Import_Export_Quote__r.Route__r.Country_of_Discharge__r.ISO_Code__c,  Product_Item_DC_Value__c, Category_DC_Value__c, Subcategory_DC_Value__c, Sales_Tax__c, Additional_Import_Taxes_Detail__c, Duty__c, Customs_Value__c, Incoterm__c, Item_Price__c, Item_Name__r.Name, Extension_Item_Name__c, Import_Export_Quote__r.Country_ofDischarge__r.ISO_Code__c, Import_Export_Quote__r.Country_ofLoad__r.ISO_Code__c,  Category__c, Subcategory_DC__c, Product_Item_DC__c, Item_Name__c, Units__c from Quote_Item_Line__c where id =: idlineactualizar];
        
        for (Quote_Item_Line__c ql: Quote_Item_Line)
        {
            ql.Category__c =  category_name;
            ql.Subcategory_DC__c =  subcategory_name;
            ql.Product_Item_DC__c =  item_name;
            if(ql.Item_Name__c != null)
                iditem = ql.Item_Name__c;
            ql.Category_DC_Value__c = category_field;
            ql.Subcategory_DC_Value__c = subcategory_field;
            ql.Product_Item_DC_Value__c = item_field;
            
            
            //Get Info Custom Duty  
            iso_code_countryto = ql.Import_Export_Quote__r.Country_ofDischarge__r.ISO_Code__c;
            
            valoritems = ql.Price__c;
            
            url += 'https://www.dutycalculator.com/api2.1/'+api_key+'/calculation';
            url += '?from='+ ql.Import_Export_Quote__r.Route__r.Country_of_Load__r.ISO_Code__c ;
            url += '&to='+ql.Import_Export_Quote__r.Route__r.Country_of_Discharge__r.ISO_Code__c;
            //url += '&province={ISO alpha-2 province code of ‘importing to’ country (only required for Canada and Brazil)} \';
            //url += '&shipping_mode={shipping mode} \';
        //  url += '&commercial_importer={importer status (only required for Russia)} \';
        //  url += '&imported_wt={total weight of products imported during the month (only required for Russia)} \';
        //  url += '&imported_value={total value of products imported during the month (only required for Russia)} \';
            url += '&classify_by=cat';
            url += '&cat[0]='+item_field;
        //  url += '&hs[0]={item HS code} \';
        //  url += '&country_of_hs_code[0]={ISO  alpha-3 country code or alpha-2 country code} \';
            url += '&desc[0]='+EncodingUtil.urlEncode(ql.Item_Name__r.Name, 'UTF-8');
            //url += '&sku[0]={item sku } \';
            url += '&value[0]='+valoritems;
        //  url += '&weight[0]={weight of one item} \';
            url += '&qty[0]='+ql.Units__c;
            //url += '&origin[0]={ISO alpha-3 country code or alpha-2 country code} \';
            url += '&reference[0]='+item_field;
            url += '&shipping='+ql.Imp_Exp_Fees_assigned__c;
            url += '&insurance=0';
            url += '&currency='+NEU_CurrencyUtils.getCurrencyIsoCode(ql);
            //url += '&shipment_wt='+ql.Import_Export_Quote__r.Total_Weight_Kg2__c;
            url += '&output_currency='+NEU_CurrencyUtils.getCurrencyIsoCode(ql); //NEU_CurrencyUtils.getCurrencyIsoCode(ql.Import_Export_Quote__r);
            //url += '&preferential_rates={1 to apply FTA and preferential rates, 0 to ignore FTA and preferential rates} \';
            url += '&detailed_result=0';
            url += '&incl_hs_codes=1';
            
            
             if(ApexPages.currentPage().getParameters().get('test') != null)
                    url='https://api.salesforce.com/foo/bar';
            
            try
            {
                Http h = new Http(); 
                HttpRequest req = new HttpRequest();
                
                req.setEndpoint(url); 
                req.setMethod('GET');
                HttpResponse res = new HttpResponse();
                if (!Test.isRunningTest())
                    res = h.send(req); 
                else
                {
                    body_test2 ='<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"><soap:Header></soap:Header>';
                    body_test2 +='<soap:Body>';
                    body_test2 +='<duty-calculation id="187659186" item="18888">';
                    body_test2 +='  <total-charges>';
                    body_test2 +='      <customs-value name="CIF">';
                    body_test2 +='          <amount currency="EUR">1000</amount>';
                    body_test2 +='      </customs-value>';
                    body_test2 +='      <duty>';
                    body_test2 +='          <amount currency="EUR">30</amount>';
                    body_test2 +='      </duty>';
                    body_test2 +='      <sales-tax name="VAT">';
                    body_test2 +='          <amount currency="EUR">216.3</amount>';
                    body_test2 +='      </sales-tax>';
                    body_test2 +='                                                            <duty name="VAT">';
                    body_test2 +='          <amount currency="EUR">216.3</amount>';
                    body_test2 +='          <additional-import-taxes currency="EUR" name="hola">216.3</additional-import-taxes>';
                    body_test2 +='      </duty>';
                    body_test2 +='      <total>';
                    body_test2 +='          <amount currency="EUR">246.3</amount>';
                    body_test2 +='      </total>';
                    body_test2 +='  </total-charges>';
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
                    if(child.getName() == 'item')
                    {
                        ql.HS_Code__c = child.getAttribute('hs-code','');
                        hs_code_item = child.getAttribute('hs-code','');
                    }
                    for(Dom.XMLNode child2 : child.getChildElements())
                    { 
                        
                         if(child2.getName() == 'customs-value')
                            ql.Incoterm__c = child2.getAttribute('name','');
    
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
                if(ql.Import_Export_Quote__r.Route__r.Country_of_Load__r.ISO_Code__c == null)
                    errores ='Country of Delivery is empty';
                else if(ql.Import_Export_Quote__r.Route__r.Country_of_Discharge__r.ISO_Code__c== null)   
                    errores ='Country of Receipt is empty';
                else if(ql.Item_Name__c == null)
                    errores ='Item Name is empty';
                else if(ql.Units__c == null || ql.Units__c ==0)
                    errores ='Units is 0';
                else if(ql.Price__c == null || ql.Price__c ==0)
                    errores ='Price is 0';
                else
                    errores ='Error countries';
            }
        }
        List<Sourcing_Item__c> Sourcing_Item = new List<Sourcing_Item__c>();
        if(iditem != '')
        {
            
            Sourcing_Item = [select Id, Name, HS_Code_Text__c,Category_DC_Value__c , Subcategory_DC_Value__c , Product_Item_DC_Value__c ,  Category__c, Subcategory__c, Product_Item__c from Sourcing_Item__c where id =: iditem];
            
            for (Sourcing_Item__c si: Sourcing_Item)
            {
                si.Category__c = category_name;
                si.Subcategory__c = subcategory_name;
                si.Product_Item__c = item_name;
                si.Category_DC_Value__c = category_field;
                si.Subcategory_DC_Value__c = subcategory_field;
                si.Product_Item_DC_Value__c = item_field;
                if(hs_code_item != '')
                    si.HS_Code_Text__c = hs_code_item;
            }
        }
        
        try
        {
            update Quote_Item_Line;
            update Sourcing_Item;
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));
            return null;
        }
        return null;
    }

    public void calcular_hs_codes()
    {
        
    }
}