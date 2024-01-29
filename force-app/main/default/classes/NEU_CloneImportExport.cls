public with sharing class NEU_CloneImportExport {
    public String resultado {get;set;}
    public Customer_Quote__c record=null;
    
    public NEU_CloneImportExport(ApexPages.StandardController stdController) 
    {
        if (!Test.isRunningTest())stdController.AddFields(new String[]{'Id', 'Account_for__r.ActiveSap__c'});
        record=(Customer_Quote__c)stdController.getRecord();
    }
    
    public PageReference duplicate_order()
    {
        try{
            if(Test.isRunningTest() || record.Account_for__r.ActiveSap__c) {
                String newquoteid = splitImportExport(record.Id);
                if (String.IsNotEmpty(newquoteid)) {
                    //List<Quote_Item_Line__c>lines=splitImportExportLine(record.Id,newquoteid);
                    splitImportExportFeeLine(record.Id, newquoteid);
                    //if(lines.size()>0)
                    //    update lines;
                    PageReference pgReturnPage = new PageReference('/' + newquoteId);
                    pgReturnPage.setRedirect(true);
                    return pgReturnPage;
                }
            }
        }catch(Exception ex){resultado = ''+ex; System.debug(ex);}
        return null;
    }

    public PageReference back_record()
    {
            PageReference pgReturnPage = new PageReference('/' + record.Id);
            pgReturnPage.setRedirect(true);
            return pgReturnPage;
    }

    private void splitImportExportFeeLine(String quoteid,String newquoteid)
    {
        String query='select Id,Name';
        Boolean firstField=true;
        Map<String,Schema.SObjectField>objectFields=Import_Export_Fee_Line__c.getSobjectType().getDescribe().fields.getMap();
        for(String s:objectFields.keySet())
            if((s!='Id')&&(s!='Name'))
                query+=','+s;
        query+=' from Import_Export_Fee_Line__c where Import_Export_Quote__c=\''+quoteid+'\'';
        List<Import_Export_Fee_Line__c>lines=database.query(query);
        List<Import_Export_Fee_Line__c>newlines= new List<Import_Export_Fee_Line__c>();

        for(Import_Export_Fee_Line__c line:lines)
        {
            Import_Export_Fee_Line__c newline=line.clone(false,true);
                        
            newLine.Import_Export_Quote__c=newquoteid;       
            

            if (line.Service_Rate_Name__c != null){
                Fee__c oldRate = [SELECT Id,RecordTypeId, Name,Route__c,CurrencyIsoCode,Fee_Category__c,Group__c,SAP_Service_Type__c,
                Container_Type__c,TT_Days__c,Rate_Type__c,Account_for__c,Active__c,Fee_Rate__c,Buy_Rate__c FROM Fee__c WHERE Id = :line.Service_Rate_Name__c];
                Fee__c newRate = oldRate.clone(false, false);
                insert newRate;
                newline.Service_Rate_Name__c = newRate.Id;  
            }
            
            if(newLine.Tarifario__c){                                
                newline.Quote_Buy_Price__c = newline.Buy_Rate__c;
                newline.Quote_Sell_Price__c = newline.Sell_Rate__c;            
            }                 

            newlines.add(newline);
        }
        if(newlines.size()>0)
            insert newlines;
    }
    private String splitImportExport(String quoteid)
    {
        String query='select Id,Name';
        Boolean firstField=true;
        Map<String,Schema.SObjectField>objectFields=Customer_Quote__c.getSobjectType().getDescribe().fields.getMap();
        system.debug('object fields '+ objectFields);
        for(String s:objectFields.keySet())
            if((s!='Id')&&(s!='Name'))
                query+=','+s;
        query+=' from Customer_Quote__c where Id=\''+quoteid+'\'';
        List<Customer_Quote__c>lines=database.query(query);
        System.debug('lines '+lines);
        if(lines.size()>0)
        {
            Customer_Quote__c newline=lines[0].clone(false,true);            
            try{
                newline.Awaiting_load_time__c = null;
                newline.Awaiting_unload_time__c = null; 
                //newline.ByPass__c = null;
                newline.Quotation_Status__c = null;
                newline.Last_Shipment__c = null;
                newline.Approved_Date_time01__c = null;
                newline.Declined_Date_time__c = null;
                newline.Invoiced_Correctly__c = false;
                newline.Date_Invoice_Checked__c = null;
                newline.Cloned__c = true;
                newline.BOL_Associated__c = false;
                newline.Purchase_OrderNum__c = '';
                newline.Id_Import_Export_Origin__c = lines[0].Id;
                newline.Name_Import_Export_Origin__c = lines[0].Name;
                newline.RecordTypeId = Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
                newline.ETD__c = null;
                newline.ETA__c = null;
                newline.Pickup_Cartage__c = null;
                newline.Delivery_Cartage__c = null;
                newline.Date_Pricing_responded__c = null;
                newline.clave_de_lead__c = 'Folio Duplicado';
                
                if(newline.Opportunity__c != null){
                    newline.Opportunity__c = null;
                }

                System.debug('newline '+newline);                
                insert newline;

                return newline.Id;
            }catch(Exception e){resultado = 'Error: '+e; system.debug('Error: ' + e.getCause() + ' linea : ' + e.getLineNumber());}
        }
        return null;
    }
}