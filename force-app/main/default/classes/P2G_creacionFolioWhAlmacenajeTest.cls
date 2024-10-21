@isTest(SeeAllData=true)
public class P2G_creacionFolioWhAlmacenajeTest {
    @isTest
    static void callsendToSaptest(){
        Import_Export_Fee_Line__c serviceLine = [SELECT Id, Import_Export_Quote__c FROM Import_Export_Fee_Line__c
                                                WHERE Import_Export_Quote__r.Account_for__r.Name Like: '%ejemplo%'
                                                AND Quote_Sell_Price__c > 0 Limit 1];
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name='Xalapa' Limit 1];
        Account_Address__c acc = [SELECT Id, Account__c FROM Account_Address__c WHERE Name Like '%Prueba%' Limit 1];
        Catalogo_SAT__c claveSap= [SELECT Id FROM Catalogo_SAT__c WHERE Name= 'Servilletas de papel' Limit 1];
        Test.startTest(); 
        P2G_CreacionFoliosWrapper.folio fleteNacional = P2G_CreacionFolios.getwrapper();
        fleteNacional.numFoliosCrear = 1;
        fleteNacional.reference = 'prueba test';
        fleteNacional.grupo = 'SP-WH-ALMACENAJE';
        fleteNacional.etd = '2023-03-10';
        fleteNacional.eta = '2023-03-10';
        fleteNacional.team = 'P2G';
        fleteNacional.idSideLoad = location.Id;
        fleteNacional.idSideDischarged = location.Id;
        fleteNacional.idAccount = acc.Account__c;
        fleteNacional.Awaitingloadtime = '08:00:00.000';
        fleteNacional.Awaitingunloadtime = '18:00:00.000';
        fleteNacional.accountOriginAddress = acc.Id;
        fleteNacional.accountDestinAddress = acc.Id;
        fleteNacional.buyPrice = '345';
        fleteNacional.sellPrice = '785';
        P2G_CreacionFoliosWrapper.cargoLine cargo = P2G_CreacionFolios.getCargoline();
        cargo.idItemSuplienerOwner='0010R000019aZF8QAM';
        cargo.extencionItemName='Papel';
        cargo.description='sd';
        cargo.currencyIsoCode='MXN';
        cargo.units='1';
        cargo.pesoBruto='1';
        cargo.pesoNeto='1';
        cargo.itemPrice='1';
        cargo.totalShipping='1';
        cargo.idClaveSat =claveSap.Id;
        P2G_CreacionFoliosWrapper.folio flete = P2G_creacionFolioWhAlmacenaje.creaFolios(fleteNacional, cargo);
        P2G_creacionFolioWhAlmacenaje.getCargoLine(flete.id);
        Quote_Item_Line__c getCargoLine = P2G_creacionFolioWhAlmacenaje.getCargoLine(flete.id);
        Import_Export_Fee_Line__c getServiceLine = P2G_creacionFolioWhAlmacenaje.getServiceLine(serviceLine.Import_Export_Quote__c);
        P2G_creacionFolioWhAlmacenaje.futureM(serviceLine.Import_Export_Quote__c);
		// para clase P2G_CreacionFoliosWrapper
        fleteNacional.border = 'border';
        fleteNacional.customs = 'customs';
        fleteNacional.impak = 'impak';
        fleteNacional.servicioIMPAK = 'serviIMPAK';
        fleteNacional.salesIncoterm = 'sales Inco';
		P2G_CreacionFoliosWrapper.folio getwrapper2 = P2G_CreacionFoliosWrapper.getwrapper2();
    	P2G_CreacionFoliosWrapper.cargoLine getCargoline2 = P2G_CreacionFoliosWrapper.getCargoline2();
    	list<SAP_Service_Type__c> getSapServiceType = P2G_CreacionFoliosWrapper.getSapServiceType('Servicio', fleteNacional.grupo);
		fleteNacional.grupo = 'SP-FN-FLETE NACIONAL';
		fleteNacional = P2G_CreacionFoliosWrapper.tipoServicio(fleteNacional);
        fleteNacional.grupo = 'SP-FI-FLETE INTER';
		fleteNacional = P2G_CreacionFoliosWrapper.tipoServicio(fleteNacional);
        fleteNacional.grupo = 'SP-A-AEREO';
		fleteNacional = P2G_CreacionFoliosWrapper.tipoServicio(fleteNacional);
        fleteNacional.grupo = 'SP-CE-COMERCIO EXT';
		fleteNacional = P2G_CreacionFoliosWrapper.tipoServicio(fleteNacional);
        fleteNacional.grupo = 'SP-M-MARITIMO';
		fleteNacional = P2G_CreacionFoliosWrapper.tipoServicio(fleteNacional);
        fleteNacional.grupo = 'SP-PTO-PUERTOS';
		fleteNacional = P2G_CreacionFoliosWrapper.tipoServicio(fleteNacional);
        fleteNacional.grupo = 'SP-R-GLOBAL ROUTIN';
		fleteNacional = P2G_CreacionFoliosWrapper.tipoServicio(fleteNacional);
        Test.stopTest();
    }
}