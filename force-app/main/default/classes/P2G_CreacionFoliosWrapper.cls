global class P2G_CreacionFoliosWrapper {
    public class folio{
        @AuraEnabled public String id{get;set;}
        @AuraEnabled public String Name{get;set;}
        @AuraEnabled public Integer numFoliosCrear{get;set;}
        @AuraEnabled public String comercioExterior{get;set;}
        @AuraEnabled public String freighMode{get;set;}
        @AuraEnabled public String serviceMode{get;set;}
        @AuraEnabled public String servicetype{get;set;}
        @AuraEnabled public String reference{get;set;}
        @AuraEnabled public String rurrencyIsoCode{get;set;}
        @AuraEnabled public String currencyIsoCode{get;set;}
        @AuraEnabled public String etd{get;set;} 
        @AuraEnabled public String eta{get;set;}
        @AuraEnabled public String team{get;set;}
        @AuraEnabled public String quotationStatus{get;set;}
        @AuraEnabled public String CommunityStatus{get;set;}
        @AuraEnabled public String Awaitingloadtime{get;set;}
        @AuraEnabled public String Awaitingunloadtime{get;set;}
        @AuraEnabled public String grupo{get;set;}
        @AuraEnabled public String border{get;set;}
        @AuraEnabled public String customs{get;set;}
        @AuraEnabled public String impak{get;set;}
        @AuraEnabled public String servicioIMPAK{get;set;}
        @AuraEnabled public String salesIncoterm{get;set;}
        @AuraEnabled public Boolean warehouseService{get;set;}
        //ids necesarios tomados del formulario
        @AuraEnabled public String idSideLoad{get;set;}
        @AuraEnabled public String idSideDischarged{get;set;}
        @AuraEnabled public String idAccount{get;set;}
        @AuraEnabled public String idReferenceForm{get;set;}
        @AuraEnabled public String recordTypeUnidad{get;set;}
        @AuraEnabled public String idConteinerType{get;set;}
        @AuraEnabled public String accountOriginAddress{get;set;}
        @AuraEnabled public String accountDestinAddress{get;set;}
        @AuraEnabled public String buyPrice{get;set;}
        @AuraEnabled public String sellPrice{get;set;}
        @AuraEnabled public String error{get;set;}
    }
    global class cargoLine{
        @AuraEnabled public String idQuote{get;set;}
        @AuraEnabled public String idItem{get;set;}
        @AuraEnabled public String idConteinerType{get;set;}//
        @AuraEnabled public String idClaveSat{get;set;}
        @AuraEnabled public String idItemSuplienerOwner{get;set;}
        @AuraEnabled public String extencionItemName{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public String currencyIsoCode{get;set;}
        @AuraEnabled public String units{get;set;}
        @AuraEnabled public String pesoBruto{get;set;}
        @AuraEnabled public String pesoNeto{get;set;}
        @AuraEnabled public String itemPrice{get;set;}
        @AuraEnabled public String totalShipping{get;set;}
        @AuraEnabled public String MaterialPeligroso{get;set;}
        @AuraEnabled public String Embalaje{get;set;}
        @AuraEnabled public String idSST{get;set;}
        @AuraEnabled public String length{get;set;}
        @AuraEnabled public String width{get;set;}
        @AuraEnabled public String height{get;set;}
        @AuraEnabled public String weight{get;set;}
        @AuraEnabled public String idFraccionArancelaria{get;set;}
        @AuraEnabled public String pedimento{get;set;}
    }
    public class namesIds{
        @AuraEnabled public Boolean vacio{get;set;}
        @AuraEnabled public String idQuote{get;set;}
        @AuraEnabled public String name{get;set;}   
    }
    global class folioMasivo{
        public folio folio{get;set;}  
        public cargoLine cargo{get;set;}
    }
        global class folioM{
        public List<Customer_Quote__c> folio{get;set;}  
        public List<cargoLine> cargo{get;set;}
    }
    @AuraEnabled
    public static P2G_CreacionFoliosWrapper.folio getwrapper2(){
        P2G_CreacionFoliosWrapper.folio fleteNacional = new P2G_CreacionFoliosWrapper.folio();
        fleteNacional.numFoliosCrear = 1;
        fleteNacional.Awaitingloadtime = '08:00:00.000';
        fleteNacional.Awaitingunloadtime = '18:00:00.000';
        System.debug('el wraper folio: '+fleteNacional);
        return fleteNacional;
    }
    @AuraEnabled
    public static P2G_CreacionFoliosWrapper.cargoLine getCargoline2(){
        P2G_CreacionFoliosWrapper.cargoLine cargo = new P2G_CreacionFoliosWrapper.cargoLine();
        return cargo;
    }
    @AuraEnabled
    public static list<SAP_Service_Type__c> getSapServiceType(string sapServiceT, String grupo){
        string searchKeyword = '%' + sapServiceT + '%';
        list<SAP_Service_Type__c> ListSapServiceT = [SELECT Id, Name FROM SAP_Service_Type__c 
                                              where Name LIKE : searchKeyword AND Group__c =: grupo limit 20];
        if(ListSapServiceT.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return ListSapServiceT;
    }
    public static folio tipoServicio(folio folio){
        System.debug('el grupo es: '+folio.grupo);
        switch on folio.grupo {
            when 'SP-FN-FLETE NACIONAL' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'P2G';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Road';
                folio.serviceMode = 'NATIONAL';
                folio.servicetype = 'FTL';
            }	
            when 'SP-FI-FLETE INTER' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'P2G';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Road';
            }
            when 'SP-A-AEREO' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'P2G';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Air';
                folio.servicetype = 'CARGA';
            }
            when 'SP-CE-COMERCIO EXT' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                //folio.team = 'P2G';
                folio.comercioExterior = 'Si';
            }
            when 'SP-M-MARITIMO' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'P2G';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Sea';
            }
            when 'SP-PTO-PUERTOS' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'P2G';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Road';
                folio.serviceMode = 'PORT';
            }
            when 'SP-R-GLOBAL ROUTIN' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'WCA';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Sea';
            }
            when 'SP-WH-ALMACENAJE' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'P2G';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Road';
                folio.warehouseService = true;
            }
            when 'SP-T-CONSOLIDADO' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'P2G';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Road';
                folio.serviceMode = 'NATIONAL';
                folio.servicetype = 'TARIMAS';
            }
            when 'SP-EX-SEGUROS' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'P2G';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Road';
                folio.serviceMode = 'NATIONAL';
                folio.servicetype = 'Extras';
            }
            when 'SP-W-GLOBAL MARITIMO' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'WCA';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Sea';
                folio.serviceMode = 'EXPORT';
            }
            when 'SP-AW-GLOBAL AEREO' {
                folio.quotationStatus = 'Sent awaiting response';
                folio.CommunityStatus = 'CUSTOMER CREATED';
                folio.team = 'WCA';
                folio.comercioExterior = 'No';
                folio.freighMode = 'Air';
                folio.serviceMode = 'EXPORT';
            }
            when else {
                System.debug('No hay grupo');
            }
		}
        return folio;
    }
}