trigger NEU_Update_Disbursement_Ship_Lines_Conversion_Rate on Shipment_Service_Line_Disbursement__c (after insert) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id> list_disbursement_ship_lines = new Set<Id>();
    if(trigger.isInsert == true)
    {
        for(Shipment_Service_Line_Disbursement__c  iol:trigger.new)
        {
            list_disbursement_ship_lines .add(iol.Id);
        }
    }

    // Consulta de las shipment service lines disbursement para actualizar su Conversion Rate
    List<Shipment_Service_Line_Disbursement__c> query_disbursement_ship_lines = new List<Shipment_Service_Line_Disbursement__c >();
    if(list_disbursement_ship_lines != null && list_disbursement_ship_lines.size()>0)
    {
        String consulta_disbursement_order_lines = '';
        consulta_disbursement_order_lines += 'SELECT Id, Name, Conversion_Rate_to_Service_Line_Currency__c, Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c, Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c ';
        consulta_disbursement_order_lines += 'FROM Shipment_Service_Line_Disbursement__c '; 
        consulta_disbursement_order_lines += 'WHERE Id IN : list_disbursement_ship_lines ';
        query_disbursement_ship_lines = Database.query(consulta_disbursement_order_lines); 
    }
  
    for(Shipment_Service_Line_Disbursement__c disbursement_ship_line: query_disbursement_ship_lines )
    {
        disbursement_ship_line.Conversion_Rate_to_Service_Line_Currency__c = neu_utils.safedecimal(disbursement_ship_line.Shipment_Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c) / neu_utils.safedecimal(disbursement_ship_line.Shipment_Service_Line__r.Conversion_Rate_to_Currency_Header__c);
    } 
  
    if(query_disbursement_ship_lines != null && query_disbursement_ship_lines.size()>0)
    {
        update query_disbursement_ship_lines ;
    }  
}