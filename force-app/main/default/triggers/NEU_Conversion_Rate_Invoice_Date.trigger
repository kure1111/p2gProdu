trigger NEU_Conversion_Rate_Invoice_Date on Invoice__c (after insert, after update) 
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}       

    if(!RecursiveCheck.triggerMonitor.contains('NEU_Conversion_Rate_Invoice_Date')){
        RecursiveCheck.triggerMonitor.add('NEU_Conversion_Rate_Invoice_Date');
        Set<Id> list_invoice = new Set<Id>();
        if(trigger.isInsert == true)
        {
            for(Invoice__c inv:trigger.new)
            {
                if(inv.Date_of_Invoice__c != null){list_invoice.add(inv.Id);}                        
            }
        }
        else if(trigger.isUpdate == true)
        {
            for(Invoice__c inv:trigger.new)
            {
                Invoice__c old_invoice = Trigger.oldMap.get(inv.Id);
                if(old_invoice.Date_of_Invoice__c != inv.Date_of_Invoice__c || (NEU_CurrencyUtils.getCurrencyIsoCode(old_invoice) != NEU_CurrencyUtils.getCurrencyIsoCode(inv))){list_invoice.add(inv.Id);}                        
            }
        }
        
        if(list_invoice != null && list_invoice.size()>0)
        {
            
            system.debug('list_invoice Trigger: ' + list_invoice);
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
            consulta_inv += ' WHERE Id IN : list_invoice';
            query_invoice = Database.query(consulta_inv);
            
            
            for(Invoice__c inv: query_invoice)
            {   
                Date dtIsoCode = inv.Date_of_Invoice__c;
                
                if(!Test.isRunningTest() && (!UserInfo.isMultiCurrencyOrganization() || (NEU_CurrencyUtils.getCurrencyIsoCode(inv.Import_Export_Quote_Order__r) == NEU_CurrencyUtils.getCurrencyIsoCode(inv))))
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
            {
                update query_invoice;
            }
            
            //---------------------------------------
            
            // Consulta de las Invoices Order Lines para actualizar su Conversion Rate
            List<Import_Export_Service_Line_Invoice__c> query_invoice_lines = new List<Import_Export_Service_Line_Invoice__c>();
            if(query_invoice != null && query_invoice.size()> 0)
            {
                String consulta_invoice_lines = '';
                consulta_invoice_lines += 'SELECT Id, Name, Conversion_Rate_to_Service_Line_Currency__c, Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c, Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c ';
                consulta_invoice_lines += 'FROM Import_Export_Service_Line_Invoice__c '; 
                consulta_invoice_lines += 'WHERE Invoice__c IN: query_invoice';
                query_invoice_lines = Database.query(consulta_invoice_lines);
            }
            
            for(Import_Export_Service_Line_Invoice__c invoice_line:query_invoice_lines)
            {
                invoice_line.Conversion_Rate_to_Service_Line_Currency__c = invoice_line.Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c/ invoice_line.Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c;
            }
            
            if(query_invoice_lines != null && query_invoice_lines.size()>0)
            {
                update query_invoice_lines;
            }
            //------------------------------------------
            //Consulta de las Invoices Order Cargo Lines para actualizar su Conversion Rate
            List<Import_Export_Item_Line_Invoice__c> query_invoice_items_lines = new List<Import_Export_Item_Line_Invoice__c>();
            if(query_invoice != null && query_invoice.size()> 0)
            {
                String consulta_invoice_lines = '';
                consulta_invoice_lines += 'SELECT Id, Name, Conversion_Rate_to_Cargo_Line_Currency__c, Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c, Import_Export_Item_Line__r.Conversion_Rate_to_Currency_Header__c ';
                consulta_invoice_lines += 'FROM Import_Export_Item_Line_Invoice__c '; 
                consulta_invoice_lines += 'WHERE Invoice__c IN: query_invoice';
                query_invoice_items_lines = Database.query(consulta_invoice_lines);
            }
            
            for(Import_Export_Item_Line_Invoice__c  invoice_line:query_invoice_items_lines)
            {
                invoice_line.Conversion_Rate_to_Cargo_Line_Currency__c = invoice_line.Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c/ invoice_line.Import_Export_Item_Line__r.Conversion_Rate_to_Currency_Header__c;
            }
            
            if(query_invoice_items_lines != null && query_invoice_items_lines.size()>0)
            {
                update query_invoice_items_lines;
            }
            //-------------------------------------
            //shipments 
            // Consulta de las Invoices shipment Lines para actualizar su Conversion Rate
            
            List<Invoice_Service_Line__c> query_invoice_lines_shipment = new List<Invoice_Service_Line__c>();
            if(query_invoice != null && query_invoice.size()> 0)
            {
                String consulta_invoice_lines = '';
                consulta_invoice_lines += 'SELECT Id, Name, Conversion_Rate_to_Service_Line_Currency__c, Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c ';
                consulta_invoice_lines += 'FROM Invoice_Service_Line__c '; 
                consulta_invoice_lines += 'WHERE Invoice__c IN: query_invoice';
                query_invoice_lines_shipment = Database.query(consulta_invoice_lines);
            }
            
            for(Invoice_Service_Line__c invoice_line:query_invoice_lines_shipment )
            {
                invoice_line.Conversion_Rate_to_Service_Line_Currency__c = invoice_line.Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c/ invoice_line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c;
            }
            
            if(query_invoice_lines_shipment != null && query_invoice_lines_shipment.size()>0)
            {
                update query_invoice_lines_shipment;
            }
            //----------------------------------------------------------
            
            // Consulta de las Invoices shipment cargo Lines para actualizar su Conversion Rate
            
            List<Invoice_Item_Line__c> query_invoice_shipment_items_lines = new List<Invoice_Item_Line__c>();
            if(query_invoice != null && query_invoice.size()> 0)
            {
                String consulta_invoice_lines = '';
                consulta_invoice_lines += 'SELECT Id, Name, Conversion_Rate_to_Cargo_Line_Currency__c, Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c ';
                consulta_invoice_lines += 'FROM Invoice_Item_Line__c '; 
                consulta_invoice_lines += 'WHERE Invoice__c IN: query_invoice';
                query_invoice_shipment_items_lines = Database.query(consulta_invoice_lines);
            }
            
            for(Invoice_Item_Line__c invoice_line:query_invoice_shipment_items_lines )
            {
                invoice_line.Conversion_Rate_to_Cargo_Line_Currency__c = invoice_line.Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c/ invoice_line.Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c;
            }
            
            if(query_invoice_shipment_items_lines != null && query_invoice_shipment_items_lines.size()>0)
            {
                update query_invoice_shipment_items_lines ;
            }
		}
               
    }
}