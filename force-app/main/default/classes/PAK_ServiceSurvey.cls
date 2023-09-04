public class PAK_ServiceSurvey {
    public Shipment__c shipment {get;set;}
    public Boolean valid {get;set;}
    
    public PAK_ServiceSurvey(){}
    
    public PageReference validate(){
        valid = true;
        Id shipId = ApexPages.currentPage().getParameters().get('shipId');        
        if(shipId == null){
            PageReference pageRef = new PageReference('/apex/FileNotFound');return pageRef;
        }else{
            shipment = [SELECT Id, Name, Rating__c FROM Shipment__c WHERE Id =:shipId LIMIT 1];
            if(shipment.Rating__c != null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Encuesta ya recibida'));valid = false;
            }
        }
        return null;
    }
    
    public PageReference save() {
        try{
            if(shipment.Rating__c != null){
                update shipment;
                valid = false;
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Encuesta recibida exitosamente!'));
            }            
        }catch(Exception ex){ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ex.getMessage()));
        }
        return null;
    }
}