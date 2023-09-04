public with sharing class NEU_Standard_Duty_Calculator_Shipment {

    private Shipment__c record=null;
    public String api_key='0396552b6337c843';
    public String errores {get;set;}
    public Integer contador_de_llamadas {get;set;}
    public Integer posicion_seguir {get;set;}
    public Integer indice {get;set;}
    public List<Shipment_Line__c> ship_Line = null;
    public NEU_Standard_Duty_Calculator_Shipment(ApexPages.StandardController stdController)
    {
         if (!Test.isRunningTest()) {
            stdController.AddFields(new String[]
            {
              'Id',
              'Name', 
              'Route__c'
            });
         }
         
        record=(Shipment__c)stdController.getRecord();
        
    }
    
    public PageReference calcular_tasas() 
    {
        string url='';
        string body_test2 = '';
        errores = '';
        
        ship_Line = new List<Shipment_Line__c>();
        ship_Line = [select Id, Name, Unit_Origin_Sell_Price__c,  HS_Code__c , Percent_Duty__c, Percent_Taxes__c, 
         Shipment_Charges_Assigned__c, 
        Shipment__r.Route__r.Country_of_Load__r.ISO_Code__c, Shipment__r.Route__r.Country_of_Discharge__r.ISO_Code__c, 
        Sales_Tax__c, Additional_Import_Taxes_Detail__c,
        Total_Taxes__c, Duty__c, Customs_Value__c, Customs_Incoterm__c, Item_Name__r.Name, Extension_Item_Name__c,
        Import_Export_Quote__r.Country_ofDischarge__r.ISO_Code__c, Import_Export_Quote__r.Country_ofLoad__r.ISO_Code__c, 
        Category_DC__c, Subcategory_DC__c, Product_Item_DC__c, Item_Name__c,  Item_Name__r.Product_Item__c, Item_Name__r.Subcategory__c, Item_Name__r.Category__c,
        Units_Shipped__c, Additional_Import_Taxes_Amount__c,
        Item_Name__r.HS_Code_Text__c from Shipment_Line__c where Shipment__c =: record.Id];//id =: idlineactualizar
        
        decimal valoritems = 0;
        contador_de_llamadas = 0;
        indice = 0; 
        if(ApexPages.currentPage().getParameters().get('er') != null)
            errores = ApexPages.currentPage().getParameters().get('er') ;
        if(ApexPages.currentPage().getParameters().get('n') != null)
            posicion_seguir = integer.valueOf(ApexPages.currentPage().getParameters().get('n'));
        else
            posicion_seguir = 0;
            
        if(record.Route__c != null)
        {    
            for (Shipment_Line__c ql: ship_Line)
            {
                if(indice >= posicion_seguir)
                {
                    if(ql.Item_Name__r.HS_Code_Text__c != '' && ql.Item_Name__r.HS_Code_Text__c != null)
                    {
                        if(contador_de_llamadas < 10 )
                        {
                            url = '';
                            valoritems = ql.Unit_Origin_Sell_Price__c;
                            /*if(ql.Item_Name__r.Category_DC_Value__c != '')
                                ql.Category_DC_Value__c = ql.Item_Name__r.Category_DC_Value__c;
                            if(ql.Item_Name__r.Subcategory_DC_Value__c != '')
                                ql.Subcategory_DC_Value__c = ql.Item_Name__r.Subcategory_DC_Value__c;
                            if(ql.Item_Name__r.Product_Item_DC_Value__c != '')
                                ql.Product_Item_DC_Value__c = ql.Item_Name__r.Product_Item_DC_Value__c;*/
                            
                             if(ql.Item_Name__r.Category__c != '')
                                ql.Category_DC__c = ql.Item_Name__r.Category__c;
                            if(ql.Item_Name__r.Subcategory__c != '')
                                ql.Subcategory_DC__c = ql.Item_Name__r.Subcategory__c;
                            if(ql.Item_Name__r.Product_Item__c != '')
                                ql.Product_Item_DC__c = ql.Item_Name__r.Product_Item__c;    
                            if(ql.Item_Name__r.HS_Code_Text__c !='')
                                ql.HS_Code__c = ql.Item_Name__r.HS_Code_Text__c;
                            
                            url += 'https://www.dutycalculator.com/api2.1/'+api_key+'/calculation';
                            url += '?from='+ ql.Shipment__r.Route__r.Country_of_Load__r.ISO_Code__c ;
                            url += '&to='+ql.Shipment__r.Route__r.Country_of_Discharge__r.ISO_Code__c;
                            url += '&hs[0]='+ql.Item_Name__r.HS_Code_Text__c;
                        //  url += '&country_of_hs_code[0]={ISO  alpha-3 country code or alpha-2 country code} \';
                            url += '&desc[0]='+EncodingUtil.urlEncode(ql.Item_Name__r.Name, 'UTF-8');
                            url += '&value[0]='+valoritems;
                        //  url += '&weight[0]={weight of one item} \';
                            url += '&qty[0]='+ql.Units_Shipped__c;
                            url += '&shipping='+ql.Shipment_Charges_Assigned__c;
                            url += '&insurance=0';
                            url += '&currency='+NEU_CurrencyUtils.getCurrencyIsoCode(ql);
                            //url += '&shipment_wt='+ql.Import_Export_Quote__r.Total_Weight_Kg2__c;
                            url += '&output_currency='+NEU_CurrencyUtils.getCurrencyIsoCode(ql); //NEU_CurrencyUtils.getCurrencyIsoCode(ql.Import_Export_Quote__r);
                            //url += '&preferential_rates={1 to apply FTA and preferential rates, 0 to ignore FTA and preferential rates} \';
                            url += '&classify_by=hs';
                             if(ApexPages.currentPage().getParameters().get('test') != null)
                                    url='https://api.salesforce.com/foo/bar';
                            
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
                                            //if(child2.getName() == 'total')
                                             //   ql.Total_Taxes__c = decimal.valueof(child3.getText());
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
                                        
                                        
                                    }
                                    if(ql.Customs_Value__c == null || ql.Customs_Value__c <= 0 )
                                    {
                                          errores +=  (child.getName() == 'code' ? 'Line'+ ql.Name+' Error'+  child.getText() :'');
                                       
                                    }
                                    if(errores  !='')
                                     {
                                         errores +=(child.getName() == 'message'?  child.getText():'');
                                         errores +='\n';
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
                                if(ql.Shipment__r.Route__r.Country_of_Load__r.ISO_Code__c == null)
                                    errores +='Country of Delivery is empty';
                                else if(ql.Shipment__r.Route__r.Country_of_Discharge__r.ISO_Code__c== null)   
                                    errores +='Country of Receipt is empty';
                                else if(ql.Item_Name__c == null)
                                    errores +='Item Name is empty';
                                else if(ql.Units_Shipped__c == null || ql.Units_Shipped__c ==0)
                                    errores +='Units is 0';
                                else if(ql.Unit_Origin_Sell_Price__c == null || ql.Unit_Origin_Sell_Price__c ==0)
                                    errores +='Price is 0';
                                else
                                    errores +='Error countries';
                            }
                        }
                        else
                        {       
                                return refresh();
                                break;
                        }
                    }
                    else
                         errores += 'Line'+ ql.Name+' Error HS Code empty \n\n';
                    indice ++;
                }
                else
                    indice ++;
            }
        
        
            try
            {
                update ship_Line;
            }
            catch(Exception ex) { }
        }
        else
        {
            errores +='Route is empty';
        }
        
        return null;
       
    }
    
    public PageReference refresh()
    {
        if(ship_Line != null)
        {
            try
            {
                update ship_Line;
            }
            catch(Exception ex) { }
        }
        
        String returnUrl = '/apex/NEU_Standard_Duty_Calculator_Shipment'; 
        PageReference pgReturnPage  = new PageReference(returnUrl);
        pgReturnPage.getParameters().put('id', record.Id);
        if(indice >0)
            pgReturnPage.getParameters().put('n', string.valueOf(indice));
        if(errores != null && errores != '')
            pgReturnPage.getParameters().put('er', errores);
        
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    public PageReference volver()
    {
        return new PageReference('/'+record.Id);
    
    }
    
}