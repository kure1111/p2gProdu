@isTest
public class NEU_UpdateOutstandingBalanceAccount_test {
    
    @TestSetUp
    public static void makeData(){                       
       
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
        Catalogo_SAT__c trans1 = createCatalogoSat('Camión-Remolque-Test', 'T3S17','Configuracion Autotransporte');                                        
 
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
        Customer_Quote__c folio1 =createFolio('FN-22-000001',accCustomer.Id, catalogo.Id,false);		
        Test.startTest();              		        		                        	        	
        	Shipment__c sp1 = createShipment('SP-FN-22-000001',operador.Id, v.Id, accCarrier.Id, accCustomer.Id, userT.Id, 'Cuenta 1');
        	Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = sp1.Id, Name= 'test ship line');
        	insert shipline;        
        	Shipment_Fee_Line__c fe = createFee('001', sp1.Id);  
        	Invoice__c inv = new Invoice__c();
        	inv.Account__c = accCustomer.Id;
            inv.Import_Export_Quote_Order__c = folio1.Id;
            inv.Shipment__c = sp1.Id;
            inv.Account__c = accCustomer.Id;
            Date date1 = System.today().addDays(-2);
            Date date2 = System.today();
            inv.Payable_Before__c = date1;
            inv.Date_of_Invoice__c = date2;        	
        	inv.Amount_Received__c = 250;        	
            insert inv;
        	Invoice_Line__c il = new Invoice_Line__c();
            il.Invoice__c = inv.Id;
            il.Units__c = 10; 
            il.Unit_Price__c = 433.02;
            il.Amount__c= 433.02;
         	insert il;
        	Invoice_Item_Line__c invIL = new Invoice_Item_Line__c();
        	invIL.Name = 'invIL Test';
        	invIL.Invoice__c = inv.Id;
        	invIL.Shipment_Item_Line__c = shipline.Id;
        	insert invIL;
        	
        Test.stopTest();                                                 
                
    }
    
    @isTest
    public static void runTest(){
        
        Test.startTest();
            Id acc = [Select Id from Account where Name = 'Cuenta customer'].Id;
            //Customer_Quote__c folio = [Select Id, Name from Customer_Quote__c where Account_for__c =: acc];
            Shipment__c sp = [Select Id, Name,Reparto__c from Shipment__c where Name = 'SP-FN-22-000001'];
            Invoice__c inv = [Select Id, Name,VoBo_Lideres__c from Invoice__c where Shipment__c =: sp.Id];
        	Invoice_Line__c invL = [Select Id, Name, Units__c from Invoice_Line__c where  Invoice__c =: inv.Id];
        	Invoice_Item_Line__c invIL = [Select Id, Name from Invoice_Item_Line__c where Invoice__c =: inv.Id];
        	sp.Reparto__c = true;
        	update sp;
            inv.VoBo_Lideres__c = true;        
        	update inv;        	
        	invL.Units__c = 20;
        	update invL;        
        	delete inv;
        Test.stopTest();
        
        
    }
    
    
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
    
    
    
    
    
  // static testMethod void NEU_UpdateOutstandingBalanceAccount()
  // {
  //       Account acc = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() /*,Business_Area__c = 'Sales'*/);
  //       //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
  //       Account a = acc;
  //       a.Credit_Limit__c = 100;
  //       insert a;
        
  //       Customer_Quote__c importexportquote = new Customer_Quote__c( Account_for__c = a.Id,
  //       Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', 
  //       Destination_Address__c='test address');
  //       insert importexportquote;
        
  //       /*Customer_Quote__c importexportquote1 = new Customer_Quote__c( Account_for__c = a.Id,
  //       Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', 
  //       Destination_Address__c='test address');
  //       insert importexportquote1;*/
        
  //       Shipment__c ship = new Shipment__c();
  //       ship.Account_for__c = a.Id;
  //       ship.Freight_Mode__c = 'Sea';
  //      ship.name = 'SP-R-21-909089';
  //       ship.Service_Mode__c = 'Import';
  //       ship.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
  //       ship.Only_Warehouse_Service__c = true;
  //       insert ship;
        
  //       Invoice__c i_test = new Invoice__c();
  //       i_test.Import_Export_Quote_Order__c = importexportquote.Id;
  //       i_test.Shipment__c = ship.Id;
  //       i_test.Account__c = a.Id;
  //       Date date1 = System.today().addDays(-2);
  //       Date date2 = System.today();
  //       i_test.Payable_Before__c = date1;
  //       i_test.Date_of_Invoice__c = date2;
  //       insert i_test;
        
  //     /*  Invoice_Line__c il = new Invoice_Line__c();
  //       il.Invoice__c = i_test.Id;
  //       il.Units__c = 10; 
  //       il.Unit_Price__c = 433.02;
  //       il.Amount__c= 433.02;
  //       insert il;
  //       */
  //       /*Invoice__c i_test1 = new Invoice__c();
  //       i_test1.Import_Export_Quote_Order__c = importexportquote1.Id;
  //       i_test1.Account__c = a.Id;
  //       i_test1.Payable_Before__c = date1;
  //       i_test1.Date_of_Invoice__c = date2;
  //       insert i_test1;
        
  //       Invoice_Line__c il1 = new Invoice_Line__c();
  //       il1.Invoice__c = i_test.Id;
  //       il1.Units__c = 10; 
  //       il1.Unit_Price__c = 533.02;
  //       il1.Amount__c= 533.02;
  //       insert il1;*/
        
  //       //delete i_test1;
  // }
}