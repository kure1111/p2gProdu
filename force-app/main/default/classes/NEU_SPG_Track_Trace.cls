public with sharing class NEU_SPG_Track_Trace
{
    private Shipment_Program__c record;
    private ApexPages.StandardController con;
    public NEU_SPG_Track_Trace(ApexPages.StandardController stdController)
    {
        if (!Test.isRunningTest()){stdController.AddFields(new String[]{'Id','Name','Freight_Mode__c'});}
        con=stdController;
        record=(Shipment_Program__c)stdController.getRecord();
    }
}