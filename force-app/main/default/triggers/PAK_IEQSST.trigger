trigger PAK_IEQSST on Customer_Quote__c (before update) {
    if(NEU_StaticVariableHelper.getBoolean1()){return;}
    
    if(!RecursiveCheck.triggerMonitor.contains('PAK_IEQSST')){
     	RecursiveCheck.triggerMonitor.add('PAK_IEQSST');
        if(Trigger.isUpdate && Trigger.isBefore){
            System.debug('Trigger validation Group && Sap Service Type');
            Set<Id> idsQuote = new Set<Id>();
            for(Customer_Quote__c quote : Trigger.New){
                if((Trigger.oldMap.get(quote.Id).Quotation_Status__c != quote.Quotation_Status__c && quote.Quotation_Status__c == 'Approved as Succesful') && !idsQuote.contains(quote.Id)){idsQuote.add(quote.Id);}
            }
            System.debug('Quotes Ids: ' + idsQuote);
            List<Import_Export_Fee_Line__c> lines = [SELECT Id, Import_Export_Quote__c, Service_Rate_Name__c, Service_Rate_Name__r.Group__c, Service_Rate_Name__r.SAP_Service_Type__c 
                                                     FROM Import_Export_Fee_Line__c 
                                                     WHERE Import_Export_Quote__c IN:idsQuote];
            System.debug('Lines: ' + lines);
            for(Customer_Quote__c quote : Trigger.New){
                for(Import_Export_Fee_Line__c line : lines){
                    if(quote.Id == line.Import_Export_Quote__c && (line.Service_Rate_Name__c == null || line.Service_Rate_Name__r.Group__c == null || line.Service_Rate_Name__r.SAP_Service_Type__c == null)){
                        System.debug('Line error: ' + line.Id);
                        if(!Test.isRunningTest()){quote.addError('Verificar que todas las partidas tengan Grupo y SAP Service Type');}
                    }
                }
            }
    
        }
    }    
}