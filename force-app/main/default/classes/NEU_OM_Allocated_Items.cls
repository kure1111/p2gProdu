public with sharing class NEU_OM_Allocated_Items {
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
  
  private Decimal mydiscount=0;
  public String getdiscount()
  {
    if(mydiscount!=0)
        return mydiscount.format();
    return '';
  }
  public void setdiscount(String value)
  {
    mydiscount=NEU_Utils.safeDecimal(NEU_Utils.toDecimal(value));
  }

    public  List<pricelists_s> listado_pricelist = null;
    private List<SelectOption> newcategories=null;
    public string comprobante_familias = '';
    public String id_oi {get;set;}
    
    public string search_filter='';
    public string search_text {get;set;}
    
    
    public string step {get;set;} 
    public integer offset_lines = 0;
    public string sort_value {get;set;}


    
    ApexPages.StandardController con;
    public Price_List__c record;
    public NEU_OM_Allocated_Items(ApexPages.StandardController stdController) {
        if (!Test.isRunningTest())
            stdController.AddFields(new String[]{'Id','Business_Area__c','Items_Account_Owner__c','Family__c','Subfamily__c'});
        con = stdController;
        record=(Price_List__c)con.getRecord();
    }
    
    public  List<SelectOption> getnewcategories()
    {
      if(newcategories==null)
      {
          mynewcategory=null;
          newcategories=new List<SelectOption>();
          List<Catalog_Family__c> Catalog_Family = new List<Catalog_Family__c>();
          Catalog_Family = [select Id, Name, Catalog_Price_List__c, Family__c, Family__r.Name   from Catalog_Family__c where Catalog_Price_List__c =: record.Id];
          if(Catalog_Family.size()>0)
          {
            for(Catalog_Family__c ca_fa : Catalog_Family)
            {
                newcategories.add(new SelectOption(ca_fa.Family__c,ca_fa.Family__r.Name));
                if(String.IsEmpty(mynewcategory))
                    mynewcategory=ca_fa.Family__c;
            }
            
          }
          else
          {
                List<Product_Family__c> Product_Family = new List<Product_Family__c>();
            
                Product_Family = [select Id, Name   from Product_Family__c];
                if(record.Family__c != null)
                    Product_Family = [select Id, Name   from Product_Family__c where Id =: record.Family__c];
                else
                {
                    if(record.Business_Area__c != null)
                        Product_Family = [select Id, Name, Business_Area__c from Product_Family__c where Business_Area__c =: record.Business_Area__c];
                }
                
                for(Product_Family__c pro_fa : Product_Family)
                {
                    newcategories.add(new SelectOption(pro_fa.Id,pro_fa.Name));
                    if(String.IsEmpty(mynewcategory))
                        mynewcategory=pro_fa.Id;
                }
          }
      }
      return newcategories;
    }
    private String mynewcategory=null;
    
    public String getnewcategory()
    {
      if(mynewcategory==null)
        getnewcategories();
      return mynewcategory;
    }
    
    public void setnewcategory(String value)
    {
      if(mynewcategory!=value)
      {
        mynewcategory=value;
        listado_pricelist = null;
      }
    }
    
    public String getsearch_filter()
    {
    //  if(search_filter =='' || search_filter == null || search_filter =='All') 
      
      return search_filter;
    }
    
    public void setsearch_filter(String value)
    {
      if(search_filter!=value)
      {
        search_filter=value;
        listado_pricelist = null;
      }
    }
    
    public class pricelists_s
    {
        public Item_List_Price__c listprice{get;set;}
        public boolean selected {get; set;}
        
      public pricelists_s(Item_List_Price__c listprice)
      {
        this.listprice=listprice;
        this.selected=false;
      }
    }
    
    public List<pricelists_s> getlistado_pricelist()
    {

        if(listado_pricelist == null)
        {
          listado_pricelist = new List<pricelists_s>();
          List<Sourcing_Item__c> item_List = null;
          if(String.IsNotEmpty(getsearch_filter()) && getsearch_filter() !='All') 
            item_List = [SELECT Id, Name, Subfamily__r.Id,  Subfamily__r.Name, Volume__c, Sourcing_Item_Code__c, Account_Owner__c, Technical_description__c, Unit_of_measure__c, Item_Price__c  FROM Sourcing_Item__c WHERE Name LIKE :getsearch_filter()+'%' AND Sourcing_Family__c =:getnewcategory() ORDER BY Name];
          else
            item_List = [select Id, Name, Subfamily__r.Id, Subfamily__r.Name, Volume__c, Sourcing_Item_Code__c, Account_Owner__c, Technical_description__c, Unit_of_measure__c, Item_Price__c from Sourcing_Item__c where Sourcing_Family__c =: getnewcategory()  order by Name];

          Map<Id,Item_List_Price__c>maplist=new Map<Id,Item_List_Price__c>();
          for(Item_List_Price__c i:[select Id, JIT_MOQ__c, List_Price_STOCK__c , Item_Name__r.Volume__c, Item_Name__r.Account_Owner__c, DROP_MOQ__c, List_Price_DROP__c, STOCK_MOQ__c,  List_Price__c, Item_Name__r.Id, Item_Name__r.Name, Item_Name__r.Subfamily__r.Id, Item_Name__r.Subfamily__r.Name, Item_Name__r.Sourcing_Item_Code__c, Item_Name__r.Technical_description__c, Item_Name__r.Unit_of_measure__c, Item_Name__r.Item_Price__c from Item_List_Price__c where Price_List__c =: record.Id and Item_Name__c IN:item_List])
            maplist.put(i.Item_Name__r.Id,i);
    
          for(Sourcing_Item__c li: item_List)
          {
            Item_List_Price__c i=maplist.get(li.Id);
            if(i==null)
            {
                i=new Item_List_Price__c();
                if(li.Item_Price__c!=null)
                    i.List_Price__c=li.Item_Price__c*(1+(mydiscount/100));
                i.Item_Name__c=li.Id;
                i.Item_Name__r=li;
                i.Price_List__c=record.Id;
            }
            listado_pricelist.add(new pricelists_s(i));
          }
        }
        return listado_pricelist;
    } 
    
    
    public void asignar_price_list()
    {
        List<Item_List_Price__c> nueva_lista = new List<Item_List_Price__c>();
         for (pricelists_s lines:getlistado_pricelist())
         {
            if((lines.selected)&&(lines.listprice.Id==null))
                nueva_lista.add(lines.listprice);
         }
         if(nueva_lista.size()>0)
         {
            try
             {
                insert nueva_lista;
                 listado_pricelist = null;
             }
             catch(Exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
             return;
         }
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You haven\'t selected any Item'));
    }
    
    public void delete_item_pricelist_select()
    {
        List<Item_List_Price__c> lines_del =[select Id from Item_List_Price__c where Id =: id_oi];
        if(lines_del.size()>0)
        {
            try
            {
               delete lines_del;
               listado_pricelist = null;
            }
            catch(Exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
        }
    }
  
    public void updatelines()
    {
        listado_pricelist = null;
    }
      public PageReference return_pricelist()
      {
        return con.view();
      }
    
    
}