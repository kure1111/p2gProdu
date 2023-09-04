public class PK2_FI_IEQ {
    public static Transient list<Customer_Quote__c> lstQ {get;set;}
    public DateTime fechaInicial {get;set;}
    public DateTime fechaFinal {get;set;}
    
    public PK2_FI_IEQ(){
        fechaInicial = DateTime.valueOf(System.today().Year() + '-' + System.today().Month() + '-01 00:00:00').addHours(-6);
		fechaFinal = DateTime.valueOf(System.today().Year() + '-' + System.today().Month() + '-' + Date.daysInMonth(System.today().Year(), System.today().Month()) + ' 23:59:59').addHours(-6);
        lstQ = [Select Id,
                Name,
                Mode__c,
                Route__c,
                CreatedDate,
                Account_for__r.Name,
                Account_for__r.Workplace_AccOwner__c,
                CreatedBy.Name,
                Pricing_Executive__r.Name,
                (Select Container_Type__r.Name From Import_Export_Items_Lines__r),
                Quotation_Status__c 
                From Customer_Quote__c 
                Where Account_for__r.Customer_Id__c !='CMTY3748' and Name LIKE 'FI-%' and Quotation_Status__c IN ('Shipped', 'Approved as Succesful') and CreatedDate>=:fechaInicial and CreatedDate<=:fechaFinal
                and Last_Shipment__c = null  Order by Quotation_Status__c,Account_for__r.Workplace_AccOwner__c asc];
    }
}