trigger NEU_Supplier_Quote_Order_Fee_Line_copy on Supplier_Quote_Order_Fee_Line__c (before insert) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    Set<Id>itemids=new Set<Id>();
    for(Supplier_Quote_Order_Fee_Line__c line:trigger.new)
    {
        if(NEU_Utils.safeDecimal(line.Supplier_Quote_Order_Buy_Price__c)==0)
            itemids.add(line.Fee_Name__c);
        if(NEU_Utils.safeDecimal(line.Supplier_Quote_Order_Sell_Price__c)==0)
            itemids.add(line.Fee_Name__c);
    }
    if(itemids.size()>0)
    {
        Map<Id,Fee__c>rates=new Map<Id,Fee__c>([select Id, Fee_Rate__c from Fee__c where Id IN:itemids]);
        for(Supplier_Quote_Order_Fee_Line__c line:trigger.new)
        {
            if(NEU_Utils.safeDecimal(line.Supplier_Quote_Order_Buy_Price__c)==0)
            {
                Fee__c rate=rates.get(line.Fee_Name__c);
                line.Supplier_Quote_Order_Buy_Price__c=rate.Fee_Rate__c;
            }
            if(NEU_Utils.safeDecimal(line.Supplier_Quote_Order_Sell_Price__c)==0)
            {
                Fee__c rate=rates.get(line.Fee_Name__c);
                line.Supplier_Quote_Order_Sell_Price__c=rate.Fee_Rate__c;
            }
        }
    }
}