@isTest
public class P2G_cargaMasivaFoliosTest {
	@testSetup
    static void SetUp(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Name = 'Bimbo';
        account_test.Credit_Limit__c = 1000000;
        account_test.Venta_Sap__c='Credito';
        account_test.Segment__c='Nuevo';
        account_test.Workplace__c=null;
        insert account_test;
        User userT = [select id,managerId, userRole.Name  from user where id =: UserInfo.getUserId() limit 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.userRole.Name);//Director Comercial ,Director Regional
        Catalogo_SAT__c catalogo = TestDataFactory.createCatalogoSat('Caja de acero test' , 'TCA125','Unidad Peso');
        Catalogo_SAT__c producto = TestDataFactory.createCatalogoSat('Papel' , 'TCA127','Productos y Servicios cP');
        Catalogo_SAT__c materialPeligro = TestDataFactory.createCatalogoSat('Aluminio' , 'TCA126','Material Peligroso');
        Catalogo_SAT__c embalaje = TestDataFactory.createCatalogoSat('Caja' , 'TCA128','Tipo de Embalaje');
        Catalogo_SAT__c palet = TestDataFactory.createCatalogoSat('Pallet' , 'TCA228','Unidad Peso');
        catalogo.Material_PeligrosoCP__c=true;
        update catalogo;
        Country__c country = new Country__c(Name='Mxico');
        insert country;
        SAP_Service_Type__c sapServiceType = new SAP_Service_Type__c(Name='FLETE NACIONAL (IC) (FN)');
        insert sapServiceType;
        State__c state = new State__c(Name='Sonora',Country__c=country.Id,Iso_Code__c='SON',ISO_Code_2c__c='SO',Zone_Planner_email__c='kuresa@gmaidl.com',Active__c=true);
        insert state;
        Location__c location = new Location__c(Name='xalapa', State__c=state.Id,Country__c=country.Id);
        insert location;
        Container_Type__c container = new Container_Type__c(Name='Super tracto Camion',Type__c='Road',Cargo_Weight_Kg__c=22222);
        insert container;
    }
    @isTest
    static void callMethods(){
        
        String body = 'Accountfor,Team,CustomerReference,ReferenceForm,SiteofLoad,SiteofDischarge,SapServiceType,ETD,ETA,AwaitingLoadtime,AwaitingUnloadtime,ContainerType,ClaveProducto,DescripcionProducto,Material,Embalaje,Units,PesoBruto,PesoNeto,Currency,TotalVolume(m3),Precio\n '+
        'Bimbo,P2G,Crear folio 1,,xalapa,xalapa,FLETE NACIONAL (IC) (FN),2023-03-17,2023-03-20,09:00:00,14:00:00,Super tracto Camion,Papel,creo una cargo para el folio1,Aluminio,Caja,1,1,1,MXN,1,20';
    	Blob fileBody = Blob.valueOf(body);
        List<P2G_CreacionFoliosWrapper.folioMasivo> carga = P2G_convertCsv.fileProcess(fileBody);
        P2G_CreacionFoliosWrapper.folioM listaFolio = P2G_CargaMasivaMetodos.cambioId(carga);
        //P2G_cargaMasivaFolios batch = new P2G_cargaMasivaFolios(listaFolio.folio,listaFolio.cargo);
        //Database.executeBatch(batch,5);
        //List<Quote_Item_Line__c> listaCargo = P2G_CargaMasivaMetodos.creaCargo(fleteNacional, cargoLine);
        
    }
}