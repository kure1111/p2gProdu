public class P2g_updateServiceLineOC {
    
    public static void inOcStatus(List<String> inputList) {
        try{
            List<Id> listIdServicesLines = new List<String>();
            List<String> listOc = new List<String>();
            List<String> listStatus = new List<String>();
            for (String inputString : inputList) {
                String stringWithoutSpaces = inputString.replaceAll(' ', '');
                List<String> parsedValues = new List<String>();
                String[] parts = stringWithoutSpaces.split('\\|');
                if(parts.size() >2){                   
                    String status = parts[1].substringAfter('Estatus:');
                    String oc =parts[0].substringAfter('OCCreada');   
                    listIdServicesLines.add(parts[2]);
                    listStatus.add(status);
                    listOc.add(oc);      
                }
            }
            
            if(!listIdServicesLines.isEmpty()){
                List<Shipment_Fee_Line__c> lisServicesline = [SELECT Id,Orden_Compra__c, SST_Estatus_orden_compra__c from Shipment_Fee_Line__c
                                                              where id IN: listIdServicesLines];
                for(Shipment_Fee_Line__c serviceLine:lisServicesline){
                    Integer index = listIdServicesLines.indexOf(serviceLine.Id);
                    serviceLine.SST_Estatus_orden_compra__c = listStatus[index];
                    serviceLine.Orden_Compra__c = listOc[index];                
                }
                update lisServicesline;
            }
        }
        catch(Exception e){
            System.debug('Error en P2g_updateServiceLineOC: '+e.getLineNumber()+' tipo: '+e.getMessage());
        }
        
    }
}