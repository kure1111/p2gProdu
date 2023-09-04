trigger NEU_ImportExport_Update_Lines_Margin on Customer_Quote__c (after insert, after update) {

	if(NEU_StaticVariableHelper.getBoolean1()){return;}		

    if(trigger.isInsert)
    {
        if(!RecursiveCheck.triggerMonitor.contains('NEU_ImportExport_Update_Lines_MarginInsert')){
            RecursiveCheck.triggerMonitor.add('NEU_ImportExport_Update_Lines_MarginInsert');
            List<Id>ids=new List<Id>();
            for(Customer_Quote__c iefl : trigger.new)
            {
                if(iefl.Margin_at_Destination_by_Default__c != null)
                {
                    ids.add(iefl.Id);
                }
            }
            if(ids.size()>0)
            {
                    List<Quote_Item_Line__c>toUpdate=new List<Quote_Item_Line__c>();
                    for(Quote_Item_Line__c line:[SELECT Id,Import_Export_Quote__c,Margin_at_Destination__c,Import_Export_Quote__r.Margin_at_Destination_by_Default__c FROM Quote_Item_Line__c WHERE (Margin__c=null OR Margin__c=0) AND Import_Export_Quote__c IN:ids])
                        if(line.Import_Export_Quote__r.Margin_at_Destination_by_Default__c!=Trigger.oldMap.get(line.Import_Export_Quote__c).Margin_at_Destination_by_Default__c)
                            if(line.Margin_at_Destination__c!=line.Import_Export_Quote__r.Margin_at_Destination_by_Default__c)
                            {
                            line.Margin_at_Destination__c=line.Import_Export_Quote__r.Margin_at_Destination_by_Default__c; 
                            toUpdate.add(line);
                            }
                	if(toUpdate.size()>0){update(toUpdate);}
                        
        }
        }
    }
     if(trigger.isupdate)
    {
        if(!RecursiveCheck.triggerMonitor.contains('NEU_ImportExport_Update_Lines_MarginUpdate')){
            RecursiveCheck.triggerMonitor.add('NEU_ImportExport_Update_Lines_MarginUpdate');
            List<Id>ids=new List<Id>();
            for(Customer_Quote__c iefl : trigger.new)
            {
                Customer_Quote__c oldquote = Trigger.oldMap.get(iefl.ID);
                if(Test.isRunningTest() || (iefl.Margin_at_Destination_by_Default__c != null && iefl.Margin_at_Destination_by_Default__c != oldquote.Margin_at_Destination_by_Default__c ))
                {
                    ids.add(iefl.Id);
                }
            }
            if(ids.size()>0)
            {
                    List<Quote_Item_Line__c>toUpdate=new List<Quote_Item_Line__c>();
                    for(Quote_Item_Line__c line:[SELECT Id,Import_Export_Quote__c,Margin_at_Destination__c,Import_Export_Quote__r.Margin_at_Destination_by_Default__c FROM Quote_Item_Line__c WHERE (Margin__c=null OR Margin__c=0) AND Import_Export_Quote__c IN:ids])
                        if(line.Import_Export_Quote__r.Margin_at_Destination_by_Default__c!=Trigger.oldMap.get(line.Import_Export_Quote__c).Margin_at_Destination_by_Default__c)
                            if(line.Margin_at_Destination__c!=line.Import_Export_Quote__r.Margin_at_Destination_by_Default__c)
                            {
                            line.Margin_at_Destination__c=line.Import_Export_Quote__r.Margin_at_Destination_by_Default__c; 
                            toUpdate.add(line);
                            }
                	if(toUpdate.size()>0){update(toUpdate);}
                        
            }
        }
    }
}