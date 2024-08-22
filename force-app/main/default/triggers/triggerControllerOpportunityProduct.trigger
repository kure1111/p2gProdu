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
                    if((oli.Buy_Price__c !=  trigger.oldMap.get(oli.Id).Buy_Price__c) && ((oli.Status__c == 'Pendiente por Cotizar') || (oli.Status__c == 'Negociación con cliente'))){
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
                    oli.SLA_Cotiza_Pricing__c = tiempoTranscurridas + ' El Buy Price que se coloco es: $'+ oli.Buy_Price__c.format();
                }
                //llena el campo Datatime Negociacion y correo Pricing
                if(oli.Status__c == 'Negociación con cliente'){
                    oli.Data_Time_Negocia_Pricing__c = System.now();
                    P2G_correoPricingNegociacion.enviarCorreo(oli.Id);
                }
                //llena el campo SLA Negociacion Pricing
                if((trigger.oldMap.get(oli.Id).Status__c == 'Negociación con cliente') && (trigger.oldMap.get(oli.Id).Status__c != oli.Status__c)){
                    String tiempoTranscurridas = P2G_tiempoTranscurridoOppo.tiempoTranscurridoOli(oli.Data_Time_Negocia_Pricing__c,System.now());
                    oli.SLA_Negocia_Pricing__c = tiempoTranscurridas + ' El Buy Price que se coloco es: $'+ oli.Buy_Price__c.format();
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
            List<Quote> quoteLine = [SELECT id, Name, OpportunityId FROM Quote WHERE OpportunityId in: idOpportuniy AND Vendido__c = false AND Status != 'Accepted'];
            List<QuoteLineItem> qlis = new List<QuoteLineItem>();
            List<OpportunityLineItem> todosOlis = new List<OpportunityLineItem>();
            List<SubProducto__c> subproduct = new List<SubProducto__c>();
            List<QuoteLineItem> modificarQuoteLine = new List<QuoteLineItem>();
            List<QuoteLineItem> eliminarQuoteLine = new List<QuoteLineItem>();
            List<QuoteLineItem> insertarQuoteLine = new List<QuoteLineItem>();
            List<QuoteLineItem> modificarQuoteLineSub = new List<QuoteLineItem>();
            List<QuoteLineItem> eliminarQuoteLineSub = new List<QuoteLineItem>();
            List<QuoteLineItem> insertarQuoteLineSub = new List<QuoteLineItem>();
            if(quoteLine.size() > 0){
                qlis = P2G_sincrinizarConOppoProduct.todasQuoteLineItem(quoteLine);
                todosOlis = P2G_sincrinizarConOppoProduct.todasOpportunityLineItem(quoteLine);
                subproduct = P2G_sincrinizarConOppoProduct.todosSubproduct(quoteLine);
            }
            for(OpportunityLineItem oli : trigger.new){
                if((quoteLine.size() > 0) && ((oli.Quantity != trigger.oldMap.get(oli.Id).Quantity) || (oli.UnitPrice != trigger.oldMap.get(oli.Id).UnitPrice) || (oli.Status__c != trigger.oldMap.get(oli.Id).Status__c))){
                    System.debug('entra a modificar,eliminar o insertar');
                    modificarQuoteLine = P2G_sincrinizarConOppoProduct.modificarQuoteLine(qlis, todosOlis);
                    eliminarQuoteLine = P2G_sincrinizarConOppoProduct.eliminarQuoteLine(qlis, todosOlis);
                    insertarQuoteLine = P2G_sincrinizarConOppoProduct.insertarQuoteLine(modificarQuoteLine, todosOlis, quoteLine[0].Id);
                    if(subproduct.size() > 0){
                        modificarQuoteLineSub = P2G_sincrinizarConOppoProduct.modificarQuoteLineSub(qlis, subproduct);
                        eliminarQuoteLineSub = P2G_sincrinizarConOppoProduct.eliminarQuoteLineSub(qlis, subproduct);
                        insertarQuoteLineSub = P2G_sincrinizarConOppoProduct.insertarQuoteLineSub(modificarQuoteLine, subproduct, quoteLine[0].Id);
                    }
                }
            }
            if(modificarQuoteLine.size() > 0){
                update modificarQuoteLine;
            }
            if(eliminarQuoteLine.size() > 0){
                delete eliminarQuoteLine;
            }
            if(insertarQuoteLine.size() > 0){
                insert insertarQuoteLine;
            }
            if(modificarQuoteLineSub.size() > 0){
                update modificarQuoteLineSub;
            }
            if(eliminarQuoteLineSub.size() > 0){
                delete eliminarQuoteLineSub;
            }
            if(insertarQuoteLineSub.size() > 0){
                insert insertarQuoteLineSub;
            }
        }
    }
}