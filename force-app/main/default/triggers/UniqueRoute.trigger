trigger UniqueRoute on Carrier_Line_Load_Point__c (before insert, before update) {
    
    set<string> keys = new set<string>();
    
    for(Carrier_Line_Load_Point__c route : Trigger.New){
        keys.add(route.key__c);
    }
    
    if(trigger.isInsert)
    {
        
        set<string> keysQ = new set<string>();

        for(Carrier_Line_Load_Point__c route : [select id, key__c from Carrier_Line_Load_Point__c where key__c IN: keys ])
        {
            keysQ.add(route.key__c);
        }
        
        for(Carrier_Line_Load_Point__c route : Trigger.New){
            
            if(keysQ.contains(route.Key__c) )
                route.addError('Esta ruta ya existe.');
         }
    }
    
      if(trigger.isUpdate)
      {
          list<string> keysQ = new list<string>();
		Map<String,Integer> elCount = new Map<String,Integer>();

        for(Carrier_Line_Load_Point__c route : [select id, key__c from Carrier_Line_Load_Point__c where key__c IN: keys ])
        {
            keysQ.add(route.key__c);
        }
          
          for(String key : keysQ)
          {
              if(!elCount.containsKey(key)){
                  elCount.put(key,0);
              }
              
              Integer currentInt=elCount.get(key)+1;
              elCount.put(key,currentInt);
          }
        
        for(Carrier_Line_Load_Point__c route : Trigger.New){
            
            if(elCount.get(route.Key__c) > 1 )
                route.addError('Esta ruta ya existe.');
         }
          
         
      }
    
}