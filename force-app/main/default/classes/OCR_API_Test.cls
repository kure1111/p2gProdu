@isTest
public with sharing class OCR_API_Test {
    @TestSetup
    static void createObjects(){
      
        //user        
        User userT = new User();
        userT.FirstName = 'leo';
        userT.LastName = 'test';
        userT.Email = 'leoTest@test.com';
        userT.Username = 'leoTest@test.com.leoTest';
        userT.Alias = 'TestL';
        userT.TimeZoneSidKey = 'America/Mexico_City';
        userT.LocaleSidKey = 'es_MX';
        userT.EmailEncodingKey = 'UTF-8';
        userT.ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id;
        userT.LanguageLocaleKey = 'es_MX';
        insert userT;

        //Account        
        Account accCustomer = createAccount('Cuenta customer', 'Customer');
        insert accCustomer;

        Account accCarrier = createAccount('Cuenta carrier', 'Supply Chain Partner');        
        insert accCarrier;

        //Container Type
        Container_Type__c ctV = new Container_Type__c();
        ctV.Name = 'caja test';
        ctV.Type__c = 'Road';
        ctV.Height_cm__c = 250;
        ctV.Length_cm__c = 1450;
        ctV.Width_cm__c = 250;
        ctV.Cargo_Weight_Kg__c = 25000;
        insert ctV;   
        
        //RecordType: produccion:Configuracion Autotransporte  UAT: Configuracion Autotrasporte
        Catalogo_SAT__c trans1 = createCatalogoSat('Camión-Remolque-Test', 'T3S17','Configuracion Autotransporte');                        
        insert trans1;        

        //RecordType: AUT y  produccion : Tipo de Permiso     
        Catalogo_SAT__c trans2 = createCatalogoSat('Autotransporte Federal Test' , 'T3S172','Tipo de Permiso');
        insert trans2;

        //Vehiculo
        Vehicle__c v = createVehicle('Vehiculo test', accCarrier.Id, trans1.Id, trans2.Id, 'Si');
        insert v;
        
        Vehicle__c v2 = createVehicle('Vehiculo test2', accCarrier.Id, trans1.Id, trans2.Id, 'No');
        insert v2;

        // cp
        Catalogo_SAT__c cp = new Catalogo_SAT__c();        
        cp.Name  = '980828';
        cp.Clave_SAT__c = '980828';
        cp.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert cp;

        //Operador        
		Operadores__c operador = new Operadores__c();
		operador.Account__c = accCarrier.Id;		
        operador.Name = 'Operador test';
        operador.Cel_ope__c = '123456789';
        operador.Telfij_ope__c = '123123123';
        operador.Medprev_ope__c = '123123';
        operador.Proovedor_validado__c = true;
        operador.Validado__c = true;        
        operador.Operador_Validado__c = true;
        operador.Codigo_Postal_Operador__c = cp.Id;
        operador.RFC_Operador__c = 'TestRFC';
        operador.Numlicvig_ope__c = '123135';
        
		insert operador;

        Catalogo_SAT__c catalogo = new Catalogo_SAT__c();
        catalogo.Name = 'Caja de acero test';
        catalogo.Clave_SAT__c = 'Caja de acero test';
        catalogo.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Unidad Peso').getRecordTypeId();
        insert catalogo;      

        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = 'SP-FN-21-280888';                      
        new_shipment.Freight_Mode__c = 'Road';
        new_shipment.Account_for__c=accCustomer.Id;             
        new_shipment.Service_Mode__c = 'NATIONAL';
        new_shipment.Service_Type__c =  'LTL';
        new_shipment.Move_Type__c = 'Door to Door';        
        new_shipment.Only_Warehouse_Service__c = false;                    
        new_shipment.Operation_Executive__c = userT.Id; 
        new_shipment.Carrier__c = accCarrier.Id; 
        new_shipment.National_Operator__c = operador.Id;
        new_shipment.Vehicle__c = v.Id;        
        insert new_shipment;    

        Associated_Document__c docV = createDoc();
        docV.Account__c = v.Account_for_SCP__c;
        docV.vehicle__c = v.Id;
        docV.Document_Type__c = 'Tercerizado';
        docV.name = 'Tercerizado';
        insert docV;

        Associated_Document__c docOp = createDoc();
        docOp.Account__c = operador.Account__c;
        docOp.Operadores__c = operador.Id;
        docOp.Document_Type__c = 'Licencia';
        docV.name = 'Licencia';
        insert docOp;

        Associated_Document__c docSP = createDoc();
        docSP.Account__c = new_shipment.Account_for__c;
        docSP.Shipment__c = new_shipment.Id;
        docSP.Document_Type__c = 'Otros';
        docV.name = 'Otros.jpg';
        insert docSP;

        //https://base64.guru/converter/encode/file 
        String tokenName = 'einstein_platform.pem';
        Blob bolbTemp = Blob.valueOf('MIIEowIBAAKCAQEAuZEBlVG7SjZawgsGgMFoFLQvZhlsmgrb9fiQz/bD4tevnMIH3DQkSIyAwg4DbFT4StJQgK+Wl0vXpFj+Z+dmL7ZwoM0kBma2RyIdXxaRXZgxv48udrYu3GTBxgLVfMnkRPzFpH/yI2nvKpLgXY4g+OkM3hpAzRuyGIQW/g7s7//j3ZFOBjJYEs5DWjpadiQAvWYnGtdTCLozFl2tdJQ9k+wA09WntUBNK+ETYRnX3OaJqFSQ6yvYRN03iqGP6t4bF/Jo7UIxZFapR1QCWNXfFRSQwCqLx3G2ACjbG6PRY9CkZIS4QBh/iYN0yNLx4/vjniJffuvIB2JfOuALe8Y2QQIDAQABAoIBAFLFxLAHSgSbZDZj1p2+J5/8k5v2QUQhDeaU3nt1NgFMdi/1OK5Xr8uQqKpmt84txKcTUwdjy0dndCQB8lEEnccwmOKRPr2AOVRXekR8+5CFH8OzqWUYdKSoaOrbPsEwCRtgqQRsceSsDxutclko2bpNsgisKzWSYgmfeeYPYE7Y0heZntptVTuQUHFLbhz/BD3+b2WlKQM+5qG8j4CPE5Au8G/Fr7jdouHcZWZD85owiF6BgCNlO/HiPp2hDBeRB6Vsg9TKgHYXqWno5MzJhQPuu2m0HicprzPiKVYOy+GaKLAiUVkCRQV0tOjMFMmaTPwxO4W9PmGfzfeHaopBypUCgYEA38n10bzQphWQehcrueOOlzRktiye3vzWwHlj/qIalRUk5rcWz32XbZjDae0JGzFCP1bzv23Ig5FKHJCPCec9J+c+KleVCh4D7FDRW59Gxzq9E+vWXXXxWY/UCdq2ls7HsQLtMHesLsPSk/XUeFU9dajzY9nEmBzMmrHS5bvlnoMCgYEA1EaloZMScgKEZUi7oaVgIZXxYIBUeH3Wl9oiVPRX1jJpC0D5GiMRewmQTO1v/ZGs5wuuOf/b0Y1dfUBlVZKUoqweRlUHEgZDVGoGNHIh2Ted/25NcGpbGIw8xuIVsk62zi2OceeMtU6+cKGGSRkOApKDklA+u/sHi5ER0r4dPOsCgYAZpdTVd9VV44zOYU9ym4DhFXEha9W9aq7WGlN6gGuZgHXdN0iW+SbcubBTuIXdpvSXu8htvRBI++LJiUvLb8QTia4XPjhnk28Rq2WDIasD9FhtKw9DYNwLTq+XfYiFmidKwzIZ5u1F4s2EhZ0XOXW0wWs7m16rrElKxWyNRc6YLwKBgQCso9hJFAfIWWu7w+91g74vEneA+F26sP05+to5JY/aUJ1F3c26CBNLcXe+WMzf+P4Z2lIUMZZhUwtZtmmzssbXlgv5P2XErvtLR/9L4BbPRoBlIRwx9Q2pZUR4q57hqUrbXAmhcaPqQOR5TaSdBpdyWB5RfJnI4Fw+kflg3+V/iQKBgDGRK1L7V0PokGgfFqq9PkyOJy/v2/W46Cfq154fILzEV1ytAejZu3hruxLuV0z65bgiAVtBkt3JsK7W6grwR/ZrPeW3lsTUWl80ZhUia2I6UEsNJGeHeFegqsofikdwP/JupgqpAdMaotM316sfRr+G8rtjiRQwUjeRsOwhgBte-----END RSA PRIVATE KEY-----');
        String b64 = EncodingUtil.base64Encode(bolbTemp);
        
        ContentVersion cv1 = createCV(b64, tokenName);        
        insert cv1;
        
		ContentDocumentLink cdl1 = createCDL(cv1.Id, accCustomer.Id);
		insert cdl1;        
        
        String fileName = 'Licencia.jpg';
        Blob tempBlob = Blob.valueOf(fileName);
        string bas64 = EncodingUtil.base64Encode(tempBlob);
        
        ContentVersion cv2 = createCV(bas64, fileName);
        insert cv2;
        
        ContentDocumentLink cdl2 = createCDL(cv2.Id, operador.Id);
        insert cdl2;
        
        String fileNamev = 'Tercerizado.png';
        Blob tempBlobv = Blob.valueOf(fileNamev);
        string bas64v = EncodingUtil.base64Encode(tempBlobv);
        
        
        ContentVersion cv3 = createCV(bas64v, fileNamev);
        insert cv3;
        
        ContentDocumentLink cdl3 = createCDL(cv3.Id, v.Id);
        insert cdl3;
        
        
        String fileNamev2 = 'Tarjeta Circulacion.png';
        Blob tempBlobv2 = Blob.valueOf(fileNamev2);
        string bas64v2 = EncodingUtil.base64Encode(tempBlobv2);
        
        ContentVersion cv4 = createCV(bas64v2, fileNamev2);
        insert cv4;
        
        ContentDocumentLink cdl4 = createCDL(cv4.Id, v2.Id);
        insert cdl4;
        
        /*ContentVersion cv1 = new ContentVersion();          
        cv1.VersionData = EncodingUtil.base64Decode(b64);          
        cv1.Title = tokenName;          
        cv1.PathOnClient = tokenName;          
        insert cv1; 
        
        
        ContentDocumentLink cdl1 = new ContentDocumentLink();
        cdl1.ContentDocumentId = [ SELECT ContentDocumentId  FROM ContentVersion WHERE Id =: cv1.Id].ContentDocumentId;
        cdl1.LinkedEntityId = accCustomer.Id;        
        cdl1.ShareType = 'V';
        insert cdl1;
        
        String fileName = 'Licencia.jpg';
        Blob tempBlob = Blob.valueOf(fileName);
        string bas64 = EncodingUtil.base64Encode(tempBlob);
        
        ContentVersion cv = new ContentVersion();          
        cv.VersionData = EncodingUtil.base64Decode(bas64);          
        cv.Title = fileName;          
        cv.PathOnClient = fileName;          
        insert cv; 

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [ SELECT ContentDocumentId  FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = operador.Id;        
        cdl.ShareType = 'V';
        insert cdl;  
        
        String fileNamev = 'Tercerizado.png';
        Blob tempBlobv = Blob.valueOf(fileNamev);
        string bas64v = EncodingUtil.base64Encode(tempBlobv);
        
        ContentVersion cv2 = new ContentVersion();          
        cv2.VersionData = EncodingUtil.base64Decode(bas64v);          
        cv2.Title = fileNamev;          
        cv2.PathOnClient = fileNamev;          
        insert cv2; 

        ContentDocumentLink cdl2 = new ContentDocumentLink();
        cdl2.ContentDocumentId = [ SELECT ContentDocumentId  FROM ContentVersion WHERE Id =: cv2.Id].ContentDocumentId;
        cdl2.LinkedEntityId = v.Id;        
        cdl2.ShareType = 'V';
        insert cdl2;*/  
            
    }
    
    public static Vehicle__c createVehicle(String name, Id accCarrier, Id trans1, Id trans2, String type){
        
        Vehicle__c v = new Vehicle__c();
        v.Name = name;
        v.Account_for_SCP__c = accCarrier;//accCarrier.Id;
        //v.Container_Type__c = ctV.Id;
        v.Marca__c = 'Mercedes';
        v.Num_Placa_Tracto__c = '45aasd15';
        v.Color_Tracto__c ='Rojo';
        v.Modelo__c ='K77';
        v.Ano__c = 2021;
        v.Configuracion_Vehicularcat__c = trans1;//trans1.Id;
        v.Account_Owner_Vehicle__c = type == 'Si' ? accCarrier : null;//accCarrier.Id ;
        v.Numero_Poliza_Seguro__c = '1234556';
        v.Asegura_Responsabilidad_Civil__c = 'AXXXA';
        v.Nombre_Aseguradora__c = 'AXXXA';
        v.Poliza_Responsabilidad_civil__c = '123456789';
        v.Prima_Seguro__c = '123456789';
        v.Numero_de_Permiso_SCT__c = '123456789';
        v.Tipo_de_Permiso__c = trans2;//trans2.Id;
        v.Vehiculo_Validado__c = true;
        return v;
    }
    
    public static ContentVersion createCV(String base64, String fileName){
                
        ContentVersion cv = new ContentVersion();          
        cv.VersionData = EncodingUtil.base64Decode(base64);          
        cv.Title = fileName;          
        cv.PathOnClient = fileName;          
        return cv;        
    }
        
    
    public static ContentDocumentLink createCDL(Id cv, Id obj){
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [ SELECT ContentDocumentId  FROM ContentVersion WHERE Id =: cv].ContentDocumentId;
        cdl.LinkedEntityId = obj;        
        cdl.ShareType = 'V';
        return cdl;
    }
        
    public static Associated_Document__c createDoc(){

        Associated_Document__c new_doc = new Associated_Document__c();
        new_doc.Account__c = null;
        new_doc.Shipment__c = null;                
        new_doc.vehicle__c = null;
        new_doc.Operadores__c = null;
        new_doc.Available_for_Community__c = true;
        new_doc.Type__c = 'File';
        new_doc.Document_Type__c = null;
        new_doc.Document_URL__c = 'www.testDocs.com';
        new_doc.Name = null; 
        return new_doc;
    }

    public static Account createAccount(String name, String recordType){
        
        Account accountT = new Account();
        accountT.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        accountT.name = name;    

        if(recordType == 'Supply Chain Partner'){
            accountT.Phone = '8311109798';
            accountT.Brand_Name__c = 'Cuenta carrier';
            accountT.NEU_Email__c = 'test@live.com';
            accountT.TAX_ID__c = 'TEST1106099H1';
            accountT.Ubicta_cta__c = 'Nacional';
            accountT.Grupo_SAP_PICK__c = 'FLETES TEST';
            accountT.SCPNombre_Acta_Constitutiva__c = 'N A';
            accountT.Bank_Name_Supplier_Form2__c = 'Banorte Test';
            accountT.Bank_Account_Number__c = '0720780101000000';
            accountT.Bank_Account_Name__c = 'Cuenta carrier';
            accountT.Credit_Limit__c = 500;
            accountT.Anticipo__c = 'No';
            accountT.Sujeto_a_retencion__c = 'Si';
            accountT.Factoraje__c = 'No';
            accountT.C_digo_IVA_Permitido__c = 'IRF';
            accountT.Indicador_de_impuestos__c = 'V2';
        
        }else{        
            accountT.AccountSource = 'Other';
            accountT.TAX_ID__c = 'TEST1106090000';
        }

        return accountT;            
    }

    public static Catalogo_SAT__c createCatalogoSat(String name, String claveSat, String RecordType){

        Catalogo_SAT__c trans = new Catalogo_SAT__c();        
        trans.Name  = name;
        trans.Clave_SAT__c = claveSat;
        trans.RecordTypeId =Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get(RecordType).getRecordTypeId();
        return trans;        
    }
    
    @isTest
    public static void ocrTest(){

        Id v = [Select Id from Vehicle__c where Name = 'Vehiculo test'].Id;
        Id v2 = [Select Id from Vehicle__c where Name = 'Vehiculo test2'].Id;
        Id op = [Select Id from Operadores__c where Name = 'Operador test'].Id;
        Id sp = [Select Id from Shipment__c  where Name = 'SP-FN-21-280888'].Id;
        
        ContentVersion cv = [SELECT Id, Title, ContentDocumentId FROM ContentVersion where Title = 'Licencia.jpg'];
        ContentVersion cvT = [SELECT Id, Title, ContentDocumentId FROM ContentVersion where Title = 'Tercerizado.png'];
        ContentVersion cvT2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion where Title = 'Tarjeta Circulacion.png'];
              
        Test.startTest();
        OCR_API.getImageText(v, cvT.id, 'Tercerizado');
        OCR_API.getImageText(v2, cvT2.id, 'Tarjeta Circulacion');
        OCR_API.getImageText(op, cv.id, 'Licencia');
        OCR_API.getObjectType(v);
        //OCR_API.bypass();
        //ContentTriggerHandler.bypass();
        Test.stopTest();
    }
    
    @isTest
    public static void validateJWT(){
        
        test.startTest();
        
        	JWT jwt = new JWT('RS256');
            jwt.iss = 'developer.force.com';
            jwt.sub = 'ejemplo@gmail.com'; // Change this with your email which is used for einstein api setup
            jwt.aud = 'https://prueba/ejemplo';
            jwt.exp = '3600';
        	jwt.pkcs8 = 'EjemploPrueba'; 
        	String token = jwt.issue();
        
        	JWT jwt1 = new JWT('HS256');
            jwt1.iss = 'developer.force.com';
            jwt1.sub = 'ejemplo@gmail.com'; // Change this with your email which is used for einstein api setup
            jwt1.aud = 'https://prueba/ejemplo';
            jwt1.exp = '3600';
        	jwt1.pkcs8 = 'EjemploPrueba'; 
        	String token1 = jwt.issue();
        
        	String access_token = JWTBearerFlow.getAccessToken('https://ejemplo/test/', jwt);
        
        test.stopTest();
        
    }
    @isTest
    public static void einsteinOCRtest(){
        String imageUrl='https://pak2gologistics--uat--c.documentforce.com/sfc/dist/version/download/?oid=00D0R000000MBcG&ids=0680R000001qAK4&d=%2Fa%2F0R0000008lhS%2FgQO6a2PnP2bfh8ZpYA46nqG3MQ4UMFNRDCIHt4OMmaM&asPdf=false token: GVHUENCQLFHFAR2MJQ3UERRSJJGVOR2KLJMFQSJSIVNFQSKQLBNFQNSUJBKFOQ2SKZDVEUK2LFAU4TZXIVFDOWKUKNGESSKZGZBEWWBVIZNE4Q2ZJNJDIQSIIFDDGWBUJNJEWSJUGY3UINRXINDVSRCSGZEESTSMKVLUC7COIE'; 
        String token='GVHUENCQLFHFAR2MJQ3UERRSJJGVOR2KLJMFQSJSIVNFQSKQLBNFQNSUJBKFOQ2SKZDVEUK2LFAU4TZXIVFDOWKUKNGESSKZGZBEWWBVIZNE4Q2ZJNJDIQSIIFDDGWBUJNJEWSJUGY3UINRXINDVSRCSGZEESTSMKVLUC7COIE '; 
        String model='OCRModel';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new einsteinMock());
        EinsteinOCR.extractText(imageUrl,token,model);
        test.stopTest();
        
    }
    @isTest
    public static void einsteinControllerTest(){
        Blob bolbTemp = Blob.valueOf('MIIEowIBAAKCAQEAuZEBlVG7SjZawgsGgMFoFLQvZhlsmgrb9fiQz/bD4tevnMIH3DQkSIyAwg4DbFT4StJQgK+Wl0vXpFj+Z+dmL7ZwoM0kBma2RyIdXxaRXZgxv48udrYu3GTBxgLVfMnkRPzFpH/yI2nvKpLgXY4g+OkM3hpAzRuyGIQW/g7s7//j3ZFOBjJYEs5DWjpadiQAvWYnGtdTCLozFl2tdJQ9k+wA09WntUBNK+ETYRnX3OaJqFSQ6yvYRN03iqGP6t4bF/Jo7UIxZFapR1QCWNXfFRSQwCqLx3G2ACjbG6PRY9CkZIS4QBh/iYN0yNLx4/vjniJffuvIB2JfOuALe8Y2QQIDAQABAoIBAFLFxLAHSgSbZDZj1p2+J5/8k5v2QUQhDeaU3nt1NgFMdi/1OK5Xr8uQqKpmt84txKcTUwdjy0dndCQB8lEEnccwmOKRPr2AOVRXekR8+5CFH8OzqWUYdKSoaOrbPsEwCRtgqQRsceSsDxutclko2bpNsgisKzWSYgmfeeYPYE7Y0heZntptVTuQUHFLbhz/BD3+b2WlKQM+5qG8j4CPE5Au8G/Fr7jdouHcZWZD85owiF6BgCNlO/HiPp2hDBeRB6Vsg9TKgHYXqWno5MzJhQPuu2m0HicprzPiKVYOy+GaKLAiUVkCRQV0tOjMFMmaTPwxO4W9PmGfzfeHaopBypUCgYEA38n10bzQphWQehcrueOOlzRktiye3vzWwHlj/qIalRUk5rcWz32XbZjDae0JGzFCP1bzv23Ig5FKHJCPCec9J+c+KleVCh4D7FDRW59Gxzq9E+vWXXXxWY/UCdq2ls7HsQLtMHesLsPSk/XUeFU9dajzY9nEmBzMmrHS5bvlnoMCgYEA1EaloZMScgKEZUi7oaVgIZXxYIBUeH3Wl9oiVPRX1jJpC0D5GiMRewmQTO1v/ZGs5wuuOf/b0Y1dfUBlVZKUoqweRlUHEgZDVGoGNHIh2Ted/25NcGpbGIw8xuIVsk62zi2OceeMtU6+cKGGSRkOApKDklA+u/sHi5ER0r4dPOsCgYAZpdTVd9VV44zOYU9ym4DhFXEha9W9aq7WGlN6gGuZgHXdN0iW+SbcubBTuIXdpvSXu8htvRBI++LJiUvLb8QTia4XPjhnk28Rq2WDIasD9FhtKw9DYNwLTq+XfYiFmidKwzIZ5u1F4s2EhZ0XOXW0wWs7m16rrElKxWyNRc6YLwKBgQCso9hJFAfIWWu7w+91g74vEneA+F26sP05+to5JY/aUJ1F3c26CBNLcXe+WMzf+P4Z2lIUMZZhUwtZtmmzssbXlgv5P2XErvtLR/9L4BbPRoBlIRwx9Q2pZUR4q57hqUrbXAmhcaPqQOR5TaSdBpdyWB5RfJnI4Fw+kflg3+V/iQKBgDGRK1L7V0PokGgfFqq9PkyOJy/v2/W46Cfq154fILzEV1ytAejZu3hruxLuV0z65bgiAVtBkt3JsK7W6grwR/ZrPeW3lsTUWl80ZhUia2I6UEsNJGeHeFegqsofikdwP/JupgqpAdMaotM316sfRr+G8rtjiRQwUjeRsOwhgBte-----END RSA PRIVATE KEY-----');
        String b64 = EncodingUtil.base64Encode(bolbTemp);
        ContentVersion cv=createCV(b64, 'einstein_platform');
        insert cv;
        // insert cv;
        // String imageUrl='https://pak2gologistics--uat--c.documentforce.com/sfc/dist/version/download/?oid=00D0R000000MBcG&ids=0680R000001qAK4&d=%2Fa%2F0R0000008lhS%2FgQO6a2PnP2bfh8ZpYA46nqG3MQ4UMFNRDCIHt4OMmaM&asPdf=false token: GVHUENCQLFHFAR2MJQ3UERRSJJGVOR2KLJMFQSJSIVNFQSKQLBNFQNSUJBKFOQ2SKZDVEUK2LFAU4TZXIVFDOWKUKNGESSKZGZBEWWBVIZNE4Q2ZJNJDIQSIIFDDGWBUJNJEWSJUGY3UINRXINDVSRCSGZEESTSMKVLUC7COIE'; 
        // String token='GVHUENCQLFHFAR2MJQ3UERRSJJGVOR2KLJMFQSJSIVNFQSKQLBNFQNSUJBKFOQ2SKZDVEUK2LFAU4TZXIVFDOWKUKNGESSKZGZBEWWBVIZNE4Q2ZJNJDIQSIIFDDGWBUJNJEWSJUGY3UINRXINDVSRCSGZEESTSMKVLUC7COIE '; 
        // String model='OCRModel';
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new einsteinMock());
        String stToken =new EinsteinController().getAccessToken();
        test.stopTest();
        
    }
}