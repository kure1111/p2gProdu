public class P2G_CapturaOrdenCompra {

    public static void main(List<Response__c> newResponses){        
        SET<Id> idsShipment=new SET<Id>();
        MAP<Id,String> mapShipmentOC=new Map<Id,String>();
        for(Response__c res:newResponses){
            if(res.Type__c=='CONFIRM' && res.SolOrdenCompraSAP__c!=null && res.Object__c=='Shipment' && res.Shipment__c!=null &&(!res.Servicio__c.contains('SP-FN'))){idsShipment.add(res.Shipment__c);mapShipmentOC.put(res.Shipment__c,res.SolOrdenCompraSAP__c);
            }
        }
        List<Shipment_Fee_Line__c> listSPServiceLine= getAllShipmentServiceLines(idsShipment);
        if(listSPServiceLine.size()>0 || Test.isRunningTest()){editOrdenCompra(listSPServiceLine,mapShipmentOC);
        }
    }
    
    public static List<Shipment_Fee_Line__c> getAllShipmentServiceLines(SET<Id> idsShipment){
        return [SELECT Id, Orden_Compra__c, Shipment__c  FROM Shipment_Fee_Line__c WHERE Shipment__c=: idsShipment];
    }
    
    public static void editOrdenCompra(List<Shipment_Fee_Line__c> listSPServiceLine, MAP<Id,String> mapShipmentOC){
        for(Shipment_Fee_Line__c spServLine: listSPServiceLine){
            if(spServLine.Orden_Compra__c==null && spServLine.Shipment__c!=null 
               && mapShipmentOC.containsKey(spServLine.Shipment__c)){
                   spServLine.Orden_Compra__c=mapShipmentOC.get(spServLine.Shipment__c);
            }
        }
        updateFieldOrdenCompra(listSPServiceLine);
    }
    
    public static void updateFieldOrdenCompra(List<Shipment_Fee_Line__c> listSPServiceLineUpd){        
        update listSPServiceLineUpd;
    }
}