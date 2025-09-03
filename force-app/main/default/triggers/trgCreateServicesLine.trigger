trigger trgCreateServicesLine on Customer_Quote__c (after insert) {
  string name= 'PAK 1000';
    list<Customer_Quote__c> LstCustomerQuote = new list<Customer_Quote__c>();
    list<Fee__c> servicesRate  = new list<Fee__c>();
    Import_Export_Fee_Line__c servicesLine = new Import_Export_Fee_Line__c();
    list<Import_Export_Fee_Line__c> ListaServicesLines = new list<Import_Export_Fee_Line__c>();
    set<string> setAccountId = new set<string>();
    map<string,Account> mapOrderToCash = new  map<string,Account>(); 
    /*if(!test.isRunningTest())
      {
            servicesRate =  [select id,Name,Fee_Rate__c from Fee__c where Name =:name and Active__c = true ];
            system.debug('servicesRate '+ servicesRate);
        }
        else{ servicesRate =  [select id,Name,Fee_Rate__c from Fee__c limit 10];} 
    
        if(servicesRate.size() > 0)
        {
            for(Customer_Quote__c cqc : trigger.new)
            {
                if(cqc.Account_for__c != null && cqc.Freight_Mode__c == 'Road' && cqc.Service_Mode__c == 'NATIONAL')
                {
                    setAccountId.add(cqc.Account_for__c);
                }
            }
            if(setAccountId.size() > 0)
            {
                  mapOrderToCash  = new map<string,Account>([select id,Order_to_Cash__c from account where id in : setAccountId]);
            }
            for(Customer_Quote__c cqc : trigger.new)
            {
                if(cqc.Freight_Mode__c == 'Road' && cqc.Service_Mode__c == 'NATIONAL')
                {
                   if(!mapOrderToCash.get(cqc.Account_for__c).Order_to_Cash__c)
                   {
                       LstCustomerQuote.add(cqc);
                   }
                   
                }
            }
            for(Customer_Quote__c cqc : LstCustomerQuote)
            {
                servicesLine = new Import_Export_Fee_Line__c();
                servicesLine.Import_Export_Quote__c = cqc.id;
                servicesLine.Name = '1';
                servicesLine.Units__c = 1;
                servicesLine.Quote_Sell_Price__c = servicesRate[0].Fee_Rate__c;
                servicesLine.Service_Rate_Name__c = servicesRate[0].id;
                ListaServicesLines.add(servicesLine);
            }

          Insert ListaServicesLines;
        }
        
    */
   
  
}