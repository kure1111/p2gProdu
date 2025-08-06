public class P2G_NoEliminarLineaEnSAP {
    public static void noElimiarLinea(Shipment_Fee_Line__c serviceLine){
        Datetime dateResponse = consultaSapResponse(serviceLine.Shipment__c);
        if(dateResponse != NULL && dateResponse > serviceLine.CreatedDate){
            if(!Test.isRunningTest()){
                serviceLine.addError('No se puede eliminar la línea si ya ha sido enviada a SAP');
            }
        }
    }
    public static Datetime consultaSapResponse(String spId){
        Datetime creacionResponse;
        List<Response__c> response = [SELECT Id, Name, CreatedDate FROM Response__c WHERE Shipment__c =: spId 
                                      AND Type__c = 'CONFIRM' 
                                      AND Message__c != 'Carga correcta en recurso confiable'
                                      Order By CreatedDate desc LIMIT 1];
        if(response.size() > 0){
            creacionResponse = response[0].CreatedDate;
        }else{
            creacionResponse = NULL;
        }
        return creacionResponse;
    }
}