trigger NEU_Update_Disbursement_Lines_Conversion_Rate on Import_Export_Service_Line_Disbursement__c(after insert) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id> list_disbursement_order_lines = new Set<Id>();
    if(trigger.isInsert == true)
    {
        for(Import_Export_Service_Line_Disbursement__c iol:trigger.new)
        {
            list_disbursement_order_lines .add(iol.Id);
        }
    }

    // Consulta de las Invoices Order Lines para actualizar su Conversion Rate
    List<Import_Export_Service_Line_Disbursement__c> query_disbursement_order_lines = new List<Import_Export_Service_Line_Disbursement__c>();
    if(list_disbursement_order_lines != null && list_disbursement_order_lines .size()>0)
    {
        String consulta_invoice_order_lines = '';
        consulta_invoice_order_lines += 'SELECT Id, Name, Conversion_Rate_to_Service_Line_Currency__c, Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c, Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c ';
        consulta_invoice_order_lines += 'FROM Import_Export_Service_Line_Disbursement__c '; 
        consulta_invoice_order_lines += 'WHERE Id IN : list_disbursement_order_lines';
        query_disbursement_order_lines = Database.query(consulta_invoice_order_lines);
    }
    
    for(Import_Export_Service_Line_Disbursement__c invoice_disbursement_line:query_disbursement_order_lines )
    {
        invoice_disbursement_line.Conversion_Rate_to_Service_Line_Currency__c = neu_utils.safedecimal(invoice_disbursement_line.Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c) / neu_utils.safedecimal(invoice_disbursement_line.Import_Export_Service_Line__r.Conversion_Rate_to_Currency_Header__c);
    } 
    
    if(query_disbursement_order_lines != null && query_disbursement_order_lines .size()>0)
    {
        update query_disbursement_order_lines;
    }
}