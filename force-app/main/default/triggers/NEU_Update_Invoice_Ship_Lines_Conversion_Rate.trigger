trigger NEU_Update_Invoice_Ship_Lines_Conversion_Rate on Invoice_Service_Line__c (after insert) {

   if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id> list_invoice_ship_lines = new Set<Id>();
    if(trigger.isInsert == true)
    {
        for(Invoice_Service_Line__c iol:trigger.new)
        {
            list_invoice_ship_lines .add(iol.Id);
        }
    }

    // Consulta de las Invoices Order Lines para actualizar su Conversion Rate
    List<Invoice_Service_Line__c> query_invoice_ship_lines = new List<Invoice_Service_Line__c>();
    if(list_invoice_ship_lines != null && list_invoice_ship_lines.size()>0)
    {
        String consulta_invoice_order_lines = '';
        consulta_invoice_order_lines += 'SELECT Id, Name, Conversion_Rate_to_Service_Line_Currency__c, Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c ';
        consulta_invoice_order_lines += 'FROM Invoice_Service_Line__c '; 
        consulta_invoice_order_lines += 'WHERE Id IN : list_invoice_ship_lines ';
        query_invoice_ship_lines = Database.query(consulta_invoice_order_lines); 
    }
  
    for(Invoice_Service_Line__c  invoice_ship_line: query_invoice_ship_lines )
    {
        invoice_ship_line.Conversion_Rate_to_Service_Line_Currency__c = invoice_ship_line.Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c / invoice_ship_line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c;
    } 
  
    if(query_invoice_ship_lines != null && query_invoice_ship_lines.size()>0)
    {
        update query_invoice_ship_lines;
    }  
}