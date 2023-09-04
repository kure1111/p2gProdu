trigger PAK_SR_Prom on Shipment_Fee_Line__c (after insert, after update) {
    if(NEU_StaticVariableHelper.getBoolean1())
        return;
    private Decimal sumaValor {get;set;}
    private Integer records {get;set;}
    private Decimal promedio {get;set;}
    private Decimal sumaUnits {get;set;}
    private Decimal promedioUnits {get;set;}
    
    if(trigger.isInsert || trigger.isUpdate){
        Set<Id> idsFee = new Set<Id>();
        for(Shipment_Fee_Line__c ssl : trigger.New){
            if(ssl.Service_Rate_Name__c != null && !idsFee.contains(ssl.Service_Rate_Name__c)){
                idsFee.add(ssl.Service_Rate_Name__c);
            }
        }
        
        List<Fee__c> lstServiceRates = [SELECT Id, FN_Average_Cost__c, FN_Average_Trips__c FROM Fee__c WHERE Id IN:idsFee];
        List<Shipment_Fee_Line__c> lstShipServLine = [SELECT Id, Service_Rate_Name__c, Std_Buy_Amount__c, Units__c FROM Shipment_Fee_Line__c WHERE Service_Rate_Name__c IN:idsFee AND Service_Rate_Category__c = 'Road Freights' AND Shipment_Status_Planner__c = 'Confirmed'];
        List<Fee__c> srToUpd = new List<Fee__c>();
        
        for(Fee__c f : lstServiceRates){
            sumaValor = 0;
            records = 0;
            promedio = 0;
            promedioUnits = 0;
            sumaUnits = 0;
            for(Shipment_Fee_Line__c ssl : lstShipServLine){
                if(f.Id == ssl.Service_Rate_Name__c){records = records + 1;sumaValor += ssl.Std_Buy_Amount__c ==null?0:ssl.Std_Buy_Amount__c;sumaUnits += ssl.Units__c==null?0:ssl.Units__c;}
            }
            if(records > 0){promedio = sumaValor / records;promedioUnits = sumaUnits / records;f.FN_Average_Cost__c = promedio;f.FN_Average_Trips__c = promedioUnits;srToUpd.add(f);}
        }
        
        if(srToUpd.size() > 0){update srToUpd;}
    }
}