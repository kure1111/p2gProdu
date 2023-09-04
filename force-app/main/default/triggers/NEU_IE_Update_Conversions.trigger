trigger NEU_IE_Update_Conversions on Customer_Quote__c (after update) 
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;

        NEU_CurrencyUtils.headerAfterUpdate(new String[]{'Quote_Item_Line__c','Import_Export_Fee_Line__c'},new String[]{'Import_Export_Quote__c','Import_Export_Quote__c'},trigger.new,trigger.newMap,trigger.oldMap);
      
      
        Set<Id>ieids=new Set<Id>();
        for(Customer_Quote__c ie:trigger.new)
        {
            Customer_Quote__c oldie=trigger.oldMap.get(ie.Id);
            if((NEU_CurrencyUtils.getCurrencyIsoCode(oldie) != NEU_CurrencyUtils.getCurrencyIsoCode(ie)) || Test.isRunningTest())
                ieids.add(ie.Id);
        }
        
        if(ieids != null && ieids.size()>0)
        {
                    
            List<Invoice__c> query_invoice = new List<Invoice__c>(); 
            String consulta_inv = '';
            consulta_inv += 'SELECT Id, Name, Date_of_Invoice__c, CreatedDate';
            consulta_inv += ' ,Conversion_Rate_to_Imp_Exp_Currency__c';
            if(UserInfo.isMultiCurrencyOrganization())
            {
                consulta_inv += ' ,Import_Export_Quote_Order__r.CurrencyISOCode';
                consulta_inv += ' ,CurrencyISOCode';
            }
            consulta_inv += ' FROM Invoice__c'; 
            consulta_inv += ' WHERE Import_Export_Quote_Order__c IN : ieids';
            consulta_inv += ' AND Date_of_Invoice__c != null' ;
            query_invoice = Database.query(consulta_inv);
            
            
            for(Invoice__c inv: query_invoice )
            {
                Date dtIsoCode = inv.Date_of_Invoice__c;
            
                //If the System is MultiCurrency OR Currency Invoice is equal than Currency Import/Export   
               if(!UserInfo.isMultiCurrencyOrganization() || (NEU_CurrencyUtils.getCurrencyIsoCode(inv.Import_Export_Quote_Order__r) == NEU_CurrencyUtils.getCurrencyIsoCode(inv)))
                    inv.Conversion_Rate_to_Imp_Exp_Currency__c = 1;
                else
                {
                    List<SObject> query_conversion_rate_invoice = null;
                    List<SObject> query_conversion_rate_import_export = null;
                    
                    String query_cr1 = '';
                    query_cr1 += 'SELECT ConversionRate';
                    query_cr1 += ' FROM DatedConversionRate'; 
                    query_cr1 += ' WHERE startDate <=: dtIsoCode AND nextstartdate > :dtIsoCode';
                    query_cr1 += ' AND Isocode = \'' + NEU_CurrencyUtils.getCurrencyIsoCode(inv) + '\'';
                    query_cr1 += ' LIMIT 1';
                    query_conversion_rate_invoice = Database.query(query_cr1);
                                            
                    String query_cr2 = '';
                    query_cr2 += 'SELECT ConversionRate';
                    query_cr2 += ' FROM DatedConversionRate'; 
                    query_cr2 += ' WHERE startDate <=:dtIsoCode AND nextstartdate > :dtIsoCode';
                    query_cr2 += ' AND Isocode = \'' + NEU_CurrencyUtils.getCurrencyIsoCode(inv.Import_Export_Quote_Order__r) + '\'';
                    query_cr2 += ' LIMIT 1';
                    query_conversion_rate_import_export = Database.query(query_cr2);
                
                    //Import/Export's ConversionRate is divided between Invoice's Conversion Rate because it's wante to get the value of the Import/Export
                    if(query_conversion_rate_invoice != null && query_conversion_rate_import_export!=null)
                        inv.Conversion_Rate_to_Imp_Exp_Currency__c = (Decimal)query_conversion_rate_import_export[0].get('ConversionRate')/(Decimal)query_conversion_rate_invoice[0].get('ConversionRate');
                }
            }
            if(query_invoice != null && query_invoice.size()>0)
                update query_invoice;
                
        }

}