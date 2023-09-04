@isTest
public with sharing class APX_Debit_Note_Test {
    
    private class createException extends Exception {}
    /*@TestSetup
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

        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen('Director Comercial');
        //Account     
        Account accCustomer = createAccount('Cuenta customer', 'Customer');
        insert accCustomer;

        Account accCarrier = createAccount('Cuenta carrier', 'Supply Chain Partner');        
        insert accCarrier;
        
        Account accCarrier1 = createAccount('Cuenta carrier1', 'Supply Chain Partner');        
        insert accCarrier1;

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
        Catalogo_SAT__c trans1 = createCatalogoSat('Camión-Remolque-Test', 'T3S17','Configuracion Autotrasporte');                                        
 
        //RecordType: AUT y  produccion : Tipo de Permiso     
        Catalogo_SAT__c trans2 = createCatalogoSat('Autotransporte Federal Test' , 'T3S172','Tipo de Permiso');                       


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
        
        Catalogo_SAT__c catalogo = createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso');
        Catalogo_SAT__c catalogo1 = createCatalogoSat('Caja de acero test11' , 'TCA125','Unidad Peso');
        Customer_Quote__c folio1 =createFolio('CE-22-000001',accCustomer.Id, catalogo.Id,false);
		Customer_Quote__c folio2 =createFolio('CE-22-000002',accCustomer.Id, catalogo1.Id,true);        
        Test.startTest();              		        		                        	        	
        	Shipment__c sp1 = createShipment('SP-CE-22-000001',operador.Id, v.Id, accCarrier.Id, accCustomer.Id, userT.Id, 'Cuenta 1');
            Shipment__c sp2 = createShipment('SP-FN-22-000002',operador.Id, v.Id, accCarrier.Id, accCustomer.Id, userT.Id, 'Cuenta 2');
            Shipment__c sp3 = createShipment('SP-FN-22-000003',operador.Id, v.Id, accCarrier.Id, accCustomer.Id, userT.Id, 'Cuenta 3');
            Shipment__c sp4 = createShipment('SP-FN-22-000004',operador.Id, v.Id, accCarrier.Id, accCustomer.Id, userT.Id, 'Cuenta 4');
            Shipment__c sp5 = createShipment('SP-FN-22-000005',operador.Id, v.Id, accCarrier.Id, accCustomer.Id, userT.Id, 'Cuenta 5');
        	Shipment__c sp6 = createShipment('SP-FN-22-000006',operador.Id, v.Id, accCarrier.Id, accCustomer.Id, userT.Id, 'Cuenta 6');        	
        	//folio1.Customer_Reference_Form__c = folio2.Id;
        	//folio1.Last_Shipment__c = sp1.Id;
        	//update folio1;
        Test.stopTest();  
        
        Debit_Note__c dn = new Debit_Note__c();
        dn.Account_for__c = sp1.Account_for__c;
        dn.Shipment_Number_1__c = sp1.Id;		
        insert dn;
        
        Debit_Note__c dn1 = new Debit_Note__c();
        dn1.Account_for__c = sp1.Account_for__c;
        dn1.Shipment_Number_1__c = sp1.Id;
        dn1.Shipment_Number_2__c = sp2.Id;
        dn1.Shipment_Number_3__c = sp3.Id;
        dn1.Shipment_Number_4__c = sp4.Id;
        dn1.Shipment_Number_5__c = sp5.Id;
        insert dn1;
        
        Debit_Note__c dn2 = new Debit_Note__c();
        dn2.Account_for__c = sp1.Account_for__c;
        dn2.Shipment_Number_1__c = sp6.Id;		
        insert dn2;
                        
        Shipment_Fee_Line__c fe = createFee('001', sp1.Id);       
    }*/


    @isTest
    public static void runTest1(){

        /*Id catalogo = [Select Id from Catalogo_SAT__c where Name = 'Caja de acero test'].Id;
        Id acc  = [Select Id, Name from Account where Name ='Cuenta customer'].Id;
        Customer_Quote__c folio1;
        Shipment__c  sp1 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 1'];
                   
              
        Shipment__c sp2 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 2'];
        Shipment__c sp3 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 3'];
        Shipment__c sp4 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 4'];
        Shipment__c sp5 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 5'];
        Shipment__c sp6 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 6'];
        Debit_Note__c dn = [Select Id from Debit_Note__c where Shipment_Number_1__c =:sp1.Id limit 1];
		Debit_Note__c dn2 = [Select Id from Debit_Note__c where Shipment_Number_2__c =:sp2.Id];
		Debit_Note__c dn3 = [Select Id from Debit_Note__c where Shipment_Number_1__c =:sp6.Id];               
        List<String> sps = new List<String>{sp1.Id/*,sp2.Id,sp3.Id,sp4.Id,sp5.Id};*/
        //List<Id> spsL = new List<Id>{sp1.Id,sp2.Id,sp3.Id,sp4.Id,sp5.Id};
        

        Test.startTest();        
        	APX_Debit_Note.testRun();
            /*try{             
                system.debug('folio sp1: ' + sp1.ShipmentService__c);
                sp1.Shipment_Status_Plann__c = 'Closed';        	
                sp2.Shipment_Status_Plann__c = 'Closed';        	                 	
                update sp1;
                update sp2;
                APX_Debit_Note.getInvoice(sp1.Id);
                APX_Debit_Note.getDebitNote(sp1.Id);
                APX_Debit_Note.getDebitNoteByList(sps);
                APX_Debit_Note.updateDebitNote(dn.Id,sp1.Id);
                APX_Debit_Note.updateDebitNote(dn.Id,sp1.Id);
                APX_Debit_Note.updateDebitNote(dn.Id,sp1.Id);
                APX_Debit_Note.updateDebitNote(dn.Id,sp1.Id);
                APX_Debit_Note.updateDebitNote(dn.Id,sp1.Id);         	
                APX_Debit_Note.createDebitNote(sp1.Id);
                APX_Debit_Note.changeShipment(dn.Id,sp1.Id);
                APX_Debit_Note.changeShipment(dn.Id,sp1.Id);
                APX_Debit_Note.changeShipment(dn.Id,sp1.Id);
                APX_Debit_Note.changeShipment(dn.Id,sp1.Id);
                APX_Debit_Note.changeShipment(dn.Id,sp1.Id);
                APX_Debit_Note.updateDebitNoteSearch(dn.Id,sp1.Id);
                APX_Debit_Note.updateDebitNoteSearch(dn.Id,sp1.Id);
                APX_Debit_Note.updateDebitNoteSearch(dn.Id,sp1.Id);
                APX_Debit_Note.updateDebitNoteSearch(dn.Id,sp1.Id);
                APX_Debit_Note.getShipmentsAndLines(spsL,sp6.Id);        	
                APX_Debit_Note.getShipmentsAndLines(spsL,dn2.Id);   
                APX_Debit_Note.getDebitNoteAndCreateInvoice(sp1.Id);
                APX_Debit_Note.createAndAssignDebitNote(spsL, dn2.Id);
                APX_Debit_Note.AssignDebitNoteShipmentsOmitted(dn3.Id, spsL);      
                APX_Debit_Note.getDNandSPtoMonitor(dn.Id);
                APX_Debit_Note.getDNTonMonitor(sp1.Id);              
                //APX_Debit_Note.testRun();
                throw new createException('Script-thrown exception');
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Script-thrown exception') ? true : false;
                if(expectedExceptionThrown){
                    System.AssertEquals(expectedExceptionThrown, true);   
                }else{
                    System.AssertEquals(expectedExceptionThrown, false);
                } 
            }*/   
        Test.stopTest();

    }
    
    //@isTest
    //public static void runTest2(){
        /*Id acc  = [Select Id, Name from Account where Name ='Cuenta customer'].Id;        
        Shipment__c sp1 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 1'];     
        Shipment__c sp2 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 2'];    
        Shipment__c sp6 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 6'];
        Debit_Note__c dn = [Select Id from Debit_Note__c where Shipment_Number_1__c =:sp1.Id limit 1];        
        system.debug('DN: '+ dn.Id);
        List<Id> sps = new List<String>{sp1.Id};
            List<Shipment__c> spL = new List<Shipment__c>{sp1};
                List<Debit_Note__c> dns = new List<Debit_Note__c>();
        dns.add(dn);
        
        
        Test.startTest();           	                        
        List<Customer_Quote__c> folios1 = [select Id, Name from Customer_Quote__c where Name like '%CE-22%'];
        List<Customer_Quote__c> folios2 = folios1.clone();
        sp1.Shipment_Status_Plann__c = 'Closed';        	
        update sp1;      
        //APX_Debit_Note.getData(dn.Id);
        APX_Debit_Note.createInvoice(sps); 
        APX_Debit_Note.showInvoicesAndLines(sps);
        String fileName = APX_Debit_Note.sendPdf(dn.Id);
        Test.setMock(HttpCalloutMock.class, new DebitNoteMock());
        APX_Debit_Note.uploadFiles(sps, fileName);        
        APX_Debit_Note.UpdateShipmentInDebitnote(spL);     			
        APX_Debit_Note apxD = new APX_Debit_Note();
        apxD.recordId = dn.Id;      
        apxD.record = null;
        Debit_Note__c dn2 = APX_Debit_Note.createDNSP(sp6.Id);*/
        //Debit_Note__c dn1 = APX_Debit_Note.createDNSP(sp6.Id);
        //Debit_Note__c dn3 = APX_Debit_Note.createDNSP(sp6.Id);
        //Debit_Note__c dn4 = APX_Debit_Note.createDNSP(sp6.Id);
        //Debit_Note__c dn5 = APX_Debit_Note.createDNSP(sp6.Id);
        //Debit_Note__c dn6 = APX_Debit_Note.createDNSP(sp6.Id);
        //List<Id> dns1 = new List<Id>{dn1.Id,dn2.Id,dn3.Id};//,dn4.Id,dn5.Id,dn6.Id};
        //APX_Debit_Note.removeAndAssigneDebitNote(dn1.Id, dns1, sp6.Id);
        //APX_Debit_Note.IsDebitNoteSP(sp6.Id, dn1.Id);
        //APX_Debit_Note.asignacionDNaFolio(folios1,folios2);
        
        /*try{             
            Id acc  = [Select Id, Name from Account where Name ='Cuenta customer'].Id;        
            Shipment__c sp1 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 1'];     
            Shipment__c sp2 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 2'];    
            Shipment__c sp6 = [Select Id, Name,ShipmentService__c from Shipment__c where Liga_Cuenta_Espejo__c = 'Cuenta 6'];
            Debit_Note__c dn = [Select Id from Debit_Note__c where Shipment_Number_1__c =:sp1.Id limit 1];        
            system.debug('DN: '+ dn.Id);
            List<Id> sps = new List<String>{sp1.Id};
            List<Shipment__c> spL = new List<Shipment__c>{sp1};
            List<Debit_Note__c> dns = new List<Debit_Note__c>();
            dns.add(dn);
                
               
            List<Customer_Quote__c> folios1 = [select Id, Name from Customer_Quote__c where Name like '%FN-22%'];
            List<Customer_Quote__c> folios2 = folios1.clone();
            sp1.Shipment_Status_Plann__c = 'Closed';        	
            update sp1;      
            APX_Debit_Note.getData(dn.Id);
            APX_Debit_Note.createInvoice(sps); 
            APX_Debit_Note.showInvoicesAndLines(sps);
            String fileName = APX_Debit_Note.sendPdf(dn.Id);
            Test.setMock(HttpCalloutMock.class, new DebitNoteMock());
            APX_Debit_Note.uploadFiles(sps, fileName);        
            APX_Debit_Note.UpdateShipmentInDebitnote(spL);     			
            APX_Debit_Note apxD = new APX_Debit_Note();
            apxD.recordId = dn.Id;      
            apxD.record = null;
            Debit_Note__c dn2 = APX_Debit_Note.createDNSP(sp6.Id);
            Debit_Note__c dn1 = APX_Debit_Note.createDNSP(sp6.Id);
            Debit_Note__c dn3 = APX_Debit_Note.createDNSP(sp6.Id);
            Debit_Note__c dn4 = APX_Debit_Note.createDNSP(sp6.Id);
            Debit_Note__c dn5 = APX_Debit_Note.createDNSP(sp6.Id);
            Debit_Note__c dn6 = APX_Debit_Note.createDNSP(sp6.Id);
            List<Id> dns1 = new List<Id>{dn1.Id,dn2.Id,dn3.Id,dn4.Id,dn5.Id,dn6.Id};
            APX_Debit_Note.removeAndAssigneDebitNote(dn1.Id, dns1, sp6.Id);
            APX_Debit_Note.IsDebitNoteSP(sp6.Id, dn1.Id);
            APX_Debit_Note.asignacionDNaFolio(folios1,folios2);
            throw new createException('Script-thrown exception');
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Script-thrown exception') ? true : false;
            if(expectedExceptionThrown){
                System.AssertEquals(expectedExceptionThrown, true);   
            }else{
                System.AssertEquals(expectedExceptionThrown, false);
            } 
        }*/        	       
        //APX_Debit_Note.getData(dn.Id);
        ///Debit_Note__c dn2 = APX_Debit_Note.createDNSP(sp1.Id);        	
        //dns.add(dn2);
        //APX_Debit_Note.createInvoiceDN(dn2.Id, dns, sp1.Id);          	
        //APX_Debit_Note.getData(dn.Id); 101        	
        //APX_Debit_Note.validandoDebitNote(dn);
        //APX_Debit_Note.sendPdf(sp1.Id);
        //APX_Debit_Note.uploadFiles(sps,'testDN.pdf');        
		//Test.stopTest();        
    //}
    
   
    public static Shipment_Fee_Line__c createFee(String name, Id sp){

        Shipment_Fee_Line__c sfl = new Shipment_Fee_Line__c();
        sfl.Shipment__c = sp;
        sfl.Units__c = 1;
        sfl.Shipment_Sell_Price__c = 10;
        sfl.Name = name;
        insert sfl;
        return sfl;
    }
    
    public static Account createAccount(String name, String recordType){
        
        Account accountT = new Account();
        accountT.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        accountT.name = name;   
        accountT.ActiveSap__c = true;
        accountT.Credit_Terms__c = '1 Día';

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

    public static Customer_Quote__c createFolio(String name, Id accT, Id catalogo, boolean service){

        Customer_Quote__c folio = new Customer_Quote__c();
        folio.Name = name;
        folio.Account_for__c = accT;
        folio.Freight_Mode__c = 'Road';
        folio.Service_Mode__c = (service ? 'IMPORT' :'NATIONAL'); 
        folio.Service_Type__c =  'FTL';
        folio.Move_Type__c = 'Door to Door';
        folio.Origin_Address__c = 'Address Test'; 
        folio.Destination_Address__c = 'Address Test';
        folio.ByPass__c = true;
        folio.Impak_Request__c = true;
        folio.Date_Pricing_responded__c = System.today();
        folio.Clave_de_Unidad_de_Peso__c = catalogo;     
        folio.Pricing_Executive__c=userinfo.getUserId();
        insert folio;      

        return folio;
    }

    public static Shipment__c createShipment (String name, Id operador, Id vehiculo, Id acccarrier, Id accCustom, Id userT,String espejo){

        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = name;  
        new_shipment.Traslado_Ingreso__c = 'Traslado';
        new_shipment.VERIFY_PAK_CONTROL__c = true;
        new_shipment.Shipment_Status_Plann__c = 'In Progress';         
        new_shipment.Freight_Mode__c = 'Road';
        new_shipment.Account_for__c= accCustom;             
        new_shipment.Service_Mode__c = 'NATIONAL';
        new_shipment.Service_Type__c =  'FTL';
        new_shipment.Move_Type__c = 'Door to Door';        
        new_shipment.Only_Warehouse_Service__c = false;                    
        new_shipment.Operation_Executive__c = userT;       
        new_shipment.Carrier__c = acccarrier; 
        new_shipment.National_Operator__c = operador;
        new_shipment.Vehicle__c = vehiculo;
        new_shipment.Liga_Cuenta_Espejo__c = espejo;
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
        return new_shipment;
    }

    public static Catalogo_SAT__c createCatalogoSat(String name, String claveSat, String RecordType){

        Catalogo_SAT__c trans = new Catalogo_SAT__c();        
        trans.Name  = name;
        trans.Clave_SAT__c = claveSat;
        trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get(RecordType).getRecordTypeId();     
        insert trans;   
        return trans;        
    }    
}