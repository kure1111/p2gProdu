@isTest
public class P2G_NEU_IE_Service_Upd_ConversionTest {
	@isTest(SeeAllData=true)
    static void NEU_IE_Service_Update_Conversions(){
        Customer_Quote__c quote= [SELECT Id,Name, Total_Services_Order_Amount_NoIMP__c, Account_for__c, Account_for__r.RecordType.Name,
                                        Total_Services_Std_Buy_Amount_NoIMP__c, Margen_Operativo__c,Impak_Request__c,ETA__c, ETD__c
                                        FROM Customer_Quote__c where  Margen_Operativo__c  !=null 
                                        AND Pricing_Executive__c!=null AND Account_for__r.Owner.IsActive=true AND Account_for__r.Owner.SalesEmployer__c!=NULL 
                                        LIMIT 1];
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = quote.id,Name = 'lineas items'
                                                                         , Extension_Service_Name__c='test extension fee name', Discount__c=10, Quote_Buy_Price__c=10
                                                                         , Quote_Sell_Price__c=10,Units__c=10 );
        insert quote2;
        
        quote2.Name='TEST0001';
        update quote2;
    }
}