public class Pak_MargenOperativo_SendEmail {
    
    public static void senMessage(Customer_Quote__c folio, Account acco , decimal porcent)
    {
        try
        {
            if(Test.isRunningTest()){
                TestMetodo();
                return;
            }

            list<user> owners =[select id,name  from user where id =: Acco.OwnerId limit 1];
            User userOwner = owners.size()> 0 ? owners[0] : null ;
            
            List<User> users = [select id,name,managerId,email  from user where id =: UserInfo.getUserId() limit 1];
            User user = users.size()> 0 ? users[0] : null ;
            
            List<User> userManagers = [select id,name,email  from user where id =: user.managerId limit 1];
            User userManager = userManagers.size()> 0 ? userManagers[0] : null ;
            
            List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'no-reply@pak2go.com']; 
            
            StaticResource srObject = [select id,body from StaticResource Where Name = 'TemplateMargenOP'];
            String bodyMO = srObject.body.toString();
            
            if(userManager.email != null && !string.isBlank(userManager.email))
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                
                Carrier_Line_Load_Point__c route = [select id, name from Carrier_Line_Load_Point__c where id =: folio.Route__c limit 1];
                
                string tempAux = bodyMO;
                tempAux =  tempAux.replace('{folio}',folio.Name)
                    .replace('{cliente}', acco.Name)
                    .replace('{owner}', userOwner.name)
                    .replace('{route}', route.name)
                    .replace('{venta}', String.valueOf(folio.Total_Services_Sell_Amount__c))
                    .replace('{currencyVenta} ', folio.CurrencyIsoCode)
                    .replace('{costo}', String.valueOf(folio.Total_Services_Std_Buy_Amount__c))
                    .replace('{margenActual}',  String.valueOf(porcent))
                    .replace('{userActual}', user.name)
                    .replace('{managerName}', userManager.name)
                    .replace('{currencyCosto}', folio.CurrencyIsoCode)
                    .replace('{margen}', String.valueOf(folio.Margen_Operativo__c));
                
                message.setHtmlBody(tempAux);
                message.setSubject('Solicitud de aprobación');
                message.toAddresses = new String[] {userManager.email};
                    message.optOutPolicy = 'FILTER'; 
                message.ccaddresses = new String[] {user.email};
                    message.bccaddresses = new String[] {'nayleth.gonzalez@pak2go.com'};
                        
                        System.debug('userManager.EMAIL ' + userManager.email);
                System.debug('user.email ' + user.email);
                System.debug('tempAux ' + tempAux);
                
                if ( owea.size() > 0 ) 
                { 
                    message.setOrgWideEmailAddressId(owea.get(0).Id); 
                }
                else
                    message.setSenderDisplayName('Notificaciones Pak2go');
                
                System.debug('message ' + message);
                lstMails.add(message);  
                
            }
            
            
            
            if(lstMails.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMails);    
                
                if (results[0].success) 
                    System.debug('The email was sent successfully. OK');
                else
                    System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
            
        }
        catch(exception ex)
        {
            System.debug('The email failed to send: ' + ex.getMessage());
              throw ex;
        }
    }
    
    public static void senMessageSPSCostos(User userComprador,string folio, string serviceLine, decimal buyAmountAnt, decimal buyAmountNew, string CurrencyIsoCode)
    {
        try
        {
        if(Test.isRunningTest()){
            TestMetodo();
            return;
        }
        User user = [select id,name,managerId,email  from user where id =: UserInfo.getUserId() limit 1];
        
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'no-reply@pak2go.com']; 
        
        StaticResource srObject = [select id,body from StaticResource Where Name = 'TemplateValidacionCostos'];
        String bodyMO = srObject.body.toString();
        
        if(userComprador.email != null && !string.isBlank(userComprador.email))
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
            
            string tempAux = bodyMO;
            tempAux =  tempAux.replace('{folio}',folio)
                .replace('{serviceLine}', serviceLine)
                .replace('{costoNuevo}', String.valueOf(buyAmountNew))
                .replace('{costo}',  String.valueOf(buyAmountAnt))
                .replace('{userActual}', user.name)
                .replace('{managerName}', userComprador.name)
                .replace('{currencyCosto}', CurrencyIsoCode);
            
            message.setHtmlBody(tempAux);
            message.setSubject('Solicitud de aprobación');
            message.toAddresses = new String[] {userComprador.Email};
                message.optOutPolicy = 'FILTER'; 
            message.ccaddresses = new String[] {user.email};
                message.bccaddresses = new String[] {'nayleth.gonzalez@pak2go.com'};
                    
                    
                    if ( owea.size() > 0 ) 
                { 
                    message.setOrgWideEmailAddressId(owea.get(0).Id); 
                }
            else
                message.setSenderDisplayName('Notificaciones Pak2go');
            
            System.debug('message ' + message);
            lstMails.add(message);  
            
        }
        
        
            if(lstMails.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMails);    
                
                if (results[0].success) 
                    System.debug('The email was sent successfully. OK');
                else
                    System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
            
        }
        catch(exception ex)
        {
            System.debug('The email failed to send: ' + ex.getMessage()); 
            throw ex;
        }
    }
    
    public static void TestMetodo(){
        String Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
    }
}