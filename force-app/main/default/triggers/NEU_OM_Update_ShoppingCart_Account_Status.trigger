trigger NEU_OM_Update_ShoppingCart_Account_Status on Shopping_Cart__c (after insert, after update) {

    if(NEU_StaticVariableHelper.getBoolean1())
        return;

    List<Shopping_Cart_line__c>Shop_lines=[select Id, Account_for_Record_Type_TEXT__c,Shopping_Cart__r.Account_for_Record_Type__c,Shopping_Cart_Status_TEXT__c,Shopping_Cart__r.Status__c from Shopping_Cart_line__c where Shopping_Cart__c IN:trigger.new];
    for(Shopping_Cart_line__c sl : Shop_lines)
    {
        sl.Account_for_Record_Type_TEXT__c = sl.Shopping_Cart__r.Account_for_Record_Type__c;
        sl.Shopping_Cart_Status_TEXT__c = sl.Shopping_Cart__r.Status__c;
    }
    try
    {
        update Shop_lines;
    }
    catch(Exception ex){ }
}