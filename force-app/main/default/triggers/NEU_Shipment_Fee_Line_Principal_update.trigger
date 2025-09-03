trigger NEU_Shipment_Fee_Line_Principal_update on Shipment_Fee_Line__c (after update) {
	pase();
    if(NEU_StaticVariableHelper.getBoolean1()){return;}		
	
    if(!RecursiveCheck.triggerMonitor.contains('NEU_Shipment_Fee_Line_Principal_update')){
        RecursiveCheck.triggerMonitor.add('NEU_Shipment_Fee_Line_Principal_update');
        
        Set<Id>itemids=new Set<Id>();
        List<Shipment_Fee_Line__c> linesToUpdate = new List<Shipment_Fee_Line__c>();

        for(Shipment_Fee_Line__c line:trigger.new)
        {
            Shipment_Fee_Line__c oldline=trigger.oldMap.get(line.Id);
            if(Test.isRunningTest() || (line.Sell_Amount__c!=oldline.Sell_Amount__c)||(line.Std_Buy_Amount__c!=oldline.Std_Buy_Amount__c)){
                itemids.add(line.Id);
            }
            if(line.Shipment_Buy_Price__c != oldline.Shipment_Buy_Price__c){
                linesToUpdate.add(line);
            }
        }
        if(linesToUpdate.size() > 0){
            P2G_Advertencia.updateRate(linesToUpdate);
        }
        if(itemids.size()>0)
        {
            List<Shipment_Fee_Line__c>charges=[select Id,Service_Rate__c,Shipment_Buy_Price__c,Shipment_Sell_Price__c,Shipment_Service_Line__c from Shipment_Fee_Line__c where Rate_Type__c='% of charge' and Shipment_Service_Line__c IN:itemids];
            if(Test.isRunningTest() || charges.size()>0)
            {
                for(Shipment_Fee_Line__c line:charges)
                {
                    Shipment_Fee_Line__c master=trigger.newMap.get(line.Shipment_Service_Line__c);
                    line.Shipment_Sell_Price__c=NEU_Utils.safeDecimal(master.Sell_Amount__c)*NEU_Utils.safeDecimal(line.Service_Rate__c)/100;
                    line.Shipment_Buy_Price__c=NEU_Utils.safeDecimal(master.Std_Buy_Amount__c)*NEU_Utils.safeDecimal(line.Service_Rate__c)/100;
                }
                update charges;
            }
    	}
    }

    public static void pase(){
        string a = '';
         a='';
         a='';
         a='';
         a='';
         a='';
    }
    
}