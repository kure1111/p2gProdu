public class P2G_AssociatedDocumentsHandler {
    public static void main(List<Associated_Document__c> listAssociatedDoc){
        SET<Id> idsShipment= new Set<Id>();
        String labelValue= System.label.TypeDocumentSp;
        for(Associated_Document__c doc:listAssociatedDoc){			         
            if(doc.Document_Description__c!=null && doc.Document_Description__c.contains(labelValue) && doc.Document_Type__c=='Other'){
            	idsShipment.add(doc.Shipment__c);    
            }            
        }
        List<Shipment__c> listShipment= getAllShipments(idsShipment);
        if(listShipment.size()>0){
            loadDocumentDebitNote(listShipment);
        }
    }
    
    public static List<Shipment__c> getAllShipments(Set<Id> idsShipment){        
        return [SELECT Id, Debit_Note_Uploaded__c FROM Shipment__c WHERE Id =: idsShipment];
    }
    
    public static void loadDocumentDebitNote(List<Shipment__c> listShipment){
        for(Shipment__c sp: listShipment){
            if(sp.Debit_Note_Uploaded__c!=true){
            	sp.Debit_Note_Uploaded__c=true;    
            }            
        }
        updateFieldDebitNote(listShipment);
    }
    
    public static void updateFieldDebitNote(list<Shipment__c> listShipmentUpd){        
        update listShipmentUpd;
    }
    
    
}