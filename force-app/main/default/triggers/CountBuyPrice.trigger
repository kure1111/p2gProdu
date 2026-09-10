trigger CountBuyPrice on OpportunityLineItem (after insert, after update) {


    set <string> opsIds = new set<string>();

    for(OpportunityLineItem op : trigger.new){
        opsIds.add(op.OpportunityId );
    }

    List<Opportunity> paraActualizar = new List<Opportunity>();
    for( Opportunity oport : [select id, name,PROJ_Buy_price__c,(select id, name,PROJ_Buy_price__c , OpportunityId from  OpportunityLineItems) from  Opportunity where id in:opsIds])
    {
        Decimal sumaActual = oport.PROJ_Buy_price__c;
        Decimal suma = 0;

        for(OpportunityLineItem opi : oport.OpportunityLineItems)
        {
            suma += (opi.PROJ_Buy_price__c== null ? 0 : opi.PROJ_Buy_price__c);
        }

        // Solo actualizar si el total realmente cambio: antes se actualizaba SIEMPRE
        // y cada update identico re-disparaba el tren completo de automatizaciones de la oportunidad
        if(sumaActual == null || sumaActual != suma){
            oport.PROJ_Buy_price__c = suma;
            paraActualizar.add(oport);
        }
    }
    if(!paraActualizar.isEmpty()){
        update paraActualizar;
    }
}
