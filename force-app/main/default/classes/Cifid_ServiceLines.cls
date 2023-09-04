global class Cifid_ServiceLines {
    global class estatus {
        webservice string code {get;set;}
        webservice string message {get;set;}
    }
    
    global class Quote{
        webservice String quoteName {get;set;}
        webservice List<ServiceLine> lines  {get;set;}
        webservice Integer operation {get;set;}
    }
    
    global class ServiceLine{
        webservice String idLine {get;set;}
        webservice String name {get;set;}
        webservice String rateName {get;set;}
        webservice Double units {get;set;}
        webservice Double quoteSellPrice {get;set;}
        webservice Double buyPrice {get;set;}
    }
    
    webservice static estatus serviceLines(Quote quote){
        System.debug('Quote: ' + quote);
        estatus result = new estatus();
        
        try{
            List<Import_Export_Fee_Line__c> lines;
            String idsLines = '';
            Set<String> linesId = new Set<String>();
            for(ServiceLine sl : quote.lines){
                if(!linesId.contains(sl.idLine)){
                    linesId.add(sl.idLine);
                    idsLines += ' ' + sl.IdLine;
                }
            }
            
            if(quote.operation == 3){
                lines = [SELECT Id, Ext_Service_Line_IMPK__c FROM Import_Export_Fee_Line__c WHERE Ext_Service_Line_IMPK__c IN:linesId];
                delete lines;
                result.code = '1';
                result.message = 'Quote Service Lines with external id ' + idsLines + ' deleted in Pak2go';
            }else{
                List<Customer_Quote__c> cq = [SELECT Id FROM Customer_Quote__c WHERE Name =:quote.quoteName];
                if(cq.size()>0){
                    if(quote.operation == 1){   
                        List<Import_Export_Fee_Line__c> linesInsert = new List<Import_Export_Fee_Line__c>();                       
                        for(ServiceLine sl : quote.lines){
                            Import_Export_Fee_Line__c l = new Import_Export_Fee_Line__c();
                            l.Import_Export_Quote__c = cq[0].Id;
                            l.Ext_Service_Line_IMPK__c = sl.idLine;
                            l.Name = sl.name;
                            l.Ext_Serv_Rate_Name_IMPK__c = sl.rateName;
                            l.Units__c = sl.units;
                            l.Quote_Sell_Price__c = sl.quoteSellPrice;
                            l.Quote_Buy_Price__c = sl.buyPrice;                            
                            linesInsert.add(l);
                        }
                        insert linesInsert;
                        result.code = '1';
                        result.message = 'Quote Service Lines with external id ' + idsLines + ' inserted in Pak2go';
                    }else if(quote.operation == 2){
                        List<Import_Export_Fee_Line__c> linesUpdate = new List<Import_Export_Fee_Line__c>();
                        Map<String, Import_Export_Fee_Line__c> mapLines = new Map<String, Import_Export_Fee_Line__c>();
                        for(Import_Export_Fee_Line__c line : [SELECT Id, Name, Ext_Serv_Rate_Name_IMPK__c, Units__c, Quote_Sell_Price__c, Quote_Buy_Price__c, Ext_Service_Line_IMPK__c
                                                       FROM Import_Export_Fee_Line__c 
                                                       WHERE Ext_Service_Line_IMPK__c IN:linesId]){
                                                           mapLines.put(line.Ext_Service_Line_IMPK__c, line);
                                                       }
                        for(ServiceLine sl : quote.lines){
                            if(mapLines.containsKey(sl.idLine)){
                                Import_Export_Fee_Line__c l = mapLines.get(sl.idLine);
                                l.Name = sl.name;
                                l.Ext_Serv_Rate_Name_IMPK__c = sl.rateName;
                                l.Units__c = sl.units;
                                l.Quote_Sell_Price__c = sl.quoteSellPrice;
                                l.Quote_Buy_Price__c = sl.buyPrice;
                                linesUpdate.add(l);
                            }                            
                        }   
                        if(linesUpdate.size()>0){update linesUpdate;}
                        result.code = '1';
                        result.message = 'Quote Service Lines with external id ' + idsLines + ' updated in Pak2go';
                    }
                }else{
                    result.code = '0';result.message = 'Error: serviceLines - External Reference not found.';
                }
            }
            
        }catch(Exception e){
            result.code = '0';result.message = 'Error:'+ e.getMessage()+' en la siguiente Linea: '+ e.getLineNumber() + ' - Trace: ' + e.getStackTraceString() + ' - Cause: ' + e.getCause();           
        }
        
        return result;
    }
}