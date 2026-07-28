public class P2G_AcuseRecibidoEmail {
    public static void sendEmail(List<Shipment__c> newShipments, Map<Id, Shipment__c> oldMap){
        
        Set<Id> shipmentIds = new Set<Id>();

        for (Shipment__c newShipment : newShipments) { 
            Shipment__c oldshipment = oldMap.get(newShipment.Id);
            
            if(newShipment.Status_Acuse_SAP__c == 'ACUSE RECIBIDO' && oldShipment.Status_Acuse_SAP__c != 'ACUSE RECIBIDO') {
                shipmentIds.add(newShipment.Id);
            }
        }
        if(!shipmentIds.isEmpty()){
            List<Id> shipmentIdsList = new List<Id>();
            shipmentIdsList.addAll(shipmentIds);
            
        	sendEmailFuture(new List<Id>(shipmentIdsList));
            }
    }
        @future
        public static void sendEmailFuture(List<Id> shipmentIds) {
            
            List<Shipment__c> shipments = [
            SELECT Id, Name, Status_Acuse_SAP__c, Carrier__c, Carrier__r.NEU_Email__c, Carrier__r.Name, Date_Verify_Acuse_SAPTxt__c/*Date_Acuse_SAP__c --campo de uat*/ FROM Shipment__c WHERE Id IN :shipmentIds
        ];

        Map<Id, List<Shipment_Fee_Line__c>> serviceLines = new Map<Id, List<Shipment_Fee_Line__c>>();
            
        for(Shipment_Fee_Line__c serviceLine : [SELECT Id, Name, Shipment__c, Orden_Compra__c FROM Shipment_Fee_Line__c WHERE Shipment__c IN :shipmentIds]) {
        	if (!serviceLines.containsKey(serviceLine.Shipment__c)) {
                    serviceLines.put(serviceLine.Shipment__c, new List <Shipment_Fee_Line__c>());
            }
            
           	serviceLines.get(serviceLine.Shipment__c).add(serviceLine);
		}
        List<Messaging.SingleEmailMessage> emails =  new List<Messaging.SingleEmailMessage>();

        for (Shipment__c shipment : shipments) {
             
            String ordenCompra = '';
            
            List<Shipment_Fee_Line__c> sLines = serviceLines.get(shipment.Id);
                if (sLines != null) {
                    for (Shipment_fee_Line__c sLine : sLines) {
                        ordenCompra += sLine.Orden_Compra__c;
                    }
                }
            
            	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

                email.setToAddresses(new List<String>{
                    shipment.Carrier__r.NEU_Email__c
                });
                
                email.setSubject('Notificación de recepción de acuse en base al folio ' + shipment.Name);
                String fechaAcuse = shipment.Date_Verify_Acuse_SAPTxt__c != null ? shipment.Date_Verify_Acuse_SAPTxt__c.format() : '';
            	//String fechaAcuse = shipment.Date_Acuse_SAP__c != null ? shipment.Date_Acuse_SAP__c.format() : ''; UAT
                String htmlBody = '';
                htmlBody += '<html>';
                htmlBody += '<body>';
                htmlBody += '<p>Buen día <b>' + shipment.Carrier__r.Name + '</b>,</p>';
                htmlBody += '<p>Se ha aprobado y anexado con éxito al día <b>' + fechaAcuse + '</b>, el acuse correspondiente a la orden de compra <b>' + ordenCompra + '</b>, servicio <b>' + shipment.Name + '</b>.</p>';
                htmlBody += '</body>';
                htmlBody += '</html>';  
                 
                email.setHtmlBody(htmlBody);
                    
                emails.add(email);    
            }
            if(!emails.isEmpty()) {
                Messaging.sendEmail(emails);
            }
        }
    }