trigger NEU_CheckDisbursementLinesCurrency on Shipment_Disbursement__c  (before update) {
    if(NEU_StaticVariableHelper.getBoolean1())
        return;
    
    // Validar que la moneda del disbursement a modificar no es distinta de alguna de sus líneas actuales. 
    if((trigger.isUpdate == true && UserInfo.isMultiCurrencyOrganization()) || Test.isRunningTest())
    {
        Set<Id> list_disbursement = new Set<Id>();
        for(Shipment_Disbursement__c inv:trigger.new)
        {
            list_disbursement .add(inv.Id);
        }
        
        //ie service line disbursement
        List<Import_Export_Service_Line_Disbursement__c> query_invoice_lines = new List<Import_Export_Service_Line_Disbursement__c>();
        
        //ie cargo line disbursement
        List<Import_Export_Cargo_Line_Disbursement__c> query_invoice_cargo_lines = new List<Import_Export_Cargo_Line_Disbursement__c>();
        
        //ship service Line disbursement
        List<Shipment_Service_Line_Disbursement__c > query_shipment_invoice_lines = new List<Shipment_Service_Line_Disbursement__c >();
        
        //ship cargo line disbursement
        List<Shipment_Item_Line_Disbursement__c> query_Shipment_invoice_cargo_lines = new List<Shipment_Item_Line_Disbursement__c>();
        
        if(list_disbursement != null && list_disbursement.size()>0)
        { 
            String consulta_invoice_lines = '';
            consulta_invoice_lines += 'SELECT Id, Disbursement__c';
            if(UserInfo.isMultiCurrencyOrganization())
            {
                consulta_invoice_lines += ', CurrencyISOCode';
            }
            consulta_invoice_lines += ' FROM Import_Export_Service_Line_Disbursement__c'; 
            consulta_invoice_lines += ' WHERE Disbursement__c IN : list_disbursement ';
            query_invoice_lines = Database.query(consulta_invoice_lines);
            
            //ie cargo lines
            consulta_invoice_lines = '';
            consulta_invoice_lines += 'SELECT Id, Disbursement__c';
            if(UserInfo.isMultiCurrencyOrganization())
            {
                consulta_invoice_lines += ', CurrencyISOCode';
            }
            consulta_invoice_lines += ' FROM Import_Export_Cargo_Line_Disbursement__c'; 
            consulta_invoice_lines += ' WHERE Disbursement__c IN : list_disbursement ';
            query_invoice_cargo_lines = Database.query(consulta_invoice_lines);
            
            //ship service lines
            consulta_invoice_lines = '';
            consulta_invoice_lines += 'SELECT Id, Shipment_Disbursement__c ';
            if(UserInfo.isMultiCurrencyOrganization())
            {
                consulta_invoice_lines += ', CurrencyISOCode';
            }
            consulta_invoice_lines += ' FROM Shipment_Service_Line_Disbursement__c '; 
            consulta_invoice_lines += ' WHERE Shipment_Disbursement__c IN : list_disbursement ';
            query_shipment_invoice_lines = Database.query(consulta_invoice_lines);
            
            //ship cargo lines
            consulta_invoice_lines = '';
            consulta_invoice_lines += 'SELECT Id, Shipment_Disbursement__c ';
            if(UserInfo.isMultiCurrencyOrganization())
            {
                consulta_invoice_lines += ', CurrencyISOCode';
            }
            consulta_invoice_lines += ' FROM Shipment_Item_Line_Disbursement__c'; 
            consulta_invoice_lines += ' WHERE Shipment_Disbursement__c IN : list_disbursement ';
            query_Shipment_invoice_cargo_lines = Database.query(consulta_invoice_lines);
        } 
        
        
        
        for(Shipment_Disbursement__c inv:trigger.new)
        {
            //ie service
            for(Import_Export_Service_Line_Disbursement__c disbursement_line:query_invoice_lines)
            {
                if(inv.Id == disbursement_line.Disbursement__c)
                {
                    if(NEU_CurrencyUtils.getCurrencyIsoCode(inv) != NEU_CurrencyUtils.getCurrencyIsoCode(disbursement_line))
                        inv.addError('Currently there are Disbursement Lines with a different Currency');
                }           
            }  
            //ie item
            for(Import_Export_Cargo_Line_Disbursement__c disbursement_line: query_invoice_cargo_lines )
            {
                if(inv.Id == disbursement_line.Disbursement__c)
                {
                    if(NEU_CurrencyUtils.getCurrencyIsoCode(inv) != NEU_CurrencyUtils.getCurrencyIsoCode(disbursement_line))
                        inv.addError('Currently there are Disbursement Lines with a different Currency');
                }           
            }
            //ship service
            for(Shipment_Service_Line_Disbursement__c disbursement_line: query_shipment_invoice_lines )
            {
                if(inv.Id == disbursement_line.Shipment_Disbursement__c)
                {
                    if(NEU_CurrencyUtils.getCurrencyIsoCode(inv) != NEU_CurrencyUtils.getCurrencyIsoCode(disbursement_line))
                        inv.addError('Currently there are Disbursement Lines with a different Currency');
                }           
            }
            //ship item
            for(Shipment_Item_Line_Disbursement__c disbursement_line: query_Shipment_invoice_cargo_lines )
            {
                if(inv.Id == disbursement_line.Shipment_Disbursement__c)
                {
                    if(NEU_CurrencyUtils.getCurrencyIsoCode(inv) != NEU_CurrencyUtils.getCurrencyIsoCode(disbursement_line))
                        inv.addError('Currently there are Disbursement Lines with a different Currency');
                }           
            }
        }        
    }
}