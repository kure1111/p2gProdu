trigger PrecioSugerido on OpportunityLineItem (before insert, before update) {
          
   Rol_Margen__c margen = [SELECT 
                            Id, Name, FN_Margen_Operativo__c, FI_Margen_Operativo__c, 
                            FI_LTL_Margen_Operativo__c, PTO_Margen_Operativo__c,
                            M_FCL_Margen_Operativo__c, M_LCL_Margen_Operativo__c, 
                            A_Margen_Operativo__c, A_Paq_Margen_Operativo__c, 
                            W_WCA_Margen_Operativo__c, AW_WCA_Margen_Operativo__c, 
                            R_Margen_Operativo__c, T_Margen_Operativo__c, PQ_Margen_Operativo__c 
                            FROM Rol_Margen__c where name  = 'Asesor Comercial' limit 1 ];
    
    set <string> opsIds = new set<string>();
    Map<string, Opportunity>  oprts  = new Map<string, Opportunity> ();
    
    for(OpportunityLineItem op : trigger.new){
        opsIds.add(op.OpportunityId );  
    }
    
    for( Opportunity oport : [select id, name,PROJ_Service_Mode__c, accountid ,account.Sitprov_cta__c from  Opportunity where id in:opsIds ])
    {
        if(!oprts.containsKey(oport.id))
            oprts.put(oport.id, oport);
    }
    
    for(OpportunityLineItem op : trigger.new){
        Opportunity oportunidad = oprts.get(op.OpportunityId);
        
        // ( PRECIO COMPRA + GASTO OPERATIVO TIPO DE SSERVICIO ) * ( 1 + MARGENROL ) 
        
        if(oportunidad.PROJ_Service_Mode__c == 'PAQUETERIA')
            op.Precio_Sugerido3__c = (op.PROJ_Buy_price__c + 895 ) * (1+ (margen.PQ_Margen_Operativo__c/100)) ;
        else if(oportunidad.PROJ_Service_Mode__c == 'FN')
            op.Precio_Sugerido3__c = (op.PROJ_Buy_price__c + 1830) * (1+(margen.FN_Margen_Operativo__c/100)) ;
        else if(oportunidad.PROJ_Service_Mode__c == 'FI')
            op.Precio_Sugerido3__c = (op.PROJ_Buy_price__c + 1498) * (1+(margen.FI_Margen_Operativo__c/100)) ;
        else if(oportunidad.PROJ_Service_Mode__c == 'PTO')
            op.Precio_Sugerido3__c = (op.PROJ_Buy_price__c + 0) * (1+(margen.PTO_Margen_Operativo__c/100)) ;
        else if(oportunidad.PROJ_Service_Mode__c == 'M')
            op.Precio_Sugerido3__c = (op.PROJ_Buy_price__c + 2073) * (1+(margen.M_FCL_Margen_Operativo__c/100)) ;
        else if(oportunidad.PROJ_Service_Mode__c == 'T')
            op.Precio_Sugerido3__c = (op.PROJ_Buy_price__c + 0) * (1+(margen.T_Margen_Operativo__c/100)) ;
        
    }
}