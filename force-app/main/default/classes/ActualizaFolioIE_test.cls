@isTest
private class ActualizaFolioIE_test {

    static testMethod void ActualizaFolioIE_test () //ok
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Terms__c = '15 days';
        insert account_test;
        list<Customer_Quote__c> lista = new list<Customer_Quote__c>();
        lista.add(CrearQuote('Sea','IMPORT','FTL',account_test.Id));
               
        test.startTest();
         insert lista;
        test.stopTest();
    }
    static testMethod void ActualizaFolioIE_test2 () //ok
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Terms__c = '15 days';
        insert account_test;
        list<Customer_Quote__c> lista = new list<Customer_Quote__c>();
        lista.add(CrearQuote('Road','IMPORT','FTL',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','LTL',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','FP',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','FO',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','TARIMAS',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','MAYOREO',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','MAYOREO',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','FTL',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','LTL',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','FP',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','FO',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','TARIMAS',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','MAYOREO',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','FTL',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','LTL',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','FP',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','FO',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','TARIMAS',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','Extras',account_test.Id));
        lista.add(CrearQuote('Road','INTERNATIONAL','Extras',account_test.Id));
        lista.add(CrearQuote('Road','PORT','Extras',account_test.Id));
        
        lista.add(CrearQuote('Air','IMPORT','PAQUETERIA',account_test.Id));
        lista.add(CrearQuote('Air','IMPORT','CARGA',account_test.Id));
        lista.add(CrearQuote('Air','EXPORT','PAQUETERIA',account_test.Id));
        lista.add(CrearQuote('Air','EXPORT','CARGA',account_test.Id));
        lista.add(CrearQuote('Air','INTERNATIONAL','PAQUETERIA',account_test.Id));
        lista.add(CrearQuote('Air','INTERNATIONAL','CARGA',account_test.Id));
        lista.add(CrearQuote('Air','NATIONAL','PAQUETERIA',account_test.Id));
        lista.add(CrearQuote('Air','NATIONAL','CARGA',account_test.Id));
        lista.add(CrearQuote('Air','NATIONAL','ENVIO NACIONAL',account_test.Id));
        
        Customer_Quote__c Quote = CrearQuote('Sea','IMPORT','ENVIO NACIONAL',account_test.Id);
        Quote.Team__c = 'WCA';
        lista.add(Quote);
        
        Customer_Quote__c Quote2 = CrearQuote('Sea','EXPORT','ENVIO NACIONAL',account_test.Id);
        Quote2.Team__c = 'WCA';
        lista.add(Quote2);
        
        Customer_Quote__c Quote3 = CrearQuote('Air','EXPORT','ENVIO NACIONAL',account_test.Id);
        Quote3.Team__c = 'WCA';
        lista.add(Quote3);
        
        Customer_Quote__c Quote4 = CrearQuote('Air','IMPORT','ENVIO NACIONAL',account_test.Id);
        Quote4.Team__c = 'WCA';
       
        lista.add(Quote4);
        
        test.startTest();
        insert lista;
        
         for(Customer_Quote__c cq : lista)
        {
            cq.PDF_Notes_EN__c=null;
           
        }
        update lista;
        test.stopTest();
    }
     static testMethod void ActualizaFolioIE_test3 () //ok
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Credit_Terms__c = '15 days';
        insert account_test;
        list<Customer_Quote__c> lista = new list<Customer_Quote__c>();
        lista.add(CrearQuote('Road','IMPORT','FTL',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','LTL',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','FP',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','FO',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','TARIMAS',account_test.Id));
        lista.add(CrearQuote('Road','IMPORT','MAYOREO',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','MAYOREO',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','FTL',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','LTL',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','FP',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','FO',account_test.Id));
        lista.add(CrearQuote('Road','EXPORT','TARIMAS',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','MAYOREO',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','FTL',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','LTL',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','FP',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','FO',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','TARIMAS',account_test.Id));
        lista.add(CrearQuote('Road','NATIONAL','Extras',account_test.Id));
        lista.add(CrearQuote('Road','INTERNATIONAL','Extras',account_test.Id));
        lista.add(CrearQuote('Road','PORT','Extras',account_test.Id));
        
        lista.add(CrearQuote('Air','IMPORT','PAQUETERIA',account_test.Id));
        lista.add(CrearQuote('Air','IMPORT','CARGA',account_test.Id));
        lista.add(CrearQuote('Air','EXPORT','PAQUETERIA',account_test.Id));
        lista.add(CrearQuote('Air','EXPORT','CARGA',account_test.Id));
        lista.add(CrearQuote('Air','INTERNATIONAL','PAQUETERIA',account_test.Id));
        lista.add(CrearQuote('Air','INTERNATIONAL','CARGA',account_test.Id));
        lista.add(CrearQuote('Air','NATIONAL','PAQUETERIA',account_test.Id));
        lista.add(CrearQuote('Air','NATIONAL','CARGA',account_test.Id));
        lista.add(CrearQuote('Air','NATIONAL','ENVIO NACIONAL',account_test.Id));
        
        Customer_Quote__c Quote = CrearQuote('Sea','IMPORT','ENVIO NACIONAL',account_test.Id);
        Quote.Team__c = 'WCA';
        lista.add(Quote);
        
        Customer_Quote__c Quote2 = CrearQuote('Sea','EXPORT','ENVIO NACIONAL',account_test.Id);
        Quote2.Team__c = 'WCA';
        lista.add(Quote2);
        
        Customer_Quote__c Quote3 = CrearQuote('Air','EXPORT','ENVIO NACIONAL',account_test.Id);
        Quote3.Team__c = 'WCA';
        lista.add(Quote3);
        
        Customer_Quote__c Quote4 = CrearQuote('Air','IMPORT','ENVIO NACIONAL',account_test.Id);
        Quote4.Team__c = 'WCA';
       
        lista.add(Quote4);
         insert lista;
        test.startTest();
       
        
        for(Customer_Quote__c cq : lista)
        {
            cq.Origin_Address__c = 'ASD';
            cq.Only_Warehouse_Service__c = false;
           
        }
        update lista;
        
        
        test.stopTest();
    }
      static testMethod void TimeResponseTest () //ok
      {
            List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
            Account account_test = list_accounts[0];
            account_test.Credit_Terms__c = '15 days';
            insert account_test;
            list<Customer_Quote__c> lista = new list<Customer_Quote__c>();
        	lista.add(CrearQuote('Road','IMPORT','FTL',account_test.Id));
            insert lista;
           test.startTest();
       
        datetime fecha = datetime.now();
        string year = string.valueOf(Date.today().year());
                    string month = string.valueOf(Date.today().month());
                    string day = string.valueOf(fecha.addDays(2).day());
                    string hour = '15';
                    string minute = '00';
                    string second = '00';
                    string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
		Datetime DateHoy = Datetime.valueOfGMT(stringDate);
          
        for(Customer_Quote__c cq : lista)
        {
            cq.Status_Observations__c ='prueba';
            cq.Only_Warehouse_Service__c = false;
            cq.Date_Pricing_responded__c = DateHoy.addDays(3);
            cq.Date_Pricing_responded__c = DateHoy.addHours(5);
        }
        update lista;
        test.stopTest();

      }
    public static Customer_Quote__c CrearQuote(string Freight_Mode,string Service_Mode, string Service_Type, string accountId)
    {
        Customer_Quote__c importexportquote = new Customer_Quote__c();
        importexportquote.Account_for__c = accountId;
        importexportquote.Quotation_Status__c = 'Quote being prepared'; 
        importexportquote.Origin_Address__c = '';
        importexportquote.Destination_Address__c = '';  
        importexportquote.Only_Warehouse_Service__c = true;
        importexportquote.Comercio_Exterior__c = 'Si';
        importexportquote.Freight_Mode__c = Freight_Mode;
        importexportquote.Service_Mode__c =Service_Mode;
        importexportquote.Service_Type__c = Service_Type;
        string year = string.valueOf(Date.today().year());
                    string month = string.valueOf(Date.today().month());
                    string day = string.valueOf(Date.today().day());
                    string hour = '09';
                    string minute = '00';
                    string second = '00';
                    string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
		Datetime FechaCalculada = Datetime.valueOfGMT(stringDate);
        importexportquote.Date_Send_Request__c = FechaCalculada;
          year = string.valueOf(Date.today().year());
                     month = string.valueOf(Date.today().month());
                     day = string.valueOf(Date.today().day());
                     hour = '16';
                     minute = '30';
                     second = '00';
                     stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
		FechaCalculada = Datetime.valueOfGMT(stringDate);
        importexportquote.Date_Pricing_responded__c = FechaCalculada;
        NEU_CurrencyUtils.setCurrencyIsoCode(importexportquote, 'MXN');
        return importexportquote;
    }
}