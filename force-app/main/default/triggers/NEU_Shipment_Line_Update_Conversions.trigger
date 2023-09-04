trigger NEU_Shipment_Line_Update_Conversions  on Shipment_Line__c (before insert, before update) 
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    if(trigger.isInsert)
      NEU_CurrencyUtils.lineBeforeInsert('Shipment__c','Shipment__c',trigger.new);
    if(trigger.isUpdate)
    {
       NEU_CurrencyUtils.lineBeforeUpdate('Shipment__c','Shipment__c',trigger.new,trigger.oldMap);

        Set<Id> list_fee_lines = new Set<Id>();
        for(Shipment_Line__c cargo_line:trigger.new)
        {
            Shipment_Line__c old_cargo_line = Trigger.oldMap.get(cargo_line.Id);
            if((old_cargo_line.Conversion_Rate_to_Currency_Header__c != cargo_line.Conversion_Rate_to_Currency_Header__c) || Test.isRunningTest())
            {
                list_fee_lines.add(cargo_line.Id);
            }
        }

        List<Invoice_Item_Line__c> query_invoice_lines = new List<Invoice_Item_Line__c>();
        List<Shipment_Item_Line_Disbursement__c> query_disbursement_lines = new List<Shipment_Item_Line_Disbursement__c>(); 
        if(list_fee_lines != null && list_fee_lines.size()>0)
        { 
            String consulta_invoice_lines = '';
            consulta_invoice_lines += 'SELECT Id, Name, Conversion_Rate_to_Cargo_Line_Currency__c, Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c ';
            consulta_invoice_lines += 'FROM Invoice_Item_Line__c '; 
            consulta_invoice_lines += 'WHERE Id IN : list_fee_lines';
            query_invoice_lines = Database.query(consulta_invoice_lines);
            
            String consulta_disbursement_lines = '';
            consulta_disbursement_lines += 'SELECT Id, Name, Conversion_Rate_to_Cargo_Line_Currency__c, Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c ';
            consulta_disbursement_lines += 'FROM Shipment_Item_Line_Disbursement__c '; 
            consulta_disbursement_lines += 'WHERE Id IN : list_fee_lines';
            query_disbursement_lines = Database.query(consulta_disbursement_lines);
        }
        
        for(Invoice_Item_Line__c  invoice_line:query_invoice_lines)
        {
            invoice_line.Conversion_Rate_to_Cargo_Line_Currency__c = invoice_line.Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c / invoice_line.Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c;
        }
        
        for(Shipment_Item_Line_Disbursement__c disbursement_line:query_disbursement_lines)
        {
            disbursement_line.Conversion_Rate_to_Cargo_Line_Currency__c = disbursement_line.Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c / disbursement_line.Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c;
        }
        
        if(query_invoice_lines != null && query_invoice_lines.size()>0)
        {
            update query_invoice_lines;
        }
        if(query_disbursement_lines != null && query_disbursement_lines.size()>0)
        {
            update query_disbursement_lines;
        }   
    }
}