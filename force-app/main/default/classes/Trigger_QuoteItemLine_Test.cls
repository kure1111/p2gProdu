@isTest
public class Trigger_QuoteItemLine_Test {
	@isTest(SeeAllData=true)
    //Triggers afectados
    //NEU_Import_Export_Line_Update_Margin
    //NEU_Quote_Item_Line_copy
    //PAK_CargoLines
    public static void QuoteItemLine_Test(){
        Customer_Quote__c ieqo = [SELECT Id,Account_for__c FROM Customer_Quote__c WHERE Last_Shipment__c = null AND Pricing_Executive__c != null LIMIT 1];
        Container_Type__c container = [SELECT Id, TEUS__c FROM Container_Type__c LIMIT 1];
        Sourcing_Item__c item =  new Sourcing_Item__c();
        item.Name = 'item tst';
        item.Account_Owner__c = ieqo.Account_for__c;
        insert item;
        
        Quote_Item_Line__c ql = new Quote_Item_Line__c();
        ql.Name = 'tst1';
        ql.Item_Name__c = item.Id;
        ql.Units__c = 1;
        ql.Margin_at_Destination__c = 2;
        ql.Import_Export_Quote__c = ieqo.Id;
        insert ql;
        
        ql.Container_Type__c = container.id;
        ql.Total_Shipping_Weight_Kgs__c = 20;
        ql.Total_Shipping_Volume_m3__c = 10;
        update ql;
        
     }
}