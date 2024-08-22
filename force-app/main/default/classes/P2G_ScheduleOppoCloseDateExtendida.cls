public class P2G_ScheduleOppoCloseDateExtendida implements Schedulable {
	public static String CRON_EXP = '0 0 8 * * ?';
    public void execute(SchedulableContext SC) {
        Date fecha = system.today();
        Date fechaExtendida = system.today()+30;
        Messaging.Email[] messages = new Messaging.Email[0];
        List<String> etapas = new List<String>{'Prospectar','Explorar','Construir','Cotizar','Presentar','Implementar'};
      	List<Opportunity> listOppo = [SELECT Id, Name, StageName, CreatedBy.Email FROM Opportunity WHERE StageName IN : etapas AND CloseDate =: fecha];
        System.debug('Lista de etapas a modificar: '+listOppo);
        for(Opportunity oppo : listOppo){
            oppo.CloseDate = fechaExtendida;
            messages.add(enviarCorreo(oppo));
        }
        update listOppo;
        Messaging.sendEmail(messages, false);
   }
    public static Messaging.SingleEmailMessage enviarCorreo(Opportunity oppo){
        String correo = oppo.CreatedBy.Email;
        System.debug('El correo del usuario es: '+correo);
        String bodyHTML = htmlCorreo(oppo);
        System.debug('El body es: '+bodyHTML);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{correo});
        email.setSubject('Close Date Extendida en la Oportunidad');
        email.setHtmlBody(bodyHTML);
        return email;
    }
    public static String htmlCorreo(Opportunity oppo){
        String url = 'https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Opportunity/'; //Produ'https://pak2gologistics.lightning.force.com/lightning/r/Opportunity/';
        // UAT 'https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Opportunity/';
        String bodyHTML ='<html><body>';
        bodyHTML += '<div class="pagina">';
        bodyHTML += '<div class="container">';
        bodyHTML += '<h3>Fecha de cierre extendida de la Oportunidad</h3>';
        bodyHTML += '<br/>';
        bodyHTML += '<p>Se extendido la fecha de cierre de: '+ System.Today()+' a la siguente fecha: '+Oppo.CloseDate;
        bodyHTML += '</p>';
        bodyHTML += '<p>De la oportunidad <a href="'+uRL+oppo.Id+'/view">'+Oppo.Name+'</a></p>';
        bodyHTML += '</div>';
        bodyHTML += '</div>';
        bodyHTML += '</body></html>';
        return bodyHTML;
    }
}