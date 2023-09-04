public with sharing class NEU_Standard_Fee_Calculation {


 public Supplier_Quote__c record = null;
  
 public NEU_Standard_Fee_Calculation(ApexPages.StandardController stdController) {
         
            if (!Test.isRunningTest()) {
            stdController.AddFields(new String[]
                {
                    'Id','Name', 'Customer__c','Customer__r.Business_Area__c',
                    'Place_of_Delivery__c','Place_of_Receipt__c','Delivery_Zone__c',
                    'Total_Volume_m3_2__c','Total_Weight_Kg2__c',
                    'Port_Airport_of_Load__c',
                    'Service_Charges_Calculated__c',
                    'Incoterm__c',
                    'Supply_Project__r.Sales_Incoterm__c',
                    'Port_Airport_of_Discharge__c', 'Country_ofLoad__c','Country_ofDischarge__c','Delivery_Account__c',
                    'Route__r.Name', 'Route__c'
                });
            }
            record=(Supplier_Quote__c)stdController.getRecord();
     }
  
   public NEU_Standard_Fee_Calculation(Supplier_Quote__c sq) {
         
            record=sq;
     }
     
  public Pagereference crear_fee_estandar()
  {
   // if(record.Route__c != null)
    //{
        List<Supplier_Quote_Order_Fee_Line__c> lista_de_fees_standar = [select Id, Fee_Name__r.Standard_Rate__c from Supplier_Quote_Order_Fee_Line__c where Supplier_Quote_Order__c =: record.Id and Fee_Name__r.Standard_Rate__c =:true];
        if(lista_de_fees_standar.size()>0)
        {
            try
            {
                delete lista_de_fees_standar;
            }
            catch(Exception ex){}
        }
        
        lista_de_fees_standar = [select Id from Supplier_Quote_Order_Fee_Line__c where Supplier_Quote_Order__c=: record.Id ];
        decimal total_lineas = lista_de_fees_standar.size();
        decimal total_fee_rate_peso = 0;
        decimal total_fee_rate_volumen = 0;
        
         decimal unidades_calculadas = 1;
         decimal unidades_calculadas2 = 1;
            
        List<Supplier_Quote_Order_Fee_Line__c> lista_de_lineas_fee = new List<Supplier_Quote_Order_Fee_Line__c>();
        
        List<Fee__c> lista_fees_standar = Database.query('select Id, Port_Airport__c,  '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'   Container_Type__r.Cargo_Weight_Kg__c, Valid_Until__c, Applicable_to_Purchase_Incoterms__c, Applicable_to_Sales_Incoterms__c, Container_Type__r.Cargo_Volume_m3__c,        Pallet_Type__r.Cargo_Weight_Kg__c,Pallet_Type__r.Cargo_Volume_m3__c,Pallet_Type__c,         Route__c, Rate_Type__c, Delivery_Zone__c, Account_for__c, RecordTypeId, Port_Airport__r.Name, Container_Type__c,         Fee_Rate__c from Fee__c where Standard_Rate__c = true and Active__c = true');
         
        for(Fee__c lp : lista_fees_standar)
        {
            if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId())
            { 
                  if((record.Place_of_Delivery__c != null || record.Place_of_Receipt__c != null || string.isnotEmpty(record.Port_Airport_of_Load__c) || string.isnotEmpty(record.Port_Airport_of_Discharge__c) ) 
                  && (lp.Port_Airport__c != null && record.Place_of_Delivery__c != lp.Port_Airport__c && record.Place_of_Receipt__c != lp.Port_Airport__c 
                  && record.Port_Airport_of_Load__c != lp.Port_Airport__r.Name && record.Port_Airport_of_Discharge__c != lp.Port_Airport__r.Name))  
                    continue;
                  
                  if(record.Delivery_Zone__c != null && record.Delivery_Zone__c != lp.Delivery_Zone__c && lp.Delivery_Zone__c != null)
                    continue;
                    
                 // if(record.Delivery_Account__c != null && record.Delivery_Account__c != lp.Account_for__c && lp.Account_for__c != null)
                  //  continue;
                      
                  if(lp.Applicable_to_Purchase_Incoterms__c != null)
                            if(record.Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(record.Incoterm__c))
                              continue;
                              
                  if(lp.Applicable_to_Sales_Incoterms__c != null)
                            if(record.Supply_Project__r.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(record.Supply_Project__r.Sales_Incoterm__c))
                               continue;
                      
                 Supplier_Quote_Order_Fee_Line__c nueva_linea = new Supplier_Quote_Order_Fee_Line__c();
                 total_lineas ++;
                 nueva_linea.Name =string.valueof(total_lineas);
                
                 while(nueva_linea.Name.length()>2) 
                    nueva_linea.Name = '0'+nueva_linea.Name;
                 
                 nueva_linea.Fee_Name__c = lp.Id;
                 nueva_linea.Supplier_Quote_Order__c= record.Id;
                 nueva_linea.Supplier_Quote_Order_Buy_Price__c = lp.Fee_Rate__c;
                 nueva_linea.Supplier_Quote_Order_Sell_Price__c = lp.Fee_Rate__c;
                // nueva_linea.CurrencyIsoCode = lp.CurrencyIsoCode;
                NEU_CurrencyUtils.setCurrencyIsoCode(nueva_linea ,NEU_CurrencyUtils.getCurrencyIsoCode(lp));
                 if(lp.Rate_Type__c == 'Per Kg')
                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                if(lp.Rate_Type__c == 'Per TON')
                    unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                if(lp.Rate_Type__c == 'Per M3')
                     unidades_calculadas = (record.Total_Volume_m3_2__c >0 ? record.Total_Volume_m3_2__c: 1); 
                if(lp.Rate_Type__c == 'Per Container')
                {
                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                   if(unidades_calculadas2 > unidades_calculadas)
                       unidades_calculadas = unidades_calculadas2; 
                   unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                }
                if(lp.Rate_Type__c == 'Per Pallet')
                {
                    unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                    unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                   if(unidades_calculadas2 > unidades_calculadas)
                       unidades_calculadas = unidades_calculadas2; 
                   unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                }
                nueva_linea.Units__c = unidades_calculadas;
                if(lp.Valid_Until__c != null)
                    nueva_linea.Valid_Until__c = lp.Valid_Until__c;
                lista_de_lineas_fee.add(nueva_linea);  
                    
            }
            else
            {
                if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                {
                  if(record.Route__c == null || lp.Route__c == null || record.Route__c == lp.Route__c)
                  {
                      if(lp.Applicable_to_Purchase_Incoterms__c != null)
                            if(record.Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(record.Incoterm__c))
                              continue;
                              
                        if(lp.Applicable_to_Sales_Incoterms__c != null)
                            if(record.Supply_Project__r.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(record.Supply_Project__r.Sales_Incoterm__c))
                               continue;
                    
                     Supplier_Quote_Order_Fee_Line__c nueva_linea = new Supplier_Quote_Order_Fee_Line__c();
                     total_lineas ++;
                     nueva_linea.Name =string.valueof(total_lineas);
                  
                     while(nueva_linea.Name.length()>2)
                        nueva_linea.Name = '0'+nueva_linea.Name;
                     
                     nueva_linea.Fee_Name__c = lp.Id;
                     nueva_linea.Supplier_Quote_Order__c= record.Id;
                     nueva_linea.Supplier_Quote_Order_Buy_Price__c = lp.Fee_Rate__c;
                     nueva_linea.Supplier_Quote_Order_Sell_Price__c = lp.Fee_Rate__c;
                     // nueva_linea.CurrencyIsoCode = lp.CurrencyIsoCode;
                      NEU_CurrencyUtils.setCurrencyIsoCode(nueva_linea ,NEU_CurrencyUtils.getCurrencyIsoCode(lp));
                    if(lp.Rate_Type__c == 'Per Kg')
                        unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                    if(lp.Rate_Type__c == 'Per TON')
                        unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                    if(lp.Rate_Type__c == 'Per M3')
                         unidades_calculadas = (record.Total_Volume_m3_2__c >0 ? record.Total_Volume_m3_2__c: 1); 
                    if(lp.Rate_Type__c == 'Per Container')
                    {
                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                       if(unidades_calculadas2 > unidades_calculadas)
                           unidades_calculadas = unidades_calculadas2; 
                       unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                    }        
                    if(lp.Rate_Type__c == 'Per Pallet')
                    {
                        unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                       if(unidades_calculadas2 > unidades_calculadas)
                           unidades_calculadas = unidades_calculadas2; 
                       unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                    }
                     nueva_linea.Units__c = unidades_calculadas;
                     if(lp.Valid_Until__c != null)
                         nueva_linea.Valid_Until__c = lp.Valid_Until__c;
                     lista_de_lineas_fee.add(nueva_linea);   
                  }
                }
                else
                {
                     if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId())
                     {
                        if(lp.Applicable_to_Purchase_Incoterms__c != null)
                            if(record.Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(record.Incoterm__c))
                              continue;
                              
                        if(lp.Applicable_to_Sales_Incoterms__c != null)
                            if(record.Supply_Project__r.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(record.Supply_Project__r.Sales_Incoterm__c))
                               continue;
                      
                        Supplier_Quote_Order_Fee_Line__c nueva_linea = new Supplier_Quote_Order_Fee_Line__c();
                         total_lineas ++;
                         nueva_linea.Name =string.valueof(total_lineas);

                         while(nueva_linea.Name.length()>2)
                            nueva_linea.Name = '0'+nueva_linea.Name;
                         
                         nueva_linea.Fee_Name__c = lp.Id;
                         nueva_linea.Supplier_Quote_Order__c= record.Id;
                         nueva_linea.Supplier_Quote_Order_Buy_Price__c = lp.Fee_Rate__c;
                         nueva_linea.Supplier_Quote_Order_Sell_Price__c = lp.Fee_Rate__c;
                         //nueva_linea.CurrencyIsoCode = lp.CurrencyIsoCode;
                         NEU_CurrencyUtils.setCurrencyIsoCode(nueva_linea ,NEU_CurrencyUtils.getCurrencyIsoCode(lp));
                         if(lp.Rate_Type__c == 'Per Kg')
                            unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c : 1);
                        if(lp.Rate_Type__c == 'Per TON')
                            unidades_calculadas = (record.Total_Weight_Kg2__c >0 ? record.Total_Weight_Kg2__c/1000 : 1);
                        if(lp.Rate_Type__c == 'Per M3')
                             unidades_calculadas = (record.Total_Volume_m3_2__c >0 ? record.Total_Volume_m3_2__c: 1); 
                        if(lp.Rate_Type__c == 'Per Container')
                        {
                            unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                            unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                           if(unidades_calculadas2 > unidades_calculadas)
                               unidades_calculadas = unidades_calculadas2; 
                           unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                        }
                        if(lp.Rate_Type__c == 'Per Pallet')
                        {
                            unidades_calculadas = (record.Total_Volume_m3_2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3_2__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                            unidades_calculadas2 = (record.Total_Weight_Kg2__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg2__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                           if(unidades_calculadas2 > unidades_calculadas)
                               unidades_calculadas = unidades_calculadas2; 
                           unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                        }
                          nueva_linea.Units__c = unidades_calculadas;
                          if(lp.Valid_Until__c != null)
                            nueva_linea.Valid_Until__c = lp.Valid_Until__c;
                        lista_de_lineas_fee.add(nueva_linea);    
                     }
                         
                }
            }
           unidades_calculadas = 1;
           unidades_calculadas2 = 1;
            
        }
        try
        {
            insert lista_de_lineas_fee;
            record.Service_Charges_Calculated__c = true;
            update record;
        }
        catch(Exception ex){}
    
  //  }
    return new PageReference('/'+record.Id);
  }
  

    
     public PageReference cancel()
    {   
        String returnUrl = '/'+record.Id; 
        PageReference pgReturnPage  = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
 
    }
}