trigger NEU_Supplier_Quote_Line_Copy on Supplier_Quote_Line__c (before insert,before update) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id>itemids=new Set<Id>();
    for(Supplier_Quote_Line__c line:trigger.new)
    {
        Supplier_Quote_Line__c oldline=null;
        if(trigger.oldMap!=null)
            oldline=trigger.oldMap.get(line.Id);
        if(oldline!=null)
        {
            if(oldline.Total_Weight_Kg__c==line.Total_Weight_Kg__c)
                if(oldline.Supplier_Total_Weight_kg__c!=line.Supplier_Total_Weight_kg__c)
                    line.Total_Weight_Kg__c=line.Supplier_Total_Weight_kg__c;
            if(oldline.Total_Volume_m3__c==line.Total_Volume_m3__c)
                if(oldline.Supplier_Total_Volume_m3__c!=line.Supplier_Total_Volume_m3__c)
                    line.Total_Volume_m3__c=line.Supplier_Total_Volume_m3__c;
        }
        else
        {
            if(NEU_Utils.safeDecimal(line.Total_Weight_Kg__c)==0)
            {
                if(NEU_Utils.safeDecimal(line.Supplier_Total_Weight_kg__c)!=0)
                    line.Total_Weight_Kg__c=line.Supplier_Total_Weight_kg__c;
                else if(line.Item__c!=null)
                    itemids.add(line.Item__c);
            }
            if(NEU_Utils.safeDecimal(line.Total_Volume_m3__c)==0)
            {
                if(NEU_Utils.safeDecimal(line.Supplier_Total_Volume_m3__c)!=0)
                    line.Total_Volume_m3__c=line.Supplier_Total_Volume_m3__c;
                else if(line.Item__c!=null)
                    itemids.add(line.Item__c);
            }
        }
    }
    if(itemids.size()>0)
    {
        Map<Id,Sourcing_Item__c>items=new Map<Id,Sourcing_Item__c>([select Id,Master_Box_Gross_Weight_kg__c,Units_x_Master_Box__c,Weight_Kgs__c,Master_Box_Volume_m3__c from Sourcing_Item__c where Id IN:itemids]);
        for(Supplier_Quote_Line__c line:trigger.new)
        {
            if(NEU_Utils.safeDecimal(line.Total_Weight_Kg__c)==0)
                if(NEU_Utils.safeDecimal(line.Supplier_Total_Weight_kg__c)==0)
                    if(line.Item__c!=null)
                    {
                        Sourcing_Item__c item=items.get(line.Item__c);
                        Decimal itemweight;
                        if((NEU_Utils.safeDecimal(item.Master_Box_Gross_Weight_kg__c)!=0)&&(NEU_Utils.safeDecimal(item.Units_x_Master_Box__c)!=0))
                            itemweight=item.Master_Box_Gross_Weight_kg__c/item.Units_x_Master_Box__c;
                        else
                            itemweight=item.Weight_Kgs__c;
                        if(NEU_Utils.safeDecimal(itemweight)!=0)
                            line.Total_Weight_Kg__c=NEU_Utils.safeDecimal(line.Quantity__c)*itemweight;
                    }
            if(NEU_Utils.safeDecimal(line.Total_Volume_m3__c)==0)
                if(NEU_Utils.safeDecimal(line.Supplier_Total_Volume_m3__c)==0)
                    if(line.Item__c!=null)
                    {
                        Sourcing_Item__c item=items.get(line.Item__c);
                        Decimal itemvolume=0;
                        if((NEU_Utils.safeDecimal(item.Master_Box_Volume_m3__c)!=0)&&(NEU_Utils.safeDecimal(item.Units_x_Master_Box__c)!=0))
                            itemvolume=item.Master_Box_Volume_m3__c/item.Units_x_Master_Box__c;
                        if(NEU_Utils.safeDecimal(itemvolume)!=0)
                            line.Total_Volume_m3__c=NEU_Utils.safeDecimal(line.Quantity__c)*itemvolume;
                    }
        }
    }
}