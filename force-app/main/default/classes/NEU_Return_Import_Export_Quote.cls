public with sharing class NEU_Return_Import_Export_Quote
{
    public Shipment__c record;
    ApexPages.StandardController con;
    public NEU_Return_Import_Export_Quote(ApexPages.StandardController stdController) {
        con = stdController;
        try { 
        record = [select Id, Name from Shipment__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
          record = new Shipment__c();
        }
    }
    
    public Pagereference return_ie()
    { 
        List<Shipment_Consolidation_Data__c> query_ship_conso_data = [select Id, Name, Import_Export_Quote__c  from Shipment_Consolidation_Data__c where Shipment__c =: record.Id];
        if(query_ship_conso_data != null && query_ship_conso_data.size()>0)
        {
            PageReference pgReturnPage;
            String returnUrl = '/' + query_ship_conso_data[0].Import_Export_Quote__c;
            pgReturnPage = new PageReference(returnUrl);
            pgReturnPage.setRedirect(true);
            return pgReturnPage;
        }
        else
            return null;
    }
}