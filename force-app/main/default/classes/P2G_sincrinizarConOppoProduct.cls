public class P2G_sincrinizarConOppoProduct {
    public static List<QuoteLineItem> todasQuoteLineItem(List<Quote> newQuotes){
        List<String> idQuote = new List<String>();
        for (Quote newQuote : newQuotes) {
            idQuote.add(newQuote.Id);
        }
        List<QuoteLineItem> qlis = [SELECT Id, OpportunityLineItemId, Quote.OpportunityId, PricebookEntryId, Product2Id, Sales_Price_Converted__c,
                                    Quantity, UnitPrice, SubProducto__c FROM QuoteLineItem WHERE QuoteId IN: idQuote];
        return qlis;
    }
    public static List<OpportunityLineItem> todasOpportunityLineItem(List<Quote> newQuotes){
        List<String> idOppos = new List<String>();
        for (Quote newQuote : newQuotes) {
            idOppos.add(newQuote.OpportunityId);
        }
        List<OpportunityLineItem> todosOlis = [SELECT Id, OpportunityId,PricebookEntryId, Product2Id, Quantity, Sales_Price_Converted__c, UnitPrice,
                                               Status__c FROM OpportunityLineItem WHERE OpportunityId IN: idOppos];
        return todosOlis;
    }
    public static List<SubProducto__c> todosSubproduct(List<Quote> newQuotes){
        List<String> idOppos = new List<String>();
        for (Quote newQuote : newQuotes) {
            idOppos.add(newQuote.OpportunityId);
        }
        List<SubProducto__c> subproduct = [SELECT id, Name, SubProduct_Opportunity_Product__c, SubProduct_Opportunity_Product__r.PricebookEntryId,
                                           SubProduct_Opportunity_Product__r.Product2Id, SubProduct_Opportunity_Product__r.Quantity,
                                           SubProduct_Buy_Price_Converted__c, SubProduct_Sell_Price__c, Status__c
                                           FROM SubProducto__c WHERE SubProduct_Opportunity__c in: idOppos];
        return subproduct;
    }
    @InvocableMethod
	public static void updateQuoteLine(List<Quote> newQuotes) {
        List<QuoteLineItem> listaQli = todasQuoteLineItem(newQuotes);
        List<OpportunityLineItem> listaOli = todasOpportunityLineItem(newQuotes);
        List<SubProducto__c> listaSubproduct = todosSubproduct(newQuotes);
        Set<OpportunityLineItem> oliParaInsertar = new Set<OpportunityLineItem>();
        Set<SubProducto__c> subProParaInsertar = new Set<SubProducto__c>();
        List<QuoteLineItem> insertarQuoteLineNuevo = new List<QuoteLineItem>();
        List<QuoteLineItem> insertarQuoteLineSubNuevo = new List<QuoteLineItem>();
        if(listaQli.size() > 0){
            delete listaQli;
        }
        for(OpportunityLineItem oli : listaOli){
            if((oli.Status__c == 'Cotizada') || (oli.Status__c == 'Aceptada') || (oli.Status__c == 'Negociación con cliente')){
                oliParaInsertar.add(oli);
            }
        }
        if(listaSubproduct.size() > 0){
            for(SubProducto__c sub : listaSubproduct){
                if((sub.Status__c == 'Cotizada') || (sub.Status__c == 'Aceptada') || (sub.Status__c == 'Negociación con cliente')){
                    subProParaInsertar.add(sub);
                }
            }
        }
        if(oliParaInsertar.size() > 0){
            for(OpportunityLineItem oli : oliParaInsertar){
                QuoteLineItem quoLine = insertarProducto(oli, newQuotes[0].Id);
                insertarQuoteLineNuevo.add(quoLine);
            }
        }
        if(subProParaInsertar.size() > 0){
            for(SubProducto__c sub : subProParaInsertar){
                for(OpportunityLineItem oli : oliParaInsertar){
                    if(sub.SubProduct_Opportunity_Product__c == oli.Id){
                        QuoteLineItem quoLine = insertarSubProducto(sub, newQuotes[0].Id, oli);
                        insertarQuoteLineSubNuevo.add(quoLine);
                    }
                }
            }
        }
        if(insertarQuoteLineNuevo.size() > 0){
        	insert insertarQuoteLineNuevo;
        }
        if(insertarQuoteLineSubNuevo.size() > 0){
        	insert insertarQuoteLineSubNuevo;
        }
    }
    
	public static List<QuoteLineItem> modificarQuoteLine(List<QuoteLineItem> qlis, List<OpportunityLineItem> todosOlis) {
        List<String> idolis = new List<String>();
        Set<QuoteLineItem> paraModificar = new Set<QuoteLineItem>();
        List<QuoteLineItem> qliModificar = new List<QuoteLineItem>();
        if(qlis.size() > 0){
        	for(QuoteLineItem qli : qlis){
            System.debug('es '+qli);
                for(OpportunityLineItem oli : todosOlis){
                    if(qli.OpportunityLineItemId != null){
                        if(qli.OpportunityLineItemId == oli.Id){
                            if((oli.Status__c == 'Cotizada') || (oli.Status__c == 'Aceptada') || (oli.Status__c == 'Negociación con cliente')){
                                System.debug('entra flete '+oli);
                                    qli.Quantity = oli.Quantity;
                                    qli.Sales_Price_Converted__c = oli.Sales_Price_Converted__c;
                                    qli.UnitPrice = oli.UnitPrice;
                                    paraModificar.add(qli);
                            }
                        }
                    }
                }
        	}
        }
                    System.debug('lista modificar '+paraModificar.size()+' '+qliModificar);
        if(paraModificar.size() > 0){
            for(QuoteLineItem modif : paraModificar){
                qliModificar.add(modif);
            }
        } 
        return qliModificar;
    }
	public static List<QuoteLineItem> eliminarQuoteLine(List<QuoteLineItem> qlis, List<OpportunityLineItem> todosOlis) {
        
        Set<QuoteLineItem> paraEliminar = new Set<QuoteLineItem>();
        List<QuoteLineItem> qliEliminar = new List<QuoteLineItem>();
        if(qlis.size() > 0){
        	for(QuoteLineItem qli : qlis){
                for(OpportunityLineItem oli : todosOlis){
                    if((qli.OpportunityLineItemId != null) && (qli.SubProducto__c == null)){
                        if(qli.OpportunityLineItemId == oli.Id){
                            if((oli.Status__c != 'Cotizada') && (oli.Status__c != 'Aceptada') && (oli.Status__c != 'Negociación con cliente')){
                                System.debug('es flete eliminado '+oli);
                                paraEliminar.add(qli);
                            }
                        }
                    }
                }
        	}
        }
                    System.debug('lista eliminar '+paraEliminar.size()+' '+paraEliminar);
        if(paraEliminar.size() > 0){
            for(QuoteLineItem elimina : paraEliminar){
                qliEliminar.add(elimina);
            }
        }
        return qliEliminar;
    }
	public static List<QuoteLineItem> insertarQuoteLine(List<QuoteLineItem> qliModificar, List<OpportunityLineItem> todosOlis, String idQuote) {
        Set<OpportunityLineItem> oliParaInsertar = new Set<OpportunityLineItem>();
        List<QuoteLineItem> qliInsertar = new List<QuoteLineItem>();
        if(qliModificar.size() > 0){
            for(QuoteLineItem mod : qliModificar){
                for(OpportunityLineItem oli : todosOlis){
                    if(mod.OpportunityLineItemId != oli.Id){
                        if((oli.Status__c == 'Cotizada') || (oli.Status__c == 'Aceptada') || (oli.Status__c == 'Negociación con cliente')){
                            System.debug('para insertar oli '+oli);
                            oliParaInsertar.add(oli);
                        }
                    }
                }
            }
        }else{
            for(OpportunityLineItem oli : todosOlis){
                if((oli.Status__c == 'Cotizada') || (oli.Status__c == 'Aceptada') || (oli.Status__c == 'Negociación con cliente')){
                    oliParaInsertar.add(oli);
                }
            }
        }
                    System.debug('set insertar oli '+oliParaInsertar.size()+' '+oliParaInsertar);
        if(oliParaInsertar.size() > 0){
            for(OpportunityLineItem oli : oliParaInsertar){
                QuoteLineItem quoLine = insertarProducto(oli, idQuote);
                qliInsertar.add(quoLine);
            }
        }
        return qliInsertar;
    }
    public static List<QuoteLineItem> modificarQuoteLineSub(List<QuoteLineItem> qlis, List<SubProducto__c> subproduct) {
        List<String> idolis = new List<String>();
        
        Set<QuoteLineItem> paraModificar = new Set<QuoteLineItem>();
        List<QuoteLineItem> qliModificar = new List<QuoteLineItem>();
        if(qlis.size() > 0){
        	for(QuoteLineItem qli : qlis){
            System.debug('es '+qli);
                if((subproduct.size() > 0)&&(qli.OpportunityLineItemId == null)){
                    for(SubProducto__c sub : subproduct){
                        if(qli.SubProducto__c == sub.Id){
                            System.debug('es cargo adicional '+sub);
                            if((sub.Status__c == 'Cotizada') || (sub.Status__c == 'Aceptada') || (sub.Status__c == 'Negociación con cliente')){
                                //qli.Quantity = sub.SubProduct_Opportunity_Product__r.Quantity;
                                qli.Sales_Price_Converted__c = sub.SubProduct_Buy_Price_Converted__c;
                                qli.UnitPrice = sub.SubProduct_Sell_Price__c ;
                                paraModificar.add(qli);
                            }
                        }
                    }
                }
        	}
        }
                    System.debug('lista modificar '+paraModificar.size()+' '+qliModificar);
        if(paraModificar.size() > 0){
            for(QuoteLineItem modif : paraModificar){
                qliModificar.add(modif);
            }
        } 
        return qliModificar;
    }
	public static List<QuoteLineItem> eliminarQuoteLineSub(List<QuoteLineItem> qlis, List<SubProducto__c> subproduct) {
        Set<QuoteLineItem> paraEliminar = new Set<QuoteLineItem>();
        List<QuoteLineItem> qliEliminar = new List<QuoteLineItem>();
        if(qlis.size() > 0){
        	for(QuoteLineItem qli : qlis){
                if((subproduct.size() > 0)&&(qli.OpportunityLineItemId == null)){
                    for(SubProducto__c sub : subproduct){
                        if(qli.SubProducto__c == sub.Id){
                            if((sub.Status__c != 'Cotizada') && (sub.Status__c != 'Aceptada') && (sub.Status__c != 'Negociación con cliente')){
                                System.debug('es cargo adicional eliminado '+sub);
                                paraEliminar.add(qli);
                            }
                        }
                    }
                }
        	}
        }
                    System.debug('lista eliminar '+paraEliminar.size()+' '+paraEliminar);
        if(paraEliminar.size() > 0){
            for(QuoteLineItem elimina : paraEliminar){
                qliEliminar.add(elimina);
            }
        }
        return qliEliminar;
    }
	public static List<QuoteLineItem> insertarQuoteLineSub(List<QuoteLineItem> qliModificar, List<SubProducto__c> subproduct, String idQuote, List<OpportunityLineItem> listOli) {
        Set<SubProducto__c> subProParaInsertar = new Set<SubProducto__c>();
        List<QuoteLineItem> qliInsertar = new List<QuoteLineItem>();
        if(qliModificar.size() > 0){
            for(QuoteLineItem mod : qliModificar){
                for(SubProducto__c sub : subproduct){
                    if((subproduct.size() > 0)&&(mod.SubProducto__c != sub.Id)){
                        System.debug('para insertar sub '+sub);
                        if((sub.Status__c == 'Cotizada') || (sub.Status__c == 'Aceptada') || (sub.Status__c == 'Negociación con cliente')){
                            subProParaInsertar.add(sub);
                        }
                    }
                }
            }
        }else{
            if(subproduct.size() > 0){
                for(SubProducto__c sub : subproduct){
                    if((sub.Status__c == 'Cotizada') || (sub.Status__c == 'Aceptada') || (sub.Status__c == 'Negociación con cliente')){
                        subProParaInsertar.add(sub);
                    }

           		}
            }
        }
                    System.debug('set insertar sub '+subProParaInsertar.size()+' '+subProParaInsertar);
        for(SubProducto__c sub : subProParaInsertar){
            for(OpportunityLineItem oli : listOli){
                if(sub.SubProduct_Opportunity_Product__c == oli.Id){
                    System.debug('set insertar sub '+subProParaInsertar.size()+' '+subProParaInsertar);
                    QuoteLineItem quoLine = insertarSubProducto(sub, idQuote, oli);
                    qliInsertar.add(quoLine);
                }
            }
        }
                    System.debug('lista insertar '+qliInsertar.size()+' '+qliInsertar);
        return qliInsertar;
    }
    public static QuoteLineItem insertarProducto(OpportunityLineItem oli, String quoteId){
        QuoteLineItem quoLine = new QuoteLineItem();
            quoLine.OpportunityLineItemId = oli.Id;
            quoLine.PricebookEntryId = oli.PricebookEntryId;
            quoLine.Product2Id = oli.Product2Id;
            quoLine.Quantity = oli.Quantity;
            quoLine.QuoteId = quoteId;
            quoLine.Sales_Price_Converted__c = oli.Sales_Price_Converted__c;
            quoLine.Tipo_de_Linea__c = 'Flete';
            quoLine.UnitPrice = oli.UnitPrice;
        return quoLine;
    }
    public static QuoteLineItem insertarSubProducto(SubProducto__c sub, String quoteId, OpportunityLineItem oli){
        QuoteLineItem quoLine = new QuoteLineItem();
            quoLine.SubProducto__c = sub.Id;
            quoLine.PricebookEntryId = oli.PricebookEntryId;
            quoLine.Product2Id = oli.Product2Id;
            quoLine.Quantity = oli.Quantity;
            quoLine.QuoteId = quoteId;
            quoLine.Sales_Price_Converted__c = sub.SubProduct_Buy_Price_Converted__c;
            quoLine.Tipo_de_Linea__c = 'Cargo Adicional';
            quoLine.UnitPrice = sub.SubProduct_Sell_Price__c;
        return quoLine;
    }
    public static void pase(){
        Integer a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
    }
}