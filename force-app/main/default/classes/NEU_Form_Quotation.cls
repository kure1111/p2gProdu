public class NEU_Form_Quotation {

    public Fee__c record{get;set;}
    public String currency_selected{get;set;}
    public List<SelectOption> currencys {get; set;}
    public String id_fee_selected {get;set;}
    public String name_fee_selected {get;set;}
    private List<SelectOption> listado_rate_type=null;
    public String numero_contenedores{get;set;}
    public String shipment_service_type{get;set;}  
    public List<Chatter_Feed_Guest_User__c> list_to_insert_chatter = null;
    public List<Fee__c> query_fee = null;
    public string id_contact = '';
    public string id_fee = '';
    public List<Quote_Item_Line__c> list_to_IE_cargo_lines {get;set;}//Import-Export Cargo Line
    public Boolean error {get;set;}//Use this variable for to not renderize when exist something error
    
    public  List<SelectOption> getlistado_rate_type()
    {
        if(listado_rate_type==null)
        {
            listado_rate_type=null;
            listado_rate_type=new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Fee__c.Rate_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            boolean ya_existe = false;
            listado_rate_type.add(new SelectOption('',''));
        
            for( Schema.PicklistEntry f : ple)
                listado_rate_type.add(new SelectOption(f.getValue(),f.getValue()));
            
        }
        return listado_rate_type;
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
    
    public NEU_Form_Quotation()
    {   
        if(apexpages.currentpage().getparameters().get('id') != null)
        {
            try
            {
                  //Get Ids for URL, separate for Substring
                  //Example NEU_Form_Quotation?id=aa0V9E0000008lfsUAA############0010Y00000DnnFfQAJ############0030Y00000AvkXSQAZ############
                  //https://c.cs88.visual.force.com/apex/NEU_Form_Quotation?id=YTBWMFkwMDAwMDExMWdoIyMjIyMjIyMjIyMjIyMjMDAxMFkwMDAwMEVpaFVQIyMjIyMjIyMjIyMjIyMjMDAzMFkwMDAwMEF3NmJoIyMjIyMjIyMjIyMjIyMj
                  //New configuration por URL with # 30 positions for each id based to AutoNumber Documentacion Salesforce https://help.salesforce.com/articleView?id=custom_field_types.htm&type=0
                  
                  string idsEncode = apexpages.currentpage().getparameters().get('id');//Encode
                  //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'El id codificado en base64 es: '+idsEncode));
                  
                  Blob url = EncodingUtil.base64Decode(idsEncode);
                  string ids = url.tostring();
                  //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'El identificador decodificado es: '+ids));
                  //Get Id of Service Rate (1ST of URL)
                  //string id_fee = ids.substring(0, 15);
                  id_fee = ids.substring(0, 30).replace('#','');
                  //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'El id_fee es: '+id_fee));
                  //Get Id of Service Rate's Carrier (3ST of URL)
                  string id_carrier = ids.substring(30, 60).replace('#','');
                  //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'El id_carrier es: '+id_carrier));
                  //Get Id of Contact's Carrier (2ST of URL)
                  id_contact = ids.substring(60, ids.length()).replace('#','');
                  //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'El id_contact es: '+id_contact));
             
                 //Execute process only if id_fee and id_carrier not null or empty
                 error = false;
                 if(!String.isEmpty(id_fee) && !String.isEmpty(id_fee))
                 {
                      //Process
                      numero_contenedores = '';
                      shipment_service_type = '';  
                      query_fee = [select id, Name, Account_for__c, Fee__c, Active__c,
                      Applicable_to_Purchase_Incoterms__c, Applicable_to_Sales_Incoterms__c, Shipments_Program_Quoted_Marketplace__r.Number_of_Containers__c,
                      Buy_Rate__c, Carrier_Account__c, Container_Type__c, Carrier_Account__r.Name, Container_Type__r.Name, Country_of_Discharge__c, Import_Export_Quoted_Marketplace__r.Service_Type__c, Country_of_Load__c,
                      Fuel__c, Fuel_Over__c, Import_Export_Quoted_Marketplace__c, Import_Export_Quoted_Marketplace__r.Name, Import_Export_Quoted_Marketplace__r.Container_Count__c, Marketplace_Ranking__c,
                      Master_Allocation__c, Max_Kgs__c, Max_M3__c, Min__c, Quoted__c, Normal__c, Pallet_Type__c, Pallet_Type__r.Name, Delivery_Zone__c, Delivery_Zone__r.Name,
                      Port_Airport__c, Port_Airport__r.Name, Fee_Category__c,Comments__c, LOT_Url__c, LOT__c, Fee_Description__c, Rate_Type__c, Risk__c, Risk_Over__c, Route__c, Route__r.Name, Shipment_Quoted_Marketplace__r.N_Containers__c,
                      Fee_Rate__c, Shipment_Quoted_Marketplace__c, Shipment_Quoted_Marketplace__r.Name, Shipments_Program_Quoted_Marketplace__c, Shipments_Program_Quoted_Marketplace__r.Name,
                      Port_Airport_of_Discharge__c, Port_Airport_of_Load__c, Standard_Rate__c, Sub_Allocation__c, Taxable_Item__c, Shipment_Quoted_Marketplace__r.Service_Type__c,
                      TT_Days__c, Valid_From__c, Valid_Until__c, VAT_Column__c, Via__c, Volumetric_Factor__c from Fee__c where id=: id_fee and Carrier_Account__c =: id_carrier];
                      //Check that query has records
                      if(query_fee.size()>0)
                      {
                          record = query_fee[0];
                          id_fee_selected = query_fee[0].Id;
                          list_to_insert_chatter = new List<Chatter_Feed_Guest_User__c>();
                          //crear chat en el fee
                          Chatter_Feed_Guest_User__c new_insert_chatter = new Chatter_Feed_Guest_User__c();
                          new_insert_chatter.Feed_Text__c = query_fee[0].Carrier_Account__r.Name+' have quotation for '+query_fee[0].Name;
                          new_insert_chatter.Record_Id__c = id_fee;
                          list_to_insert_chatter.add(new_insert_chatter);
                          Chatter_Feed_Guest_User__c new_insert_chatter2 = new Chatter_Feed_Guest_User__c();
                          new_insert_chatter2.Feed_Text__c = query_fee[0].Carrier_Account__r.Name+' have quotation for '+query_fee[0].Name;
                          
                          name_fee_selected = query_fee[0].Name;
                          
                          if(query_fee[0].Shipment_Quoted_Marketplace__c != null)
                          {
                            if(query_fee[0].Shipment_Quoted_Marketplace__r.N_Containers__c != null)
                              numero_contenedores = string.valueof(query_fee[0].Shipment_Quoted_Marketplace__r.N_Containers__c);
                            if(query_fee[0].Shipment_Quoted_Marketplace__r.Service_Type__c != null)
                              shipment_service_type = string.valueof(query_fee[0].Shipment_Quoted_Marketplace__r.Service_Type__c); 
                            new_insert_chatter2.Record_Id__c = query_fee[0].Shipment_Quoted_Marketplace__c;
                            list_to_insert_chatter.add(new_insert_chatter2); 
                          }
                          
                          if(query_fee[0].Import_Export_Quoted_Marketplace__c != null)
                          {
                            if(query_fee[0].Import_Export_Quoted_Marketplace__r.Container_Count__c != null)
                              numero_contenedores =string.valueof(query_fee[0].Import_Export_Quoted_Marketplace__r.Container_Count__c);
                            if(query_fee[0].Import_Export_Quoted_Marketplace__r.Service_Type__c != null)
                              shipment_service_type =string.valueof(query_fee[0].Import_Export_Quoted_Marketplace__r.Service_Type__c);  
                            new_insert_chatter2.Record_Id__c = query_fee[0].Import_Export_Quoted_Marketplace__c;
                            list_to_insert_chatter.add(new_insert_chatter2);
                          }
                          
                          if(query_fee[0].Shipments_Program_Quoted_Marketplace__c != null)
                          {
                            if(query_fee[0].Shipments_Program_Quoted_Marketplace__r.Number_of_Containers__c != null)
                              numero_contenedores =string.valueof(query_fee[0].Shipments_Program_Quoted_Marketplace__r.Number_of_Containers__c); 
                            //new_insert_chatter2.Record_Id__c = query_fee[0].Shipments_Program_Quoted_Marketplace__c;   
                          }
                      
                      
                      
                          currency_selected = NEU_CurrencyUtils.getCurrencyIsoCode(record);
                          currencys = new List<SelectOption>(); 
                          if(UserInfo.isMultiCurrencyOrganization()== true)
                          {
                               for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
                               {
                                      currencys.add(new SelectOption(lu,lu)); 
                               }
                          }
                          else
                             currencys.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));
                             
                         //Read to Import-Export Cargo Line of Service Rate
                         if(!String.isEmpty(record.Import_Export_Quoted_Marketplace__c))
                         {
                            list_to_IE_cargo_lines = [select Name, Item_Name__c, Item_Name__r.Name, Units__c, Unit_of_measure__c,  Total_Shipping_Volume_m3__c, Total_Shipping_Weight_Kgs__c 
                            from Quote_Item_Line__c where Import_Export_Quote__c = :record.Import_Export_Quoted_Marketplace__c];
                         }
                         
                     }else{
                        error = true;
                     }
                     
                     
                 }else{
                    error = true;
                 }
                 
            }
           catch(Exception ex)
           {
              //ids are null or empty
              error = true;
           }
        }
        else
        {
            //Don't exist ids   
            error = true;
        }
        //If there is an error, the forms show it to the user
        if(error)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Identifier could not be obtained Service Rate Detail'));
        }
    }
    
    
    public void send_form()
    {
       try
       {     
          NEU_CurrencyUtils.setCurrencyIsoCode(record,currency_selected);
          if(record.Id != null)
          {
            id_fee_selected = record.Id;
            name_fee_selected = record.Name;
            record.Quoted__c = true;
            //List<Fee__c> listado_de_fees_shipment = [select Id, Name,  Rate_Type__c  from Fee__c where Id =:record.Id];
            //if(listado_de_fees_shipment.size()>0 && record.Rate_Type__c == listado_de_fees_shipment[0].Rate_Type__c)
                update record;
            /*else//----de momento no se crea ninguno nuevo
            {
                if(listado_de_fees_shipment.size()>0 && record.Rate_Type__c != listado_de_fees_shipment[0].Rate_Type__c)
                {
                    Fee__c newrecord=record.clone(false,true);
                    newrecord.Rate_Type__c = record.Rate_Type__c;
                    string nombre_introducido =  record.Name;
                    insert newrecord;
                    if(nombre_introducido != null && nombre_introducido != '')
                    {
                        record.Name = nombre_introducido;
                        update record;
                    }
                    id_fee_selected = newrecord.Id;
                    name_fee_selected = newrecord.Name;
                    record = newrecord;
                }
            }*/
         }
         
         if(record.Active__c == true)
         {
            //crear registro en chatter
            if(list_to_insert_chatter != null && list_to_insert_chatter.size()>0)
                insert list_to_insert_chatter;
            //update task to complete
            if(query_fee != null && query_fee.size()>0 && string.isnotempty(id_contact) == true && string.isnotempty(id_fee) == true)
            {
                
                if(query_fee[0].Import_Export_Quoted_Marketplace__c != null)
                {
                    List<Task> query_task = [select Id, Status from Task where  Status =: 'Waiting for the Supplier Quote' and WhatId =: query_fee[0].Import_Export_Quoted_Marketplace__c and Send_Emails__c =: true and WhoId =: id_contact and Service_Rate__c =: id_fee];
                    if(query_task != null && query_task.size()>0)// and
                    {
                        query_task[0].Status = 'Completed';
                        update query_task[0]; 
                    }
                }
            }
            
         }
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Your Quotation is registered in our system.'));
         
       }
       catch(Exception ex)
       {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex.getMessage()));
         return;
       }
   }
}