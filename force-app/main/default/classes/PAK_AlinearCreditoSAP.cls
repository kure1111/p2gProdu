global class PAK_AlinearCreditoSAP {
    global class CREDITODISPONIBLE{
        webservice String CustomerID {get;set;}
        webservice String Credito {get;set;}
        webservice String OVAbiertas {get;set;}
        webservice String currencyIsoCode {get;set;}
    }
    webservice static list<status> SFCREDITO(CREDITODISPONIBLE[] lsEntity){
        list<status> result = new list<status>();
        Response__c RES = new Response__c();
        try{
            for(CREDITODISPONIBLE R: lsEntity){
                RES.Type__c = 'CONFIRM';
                RES.Object__c='Account';
                list<Account> Cuenta = [Select Id,CreditoDisponible__c,Total_OV__c From Account Where Customer_Id__c=:R.CustomerID];
                if(R.Credito != null){Cuenta[0].CreditoDisponible__c = Decimal.valueOf(R.Credito);}
                if(R.OVAbiertas != null){Cuenta[0].Total_OV__c = Decimal.valueOf(R.OVAbiertas);}
                
                //NUEVO, LIMITE DE CREDITO
                if( !string.isBlank(R.currencyIsoCode))
                {
                    Cuenta[0].CurrencyIsoCode = R.currencyIsoCode; 
                } 
                
                if(!Cuenta.isEmpty()){RES.Account__c = Cuenta[0].Id;}
                if(!Test.isRunningTest()){update Cuenta[0];}
                status st = new status();st.code = '1';st.Existe = 'NO'; st.message = 'Exitoso- se actualizo correctamente';st.registry = R; result.add(st);
                RES.Message__c = st.message +' Credito Disponible: '+R.Credito+ ' Total OV abiertas '+ R.OVAbiertas;
                if(!Test.isRunningTest()){insert RES;}
            }
            
        	return result;
            
        }catch(Exception e){
            RES.Type__c = 'ERROR';RES.Message__c = e.getCause()+' '+e.getMessage();insert RES;
            System.debug(e.getCause()); System.debug(e.getMessage()); System.debug(e.getLineNumber());
			status st = new status(); st.code = '0';st.Existe = ''; st.message = 'Existe un error en el web services, por favor revise la trasabilidad de la transacción' + e.getCause() +' '+ e.getMessage() +' '+ e.getLineNumber();					
			result.add(st);return result;
        }
    }
    global class status {
        webservice String code {get; set;}
        webservice String message {get; set;}
        webservice String Existe {get;set;}
        webservice CREDITODISPONIBLE registry {get; set;}
    }
}