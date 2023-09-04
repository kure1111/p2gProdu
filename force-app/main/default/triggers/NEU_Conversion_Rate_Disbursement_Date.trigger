trigger NEU_Conversion_Rate_Disbursement_Date on Shipment_Disbursement__c (after insert, after update) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id> list_disbursement = new Set<Id>();
    if(trigger.isInsert == true)
    {
        for(Shipment_Disbursement__c dis:trigger.new)
        {
            if(dis.Invoice_Date__c != null)
                list_disbursement.add(dis.Id);
        }
    }
    else if(trigger.isUpdate == true)
    {
        for(Shipment_Disbursement__c dis:trigger.new)
        {
            Shipment_Disbursement__c old_disbursement = Trigger.oldMap.get(dis.Id);
            if(old_disbursement.Invoice_Date__c != dis.Invoice_Date__c || (NEU_CurrencyUtils.getCurrencyIsoCode(old_disbursement) != NEU_CurrencyUtils.getCurrencyIsoCode(dis)))
                list_disbursement.add(dis.Id);
        }
    }
    
    if(list_disbursement != null && list_disbursement.size()>0)
    {
        List<Shipment_Disbursement__c> query_disbursement = new List<Shipment_Disbursement__c>(); 
        String consulta_dis = '';
        consulta_dis += 'SELECT Id, Name, Invoice_Date__c, CreatedDate';
        consulta_dis += ' ,Conversion_Rate_to_Imp_Exp_Currency__c';
        if(UserInfo.isMultiCurrencyOrganization())
        {
            consulta_dis += ' ,Import_Export_Quote_Order__r.CurrencyISOCode';
            consulta_dis += ' ,CurrencyISOCode';
        }
        consulta_dis += ' FROM Shipment_Disbursement__c'; 
        consulta_dis += ' WHERE Id IN : list_disbursement';
        query_disbursement = Database.query(consulta_dis);

        for(Shipment_Disbursement__c dis: query_disbursement)
        {   
            Date dtIsoCode = dis.Invoice_Date__c;
            
            if(!UserInfo.isMultiCurrencyOrganization() || (NEU_CurrencyUtils.getCurrencyIsoCode(dis.Import_Export_Quote_Order__r) == NEU_CurrencyUtils.getCurrencyIsoCode(dis)))
                dis.Conversion_Rate_to_Imp_Exp_Currency__c = 1;
            else
            {
                List<SObject> query_conversion_rate_disbursement = null;
                List<SObject> query_conversion_rate_import_export = null;
                
                String query_cr1 = '';
                query_cr1 += 'SELECT ConversionRate';
                query_cr1 += ' FROM DatedConversionRate'; 
                query_cr1 += ' WHERE startDate <=: dtIsoCode AND nextstartdate > :dtIsoCode';
                query_cr1 += ' AND Isocode = \'' + NEU_CurrencyUtils.getCurrencyIsoCode(dis) + '\'';
                query_cr1 += ' LIMIT 1';
                query_conversion_rate_disbursement = Database.query(query_cr1);
                                        
                String query_cr2 = '';
                query_cr2 += 'SELECT ConversionRate';
                query_cr2 += ' FROM DatedConversionRate'; 
                query_cr2 += ' WHERE startDate <=:dtIsoCode AND nextstartdate > :dtIsoCode';
                query_cr2 += ' AND Isocode = \'' + NEU_CurrencyUtils.getCurrencyIsoCode(dis.Import_Export_Quote_Order__r) + '\'';
                query_cr2 += ' LIMIT 1';
                query_conversion_rate_import_export = Database.query(query_cr2);
            
                //Import/Export's ConversionRate is divided between Invoice's Conversion Rate because it's wante to get the value of the Import/Export
                if(query_conversion_rate_disbursement != null && query_conversion_rate_import_export!=null)
                    dis.Conversion_Rate_to_Imp_Exp_Currency__c = (Decimal)query_conversion_rate_import_export[0].get('ConversionRate')/(Decimal)query_conversion_rate_disbursement[0].get('ConversionRate');
            }            
        }
        
        if(query_disbursement != null && query_disbursement.size()>0)
        {
            update query_disbursement;
        }
        
        //Import-Export
         // Consulta de las Invoices Order Lines para actualizar su Conversion Rate
        List<Import_Export_Service_Line_Disbursement__c> query_disbursement_lines = new List<Import_Export_Service_Line_Disbursement__c>();
        if(query_disbursement != null && query_disbursement.size()>0)
        {
            String consulta_disbursement_lines = '';
            consulta_disbursement_lines += 'SELECT Id, Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c, Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c ';
            consulta_disbursement_lines += 'FROM Import_Export_Service_Line_Disbursement__c '; 
            consulta_disbursement_lines += 'WHERE Disbursement__c IN: query_disbursement';
            query_disbursement_lines = Database.query(consulta_disbursement_lines);
        }
        for(Import_Export_Service_Line_Disbursement__c disbursment_line:query_disbursement_lines)
        {
            disbursment_line.Conversion_Rate_to_Service_Line_Currency__c = disbursment_line.Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c / disbursment_line.Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c;
        }
        if(query_disbursement_lines != null && query_disbursement_lines.size()>0)
        {
            update query_disbursement_lines;
        }
        
         // Consulta de las Invoices Order cargo Lines para actualizar su Conversion Rate
        List<Import_Export_Cargo_Line_Disbursement__c> query_disbursement_cargo_lines = new List<Import_Export_Cargo_Line_Disbursement__c>();
        if(query_disbursement != null && query_disbursement.size()>0)
        {
            String consulta_disbursement_lines = '';
            consulta_disbursement_lines += 'SELECT Id, Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c, Import_Export_Cargo_Line__r.Conversion_Rate_to_Currency_Header__c ';
            consulta_disbursement_lines += 'FROM Import_Export_Cargo_Line_Disbursement__c '; 
            consulta_disbursement_lines += 'WHERE Disbursement__c IN: query_disbursement';
            query_disbursement_cargo_lines = Database.query(consulta_disbursement_lines);
        }
        for(Import_Export_Cargo_Line_Disbursement__c disbursment_line: query_disbursement_cargo_lines)
        {
            disbursment_line.Conversion_Rate_to_Cargo_Line_Currency__c = disbursment_line.Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c / disbursment_line.Import_Export_Cargo_Line__r.Conversion_Rate_to_Currency_Header__c;
        }
        if(query_disbursement_cargo_lines != null && query_disbursement_cargo_lines.size()>0)
        {
            update query_disbursement_cargo_lines;
        }
        
        //Shipment
        // Consulta de las Invoices Order Lines para actualizar su Conversion Rate
       List<Shipment_Service_Line_Disbursement__c> query_disbursement_service_lines = new List<Shipment_Service_Line_Disbursement__c>();
        if(query_disbursement != null && query_disbursement.size()>0)
        {
            String consulta_disbursement_lines = '';
            consulta_disbursement_lines += 'SELECT Id, Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c ';
            consulta_disbursement_lines += 'FROM Shipment_Service_Line_Disbursement__c '; 
            consulta_disbursement_lines += 'WHERE Shipment_Disbursement__c IN: query_disbursement';
            query_disbursement_service_lines = Database.query(consulta_disbursement_lines);
        }
        for(Shipment_Service_Line_Disbursement__c disbursment_line: query_disbursement_service_lines )
        {
            disbursment_line.Conversion_Rate_to_Service_Line_Currency__c = disbursment_line.Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c/disbursment_line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c;
        }
        if(query_disbursement_service_lines != null && query_disbursement_service_lines.size()>0)
        {
            update query_disbursement_service_lines;
        }
         
         // Consulta de las disbursement shipment cargo Lines para actualizar su Conversion Rate
        List<Shipment_Item_Line_Disbursement__c> query_disbursement_shipment_cargo_lines = new List<Shipment_Item_Line_Disbursement__c>();
        if(query_disbursement != null && query_disbursement.size()>0)
        {
            String consulta_disbursement_lines = '';
            consulta_disbursement_lines += 'SELECT Id, Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c ';
            consulta_disbursement_lines += 'FROM Shipment_Item_Line_Disbursement__c '; 
            consulta_disbursement_lines += 'WHERE Shipment_Disbursement__c IN: query_disbursement';
            query_disbursement_shipment_cargo_lines = Database.query(consulta_disbursement_lines);
        }
        for(Shipment_Item_Line_Disbursement__c disbursment_line: query_disbursement_shipment_cargo_lines )
        {
            disbursment_line.Conversion_Rate_to_Cargo_Line_Currency__c = disbursment_line.Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c / disbursment_line.Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c;
        }
        if(query_disbursement_shipment_cargo_lines != null && query_disbursement_shipment_cargo_lines.size()>0)
        {
            update query_disbursement_shipment_cargo_lines;
        }
        
    }
}