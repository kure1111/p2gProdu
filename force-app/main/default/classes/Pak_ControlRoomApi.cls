@RestResource(urlMapping='/controlroom/*')
global without sharing class Pak_ControlRoomApi 
{
    
    @HttpGet
    global static Carta_Porte__c GetCartaPorte() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        if(String.isBlank(req.params.get('telefono')))
            return new Carta_Porte__c();
        
        String telefono = req.params.get('telefono');
        
        list<Operadores__c> operadores = [SELECT Id, name  
                                          FROM Operadores__c 
                                          where  (Cel_ope__c =: telefono 
                                                  or Telefono_2__c =:telefono 
                                                  or Telefono_3__c =:telefono 
                                                  or Telfij_ope__c =: telefono)];
        
        if(operadores.size() == 0)
            return new Carta_Porte__c();
        
        List<Shipment__c> shipments = [SELECT Id, name  
                                       FROM Shipment__c 
                                       where (National_Operator__c =:operadores[0].id
                                              or Operator_2__c =:operadores[0].id) 
                                       and Shipment_Status_Plann__c not in ('Closed', 'False') order by createddate desc /*limit 1 */];
        
        if(shipments.size() == 0)
            return new Carta_Porte__c();
        
        //borrar
        set<string> ids = new set<string>();
        for(shipment__c ship : shipments)
            ids.add(ship.id);
        
        
        list<Carta_Porte__c> cps = [SELECT Id, PDF_Url__c
                                    FROM Carta_Porte__c 
                                    where shipment__c  in:ids // =: shipments[0].id 
                                    order by createddate desc /*limit 1*/];
        
        if(cps.size() == 0)
            return new Carta_Porte__c();
        else 
          return  cps[0];            
        
        
        
    }
    
    public static void test()
    {
        string a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        a ='';
        
    }
    
}