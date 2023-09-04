public class PK2_FN_TABLE
{
    private limitWrapper[] thousandBlocks = new limitWrapper[]{};
    
    private final integer listLimit;
    
    public PK2_FN_TABLE()
    {
        listLimit = 999;
    }
    
    public limitWrapper[] getthousandBlocks()
    {
        thousandBlocks = new limitWrapper[]{};
        
        integer counter = 0;
        integer loopCount = 0;
        Customer_Quote__c[] tmp_customer_quote = new Customer_Quote__c[]{};
        
        for(Customer_Quote__c c:[Select Id, Name,Freight_Mode__c,
              Service_Mode__c,
              Mode__c,
              Service_Type__c,
              Site_of_Load__c,
              Site_of_Discharge__c,
              Route__c,
              CreatedDate,
              Account_for__r.Name,
              CreatedBy.Name,
              Last_Shipment__c,
              Last_Shipment__r.Operation_Executive__c,
              Last_Shipment__r.Shipment_Status__c,
              Last_Shipment__r.Shipment_Status_Plann__c,
              Last_Shipment__r.Shipment_Status_Mon__c,
              Pricing_Executive__r.Name,(Select Container_Type__r.Name From Import_Export_Items_Lines__r),
              Operations_Exec__r.Name,Quotation_Status__c From Customer_Quote__c Where Freight_Mode__c = 'Road' and Service_Mode__c = 'NATIONAL' and Last_Shipment__r.Shipment_Status_Plann__c !='Confirmed' and Last_Shipment__r.Shipment_Status_Plann__c !='False' and Last_Shipment__r.Shipment_Status_Plann__c !='Cancel'
              and Service_Type__c != 'PAQUETERIA' and  Service_Type__c != 'TARIMAS' and Name LIKE 'FN-%' and Quotation_Status__c IN ('Shipped', 'Approved as Succesful') Order by Quotation_Status__c desc LIMIT 1000])
        {
            if(counter < listLimit)
            {
                tmp_customer_quote.add(c);
                counter++;
            }
            else
            {
                loopCount++;
                thousandBlocks.add(new limitWrapper(tmp_customer_quote,loopCount));
                tmp_customer_quote = new Customer_Quote__c[]{};
                tmp_customer_quote.add(c);
                counter = 0;
            }            
        }
        
        if(thousandBlocks.size() == 0)
        {
            loopCount++;
            thousandBlocks.add(new limitWrapper(tmp_customer_quote,loopCount));
        }
        
        return thousandBlocks;
    }
    
    public class limitWrapper
    {
        public Customer_Quote__c [] cases {get;set;}
        public integer blockNumber {get;set;}
        public limitWrapper(Customer_Quote__c[] accs, integer i)
        {
            cases = accs;
            blockNumber = i;
        }
        
    }
}