@isTest
public class NEU_OM_CQLShipFeeLineTest {
    //Clase test para las clases Apex NEU_OM_CQLPriceListYDiscount y NEU_OM_ShipFeeLinesPriceListYDiscount  
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

        Rol_Margen__c rm = TestDataFactory.createRolMargen('Director Regional');//	Director Regional,Director Comercial
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
        
        Test.startTest();              		        		                
             Customer_Quote__c folio1 = createFolio('FN-23-000001',accCustomer.Id, catalogo.Id);        	
        	 Shipment__c sp1 = createShipment('SP-FN-23-000001',operador.Id, v.Id, accCarrier.Id, accCustomer.Id, userT.Id, 'Cuenta 1');        
        Test.stopTest();       
    }
    
    @isTest
    public static void NEU_OM_CQLPriceListYDiscount_Test(){
        
		List<Customer_Quote__c> folios = [select Id,Name,Account_for__c,Freight_Mode__c,Service_Mode__c,Service_Type__c,Move_Type__c,Origin_Address__c,Destination_Address__c,
                                          ByPass__c,Impak_Request__c,Date_Pricing_responded__c,Clave_de_Unidad_de_Peso__c,CurrencyIsoCode,
                                          Total_Services_Std_Buy_Amount_number__c, Total_Services_Sell_Amount_number__c, Conversion_Rate_Date__c, Route__c,Purchase_Incoterm__c,
                                          Sales_Incoterm__c,Pickup_Cartage__c,Delivery_Cartage__c,Container_Type__c,Country_ofLoad__c,Country_ofDischarge__c,State_of_Load__c,
                                          State_of_Discharge__c,Site_of_Load__c,Site_of_Discharge__c, Account_for_Price_List__c,Catalog_Price_List__c                                          
                                          From Customer_Quote__c where Name = 'FN-23-000001'];
        
        /*List<Shipment__c> shipments = [Select Id, Name,Site_of_Load__c,Site_of_Discharge__c,Pickup_Cartage__c,Total_Weight_Kg__c,Total_Volume_m3__c,Purchase_Incoterm__c,Sales_Incoterm__c,
                                      Account_for__c,Carrier__c,N_Containers__c,Conversion_Rate_Date__c,Total_Services_Std_Buy_Amount__c,Total_Services_Std_Buy_Amount_number__c,
                                      Total_Services_Sell_Amount__c,Total_Services_Sell_Amount_number__c,Delivery_Cartage__c,Supplier_Account__c,Enable_Route_Options__c,Country_of_Discharge__c,
                                      Country_of_Load__c,Route__c,Container_Type__c,State_of_Discharge__c,State_of_Load__c,CurrencyIsoCode from Shipment__c where Name = 'SP-FN-22-000001'];*/
	    
        NEU_OM_CQLPriceListYDiscount folio = new NEU_OM_CQLPriceListYDiscount(new ApexPages.StandardController(folios[0]));
        //NEU_OM_ShipFeeLinesPriceListYDiscount shipment = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController(shipments[0]));
        //shipment.runtest();
    }
    
    @isTest
    public static void NEU_OM_ShipFeeLinesPriceListYDiscount(){
        
        List<Shipment__c> shipments = [Select Id, Name,Site_of_Load__c,Site_of_Discharge__c,Pickup_Cartage__c,Total_Weight_Kg__c,Total_Volume_m3__c,Purchase_Incoterm__c,Sales_Incoterm__c,
                                      Account_for__c,Carrier__c,N_Containers__c,Conversion_Rate_Date__c,Total_Services_Std_Buy_Amount__c,Total_Services_Std_Buy_Amount_number__c,
                                      Total_Services_Sell_Amount__c,Total_Services_Sell_Amount_number__c,Delivery_Cartage__c,Supplier_Account__c,Enable_Route_Options__c,Country_of_Discharge__c,
                                      Country_of_Load__c,Route__c,Container_Type__c,State_of_Discharge__c,State_of_Load__c,CurrencyIsoCode from Shipment__c where Name = 'SP-FN-23-000001'];
        NEU_OM_ShipFeeLinesPriceListYDiscount shipment = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController(shipments[0]));
        shipment.setnewcategory('Other Service Charges');
        shipment.getrecordtype();
        shipment.setnewcategory('Sea Freights');
        shipment.getrecordtype();
        shipment.setnewcategory('Drayages');                
        shipment.getrecordtype();
        shipment.chekeados = true;
        shipment.chekeados_ie = true;
        shipment.sum_buy_amount_ie_string = null;
        shipment.thousandSep = null;
        shipment.sum_sell_amount_ie_string = null;
        shipment.getshipment_filter();
        shipment.decimalSep = null	;        
        //shipment.sortList(0);
        shipment.change_ratio_category();        
        shipment.return_shipment();
        shipment.update_sites_countries();
        shipment.update_route();
        shipment.getSociedadSap();
        shipment.runtest();
    }
    
    public static Account createAccount(String name, String recordType){
        
        Account accountT = new Account();
        accountT.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        accountT.name = name;    
        accountT.Segment__c = 'Nuevo';

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

    public static Customer_Quote__c createFolio(String name, Id accT, Id catalogo){

        Customer_Quote__c folio = new Customer_Quote__c();
        folio.Name = name;
        folio.Account_for__c = accT;
        folio.Freight_Mode__c = 'Road';
        folio.Service_Mode__c = 'NATIONAL'; 
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