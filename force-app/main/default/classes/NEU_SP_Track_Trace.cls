public with sharing class NEU_SP_Track_Trace
{
    private Shipment__c record;
    private ApexPages.StandardController con;
    public boolean Ground_Track_Trace_or_Road_Route{get;set;}
    public NEU_SP_Track_Trace(ApexPages.StandardController stdController)
    {
        if (!Test.isRunningTest()){stdController.AddFields(new String[]{'Id','Name', 'Account_Stop_B__c', 'Account_Stop_C__c', 'Freight_Mode__c'});}
        con=stdController;
        record=(Shipment__c )stdController.getRecord();
        Ground_Track_Trace_or_Road_Route = false;
        
        if(record.Account_Stop_B__c != null  || record.Account_Stop_C__c != null)
            Ground_Track_Trace_or_Road_Route = true;    
    }
}