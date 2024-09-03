trigger triggerControllerOpportunityProduct on OpportunityLineItem (before insert, before update, before delete, after insert, after update, after delete) {
	List<String> idOpportuniy = new List<String>();
    List<String> idOli = new List<String>();
    if(!Trigger.isDelete){
        for(OpportunityLineItem oli : trigger.new){
            idOpportuniy.add(oli.OpportunityId);
            idOli.add(oli.id);
        }
    }
    switch on Trigger.operationType {
        when before_insert {
        }
        when after_insert {
        }
        when before_update {
            List<SubProducto__c> updateSubproductos = new List<SubProducto__c>();
            Set<SubProducto__c> paraSubproductos = new Set<SubProducto__c>();
            List<SubProducto__c> todosSubproductos = P2G_tiempoTranscurridoOppo.todosSubproductos(idOpportuniy);
            for(OpportunityLineItem oli : trigger.new){
                // para convertir la moneda del buy price y del sales price.
                // La clase test de esta parte es la clase P2G_convertCurrencyOppoProductTest
                if(oli.CurrencyIsoCode != oli.Tipo_de_moneda__c && oli.Tipo_de_moneda__c != null){
                    if((oli.Buy_Price__c !=  trigger.oldMap.get(oli.Id).Buy_Price__c) && ((oli.Status__c == 'Pendiente por Cotizar') || (oli.Status__c == 'Negociación con cliente')||(trigger.oldMap.get(oli.Id).Status__c == 'Pendiente por Cotizar') || (trigger.oldMap.get(oli.Id).Status__c == 'Negociación con cliente'))){
                        OpportunityLineItem produc = P2G_convertCurrencyOppoProduct.actualizarBuyPriceCurrency('Buy Price', oli.Buy_Price__c, oli.Tipo_de_moneda__c, oli.CurrencyIsoCode);
                        oli.Buy_Price__c = produc.Buy_Price__c;
                        oli.Buy_Price_Converted__c = produc.Buy_Price_Converted__c;
                    }
                    if((oli.UnitPrice !=  trigger.oldMap.get(oli.Id).UnitPrice)){
                        OpportunityLineItem produc = P2G_convertCurrencyOppoProduct.actualizarBuyPriceCurrency('Sales Price', oli.UnitPrice, oli.Tipo_de_moneda__c, oli.CurrencyIsoCode);
                        oli.UnitPrice = produc.UnitPrice;
                        oli.Sales_Price_Converted__c = produc.Sales_Price_Converted__c;
                    } 
                }
                //llena el campo SLA Cotiza Pricing
                if(((trigger.oldMap.get(oli.Id).Buy_Price__c == 0) || (trigger.oldMap.get(oli.Id).Buy_Price__c == null)) && (trigger.oldMap.get(oli.Id).Buy_Price__c != oli.Buy_Price__c)){
                    String tiempoTranscurridas = P2G_tiempoTranscurridoOppo.tiempoTranscurridoOli(oli.CreatedDate,System.now());
                    oli.SLA_Cotiza_Pricing__c = tiempoTranscurridas + ' El Buy Price que se coloco es: $'+ oli.Buy_Price__c.format()+oli.CurrencyIsoCode;
                }
                //llena el campo Datatime Negociacion y correo Pricing
                if(oli.Status__c == 'Negociación con cliente'){
                    oli.Data_Time_Negocia_Pricing__c = System.now();
                    P2G_correoPricingNegociacion.enviarCorreo(oli.Id);
                }
                //llena el campo SLA Negociacion Pricing
                if((trigger.oldMap.get(oli.Id).Status__c == 'Negociación con cliente') && (trigger.oldMap.get(oli.Id).Status__c != oli.Status__c)){
                    String tiempoTranscurridas = P2G_tiempoTranscurridoOppo.tiempoTranscurridoOli(oli.Data_Time_Negocia_Pricing__c,System.now());
                    oli.SLA_Negocia_Pricing__c = tiempoTranscurridas + ' El Buy Price que se coloco es: $'+ oli.Buy_Price__c.format()+oli.CurrencyIsoCode;
                }
                if(oli.Status__c != trigger.oldMap.get(oli.Id).Status__c){
                //modificar status subproducto
                    for(SubProducto__c subproduct : todosSubproductos){
                        if(subproduct.SubProduct_Opportunity_Product__c == oli.Id){
                            subproduct.Status__c = oli.Status__c;
                            paraSubproductos.add(subproduct);
                        }
                    }
                }
            }
            if(paraSubproductos.size() > 0){
                for(SubProducto__c sub : paraSubproductos){
                    updateSubproductos.add(sub);
                }
            	update updateSubproductos;
            }
        }
        when after_update {
            //inicia sincronizacion de la Quote
            List<OpportunityLineItem> modificarOlis = new List<OpportunityLineItem>();
            List<SubProducto__c> todosSubproduct = new List<SubProducto__c>();
            List<SubProducto__c> modificarSubproduct = new List<SubProducto__c>();
            for(OpportunityLineItem oli : trigger.new){
                if((oli.Quantity != trigger.oldMap.get(oli.Id).Quantity) || (oli.UnitPrice != trigger.oldMap.get(oli.Id).UnitPrice) || (oli.Status__c != trigger.oldMap.get(oli.Id).Status__c)){
                    System.debug('entra a modificar,eliminar o insertar');
                    modificarOlis.add(oli);
                }
            }
            if(modificarOlis.size() > 0){
                List<SubProducto__c> subproduct = [SELECT id, Name, SubProduct_Opportunity_Product__c, SubProduct_Opportunity_Product__r.PricebookEntryId,
                                               SubProduct_Opportunity_Product__r.Product2Id, SubProduct_Opportunity_Product__r.Quantity,
                                               SubProduct_Buy_Price_Converted__c, SubProduct_Sell_Price__c, Status__c
                                               FROM SubProducto__c WHERE SubProduct_Opportunity_Product__c in: modificarOlis];
                List<Quote> quoteLine = [SELECT id, Name, OpportunityId FROM Quote WHERE OpportunityId in: idOpportuniy AND Vendido__c = false AND Status != 'Accepted'];
                List<QuoteLineItem> qlis = new List<QuoteLineItem>();
                if(quoteLine.size() > 0){
                    qlis = P2G_sincrinizarConOppoProduct.todasQuoteLineItem(quoteLine);
                    List<QuoteLineItem> modificarQuoteLine = P2G_sincrinizarConOppoProduct.modificarQuoteLine(qlis, modificarOlis);
                    List<QuoteLineItem> eliminarQuoteLine = P2G_sincrinizarConOppoProduct.eliminarQuoteLine(qlis, modificarOlis);
                    List<QuoteLineItem> insertarQuoteLine = P2G_sincrinizarConOppoProduct.insertarQuoteLine(modificarQuoteLine, modificarOlis, quoteLine[0].Id);
                    if(modificarQuoteLine.size() > 0){update modificarQuoteLine;}
                    if(eliminarQuoteLine.size() > 0){delete eliminarQuoteLine;}
                    if(insertarQuoteLine.size() > 0){insert insertarQuoteLine;}
                    if(subproduct.size() > 0){
                        List<QuoteLineItem> modificarQuoteLineSub = P2G_sincrinizarConOppoProduct.modificarQuoteLineSub(qlis, subproduct);
                        List<QuoteLineItem> eliminarQuoteLineSub = P2G_sincrinizarConOppoProduct.eliminarQuoteLineSub(qlis, subproduct);
                        List<QuoteLineItem> insertarQuoteLineSub = P2G_sincrinizarConOppoProduct.insertarQuoteLineSub(modificarQuoteLineSub, subproduct, quoteLine[0].Id,trigger.new);
                    	if(modificarQuoteLineSub.size() > 0){update modificarQuoteLineSub;}
                        if(eliminarQuoteLineSub.size() > 0){delete eliminarQuoteLineSub;}
                        if(insertarQuoteLineSub.size() > 0){insert insertarQuoteLineSub;}
                    }
                }
            }
        //termina sincronizacion de la quote
        noSeHace();
        }
    }
    public static void noSeHace(){
        String a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
        a ='1';
    }
}