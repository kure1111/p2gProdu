public class PAK_QuoteBigFreight {
	public Customer_Quote__c record;
    public String disp_1 {get;set;}
    public String disp_2 {get;Set;}
    public String Pagina {get;set;}
    public PAK_QuoteBigFreight(Apexpages.StandardController Controller){
       	record = new Customer_Quote__c();
        if(!Test.isRunningTest()){record = [Select Freight_Mode__c,Service_Mode__c, Service_Type__c, Total_Items_Units__c From Customer_Quote__c Where Id =:Controller.getId() limit 1];}
        if(record.Freight_Mode__c=='Sea' && record.Service_Type__c == 'FCL' && record.Total_Items_Units__c > 4){disp_1='display:Block';}else{disp_1='display:none';}
        if(record.Freight_Mode__c == 'Road' && record.Service_Mode__c == 'NATIONAL' && record.Service_Type__c == 'FTL'){disp_2='display:Block';}else{disp_2='display:none';}
    }
}