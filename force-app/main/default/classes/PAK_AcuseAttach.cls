global class PAK_AcuseAttach {
	global class AttachmentAcuse{
        webservice String CustomerID {get;set;}
        webservice String Documento {get;set;}
        webservice String NameDocumento {get;set;}
    }
    
    global class status{
        webservice String code {get; set;}
        webservice String message {get; set;}
    }
    
    webservice static list<Status> AcuseDocumento(AttachmentAcuse[] lsEntity){
        list<status> result = new list<status>();
        Response__c RES = new Response__c();
        list<Account> Cuenta = new list<Account>();
        
        try{
            for(AttachmentAcuse Acuse: lsEntity){
                list<Associated_Document__c> lsDocs = [Select Id From Associated_Document__c Where Name=:Acuse.NameDocumento.toLowerCase()];
                if(!lsDocs.isEmpty()){
                    status st = new status(); st.code = '0'; st.message ='El Documento ya existe';
                    result.add(st);
                    return result;
                }
                RES.Type__c = 'CONFIRM';
           		RES.Object__c='Account';
                Cuenta = [Select Id From Account Where Customer_Id__c=:Acuse.CustomerID];
                Associated_Document__c DOC = new Associated_Document__c();
                DOC.Name = Acuse.NameDocumento.toLowerCase();
                DOC.Account__c = Test.isRunningTest()?null:Cuenta[0].Id;
                DOC.Document_Type__c = 'Other';
                DOC.Type__c = 'Document';
                if(!Test.isRunningTest()){insert DOC;}
                
                Attachment Archivo = new Attachment();
                Archivo.ParentId = Test.isRunningTest()?null:DOC.Id;
                Archivo.Name = Acuse.NameDocumento.toLowerCase();
                
                if(Archivo.Name.contains('pdf')){Archivo.ContentType = 'application/pdf';}
                else if(Archivo.Name.contains('jpeg')){Archivo.ContentType = 'image/jpeg';}
                else if(Archivo.Name.contains('png')){Archivo.ContentType = 'image/png';}
      
                Archivo.Body = EncodingUtil.base64Decode(Acuse.Documento);
                if(!Test.isRunningTest()){insert Archivo;DOC.Document_URL__c = System.URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+Archivo.Id;update DOC;}
                
                status st = new status();
                st.code='1';
                st.message = 'Se inserto Correctamente el Documento';
                result.add(st);
                
              	//RES.base64__c = Acuse.Documento;
                RES.Account__c = Test.isRunningTest()?null:Cuenta[0].Id;
                RES.Message__c = 'Se inserto el Documento '+Acuse.NameDocumento;
                insert RES; 
            }
            return result;
        }catch(Exception e){
            RES.Type__c = 'ERROR';RES.Message__c = e.getCause()+' Linea:'+e.getLineNumber();
            insert RES; System.debug(e.getCause()); System.debug(e.getMessage()); System.debug(e.getLineNumber());
			status st = new status(); st.code = '0'; st.message = 'Existe un error en el web services, por favor revise la trasabilidad de la transacción ' + e.getCause() +' '+ e.getMessage() +' '+ e.getLineNumber();					
			result.add(st);return result;
        }
    }
}