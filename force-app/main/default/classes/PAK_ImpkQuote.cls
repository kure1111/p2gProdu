global class PAK_ImpkQuote {
    global class estatus{
        webservice String code {get; set;}
        webservice String message {get; set;}
    }
    
    global class Quote{
        webservice String quoteName {get;set;}
        webservice String pricing {get;set;}
        webservice Datetime datePricingResponse {get;set;}
        webservice String FinalClient {get;set;}
        webservice String stage {get;set;}
    }
    
    webservice static estatus updateQuote(Quote quote){
        System.debug('Quote: ' + quote);
        estatus result = new estatus();
        try{
            List<Customer_Quote__c> qc = [SELECT Id, Ext_Pricing_Impk__c, Date_Pricing_responded__c, External_Final_Client_WS__c, External_Stage_Impak__c FROM Customer_Quote__c WHERE Name =:quote.quoteName];
            if(qc.size()>0){
                qc[0].Ext_Pricing_Impk__c = quote.pricing;
                qc[0].Date_Pricing_responded__c = quote.datePricingResponse;
                qc[0].External_Final_Client_WS__c = quote.FinalClient;
                qc[0].External_Stage_Impak__c = quote.stage;
                update qc[0];
                result.code = '1';
                result.message = 'Quote updated';
            }else{
                result.code = '0';
                result.message = 'Quote updated';
            }            
        }catch(Exception e)
        {
            result.code = '0';
            result.message = 'Error:'+ e.getMessage()+' en la siguiente Linea: '+ e.getLineNumber() + ' - Trace: ' + e.getStackTraceString() + ' - Cause: ' + e.getCause();
        }
        return result;
    }
}