@isTest
public with sharing class asignacionDN_Test {
    @TestSetup
    static void createObjects(){
        
         //user        
        
 
         User userT2 = new User();
         userT2.FirstName = 'leos';
         userT2.LastName = 'test2';
         userT2.Email = 'leoTest@test.com';
         userT2.Username = 'leoTest@test.com.leoTest2';
         userT2.Alias = 'TestL';
         userT2.TimeZoneSidKey = 'America/Mexico_City';
         userT2.LocaleSidKey = 'es_MX';
         userT2.EmailEncodingKey = 'UTF-8';
         userT2.ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id;
         userT2.LanguageLocaleKey = 'es_MX';
         insert userT2;
 
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
         userT.managerId=userT2.id;
         insert userT;
         //Account        
         Account accCustomer = createAccount('Cuenta customer', 'Customer');
         insert accCustomer;
 
         Account accCarrier = createAccount('Cuenta carrier', 'Supply Chain Partner');        
         insert accCarrier;
        
         Rol_Margen__c rl = TestDataFactory.createRolMargen('Director Comercial');
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
         Vehicle__c v = new Vehicle__c();
         v.Name = 'Vehiculo test';
         v.Account_for_SCP__c = accCarrier.Id;
         //v.Container_Type__c = ctV.Id;
         v.Marca__c = 'Mercedes';
         v.Color_Tracto__c ='Rojo';
         v.Modelo__c ='K77';
         v.Ano__c = 2021;
         v.Configuracion_Vehicularcat__c = trans1.Id;
         v.Account_Owner_Vehicle__c = accCarrier.Id ;
         v.Numero_Poliza_Seguro__c = '1234556';
         v.Asegura_Responsabilidad_Civil__c = 'AXXXA';
         v.Nombre_Aseguradora__c = 'AXXXA';
         v.Poliza_Responsabilidad_civil__c = '123456789';
         v.Prima_Seguro__c = '123456789';
         v.Numero_de_Permiso_SCT__c = '123456789';
         v.Tipo_de_Permiso__c = trans2.Id;
         insert v;
 
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
 
         Customer_Quote__c folio = new Customer_Quote__c();
         folio.Account_for__c = accCustomer.Id;
         folio.Freight_Mode__c = 'Air';
         folio.Service_Mode__c = 'Import'; 
         folio.Service_Type__c = 'LCL Cargo';
         folio.Move_Type__c = 'Door to Door';
         folio.Origin_Address__c = 'Address Test'; 
         folio.Destination_Address__c = 'Address Test';
         folio.ByPass__c = true;
         folio.Impak_Request__c = true;
         folio.Date_Pricing_responded__c = System.today();
         folio.Clave_de_Unidad_de_Peso__c = catalogo.Id;
		 folio.Pricing_Executive__c = userInfo.getUserId();        
         insert folio; 
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
        trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get(RecordType).getRecordTypeId();        
        return trans;        
    }
    @isTest
    public static void runTest(){
        Customer_Quote__c folio = [SELECT ID,Customer_Reference__c FROM Customer_Quote__c LIMIT 1];
        folio.Customer_Reference__c='asdsdf';
        update folio;
    }
}