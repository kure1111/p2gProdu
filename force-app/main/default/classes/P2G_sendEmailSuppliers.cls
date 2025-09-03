public class P2G_sendEmailSuppliers {

    public static void sendEmailsToSupplyChainPartners() {
        Date today;
        Date targetDate;
        if(!Test.isRunningTest()){
        	today = Date.today();
        	targetDate = getTargetDate(today);
        }else{
            today = Date.today();
        	targetDate = Date.today();
        }

        // Verificamos que hoy es el día en el que se debe enviar el correo
        if (today == targetDate) {
            Date previousMonth = today.addMonths(-1);

            // Obtener Shipments relacionados a cuentas con tipo "Supply Chain Partner"
            List<Shipment__c> shipments = [
                SELECT Id, Carrier__c, Carrier__r.Name, Carrier__r.NEU_Email__c, Carrier__r.Record_Type_Name__c, Date_Planner_Confirmed__c 
                FROM Shipment__c 
                WHERE Carrier__r.Record_Type_Name__c = 'Supply Chain Partner'
                AND Date_Planner_Confirmed__c = LAST_MONTH
            ];

            // Mapear cuentas para evitar duplicados
            Map<Id, Account> accountsToEmail = new Map<Id, Account>();

            for (Shipment__c shipment : shipments) {
                if (shipment.Carrier__r.NEU_Email__c != null) {
                    accountsToEmail.put(shipment.Carrier__c, shipment.Carrier__r);
                }
            }
if (!Test.isRunningTest()) {
            // Obtener el valor de la Etiqueta Personalizada
            String linkEncuesta = Label.LinkEncuesta;

            // Llamar al método para enviar correos electrónicos
            sendSurveyEmails(accountsToEmail, linkEncuesta);
}
        }
    }

    // Método para enviar correos electrónicos
    public static void sendSurveyEmails(Map<Id, Account> accountsToEmail, String linkEncuesta) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Account acc : accountsToEmail.values()) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { acc.NEU_Email__c });
            email.setSubject('Encuesta de Evaluación Clientes');

            String emailBody = 'Hola ' + acc.Name + ',<br/><br/>';
            emailBody += 'Esperamos que te encuentres muy bien.<br/><br/>';
            emailBody += 'Como parte de nuestra mejora continua, nos gustaría que nos ayudes respondiendo la siguiente encuesta <br/>';
            emailBody += '<a href="' + linkEncuesta + '">Abrir encuesta</a>.<br/><br/>';
            emailBody += '¡Agradecemos tu tiempo y disponibilidad!';
            
            email.setHtmlBody(emailBody);
            emails.add(email);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }

    // Método para obtener el primer día hábil del mes
    public static Date getTargetDate(Date today) {
        Date targetDate = Date.newInstance(today.year(), today.month(), 1);

        // Convertir la fecha a Datetime para obtener el día de la semana
        Datetime targetDateTime = Datetime.newInstance(targetDate.year(), targetDate.month(), targetDate.day());

        // Ajustar la fecha si el primer día del mes es sábado (6) o domingo (7)
        while (targetDateTime.format('u') == '6' || targetDateTime.format('u') == '7') {
            targetDate = targetDate.addDays(1);
            targetDateTime = Datetime.newInstance(targetDate.year(), targetDate.month(), targetDate.day());
        }

        return targetDate;
    }
}