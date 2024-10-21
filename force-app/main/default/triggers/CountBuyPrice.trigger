trigger CountBuyPrice on OpportunityLineItem (after insert, after update) {
    
    
    set <string> opsIds = new set<string>();
    Map<string, Opportunity>  oprts  = new   Map<string, Opportunity> ();
    
    for(OpportunityLineItem op : trigger.new){
        opsIds.add(op.OpportunityId );  
    }
    
    
    for( Opportunity oport : [select id, name,PROJ_Buy_price__c,(select id, name,PROJ_Buy_price__c , OpportunityId from  OpportunityLineItems) from  Opportunity where id in:opsIds])
    {
        oport.PROJ_Buy_price__c = 0;
        system.debug('oport ' + oport);
        
        for(OpportunityLineItem opi : oport.OpportunityLineItems)
        {
            oport.PROJ_Buy_price__c += (opi.PROJ_Buy_price__c== null ? 0 : opi.PROJ_Buy_price__c);
            system.debug('precio : ' +  oport.PROJ_Buy_price__c );
        }  
        
        system.debug('oport 2 : ' +  oport );
        update oport;
    }
}