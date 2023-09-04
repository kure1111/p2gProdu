global class NEU_UpdateBalanceAccount 
{
    public static void update_data()
    {
        try
        {
            List<Account> accounts = new List<Account>(); 
            String consulta_a = '';
            consulta_a += 'SELECT Id, Name, Total_Collection_Outstanding_Balance__c, Late_Outstanding_Payments__c';
            if(UserInfo.isMultiCurrencyOrganization())
                consulta_a += ' ,CurrencyISOCode';
            consulta_a += ' FROM Account'; 
            accounts = Database.query(consulta_a);

            List<Invoice__c> invoices = new List<Invoice__c>(); 
            String consulta_inv = '';
            consulta_inv += 'SELECT Id, Name, Account__c, Date_of_Invoice__c,Collection_Outstanding_Balance__c, Payable_Before__c';
            if(UserInfo.isMultiCurrencyOrganization())
                    consulta_inv += ' ,CurrencyISOCode';
            consulta_inv += ' FROM Invoice__c'; 
            consulta_inv += ' WHERE Account__c IN :accounts';
            consulta_inv += ' AND Date_of_Invoice__c != null' ;
            consulta_inv += ' AND Collection_Outstanding_Balance__c > 0' ;
            invoices = Database.query(consulta_inv);
                    
            Map<Id,List<Invoice__c>> mapInvoices = new Map<Id,List<Invoice__c>>();
            for(Invoice__c inv :invoices)
            {
                if(mapInvoices.containsKey(inv.Account__c))
                    mapInvoices.get(inv.Account__c).add(inv);
                else
                    mapInvoices.put(inv.Account__c, new List<Invoice__c>{inv});
            }
            List<Account> accountsUpdate = new List<Account>();
            
            for(Account a: accounts)
            {
                List<Invoice__c> linv = new List<Invoice__c>(mapInvoices.get(a.Id));
                Decimal total_outstanding_balance = 0;
                Decimal late_Outstanding_Payments = 0;
                for(Invoice__c inv : linv)
                {
                    Decimal factor_conversion = 1; 
                    Date dtIsoCode = inv.Date_of_Invoice__c;
                    //If the System is MultiCurrency OR Currency Account is NOT EQUAL than Currency Import/Export
                    if(UserInfo.isMultiCurrencyOrganization() && (NEU_CurrencyUtils.getCurrencyIsoCode(a) != NEU_CurrencyUtils.getCurrencyIsoCode(inv)))
                    {
                        List<SObject> query_conversion_rate_invoice = null;
                        List<SObject> query_conversion_rate_account = null;
                        
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
                        query_cr2 += ' AND Isocode = \'' + NEU_CurrencyUtils.getCurrencyIsoCode(a) + '\'';
                        query_cr2 += ' LIMIT 1';
                        query_conversion_rate_account = Database.query(query_cr2);
                    
                        //Account's ConversionRate is divided between Invoice's Conversion Rate because it's wanted to get the value of the Import/Export
                        if(query_conversion_rate_invoice != null && query_conversion_rate_account!=null)
                            factor_conversion = (Decimal)query_conversion_rate_account[0].get('ConversionRate')/(Decimal)query_conversion_rate_invoice[0].get('ConversionRate');
                    
                    }
                    if(inv.Collection_Outstanding_Balance__c != null)
                    {
                        total_outstanding_balance += (inv.Collection_Outstanding_Balance__c * factor_conversion);
                        
                        if(inv.Collection_Outstanding_Balance__c > 0 && inv.Payable_Before__c != null && inv.Payable_Before__c < system.today())
                           late_Outstanding_Payments += (inv.Collection_Outstanding_Balance__c * factor_conversion);   
                    }     
                }
                
                //The Account has Invoices, if only have one invoice is deleted, the trigger is already executed.
                if(linv.size() > 0)
                {
                    a.Total_Collection_Outstanding_Balance__c = total_outstanding_balance;
                    a.Late_Outstanding_Payments__c = late_Outstanding_Payments;
                    accountsUpdate.add(a);
                }
            }
            update accountsUpdate;  
            
        }
        catch(Exception ex)
        {
            NEU_UpdateBalanceAccount.sendMail(string.valueof(ex));
        }
    }
    
    
    public static void sendMail(string string_e)
    {
            List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{'jmanuel@neurored.com','oscar@neurored.com'});
            mail.setSenderDisplayName('NEURORED');
            mail.setSubject('Error Update Scheduler Balance Account');
            mail.setBccSender(false); 
            mail.setUseSignature(false); 
            mail.setCharset('UTF-8');
            mail.setPlainTextBody('Error: '+string_e);
            
            theEmails.add(mail);
            
            List<Messaging.Email> allMails = new List<Messaging.Email>();
            for(Integer j = 0; j < theEmails.size(); j++)
            {
                allMails.add(theEmails.get(j));
            }
            
            try
            {
                if (!Test.isRunningTest())
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
            }
            catch(Exception exc){}
    }
}