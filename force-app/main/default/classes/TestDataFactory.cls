@isTest
public  class TestDataFactory {
    //Brandom Baruch -  Leonardo
    //Clase test para crear todos los objetos y llamarla en las clases
    //Test que se lleguen a utilizar

    //Metodo para crear cuentas
    public static Account createAccounts(String name, String recordType){

        Account accountT = new Account();
        accountT.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        accountT.name = name;
        accountT.Segment__c = 'Nuevo';
        accountT.Order_to_Cash__c = true;
        accountT.ShippingStreet = 'testShipping';
        accountT.ShippingCity = 'city shipping';
        accountT.ShippingState = 'state shipping';
        accountT.ShippingPostalCode = 'postalCode';
        accountT.ShippingCountry = 'country shipping';
        accountT.Account_Executive_User__c = userinfo.getUserId();
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
            accountT.Credit_Limit__c = 50000;
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
        
        insert accountT;           
        return accountT;
    }
    
    public static Contact createContact(Id acc, String name){
        
        Contact con = new Contact();
        con.AccountId = acc;
        con.LastName = name;
        insert con;
        return con;
    }

    public static Vessel_Flight__c createVassel(String name, Id accCarrier){
        
        Vessel_Flight__c vf = new Vessel_Flight__c();        
        vf.Carrier_Account__c = accCarrier;
        vf.Name = name;
        vf.IMO__c = '111';
        vf.MMSI__c = '1111';
        //vf.Anio_Embarcacion__c = '2019';
        vf.Vessel_Flight_ETD_Point_of_Load__c = Date.today();
        insert vf;
        return vf;
    }
    //Metodo para crear un administrador
    public static User createUserAdmin(){
       
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
        return userT;
    }

    public static Carrier_Line_Load_Point__c createRoute(String name, InfoCountry ic){
        Carrier_Line_Load_Point__c ro = new Carrier_Line_Load_Point__c();
        ro.Name = name;
        if(ic != null){
         	ro.Country_of_Discharge__c=ic.countryOfdischarge;
            ro.Country_of_Load__c=ic.countryOfLoad;
            ro.Port_Airport_of_Discharge__c=ic.siteOfdischarge; 
            ro.Port_Airport_of_Load__c=ic.siteOfLoad;
            ro.State_of_Discharge__c = ic.stateofDischarge;
            ro.State_of_Load__c = ic.stateofLoad;   
        }        
        insert ro;  
        return ro;
    }
    
    //Metodos para crear folio
    public static Customer_Quote__c createFolio(Id acc,Id catalogo, Id route, String freMod, String serMod, String serTyp,boolean status){
                        
        Customer_Quote__c folio = new Customer_Quote__c();
        //folio.Name = name;
        folio.Account_for__c = acc;
        folio.Freight_Mode__c = freMod;
        folio.Service_Mode__c = serMod; 
        folio.Service_Type__c =  serTyp;
        folio.Move_Type__c = 'Door to Door';
        folio.Origin_Address__c = 'Address Test'; 
        folio.Destination_Address__c = 'Address Test';
        folio.ByPass__c = true;
        folio.Impak_Request__c = true;
        folio.Date_Pricing_responded__c = System.today();
        folio.Clave_de_Unidad_de_Peso__c = catalogo;
        folio.Max_Deliveries__c = 10;
        folio.Conversion_Rate_Date__c = system.today();
        folio.DO_Release_Date__c = system.today();
        folio.DO_Release_Valid_To__c = system.today().adddays(3);
        folio.Authorized_Credit__c = true;   
        folio.Route__c = route;
        folio.Supplier_Account__c = acc;
        folio.Consignee__c = acc;
        folio.Margin_at_Destination_by_Default__c = 10;
        
        if(status){
         	folio.Quotation_Status__c = 'Approved as Succesful';   
        }      
        
        insert folio;                                      
        return folio;
    }
    
    public static Import_Export_Fee_Line__c createServiceLine(String name, Id route, Customer_Quote__c folio){
        
        Fee__c service_rate = new Fee__c();
		service_rate.Name = 'Service Rate Test';
		service_rate.Fee_Category__c = 'Disbursement';
		service_rate.Rate_Type__c = 'Per Kg';
		service_rate.Account_for__c = folio.Account_for__c;
        service_rate.CustomRate__c = true;
        service_rate.Route__c = route;
        insert service_rate;       
        
        Import_Export_Fee_Line__c sl = new Import_Export_Fee_Line__c();
        sl.Import_Export_Quote__c = folio.Id;
        sl.Quote_Buy_Price__c = 250;
        sl.Quote_Sell_Price__c = 500;
        sl.Units__c = 1;
        sl.Discount__c = 10;
        sl.Conversion_Rate_to_Currency_Header__c = 1;
        sl.Min_Amount__c  = 500;
        sl.Service_Rate_Name__c = service_rate.Id;
        sl.Name = 'Test1';
        insert sl;          
        return sl;        
    }
    
    public static Import_Export_Service_Line_Invoice__c createServiceLineInvoice(Id inv, Id sl, String name){
        
        Import_Export_Service_Line_Invoice__c il = new Import_Export_Service_Line_Invoice__c();
        il.Name = name;
        il.Invoice__c = inv;
        il.Import_Export_Service_Line__c = sl;
        insert il;
        return il;
    }
        
    public static Quote_Item_Line__c createCargoLine(String name, Customer_Quote__c folio){
        
        Sourcing_Item__c item =  new Sourcing_Item__c();
        item.Name = 'item tst';
        item.Account_Owner__c = folio.Account_for__c;
        insert item;
        
        Quote_Item_Line__c ql = new Quote_Item_Line__c();
        ql.Name = 'tst1';
        ql.Item_Name__c = item.Id;
        ql.Units__c = 1;
        ql.Total_Shipping_Weight_Kgs__c = 20;
        ql.Total_Shipping_Volume_m3__c = 10;
        ql.Margin_at_Destination__c = 2;
        ql.Import_Export_Quote__c = folio.Id;
        ql.Margin_at_Destination__c = 1;
        insert ql;
        
        return ql;
    }
    //Fin de crear folio

    public static Rol_Margen__c createRolMargen(String name){
        
        Rol_Margen__c margen = new Rol_Margen__c();        
        margen.Name = name;
        margen.FN_Margen_Operativo__c = 1;
        margen.FI_Margen_Operativo__c  = 1;
        margen.FI_LTL_Margen_Operativo__c = 1;
        margen.PTO_Margen_Operativo__c = 5;
        margen.M_FCL_Margen_Operativo__c = 1;
        margen.M_LCL_Margen_Operativo__c = 1;
        margen.A_Margen_Operativo__c = 1;
        margen.A_Paq_Margen_Operativo__c = 1;
        margen.W_WCA_Margen_Operativo__c = 1;
        margen.AW_WCA_Margen_Operativo__c = 1;
        margen.R_Margen_Operativo__c = 1;
        margen.T_Margen_Operativo__c = 1;
        margen.PQ_Margen_Operativo__c = 1;
        insert margen;
        return margen;
    }

    public static Catalogo_SAT__c createCatalogoSat(String name, String claveSat, String recordType){

        Catalogo_SAT__c trans = new Catalogo_SAT__c();        
        trans.Name  = name;
        trans.Clave_SAT__c = claveSat;
        trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();     
        insert trans;   
        return trans;        
    } 

    public static Shipment__c createShipment (ShipmentCreate sp, InfoCountry ic){

        Shipment__c newSP = new Shipment__c();
        newSP.Name = sp.name;  
        newSP.Traslado_Ingreso__c = 'Traslado';
        newSP.VERIFY_PAK_CONTROL__c = true;
        newSP.Shipment_Status_Plann__c = 'In Progress';         
        newSP.Freight_Mode__c = (sp.freightMode == null ? 'Road' : sp.freightMode);
        newSP.Account_for__c= sp.accCustomer;             
        newSP.Service_Mode__c = (sp.serviceMode == null ? 'NATIONAL' : sp.serviceMode);
        newSP.Service_Type__c =  (sp.serviceType == null ? 'FTL' : sp.serviceType);
        newSP.Move_Type__c = 'Door to Door';        
        newSP.Only_Warehouse_Service__c = false;                    
        newSP.Operation_Executive__c = sp.user;       
        newSP.Carrier__c = sp.accCarrier; 
        newSP.National_Operator__c = sp.operador;
        newSP.Vehicle__c = sp.vehiculo;
        newSP.Liga_Cuenta_Espejo__c = 'EspejoEjemplo';
        newSP.Usuario_Cuenta_Espejo__c = 'Espejo cuenta';
        newSP.Contrasena_Cuenta_Espejo__c = 'cuenta espejo';
        newSP.ETA_Point_of_Discharge__c = Date.newInstance(2300, 2, 17);
        newSP.ETA_Time_Point_of_Discharge__c = Time.newInstance(18, 30, 2, 20);
        newSP.ETD_from_Point_of_Load__c = Date.newInstance(2300, 2, 19);
        newSP.ETD_Time_from_Point_of_Load__c = Time.newInstance(18, 30, 2, 20);
        newSP.kms__c = 2;
        newSP.ATA__c =Date.newInstance(2300, 2, 17);
        newSP.ATD__c=Date.newInstance(2300, 2, 17);
        newSP.Container_Size__c = sp.containerSize; 
        newSP.Truck_Vessel_Flight__c = sp.vesselId;
        newSP.ETD__c =  String.valueOf(Date.today());
		newSP.ETA_ATA__c = String.valueOf(Date.today());
		newSP.Inbound_Consolidation_Program__c = sp.shipmentProgram;     
        newSP.Flight_Number__c = '10';
        newSP.Truck_Number__c = '2';
        newSP.Supplier_Account__c = sp.accCarrier;
        newSP.Origin_Address__c = 'Address Test'; 
        newSP.Destination_Address__c = 'Address Test';
        newSP.Margin_at_Destination_by_Default__c = 10;
        
        
        if(ic != null){
            newSP.Site_of_Discharge__c = ic.siteOfdischarge;
            newSP.Site_of_Load__c = ic.siteOfLoad;
            newSP.Country_of_Load__c = ic.countryOfLoad;
            newSP.Country_of_Discharge__c = ic.countryOfdischarge;
            newSP.Only_Warehouse_Service__c = true;
            newSP.State_of_Discharge__c = ic.stateofDischarge;
            newSP.State_of_Load__c = ic.stateofLoad;
        }

        insert newSP;
        return newSP;
    }

    public static Shipment_Line__c createShipmentLine(Id sp, String name){
        
        Shipment_Line__c sl = new Shipment_Line__c();
        sl.Shipment__c = sp;
        sl.Name = name;
        insert sl;
        return sl;
    }
    
    public static SCM_Rule__c createRule(String name, String ruleCode){
     
        SCM_Rule__c scmRule = new SCM_Rule__c();
        scmRule.Name=name;
        scmRule.Category__c= 'Inventory Management';
        scmRule.Enabled__c = true;
        scmRule.Fee_Alarm_Text__c='test';
        scmRule.Description__c='test';
        scmRule.SCM_Rule_Code__c= ruleCode;
        insert scmRule;
        return scmRule;
    }    
    
    public static SCM_Activity__c createActivity(String name, Id csmRule){
     
        SCM_Activity__c activity = new SCM_Activity__c();
        activity.Name='test';
        activity.Enabled__c = true;
        activity.SCM_Rule__c = csmRule;
        activity.Subject__c='test';
        activity.Comments__c = 'Comentario test';
        insert activity;
        return activity;
    }    
    
    public static Container_Type__c createContainerType(String name){

        Container_Type__c ctV = new Container_Type__c();
         ctV.Name = name;
         ctV.Type__c = 'Road';
         ctV.Height_cm__c = 250;
         ctV.Length_cm__c = 1450;
         ctV.Width_cm__c = 250;
         ctV.Cargo_Weight_Kg__c = 25000;
         insert ctV;  
         return ctV; 
    }

    public static Operadores__c  createOperador(Id accCarrier, Id cp){
        
        Operadores__c operador = new Operadores__c();
        operador.Account__c = accCarrier;		
        operador.Name = 'Operador test';
        operador.Cel_ope__c = '123456789';
        operador.Telfij_ope__c = '123123123';
        operador.Medprev_ope__c = '123123';
        operador.Proovedor_validado__c = true;
        operador.Validado__c = true;        
        operador.Operador_Validado__c = true;
        operador.Codigo_Postal_Operador__c = cp;
        operador.RFC_Operador__c = 'TestRFC';
        operador.Numlicvig_ope__c = '123135';         
        insert operador;
        return operador;
    }

    public static State__c createState(String name,Id country){
        State__c state = new State__c();
        state.Name = name;
		state.ISO_Code_2c__c = 'SO';
		state.country__c = country;
        return state;
    }
    
    
    //trans son del objeto "catalogo SAT"
    public static Vehicle__c createVehiculo(Id accCarrier, Id trans1, Id trans2){
        
        Vehicle__c v = new Vehicle__c();
         v.Name = 'Vehiculo test';
         v.Account_for_SCP__c = accCarrier;         
         v.Marca__c = 'Mercedes';
         v.Color_Tracto__c ='Rojo';
         v.Modelo__c ='K77';
         v.Ano__c = 2021;
         v.Configuracion_Vehicularcat__c = trans1;
         v.Account_Owner_Vehicle__c = accCarrier ;
         v.Numero_Poliza_Seguro__c = '1234556';
         v.Asegura_Responsabilidad_Civil__c = 'AXXXA';
         v.Nombre_Aseguradora__c = 'AXXXA';
         v.Poliza_Responsabilidad_civil__c = '123456789';
         v.Prima_Seguro__c = '123456789';
         v.Numero_de_Permiso_SCT__c = '123456789';
         v.Tipo_de_Permiso__c = trans2;
         v.Vehiculo_Validado__c = true;
         insert v;
         return v;
    }   

    public static Country__c createCountry(){

        Country__c country = new Country__c();
        country.Name = 'Mexico';
        country.ISO_Code__c='MEX';
        country.Region__c = 'North America';
        country.DHL_ExportZone__c= 'Zona 8';
        insert country;
        return country;
    }

    public static Location__c createLocation(String name,Id country){

        Location__c location = new Location__c();
        location.Name= name;
        location.City__c='test city';
        location.Country__c= country;
        location.Subdivision__c='test subdivision';
        location.UNLOCODE__c='ABC';
        insert location;
        return location;

    }
    
    public static Account_Address__c createAddressAccount(String name, Id accountT, Id direccion){
     
        Account_Address__c address = new Account_Address__c();
        address.Name = name;
        address.Account__c = accountT;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Codigo_Postal_CP__c = direccion;
        address.referencia__c = 'Referencias test';
        address.Type__c = 'Shipping Address';
        insert address;
        return address;
    }       
    
    public static Shipment_Program__c createShipmentProgram(){
        Shipment_Program__c spp = new Shipment_Program__c();
        spp.Number_of_Containers__c = 2;
        spp.Flight_Number__c = '10';
        insert spp;
        return spp;
    }
    
    public static Invoice__c createInvoice(Shipment__c sp, Id folio){
        Invoice__c inv = new Invoice__c();
        inv.Name = '.';
        inv.Type__c= 'Debit Note';
        inv.Date_of_Invoice__c = Date.today();
        inv.Payable_Before__c = Date.today();
        inv.Account__c = sp.Account_for__c;
        inv.Shipment__c = sp.Id;
        inv.Import_Export_Quote_Order__c = folio; 
        insert inv;
		return inv;        
    }

    public class ShipmentCreate{

        public String containerSize {get;set;}
        public String name {get;set;}
        public Id operador{get;set;}
        public Id vehiculo{get;set;}
        public Id accCarrier{get;set;}
        public Id accCustomer{get;set;}
        public Id user{get;set;}
        public String freightMode{get;set;}
        public String serviceMode{get;set;}
        public String serviceType{get;set;}
        public Id vesselId{get;set;}
        public Id shipmentProgram{get;set;}
    }

    public class InfoCountry{

        public Id siteOfLoad{get;set;}
        public Id siteOfdischarge{get;set;}
        public Id countryOfLoad{get;set;}
        public Id countryOfdischarge{get;set;}
        public Id stateofDischarge{get;set;}
        public Id stateofLoad{get;set;}
    }
}