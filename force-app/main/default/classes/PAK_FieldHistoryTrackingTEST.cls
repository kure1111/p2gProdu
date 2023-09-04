@isTest
public class PAK_FieldHistoryTrackingTEST {
    
    /**
* @author		Israel Mar
* @version 		1.0
* @date 		28/04/22
* @description	Clase TEST de la clase Apex: 
* "PAK_HistoryAccountHelper"
* "PAK_OperatorHistoryHelper"
* "PAK_OrderHistoryHelper"
* "PAK_IESL_HistoryHelper"
* "PAK_VehicleHistoryHelper"
* "PAK_ServiceRateHistoryHelper"
* "PAK_IECL_HistoryHelper"
* "PAK_IEQO_HistoryHelper"
* "PAK_ShipmentHistoryHelper"
* "PAK_InvoiceHistoryHelper"
* "PAK_ShipmentCL_History"
* "PAK_ShipmentSL_HistoryHelper"
*/    
    
   @testSetup static void createObjects() 
    {              
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
       //userT.UserRoleId = [Select Id From UserRole Where Name like 'COMERCIAL%' Limit 1].Id;//
       insert userT;

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
        remolque1.name = 'caja test';        
        remolque1.Tipo_Remolque__c = unidad.Id;
        remolque1.Tipo_Remolque__c = remolqueT.Id;
        remolque1.Color_Caja__c = 'Blanco';
        remolque1.Num_Placa_Caja__c = 'Tes1t115';
        insert remolque1;
        
        Caja_Remolque__c remolque2 = new Caja_Remolque__c();
        remolque2.name = 'caja2 test';        
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
        vehicle.Prima_Seguro__c = 'Test prima';
        vehicle.Numero_de_Permiso_SCT__c = 'Test numero';
        vehicle.Tipo_de_Permiso__c = permiso.Id;
        vehicle.Configuracion_Vehicularcat__c = trans.Id;
        vehicle.Caja_Remolque__c = remolque1.Id;
        vehicle.Caja_Remolque_2__c = remolque2.Id;
        insert vehicle;        
        
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
        new_shipment.Service_Mode__c = 'NATIONAL';
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
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen('Director Comercial');
        Test.startTest();
         	folio.Last_Shipment__c = new_shipment.Id;
        	update folio;
        /*try{
           
        }catch(Exception e){
            System.assert(e.getMessage().contains('Usuario con rol no autorizado'));
        }*/
        Test.stopTest();
        
   }
    

   public static testMethod void updateAccount(){

        List<Account> getAccount = [Select Id, Name, Customer_Id__c, OwnerId, Venta_Sap__c, Credit_Limit__c,Brand_Name__c, Phone,
                                    Recuperado__c, Remote__c, Requiere_Orden_de_Compra__c, Rfcfis_cta__c, Specialist__c, Uso_Portal__c, WebService__c,
                                    SCPVetado__c, AccountSource, Actcons_cta__c, ActiveSap__c, Authorized_Credit__c, Capacitacion_Acuses__c, Capacitacion_Control_Room__c,
                                    Capacitacion_Operaciones__c, Capacitacion_Portal__c, Carban_cta__c, Comdom_cta__c, Convfirm_cta__c, CT_Pat__c, Cuenta_con_instrumentos_de_movimiento_de__c,
                                    Cuenta_con_SUA_Sistema_nico_de_Autodet__c, Encuesta_SCP__c,Formalt_cta__c,Factvig_cta__c,Estatus_de_cliente__c, Fotext_cta__c, Gps_cta__c, Inerep_cta__c,
                                    Negociacion_de_tarifas__c, Recuperado_SAP__c,Potencializacion__c, Proovedor_validado__c, Prospeccion__c, Prospeccion_Impak__c, Polseg_cta__c,Reasign_Dir__c,
                                    Reasign_Dir_SAP__c, Phone_test__c, Order_to_Cash__c, IDproveesap_cta__c, IVA_16__c, IVA_4__c, Key_Account__c,Folio_Mkt__c,Folio_Mkt_Ok2_del__c,
                                    Factoraje_2__c, Evidencia_de_Visita_del_Vendedor__c, Enviar_encuesta__c, Enviado_SAP__c, SCPCuenta_Espejo__c, Cliente_internacional__c, Cliente_con_cita__c,
                                    Ciclo_de_Cobranza_Corto__c, Check_test__c, Acta_Constitutiva_Poder_Rep_Legal__c 
                                    from Account where name = 'Account test' limit 1];       
       
        Account accountFind = getAccount.get(0);
        accountFind.name = 'Cuenta test';
       	accountFind.Venta_Sap__c = 'Contado';
       	accountFind.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        accountFind.OwnerId = [Select Id from User where Name = 'Pan test'].Id;
        //accountFind.Venta_Sap__c = 'Credito'; 
        accountFind.Credit_Limit__c = 3000000.00;  
        accountFind.Brand_Name__c = 'Account1 Test';
        accountFind.Phone = '125987';
        accountFind.Recuperado__c = false;
        accountFind.Remote__c = false;
        accountFind.Requiere_Orden_de_Compra__c = false;
        accountFind.Rfcfis_cta__c = false;
        accountFind.Specialist__c = false;
        accountFind.Uso_Portal__c = false;  
        accountFind.WebService__c = false;
        accountFind.SCPVetado__c = false;
		accountFind.AccountSource = 'Other';
        accountFind.Actcons_cta__c  = true;
       	accountFind.ActiveSap__c = true;
        accountFind.Authorized_Credit__c = true;
        accountFind.Capacitacion_Acuses__c = true;
        accountFind.Capacitacion_Control_Room__c = true;
        accountFind.Capacitacion_Operaciones__c = true;
        accountFind.Capacitacion_Portal__c = true;
        accountFind.Carban_cta__c = true;
       	accountFind.Comdom_cta__c = true;
       	accountFind.Convfirm_cta__c = true;
       	accountFind.CT_Pat__c = true;
       	accountFind.Cuenta_con_instrumentos_de_movimiento_de__c = true;
       	accountFind.Cuenta_con_SUA_Sistema_nico_de_Autodet__c = true;
       	accountFind.Encuesta_SCP__c = true;
       	accountFind.Estatus_de_cliente__c = 'Nuevo';
       	accountFind.Factvig_cta__c = true;
       	accountFind.Formalt_cta__c = true;
       	accountFind.Fotext_cta__c = true;
       	accountFind.Gps_cta__c = true;
       	accountFind.Inerep_cta__c = true;
       	accountFind.Negociacion_de_tarifas__c = true;
       	accountFind.Opinion_de_cumplimiento_ante_el_SAT__c = true;
        accountFind.Recuperado_SAP__c = True;
        accountFind.Potencializacion__c = True;
        accountFind.Proovedor_validado__c = True;
        accountFind.Prospeccion__c = True;
        accountFind.Prospeccion_Impak__c = True;
        accountFind.Polseg_cta__c = True;
        accountFind.Reasign_Dir__c = True;
        accountFind.Reasign_Dir_SAP__c = True;
       	accountFind.Phone_test__c = '1234567890';
       	accountFind.Order_to_Cash__c = true;
       	accountFind.IDproveesap_cta__c = 'G2';        
        accountFind.IVA_16__c = True;
        accountFind.IVA_4__c = True;
        accountFind.Key_Account__c = True;
        accountFind.Folio_Mkt__c = 'AABBCC';
        accountFind.Folio_Mkt_Ok2_del__c = 'DDEEFF';
        accountFind.Factoraje_2__c = True;
        accountFind.Evidencia_de_Visita_del_Vendedor__c = True;
        accountFind.Enviar_encuesta__c = True;
        accountFind.Enviado_SAP__c = True;
        accountFind.SCPCuenta_Espejo__c = True;
        accountFind.Cliente_internacional__c = True;
        accountFind.Cliente_con_cita__c = True;
        accountFind.Ciclo_de_Cobranza_Corto__c = True;
        accountFind.Check_test__c = True;
        accountFind.Acta_Constitutiva_Poder_Rep_Legal__c = True;
       
        test.startTest();
        update accountFind;
        test.stopTest();
    
   }     
    
    
   public static testMethod void updateShipment(){
                
        List<Shipment__c> shipFound = [SELECT Id FROM Shipment__c  WHERE name='SP-FI-21-1234567'];
       	Shipment__c ship = shipFound.get(0);
       
       	//ship.Name = 'SP-FI-21-987654321';
        ship.Acuse_en_SAP__c = True;
        ship.VERIFY_ACUSE_SAP__c = True;
        ship.Sell_Amount_Bloq__c = True;
        ship.AUTORIZADO_FP_FO__c = True;
        ship.AUTORIZAR_GASTO_EXTRA__c = True;
        ship.Cargo_insurance__c = True;
        ship.Cliente_con_cita2__c= True;
        ship.N_Containers__c = 2;
        ship.Conversion_Rate_Date__c = System.today()+1;
        ship.Customs_Broker__c = True;
        //ship.Date_Planner_Confirmed__c = System.now()+1;
        
        ship.Date_Receive_from_SAP__c = System.now()+1;
        ship.Devolucion__c = True;
        ship.Email_Sales_ExecutiveSP__c = 'testship@pak2go.com';
        //ship.Enable_Route_Options__c = True;
        ship.Enviado_Sap__c = True;
        ship.ETA_Point_of_Discharge__c = System.today();
        ship.ETD_from_Point_of_Load__c = System.today();
        ship.Hazardous__c = True;
        ship.Order_Margen_Operativo__c = 30;
        ship.Monitoreo_Recepci_n_Acuse__c = True;
        ship.NotificarGastoExtra__c = True;
        ship.OK_FACTURAR_FI__c = True;
        ship.Only_Warehouse_Service__c = True;
        ship.Placas_Validadas__c = True;
        ship.Reparto__c = True;
        ship.SAP_Invoiced__c = True;
        ship.Sell_Price_Modified__c = True;
        ship.Shipment_Customer_Evaluate__c = 'www.google.com';
        //ship.Name = '.';
        ship.Shipment_Status_Mon__c = 'In Progress';
        ship.Solicitud_de_Maniobras__c = True;
        ship.SP_Evaluated__c = True;
        ship.Status_Acuse_SAP__c = 'Enviado';
        ship.VERIFY_PAK_CONTROL__c = True;
        ship.VoBo_Acuse_SAP__c = True;
        //Account carrier = [SELECT Id FROM Account LIMIT 1];
        ship.Carrier__c = [Select Id from Account where Name = 'Carrier2 Test'].Id;        
        ship.Country_of_Load__c = [Select Id from Country__c  where Name = 'Mexico T'].Id;
        ship.State_of_Load__c = [Select Id from State__c   where Name = 'Sonora T'].Id;
        ship.Site_of_Load__c = 'a034T000004F9RiQAK';//[Select Id from Location__c    where Name LIKE 'Hermosillo T'].Id;
        ship.Country_of_Discharge__c = 'a004T0000028AZOQA2';//[Select Id from Country__c  where Name = 'Mexico T'].Id;
        ship.State_of_Discharge__c = 'a044T000003SdLoQAK';//[Select Id from State__c   where Name = 'Sonora T'].Id;
        ship.Site_of_Discharge__c = 'a034T000004FHWMQA4';//[Select Id from Location__c    where Name = 'Hermosillo T'].Id;        
        //ship.Operation_Executive__c = [SELECT Id FROM User WHERE Alias = 'TestL'].Id;
        ship.Freight_Mode__c = 'Sea';
        ship.Service_Mode__c = 'EXPORT';
        ship.Service_Type__c = 'FCL';
        ship.Status_Shipment__c = 'Active';
        ship.Destination_Address__c = 'En alguna parte de Xalapa, Veracruz';
        ship.Documentos_de_Cruce__c = True;
        ship.Email_Sales_ExecutiveSP__c = '';
        ship.Name_Cliente__c = 'Cliente de Prueba';
        ship.Marketplace_Auction__c = True;
        //ship.Shipment_Status_Plann__c = 'In Progress';
        //ship.Traslado_Ingreso__c = 'Traslado';
        
        test.startTest();
	        update ship;
        test.stopTest();
        
    }
   
   public static testMethod void updateServiceLine(){
        
   	     
        NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
       account_test.Segment__c = 'Nuevo';
        insert account_test;               	
       
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.name = 'SP-FN-909897';
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
        
       	 Fee__c service = new Fee__c();
        service.Account_for__c = shipment_test.Account_for__c;
        service.Carrier_Account__c = shipment_test.Account_for__c;
        service.Name = 'test fees' + NEU_Utils.safeString(DateTime.now().getTime());
        service.Fee_Category__c = 'Disbursement';
        service.Rate_Type__c = 'Fixed';
        service.Valid_Until__c = Date.newInstance(2017,11,11);
        service.Valid_From__c = Date.newInstance(2017,10,10);
        service.Buy_Rate__c = 12;
        service.Fee_Rate__c = 23;
        service.Active__c = true;
        service.Standard_Rate__c = true;
        service.Fuel__c = 100;
        service.Risk__c = 100;
        service.Normal__c = 10;
        service.Volumetric_Factor__c = 1;
        service.Max_Kgs__c = 10;
        service.q200__c = 100;
        service.q25__c = 100;
        service.q45__c = 100;
        service.q50__c = 100;
        service.q80__c = 100;
        service.q100__c = 100;
        service.q125__c = 100;
        service.q150__c = 100;
        service.q250__c =100;
        service.q300__c = 100;
        service.q500__c = 100;
        service.q1000__c = 100;
        service.q1500__c = 100;
        service.q2000__c = 100;
        service.q2500__c = 100;
        service.q3000__c = 100;
        service.q5000__c = 100;
        service.q7500__c = 100;
        service.q10000__c = 100;
        insert service;
       
        Shipment_Fee_Line__c servicesF = new Shipment_Fee_Line__c();
        servicesF.Shipment__c = shipment_test.Id;
        servicesF.Name = '001';
        servicesF.Service_Rate_Name__c = service.Id;
        insert servicesF;
       	
       Set<String> validCurrency = new Set<String>();
       Schema.DescribeFieldResult f = Pricebook2.CurrencyIsoCode.getDescribe();
       for (Schema.PicklistEntry pick:f.getPicklistValues()){
           validCurrency.add(pick.getValue());
       }
       
        
		Test.startTest();
			String moneda = validCurrency.iterator().next();
       		//servicesF.Import_Export_Quote__c = folio.Id;
			servicesF.Add_to_Quote__c = true;
           	servicesF.Block__c = true;
            servicesF.Buy_Price_Modified__c = true;
            servicesF.Concept_1_Sell_Price__c = 150.50;
            servicesF.Concept_2_Sell_Price__c = 151.50;
            servicesF.Concept_3_Sell_Price__c = 152.50;
            servicesF.Concept_4_Sell_Price__c = 153.50;
            servicesF.Concept_5_Sell_Price__c = 154.50;
            servicesF.Conversion_Rate_to_Buy_Currency_Header__c = 50.50;
            servicesF.Count_Modify_Sell_Price__c = 159.60;
            servicesF.Currency_Buy_Price__c = 'MXN';
            servicesF.Director_Email__c = 'director@live.com';
            servicesF.Discount_Charge__c = 5;
            servicesF.Email_Cobranza_1__c = 'cobranza1@live.com';
            servicesF.Email_Cobranza_2__c = 'cobranza2@live.com';
            servicesF.Email_Cobranza_3__c = 'cobranza3@live.com';
            servicesF.Email_Sales_ExecutiveSP__c = 'sp@live.com';
            servicesF.Es_de_IEQ__c = true;
            servicesF.Extension_Service_Name__c = 'Service name test';
            servicesF.Min_Amount__c = 20;
            servicesF.Operations_Executive__c = 'operation@live.com';
            servicesF.Service_Rate_Category_Filter__c = 'Test exss';            
            servicesF.Sell_Price_Modified__c = true;
            servicesF.Name = 'Update test';
            servicesF.Shipment_Buy_Price__c = 250;
            servicesF.Shipment_Finished__c = true;
            servicesF.Shipment_Sell_Price__c = 580;
            servicesF.Units__c = 15.3;
            servicesF.Warehouse_Rate__c = true;
       		servicesF.Conversion_Rate_to_Currency_Header__c = 15.95;
       		servicesF.CurrencyIsoCode = moneda;
       		servicesF.Currency_Buy_Price__c = moneda;
       		servicesF.Record_Locked__c = true;
       		servicesF.Shipment_Buy_Price_Number__c = 195.25;
       		servicesF.Shipments_Program_Rate_Category__c = 'Road Freights';
       		servicesF.SAP__c = true;
        	update servicesF;
        Test.stopTest();
        
   }
    
    
    
    
   /*public static testMethod void updateServiceLine(){
   
       
       List<Shipment_Fee_Line__c> servicesF = [SELECT Id FROM Shipment_Fee_Line__c  WHERE name='001']; //
       Shipment_Fee_Line__c service = servicesF.get(0);
       
       service.Id = 'a1y0R000001TlgzQAC';
       service.Add_to_Quote__c = true;
       service.Block__c = true;
       service.Buy_Price_Modified__c = true;
       service.Concept_1_Sell_Price__c = 150.50;
       service.Concept_2_Sell_Price__c = 151.50;
       service.Concept_3_Sell_Price__c = 152.50;
       service.Concept_4_Sell_Price__c = 153.50;
       service.Concept_5_Sell_Price__c = 154.50;
       service.Conversion_Rate_to_Buy_Currency_Header__c = 50.50;
       service.Count_Modify_Sell_Price__c = 159.60;
       service.Currency_Buy_Price__c = 	'MXN';
       service.Director_Email__c = 'director@live.com';
       service.Discount_Charge__c = 5;
       service.Email_Cobranza_1__c = 'cobranza1@live.com';
       service.Email_Cobranza_2__c = 'cobranza2@live.com';
       service.Email_Cobranza_3__c = 'cobranza3@live.com';
       service.Email_Sales_ExecutiveSP__c = 'sp@live.com';
       service.Es_de_IEQ__c = true;
       service.Extension_Service_Name__c = 'Service name test';
       service.Min_Amount__c = 20;
       service.Operations_Executive__c = 'operation@live.com';
       service.Service_Rate_Category_Filter__c = 'Test exss';
       service.SAP__c = false;
       service.Sell_Price_Modified__c = true;
       service.Name = 'Update test';
       service.Shipment_Buy_Price__c = 250;
       service.Shipment_Finished__c = true;
       service.Shipment_Sell_Price__c = 580;
       service.Units__c = 15.3;
       service.Warehouse_Rate__c = true;
       
       test.startTest();
       	update service;
       test.stopTest();
           
       
   }*/
    
    /*public static testMethod void serviceLine(){
        //List<Shipment_Fee_Line__c> serviceL = [Select Id FROM Shipment_Fee_Line__c WHERE Id = 'a1y0R000001TlymQAC'];
        //List<Shipment__c> shipment = [SELECT Id FROM Shipment__c WHERE Name = 'SP-FI-21-1234567'];
        
        Shipment_Fee_Line__c sl = New Shipment_Fee_Line__c();
        sl.Name = '001';
        sl.Shipment__c = [SELECT Id FROM Shipment__c WHERE Name = 'SP-FI-21-1234567'].Id;
        insert sl;
        
        //test.startTest();
        
        //test.stopTest();
        
    
    
    
        List<Shipment_Fee_Line__c> lstService = [
            SELECT Id, Shipment_Buy_Price__c
            FROM Shipment_Fee_Line__c
            WHERE Id='a200R000001QQYdQAO'
        ];
        List<Shipment_Fee_Line__c> actualizar = New List<Shipment_Fee_Line__c>();
        for(Shipment_Fee_Line__c sl : lstService){
            sl.Shipment_Buy_Price__c = 11000;
            sl.Buy_Price_Modified__c = False;
            actualizar.add(sl);
        }
        test.startTest();
        UPDATE actualizar;
        test.stopTest();
    }*/
}