public class P2G_EmailServiceError {
    
    public static void enviarEmailPorError(Response__c response) {
        // Verificar criterios
        if (!cumpleCriterios(response)) {
            return;
        }
        
        try {
            // Obtener el Invoice con el usuario creador
            Invoice__c invoice = [
                SELECT Id, Name, CreatedById, CreatedBy.Email, CreatedBy.Name 
                FROM Invoice__c 
                WHERE Id = :response.Invoice__c 
                LIMIT 1
            ];
            System.debug('Punto de control 3 ' + invoice);
            // Verificar que el usuario creador tenga email
            if (String.isBlank(invoice.CreatedBy.Email)) {
                return;
            }
            // Crear y enviar email
            Messaging.SingleEmailMessage email = crearEmailError(response, invoice);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        } catch (Exception e) {
            System.debug('Error enviando email: ' + e.getMessage());
        }
    }
    
    private static Boolean cumpleCriterios(Response__c response) {
        // Verificar que Invoice__c no sea nulo
        if (response.Invoice__c == null) {
            return false;
        }
        
        // Verificar que Type__c sea 'ERROR'
        if (response.Type__c != 'ERROR') {
            return false;
        }
        
        if (response.CreatedById != '0054T000000cUdmQAE' && !test.isRunningTest()) {
            return false;
        }
        return true;
    }
    
    private static Messaging.SingleEmailMessage crearEmailError(Response__c response, Invoice__c invoice) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        // Obtener URL de la Org
        String orgUrl = URL.getOrgDomainURL().toExternalForm();
        
        // Configurar destinatario con el email del creador de la Invoice
        email.setToAddresses(new String[]{ invoice.CreatedBy.Email });
        email.setCcAddresses(new String[]{'mario.velazquez@2gologistics.com', 'alberto.garcia@2gologistics.com','enrique.betancourt@2gologistics.com','priscila.adame@2gologistics.com','fernanda.rodriguez@2gologistics.com'});
        // Configurar asunto
        email.setSubject('Error en registro - Invoice: ' + invoice.Name);
        
        // Configurar cuerpo del email
        /*String cuerpoEmail = 'Estimado/a ' + invoice.CreatedBy.Name + ',\n\n';
        cuerpoEmail += 'Se ha detectado un error en su registro por SAP.\n\n';
        cuerpoEmail += 'Detalles del error:\n';
        cuerpoEmail += '- Invoice: ' + invoice.Name + '\n';
        cuerpoEmail += '- Tipo de Error: ' + response.Message__c + '\n';
        cuerpoEmail += '- Fecha: ' + System.now().format() + '\n';
        cuerpoEmail += '- ID del Registro: ' + response.Id + '\n\n';
        cuerpoEmail += 'Por favor, revise el registro para tomar las acciones necesarias.\n\n';
        cuerpoEmail += 'Saludos,\nSistema de Notificaciones';
		*/
        
        String cuerpoEmail = '<html><body>' + 
        '<p>Estimado/a ' + '<strong>' + invoice.CreatedBy.Name + '</strong>' + ',</p>' +
        '<p>Se ha detectado un error en su registro por SAP.</p>' +
        '<p>Detalles del error:' + '<br>' + 
        '<strong>' + '- Invoice: ' + '</strong>' + '<a href="' + orgUrl + '/' + invoice.Id + '">' + invoice.Name + '</a>' + '<br>' +
        '<strong>' + '- Tipo de Error: ' + '</strong>' + response.Message__c + '.<br>' +
        '<strong>' + '- Fecha: ' + '</strong>' + System.now().format() + '.<br>' +
        '<strong>' + '- ID del Registro: ' + '</strong>' + '<a href= "' + orgUrl + '/' + response.Id + '">' + response.Name + '</a>' + '</p>' +
        '<p>Por favor, revise el registro para tomar las acciones necesarias.</p>' +
        'Saludos.<br>' + 'Sistema de Notificaciones.</p>';

        email.setHtmlBody(cuerpoEmail);
        //email.setPlainTextBody(cuerpoEmail);
        
        return email;
    }
}