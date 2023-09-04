trigger NEU_Fields_copy_item_to_production_plan on Sourcing_Item__c (before update, before insert)
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;
    
    List<Id> lista_ids_items = new List<Id>();
    for(Sourcing_Item__c line:trigger.new) 
    {
        if(trigger.isupdate)
        {
            Sourcing_Item__c olditem = Trigger.oldMap.get(line.ID);
            if(olditem.Equivalent_Item_Units__c != line.Equivalent_Item_Units__c)
                lista_ids_items.add(line.Id);
        }
    }
    
    if(lista_ids_items.size()>0)
    {
        List<Production_Order__c> consulta_production_plan = [select Id, Name, Item__c from Production_Order__c where Item__c IN: lista_ids_items];
        if(consulta_production_plan.size()>0)
            update consulta_production_plan;
    }
}