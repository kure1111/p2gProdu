global class P2G_CreacionFoliosWrapper {
    public class folio{
        @AuraEnabled public Integer numFoliosCrear{get;set;}
        @AuraEnabled public String comercioExterior{get;set;}
        @AuraEnabled public String freighMode{get;set;}
        @AuraEnabled public String serviceMode{get;set;}
        @AuraEnabled public String servicetype{get;set;}
        @AuraEnabled public String reference{get;set;}
        @AuraEnabled public String rurrencyIsoCode{get;set;}
        @AuraEnabled public String etd{get;set;} 
        @AuraEnabled public String eta{get;set;}
        @AuraEnabled public String team{get;set;}
        @AuraEnabled public String quotationStatus{get;set;}
        @AuraEnabled public String CommunityStatus{get;set;}
        @AuraEnabled public String Awaitingloadtime{get;set;}
        @AuraEnabled public String Awaitingunloadtime{get;set;}
        @AuraEnabled public String AccountOriginAddress{get;set;}
        @AuraEnabled public String AccountDestinAddress{get;set;}
        //ids necesarios tomados del formulario
        @AuraEnabled public String idSideLoad{get;set;}
        @AuraEnabled public String idSideDischarged{get;set;}
        @AuraEnabled public String idAccount{get;set;}
        @AuraEnabled public String idReferenceForm{get;set;}
        @AuraEnabled public String recordTypeUnidad{get;set;}
        @AuraEnabled public String idConteinerType{get;set;}//
    }
    global class cargoLine{
        @AuraEnabled public String idQuote{get;set;}
        @AuraEnabled public String idItem{get;set;}
        @AuraEnabled public String idConteinerType{get;set;}//
        @AuraEnabled public String idClaveSat{get;set;}
        @AuraEnabled public String idItemSuplienerOwner{get;set;} //id account //
        
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
}