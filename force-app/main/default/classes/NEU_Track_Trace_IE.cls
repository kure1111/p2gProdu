public with sharing class NEU_Track_Trace_IE {

   public Customer_Quote__c record=null;
   public List<Shipment__c> listado_shipment_map {get;set;}
   public List<Shipment_s> listado_shipment {get;set;}
   public string ultimo_shipment {get;set;}
   
   public NEU_Track_Trace_IE(ApexPages.StandardController stdController) 
   {
        if (!Test.isRunningTest())
            stdController.AddFields(new String[]
            {
                'Id',
                'Name',
                (UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode' : 'Contact__c')
            });
        record=(Customer_Quote__c)stdController.getRecord();
        listado_shipment_map = new List<Shipment__c>();
        Map<id, Shipment__c> map_shipments = new Map<Id, Shipment__c>();
        List<Shipment_Consolidation_Data__c> ship_conso_data = [select Id, Name, Shipment__c, Shipment__r.Inbound_Consolidation_Program__r.Total_Distance_kms__c,Shipment__r.Mode__c, Shipment__r.Freight_Mode__c, Shipment__r.Route__c, Shipment__r.Route__r.Name, Shipment__r.Site_of_Discharge__c, Shipment__r.Site_of_Discharge__r.Name, Shipment__r.Storage_Date_From__c, Shipment__r.Storage_Date_To__c, Shipment__r.Storage_days__c, Shipment__r.ETD_from_Point_of_Load__c, Shipment__r.ETA_Point_of_Discharge__c, Shipment__r.Name from Shipment_Consolidation_Data__c where Import_Export_Quote__c =: record.Id and Shipment__c !=: null order by Shipment__c];
        for(Shipment_Consolidation_Data__c scd: ship_conso_data)
        {
            map_shipments.put(scd.Shipment__c, scd.Shipment__r);
            ultimo_shipment = scd.Shipment__c;
        }
        
        listado_shipment_map = map_shipments.values();
        listado_shipment = new List<Shipment_s>();
        for(Shipment__c ship: listado_shipment_map)
        {
            listado_shipment.add(new Shipment_s(ship,   NEU_Utils.safeString(ship.ETD_from_Point_of_Load__c), NEU_Utils.safeString(ship.ETA_Point_of_Discharge__c), NEU_Utils.safeString(ship.Storage_Date_From__c), NEU_Utils.safeString(ship.Storage_Date_To__c)));
        }
        
    }
    
     //clase nuevo objeto
     public class Shipment_s
     {
        public Shipment__c ship {get; set;}
        public string etd {get; set;}
        public string eta {get; set;}
        public string Storage_Date_From {get; set;}
        public string Storage_Date_To {get; set;}
        public Shipment_s(Shipment__c ship, string etd, string eta, string Storage_Date_From, string Storage_Date_To )
        {
            this.ship=ship;
            this.etd=etd;
            this.eta=eta;
            this.Storage_Date_From=Storage_Date_From;
            this.Storage_Date_To=Storage_Date_To;
        }
     }
}