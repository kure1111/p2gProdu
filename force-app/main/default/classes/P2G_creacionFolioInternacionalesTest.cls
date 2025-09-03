@isTest(SeeAllData=true)
public class P2G_creacionFolioInternacionalesTest {
	@isTest
    static void P2G_creacionFolioInternacionalesTest(){
        Customer_Quote__c quote = [SELECT Id, Name,Account_for__c,Container_Type__c,Site_of_Load__c,Account_Origin_Address__c,Clave_de_Unidad_de_Peso__c
                                   FROM Customer_Quote__c WHERE 
                                   Container_Type__c != null AND Site_of_Load__c != null
                                   AND Account_Origin_Address__c != null AND Clave_de_Unidad_de_Peso__c != null LIMIT 1];
        Catalogo_SAT__c claveSap= [SELECT Id FROM Catalogo_SAT__c WHERE Name= 'Servilletas de papel' Limit 1];
        SAP_Service_Type__c sst = [SELECT Id, Name FROM SAP_Service_Type__c where Name LIKE :'%(T)%' LIMIT 1];
        P2G_CreacionFoliosWrapper.folio fleteNacional = P2G_CreacionFolios.getwrapper();
        P2G_CreacionFoliosWrapper.cargoLine cargo = P2G_CreacionFolios.getCargoline();
        Test.startTest(); 
        fleteNacional.numFoliosCrear = 1;
        fleteNacional.reference = 'prueba test';
        fleteNacional.grupo = 'SP-AW-GLOBAL AEREO';
        fleteNacional.etd = '2023-03-10';
        fleteNacional.eta = '2023-03-10';
        fleteNacional.team = 'P2G';
        fleteNacional.idSideLoad = quote.Site_of_Load__c;
        fleteNacional.idSideDischarged = quote.Site_of_Load__c;
        fleteNacional.idAccount = quote.Account_for__c;
        fleteNacional.Awaitingloadtime = '08:00:00.000';
        fleteNacional.Awaitingunloadtime = '18:00:00.000';
        fleteNacional.accountOriginAddress = quote.Account_Origin_Address__c;
        fleteNacional.accountDestinAddress = quote.Account_Origin_Address__c;
        fleteNacional.rurrencyIsoCode='MXN';
        fleteNacional.currencyIsoCode='MXN';
        fleteNacional.buyPrice = '345';
        fleteNacional.sellPrice = '785';
		fleteNacional.idConteinerType = quote.Container_Type__c;
        fleteNacional.border = 'Norte';
        fleteNacional.customs = 'Agua Prieta';
        fleteNacional.impak = 'Si';
        fleteNacional.servicioIMPAK = 'A';
        fleteNacional.salesIncoterm = 'CIP';
        fleteNacional.warehouseService = false;
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
		cargo.idConteinerType = quote.Container_Type__c;
        cargo.totalShipping = '146';
        cargo.MaterialPeligroso = '';
        cargo.Embalaje = '';
        cargo.idSST = sst.Id;
        cargo.length = '234';
        cargo.width = '242';
        cargo.height = '2445';
		cargo.weight = '324';
        List<P2G_CreacionFoliosWrapper.folio>creaFolios = P2G_creacionFolioInternacionales.creaFolios(fleteNacional, cargo);
        list<Quote_Item_Line__c> getCargoLine = P2G_creacionFolioInternacionales.getCargoLine(creaFolios[0].Id);
        list<Customer_Quote__c> getFolios = P2G_creacionFolioInternacionales.getFolios(creaFolios);
        Quote_Item_Line__c crearMasCargoLine = P2G_creacionFolioInternacionales.crearMasCargoLine(creaFolios,cargo);
        //Sourcing_Item__c creaItemAereos = P2G_creacionFolioInternacionales.creaItemAereos(quote.Account_for__c, cargo);
		P2G_CreacionFoliosWrapper.folio getwrapper2 = P2G_CreacionFoliosWrapper.getwrapper2();
    	P2G_CreacionFoliosWrapper.cargoLine getCargoline2 = P2G_CreacionFoliosWrapper.getCargoline2();
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
        fleteNacional.grupo = 'SP-T-CONSOLIDADO';
		fleteNacional = P2G_CreacionFoliosWrapper.tipoServicio(fleteNacional);
        Test.stopTest();
    }
}