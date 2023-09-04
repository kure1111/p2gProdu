public with sharing class NEU_Standard_Fee_Calculation_Shipment {

 public Shipment__c record = null;

  
     public NEU_Standard_Fee_Calculation_Shipment(ApexPages.StandardController stdController) {
         
            if (!Test.isRunningTest()) {
            stdController.AddFields(new String[]
                {
                  'Id', 'Name','Route__c', 
                  'Site_of_Discharge__c','Site_of_Load__c', 
                  'Pickup_Cartage__c', 'Supplier_Account__c',
                  'Sales_Incoterm__c','Delivery_Cartage__c','Purchase_Incoterm__c',
                  'Country_of_Load__c','Country_of_Discharge__c',
                  'Total_Volume_m3__c', 'Total_Weight_Kg__c' 
                });
            }
            record=(Shipment__c)stdController.getRecord();
     }
  
  public Pagereference crear_fee_estandar()
  {
    //if(record.Carrier_Line_Load_Point__c != null)
    //{
        List<Shipment_Fee_Line__c> lista_de_fees_standar = [select Id, Service_Rate_Name__r.Standard_Rate__c from Shipment_Fee_Line__c where Shipment__c =: record.Id and Service_Rate_Name__r.Standard_Rate__c =:true];
        if(lista_de_fees_standar.size()>0)
        {
            try
            {
                delete lista_de_fees_standar;
            }
            catch(Exception ex){}
        }
        
        lista_de_fees_standar = [select Id from Shipment_Fee_Line__c where Shipment__c=: record.Id ];
        decimal total_lineas = lista_de_fees_standar.size();
        decimal total_fee_rate_peso = 0;
        decimal total_fee_rate_volumen = 0;
        
         decimal unidades_calculadas = 1;
         decimal unidades_calculadas2 = 1;
            
        List<Shipment_Fee_Line__c> lista_de_lineas_fee = new List<Shipment_Fee_Line__c>();
        
        List<Fee__c> lista_fees_standar = Database.query('select Id, Port_Airport__c, '+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+'  Container_Type__r.Cargo_Weight_Kg__c, Applicable_to_Purchase_Incoterms__c, Applicable_to_Sales_Incoterms__c,  Container_Type__r.Cargo_Volume_m3__c,        Pallet_Type__r.Cargo_Weight_Kg__c,Pallet_Type__r.Cargo_Volume_m3__c,Pallet_Type__c,         Route__c, Rate_Type__c, Delivery_Zone__c, Account_for__c, RecordTypeId, Port_Airport__r.Name, Container_Type__c,         Fee_Rate__c from Fee__c where Standard_Rate__c = true and Active__c = true');
         
        for(Fee__c lp : lista_fees_standar)
        {
            if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Local Transport').getRecordTypeId())
            { 
                  if((record.Site_of_Load__c != null || record.Site_of_Discharge__c != null  ) 
                  && (lp.Port_Airport__c != null && record.Site_of_Load__c != lp.Port_Airport__c && record.Site_of_Discharge__c != lp.Port_Airport__c 
                  ))  
                    continue;
                  
                  if((record.Pickup_Cartage__c != null || record.Delivery_Cartage__c != null) && record.Pickup_Cartage__c != lp.Delivery_Zone__c && record.Delivery_Cartage__c != lp.Delivery_Zone__c  && lp.Delivery_Zone__c != null)
                    continue;  
                    
                 // if(record.Supplier_Account__c != null && record.Supplier_Account__c != lp.Account_for__c && lp.Account_for__c != null)
                 //   continue;
                    
                   if(lp.Applicable_to_Purchase_Incoterms__c != null)
                     if(record.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(record.Purchase_Incoterm__c))
                           continue;
                              
                  if(lp.Applicable_to_Sales_Incoterms__c != null)
                      if(record.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(record.Sales_Incoterm__c))
                           continue;
                      
                 Shipment_Fee_Line__c nueva_linea = new Shipment_Fee_Line__c();
                 total_lineas ++;
                 nueva_linea.Name =string.valueof(total_lineas);
                
                 while(nueva_linea.Name.length()>2) 
                    nueva_linea.Name = '0'+nueva_linea.Name;
                 
                 nueva_linea.Service_Rate_Name__c = lp.Id;
                 nueva_linea.Shipment__c = record.Id;
                 nueva_linea.Shipment_Buy_Price__c = lp.Fee_Rate__c;
                 nueva_linea.Shipment_Sell_Price__c = lp.Fee_Rate__c;
                // nueva_linea.CurrencyIsoCode = lp.CurrencyIsoCode;
                NEU_CurrencyUtils.setCurrencyIsoCode(nueva_linea ,NEU_CurrencyUtils.getCurrencyIsoCode(lp));
                 if(lp.Rate_Type__c == 'Per Kg')
                    unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c : 1);
                if(lp.Rate_Type__c == 'Per TON')
                    unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/1000 : 1);
                if(lp.Rate_Type__c == 'Per M3')
                     unidades_calculadas = (record.Total_Volume_m3__c >0 ? record.Total_Volume_m3__c: 1); 
                if(lp.Rate_Type__c == 'Per Container')
                {
                    unidades_calculadas = (record.Total_Volume_m3__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                    unidades_calculadas2 = (record.Total_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                   if(unidades_calculadas2 > unidades_calculadas)
                       unidades_calculadas = unidades_calculadas2; 
                   unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                }
                if(lp.Rate_Type__c == 'Per Pallet')
                {
                    unidades_calculadas = (record.Total_Volume_m3__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                    unidades_calculadas2 = (record.Total_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                   if(unidades_calculadas2 > unidades_calculadas)
                       unidades_calculadas = unidades_calculadas2; 
                   unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                }
                nueva_linea.Units__c = unidades_calculadas;
                lista_de_lineas_fee.add(nueva_linea);  
                    
            }
            else
            {
                if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId())
                {
                  if(record.Route__c == null || lp.Route__c == null || record.Route__c == lp.Route__c)
                  {
                      if(lp.Applicable_to_Purchase_Incoterms__c != null)
                         if(record.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(record.Purchase_Incoterm__c))
                           continue;
                              
                      if(lp.Applicable_to_Sales_Incoterms__c != null)
                          if(record.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(record.Sales_Incoterm__c))
                           continue;
                    
                     Shipment_Fee_Line__c nueva_linea = new Shipment_Fee_Line__c();
                     total_lineas ++;
                     nueva_linea.Name =string.valueof(total_lineas);
                  
                     while(nueva_linea.Name.length()>2)
                        nueva_linea.Name = '0'+nueva_linea.Name;
                     
                     nueva_linea.Service_Rate_Name__c = lp.Id;
                     nueva_linea.Shipment__c = record.Id;
                     nueva_linea.Shipment_Buy_Price__c = lp.Fee_Rate__c;
                     nueva_linea.Shipment_Sell_Price__c = lp.Fee_Rate__c;
                     // nueva_linea.CurrencyIsoCode = lp.CurrencyIsoCode;
                      NEU_CurrencyUtils.setCurrencyIsoCode(nueva_linea ,NEU_CurrencyUtils.getCurrencyIsoCode(lp));
                    if(lp.Rate_Type__c == 'Per Kg')
                        unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c : 1);
                    if(lp.Rate_Type__c == 'Per TON')
                        unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/1000 : 1);
                    if(lp.Rate_Type__c == 'Per M3')
                         unidades_calculadas = (record.Total_Volume_m3__c >0 ? record.Total_Volume_m3__c : 1); 
                    if(lp.Rate_Type__c == 'Per Container')
                    {
                        unidades_calculadas = (record.Total_Volume_m3__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                       if(unidades_calculadas2 > unidades_calculadas)
                           unidades_calculadas = unidades_calculadas2; 
                       unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                    }        
                    if(lp.Rate_Type__c == 'Per Pallet')
                    {
                        unidades_calculadas = (record.Total_Volume_m3__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                        unidades_calculadas2 = (record.Total_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                       if(unidades_calculadas2 > unidades_calculadas)
                           unidades_calculadas = unidades_calculadas2; 
                       unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                    }
                     nueva_linea.Units__c = unidades_calculadas;
                     lista_de_lineas_fee.add(nueva_linea);   
                  }
                }
                else
                {
                     if(lp.RecordTypeId == Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId())
                     {
                          if(lp.Applicable_to_Purchase_Incoterms__c != null)
                             if(record.Purchase_Incoterm__c != null && !lp.Applicable_to_Purchase_Incoterms__c.contains(record.Purchase_Incoterm__c))
                                   continue;
                                      
                          if(lp.Applicable_to_Sales_Incoterms__c != null)
                              if(record.Sales_Incoterm__c != null && !lp.Applicable_to_Sales_Incoterms__c.contains(record.Sales_Incoterm__c))
                                   continue;
                        
                        Shipment_Fee_Line__c nueva_linea = new Shipment_Fee_Line__c();
                         total_lineas ++;
                         nueva_linea.Name =string.valueof(total_lineas);

                         while(nueva_linea.Name.length()>2)
                            nueva_linea.Name = '0'+nueva_linea.Name;
                         
                         nueva_linea.Service_Rate_Name__c = lp.Id;
                         nueva_linea.Shipment__c = record.Id;
                         nueva_linea.Shipment_Buy_Price__c = lp.Fee_Rate__c;
                         nueva_linea.Shipment_Sell_Price__c = lp.Fee_Rate__c;
                         //nueva_linea.CurrencyIsoCode = lp.CurrencyIsoCode;
                         NEU_CurrencyUtils.setCurrencyIsoCode(nueva_linea ,NEU_CurrencyUtils.getCurrencyIsoCode(lp));
                         if(lp.Rate_Type__c == 'Per Kg')
                            unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c : 1);
                        if(lp.Rate_Type__c == 'Per TON')
                            unidades_calculadas = (record.Total_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/1000 : 1);
                        if(lp.Rate_Type__c == 'Per M3')
                             unidades_calculadas = (record.Total_Volume_m3__c >0 ? record.Total_Volume_m3__c: 1); 
                        if(lp.Rate_Type__c == 'Per Container')
                        {
                            unidades_calculadas = (record.Total_Volume_m3__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3__c/lp.Container_Type__r.Cargo_Volume_m3__c : 1);
                            unidades_calculadas2 = (record.Total_Weight_Kg__c >0 && lp.Container_Type__c != null && lp.Container_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/lp.Container_Type__r.Cargo_Weight_Kg__c : 1);
                           if(unidades_calculadas2 > unidades_calculadas)
                               unidades_calculadas = unidades_calculadas2; 
                           unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                        }
                        if(lp.Rate_Type__c == 'Per Pallet')
                        {
                            unidades_calculadas = (record.Total_Volume_m3__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Volume_m3__c >0 ? record.Total_Volume_m3__c/lp.Pallet_Type__r.Cargo_Volume_m3__c : 1);
                            unidades_calculadas2 = (record.Total_Weight_Kg__c >0 && lp.Pallet_Type__c != null && lp.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? record.Total_Weight_Kg__c/lp.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
                           if(unidades_calculadas2 > unidades_calculadas)
                               unidades_calculadas = unidades_calculadas2; 
                           unidades_calculadas = unidades_calculadas.round(System.RoundingMode.UP);
                        }
                          nueva_linea.Units__c = unidades_calculadas;
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
            update record;
        }
        catch(Exception ex){}
   // }
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