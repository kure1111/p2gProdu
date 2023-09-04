trigger NEU_Update_IE_Total_Shipments_Services_BuySell_Amount on Shipment_Fee_Line__c (after insert, after update, after delete)
{
	if(NEU_StaticVariableHelper.getBoolean1())
		return; 
	
    Map<Id, decimal> buy_price_imp_exp = new Map<Id, decimal>();
    Map<Id, decimal> sell_price_imp_exp = new Map<Id, decimal>();
    Set<Id> listado_ids_import_export = new Set<Id>();
    decimal total_import_export_sell = 0;
    decimal total_import_export = 0;
    decimal total_import_export2 = 0;
    if(trigger.isInsert)
    {
        for(Shipment_Fee_Line__c sfl: trigger.new)
        {
            if(sfl.Import_Export_Quote__c != null && sfl.Units__c != null && ((sfl.Shipment_Buy_Price__c != null || sfl.Min_Amount__c != null) || ( sfl.Add_to_Quote__c == true && sfl.Sell_Amount__c != null) ))
            {
                listado_ids_import_export.add(sfl.Import_Export_Quote__c);
                
            }
        }
    }
    
    if(trigger.isUpdate)
    {
        for(Shipment_Fee_Line__c sfl: trigger.new)
        {
            Shipment_Fee_Line__c oldquote = Trigger.oldMap.get(sfl.Id);
            if((oldquote.Import_Export_Quote__c != sfl.Import_Export_Quote__c) || (oldquote.Shipment_Buy_Price__c != sfl.Shipment_Buy_Price__c) || (oldquote.Min_Amount__c != sfl.Min_Amount__c) || (oldquote.Units__c != sfl.Units__c) || oldquote.Add_to_Quote__c != sfl.Add_to_Quote__c  || oldquote.Sell_Amount__c  !=  sfl.Sell_Amount__c  )
            {
                listado_ids_import_export.add(sfl.Import_Export_Quote__c);
            }
        }
    }
    
    if(trigger.isDelete)
    {
        for(Shipment_Fee_Line__c sfl: trigger.old)
        {
            listado_ids_import_export.add(sfl.Import_Export_Quote__c);
        }
    }
    
    if(listado_ids_import_export != null && listado_ids_import_export.size()>0)
    {
        List<Shipment_Fee_Line__c> query_sfl =database.query('select Id, Name,'+(UserInfo.isMultiCurrencyOrganization()==true ? 'Import_Export_Quote__r.CurrencyIsoCode,CurrencyIsoCode,': '')+' Shipment_Buy_Price__c , Import_Export_Quote__r.Conversion_Rate_Date__c, Conversion_Rate_to_Currency_Header__c, Sell_Amount__c, Add_to_Quote__c, Import_Export_Quote__r.Shipments_Service_Lines_to_Add__c, Import_Export_Quote__r.Total_Shipments_Services_Sell_Amount__c,  Min_Amount__c, Import_Export_Quote__c, Units__c, Import_Export_Quote__r.Total_Shipments_Services_Buy_Amount__c from Shipment_Fee_Line__c where Import_Export_Quote__c IN: listado_ids_import_export and Import_Export_Quote__c != null order by Import_Export_Quote__c');
        
        date maximun_date_ie;
      	date minimun_date_ie;
      	Boolean filterByDate=false;
      	List<SObject>conversion=null;
      	
      	if(query_sfl != null && query_sfl.size()>0)
        {
        	for(Shipment_Fee_Line__c newo:query_sfl)
            {
            	 //buscar fechas maximas y minimas
		         if(maximun_date_ie == null)
		           maximun_date_ie = newo.Import_Export_Quote__r.Conversion_Rate_Date__c;
		         else if(maximun_date_ie < newo.Import_Export_Quote__r.Conversion_Rate_Date__c)
		           maximun_date_ie = newo.Import_Export_Quote__r.Conversion_Rate_Date__c;
		         if(minimun_date_ie == null)
		           minimun_date_ie = newo.Import_Export_Quote__r.Conversion_Rate_Date__c;
		         else if(minimun_date_ie> newo.Import_Export_Quote__r.Conversion_Rate_Date__c)
		           minimun_date_ie = newo.Import_Export_Quote__r.Conversion_Rate_Date__c;
            }
        }

        if(minimun_date_ie == null)
        {
            minimun_date_ie=Date.today();
            maximun_date_ie =Date.today();    
        }
        
        if(UserInfo.isMultiCurrencyOrganization())
        {
	        if(!Schema.getGlobalDescribe().containsKey('DatedConversionRate'))
	            conversion=database.query('select ConversionRate,IsoCode from CurrencyType where IsActive = true');
	        else
	        {
	            conversion=database.query('select ConversionRate, IsoCode, startDate, nextstartdate  from DatedConversionRate where StartDate <=: maximun_date_ie and nextstartdate >: minimun_date_ie');
	            filterByDate = true;
	        }
        }  
      
        
        List<Customer_Quote__c> list_to_update = new List<Customer_Quote__c>();
        string ie_anterior = '';
        Customer_Quote__c ie_obj_anterior;
        if(query_sfl != null && query_sfl.size()>0)
        {
            for(Shipment_Fee_Line__c sfl:query_sfl)
            {
                if(ie_anterior != '' && ie_anterior != sfl.Import_Export_Quote__c)
                {
                    ie_obj_anterior.Total_Shipments_Services_Buy_Amount__c = buy_price_imp_exp.get(ie_anterior);
                    ie_obj_anterior.Shipments_Service_Lines_to_Add__c = NEU_Utils.safedecimal(sell_price_imp_exp.get(ie_anterior));
                    list_to_update.add(ie_obj_anterior);
                }
                total_import_export = 0;
                total_import_export2 = 0;
                total_import_export_sell = 0;

                if(Neu_utils.safedecimal(sfl.Shipment_Buy_Price__c) >= 0)
                {
	                if(sfl.Shipment_Buy_Price__c != null && sfl.Units__c != null)
	                    total_import_export = sfl.Shipment_Buy_Price__c*sfl.Units__c;
	                if(sfl.Min_Amount__c != null && sfl.Shipment_Buy_Price__c != null && sfl.Shipment_Buy_Price__c != 0)
	                    total_import_export2  = sfl.Min_Amount__c;
	                if(total_import_export2  > total_import_export )
	                    total_import_export = total_import_export2;  
	                if(sfl.Add_to_Quote__c == true)
	                    total_import_export_sell = Neu_Utils.safedecimal(sfl.Sell_Amount__c);
                }
                else
                {
                	if(sfl.Shipment_Buy_Price__c != null && sfl.Units__c != null)
	                    total_import_export = sfl.Shipment_Buy_Price__c*sfl.Units__c;
	                if(sfl.Min_Amount__c != null && sfl.Shipment_Buy_Price__c != null && sfl.Shipment_Buy_Price__c != 0)
	                    total_import_export2  = - sfl.Min_Amount__c;
	                if(total_import_export2  < total_import_export )
	                    total_import_export = total_import_export2;  
	                if(sfl.Add_to_Quote__c == true)
	                    total_import_export_sell = Neu_Utils.safedecimal(sfl.Sell_Amount__c);
                }
                //conversion 
                String FromCurrencyIsoCode = NEU_CurrencyUtils.getCurrencyIsoCode(sfl);
                String ToCurrencyIsoCode = NEU_CurrencyUtils.getCurrencyIsoCode(sfl.Import_Export_Quote__r);
                Date conversionDate = sfl.Import_Export_Quote__r.Conversion_Rate_Date__c;
                
                Decimal Rate=1.0;
                if(UserInfo.isMultiCurrencyOrganization())
                {
	                if(FromCurrencyIsoCode!=ToCurrencyIsoCode)
		                if(conversion!=null)
		                {
		                  if(filterByDate)
		                  {
		                    if(conversionDate==null)
		                      conversionDate=Date.today();
		                      for(SObject c:conversion)
		                        if((((Date)c.get('startDate'))<=conversionDate)&&(((Date)c.get('nextstartdate'))>conversionDate))
		                          if(((String)c.get('IsoCode'))==ToCurrencyIsoCode)
		                            Rate=Rate*((Decimal)c.get('ConversionRate'));
		                        else if(((String)c.get('IsoCode'))==FromCurrencyIsoCode)
		                            Rate=Rate/((Decimal)c.get('ConversionRate'));
		                  }
		                  else
		                      for(SObject c:conversion)
		                      {
		                        if(((String)c.get('IsoCode'))==ToCurrencyIsoCode)
		                          Rate=Rate*((Decimal)c.get('ConversionRate'));
		                    else if(((String)c.get('IsoCode'))==FromCurrencyIsoCode)
		                              Rate=Rate/((Decimal)c.get('ConversionRate'));     
		                      }
		                }
                }
                
                //total_import_export = total_import_export*sfl.Conversion_Rate_to_Currency_Header__c;//-----mod esto
                if(neu_utils.safedecimal(total_import_export) != 0)
                	total_import_export = total_import_export*Rate;
                
                //total_import_export_sell = total_import_export_sell *sfl.Conversion_Rate_to_Currency_Header__c;
                if(neu_utils.safedecimal(total_import_export_sell) != 0)
                	total_import_export_sell = total_import_export_sell *Rate;
                //calculo del precio compra
                if(buy_price_imp_exp.containsKey(sfl.Import_Export_Quote__c))
                {
                    total_import_export += NEU_Utils.safedecimal(buy_price_imp_exp.get(sfl.Import_Export_Quote__c));
                    buy_price_imp_exp.put(sfl.Import_Export_Quote__c, total_import_export );
                }
                else
                {
                    buy_price_imp_exp.put(sfl.Import_Export_Quote__c, total_import_export );
                }   
                //calculo del pecio venta
                if(sfl.Add_to_Quote__c == true)
                {
                    if(sell_price_imp_exp.containsKey(sfl.Import_Export_Quote__c))
                    {
                        total_import_export_sell += NEU_Utils.safedecimal(sell_price_imp_exp.get(sfl.Import_Export_Quote__c));
                        sell_price_imp_exp.put(sfl.Import_Export_Quote__c, total_import_export_sell );
                    }
                    else
                    {
                        sell_price_imp_exp.put(sfl.Import_Export_Quote__c, total_import_export_sell );
                    } 
                }
                
                ie_anterior  = sfl.Import_Export_Quote__c;     
                ie_obj_anterior = sfl.Import_Export_Quote__r;      
            }
        }//si he borrado y no hay mas lineas vaciar valores
        else
        {
            List<Customer_Quote__c> query_ie = [select Id, Name from Customer_Quote__c where id in:listado_ids_import_export];
            for(Customer_Quote__c cq: query_ie )
            {
                cq.Total_Shipments_Services_Buy_Amount__c = null;
                cq.Shipments_Service_Lines_to_Add__c = null;
            }
            if(query_ie  != null && query_ie.size()>0)
                update query_ie;
        }
        
        if(ie_anterior != '' && ie_obj_anterior != null)
        {
           ie_obj_anterior.Total_Shipments_Services_Buy_Amount__c = NEU_Utils.safedecimal(buy_price_imp_exp.get(ie_anterior));
           ie_obj_anterior.Shipments_Service_Lines_to_Add__c = NEU_Utils.safedecimal(sell_price_imp_exp.get(ie_anterior));
           list_to_update.add(ie_obj_anterior); 
        }
        
        if(list_to_update != null && list_to_update.size()>0)
            update list_to_update;
    }   
}