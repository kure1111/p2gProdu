public with sharing class NEU_OM_Start_Clearance_Shipment {

    public Shipment__c record;
    private List<Shipment_Line__c> shipmentItemLines=null;
    private List<Shipment_Line__c> shipmentItemLines2=null;
    public String idlineaitem {get;set;}
    public String idsubcategory {get;set;}
    private string list_category=null;
    private string lista_subcategorias=null;
    private string lista_items=null;
    public string api_key = '0396552b6337c843';
    
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
    ApexPages.StandardController con;
    public string errores {get;set;}
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
    
    public NEU_OM_Start_Clearance_Shipment(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name from Shipment__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Shipment__c();
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
    public List<Shipment_Line__c> getshipmentItemLines()
    {
        if(shipmentItemLines==null)
        {
            shipmentItemLines = [select Id, Name, Item_Name__r.HS_Code_Text__c,
             Extension_Item_Name__c, Shipping_Weight_Kg__c, Unit_Origin_Sell_Price__c, HS_Code__c ,Percent_Duty__c, Percent_Taxes__c,
             Units_Shipped__c, Product_Item_DC__c, Subcategory_DC__c, Additional_Import_Taxes_Amount__c,
             Item_Name__c, Item_Name__r.Name, Shipment__c, 
             Sales_Tax__c, Duty__c, Customs_Incoterm__c, Customs_Value__c, Shipping_Volume_m3__c, Shipment_Charges_Assigned__c, Sell_Origin_Amount__c, Total_Taxes__c
             from Shipment_Line__c where Shipment__c =: record.Id order by Name];
        }
        
        
        return shipmentItemLines;
    }
    //pintar la linea seleccionada
    public List<Shipment_Line__c> getshipmentItemLines2()
    {

        if(idlineaitem !='')
        {
            shipmentItemLines2 = [select Id, Name, Item_Name__r.HS_Code_Text__c,  
             Extension_Item_Name__c, Shipping_Weight_Kg__c, Units_Shipped__c, Additional_Import_Taxes_Amount__c,
             Product_Item_DC__c, Subcategory_DC__c, Item_Name__c, Item_Name__r.Name, Shipment__c,
             Total_Taxes__c, Sales_Tax__c, Unit_Origin_Sell_Price__c, HS_Code__c , Percent_Duty__c, Shipping_Volume_m3__c,
             Duty__c, Customs_Incoterm__c, Customs_Value__c, Percent_Taxes__c, Sell_Origin_Amount__c, 
             Item_Name__r.Url_Photo_1__c, Item_Name__r.Sourcing_Family__c, Shipment_Charges_Assigned__c ,
             Item_Name__r.Subfamily__c from Shipment_Line__c where Id =: idlineaitem order by Name];
             
            idlineactualizar = idlineaitem;
            if(shipmentItemLines2[0].Item_Name__r.Name != null && shipmentItemLines2[0].Item_Name__r.Name !='')
                nombredelarticulo = shipmentItemLines2[0].Item_Name__r.Name;
            else
                nombredelarticulo = shipmentItemLines2[0].Extension_Item_Name__c;
            idlineaitem = '';
            return shipmentItemLines2;
            
        }
        else
            return null;
        
    }
    
    //actualizar las lineas con los campos seleccionados
   public PageReference applyLines()
    {
         for (Shipment_Line__c lines:getshipmentItemLines())
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
        shipmentItemLines=null;
        shipmentItemLines2=null;
        string url='';
        string currency_val ='';
        string iditem = '';
        decimal valoritems = 0;
        string body_test2 = '';
        List<Shipment_Line__c> Shipment_Item_Line = new List<Shipment_Line__c>();
        string hs_code_item = '';
  
        
        Shipment_Item_Line = [select Id, Name, Unit_Origin_Sell_Price__c,
         Sales_Tax__c,  Duty__c, Customs_Value__c, Customs_Incoterm__c, Additional_Import_Taxes_Amount__c,
         Item_Name__r.Name, Extension_Item_Name__c, Shipping_Weight_Kg__c,HS_Code__c ,Shipment__r.Country_of_Load__c, 
         Shipment__r.Route__r.Country_of_Load__r.ISO_Code__c, Shipping_Volume_m3__c, Percent_Duty__c, Total_Taxes__c ,
         Shipment__r.Route__r.Country_of_Discharge__r.ISO_Code__c, Sell_Origin_Amount__c, Shipment__r.Country_of_Discharge__c,
         Category_DC__c, Subcategory_DC__c, Product_Item_DC__c,  Percent_Taxes__c, Shipment_Charges_Assigned__c , 
         Item_Name__c, Units_Shipped__c, Additional_Import_Taxes_Detail__c
          from Shipment_Line__c where id =: idlineactualizar];
         
      for (Shipment_Line__c ql: Shipment_Item_Line)
        {
            ql.Category_DC__c =  category_name;
            ql.Subcategory_DC__c =  subcategory_name;
            ql.Product_Item_DC__c =  item_name;
            if(ql.Item_Name__c != null)
                iditem = ql.Item_Name__c;
                
           // iso_code_countryto =    ql.Shipment__r.Country_of_Receipt__r.ISO_Code__c;
            if(ql.Unit_Origin_Sell_Price__c != null)
                valoritems =ql.Unit_Origin_Sell_Price__c;
           
            url += 'https://www.dutycalculator.com/api2.1/'+api_key+'/calculation';
            url += '?from='+ ql.Shipment__r.Route__r.Country_of_Load__r.ISO_Code__c;
            url += '&to='+ql.Shipment__r.Route__r.Country_of_Discharge__r.ISO_Code__c;
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
            url += '&qty[0]='+ql.Units_Shipped__c;
            //url += '&origin[0]={ISO alpha-3 country code or alpha-2 country code} \';
            url += '&reference[0]='+item_field;
            url += '&shipping='+ql.Shipment_Charges_Assigned__c;
            url += '&insurance=0';
            url += '&currency='+NEU_CurrencyUtils.getCurrencyIsoCode(ql);
            //url += '&shipment_wt='+ql.Import_Export_Quote__r.Total_Weight_Kg__c;
            url += '&output_currency='+NEU_CurrencyUtils.getCurrencyIsoCode(ql);//NEU_CurrencyUtils.getCurrencyIsoCode(ql.Shipment__r);
            //url += '&preferential_rates={1 to apply FTA and preferential rates, 0 to ignore FTA and preferential rates} \';
            url += '&detailed_result=0';
            url += '&incl_hs_codes=1';
            
           /* if(ql.Extension_Item_Name__c != null && ql.Extension_Item_Name__c !='')//moneda del final outputcurrency Import_Export_Quote__r.Output_Currency__r.Currency_Code__c o Import_Export_Quote__r.Items_Currency__r.Currency_Code__c
                url += 'http://184.73.210.222/CustomDuty/CustomDuty/'+api_key+'/'+ql.Shipment__r.Country_of_Delivery__r.ISO_Code__c+'/'+ql.Shipment__r.Country_of_Receipt__r.ISO_Code__c+'/cat/'+subcategory_field+'/'+item_field+'/'+ql.Extension_Item_Name__c+'/'+ql.Units_Shipped__c+'/'+valoritems.setScale(2) +'/'+ql.Shipment_Fees_assigned_Output_Currency__c+'/0/'+ql.Shipment__r.Output_Currency__r.Currency_Code__c;//ship_ins
            else
                url += 'http://184.73.210.222/CustomDuty/CustomDuty/'+api_key+'/'+ql.Shipment__r.Country_of_Delivery__r.ISO_Code__c+'/'+ql.Shipment__r.Country_of_Receipt__r.ISO_Code__c+'/cat/'+subcategory_field+'/'+item_field+'/'+ql.Item_Name__r.Name+'/'+ql.Units_Shipped__c+'/'+valoritems.setScale(2) +'/'+ql.Shipment_Fees_assigned_Output_Currency__c+'/0/'+ql.Shipment__r.Output_Currency__r.Currency_Code__c;//ship_ins
            */
            
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
                    body_test2 +='              <duty name="VAT">';
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
                            ql.Customs_Incoterm__c = child2.getAttribute('name','');
    
                        for(Dom.XMLNode child3 : child2.getChildElements())
                        {
                            if(child2.getName() == 'customs-value')
                                ql.Customs_Value__c = decimal.valueof(child3.getText());
                            if(child2.getName() == 'duty')
                                ql.Duty__c = decimal.valueof(child3.getText());
                            if(child2.getName() == 'sales-tax')
                                ql.Sales_Tax__c = decimal.valueof(child3.getText());
                           // if(child2.getName() == 'total')
                            //    ql.Total_Taxes__c = decimal.valueof(child3.getText());
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
                if(ql.Shipment__r.Country_of_Load__c== null)
                    errores ='Route - Country of Load is empty';
                else if(ql.Shipment__r.Country_of_Discharge__c == null)   
                    errores ='Route - Country of Discharge is empty';
                else if(ql.Item_Name__c == null)
                    errores ='Item Name is empty';
                else if(ql.Units_Shipped__c== null || ql.Units_Shipped__c==0)
                    errores ='Units is 0';
                else if(ql.Unit_Origin_Sell_Price__c== null || ql.Unit_Origin_Sell_Price__c==0)
                    errores ='Price is 0';
                else
                    errores ='Error countries';
            }
        }
        
        List<Sourcing_Item__c> Sourcing_Item = new List<Sourcing_Item__c>();
        if(iditem != '')
        {
            
            Sourcing_Item = [select Id, Name, HS_Code_Text__c,  Category__c, Subcategory__c, Product_Item__c from Sourcing_Item__c where id =: iditem];
            
            for (Sourcing_Item__c si: Sourcing_Item)
            {
                si.Category__c = category_name;
                si.Subcategory__c = subcategory_name;
                si.Product_Item__c = item_name;
                if(hs_code_item != '')
                    si.HS_Code_Text__c = hs_code_item;
            }
        }
        
        try
        {
            update Shipment_Item_Line;
            update Sourcing_Item;
        }
        catch(Exception ex)
        {
        
        }
      return null;
    }

   

}