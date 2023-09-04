trigger NEU_Update_Disbursement_Shipment_Cargo_Lines_Conversion_Rate on Shipment_Item_Line_Disbursement__c (after insert) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id> list_disbursement_order_lines = new Set<Id>();
    if(trigger.isInsert == true)
    {
        for(Shipment_Item_Line_Disbursement__c iol:trigger.new)
        {
            list_disbursement_order_lines .add(iol.Id);
        }
    }

    // Consulta de las Disbursement Cargo shipment Lines para actualizar su Conversion Rate
    List<Shipment_Item_Line_Disbursement__c > query_disbursement_order_lines = new List<Shipment_Item_Line_Disbursement__c >();
    if(list_disbursement_order_lines != null && list_disbursement_order_lines .size()>0)
    {
        String consulta_invoice_order_lines = '';
        consulta_invoice_order_lines += 'SELECT Id, Name, Conversion_Rate_to_Cargo_Line_Currency__c, Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c ';
        consulta_invoice_order_lines += 'FROM Shipment_Item_Line_Disbursement__c '; 
        consulta_invoice_order_lines += 'WHERE Id IN : list_disbursement_order_lines';
        query_disbursement_order_lines = Database.query(consulta_invoice_order_lines);
    }
    
    for(Shipment_Item_Line_Disbursement__c disbursement_line:query_disbursement_order_lines )
    {
        disbursement_line.Conversion_Rate_to_Cargo_Line_Currency__c = neu_utils.safedecimal(disbursement_line.Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c) / neu_utils.safedecimal(disbursement_line.Shipment_Item_Line__r.Conversion_Rate_to_Currency_Header__c);
    } 
    
    if(query_disbursement_order_lines != null && query_disbursement_order_lines.size()>0)
    {
        update query_disbursement_order_lines;
    }    
}