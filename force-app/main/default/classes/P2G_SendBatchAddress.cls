public class P2G_SendBatchAddress implements Database.Batchable<SObject>, Database.AllowsCallouts {
    //P2G_SendBatchAddress batch = new P2G_SendBatchAddress();
	//Database.executeBatch(batch, 50);

    // Query para obtener los registros que deseas procesar
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Account_Address__c WHERE status__c = \'Nuevo\'';
        return Database.getQueryLocator(query);
    }

    // Procesa los registros en lotes de 50
    public void execute(Database.BatchableContext BC, List<Account_Address__c> scope) {
        for(Account_Address__c accAddress : scope) {
            P2G_updateAddresWs.send(accAddress.Id);
        }
    }

    // Finaliza el batch
    public void finish(Database.BatchableContext BC) {
        System.debug('Batch finalizado');
    
        // Crear el mensaje de correo
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'alberto.garcia@2gologistics.com'});
        email.setSubject('Batch Terminado');
        email.setPlainTextBody('Batch terminado de envio de direcciones a CR');
        
        // Enviar el correo
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
}