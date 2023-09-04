trigger NEU_CheckInvoiceLinesCurrency on Invoice__c (before update) {

    if(NEU_StaticVariableHelper.getBoolean1()){return;}        

    if(!RecursiveCheck.triggerMonitor.contains('NEU_CheckInvoiceLinesCurrency')){
        RecursiveCheck.triggerMonitor.add('NEU_CheckInvoiceLinesCurrency');
        // Validar que la moneda de la Invoice a modificar no es distinta de alguna de sus líneas actuales. 
        if(trigger.isUpdate == true && (UserInfo.isMultiCurrencyOrganization() || Test.isRunningTest()))
        {
            Set<Id> list_invoice = new Set<Id>();
            for(Invoice__c inv:trigger.new)
            {
                list_invoice.add(inv.Id);
            }
            
            //ie service line Invoice
            List<Import_Export_Service_Line_Invoice__c> query_invoice_lines = new List<Import_Export_Service_Line_Invoice__c>();
            
            //ie cargo line Invoice
            List<Import_Export_Item_Line_Invoice__c> query_invoice_cargo_lines = new List<Import_Export_Item_Line_Invoice__c>();
            
            //ship service Line Invoice
            List<Invoice_Service_Line__c> query_shipment_invoice_lines = new List<Invoice_Service_Line__c>();
            
            //ship cargo line Invoice
            List<Invoice_Item_Line__c> query_Shipment_invoice_cargo_lines = new List<Invoice_Item_Line__c>();
            
            if(list_invoice != null && list_invoice.size()>0)
            { 
                String consulta_invoice_lines = '';
                consulta_invoice_lines += 'SELECT Id, Invoice__c';
                if(UserInfo.isMultiCurrencyOrganization())
                {
                    consulta_invoice_lines += ', CurrencyISOCode';
                }
                consulta_invoice_lines += ' FROM Import_Export_Service_Line_Invoice__c'; 
                consulta_invoice_lines += ' WHERE Invoice__c IN : list_invoice';
                query_invoice_lines = Database.query(consulta_invoice_lines);
                
                //ie cargo lines
                consulta_invoice_lines = '';
                consulta_invoice_lines += 'SELECT Id, Invoice__c';
                if(UserInfo.isMultiCurrencyOrganization())
                {
                    consulta_invoice_lines += ', CurrencyISOCode';
                }
                consulta_invoice_lines += ' FROM Import_Export_Item_Line_Invoice__c'; 
                consulta_invoice_lines += ' WHERE Invoice__c IN : list_invoice';
                query_invoice_cargo_lines = Database.query(consulta_invoice_lines);
                
                //ship service lines
                consulta_invoice_lines = '';
                consulta_invoice_lines += 'SELECT Id, Invoice__c';
                if(UserInfo.isMultiCurrencyOrganization())
                {
                    consulta_invoice_lines += ', CurrencyISOCode';
                }
                consulta_invoice_lines += ' FROM Invoice_Service_Line__c '; 
                consulta_invoice_lines += ' WHERE Invoice__c IN : list_invoice';
                query_shipment_invoice_lines = Database.query(consulta_invoice_lines);
                
                //ship cargo lines
                consulta_invoice_lines = '';
                consulta_invoice_lines += 'SELECT Id, Invoice__c';
                if(UserInfo.isMultiCurrencyOrganization())
                {
                    consulta_invoice_lines += ', CurrencyISOCode';
                }
                consulta_invoice_lines += ' FROM Invoice_Item_Line__c '; 
                consulta_invoice_lines += ' WHERE Invoice__c IN : list_invoice';
                query_Shipment_invoice_cargo_lines = Database.query(consulta_invoice_lines);
            } 
            
            
            
            for(Invoice__c inv:trigger.new)
            {
                //ie service
                for(Import_Export_Service_Line_Invoice__c invoice_line:query_invoice_lines)
                {
                    if(inv.Id == invoice_line.Invoice__c)
                    {
                        if(NEU_CurrencyUtils.getCurrencyIsoCode(inv) != NEU_CurrencyUtils.getCurrencyIsoCode(invoice_line))
                            inv.addError('Currently there are Invoice Lines with a different Currency');
                    }           
                }  
                //ie item
                for(Import_Export_Item_Line_Invoice__c invoice_line: query_invoice_cargo_lines )
                {
                    if(inv.Id == invoice_line.Invoice__c)
                    {
                        if(NEU_CurrencyUtils.getCurrencyIsoCode(inv) != NEU_CurrencyUtils.getCurrencyIsoCode(invoice_line))
                            inv.addError('Currently there are Invoice Lines with a different Currency');
                    }           
                }
                //ship service
                for(Invoice_Service_Line__c invoice_line: query_shipment_invoice_lines )
                {
                    if(inv.Id == invoice_line.Invoice__c)
                    {
                        if(NEU_CurrencyUtils.getCurrencyIsoCode(inv) != NEU_CurrencyUtils.getCurrencyIsoCode(invoice_line))
                            inv.addError('Currently there are Invoice Lines with a different Currency');
                    }           
                }
                //ship item
                for(Invoice_Item_Line__c invoice_line: query_Shipment_invoice_cargo_lines )
                {
                    if(inv.Id == invoice_line.Invoice__c)
                    {
                        if(NEU_CurrencyUtils.getCurrencyIsoCode(inv) != NEU_CurrencyUtils.getCurrencyIsoCode(invoice_line))
                            inv.addError('Currently there are Invoice Lines with a different Currency');
                    }           
                }
            }        
        }
        
        /*if(Test.isRunningTest())
    	{
            Pak_MargenOperativo_SendEmail.senMessage(null,null , 0.00);
            
            String Test0 = '';                                
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';
            Test0 = '';                                   
        }*/
    }
}