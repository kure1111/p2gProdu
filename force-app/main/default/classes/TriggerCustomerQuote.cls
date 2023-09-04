public class TriggerCustomerQuote {    
    
    public static void ActualizarShipment(list<Customer_Quote__c> listaRegistros)
    {                
        set<string> idShipments = new set<string>();
        map<string,Customer_Quote__c> mapQuote = new map<string,Customer_Quote__c>();
        list<Shipment__c> listaShipments = new list<Shipment__c>();
        
        for(Customer_Quote__c cq : listaRegistros)
            {
                if(cq.Quotation_status__c == 'Shipped'){
                    idShipments.add(cq.Last_Shipment__c);
                    mapQuote.put(cq.Last_Shipment__c,cq);
                }
            }
        
            if(!idShipments.isEmpty()){
                
                for(Shipment__c s : [select id,SPMargen_Operativo__c  from Shipment__c where id in :idShipments] )
                {
                    if(mapQuote.containsKey(s.id))
                    {
                        s.Order_Margen_Operativo__c = mapQuote.get(s.id).Margen_Operativo__c;
                        listaShipments.add(s);    
                    }                    
                }
                update listaShipments;               
            }               
        
    }
    public static void ActualizarLocations(list<Customer_Quote__c> listaRegistros)
    {
        set<string> idsAccountAdress = new set<string>();
        for(Customer_Quote__c cq : listaRegistros)
        {
            if(cq.Account_Origin_Address__c != null){
                 idsAccountAdress.add(cq.Account_Origin_Address__c);
            }
            if(cq.Account_Destination_Address__c != null){
                idsAccountAdress.add(cq.Account_Destination_Address__c);
            }
        }
        map<string,Account_Address__c> mapAccountAddress = new   map<string,Account_Address__c>();
        for(Account_Address__c aa: [select id,Address__c,Address_Coordinates__latitude__s,Address_Coordinates__longitude__s from Account_Address__c where id IN: idsAccountAdress]){mapAccountAddress.put(aa.id,aa);}
        system.debug('idsAccountAdress: '+idsAccountAdress);
        system.debug('Map: '+mapAccountAddress);
        
         if(mapAccountAddress != null){
       
           for(Customer_Quote__c cq : listaRegistros)
            {
                if(cq.Account_Origin_Address__c != null){
                   
                    system.debug(''+mapAccountAddress.get(cq.Account_Origin_Address__c));
                    
                    cq.Origin_Address__c = mapAccountAddress.get(cq.Account_Origin_Address__c).Address__c;
                    cq.Origin_Location__Latitude__s =mapAccountAddress.get(cq.Account_Origin_Address__c).Address_Coordinates__latitude__s;
                    cq.Origin_Location__Longitude__s =mapAccountAddress.get(cq.Account_Origin_Address__c).Address_Coordinates__longitude__s;
                }
                else
                {
                   // cq.Origin_Address__c = null;
                    cq.Origin_Location__Latitude__s = null;
                    cq.Origin_Location__Longitude__s = null;
                }
                
                
                if(cq.Account_Destination_Address__c != null){
                    cq.Destination_Address__c = mapAccountAddress.get(cq.Account_Destination_Address__c).Address__c;
                    cq.Destination_Location__latitude__s =mapAccountAddress.get(cq.Account_Destination_Address__c).Address_Coordinates__latitude__s;
                    cq.Destination_Location__longitude__s =mapAccountAddress.get(cq.Account_Destination_Address__c).Address_Coordinates__longitude__s;
                }
                else
                {
                   // cq.Destination_Address__c = null;
                    cq.Destination_Location__latitude__s = null;
                    cq.Destination_Location__longitude__s = null;
                }
            }         
        }
        
    }
    
     public static void ActualizaDistancia(list<Customer_Quote__c> listaRegistros)
    {
   /*     set<string> idsAccountAdress = new set<string>();
        for(Customer_Quote__c cq : listaRegistros)
        {
            if(cq.Account_Origin_Address__c != null){
                 idsAccountAdress.add(cq.Account_Origin_Address__c);
            }
            if(cq.Account_Destination_Address__c != null){
                idsAccountAdress.add(cq.Account_Destination_Address__c);
            }
        }
        map<string,Account_Address__c> mapAccountAddress = new   map<string,Account_Address__c>();
        for(Account_Address__c aa: [select id,Address__c,Address_Coordinates__latitude__s,Address_Coordinates__longitude__s from Account_Address__c where id IN: idsAccountAdress]){mapAccountAddress.put(aa.id,aa);}
        system.debug('idsAccountAdress: '+idsAccountAdress);
        system.debug('Map: '+mapAccountAddress);
        
         if(mapAccountAddress != null){
       
           for(Customer_Quote__c cq : listaRegistros)
            {
                if( ( cq.FolioResume__c == 'FN' || cq.FolioResume__c == 'FI' || cq.FolioResume__c == 'PT' )  && cq.Account_Origin_Address__c != null && cq.Account_Destination_Address__c != null)
                {         
       			  DistanceIEQ.googleMapsDistanceKM(CQ.Origin_Location__Latitude__s, CQ.Origin_Location__Longitude__s, CQ.Destination_Location__Latitude__s,CQ.Destination_Location__Longitude__s, CQ.id);
                }

            }         
        }*/
        
    }
}