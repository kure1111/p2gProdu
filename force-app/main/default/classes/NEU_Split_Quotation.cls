public with sharing class NEU_Split_Quotation extends NEU_Controller_Comparable {

   public Customer_Quote__c record = null;
   private List<Line_s> Lines=null;
   public decimal margin_general  {get;set;}
                
   ApexPages.StandardController con;
   public NEU_Split_Quotation(ApexPages.StandardController stdController) {
         
            if (!Test.isRunningTest()) {stdController.AddFields(new String[]{'Id','Name','Total_Weight_Kg2__c','Total_Volume_m3_2__c'});}
            con=stdController;
            record=(Customer_Quote__c)stdController.getRecord();
     }
     
    public Boolean getShowImportExportItemLines()
    {
        if(getLines()!=null)
            return Lines.size()>0;
        return false;
    }
     
    public override void sortList(Integer sortList)
    {
    	Lines.sort();
    }
     
    public class Line_s extends NEU_Line_Comparable
    {
    	
        public Quote_Item_Line__c quote_line{get;set;}
        public boolean selected{get;set;}
        
        public Line_s(NEU_Controller_Comparable parent,Quote_Item_Line__c quote_line)
        {
        	super(parent);
        	this.quote_line=quote_line;
            this.selected = false;
        }
        public override Object getValue(String compareField)
    	{
	        if(compareField=='selected')
	            return selected;
	        return getValue(quote_line,compareField);
    	}
     }
     
    public PageReference cancel()
    {
        return con.view();
    }
    public List<Line_s> getLines()
    {
            if(Lines==null)
            {
                 Lines=new List<Line_s>();
                 List<Quote_Item_Line__c> lineas_items = [select Id, Name, Import_Export_Quote__r.Name, Unit_Destination_Price__c, Item_Supplier_Owner__r.Name, Item_Supplier_Owner__r.Id, Units__c , Total_Destination_Amount__c, Consolidated__c , Delivery_Number__c, Delivery_Date__c, Item_Name__r.Name, Item_Name__r.Sourcing_Item_Code__c, Extension_Item_Name__c from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id];
                 for(Quote_Item_Line__c qil: lineas_items)
                     Lines.add(new Line_s(this,qil));
            }
            return Lines;
    }
    
    public PageReference generate()
    {
        boolean linesOK=false;
        for(Line_s line:getLines())
            if(line.selected)
            {
                linesOK=true;
                break;
            }
        if(!linesOK)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please, select the lines to be included in the new '+Schema.SObjectType.Customer_Quote__c.getLabel()));
            return null;
        }
        Customer_Quote__c myieq=(Customer_Quote__c)cloneSObject(record);
        double oldWeight=NEU_Utils.safeDecimal(record.Total_Weight_Kg2__c);
        double oldVolume=NEU_Utils.safeDecimal(record.Total_Volume_m3_2__c);
        myieq.Quotation_Status__c=null;
        insert myieq;
        List<Quote_Item_Line__c> toUpdate=new List<Quote_Item_Line__c>();
        for(Line_s line:getLines())
            if(line.selected)
            {
                toUpdate.add(line.quote_line);
                line.quote_line.Import_Export_Quote__c=myieq.Id;
            }
        update toUpdate;
        List<Customer_Quote__c> newrecords=[select Id,Total_Weight_Kg2__c,Total_Volume_m3_2__c from Customer_Quote__c where Id=:record.Id];
        if(newrecords.size()>0)
        {
            double newWeight=NEU_Utils.safeDecimal(newrecords[0].Total_Weight_Kg2__c);
            double newVolume=NEU_Utils.safeDecimal(newrecords[0].Total_Volume_m3_2__c);
            double ratio=1;
            if(oldWeight!=0)
                ratio=newWeight/oldWeight;
            if(oldVolume!=0)
                if(ratio<newVolume/oldVolume)
                    ratio=newVolume/oldVolume;
            if(ratio==0)
            {
                List<Import_Export_Fee_Line__c> lineas_fees=[select Id,Units__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =:record.Id];
                if(lineas_fees.size()>0)
                {
                    for(Import_Export_Fee_Line__c fee:lineas_fees)
                        fee.Import_Export_Quote__c=myieq.Id;
                    upsert lineas_fees;
                }
            }
            else if(ratio!=1)
            {
                List<Import_Export_Fee_Line__c> lineas_fees = database.query(populateSObject(Schema.SObjectType.Import_Export_Fee_Line__c.getSobjectType())+' where Import_Export_Quote__c =\''+record.Id+'\'');
                List<Import_Export_Fee_Line__c> toUpsert=new List<Import_Export_Fee_Line__c>();
                for(Import_Export_Fee_Line__c fee:lineas_fees)
                {
                    Import_Export_Fee_Line__c newfee=fee.clone(false,true);
                    newfee.Import_Export_Quote__c=myieq.Id;
                    fee.Units__c=(fee.Units__c*ratio).round(RoundingMode.UP);
                    newfee.Units__c=(newfee.Units__c*(1-ratio)).round(RoundingMode.UP);
                    toUpsert.add(fee);
                    toUpsert.add(newfee);
                }
                if(toUpsert.size()>0)
                    upsert toUpsert;
            }
        }
        return new ApexPages.standardController(myieq).view();
    }
    private SObject cloneSObject(SObject myObject)
    {
        if(myObject.Id==null)
            return myObject.clone(false,true);
        List<SObject>lines=database.query(populateSobject(myObject.getSobjectType())+' where Id=\''+myObject.Id+'\'');
        if(lines.size()>0)
            return lines[0].clone(false,true);
        return null;
    }
    private String populateSObject(SObjectType myObjectType)
    {
        String query='select Id';
        for(String s:myObjectType.getDescribe().fields.getMap().keySet())
            if(s!='Id')
                query+=','+s;
        return query+' from '+myObjectType.getDescribe().getName();
    }
}