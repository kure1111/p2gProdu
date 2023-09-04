trigger NEU_UpdateOutstandingBalanceAccount on Invoice__c (after delete, after insert, after update) 
{
    
    if(NEU_StaticVariableHelper.getBoolean1()){return;}        
    
    if(Test.isRunningTest() || !RecursiveCheck.triggerMonitor.contains('NEU_UpdateOutstandingBalanceAccount')){
             
        RecursiveCheck.triggerMonitor.add('NEU_UpdateOutstandingBalanceAccount');
        Set<Id>ids_account=new Set<Id>();
    	Set<Id>ids_invs =new Set<Id>();
    
        if (trigger.isDelete)
        {
            for(Invoice__c i : trigger.old)
            {
                ids_account.add(i.Account__c);
            }
        }
    
        if(trigger.isUpdate || trigger.isInsert)
        {
            for(Invoice__c iv : trigger.new)
            {
                ids_account.add(iv.Account__c);
                ids_invs.add(iv.id);
            }
        }
        
        system.debug('NEU_UpdateOutstandingBalanceAccount -> ids_account : ' + ids_account);
        
        List<Account> accounts = new List<Account>(); 
        String consulta_a = '';
        consulta_a += 'SELECT Id, Name, Total_Collection_Outstanding_Balance__c, Late_Outstanding_Payments__c';
        if(UserInfo.isMultiCurrencyOrganization())
            consulta_a += ' ,CurrencyISOCode';
        consulta_a += ' FROM Account'; 
        consulta_a += ' WHERE Id IN : ids_account';	
        accounts = Database.query(consulta_a);
        
        system.debug('NEU_UpdateOutstandingBalanceAccount -> consulta_a : ' + consulta_a);
        system.debug('NEU_UpdateOutstandingBalanceAccount -> accounts : ' + accounts);
        
        List<Invoice__c> invoices = new List<Invoice__c>(); 
        String consulta_inv = '';
        consulta_inv += 'SELECT Id, Name, Account__c, Date_of_Invoice__c, Collection_Outstanding_Balance__c, Payable_Before__c';
        if(UserInfo.isMultiCurrencyOrganization())
            consulta_inv += ' ,CurrencyISOCode';
        consulta_inv += ' FROM Invoice__c'; 
        consulta_inv += ' WHERE Id != null';
        consulta_inv += ' AND Date_of_Invoice__c != null' ;
        consulta_inv += ' AND Collection_Outstanding_Balance__c != 0' ;
        consulta_inv += ' AND Collection_Outstanding_Balance__c != null' ;
        consulta_inv += ' AND Account__c IN :accounts' ;
        consulta_inv += ' AND id IN :ids_invs' ;
        invoices = Database.query(consulta_inv);
        
        system.debug('NEU_UpdateOutstandingBalanceAccount -> consulta_inv : ' + consulta_inv);
        system.debug('NEU_UpdateOutstandingBalanceAccount -> invoices : ' + invoices);
        
        Map<Id,List<Invoice__c>> mapInvoices = new Map<Id,List<Invoice__c>>();
        for(Invoice__c inv :invoices)
        {
            if(mapInvoices.containsKey(inv.Account__c))
                mapInvoices.get(inv.Account__c).add(inv);
            else
                mapInvoices.put(inv.Account__c, new List<Invoice__c>{inv});
        }
        
        
        
        List<Account> accountsUpdate = new List<Account>();
        //Object that obtains the currencies of different date, from the min date of invoices to the maximum date of invoices
        NEU_CurrencyUtils neu_currencies = new NEU_CurrencyUtils(invoices, 'Date_of_Invoice__c');
        
        system.debug('NEU_UpdateOutstandingBalanceAccount -> neu_currencies : ' + neu_currencies);
        
        for(Account a: accounts)
        {
            List<Invoice__c> linv = new List<Invoice__c>(mapInvoices.get(a.Id));
            Decimal total_outstanding_balance = 0;
            Decimal late_Outstanding_Payments = 0;
            for(Invoice__c inv : linv)
            {
                //Calculates the conversion between two objects with different currencies
                
                system.debug('NEU_UpdateOutstandingBalanceAccount -> NEU_CurrencyUtils.getCurrencyIsoCode(a) : ' + NEU_CurrencyUtils.getCurrencyIsoCode(a));
                system.debug('NEU_UpdateOutstandingBalanceAccount -> NEU_CurrencyUtils.getCurrencyIsoCode(inv) : ' + NEU_CurrencyUtils.getCurrencyIsoCode(inv));
                system.debug('NEU_UpdateOutstandingBalanceAccount -> inv.Date_of_Invoice__c : ' + inv.Date_of_Invoice__c);
                
                Decimal factor_conversion =  neu_currencies.getConversionRate(NEU_CurrencyUtils.getCurrencyIsoCode(a), NEU_CurrencyUtils.getCurrencyIsoCode(inv), inv.Date_of_Invoice__c); 
                
                if(inv.Collection_Outstanding_Balance__c != null)
                {
                    total_outstanding_balance += (inv.Collection_Outstanding_Balance__c * factor_conversion);
                    
                    if(inv.Collection_Outstanding_Balance__c > 0 && inv.Payable_Before__c != null && inv.Payable_Before__c < system.today())
                        late_Outstanding_Payments += (inv.Collection_Outstanding_Balance__c * factor_conversion);   
                }     
            }
            a.Total_Collection_Outstanding_Balance__c = total_outstanding_balance;
            a.Late_Outstanding_Payments__c = late_Outstanding_Payments;
            accountsUpdate.add(a);
        }
        
        try
        {
            if(accountsUpdate.size()>0)
                update accountsUpdate;
        }catch(Exception ex){}
                                
    }
    
    /*if(test.isRunningTest())
    {
        string a = '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
        a= '';
    }*/
}