@isTest
public with sharing class APX_Verificacion_Pak_Control_Test {
    
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
         v.Vehiculo_Validado__c = true;
         insert v;
 
         // cp
         Catalogo_SAT__c cp = createCatalogoSat('980828','980828','Codigo Postal');                          
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

         Shipment__c new_shipment = new Shipment__c();
         new_shipment.Name = 'SP-FN-21-980828';  
         new_shipment.Traslado_Ingreso__c = 'Traslado';
         new_shipment.VERIFY_PAK_CONTROL__c = true;
         new_shipment.Shipment_Status_Plann__c = 'Confirmed';         
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
         new_shipment.Liga_Cuenta_Espejo__c = 'Ejemplo liga';
         new_shipment.Usuario_Cuenta_Espejo__c = 'Espejo cuenta';
         new_shipment.Contrasena_Cuenta_Espejo__c = 'cuenta espejo';
         new_shipment.ETA_Point_of_Discharge__c = Date.newInstance(2300, 2, 17);
         new_shipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(18, 30, 2, 20);
         new_shipment.ETD_from_Point_of_Load__c = Date.newInstance(2300, 2, 19);
         new_shipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(18, 30, 2, 20);
         new_shipment.kms__c = 2;
         new_shipment.ATA__c =Date.newInstance(2300, 2, 17);
         new_shipment.ATD__c=Date.newInstance(2300, 2, 17);
         insert new_shipment;                

    }

    @isTest
    public static void runTest(){
        
        Shipment__c sp = [Select Id,Vehicle__c,National_Operator__c from Shipment__c  where Name = 'SP-FN-21-980828'];	
        Operadores__c op = [Select Name, Account__c from Operadores__c where Name = 'Operador test'];
        Account acc = [Select Name,RecordType.Name from Account where Name = 'Cuenta carrier'];	

        Shipment__c spp = new Shipment__c();        
        spp.Liga_Cuenta_Espejo__c = 'Ejemplo1';
        spp.Usuario_Cuenta_Espejo__c = 'Ejemplo2';
        spp.Contrasena_Cuenta_Espejo__c =  'Ejemplo3';

        Vehicle__c v = new Vehicle__c();        
        v.Registration_Number__c = '001/ejemplo3';
        v.Numero_Poliza_Seguro__c =  'Si1';
        v.Poliza_Responsabilidad_civil__c =  'No2';
        v.Poliza_Seguro_Medio_Ambiente__c =  'Si3';    

        Operadores__c opp = new Operadores__c();        
        opp.Licvig_ope__c = true;
        opp.Fecha_de_vigencia_de_la_licencia__c  = Date.newInstance(2300, 2, 17);
        opp.Telfij_ope__c  = '123456789';

        Test.startTest();
            APX_Verificacion_Pak_Control.getRecord(sp.Id);
            APX_Verificacion_Pak_Control.cancelModal(sp.Id);        
            APX_Verificacion_Pak_Control.updateShipmentData(sp.Id,spp,v,opp,'Compa eje');
            APX_Verificacion_Pak_Control.findRecords('Operador', 'Operadores__c', op.Account__c, null);
            APX_Verificacion_Pak_Control.findRecords('Cuenta', 'Account', null, acc.RecordType.Name);
            APX_Verificacion_Pak_Control.updateShipmentObject(sp.Id, acc.Id);
            APX_Verificacion_Pak_Control.updateShipmentObject(sp.Id, sp.Vehicle__c);            
            APX_Verificacion_Pak_Control.updateShipmentObject(sp.Id, sp.National_Operator__c);
            APX_Verificacion_Pak_Control.recordChangeData(sp.Id, acc.Id);
            APX_Verificacion_Pak_Control.recordChangeData(sp.Id, sp.Vehicle__c);            
            APX_Verificacion_Pak_Control.recordChangeData(sp.Id, sp.National_Operator__c);
        Test.stopTest();

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
            accountT.Comgps_cta__c = 'Compañia ejemplo';
        
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
}