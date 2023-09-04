public with sharing class NEU_Aditional_Discounts {
  public String decimalSep
  {
     get
     {
       if(decimalSep==null)
         decimalSep=NEU_Utils.getDecimalSep();
       return decimalSep;
     }
     set
     {
       decimalSep=value;
     }
  }
  public String thousandSep
  {
     get
     {
       if(thousandSep==null)
         thousandSep=NEU_Utils.getThousandSep();
       return thousandSep;
     }
     set
     {
       thousandSep=value;
     }
  }
  public class Import_Export_Discount_Line_s
  {
    public Import_Export_Discount_Line__c line{get;set;}
    public Boolean selected{get;set;}
    public Import_Export_Discount_Line_s(Import_Export_Discount_Line__c line)
    {
      this.line=line;
      this.selected=false;
    }
  }
  public List<Import_Export_Discount_Line_s>lines
  {
    get
    {
      if(lines==null)
      {
        lines=new List<Import_Export_Discount_Line_s>();
        List<Discount_Rule__c>full=[select Id,Name,Discount__c,Valid_From__c,Valid_To__c from Discount_Rule__c where Enabled__c=true order by Name,Valid_From__c,Valid_to__c];
        for(Discount_Rule__c f:full)
        {
          Import_Export_Discount_Line__c line=new Import_Export_Discount_Line__c();
          line.Discount__c=f.Discount__c;
          line.Discount_Rule__c=f.Id;
          line.Discount_Rule__r=f;
          line.Import_Export_Quote_Order__c=con.getId();
          lines.add(new Import_Export_Discount_Line_s(line));
        }
      }
      return lines;
    }
    set;
  }

    private ApexPages.StandardController con;
    public NEU_Aditional_Discounts(ApexPages.StandardController stdController) {
        con=stdController;
    }
    
    public void apply_lines()
    {
      List<Import_Export_Discount_Line__c>toInsert=new List<Import_Export_Discount_Line__c>();
      for(Import_Export_Discount_Line_s s:lines)
        if(s.selected)
          toInsert.add(s.line);
      if(toInsert.size()>0)
      {
        try{
          insert toInsert;
          lines=null;
          con.reset();
        }
        catch(Exception e)
        {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        return;
      }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You haven\'t selected any Discount to apply to this Import/Export Quote/Order'));
    }

    public PageReference return_quote()
    {
        return con.view();
    }
}