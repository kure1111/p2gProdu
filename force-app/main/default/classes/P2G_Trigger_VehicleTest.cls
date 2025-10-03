@isTest
public class P2G_Trigger_VehicleTest {
    @testSetup 
    static void createObjects(){                
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
       userT.SalesEmployer__c = '331';
       //userT.UserRoleId = [Select Id From UserRole Where Name = 'Director Comercial 2' Limit 1].Id;//
       insert userT;
	   //User userAlbert = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
       //user        
       User user2T = new User();
       user2T.FirstName = 'Pan';
       user2T.LastName = 'test';
       user2T.Email = 'PanTest@test.com';
       user2T.Username = 'PanTest@test.com.leoTest';
       user2T.Alias = 'PanTest';
       user2T.TimeZoneSidKey = 'America/Mexico_City';
       user2T.LocaleSidKey = 'es_MX';
       user2T.EmailEncodingKey = 'UTF-8';
       user2T.ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id;
       user2T.LanguageLocaleKey = 'es_MX';
	   userT.SalesEmployer__c = '331';
       insert user2T;

       Rol_Margen__c rl = TestDataFactory.createRolMargen('Director Comercial');
       //Account       
       Account accountT = new Account();
       accountT.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       accountT.name = 'Account test';
       accountT.Customer_Id__c = '58SQL1256';
       accountT.OwnerId = userT.Id;
       accountT.Venta_Sap__c = 'Contado'; 
       accountT.Credit_Limit__c = 6000000.00;  
       accountT.Brand_Name__c = 'Account Test';
       accountT.Phone = '123123213';
       accountT.Recuperado__c = true;
       accountT.Remote__c = true;
       accountT.Requiere_Orden_de_Compra__c = true;
       accountT.Rfcfis_cta__c = true;
       accountT.Specialist__c = true;
       accountT.Uso_Portal__c = true;  
       accountT.WebService__c = true;
       accountT.SCPVetado__c = true;  
       accountT.CreditoDisponible__c = 6000;
       accountT.Total_OV__c = 2000;
       accountT.Account_Executive_User__c = user2T.Id;
       accountT.Account_External_Follower_User__c = user2T.Id;
       accountT.ActiveSap__c = true;
       accountT.Segment__c = 'Nuevo';
       insert accountT; 
       
       //INSERTAR DOCUMENTO
       
        
      /////////////////////////////// Objetos para el historico de SP
      	Catalogo_SAT__c catalogo = new Catalogo_SAT__c();
        catalogo.Name = 'Caja de acero test';
        catalogo.Clave_SAT__c = 'Caja de acero test';
        catalogo.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Unidad Peso').getRecordTypeId();
        insert catalogo;            
        
        Catalogo_SAT__c direccion = new Catalogo_SAT__c();
        direccion.Name = '281998';
        direccion.Clave_SAT__c = '281998';
        //direccion.Clave_Relacion_SAT__c = 'Tlaxcala';
        direccion.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();
        //direccion.Municipio_Ref_CP__c = 'Nopalucan Tlax.';Codigo Postal        
        //direccion.Pais_RefCP__c = 'Mexico';
        insert direccion;
             
        /*
        Customer_Quote__c folio = new Customer_Quote__c();
        folio.Account_for__c = accountT.Id;
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
        folio.Margin_at_Destination_by_Default__c = 10;
        folio.Pricing_Executive__c = UserInfo.getUserId();
        insert folio;
        */        
        
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = accountT.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Codigo_Postal_CP__c = direccion.Id;
        address.referencia__c = 'Referencias test';
        address.Type__c = 'Shipping Address';
        insert address;
        
        Account_Address__c address2 = new Account_Address__c();
        address2.Name = 'Cln';
        address2.Account__c = accountT.id;
        address2.Address__c ='Conocida';
        address2.Address_Coordinates__Latitude__s=19.6248115;
        address2.Address_Coordinates__Longitude__s=-99.18076289999999;
        address2.Codigo_Postal_CP__c = direccion.Id;
        address2.referencia__c = 'Referencias test';
        address2.Type__c = 'Shipping Address';
        insert address2;

        Container_Type__c ctV = new Container_Type__c();
        ctV.Name = 'carro test';
        ctV.Type__c = 'Road';
        ctV.Height_cm__c = 250;
        ctV.Length_cm__c = 1450;
        ctV.Width_cm__c = 250;
        ctV.Cargo_Weight_Kg__c = 25000;
        insert ctV;        
        
        Catalogo_SAT__c trans = new Catalogo_SAT__c();        
        trans.Name  = 'Camión-Test';
        trans.Clave_SAT__c = 'T3S7';
        //UAT
        //trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Configuracion Autotrasporte').getRecordTypeId();//Prod:Configuracion Autotransporte  aut:Prod:Configuracion Autotrasporte      
        //PROD
        trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Configuracion Autotransporte').getRecordTypeId();//Prod:Configuracion Autotransporte  aut:Prod:Configuracion Autotrasporte      
        insert trans;
        
        Catalogo_SAT__c permiso = new Catalogo_SAT__c();        
        permiso.Name  = 'Permiso-Test';
        permiso.Clave_SAT__c = 'Pernis23';
        permiso.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Permiso').getRecordTypeId();        
        insert permiso;
        
        Catalogo_SAT__c confV = new Catalogo_SAT__c();        
        confV.Name  = 'ConfiguracionV-Test';
        confV.Clave_SAT__c = 'ConfiguracionV2123';        
        //UAT
        //confV.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Configuracion Autotrasporte').getRecordTypeId();//Prod:Configuracion Autotransporte  aut:Prod:Configuracion Autotrasporte        
        //PROD
        confV.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Configuracion Autotransporte').getRecordTypeId();//Prod:Configuracion Autotransporte  aut:Prod:Configuracion Autotrasporte        
        insert confV;
        
        Catalogo_SAT__c remolqueT = new Catalogo_SAT__c();        
        remolqueT.Name  = 'Caja-Test';
        remolqueT.Clave_SAT__c = 'Caja2123';
        remolqueT.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Remolque').getRecordTypeId();        
        insert remolqueT;
        
        
        Container_Type__c unidad = new Container_Type__c();
        unidad.name = 'Caja test';
        unidad.Type__c = 'Road';
        unidad.Height_cm__c = 250;
        unidad.Length_cm__c = 1590;
        unidad.Width_cm__c = 250;
        unidad.Cargo_Weight_Kg__c = 25000;
        unidad.Cargo_Volume_m3__c = 108.500;
        insert unidad;
                
        Caja_Remolque__c remolque1 = new Caja_Remolque__c();
        remolque1.name = 'cajatest';        
        remolque1.Tipo_Remolque__c = unidad.Id;
        remolque1.Tipo_Remolque__c = remolqueT.Id;
        remolque1.Color_Caja__c = 'Blanco';
        remolque1.Num_Placa_Caja__c = 'Tes1t115';
        insert remolque1;
        
        Caja_Remolque__c remolque2 = new Caja_Remolque__c();
        remolque2.name = 'caja2test';        
        remolque2.Tipo_Remolque__c = unidad.Id;
        remolque2.Tipo_Remolque__c = remolqueT.Id;
        remolque2.Color_Caja__c = 'Blanco';
        remolque2.Num_Placa_Caja__c = 'Tes2t215';
        insert remolque2;
                                      
        Account carrier = new Account();
        carrier.Name = 'Carrier Test';
        carrier.Brand_Name__c = 'Carrier Test';
        carrier.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        carrier.Direccion_Principal__c = address.Id;
        carrier.Segment__c = 'Nuevo';
        insert carrier;
        
        Account carrier2 = new Account();
        carrier2.Name = 'Carrier2 Test';
        carrier2.Brand_Name__c = 'Carrier Test';
        carrier2.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        carrier2.Direccion_Principal__c = address.Id;
        carrier2.Segment__c = 'Nuevo';
        insert carrier2;
                
        Account Forwarder = new Account();
        Forwarder.Name = 'Forwarder Test';
        Forwarder.Brand_Name__c = 'Forwarder Test';
        Forwarder.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();///UAT:Supplier Owner or Lessee of Vehicule  /  Produ:Supply Chain Partner
        Forwarder.Direccion_Principal__c = address2.Id;
        Forwarder.Segment__c = 'Nuevo';
        insert Forwarder;
        
        
        Catalogo_SAT__c cp = new Catalogo_SAT__c();        
        cp.Name  = '980828';
        cp.Clave_SAT__c = '980828';
        cp.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert cp;
        
		Operadores__c operador1 = new Operadores__c();
		operador1.Account__c = carrier.Id;		
        operador1.Name = 'Operador test';
        operador1.Cel_ope__c = '123456789';
        operador1.Telfij_ope__c = '123123123';
        operador1.Medprev_ope__c = '123123';
        operador1.Proovedor_validado__c = true;
        operador1.Validado__c = true;
        //operador1.Telefono_Validado__c = true;
        operador1.Operador_Validado__c = true;
        operador1.Codigo_Postal_Operador__c = cp.Id;
        operador1.RFC_Operador__c = 'TestRFC';
        operador1.Numlicvig_ope__c = '123135';
		insert operador1;
        
        Operadores__c operador2 = new Operadores__c();
		operador2.Account__c = carrier.Id;		
        operador2.Name = 'Operador test';
        operador2.Cel_ope__c = '123456789';
        operador2.Telfij_ope__c = '123123123';
        operador2.Medprev_ope__c = '123123';
        operador2.Proovedor_validado__c = true;
        operador2.Validado__c = true;
        //operador2.Telefono_Validado__c = true;
        operador2.Operador_Validado__c = true;
        operador2.RFC_Operador__c = 'TestRFC';    
        operador2.Numlicvig_ope__c = '123135';
        operador2.Codigo_Postal_Operador__c = cp.Id;
		insert operador2;                        
        
        Country__c country = new Country__c(
			Name = 'Mexico',
			ISO_Code_2c__c = 'MX',
			ISO_Code__c = 'MEX'
		);
		insert country;
        
        State__c state = new State__c(
			Name = 'Sonora',
			ISO_Code_2c__c = 'SO',
			country__c = country.Id
		);
		insert state;
        
        Location__c location = new Location__c(
			Name = 'Hermosillo',
			state__c = state.Id,
			country__c = country.Id
		);
		insert location;
		
        
        Country__c country2 = new Country__c(
			Name = 'Mexico T',
			ISO_Code_2c__c = 'MX',
			ISO_Code__c = 'MEX'
		);
		insert country2;
        
        State__c state2 = new State__c(
			Name = 'Sonora T',
			ISO_Code_2c__c = 'SO',
			country__c = country.Id//country.Id
		);
		insert state2;
        
        Location__c location2 = new Location__c(
			Name = 'Hermosillo T',
			state__c = state2.Id,//state.Id
			country__c = country.Id//country.Id
		);
		insert location2;
                             		
		Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(
			Country_of_Load__c = country.Id,
			Country_of_Discharge__c = country.Id,
			Port_Airport_of_Load__c = location.Id,
			Port_Airport_of_Discharge__c = location.Id,
			State_of_Load__c = state.Id,
			State_of_Discharge__c = state.Id
		);
		insert route;
                        
        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = 'SP-FI-21-1234567';                      
        new_shipment.Freight_Mode__c = 'Road';
        new_shipment.Account_for__c=accountT.Id;             
        new_shipment.Service_Mode__c = 'IMPORT';
        new_shipment.Service_Type__c =  'LTL';
        new_shipment.Move_Type__c = 'Door to Door';        
        new_shipment.Only_Warehouse_Service__c = false;                    
        new_shipment.Operation_Executive__c = userT.Id; 
        new_shipment.Destination_Address__c = 'Hola';
        new_shipment.Origin_Address__c = 'Hola';
        new_shipment.Account_Origin_Address__c = address.id;
        new_shipment.Account_Destination_Address__c = address2.id;          
        new_shipment.Shipment_Status_Plann__c = 'Pending';
        //new_shipment.Carrier__c = carrier.Id;
        //new_shipment.National_Operator__c = operador1.Id;
        //new_shipment.Operator_2__c = operador2.Id;
        //new_shipment.Vehicle__c = vehicle.Id;
        new_shipment.Traslado_Ingreso__c = 'Traslado';
        new_shipment.Country_of_Load__c = country.Id;
        new_shipment.State_of_Load__c = state.Id;
        new_shipment.Site_of_Load__c = location.Id;
        new_shipment.Country_of_Discharge__c = country.Id;
        new_shipment.State_of_Discharge__c = state.Id;
        new_shipment.Site_of_Discharge__c = location.Id;
        new_shipment.ETA_Point_of_Discharge__c = Date.newInstance(2300, 2, 17);
        new_shipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(18, 30, 2, 20);
        new_shipment.ETD_from_Point_of_Load__c = Date.newInstance(2300, 2, 19);
        new_shipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(18, 30, 2, 20);
        new_shipment.kms__c = 2;
        new_shipment.ATA__c =Date.newInstance(2300, 2, 17);
        new_shipment.ATD__c=Date.newInstance(2300, 2, 17);
        //new_shipment.Forwarder__c = Forwarder.Id;
        new_shipment.CurrencyIsoCode = 'MXN';
        new_shipment.Conversion_Rate_Date__c = Date.today();
        insert new_shipment;

        
        Catalogo_SAT__c embalaje = new Catalogo_SAT__c();
        embalaje.Name = 'Envases y embalajes Test';
        embalaje.Clave_SAT__c = 'Envases y embalajes Test';         
        embalaje.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Embalaje').getRecordTypeId();
        insert embalaje;
        
        
        Catalogo_SAT__c municion = new Catalogo_SAT__c();
        municion.Name = 'MUNICIONES INCENDIARIAS Test';
        municion.Clave_SAT__c = 'MUNICIONES INCENDIARIAS Test'; 
        municion.Material_PeligrosoCP__c = true;
        municion.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Material Peligroso').getRecordTypeId();
        insert municion;
        
        Catalogo_SAT__c servicio = new Catalogo_SAT__c();
        servicio.Name = 'Papel Test';
        servicio.Clave_SAT__c = '15975361'; 
        servicio.Material_PeligrosoCP__c = true;
        servicio.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Productos y Servicios cP').getRecordTypeId();
        insert servicio;
        
        Catalogo_SAT__c cajasCon = new Catalogo_SAT__c();
        cajasCon.Name = 'cajas conexion Test';
        cajasCon.Clave_SAT__c = '01264588';        
        cajasCon.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Fraccion Arancelaria').getRecordTypeId();
        insert cajasCon;
        
        
        Container_Type__c ct = new Container_Type__c();
        ct.Name = 'test';
        insert ct;

        Shipment_Line__c cl = new Shipment_Line__c();
        cl.Name = '001';
        cl.Shipment__c = new_shipment.Id;
        cl.Container_Type__c = ct.Id;
        cl.Units_Shipped__c = 10;
        cl.Clave_de_Servicio__c = servicio.Id;
        cl.pedimento__c = 'Test pedimiento';
        cl.Peso_Neto__c = 10;
        cl.Units_Shipped__c = 2;
        cl.Shipping_Weight_Kg__c = 2;
        cl.CP_Fraccion_Arancelaria__c = cajasCon.Id;
        cl.Material_Peligroso__c = municion.Id;
        cl.Embalaje__c = embalaje.Id;
        insert cl;		                
    }
    @isTest
    static void NEU_Update_Vehicle_Address(){
        Account carrier= [SELECT Id FROM Account WHERE RecordType.Name='Supply Chain Partner' LIMIT 1];
        Catalogo_SAT__c permiso= [SELECT Id FROM Catalogo_SAT__c WHERE RecordType.Name='Tipo de Permiso' LIMIT 1];        
        //UAT
        //Catalogo_SAT__c trans=[SELECT Id FROM Catalogo_SAT__c WHERE RecordType.Name='Configuracion Autotrasporte' LIMIT 1];        
        //PROD
        Catalogo_SAT__c trans=[SELECT Id FROM Catalogo_SAT__c WHERE RecordType.Name='Configuracion Autotransporte' LIMIT 1];
        
        Caja_Remolque__c remolque1 = [SELECT Id FROM Caja_Remolque__c WHERE Name = 'cajatest' LIMIT 1];
        
        Caja_Remolque__c remolque2 = [SELECT Id FROM Caja_Remolque__c WHERE Name = 'caja2test' LIMIT 1];
        
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'test';
        vehicle.Last_Location__Longitude__s = 41.40338;
        vehicle.Last_Location__Latitude__s = 2.17403;
        vehicle.Account_for_SCP__c = carrier.id;
        vehicle.Vehiculo_Validado__c = true;
        //vehicle.Container_Type__c = ctV.Id;
        vehicle.Num_Placa_Tracto__c = 'Test123';
        vehicle.Nombre_Aseguradora__c = 'Test aseguradora';
        vehicle.Numero_Poliza_Seguro__c = '123123';
        vehicle.Asegura_Responsabilidad_Civil__c = 'Test aseguradora';
        vehicle.Poliza_Responsabilidad_civil__c = 'Test poliza';
        vehicle.Prima_Seguro__c = '100';
        vehicle.Numero_de_Permiso_SCT__c = 'Test numero';
        vehicle.Tipo_de_Permiso__c = permiso.Id;
        vehicle.Configuracion_Vehicularcat__c = trans.Id;
        vehicle.Caja_Remolque__c = remolque1.Id;
        vehicle.Caja_Remolque_2__c = remolque2.Id;
        insert vehicle;       
        vehicle.Last_Location__Longitude__s = 40.40338;
        vehicle.Last_Location__Latitude__s = 3.17403;
        update vehicle;
    }

    
        
}