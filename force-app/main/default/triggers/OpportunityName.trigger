trigger OpportunityName on Opportunity (before insert, before update) {
    System.debug('OpportunityName IN');      
   //Lectura de Account
    Set<Id> setAccounts = new Set<Id>();
    Map<Id, String> mapAccount = new Map<Id, String>();
    List<String> idOpportuniy = new List<String>();
    for(Opportunity op :Trigger.New){
        if(op.AccountId != null){
            setAccounts.add(op.AccountId);
        }
        idOpportuniy.add(op.Id);
    }
    for(Account a : [SELECT Id, Name FROM Account WHERE Id IN:setAccounts]){
        mapAccount.put(a.Id, a.Name);
    }
    //Lectura de Owner
    Set<Id> setOwner = new Set<Id>();
    Map<Id, String> mapOwnerOpp = new Map<Id, String>();
      for(Opportunity op :Trigger.New){
        if(op.OwnerId != null){
            setOwner.add(op.OwnerId);
            }
        }
    
      for(User b : [SELECT Id, Name FROM User WHERE Id IN:setOwner]){
        mapOwnerOpp.put(b.Id, b.Name);
    }
    List<OpportunityLineItem> todosProductos = P2G_tiempoTranscurridoOppo.todosProductos(idOpportuniy);
    List<SubProducto__c> todosSubproductos = P2G_tiempoTranscurridoOppo.todosSubproductos(idOpportuniy);
    //Actualización del Campo
    for(Opportunity op : Trigger.New){
        if(op.AccountId != null && op.Service_Type__c != null){
            String tipoServicio = P2G_reporteProductosOportunidad.modificarServicio(op.Service_Type__c);
    		String elGrupo = getGroup (tipoServicio);
           	op.Name = tipoServicio + ' - ' + mapAccount.get(op.AccountId)+ ' - ' + mapOwnerOpp.get(op.OwnerId) + ' - ' + op.Opportunity_Record_Number__c;
        	op.Group__c = elGrupo;
        }
    }
    if (Trigger.isinsert) {
        if (Trigger.isBefore) {
            for(Opportunity op : Trigger.New){
        		system.debug('op ' + op);
                if((op.Group__c == 'SP-PQ-PAQUETERIA')||(op.Group__c == 'SP-WH-ALMACENAJE')||(op.Group__c == 'SP-T-CONSOLIDADO')){
                    Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'Paqueteria'];
                    op.Pricebook2Id = pb.id;
                    system.debug('pb ' + pb);
                }else{
                    Pricebook2 pb = new Pricebook2(Name = op.name, IsActive = true, Description = 'Auto- Generado');
                    insert pb;
                    op.Pricebook2Id = pb.id;
                    system.debug('pb ' + pb);
                }
            }
        }
    }
    if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            for(Opportunity op : Trigger.New){
                if(trigger.oldMap.get(op.Id).StageName != op.StageName){
                    String tiempoTranscurrido = P2G_tiempoTranscurridoOppo.etapa(trigger.oldMap.get(op.Id));
                    System.debug('Etapa para colocar el tiempo '+ trigger.oldMap.get(op.Id).StageName);
                    switch on trigger.oldMap.get(op.Id).StageName {
                        when 'Entendimiento' {
                            op.SLA_Entendimiento__c = tiempoTranscurrido;
                        }	
                        when 'Cotización' {
                            op.SLA_Cotizacion__c = tiempoTranscurrido;
                        }
                        when 'Negociación' {
                            op.SLA_Negociacion__c = tiempoTranscurrido;
                        }
                        
                        when 'Ejecución'{
                            op.SLA_Ejecucion__c = tiempoTranscurrido;
                        }
                        when else {
                            System.debug('No existe esa etapa');
                        }
                    }
                    if((op.Group__c == 'SP-PQ-PAQUETERIA')||(op.Group__c == 'SP-WH-ALMACENAJE')||(op.Group__c == 'SP-T-CONSOLIDADO')){
                        switch on op.StageName {
                            when 'Negociación' {
                                if(op.Data_Time_Cotizacion__c == null){
                                    op.Data_Time_Cotizacion__c = System.now();
                                }
                                if(op.Data_Time_Negociacion__c == null){
                                    op.Data_Time_Negociacion__c = System.now();
                                    if(op.SLA_Cotizacion__c == null){
                                        DateTime fechaActual = System.now();
                                        tiempoTranscurrido = P2G_tiempoTranscurridoOppo.tiempoTranscurridas(op.Data_Time_Cotizacion__c, fechaActual, op.CreatedDate);
                                        op.SLA_Cotizacion__c = tiempoTranscurrido;
                                    }
                                }
                            }
                            when 'Ejecución' {
                                if(op.Data_Time_Cotizacion__c == null){
                                    op.Data_Time_Cotizacion__c = System.now();
                                }
                                if(op.Data_Time_Negociacion__c == null){
                                    op.Data_Time_Negociacion__c = System.now();
                                    if(op.SLA_Cotizacion__c == null){
                                        DateTime fechaActual = System.now();
                                        tiempoTranscurrido = P2G_tiempoTranscurridoOppo.tiempoTranscurridas(op.Data_Time_Cotizacion__c, fechaActual, op.CreatedDate);
                                        op.SLA_Cotizacion__c = tiempoTranscurrido;
                                    }
                                }
                                if(op.Data_Time_Ejecucion__c == null){
                                    op.Data_Time_Ejecucion__c = System.now();
                                    if(op.SLA_Negociacion__c == null){
                                        DateTime fechaActual = System.now();
                                        tiempoTranscurrido = P2G_tiempoTranscurridoOppo.tiempoTranscurridas(op.Data_Time_Negociacion__c, fechaActual, op.CreatedDate);
                                        op.SLA_Negociacion__c = tiempoTranscurrido;
                                    }
                                }
                            }
                            when 'Ganada' {
                                if(op.Data_Time_Cotizacion__c == null){
                                    op.Data_Time_Cotizacion__c = System.now();
                                }
                                if(op.Data_Time_Negociacion__c == null){
                                    op.Data_Time_Negociacion__c = System.now();
                                    if(op.SLA_Cotizacion__c == null){
                                        DateTime fechaActual = System.now();
                                        tiempoTranscurrido = P2G_tiempoTranscurridoOppo.tiempoTranscurridas(op.Data_Time_Cotizacion__c, fechaActual, op.CreatedDate);
                                        op.SLA_Cotizacion__c = tiempoTranscurrido;
                                    }
                                }
                                if(op.Data_Time_Ejecucion__c == null){
                                    op.Data_Time_Ejecucion__c = System.now();
                                    if(op.SLA_Negociacion__c == null){
                                        DateTime fechaActual = System.now();
                                        tiempoTranscurrido = P2G_tiempoTranscurridoOppo.tiempoTranscurridas(op.Data_Time_Negociacion__c, fechaActual, op.CreatedDate);
                                        op.SLA_Negociacion__c = tiempoTranscurrido;
                                    }
                                }
                                if(op.Data_Time_Ganada__c == null){
                                    op.Data_Time_Ganada__c = System.now();
                                    if(op.SLA_Ejecucion__c == null){
                                        DateTime fechaActual = System.now();
                                        tiempoTranscurrido = P2G_tiempoTranscurridoOppo.tiempoTranscurridas(op.Data_Time_Ejecucion__c, fechaActual, op.CreatedDate);
                                        op.SLA_Ejecucion__c = tiempoTranscurrido;
                                    }
                                }
                            }
                            when else {
                                System.debug('No existe esa etapa');
                            }
                        }
                    }
                }
                if((trigger.oldMap.get(op.Id).StageName != 'Perdida' && op.StageName == 'Perdida')||(trigger.oldMap.get(op.Id).StageName != 'Ganada' && op.StageName == 'Ganada')){
                    op.CloseDate = System.Today();
                }
                if(trigger.oldMap.get(op.Id).Realizacion_de_Kickoff__c == false && op.Realizacion_de_Kickoff__c == true){
                    String quoteVendida = P2G_tiempoTranscurridoOppo.quoteVendida(op.Id);
                    Integer statusProduct = P2G_tiempoTranscurridoOppo.statusOpportunityProduct(op.Id);
                    String validaCliente = P2G_tiempoTranscurridoOppo.validaCliente(op.AccountId);
                    if(quoteVendida != 'Quote Vendido'){
                        op.addError('No se puede actualizar por que la Quote no esta vendida');
                    }
                    if(validaCliente != 'si es valida la cuenta'){
                        op.addError('Antes de continuar necesitas dar de alta la cuenta en SAP');
                    }
                    /*if(statusProduct > 0){
                        op.addError('No se puede actualizar por que existen productos en status direrentes a "Aceptada", "Rechazada" o "No Cotizada"');
                    }*/
                	op.StageName = 'Ejecución';
                    op.CloseDate = System.Today();
                    String tiempoTranscurridoNego = P2G_tiempoTranscurridoOppo.tiempoTranscurridas(op.Data_Time_Negociacion__c, System.now(),op.CreatedDate);
                    op.SLA_Negociacion__c = tiempoTranscurridoNego;
                	op.Data_Time_Ejecucion__c = System.now();
                }
            }
        } else if (Trigger.isAfter) {
            
        }  
    }
    public static String getGroup(string serviceType){
        System.debug('service Type: '+serviceType);
        String grupo = 'SP-'+serviceType+'-';
        String elGrupo;
        Schema.DescribeFieldResult cober = Opportunity.Group__c.getDescribe();
        List<Schema.PicklistEntry> values = cober.getPicklistValues();
        for(Schema.PicklistEntry item:values){
            if(item.getValue().CONTAINS(grupo)){
                elGrupo = item.getValue();
                System.debug('Grupo: '+item.getValue());
            }
        }
        return elGrupo;
    }
}