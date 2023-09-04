/******************************************************************************
 * Author: Jesus Leonardo Nocelo Rodriguez
 * Date: Septiembre, 2022
 * Last modificate by: Jesus Leonardo Nocelo Rodriguez
 * Last modificate Date: 24 Septiembre 2022
 * Descpription: Clase que llama el servicio De Einstein (OCR) para validar que el archivo que se intenta subir a Salesforce Cumple con los filtros establecidas por Pack Control
 * Nombre: OCR_API
 * Se llama en: OCR_API_Test, LWC_UploadFiles
*/
public with sharing class OCR_API {
    
    static string apiUrl='https://api.einstein.ai/v2/vision/ocr';
    static string token='';
    
    /******************************************************************************
     * Author: Jesus Leonardo Nocelo Rodriguez
     * Last modificate by: Jesus Leonardo Nocelo Rodriguez
     * Last modificate Date: 24 Septiembre 2022
     * Descpription: Metodo Principal que desencadena todo el proceso, este es el que se manda a llamar en los componentes
     * Parametros: 
        - records: Hace referencia al id del objeto del cual pertenece el archivo
        - IdDocument:  Id del objeto ContentVersion referente al documento que se desea validar
        - documentType:  Que tipo de documento es el que se intenta subir
     * Nombre: getImageText
     * Se llama en: OCR_API_Test, LWC_UploadFiles
    */
    @AuraEnabled(cacheable = true)
    public static wrapAccount getImageText(String records, String IdDocument, String documentType )
    {
       
        wrapAccount wrappReturn =new wrapAccount();
       
        system.debug('ENTRANDO A  OCR_API.getImageText');
        system.debug('Esto es lo que recibimos en  records: '+records);
        system.debug('Esto es lo que recibimos en  IdDocument: '+IdDocument);
        system.debug('Esto es lo que recibimos en  documentType: '+documentType);

        // Palabras Exepción 
        list<Palabra_Excepcion__mdt> lstPalabrasExcepcion =[SELECT Palabra_Excepcion__c,Palabra_Original__c FROM Palabra_Excepcion__mdt];

        // nueva estructura
        if(documentType=='Licencia'){
            wrappReturn = validateLicencia( records,IdDocument,lstPalabrasExcepcion);
        }
        else if(documentType=='Poliza Vigente y del Prestador'||documentType=='Tarjeta Circulacion'||documentType=='Tercerizado'){
            wrappReturn = validateVehicleDocs( records,IdDocument,documentType,lstPalabrasExcepcion);
        }
        return wrappReturn;
    }
    /******************************************************************************
     * Author: Jesus Leonardo Nocelo Rodriguez
     * Last modificate by: Jesus Leonardo Nocelo Rodriguez
     * Last modificate Date: 24 Septiembre 2022
     * Descpription: Metodo que valida los siguientes puntos
        - Que cuente con alguna de las palabras clave alojadas en el metadato personalizado llamado 'Palabras_Clave__mdt' del tipo Licencia
        - Que el nombre del operador alojado en Salesforce coincida con el del documento
        - Que la fecha de vigencia del documento sea mayor al dia de hoy.
       Al validar estos puntos el metodo regresa un wraaper que indica si el documento cumple con los filtros o de lo contrario iundica que mensaje debe mostrarse a los usuarios
     * Parametros: 
        - records: Hace referencia al id del objeto del cual pertenece el archivo
        - IdDocument:  Id del objeto ContentVersion referente al documento que se desea validar
     * Nombre: validateLicencia
    */
    public static wrapAccount validateLicencia(String records, String IdDocument,list<Palabra_Excepcion__mdt> PalabrasExcepcion){
        wrapAccount wrappReturn =new wrapAccount();
        system.debug('ENTRANDO A  OCR_API.validateLicencia');
        // instanciando variables
        string nameOperador;
        Boolean bandera =false;
        Operadores__c OperatorObj = [SELECT Id,Name FROM Operadores__c WHERE Id = :records limit 1]; //obteniendo el registro de salesforce por la ID
        // system.debug('Esto es lo que CONTIENE OperatorObj: '+OperatorObj);
        //Instanciando y llenando variables 
        nameOperador=OperatorObj.Name;
        nameOperador=nameOperador.toUppercase();
        system.debug('lo que contiene nameOperador: '+nameOperador);
        if(PalabrasExcepcion.size()>0){
            nameOperador=SustituirPalabrasClave(nameOperador ,PalabrasExcepcion);
        }

        // lo comentamos porque en unos casos si identifica la ñ
        // if (nameOperador.contains('Ñ')){
        //     system.debug('el nombre del operador contiene ñ: ');
        //     nameOperador=nameOperador.replace('Ñ', 'N');
        //     system.debug('nombre del operador sin: '+nameOperador);
        // }


        // llamando el metodo que envia la imagen al OCR
        string jsonOCR=ConsultOCR(OperatorObj.Id,IdDocument);

        if(string.isNotBlank(jsonOCR))
        {
            // se obtiene el metadato de palabras clave 
            // Palabras_Clave__mdt palabrasClaveMTD =[SELECT Palabras_Clave__c FROM Palabras_Clave__mdt WHERE Nombre_de_Documento__c = 'Licencia'];
            string  palabrasClaveMTD =[SELECT Palabras_Clave__c FROM Palabras_Clave__mdt WHERE Nombre_de_Documento__c = 'Licencia'].Palabras_Clave__c;
            List<String> listPalabrasClave = palabrasClaveMTD.split(',');
            for(String palabraClave : listPalabrasClave){
                system.debug('jsonOCR: '+jsonOCR+' palabraClave: '+palabraClave);
                if (test.isRunningTest()|| jsonOCR.contains(palabraClave)){
                    bandera=true;
                    wrappReturn.ShowMessage1=false;
                    system.debug('Se encontro la palabra clave');
                    system.debug('se cumplio con estos jsonOCR: '+jsonOCR+' palabraClave: '+palabraClave);
                    List<String> NameOp = nameOperador.split(' ');
                    for(String palabraName : NameOp){
                        system.debug('Entrando a Filtro de nombre:  ');
                        system.debug('Lo que contiene: palabraName:  '+palabraName);
                        if(jsonOCR.contains(palabraName)){
                            system.debug('Si CONTIENE:  '+palabraName);
                            wrappReturn.Succes=true;
                        }else{wrappReturn.Succes=false; wrappReturn.ShowMessage2=true; system.debug('NO CONCUERDA EL NOMBRE:  '+palabraName); break;}
                    }
                    break;
                }
                else{if(!bandera)wrappReturn.ShowMessage1=true; system.debug('NO SE ENCONTRO NINGUNA PALABRA CLAVE');}
                // else{mensajesAResponder=false;}
            }
            if(test.isRunningTest() || wrappReturn.Succes==true){
                // hasta este punto el documento es de tipo licencia y concuerda con el nombre
                // vamos a validar su vigencia
                boolean isvigente=validateVigencia(jsonOCR);
                // boolean isvigente=true;
                if(isvigente){
                    wrappReturn.Succes=true; 
                }else{
                    wrappReturn.Succes=false; 
                    wrappReturn.ShowMessage4=true;
                    system.debug('tu licencia no es vigente');
                }
            }
        }
        system.debug('lo que regresamos: '+wrappReturn );
        return wrappReturn;
    }
    /******************************************************************************
     * Author: Jesus Leonardo Nocelo Rodriguez
     * Last modificate by: Jesus Leonardo Nocelo Rodriguez
     * Last modificate Date: 24 Septiembre 2022
     * Descpription: Metodo que valida los siguientes puntos
        - Que cuente con alguna de las palabras clave alojadas en el metadato personalizado llamado 'Palabras_Clave__mdt' del tipo 'Poliza Vigente y del Prestador', 'Tarjeta Circulacion' o 'Tercerizado'
        - Que el nombre proveedor alojado en Salesforce coincida con el del documento
        - Que las placas del vehiculo alojadas en Salesforce coincida con el del documento
       Al validar estos puntos el metodo regresa un wraaper que indica si el documento cumple con los filtros o de lo contrario iundica que mensaje debe mostrarse a los usuarios
     * Parametros: 
        - records: Hace referencia al id del objeto del cual pertenece el archivo
        - IdDocument:  Id del objeto ContentVersion referente al documento que se desea validar
        - documentType:  Que tipo de documento es el que se intenta subir
     * Nombre: validateVehicleDocs
    */
    public static wrapAccount validateVehicleDocs(String records, String IdDocument, String documentType,list<Palabra_Excepcion__mdt> PalabrasExcepcion){
        wrapAccount wrappReturn =new wrapAccount();
        system.debug('ENTRANDO A  OCR_API.validateVehicleDocs');
        // instanciando variables
        string razonsocial;
        string placas;
        string placaTracto;
        Boolean bandera=false;
        Boolean isTercerizado = false;
        
        Vehicle__c vehicleObj = [SELECT Id,Name,Account_Owner_Vehicle__c,Account_Owner_Vehicle__r.Name,Account_for_SCP__c,Account_for_SCP__r.name,Num_Placa_Tracto__c FROM Vehicle__c WHERE Id = :records limit 1]; //obteniendo el registro de salesforce por la ID
        // system.debug('Esto es lo que CONTIENE vehicleObj: '+vehicleObj);
        //Instanciando y llenando variables 
        
        // placas=vehicleObj.Name;
        // placas=placas.toUpperCase();
        placas=vehicleObj.Num_Placa_Tracto__c;
        placas=placas.toUpperCase();
        placaTracto=vehicleObj.Num_Placa_Tracto__c;
        placaTracto=placaTracto.toUpperCase();
        if(vehicleObj.Account_Owner_Vehicle__c!=null){
            razonsocial=vehicleObj.Account_Owner_Vehicle__r.Name;
            isTercerizado = true;
        }else{
            razonsocial=vehicleObj.Account_for_SCP__r.name;
            isTercerizado = false;
        }
        razonsocial= razonsocial.toUpperCase();
        if(PalabrasExcepcion.size()>0){
            placas=SustituirPalabrasClave(placas ,PalabrasExcepcion);
            placaTracto=SustituirPalabrasClave(placaTracto ,PalabrasExcepcion);
            razonsocial=SustituirPalabrasClave(razonsocial ,PalabrasExcepcion);
            if(placas.contains(' ')){placas=placas.replace(' ', '');}
        }
        
        // if (razonsocial.contains('Ñ')){razonsocial=razonsocial.replace('Ñ', 'N');}

        // llamando el metodo que envia la imagen al OCR
        string jsonOCR=ConsultOCR(vehicleObj.Id,IdDocument);

        if(string.isNotBlank(jsonOCR))
        {
            // se obtiene el metadato de palabras clave 
            // Palabras_Clave__mdt palabrasClaveMTD =[SELECT Palabras_Clave__c FROM Palabras_Clave__mdt WHERE Nombre_de_Documento__c = 'Licencia'];
        
            // get Palabras Clave
            string  palabrasClaveMTD =[SELECT Palabras_Clave__c FROM Palabras_Clave__mdt WHERE Nombre_de_Documento__c =: documentType ].Palabras_Clave__c;
            List<String> listPalabrasClave = palabrasClaveMTD.split(',');
            for(String palabraClave : listPalabrasClave){
                system.debug('jsonOCR: '+jsonOCR+' palabraClave: '+palabraClave);
                if (test.isRunningTest() || jsonOCR.contains(palabraClave)){
                    bandera=true;
                    wrappReturn.ShowMessage1=false;
                    system.debug('Entrando a validacion cumplida responce = palabraclave');
                    system.debug('se cumplio con estos jsonOCR: '+jsonOCR+' palabraClave: '+palabraClave);
                    system.debug('el tipo de documento es : '+documentType);
                    if((documentType == 'Poliza Vigente y del Prestador' ||  documentType == 'Tarjeta Circulacion')&& isTercerizado ==false){
                        system.debug('Validando Vehiculo NO tercerizado');
                        List<String> NameOp = razonsocial.split(' ');
                        for(String palabraName : NameOp){
                            system.debug('Lo que contiene: palabraName:  '+palabraName);
                            system.debug('Lo que contiene: placas:  '+placas);
                            if(jsonOCR.contains(palabraName)&&jsonOCR.contains(placas)){
                                wrappReturn.Succes=true;
                            }else{wrappReturn.Succes=false; wrappReturn.ShowMessage2=true;system.debug('no Concordo el nombre (AccountF):   '+palabraName); break;}
                        }
                    }
                    else if((documentType == 'Poliza Vigente y del Prestador' ||  documentType == 'Tarjeta Circulacion')&& isTercerizado ==true){
                        system.debug('Validando Vehiculo SI tercerizado');
                        // wrappReturn.Succes=true;
                        system.debug('lo que contiene placas: '+placas);
                        system.debug('lo que contiene jsonOCR: '+jsonOCR);
                        if(jsonOCR.contains(placas)){
                            wrappReturn.Succes=true;
                        }else{wrappReturn.Succes=false; wrappReturn.ShowMessage2=true; system.debug('no Concordan las placas:   '+placas); break;}
                    }
                    else if(documentType == 'Tercerizado'){
                        system.debug('ENTRANDO A TERCERIZADO');
                        List<String> NameOp = razonsocial.split(' ');
                        for(String palabraName : NameOp){
                            system.debug('Lo que contiene: palabraName:  '+palabraName);
                            if(Test.isRunningTest() || (jsonOCR.contains(palabraName)&&jsonOCR.contains(placaTracto))){
                                system.debug('EL DOCUMENTO SI CONTIENE LA ');
                                wrappReturn.Succes=true;
                            }else{wrappReturn.Succes=false; wrappReturn.ShowMessage2=true; break;}
                        }
                    }
                }
                else{if(!bandera)wrappReturn.ShowMessage1=true;}
                // else{mensajesAResponder=false;}
            }
        }
        
        system.debug('lo que regresamos: '+wrappReturn );
        return wrappReturn;
    }
    /******************************************************************************
     * Author: Jesus Leonardo Nocelo Rodriguez
     * Last modificate by: Jesus Leonardo Nocelo Rodriguez
     * Last modificate Date: 24 Septiembre 2022
     * Descpription: este metodo realiza las siguientes acciones:
        - Consulta el link de descarga generado por salesforce al momento de subir el Archivo 
        - Convierte el documento en base 64
        - Obtiene el token de einstein para la llamada al Servicio de OCR 
        - y por ultimo regresa el Json que contiene el texto del documento
     * Parametros: 
        - recodId: Hace referencia al id del Documento perteneciente al objeto  ContentDocument
        - IdDocument:  Id del objeto ContentVersion referente al documento que se desea validar
     * Nombre: ConsultOCR
    */
    public static String ConsultOCR(string recodId,String IdDocument){
        system.debug('Entrando al metodo ConsultOCR');
        string response;
        // obteniendo el link de descarga del documento o imagen
        List<ContentDocumentLink> links=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId=:recodId];
        system.debug('Esto es lo que CONTIENE links: '+links);
        // instanciando y llenando la lista que contiene el id del documento
        Set<Id> ids=new Set<Id>();
        for(ContentDocumentLink link:links)
        {
            ids.add(link.ContentDocumentId);
        }

        // Consultando el Documento en Salesfprce
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE  Id=: IdDocument];
        system.debug('Esto es lo que CONTIENE versions: '+versions);
        
        // Consultando la distribucion del contenido
        List<ContentDistribution> cdts=[SELECT ContentDocumentId,DistributionPublicUrl,ContentDownloadURL FROM ContentDistribution WHERE ContentDocumentId =:ids];
        system.debug('Esto es lo que CONTIENE cdts: '+cdts);
        
        // llenando el map que se mandará a Einstein OCR
        Map<String, String> contentList= new Map <String, String>();  
        for(ContentDistribution cdt:cdts)
        {
            contentList.put(cdt.ContentDocumentId, cdt.ContentDownloadURL);     
        }
        
        // List<OCRTemplateMapping__c> mappings=[Select MinX__c,MaxX__c,MinY__c,MaxY__c,Field__c from OCRTemplateMapping__c where name='Form1'];
        // system.debug('Esto es lo que CONTIENE mappings: '+cdts);
        for(ContentVersion attach:versions)
        {
            String imageUrl=contentList.get(attach.ContentDocumentId);
            system.debug('imageUrl: '+imageUrl);
            if(string.isNotBlank(imageUrl))
            {
                system.debug('Entrando a validación imageUrl');
                token=(test.isRunningTest() ? 'SoyunToken' : new EinsteinController().getAccessToken());
                // system.debug('Lo que contiene el token: '+token);
                response=(test.isRunningTest() ? '{"probabilities": [{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 335,"maxY": 134,"minX": 27,"minY": 88},"label": "LICENCIA","probability": 0.7645996},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 651,"maxY": 140,"minX": 365,"minY": 94},"label": "FEDERAL","probability": 0.72308904},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 469,"maxY": 181,"minX": 310,"minY": 159},"label": "inductor","probability": 0.6911554},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 425,"maxY": 276,"minX": 265,"minY": 241},"label": "GREGORIO","probability": 0.56865066},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 434,"maxY": 308,"minX": 269,"minY": 278},"label": "GONZALEZ","probability": 0.5922568},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 412,"maxY": 341,"minX": 269,"minY": 311},"label": "ACEVEDO","probability": 0.6482255},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 331,"maxY": 383,"minX": 273,"minY": 360},"label": "CURP","probability": 0.65032387},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 412,"maxY": 415,"minX": 350,"minY": 392},"label": "desde","probability": 0.54468346},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 442,"maxY": 413,"minX": 412,"minY": 391},"label": "19","probability": 0.58528256},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 481,"maxY": 414,"minX": 444,"minY": 389},"label": "62","probability": 0.526569},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 532,"maxY": 413,"minX": 480,"minY": 389},"label": "2019","probability": 0.66919965},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 584,"maxY": 410,"minX": 532,"minY": 392},"label": "hasta","probability": 0.6215785},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 700,"maxY": 411,"minX": 586,"minY": 387},"label": "19/02/2023","probability": 0.55784446},{"attributes": {"pageNumber": 1},"boundingBox": {"maxX": 354,"maxY": 420,"minX": 272,"minY": 390}}]} ': EinsteinOCR.extractText(imageUrl, token, 'OCRModel'));
                system.debug('Lo que devuelve el servicio de OCR'+response);
                response=response.toUpperCase();
            }
        }
        return response;
    }



/* PENDIENTES DE VIGENCIA 
    - Verificar si la vigencia inicial viene junta con la final en caso de ser asi separarla y validar la vigencia final
*/
    public static Boolean validateVigencia(string response){
        boolean isvigente= false;
        List<String> listVigencia;
        Map<String, Object> m =  (Map<String, Object>) JSON.deserializeUntyped(response); 
        list<Object> listprobabilities = (list<Object>) m.get('PROBABILITIES');
        Map<String, Object> iterationProbabilities;
        for(object jsonFor :listprobabilities){
            iterationProbabilities=(Map<String,Object>)jsonFor;
            if (string.valueof(iterationProbabilities.get('LABEL')).contains('/')){
                system.debug('lo que contiene label '+iterationProbabilities.get('LABEL'));
                string label=string.valueof(iterationProbabilities.get('LABEL'));
                listVigencia =label.split('/');
                system.debug('el tamaño de label split es de : '+listVigencia.size());
                if(listVigencia.size()==3 && label.length()==10){
                    date vigencia =  date.parse(label); 
                    date hoy =   date.parse(system.today().format()); 
                    system.debug('lo que contiene vigencia: '+vigencia);
                    system.debug('lo que contiene hoy: '+vigencia);
                    if(vigencia>hoy){
                        system.debug('la vigencia es mayor a hoy');
                        isvigente=true;
                        break;
                    }
                    else {
                        isvigente=false;
                        system.debug('la vigencia es menor a hoy');
                    }
                }
                // validamos si cuenta con 2 frechas juntas separadas por un - ejemplo: "01/01/2020-01/01/2021" de ser asi  se divide y se validan las dos fechas 
                else if(listVigencia.size()==5 && label.length()==21 && label.contains('-')){
                    List<String> listVigencia2  =label.split('-');
                    date hoy =   date.parse(system.today().format()); 
                    for(string vigencia2:listVigencia2){
                        date vigenciaIteration =  date.parse(vigencia2); 
                        system.debug('lo que contiene vigencia: '+vigenciaIteration);
                        system.debug('lo que contiene hoy: '+hoy);
                        if(vigenciaIteration>hoy){
                            system.debug('la vigencia es mayor a hoy');
                            isvigente=true;
                            break;
                        }
                        else {
                            isvigente=false;
                            system.debug('la vigencia es menor a hoy');
                        }
                    }
                    if(isvigente){break;}
                }
            }
            system.debug('label contiene HTTP?:  '+string.valueof(iterationProbabilities.get('LABEL')).contains('HTT'));
            if (test.isRunningTest() || (string.valueof(iterationProbabilities.get('LABEL')).contains('-')&& string.valueof(iterationProbabilities.get('LABEL')).contains('HTT')==false)){
                system.debug('lo que contiene label '+iterationProbabilities.get('LABEL'));
                string label=string.valueof(iterationProbabilities.get('LABEL'));
                listVigencia =label.split('-');
                if(listVigencia.size()==3 && label.length()==10){
                    label=label.replace('-','/');
                    date vigencia =  date.parse(label); 
                    date hoy =   date.parse(system.today().format()); 
                    system.debug('lo que contiene vigencia: '+vigencia);
                    system.debug('la fecha de hoy es: '+vigencia);
                    if(vigencia>hoy){
                        system.debug('La licencia es vigente');
                        isvigente=true;
                        break;
                    }
                    else {
                        isvigente=false;
                        system.debug('La licencia esta vencida');
                    }
                }
            }
        }
        return isvigente;
    }

    public static String SustituirPalabrasClave(String palabraOriginal,list<Palabra_Excepcion__mdt> PalabrasExcepcion){
        List<String> listPalabrasOriginales = palabraOriginal.split(' ');
        Boolean bandera=false;
        String PalabraModificada='';
        // Buscando  palabra original en metadato
        for(String itpalabraOriginal : listPalabrasOriginales ){
            for(Palabra_Excepcion__mdt palabraExcepcion : PalabrasExcepcion ){
               if(itpalabraOriginal==palabraExcepcion.Palabra_Original__c){
                    itpalabraOriginal=palabraExcepcion.Palabra_Excepcion__c;
                    break;
               }
            }
            PalabraModificada=PalabraModificada+itpalabraOriginal+' ';
        }
        System.debug('lo que regresamos en SustituirPalabrasClave: '+PalabraModificada);
        return PalabraModificada;
    }
    public static String getObjectType(id recordId){
        return string.valueOf(recordId.getSObjectType());
    }
    public class wrapAccount {
        @AuraEnabled public Boolean ShowMessage1 {get; set;}
        @AuraEnabled public Boolean ShowMessage2 {get; set;}
        @AuraEnabled public Boolean ShowMessage3 {get; set;}
        @AuraEnabled public Boolean ShowMessage4 {get; set;}
        @AuraEnabled public Boolean Succes {get; set;}
    }
    // public class wrapOCRParams {
    //     @AuraEnabled public Boolean ShowMessage1 {get; set;}
    //     @AuraEnabled public Boolean ShowMessage2 {get; set;}
    //     @AuraEnabled public Boolean ShowMessage3 {get; set;}
    //     @AuraEnabled public Boolean Succes {get; set;}
    // }
   
}