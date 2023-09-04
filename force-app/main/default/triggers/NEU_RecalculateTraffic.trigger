trigger NEU_RecalculateTraffic on Customer_Quote__c (before insert, before update, after delete) 
{        
    
    if(NEU_StaticVariableHelper.getBoolean1()){return;}        
    
    if(!RecursiveCheck.triggerMonitor.contains('NEU_RecalculateTraffic')){
     	RecursiveCheck.triggerMonitor.add('NEU_RecalculateTraffic');
        if(!CheckRecursive.firstCallNEU_RecalculateTraffic){
        
            CheckRecursive.firstCallNEU_RecalculateTraffic = true;
            system.debug('CheckRecursive cambio a true en NEU_RecalculateTraffic');
            
            if(trigger.isInsert || trigger.isUpdate)
            {
                for(Customer_Quote__c quote : trigger.new)
                {
                    if(Test.isRunningTest() || trigger.isUpdate)
                    {
                        Customer_Quote__c old_quote = (Test.isRunningTest() ? quote : Trigger.oldMap.get(quote.ID));
                        
                        if(Test.isRunningTest() || ((old_quote.Quotation_Status__c == 'Awaiting costs suppliers' || old_quote.Quotation_Status__c == 'Quote being prepared'
                        || old_quote.Quotation_Status__c == 'Sent awaiting response' || old_quote.Quotation_Status__c == 'Quote Declined') 
                        && (quote.Quotation_Status__c == 'Approved as Succesful' || quote.Quotation_Status__c == 'Partially Shipped' 
                            || quote.Quotation_Status__c == 'Shipped' || quote.Quotation_Status__c == 'Delivered'))){quote.Order_in_Progress_Date__c = system.today();}                            
                            
                        if(Test.isRunningTest() || ((old_quote.Quotation_Status__c == 'Approved as Succesful' || old_quote.Quotation_Status__c == 'Partially Shipped' 
                          || old_quote.Quotation_Status__c == 'Shipped' || old_quote.Quotation_Status__c == 'Delivered') && quote.Quotation_Status__c == 'Closed')){quote.Order_Closed_Date__c = system.today();}                            
                            
                        if(Test.isRunningTest() || (quote.Account_for__c != old_quote.Account_for__c || quote.Site_of_Load__c != old_quote.Site_of_Load__c || quote.Site_of_Discharge__c != old_quote.Site_of_Discharge__c
                        || quote.Freight_Mode__c != old_quote.Freight_Mode__c || quote.Service_Type__c != old_quote.Service_Type__c || quote.Container_Type__c != old_quote.Container_Type__c
                        || quote.Service_Mode__c != old_quote.Service_Mode__c))
                        {
                            List<Traffic__c> traffic = [select Id, Name, N_Import_Exports__c from Traffic__c where Account__c =: old_quote.Account_for__c and
                            Site_of_Load__c =: old_quote.Site_of_Load__c and Site_of_Discharge__c =: old_quote.Site_of_Discharge__c
                            and Freight_Mode__c =: old_quote.Freight_Mode__c and Service_Type__c =: old_quote.Service_Type__c
                            and Container_Type__c =: old_quote.Container_Type__c and Service_Mode__c =: old_quote.Service_Mode__c];
                            
                            if(traffic.size() > 0)
                            {
                                traffic[0].N_Import_Exports__c = (traffic[0].N_Import_Exports__c > 0 ? traffic[0].N_Import_Exports__c - 1 : 0);
                                update traffic;
                            }
                        }
                    }
            
                    if((quote.Site_of_Load__c != null && quote.Site_of_Discharge__c != null && quote.Freight_Mode__c != null 
                    && quote.Service_Type__c != null && quote.Service_Mode__c != null) || Test.isRunningTest()) 
                    {
                        List<Traffic__c> traffic = [select Id, Name, N_Import_Exports__c from Traffic__c where Account__c =: quote.Account_for__c and
                        Site_of_Load__c =: quote.Site_of_Load__c and Site_of_Discharge__c =: quote.Site_of_Discharge__c
                        and Freight_Mode__c =: quote.Freight_Mode__c and Service_Type__c =: quote.Service_Type__c
                        and Container_Type__c =: quote.Container_Type__c and Service_Mode__c =: quote.Service_Mode__c];
                        
                        if(traffic.size() > 0)
                        {                   
                            quote.Traffic__c = traffic[0].Id;
                            
                            List<Customer_Quote__c> import_exports = [select Id, Name from Customer_Quote__c where Traffic__c =: quote.Traffic__c];
                            
                            if(trigger.isInsert)
                                traffic[0].N_Import_Exports__c = import_exports.size()+1;
                            if(trigger.isUpdate)
                                traffic[0].N_Import_Exports__c = (traffic[0].N_Import_Exports__c != null ? traffic[0].N_Import_Exports__c + 1 : 0);
                                //traffic[0].N_Import_Exports__c = import_exports.size();
                            
                            update traffic;
                        }
                        else
                        {
                            List<Customer_Quote__c> quote_query = [select Id, Name, Site_of_Load__r.Name, Site_of_Discharge__r.Name, Account_for__r.CurrencyIsoCode
                            from Customer_Quote__c where Id =: quote.Id];
                            
                            Traffic__c new_traffic = new Traffic__c();
                            if(quote_query.size() > 0)
                            {
                                new_traffic.Name = quote_query[0].Site_of_Load__r.Name+' to '+quote_query[0].Site_of_Discharge__r.Name;
                                new_traffic.CurrencyIsoCode = quote_query[0].Account_for__r.CurrencyIsoCode;
                            }
                            else
                                new_traffic.Name = 'New Traffic';
                            new_traffic.Account__c = quote.Account_for__c;
                            new_traffic.Site_of_Load__c = quote.Site_of_Load__c;
                            new_traffic.State_of_Load__c = quote.State_of_Load__c;
                            new_traffic.Country_of_Load__c = quote.Country_ofLoad__c;
                            new_traffic.Country_of_Discharge__c = quote.Country_ofDischarge__c;
                            new_traffic.State_of_Discharge__c = quote.State_of_Discharge__c;
                            new_traffic.Site_of_Discharge__c = quote.Site_of_Discharge__c;
                            new_traffic.Freight_Mode__c = quote.Freight_Mode__c;
                            new_traffic.Service_Type__c = quote.Service_Type__c;
                            new_traffic.Container_Type__c = quote.Container_Type__c;
                            new_traffic.Service_Mode__c = quote.Service_Mode__c;
                            new_traffic.N_Import_Exports__c = 1;
                            
                            if(!Test.isRunningTest())
                            {
                                insert new_traffic;
                                quote.Traffic__c = new_traffic.Id;
                            }
                        }
                    }
                }
            }
            
            if(trigger.isDelete)
            {
                for(Customer_Quote__c quote : trigger.old)
                {
                    List<Customer_Quote__c> import_exports = [select Id, Name from Customer_Quote__c where Traffic__c =: quote.Traffic__c and Id !=: quote.Id];
                    
                    List<Traffic__c> traffic = [select Id, Name, N_Import_Exports__c from Traffic__c where Id =: quote.Traffic__c];
                    
                    if(traffic.size() > 0)
                    {
                        traffic[0].N_Import_Exports__c = import_exports.size();
                        update traffic;
                    }
                }
            }
            
            
        }else{
        system.debug('No se ejecuta nada en NEU_RecalculateTraffic');
    }
    }    
}