trigger NEU_Fields_copy_production_plan on Production_Order__c (before update, before insert) 
{
    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    for(Production_Order__c line:trigger.new) 
    {
        line.Equivalent_Product_Item_Units_copy__c = line.Equivalent_Product_Item_Units__c;
        line.Loading_Time_copy__c = line.Loading_Time__c;
        line.Nominal_Speed_units_h_copy__c = line.Nominal_Speed_units_h__c;
        line.Product_Mix_copy__c = line.Product_Mix__c;
    }
}