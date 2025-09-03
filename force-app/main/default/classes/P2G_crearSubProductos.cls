public class P2G_crearSubProductos {
	public class wrapperSubProducto{
        @AuraEnabled public String id{get;set;}
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String currencyIsoCode{get;set;}
        @AuraEnabled public String tipoMoneda{get;set;}
        @AuraEnabled public String asesoria{get;set;}
        @AuraEnabled public String buyPrice{get;set;}
        @AuraEnabled public String sellPrice{get;set;}
        @AuraEnabled public String comercializadora{get;set;}
        @AuraEnabled public String despacho{get;set;}
        @AuraEnabled public String detalles{get;set;}
        @AuraEnabled public String lenght{get;set;}
        @AuraEnabled public String width{get;set;}
        @AuraEnabled public String height{get;set;}
        @AuraEnabled public Boolean hazmat{get;set;} 
        @AuraEnabled public Boolean reefer{get;set;}
        @AuraEnabled public String seguroContenedor{get;set;}
        @AuraEnabled public String seguroMercancia{get;set;}
        @AuraEnabled public String temperatura{get;set;}
        @AuraEnabled public String escalaTemperatura{get;set;}
        @AuraEnabled public Boolean trasborda{get;set;}
        @AuraEnabled public String units{get;set;}
        @AuraEnabled public String grupo{get;set;}
        @AuraEnabled public String idOpoProduct{get;set;}
        @AuraEnabled public String idOportunidad{get;set;}
        @AuraEnabled public String idSapServiceType{get;set;}
        @AuraEnabled public String idSapServiceTypeBuy{get;set;}
        @AuraEnabled public String error{get;set;}
    }
    @AuraEnabled
    public static wrapperSubProducto getWrapper(){
        wrapperSubProducto wrapper = new wrapperSubProducto();
        return wrapper;
    }
    @AuraEnabled(cacheable=true)
    public static list<SubProducto__c> getSubProductOppo(String idOppo){
        list<SubProducto__c> ListSubProduct = [SELECT Id, Name, SubProduct_SAP_Service_Type__r.Name, SubProduct_Buy_Price__c, CurrencyIsoCode,
        									 SubProduct_Sell_Price__c, SubProduct_Opportunity_Product__r.Ruta__c,SubProduct_Opportunity__r.Group__c
                                             FROM SubProducto__c WHERE SubProduct_Opportunity__c =: idOppo];
        return ListSubProduct;
    }
    @AuraEnabled(cacheable=true)
    public static list<SubProducto__c> getSubProductProduct(String idProduct){
        list<SubProducto__c> ListSubProduct = [SELECT Id, Name, SubProduct_SAP_Service_Type__r.Name, SubProduct_Buy_Price__c,
        									 SubProduct_Sell_Price__c, SubProduct_Opportunity__r.Name, SubProduct_Opportunity__r.Group__c
                                             FROM SubProducto__c WHERE SubProduct_Opportunity_Product__c =: idProduct];
        return ListSubProduct;
    }
    @AuraEnabled(cacheable=true)
    public static list<OpportunityLineItem> getOppoProduct(String idOppo){
        list<OpportunityLineItem> ListOli = [SELECT Id, Name, OpportunityId, Opportunity.Group__c, Ruta__c
                                             FROM OpportunityLineItem WHERE OpportunityId =: idOppo];
        return ListOli;
    }
    @AuraEnabled(cacheable=true)
    public static OpportunityLineItem infoProduct(String idProduct){
        OpportunityLineItem oli = [SELECT Id, Name, OpportunityId, Opportunity.Group__c, Ruta__c,CurrencyIsoCode
                                             FROM OpportunityLineItem WHERE id =: idProduct Limit 1];
        return oli;
    }
    @AuraEnabled(cacheable=true)
    public static list<Sap_Service_Type__c> getSapServiceType(String sst,String idOppo){
        Opportunity oppo = [SELECT Id, Group__c FROM Opportunity WHERE id =: idOppo Limit 1];
        String buscar = '%' + sst + '%';
        list<Sap_Service_Type__c> ListContainerType = [SELECT Id, Name, Group__c FROM Sap_Service_Type__c 
                                                       WHERE Name LIKE : buscar AND Group__c =: oppo.Group__c limit 10];
        if(ListContainerType.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return ListContainerType;
    }
    @AuraEnabled
    public static wrapperSubProducto crearSubProducto(wrapperSubProducto wrapper){
        try{
            SubProducto__c subproducto = rellenaSubProducto(wrapper);
        	insert subproducto;
            wrapper.error = 'Sin Error';
        }
        catch(Exception e){
            wrapper.error='Error al crear el sub producto: '+e.getMessage()+e.getLineNumber();
            System.debug('Error al crear el sub producto: '+e.getMessage()+e.getLineNumber());     
        }
        return wrapper;
    }
    public static SubProducto__c rellenaSubProducto(wrapperSubProducto wrapper){
        SubProducto__c sub = new SubProducto__c();
        sub.Name = wrapper.name;
        sub.CurrencyIsoCode = wrapper.currencyIsoCode;
        sub.Tipo_de_moneda__c = wrapper.tipoMoneda;
        sub.SubProduct_Buy_Price__c = Decimal.valueOf(wrapper.buyPrice);
        sub.SubProduct_Sell_Price__c = Decimal.valueOf(wrapper.sellPrice);
        sub.SubProduct_Opportunity_Product__c = wrapper.idOpoProduct;
        sub.SubProduct_Opportunity__c = wrapper.idOportunidad;
        sub.SubProduct_SAP_Service_Type__c = !String.isBlank(wrapper.idSapServiceType) ? wrapper.idSapServiceType : null;
        sub.SAP_Service_Type_Buy__c = !String.isBlank(wrapper.idSapServiceTypeBuy) ? wrapper.idSapServiceTypeBuy : null;
        sub.SubProduct_Grupo_Oportunidad__c = wrapper.grupo;
        sub.SubProduct_Asesoria__c = !String.isBlank(wrapper.asesoria) ? wrapper.asesoria : null;
        sub.SubProduct_Comercializadora__c = !String.isBlank(wrapper.comercializadora) ? wrapper.comercializadora : null;
        sub.SubProduct_Despacho__c = !String.isBlank(wrapper.despacho) ? wrapper.despacho : null;
        sub.SubProduct_Detalles__c = !String.isBlank(wrapper.detalles) ? wrapper.detalles : null;
        sub.Item_Lenght__c = !String.isBlank(wrapper.lenght) ? Decimal.valueOf(wrapper.lenght) : null;
        sub.Item_Width__c = !String.isBlank(wrapper.width) ? Decimal.valueOf(wrapper.width) : null;
        sub.Item_Height__c = !String.isBlank(wrapper.height) ? Decimal.valueOf(wrapper.height) : null;
        if(wrapper.hazmat !=null ){
            sub.SubProduct_Hazmat__c = wrapper.hazmat;}
        if(wrapper.reefer != null){
            sub.SubProduct_Reefer__c = wrapper.reefer;}
        sub.SubProduct_SeguroContenedor__c = !String.isBlank(wrapper.seguroContenedor) ? Decimal.valueOf(wrapper.seguroContenedor) : null;
        sub.SubProduct_SeguroMercancia__c = !String.isBlank(wrapper.seguroMercancia) ? Decimal.valueOf(wrapper.seguroMercancia) : null;
        sub.SubProduct_Temperatura__c = !String.isBlank(wrapper.temperatura) ? wrapper.temperatura : null;
        if(wrapper.trasborda != null){
            sub.SubProduct_Trasborda__c = wrapper.trasborda;}
        sub.SubProduct_Units__c = !String.isBlank(wrapper.units) ? Decimal.valueOf(wrapper.units) : null;
        sub.Escala_de_Temperatura__c = !String.isBlank(wrapper.escalaTemperatura) ? wrapper.escalaTemperatura : null;
        return sub;
    }
    public Static void cambiarStatus(String idProduct){
        List<SubProducto__c> listSub = [SELECT id, Name, Status__c FROM SubProducto__c WHERE SubProduct_Opportunity_Product__c =: idProduct];  
    }
}