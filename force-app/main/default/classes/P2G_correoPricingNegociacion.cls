public class P2G_correoPricingNegociacion{
	public static void enviarCorreo(String idOli){
        enviarCorreos(new List<Id>{ (Id)idOli });
    }
    // Bulk: una sola consulta y una sola invocacion de Messaging.sendEmail por lote
    // (el limite de Salesforce es 10 invocaciones por transaccion; una por linea tronaba con 11+ lineas)
    public static void enviarCorreos(List<Id> idOlis){
        if(idOlis == null || idOlis.isEmpty()){ return; }
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(OpportunityLineItem oli : [SELECT Id, Name, CreatedBy.Email, OpportunityId, Opportunity.Name,
                                       Opportunity.Account.Name, Product2.Name, PROJ_Tipo_de_mercancia__c, Quantity,
                                       PROJ_Modalidad__c,PROJ_Frecuencia__c,Comentarios__c,Buy_Price__c,UnitPrice,Target__c
                                       FROM OpportunityLineItem WHERE id in: idOlis]){
            if(oli.CreatedBy.Email == null){ continue; }
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{oli.CreatedBy.Email});
            email.setSubject('Producto en Negociación con Cliente');
            email.setHtmlBody(htmlCorreo(oli));
            emails.add(email);
        }
        if(!emails.isEmpty()){
            // allOrNothing=false: un correo invalido no tumba el guardado de las lineas
            Messaging.sendEmail(emails, false);
        }
    }
    public static String htmlCorreo(OpportunityLineItem item){
        String bodyHTML ='<html><body>';
        bodyHTML += '<div class="pagina">';
        bodyHTML += '<div class="container">';
        bodyHTML += '<h1>Producto de la Oportunidad cambio de estatus a Negociacion con el Cliente</h1>';
        bodyHTML += '<p>El producto ';
        bodyHTML += '<a href="https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/OpportunityLineItem/'+item.Id+'/view">'+item.Product2.Name+'</a>';
        bodyHTML += ' de la oportunidad <a href="https://pak2gologistics.lightning.force.com/lightning/r/Opportunity/'+item.OpportunityId+'/view">'+item.Opportunity.Name+'</a>';
        bodyHTML += ' se cambiado al estatus de Negociación con el cliente</p>';
        bodyHTML += '<br/>';
        bodyHTML += '<p>Informacion del producto:</p>';
        bodyHTML += '<br/>';
        bodyHTML += '<ol>';
        bodyHTML += '<li>Cliente: '+item.Opportunity.Account.Name+'</li>';
        bodyHTML += '<li>Ruta: '+item.Product2.Name+'</li>';
        bodyHTML += '<li>Mercancia: '+item.PROJ_Tipo_de_mercancia__c+'</li>';
        bodyHTML += '<li>Cantidad: '+item.Quantity+'</li>';
        bodyHTML += '<li>Contenedor: '+item.PROJ_Modalidad__c+'</li>';
        bodyHTML += '<li>Frecuencia: '+item.PROJ_Frecuencia__c+'</li>';
        bodyHTML += '<li>Comentarios: '+item.Comentarios__c+'</li>';
        bodyHTML += '<li>Buy Price Actual: '+item.Buy_Price__c+'</li>';
        bodyHTML += '<li>Sell Price Actual: '+item.UnitPrice+'</li>';
        bodyHTML += '<li>Target: '+item.Target__c+'</li>';
        bodyHTML += '</ol>';
        bodyHTML += '</div>';
        bodyHTML += '</div>';
        bodyHTML += '</body></html>';
        return bodyHTML;
    }
}