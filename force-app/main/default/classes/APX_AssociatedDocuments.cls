/**
 * @description       : 
 * @author            : Brandom / Leonardo
 * @group             : 
 * @last modified on  : 08-12-2022
 * @last modified by  : Brandom Gonzalez
 * % Test			  : 92%
**/
public with sharing class APX_AssociatedDocuments {
    // metodo que identifica el objeto en el que se está ejecutando     
    @AuraEnabled(cacheable = true)
    public static List<String> getInfoMetadata(Id recordId){
        system.debug('Entrando a clase:APX_AssociatedDocuments');
        system.debug('Metodo :getInfoMetadata');
        string strObjType= string.valueOf(recordId.getSObjectType());
        system.debug('El nombre del objeto es: '+strObjType);     
        string documentosRequeridos =[SELECT Documentos_requeridos__c FROM Documentos_Asociados__mdt WHERE Nombre_del_objeto__c=:strObjType].Documentos_requeridos__c;
        List<String> listDocuments = documentosRequeridos.split(',');
        if(strObjType=='Vehicle__c'){
            listDocuments=filterTercerizado(listDocuments,recordId);
        }
        system.debug('Lo que  contiene listDocuments: '+listDocuments);
        return listDocuments;
    }
    @AuraEnabled(cacheable = true)
    public static List<String> filterTercerizado(List<String> listDocuments,Id recordId){
        system.debug('entrando a filterTercerizado deñl vehiculo');
        List<String> listToReturn =new list<String>();
        Vehicle__c Vobj=[SELECT id,name,Account_Owner_Vehicle__c FROM vehicle__c WHERE id=:recordId];
        if(Vobj.Account_Owner_Vehicle__c == null){
            for(String document:listDocuments){
                system.debug('lo que contiene document: '+document);
                if(document!='Tercerizado'){
                    system.debug('lo que contiene document: '+document);
                    listToReturn.add(document);
                }
            }
        }
        else {
            listToReturn=listDocuments;
        }
        system.debug('lo que contiene: '+listToReturn);
        return listToReturn;
    }
    @AuraEnabled(cacheable = true)
    public static string getInfoMetadataToOptions(Id recordId){
        system.debug('Entrando a clase:APX_AssociatedDocuments');
        system.debug('Metodo :getInfoMetadata');
        string strObjType= string.valueOf(recordId.getSObjectType());
        system.debug('El nombre del objeto es: '+strObjType);    
        string documentosRequeridos =[SELECT Documentos_requeridos__c FROM Documentos_Asociados__mdt WHERE Nombre_del_objeto__c=:strObjType].Documentos_requeridos__c;
        List<String> listDocuments = documentosRequeridos.split(',');
        string jsonOptions='[';
        system.debug('Lo que  contiene listDocuments: '+listDocuments);
        for(string document :listDocuments){
            jsonOptions=jsonOptions+'{ label: "'+document+'", value: "'+document+'" },';
        }
        jsonOptions=jsonOptions+']';
        return jsonOptions;
    }
    @AuraEnabled(cacheable = true)
    public static List<DocumentsUpload> getDocumentUploaded(Id recordId){
        try {
            
            List<String> getDocumentsRequired = getInfoMetadata(recordId);
            String objectName = string.valueOf(recordId.getSObjectType());

            if(objectName == 'Account'){
                objectName = 'Account__c';
            }

            List<Associated_Document__c> documents = Database.query('select Name, Document_Type__c, Document_URL__c  from Associated_Document__c '+
                                                                    + ' where Document_Type__c IN : getDocumentsRequired  and '+objectName+'=:recordId'); 
            
            system.debug('documents.size: '+ documents.size());
            List<DocumentsUpload> documentsUp = new List<DocumentsUpload>();                 
            List<String> documentsFound =  new List<String>();
                
            for(Associated_Document__c document :documents){                                                                    
                                
                DocumentsUpload documentUpload = new DocumentsUpload();                                                                 
                documentUpload.isUpload = true;
                documentUpload.type = document.Document_Type__c;
                documentUpload.url = document.Document_URL__c;
                documentUpload.isImage = isImage(document.name);
                documentsUp.add(documentUpload);     
                documentsFound.add(document.Document_Type__c);                                          
                
            }           

            if(documentsUp.size() != getDocumentsRequired.size()){

                system.debug('No son iguales: ' + documentsUp.size());                

                for(String  docT : getDocumentsRequired){

                    if(!documentsFound.contains(docT)){

                        system.debug('Documento faltante: ' + docT); 

                        DocumentsUpload documentUpload = new DocumentsUpload();                                                                 
                        documentUpload.isUpload = false;
                        documentUpload.type = docT;
                        documentUpload.url = null;
                        documentsUp.add(documentUpload);     
                        documentsFound.add(docT);

                    }
                }
            }
        
            system.debug('[APX_AssociatedDocumentsdocumentUpload.getDocumentUploaded] documentsUp: '+documentsUp);

            return documentsUp;
            
        } catch (Exception e) {
            system.debug('Ocurrio un error (getDocumentUploaded): ' + e.getMessage() + ' linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    // Metodo que valida que datos estan cargados APX_AssociatedDocuments.ValidateAllDocuments('a0J0R000003Y1LPUA0');
    @AuraEnabled(cacheable = true)
    public static CustomWrapp ValidateAllDocuments(Id recordId){
        try {
            system.debug('clase APX_AssociatedDocuments metodo :ValidateAllDocuments');

            if(recordId == null ){
                system.debug('recordId vacio:');
                return null;
            }

            String objectName = string.valueOf(recordId.getSObjectType());  

            if(objectName != 'Shipment__c'){
                system.debug('El id no es de un Shipment');
                return null;
            } 

            shipment__c SpObj=[SELECT ID,Name,Vehicle__c,Account_for__c,National_Operator__c FROM Shipment__c WHERE id=: recordId limit 1];        
            List<String> documentsRequired = new list<string>();
            documentsRequired= unirListas(documentsRequired,SpObj.vehicle__c);
            // documentsRequired= unirListas(documentsRequired,SpObj.Account_for__c);
            documentsRequired= unirListas(documentsRequired,SpObj.National_Operator__c);
            system.debug('esto es lo que contiene documentsRequired: '+documentsRequired);
            
            //String objectName = string.valueOf(recordId.getSObjectType());
            system.debug('esto es lo que contiene objectName: '+objectName);
            List<Associated_Document__c> documentsVehicle = GetDocumentosRequeridos(getSObjectTypeST(SpObj.vehicle__c),documentsRequired,SpObj.vehicle__c);
            // List<Associated_Document__c> documentsCarrier = GetDocumentosRequeridos(getSObjectTypeST(SpObj.Account_for__c),documentsRequired,SpObj.Account_for__c);
            List<Associated_Document__c> documentsOperator = GetDocumentosRequeridos(getSObjectTypeST(SpObj.National_Operator__c),documentsRequired,SpObj.National_Operator__c);            
            system.debug('esto es lo que contiene documentsOperator: '+documentsOperator);

            system.debug('documents.size: '+ documentsVehicle.size());
            CustomWrapp contentList =new CustomWrapp();
            List<DocumentsUpload> documentsUp = new List<DocumentsUpload>();                 
            List<DocumentsUpload> documentsFaltantes = new List<DocumentsUpload>();                 
            List<String> documentsFound =  new List<String>();
            contentList.documentsUpWrap=documentsUp;
            contentList.documentsFoundWrap=documentsFound;
            contentList=wrapperBuild(documentsVehicle,contentList.documentsUpWrap,contentList.documentsFoundWrap);
            // contentList=wrapperBuild(documentsCarrier,contentList.documentsUpWrap,contentList.documentsFoundWrap);
            contentList=wrapperBuild(documentsOperator,contentList.documentsUpWrap,contentList.documentsFoundWrap);
            CustomWrapp wrappReturn=new CustomWrapp();
            string messagetoReturn ='Favor de subir los siguientes Documentos faltantes:';
            if(contentList.documentsUpWrap.size() != documentsRequired.size()){
                system.debug('No son iguales: ' + contentList.documentsUpWrap.size());                
                for(String  docT : documentsRequired){
                    if(!contentList.documentsFoundWrap.contains(docT)){
                        system.debug('Documento faltante: ' + docT); 
                        DocumentsUpload documentUpload = new DocumentsUpload();                                                                 
                        documentUpload.isUpload = false;
                        documentUpload.type = docT;
                        documentUpload.url = null;
                        documentsFaltantes.add(documentUpload);
                        documentsFound.add(docT);
                        messagetoReturn=messagetoReturn+documentUpload.type+', ';
                    }
                }
            }
            system.debug('lo que contiene documentsUp.size(): '+documentsFaltantes.size());
            system.debug('lo que contiene documentsUp: '+documentsFaltantes);
            if( documentsFaltantes.size()>0){
                wrappReturn.messageST=messagetoReturn;
                wrappReturn.documentsUpWrap=documentsFaltantes;
            }
            else if (documentsFaltantes.size()==0){
                system.debug('entrando a es igual a 0 ');
                wrappReturn.messageST=null;
            }

            system.debug('documentUpload: '+wrappReturn);

            return wrappReturn;

        } catch (Exception e) {
            system.debug('Ocurrio un error (ValidateAllDocuments): ' + e.getMessage() + ' linea: ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static string getSObjectTypeST(id recotdID){
        string objType= string.valueOf(recotdID.getSObjectType());
        if(objType=='Account'){
            objType=objType+'__c';
        }
        return objType;
    }
    public static CustomWrapp wrapperBuild (List<Associated_Document__c> documents, List<DocumentsUpload> documentsUp,List<String> documentsFound) {
        CustomWrapp returnWrapp = new CustomWrapp();
        for(Associated_Document__c document :documents){                                                                    
            DocumentsUpload documentUpload = new DocumentsUpload();                                                                 
            documentUpload.isUpload = true;
            documentUpload.type = document.Document_Type__c;
            documentsUp.add(documentUpload);
            documentsFound.add(document.Document_Type__c);
        }
        returnWrapp.documentsFoundWrap=documentsFound;
        returnWrapp.documentsUpWrap=documentsUp;
        return returnWrapp;
    }
    public static List<string> unirListas(List<String> masterList, string idObject) {
        List<String> documentsRequired = getInfoMetadata(idObject);
        for(string documentR : documentsRequired){
            masterList.add(documentR);
        }
        return masterList;
    }
    public static List<Associated_Document__c> GetDocumentosRequeridos(string objectName, List<String> getDocumentsRequired, string recordId) {

        if(objectName == 'Account'){
            objectName = 'Account__c';
        }

        return Database.query('SELECT Name, Document_Type__c, Document_URL__c  FROM Associated_Document__c '+
        + ' WHERE Document_Type__c IN : getDocumentsRequired  and '+objectName+'=:recordId');
    }

    private static Boolean isImage(String nameFile){

        String extension;
        Integer ext;

        ext = nameFile.lastIndexOf('.');
        extension  = nameFile.substring(ext+1);

        if(extension == 'png' || extension == 'jpg'){

            return true;
        }

        return false;
    }

    public class CustomWrapp{
        @AuraEnabled public List<DocumentsUpload> documentsUpWrap;
        @AuraEnabled public List<String> documentsFoundWrap;
        @AuraEnabled public String messageST;
    }
    public class DocumentsUpload{

        @AuraEnabled public Boolean isUpload;
        @AuraEnabled public String type;
        @AuraEnabled public String url;
        @AuraEnabled public Boolean isImage;
    }


}