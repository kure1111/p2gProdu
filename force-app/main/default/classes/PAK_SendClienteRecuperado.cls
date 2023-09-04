public class PAK_SendClienteRecuperado {
    @future(callout=true)
    public static void send(Set<Id> accountsIds){
        List<Account> lstAccount = [SELECT Id, Customer_Id__c, RecordTypeId, OwnerId FROM Account WHERE Id IN:accountsIds];
        
        if(lstAccount.size()>0){
            Map<String, String> mapUser = new Map<String,String>();
            for(User usr:[SELECT Id, SalesEmployer__c FROM User WHERE IsActive = true]){
                mapUser.put(usr.Id, usr.SalesEmployer__c);
            }
            
            String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                '<soapenv:Header/>'+
                ' <soapenv:Body>'+
                '  <tem:clienteRecuperado>'+
                '   <tem:lstClientes>';
            for(Account acct : lstAccount){
                body +=  '<tem:ClienteRecuperado>'+
                    '<tem:CustomerId>' + acct.Customer_Id__c + '</tem:CustomerId>'+
                    '<tem:AccountOwner>' + mapUser.get(acct.OwnerId) + '</tem:AccountOwner>'+
                    '<tem:AccountId>'+ acct.Id + '</tem:AccountId>'+
                    '</tem:ClienteRecuperado>'; 
            }
            body += '   </tem:lstClientes>'+
                '  </tem:clienteRecuperado>'+
                ' </soapenv:Body>'+
                '</soapenv:Envelope>';
            
            System.debug('Envelope: ' + Body);    
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://35.169.18.187/pakws92/WsActualizaOCRD.asmx');
            request.setMethod('POST');
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', 'http://tempuri.org/clienteRecuperado');
            request.setBody(Body);
            if(!Test.isRunningTest()){
                HttpResponse response = httpProtocol.send(request);                
                if(response.getStatusCode() == 200){System.debug('Cliente recuperado WS: OK');}else{System.debug('Cliente recuperado WS: Error');}
            }            
        } 
    }
}