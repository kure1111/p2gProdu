@isTest
public class P2G_NEU_IE_Line_Update_ConversionsTest {

    @isTest(SeeAllData=true)
    static void NEU_IE_Line_Update_Conversions(){
        Customer_Quote__c quote_test = [SELECT Id,Name, Total_Services_Order_Amount_NoIMP__c, Account_for__c, Account_for__r.RecordType.Name,
                                        Total_Services_Std_Buy_Amount_NoIMP__c, Margen_Operativo__c,Impak_Request__c,ETA__c, ETD__c
                                        FROM Customer_Quote__c where  Margen_Operativo__c  !=null 
                                        AND Pricing_Executive__c!=null AND Account_for__r.Owner.IsActive=true AND Account_for__r.Owner.SalesEmployer__c!=NULL 
                                        LIMIT 1];
        
        Account account_test = [SELECT Id FROM Account WHERE Id=:quote_test.Account_for__c];                
        
        
        Sourcing_Item__c item =  new Sourcing_Item__c();
        item.Name = 'item tst';
        item.Account_Owner__c = account_test.Id;
        insert item;
        
        Quote_Item_Line__c ql = new Quote_Item_Line__c();
        ql.Name = 'tst1';
        ql.Item_Name__c = item.Id;
        ql.Units__c = 1;
        ql.Total_Shipping_Weight_Kgs__c = 20;
        ql.Total_Shipping_Volume_m3__c = 10;
        ql.Margin_at_Destination__c = 2;
        ql.Import_Export_Quote__c = quote_test.Id;
        insert ql;
        
        ql.Name='test0002';
        update ql;
    }
}