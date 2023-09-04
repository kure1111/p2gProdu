trigger NEU_Update_Shipment_Cargo_Invoice_Lines_Conversion_Rate on Invoice_Item_Line__c (after insert) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id> list_invoice_ship_lines = new Set<Id>();
    if(trigger.isInsert == true)
    {
        for(Invoice_Item_Line__c  iol:trigger.new)
        {
            list_invoice_ship_lines.add(iol.Id);
        }
    }

    // Consulta de las Invoices shipment Cargo Lines para actualizar su Conversion Rate
    List<Invoice_Item_Line__c > query_invoice_order_lines = new List<Invoice_Item_Line__c >();
    if(list_invoice_ship_lines  != null && list_invoice_ship_lines.size()>0)
    {
        String consulta_invoice_order_lines = '';
        consulta_invoice_order_lines += 'SELECT Id, Name, Conversion_Rate_to_Cargo_Line_Currency__c, Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c ';
        consulta_invoice_order_lines += 'FROM Invoice_Item_Line__c '; 
        consulta_invoice_order_lines += 'WHERE Id IN : list_invoice_ship_lines';
        query_invoice_order_lines = Database.query(consulta_invoice_order_lines);
    }
    
    for(Invoice_Item_Line__c invoice_order_line:query_invoice_order_lines)
    {
        invoice_order_line.Conversion_Rate_to_Cargo_Line_Currency__c = invoice_order_line.Invoice__r.Conversion_Rate_to_Imp_Exp_Currency__c / invoice_order_line.Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c;
    } 
    
    if(query_invoice_order_lines != null && query_invoice_order_lines.size()>0)
    {
        update query_invoice_order_lines;
    }    
}