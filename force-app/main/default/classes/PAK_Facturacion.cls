public class PAK_Facturacion {
    public static Transient List<Customer_Quote__c> lstFi {get;set;}
    public static Transient List<Customer_Quote__c> lstPto {get;set;}
    public static Transient List<Customer_Quote__c> lstRImpo {get;set;}
    public static Transient List<Customer_Quote__c> lstRExpo {get;set;}
    public static Transient List<Customer_Quote__c> lstA {get;set;}
    public static Transient List<Customer_Quote__c> lstMImpo {get;set;}
    public static Transient List<Customer_Quote__c> lstMExpo {get;set;}
    public PAK_Facturacion() {
        lstFi = [SELECT Last_Shipment__r.Id, Last_Shipment__r.Name, Last_Shipment__r.Shipment_Status_Mon__c, Last_Shipment__r.ESTATUS_FACT_SAP__c, 
                 Last_Shipment__r.Total_Services_Sell_Amount__c, Last_Shipment__r.Account_for__r.Name, CreatedBy.Name, Pricing_Executive__r.Name, Last_Shipment__r.Email_Cobranza_11__c
                 FROM Customer_Quote__c 
                 WHERE Last_Shipment__c != null AND Name LIKE 'FI-%' 
                 AND Last_Shipment__r.Shipment_Status_Mon__c = 'Finished_M'
                 AND Last_Shipment__r.ESTATUS_FACT_SAP__c != 'FACTURADO' ORDER BY CreatedDate DESC];
        lstPto = [SELECT Last_Shipment__c, Last_Shipment__r.Name, Last_Shipment__r.Shipment_Status_Mon__c, Last_Shipment__r.ESTATUS_FACT_SAP__c, 
                  Last_Shipment__r.Total_Services_Sell_Amount__c, Last_Shipment__r.Account_for__r.Name, CreatedBy.Name, Pricing_Executive__r.Name, Last_Shipment__r.Email_Cobranza_11__c
                  FROM Customer_Quote__c 
                  WHERE Last_Shipment__c != null AND Name LIKE 'PTO-%' 
                  AND Last_Shipment__r.Shipment_Status_Mon__c = 'Finished_M'
                  AND Last_Shipment__r.ESTATUS_FACT_SAP__c != 'FACTURADO' ORDER BY CreatedDate DESC];
        lstA = [SELECT Last_Shipment__c, Last_Shipment__r.Name, Last_Shipment__r.Air_Shipment_Status__c , Last_Shipment__r.ESTATUS_FACT_SAP__c, 
                Last_Shipment__r.Total_Services_Sell_Amount__c, Last_Shipment__r.Account_for__r.Name, CreatedBy.Name, Pricing_Executive__r.Name, Last_Shipment__r.Email_Cobranza_11__c
                FROM Customer_Quote__c 
                WHERE Last_Shipment__c != null AND Name LIKE 'A-%' 
                AND Last_Shipment__r.Air_Shipment_Status__c  = 'Flight Confirmation'
                AND Last_Shipment__r.ESTATUS_FACT_SAP__c != 'FACTURADO' ORDER BY CreatedDate DESC];
        lstRImpo = [SELECT Last_Shipment__c, Last_Shipment__r.Name, Last_Shipment__r.Ocean_Shipment_Status__c , Last_Shipment__r.ESTATUS_FACT_SAP__c, 
                    Last_Shipment__r.Total_Services_Sell_Amount__c, Last_Shipment__r.Account_for__r.Name, CreatedBy.Name, Pricing_Executive__r.Name, Last_Shipment__r.Email_Cobranza_11__c
                    FROM Customer_Quote__c 
                    WHERE Last_Shipment__c != null AND Name LIKE 'R-%' AND Last_Shipment__r.Service_Mode__c = 'IMPORT'
                    AND (Last_Shipment__r.Ocean_Shipment_Status__c  = 'ETA-15' OR Last_Shipment__r.Ocean_Shipment_Status__c = 'Finished')
                    AND Last_Shipment__r.ESTATUS_FACT_SAP__c != 'FACTURADO' ORDER BY CreatedDate DESC];
        lstRExpo = [SELECT Last_Shipment__c, Last_Shipment__r.Name, Last_Shipment__r.Shipment_Status__c , Last_Shipment__r.ESTATUS_FACT_SAP__c, 
                    Last_Shipment__r.Total_Services_Sell_Amount__c, Last_Shipment__r.Account_for__r.Name, CreatedBy.Name, Pricing_Executive__r.Name, Last_Shipment__r.Email_Cobranza_11__c
                    FROM Customer_Quote__c 
                    WHERE Last_Shipment__c != null AND Name LIKE 'R-%' AND Last_Shipment__r.Service_Mode__c = 'EXPORT'
                    AND (Last_Shipment__r.Shipment_Status__c  = 'ETA-15' OR Last_Shipment__r.Shipment_Status__c = 'Finished')
                    AND Last_Shipment__r.ESTATUS_FACT_SAP__c != 'FACTURADO' ORDER BY CreatedDate DESC];        
        lstMImpo = [SELECT Last_Shipment__c, Last_Shipment__r.Name, Last_Shipment__r.Ocean_Shipment_Status__c , Last_Shipment__r.ESTATUS_FACT_SAP__c, 
                    Last_Shipment__r.Total_Services_Sell_Amount__c, Last_Shipment__r.Account_for__r.Name, CreatedBy.Name, Pricing_Executive__r.Name, Last_Shipment__r.Email_Cobranza_11__c
                    FROM Customer_Quote__c 
                    WHERE Last_Shipment__c != null AND Name LIKE 'M-%' 
                    AND Last_Shipment__r.Ocean_Shipment_Status__c  = 'ETA-4' AND Last_Shipment__r.Service_Mode__c = 'IMPORT'
                    AND Last_Shipment__r.ESTATUS_FACT_SAP__c != 'FACTURADO' ORDER BY CreatedDate DESC];
        lstMExpo = [SELECT Last_Shipment__c, Last_Shipment__r.Name, Last_Shipment__r.Shipment_Status__c , Last_Shipment__r.ESTATUS_FACT_SAP__c, 
                    Last_Shipment__r.Total_Services_Sell_Amount__c, Last_Shipment__r.Account_for__r.Name, CreatedBy.Name, Pricing_Executive__r.Name, Last_Shipment__r.Email_Cobranza_11__c
                    FROM Customer_Quote__c 
                    WHERE Last_Shipment__c != null AND Name LIKE 'M-%' 
                    AND Last_Shipment__r.Shipment_Status__c  = 'ETA -15' AND Last_Shipment__r.Service_Mode__c = 'EXPORT'
                    AND Last_Shipment__r.ESTATUS_FACT_SAP__c != 'FACTURADO' ORDER BY CreatedDate DESC];
    }
}