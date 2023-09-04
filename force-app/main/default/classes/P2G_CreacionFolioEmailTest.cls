@isTest
public class P2G_CreacionFolioEmailTest {
    @testSetup
    static void SetUp(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'HENKEL';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c=null;
        insert account_test;
        Account_Address__c address1 = new  Account_Address__c();
        address1.Name ='Prueba Albert';
        address1.Account__c=account_test.Id;
        address1.Type__c='Shipping Address';
        //address1.Codigo_Postal_CP__c='a3n0R000000JgI1QAK';//CatalogoSat
        //address1.Colonia_cp__c='a3n0R000000JvaPQAS';
        address1.Calle_cat__c='AVENIDA ARBOLEDA';
        address1.Address__c='Arbolada 57B, Conj U los Sauces V, 50200 San José Guadalupe, Méx., México';
        address1.Address_Coordinates__Latitude__s =37.7749;
        address1.Address_Coordinates__Longitude__s=34.67;
        insert address1;
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso');
        Catalogo_SAT__c producto = TestDataFactory.createCatalogoSat('Papel' , '47131805','Productos y Servicios cP');
        Catalogo_SAT__c materialPeligro = TestDataFactory.createCatalogoSat('Aluminio' , 'TCA126','Material Peligroso');
        Catalogo_SAT__c embalaje = TestDataFactory.createCatalogoSat('Caja' , 'TCA128','Tipo de Embalaje');
        Catalogo_SAT__c palet = TestDataFactory.createCatalogoSat('Pallet' , 'TCA228','Unidad Peso');
        catalogo.Material_PeligrosoCP__c=true;
        update catalogo;
        Country__c country = new Country__c(Name='Mxico');
        insert country;
        State__c state = new State__c(Name='Sonora',Country__c=country.Id,Iso_Code__c='SON',ISO_Code_2c__c='SO',Zone_Planner_email__c='kuresa@gmaidl.com',Active__c=true);
        insert state;
        Location__c location = new Location__c(Name='xalapa', State__c=state.Id,Country__c=country.Id);
        insert location;
        Location loc1 = System.Location.newInstance(28.635308,77.22496);
        Container_Type__c container = new Container_Type__c(Name='Caja 53 FT',Type__c='Road',Cargo_Weight_Kg__c=22222);
        insert container;
        Equivalencias__c equi = new Equivalencias__c();
        equi.Name = 'Caja 53 FT';
        equi.Account__c=account_test.Id;
        equi.Caja_53_FT__c='MEX-BL-E5-TRUCK-28T;MEX-BL-E5-TRUCK-22FT';
        insert equi;
        
    }
    @isTest
    static void handleInboundEmail(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.htmlBody = 'de la compa&ntilde;&iacute;a HENKEL Tel&eacute;fono';
        email.plainTextBody = 'URLResponder por web<https://otm.henkelgroup.net/GC3/glog.webserver.tender.SubTenderCollabManagementServlet?pk=550875340%20HKL.C010741020>Enviado aContactoNombre de la compañíaHENKELTeléfonoFaxEmailInformación del proveedor del servicioNombreNombre de la compañíaGrupo PGL MexicoID proveedor0001041564TeléfonoFaxEmailSCACInformación del envíoID de envíoC010741020Parada2Guía de cargaSello de SeguridadOrigenxalapaDestinoxalapaPeligrosoNControl de temperaturaN ( - )Peso del envío con tarimas22132.30- KGPeso del envío sin tarimas21074.06- KGNúmero total de tarimas31Número total de espacios de tarima21.758Tipo de EntregaE5 -Peso bruto total por código UN~Fecha de carga2023-03-22 20:00:00 America/Mexico_CityFecha de última entrega2023-03-24 08:00:00 America/Mexico_CitySe requiere Dock SchedulingNONúmero económico de cajaEquipoMEX-BL-E5-TRUCK-28TPeso Bruto Total por Clave Producto47131805-20.219kg, 47131811-22112.082kgComentario de envíoInformación de parada del envíoParadaNombre de ubicaciónID de la ubicaciónContactoDirección-CiudadRegiónPaísFecha Planeada de EntregaPeso totalVolumen total1L MX TOLUCA5KDAAVENIDA ARBOLEDA COLONIA SANTIN50230 TOLUCAMEX2023-03-22 20:00:0022132.3 KG80.02 CUMTRID EntregaActividadID de la ubicaciónNombre de ubicaciónPeso totalTotal, de artículos empacadosUnidad de medidaNúmero total de tarimasHora de llegada anticipadaHora de llegada tardíaHora de llegada tardíaDel.On-Till-Slotbook.0902844314-P92Recogida5KDAL MX TOLUCA22132.30 KG1138SHU31ParadaNombre de ubicaciónID de la ubicaciónContactoDirección-CiudadRegiónPaísFecha Planeada de EntregaPeso totalVolumen total2WM SC BOD SUP VILLAHERMOSA 74680001535379CARR. VILLAHERMOSA CARDENAS KM 145RANCHERIA PLATANO Y CACAO CENTRO86280 VILLAHERMOSATABMEX2023-03-24 08:00:0022132.3 KG80.02 CUMTRID EntregaActividadID de la ubicaciónNombre de ubicaciónCiudadPeso totalTotal, de artículos empacadosUnidad de medidaNúmero total de tarimasPeligrosoHora de llegada anticipadaHora de llegada tardíaDel.On-Till-Slotbook.Numero de Orden de compraEquipo del clienteIncoterm - ubicación0902844314-P92Entrega0001535379WM SC BOD SUP VILLAHERMOSA 7468VILLAHERMOSA22132.30 KG1138SHU31N2023-03-24 08:00:002023-03-24 08:00:003677945387DAP-VILLAHERMOSAHorarioday_of_week.Monday000100-235900-000000-000000day_of_week.Tuesday000100-235900-000000-000000day_of_week.Wednesday000100-235900-000000-000000day_of_week.Thursday000100-235900-000000-000000day_of_week.Friday000100-235900-000000-000000day_of_week.Saturday000100-235900-000000-000000day_of_week.Sunday000100-235900-000000-000000Appointment Date: 2023-03-24 08:00:00 America/Mexico_CityAppointment Confirmation Number:A menos que las Partes acuerden lo contrario, dicha entrega se realizará de acuerdo con los términos y condiciones de las Condiciones Generales de Compra de HENKEL (https://www.supplier-portal.henkel.com/supplier/PurchaseConditions.do)Requisitos de seguridad: Casco, Chaleco, Zapatos de seguridad, licencia federal vigente, tarjeta de circulación de caja y tracto, unidad en buen estado, hoja de SUA y seguro de unidad.Materiales Peligrosos (DG) e información de Entrega.ID de entrega0902844314-P92PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGING--PACKAGE-GROUP and KIND OF PACKAGIG--1';
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();   
        Test.startTest();
        P2G_CreacionFolioEmail handler = new P2G_CreacionFolioEmail();
        handler.handleInboundEmail(email, envelope);
        Test.stopTest();
    }
}