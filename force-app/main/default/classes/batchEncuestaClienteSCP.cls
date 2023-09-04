global class batchEncuestaClienteSCP implements Database.Batchable<sObject> {
    String fieldName ='id,Shipment_Status_Mon__c,Carrier__c,ACCOUNT_FOR__C,Shipment_Type__c';
    String query = 'select '+fieldName+' From Shipment__c ';
    string Estatus ='Finished_M';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query +=' WHERE '	;
        query += ' Shipment_Status_Mon__c =\''+Estatus+ '\' ';
        query += ' and Date_time_FN_Finished__c = THIS_WEEK'; 
        return Database.getQueryLocator(query);	
    }
    
    global void execute(Database.BatchableContext BC, List<Shipment__c> scope) {
        set<string> mapClient = new set<string>();
        set<string> mapClientSCP = new set<string>();
        
        system.debug('scope  + ' + scope);
        
        if (scope.size() > 0)
        {
            Map<id,Encuestas_Enviadas__c> mapEncuestasEnviadas = new Map<id,Encuestas_Enviadas__c>();
            
            for(Encuestas_Enviadas__c s : [select Id, Name, Account__c, Fecha_Programada__c, Fecha_Envio__c, 
                                           sent__c, Message__c, Encuesta__c   From Encuestas_Enviadas__c 
                                           where Fecha_Programada__c = THIS_WEEK]){
                                               mapEncuestasEnviadas.put(s.Account__c,s);
                                           }
            
            for(Shipment__c s : scope){
                
                if(!mapClientSCP.contains(s.Carrier__c) && !mapEncuestasEnviadas.containsKey(s.Carrier__c) && s.Shipment_Type__c.contains('FN'))
                    mapClientSCP.add(s.Carrier__c);
                
                if(!mapClient.contains(s.Account_for__c) && !mapEncuestasEnviadas.containsKey(s.Account_for__c))
                    mapClient.add(s.Account_for__c);
            }
            
            list<Encuestas_Enviadas__c> encuestasNuevas = new list<Encuestas_Enviadas__c>();
            for(string ac : mapClientSCP){
                Encuestas_Enviadas__c encuesta = new Encuestas_Enviadas__c();
                encuesta.Account__c = ac;
                encuesta.Fecha_Programada__c = DateTime.now();
                encuesta.sent__c = false;
                encuesta.Encuesta__c = 'Encuesta SCP'; 
                encuestasNuevas.add(encuesta);
            }
            
            for(string ac : mapClient){
                Encuestas_Enviadas__c encuesta = new Encuestas_Enviadas__c();
                encuesta.Account__c = ac;
                encuesta.sent__c = false;
                encuesta.Encuesta__c = 'Encuestas';
                encuesta.Fecha_Programada__c = DateTime.now();
                
                encuestasNuevas.add(encuesta);
            }
            
            if(encuestasNuevas.size()>0)
                insert encuestasNuevas;
            
        }
    }
    
    
    global void finish(Database.BatchableContext BC) 
    {
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
        List<Encuestas_Enviadas__c> encuestas = new List<Encuestas_Enviadas__c>();
        List<Encuestas_Enviadas__c> encuestasNE = new List<Encuestas_Enviadas__c>();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'no-reply@pak2go.com']; 
        
        /* Contact con = [SELECT Id, Name, Email FROM Contact where email != null 
and (email like 'Jan.haas%' or email like 'nayleth.gonzalez%' )  limit 1] ; 
if(con == null )
con =  [SELECT Id, Name, Email FROM Contact where email != null limit 1] ;

Map<string,EmailTemplate> emailTemplates = new Map<string,EmailTemplate>();

for( EmailTemplate et : [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name in ('Encuestas','Encuesta SCP')] )
{
emailTemplates.put(et.name,et);
}*/
        
        StaticResource srObject = [select id,body from StaticResource Where Name = 'TemplateEC'];
        String bodyEC = srObject.body.toString();
        
        StaticResource srObjectEP = [select id,body from StaticResource Where Name = 'TemplateEP'];
        String bodyEP = srObjectEP.body.toString();
        
        List<Organization>org=[SELECT Id, IsSandbox FROM Organization LIMIT 1];
        Boolean isSandbox=false;
        if(org.size()>0)
            if(org[0].IsSandbox)
            isSandbox = true;
        
        for(Encuestas_Enviadas__c enc : [select Id, Name, Account__c,Account__r.name,Account__r.NEU_Email__c, Fecha_Programada__c, Fecha_Envio__c, 
                                         sent__c, Message__c, Encuesta__c   
                                         From Encuestas_Enviadas__c 
                                         where sent__c = false ])
        {
            
            if(enc.Account__r.NEU_Email__c != null && !string.isBlank(enc.Account__r.NEU_Email__c))
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();              
                
                //message.setTargetObjectId( con.id);
                //EmailTemplate emailTemplate = emailTemplates.get(enc.Encuesta__c) ;  
                //message.setTemplateID(emailTemplate.Id);  
                //message.saveAsActivity = false;
                //message.setWhatId(enc.Account__c); //This is important for the merge fields in template to work
                
                
                string tempAux = '';
                if(enc.Encuesta__c == 'Encuestas')
                    tempAux  = bodyEC;
                else if(enc.Encuesta__c =='Encuesta SCP')
                    tempAux  = bodyEP;

                tempAux = !isSandbox ? tempAux.replace('{UserName}',enc.Account__r.name).replace('{Url}', 'https://pak2golive.secure.force.com/encuesta/TakeSurvey?id=a3B4T000000XltKUAS&accId='+enc.Account__c+'&caId=none')
                    :  tempAux.replace('{UserName}',enc.Account__r.name).replace('{Url}', 'https://uat-pak2golive.cs94.force.com/encuesta/TakeSurvey?id=a3B0R00000RUmjLUAT&accId='+enc.Account__c+'&caId=none');
               
                message.setHtmlBody(tempAux);
                
                
                message.toAddresses = new String[] {enc.Account__r.NEU_Email__c };
                message.bccaddresses = new String[] { 'nayleth.gonzalez@pak2go.com' };
                message.optOutPolicy = 'FILTER'; 
                message.setSubject('Encuesta de satisfacción');
                
                
                System.debug('ac.NEU_Email__c ' + enc.Account__r.NEU_Email__c );
                
                if ( owea.size() > 0 ) 
                { 
                    message.setOrgWideEmailAddressId(owea.get(0).Id); 
                }
                else
                    message.setSenderDisplayName('comunicacion interna');
                
                
                lstMails.add(message);  
                encuestas.add(enc);
            }
            else
            {
                enc.Message__c = 'Email account is null';
                encuestasNE.add(enc);
                //update enc;
            }
        }
        
       update encuestasNE;
        
        try
        {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMails);    
            
            for(Encuestas_Enviadas__c enc : encuestas)
            {
                
                if (results[0].success) 
                {
                    System.debug('The email was sent successfully.');
                    enc.Message__c = 'The email was sent successfully.';
                    enc.Fecha_Envio__c = DateTime.now(); 
                    enc.sent__c = true;
                    
                    //update enc;
                    System.debug('Actalizo enc' + enc);
                } 
                else
                {
                    System.debug('The email failed to send: ' +  results[0].errors[0].message);
                    enc.Message__c += ' The email failed to send: ' +  results[0].errors[0].message;
                    //update enc;
                }  
            }
            
            update encuestas;
        }
        
        catch(exception ex)
        {
            System.debug('The email failed to send: ' + ex.getMessage());
            
        }
        
        
    }
}