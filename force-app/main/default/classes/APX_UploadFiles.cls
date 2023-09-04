/**
 * @description       : 
 * @author            : Brandom / Leonardo
 * @group             : 
 * @last modified on  : 08-12-2022
 * @last modified by  : Brandom Gonzalez
 * % Test			  : 81%
**/
public with sharing class APX_UploadFiles {
    
    public virtual class BaseException extends Exception {}
    public class OtherException extends BaseException {}

    public static final String BUCKET_NAME = 'associateddocs';           
    public static final String URLS3 = 's3.amazonaws.com';    
    public static String SHIPMENT = 'Shipment';
    public static String CUENTA = 'Cuenta';
    public static String VEHICULO = 'Vehiculo';
    public static String OPERADOR = 'Operador';

    @AuraEnabled
    public static String uploadFile(String fileContent, String filename, Id idRecord, String nameFile, String documentType){
        try {                    
                       
           //nameFile = getNameFile(filename,documentType);                                
           Integer i = fileName.lastIndexOf('.');
           String extension = fileName.substring(i+1);
           string path = getPath(idRecord);                              

           String getUrl = uploadS3(BUCKET_NAME,URLS3, nameFile, fileContent, extension,path);            

           createData(idRecord, nameFile, documentType, getUrl);

           return nameFile;

        } catch (BaseException e) {
            system.debug('Error: ' + e.getMessage() + ' Cause: ' + e.getCause() + ' linea: ' + e.getLineNumber());            
            throw new OtherException(e.getMessage());            
        }
    }

    public static void createData(Id recordId, string fileName, string documentType, string documentUrl)
    {		        
        system.debug('createData metodo: ' + recordId+ ' Nombre: ' + fileName +  ' url: ' + documentUrl);
        try
        {
            String objectName = string.valueOf(recordId.getSObjectType());            
            Id idObject = getObjectId(recordId);         

            system.debug('Object: '  + objectName);                                                       
            Associated_Document__c new_doc = new Associated_Document__c();  
                    
            new_doc.Account__c = (objectName == 'Account') ? recordId : (objectName == 'Vehicle__c' ) ? idObject : (objectName == 'Operadores__c') ? idObject : (objectName == 'Shipment__c') ? idObject : null;
            new_doc.Shipment__c = objectName == 'Shipment__c' ? recordId : null;
            new_doc.vehicle__c = objectName == 'Vehicle__c' ? recordId : null;
            new_doc.Operadores__c =  objectName == 'Operadores__c' ? recordId : null;
    
            new_doc.Available_for_Community__c = true;
            new_doc.Type__c = 'File';
            new_doc.Document_Type__c = documentType;
            new_doc.Document_URL__c = documentUrl;
            new_doc.Name = fileName; 

            insert new_doc; 
            system.debug('Se ha registrado el documento ' + new_doc);     

            List<ContentDocument>  cd = [SELECT Id, CreatedDate, Title, FileType FROM ContentDocument where Title =: fileName];
            system.debug('cd: ' + cd.size());
            
            deleteFileSF(fileName);
                                  
        }
        catch(BaseException e){
            system.debug('Error: ' + e.getCause() + ' -  ' + e.getMessage() + ' linea: ' + e.getLineNumber());
            throw new OtherException(e.getMessage());            
        }
    }
    
    private static String getPath(Id recordId){        

        string objectName= string.valueOf(recordId.getSObjectType());

        List<Rutas_AWS__mdt> pathAWS = [select ruta__c from Rutas_AWS__mdt where objeto__c =: objectName];

        system.debug('ObjectName: '+ objectName  + 'Ruta: ' + pathAWS.get(0).ruta__c);

        if(objectName == 'Account'){
            
            Account acc = [select name, RecordType.Name from Account where id =: recordId];

                if(acc.RecordType.Name == 'Customer' || acc.RecordType.Name == 'Prospect' || acc.RecordType.Name == 'Prospect Mkt'
                    || acc.RecordType.Name == 'Account Destination')
                { 
                    pathAWS = [select ruta__c from Rutas_AWS__mdt where ruta__c like '%Customers/'];
                    return pathAWS.get(0).ruta__c;
                
                }else{
                    pathAWS = [select ruta__c from Rutas_AWS__mdt where ruta__c like '%Carriers/'];
                    return pathAWS.get(0).ruta__c;
                }  

        }else{
            return pathAWS.get(0).ruta__c;
        }             
    }

    private static Id getObjectId(Id recordId){

        string objectName= string.valueOf(recordId.getSObjectType());
        
        switch on objectName {
            when 'Vehicle__c' {

                return [select Account_for_SCP__c from Vehicle__c where Id =: recordId].Account_for_SCP__c;
            }
            when 'Operadores__c' {
                return [select Account__c from Operadores__c where Id =: recordId].Account__c;
            }           
            when 'Shipment__c'{
                return [select Account_for__c from Shipment__c where Id =: recordId].Account_for__c;
            }
            when else {
                return null;
            }
        }
    }

    public static String uploadS3(String bucket,String urlS3, String fileName, String content, String extension, String path) {
                         
        Blob base64Content = EncodingUtil.base64Decode(content);
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String contentType=AWSService.ContentType(extension);        
        
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT'); 
        
        if(!test.isRunningTest()){          
            
          	req.setEndpoint('callout:'+'associateddocs/'+path+fileName);                       
            req.setHeader('Content-Encoding', 'UTF-8');
            req.setHeader('Content-type', contentType);
            req.setHeader('Connection', 'keep-alive');
            req.setHeader('Date', formattedDateString);
            req.setHeader('Access-Control-Allow-Origin', '*');
            req.setHeader('ACL', 'public-read');
            req.setBodyAsBlob(base64Content);                        
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('Body is'+res.getBody());
            
            if(res.getStatusCode() != 200) {
                String error = 'Ocurrio un error al conectar con AWS : ' + res.getStatusCode(); 
                system.debug(error);
                return null;                     
            }
        }
        return 'https://' + bucket + '.'+urlS3+'/' +path+ fileName;
    }   

    private static String getNameFile(String filename,String documentType){

        //String na =fileName.replace(' ','_');
        String na = documentType.replace(' ','_');
        Datetime d = Datetime.now();
        String extension = null;
        Integer i = fileName.lastIndexOf('.');
        extension = fileName.substring(i+1);
        Integer dia = d.day();
        Integer mes = d.month();
        Integer ano = d.year();
        Integer hora =  d.hour();
        Integer min = d.minute();
        Integer sec = d.second();                        
        //String name = na.substring(0,i) + '_' +dia+''+mes+''+ano+''+hora+''+min+''+sec+'.'+extension;
        String name = na + '_' +dia+''+mes+''+ano+''+hora+''+min+''+sec+'.'+extension;

        system.debug('na: '+na + ' FileName: ' + name + ' Extension: ' + extension);                        
        system.debug('Nombre renombrado: ' + name);

        return name;
    }


    //Metodos para guardar el archivo en salesforces
    @AuraEnabled
    public static ContentVersion uploadFileSF(String base64, String filename, Id recordId,String documentType) {
        
        try {

            System.debug('Metodo para subir documentos en SF');            

            ContentVersion cv = createContentVersion(base64, filename, documentType);    
            ContentDocumentLink cdl = createContentLink(cv.Id, recordId);            

            return cv;

        } catch (Exception e) {

            system.debug('Error al crear un uploadFileSF: ' + e.getMessage() + ' case: ' + e.getCause()
            + ' linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }   

    private static ContentVersion createContentVersion(String base64, String filename,String documentType) {
       
        try {           
          String name = getNameFile(filename,documentType);                  
          ContentVersion cv = new ContentVersion();          
          cv.VersionData = EncodingUtil.base64Decode(base64);          
          cv.Title = name;          
          cv.PathOnClient = name;          
          insert cv;          
          return cv;
        } catch(DMLException e) {            
            
            system.debug('Error al crear un ContentVersion: ' + e.getMessage() + ' case: ' + e.getCause()
            + ' linea: ' + e.getLineNumber());

            throw new AuraHandledException(e.getMessage());
        }
      }    

    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
            
        try {
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = [ SELECT ContentDocumentId  FROM ContentVersion WHERE Id =: contentVersionId].ContentDocumentId;
            cdl.LinkedEntityId = recordId;        
            cdl.ShareType = 'V';
            insert cdl;
            return cdl;
            
        } catch(DMLException e) {

            system.debug('Error al crear un ContentDocumentLink: ' + e.getMessage() + ' case: ' + e.getCause()
            + ' linea: ' + e.getLineNumber());
            
            throw new AuraHandledException(e.getMessage());   
        }
    }   
        
    @AuraEnabled
    public static void  deleteFileSF(String title){
        try {
            
            ContentDocument  cd = [SELECT Id, CreatedDate, Title, FileType FROM ContentDocument where Title =: title];

            if(cd != null){
                delete cd;
                system.debug('Se ha eliminado el archivo '+ title +' correctamente'); 
            
            }else{
                system.debug('No se encontro el archivo: ' +title);
            }                      

        } catch (Exception e) {

            system.debug('Ocurrio un error en el metodo "deleteFileSF": ' + e.getMessage() + ' case: ' + e.getCause()
            + ' linea: ' + e.getLineNumber());            
        }
    }

    ////Fin

}