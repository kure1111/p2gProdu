/**
 * Created by aserrano on 04/01/2018.
 */

trigger NEU_ActualizaFolioINV on Invoice__c (before insert, before update)
{
    if(NEU_StaticVariableHelper.getBoolean1()){return;}
    
    if(!RecursiveCheck.triggerMonitor.contains('NEU_ActualizaFolioINV')){
        RecursiveCheck.triggerMonitor.add('NEU_ActualizaFolioINV');
        
        if(trigger.isInsert) {
            P2G_ValidateStatusInvoice.validateInvoiceCreation(trigger.new);
        }
        
        if(trigger.isInsert == true)
        {
            for(Invoice__c inv : trigger.new)
            {
                string ref = 'INV';
                
                List<INV_Counter__c> contador = [SELECT Contador__c FROM INV_Counter__c FOR UPDATE];
                
                if(!Test.isRunningTest()){ /*Si hemos cambiado de año reiniciamos el contador, si no es así simplemente lo incrementamos*/Integer contadorAnual = [SELECT COUNT() FROM Invoice__c WHERE CALENDAR_YEAR(CreatedDate) =: system.today().year()];if(contadorAnual == 0){contador[0].Contador__c = 1; }else{ contador[0].Contador__c += 1;}inv.Numero_Folio__c = contador[0].Contador__c;
                }
                else
                {
                    inv.Numero_Folio__c = 1;
                }
                
                ref += '-'+string.valueof(system.today().year()).right(2)+'-';
                ref += ('000000' + (inv.Numero_Folio__c != null ? String.valueOf(inv.Numero_Folio__c) : '')).right(6);
                
                inv.Name = ref;
                
                update contador;
            }
        }
        else
        if(trigger.isUpdate == true) {
            // Recopilar todos los IDs de Invoice__c que se están actualizando
            Set<Id> invoiceIds = new Set<Id>();
            for(Invoice__c inv : trigger.new) {
                invoiceIds.add(inv.Id);
            }
            
            // Consultar todas las Invoice_Line__c relacionadas con estas invoices
            // y sus Shipment_Service_Line__c con Campo_Control__c
            Map<Id, List<Invoice_Line__c>> invoiceLinesMap = new Map<Id, List<Invoice_Line__c>>();
            
            for(Invoice_Line__c line : [
                    SELECT Id, Invoice__c, Shipment_Service_Line__r.Campo_Control__c 
                    FROM Invoice_Line__c 
                    WHERE Invoice__c IN :invoiceIds
                    AND Shipment_Service_Line__r.Campo_Control__c = true
                ]) {
                if(!invoiceLinesMap.containsKey(line.Invoice__c)) {
                    invoiceLinesMap.put(line.Invoice__c, new List<Invoice_Line__c>());
                }
                invoiceLinesMap.get(line.Invoice__c).add(line);
            }
            
            // Obtener el perfil del usuario actual (una sola vez)
            User currentUser = [
                SELECT Profile.Name 
                FROM User 
                WHERE Id = :UserInfo.getUserId()
            ];
            Boolean isAdminUser = currentUser.Profile.Name != null && currentUser.Profile.Name.containsIgnoreCase('Admin');
            
            // Validar para cada Invoice__c si tiene líneas con Campo_Control__c = true
            for(Invoice__c inv : trigger.new) {
                // Verificar si esta invoice tiene líneas con Campo_Control__c activo
                if (invoiceLinesMap.containsKey(inv.Id)) {
                    
                    String newStatus = inv.Invoice_Status__c;
                    
                    // Solo bloquear si el nuevo estatus no es "Cancel"
                    if (!isAdminUser && (newStatus == null || newStatus != 'Cancel')) {
                        inv.addError('No es posible modificar debido a que cuenta con una Orden de Entrega');
                    }
                }
                
                // Tu lógica original: No se permite cambiar el Name
                Invoice__c old_inv = Trigger.oldMap.get(inv.Id);
                inv.Name = old_inv.Name;
            }
        }
    }
}