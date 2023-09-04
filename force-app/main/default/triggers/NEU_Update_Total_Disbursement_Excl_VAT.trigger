trigger NEU_Update_Total_Disbursement_Excl_VAT  on Disbursement_Line__c (after insert, after update, before delete) 
{//----puede que solo tenga que calcular los additional sin relacion con las lineas los que si serian por roll-up

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id> ids_ie = new Set<Id>();
    Set<Id> ids_ship = new Set<Id>();
    Set<Id> ids_dl_del = new Set<Id>();
    
    if(trigger.isInsert)
    {
        for(Disbursement_Line__c dl:trigger.new)
        {
            if(dl.Import_Export_Quote_Order__c != null)
                ids_ie.add(dl.Import_Export_Quote_Order__c);
            if(dl.Shipment__c != null)
                ids_ship.add(dl.Shipment__c);
        }
    }
    
    if(trigger.isUpdate)
    {
        for(Disbursement_Line__c dl:trigger.new)
        {
            Disbursement_Line__c old=trigger.oldMap.get(dl.Id);
            if(dl.Amount__c != old.Amount__c)
            {
                
                if(dl.Import_Export_Quote_Order__c != null)
                    ids_ie.add(dl.Import_Export_Quote_Order__c);
                
                if(dl.Shipment__c != null)
                    ids_ship.add(dl.Shipment__c);
            }
        }
    }
    
    if(trigger.isDelete)
    {
        for(Disbursement_Line__c dl:trigger.old)
        {
            if(dl.Import_Export_Quote_Order__c != null)
                ids_ie.add(dl.Import_Export_Quote_Order__c);
            if(dl.Shipment__c != null)
                ids_ship.add(dl.Shipment__c);   
            ids_dl_del.add(dl.id);
        }
    }
    
    if(ids_ie != null && ids_ie.size()> 0)
    {
        Map<Id,decimal> map_total_ie = new Map<Id,decimal>();
        List<Customer_Quote__c> query_ie = [select Id, Name, Total_Disbursements_Excl_VAT__c from Customer_Quote__c where id IN:ids_ie];
        List<Disbursement_Line__c>  query_disbursement_line =null;
        if(ids_dl_del != null && ids_dl_del.size()>0)
            query_disbursement_line =[select Id, Name, Import_Export_Quote_Order__c, Amount__c, Disbursement__c, Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c from Disbursement_Line__c where Import_Export_Quote_Order__c IN: ids_ie and id Not IN:ids_dl_del];
        else
            query_disbursement_line =[select Id, Name, Import_Export_Quote_Order__c, Amount__c, Disbursement__c, Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c from Disbursement_Line__c where Import_Export_Quote_Order__c IN: ids_ie];
        for(Disbursement_Line__c dl : query_disbursement_line )
        {
            if(map_total_ie.containsKey(dl.Import_Export_Quote_Order__c) == true)
            {
                decimal valor_anterior = neu_utils.safedecimal(map_total_ie.get(dl.Import_Export_Quote_Order__c));
                valor_anterior += neu_utils.safedecimal(dl.Amount__c)*neu_utils.safedecimal(dl.Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c);
                map_total_ie.put(dl.Import_Export_Quote_Order__c,valor_anterior);
            }   
            else
            {
                map_total_ie.put(dl.Import_Export_Quote_Order__c,neu_utils.safedecimal(dl.Amount__c)*neu_utils.safedecimal(dl.Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c));
            }
        }
        
        for(Customer_Quote__c cq: query_ie )
        {
             if(map_total_ie.containsKey(cq.Id) == true)
                 cq.Total_Disbursements_Excl_VAT__c = neu_utils.safedecimal(map_total_ie.get(cq.Id));  
        }
        if(query_ie != null && query_ie.size()>0)
            update query_ie ;
    }
    
    if(ids_ship != null && ids_ship.size()> 0)
    {
        Map<Id,decimal> map_total_ship = new Map<Id,decimal>();
        List<Shipment__c> query_ship = [select Id, Name, Total_Disbursements_Excl_VAT__c from Shipment__c where id IN: ids_ship ];
        List<Disbursement_Line__c>  query_disbursement_line = null;
        if(ids_dl_del != null && ids_dl_del.size()>0)
            query_disbursement_line = [select Id, Name, Shipment__c, Amount__c, Disbursement__c, Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c from Disbursement_Line__c where Shipment__c IN: ids_ship and id not IN: ids_dl_del];
        else
            query_disbursement_line = [select Id, Name, Shipment__c, Amount__c, Disbursement__c, Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c from Disbursement_Line__c where Shipment__c IN: ids_ship];
        for(Disbursement_Line__c dl : query_disbursement_line )
        {
            if(map_total_ship.containsKey(dl.Shipment__c) == true)
            {
                decimal valor_anterior = neu_utils.safedecimal(map_total_ship.get(dl.Shipment__c));
                valor_anterior += neu_utils.safedecimal(dl.Amount__c)*neu_utils.safedecimal(dl.Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c);
                map_total_ship.put(dl.Shipment__c,valor_anterior);
            }   
            else
            {
                map_total_ship.put(dl.Shipment__c,neu_utils.safedecimal(dl.Amount__c)*neu_utils.safedecimal(dl.Disbursement__r.Conversion_Rate_to_Imp_Exp_Currency__c));
            }
        }
        
        for(Shipment__c cq: query_ship )
        {
             if(map_total_ship.containsKey(cq.Id) == true)
                 cq.Total_Disbursements_Excl_VAT__c = neu_utils.safedecimal(map_total_ship.get(cq.Id));  
        }
        
        if(query_ship  != null && query_ship.size()>0)
            update query_ship;
    }

}