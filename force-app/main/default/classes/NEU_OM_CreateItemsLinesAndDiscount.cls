public with sharing class NEU_OM_CreateItemsLinesAndDiscount {
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

public Customer_Quote__c record=null;
public String id_oi {get;set;}
private List<Quote_Item_Line__c> quoteItemLines=null;

public Boolean editPriceList{get;set;}

public  List<NEUEBUSCM_Quote_Item_Line_h> Item_List_Price = null;

public String TempPrice_List='';

private List<SelectOption> newcategories=null;

public String getTempPrice_List()
    {
        return TempPrice_List;
    }
    
    public void setTempPrice_List(String value)
    {
        if(value!=TempPrice_List)
        {
            TempPrice_List=value;
            Item_List_Price = null;
            quoteItemLines = null;
        }
    }
    
public  List<SelectOption> getnewcategories()
{
    System.debug('getnewcategories with?');
    if(newcategories==null)
    {
        System.debug('getnewcategories with newcategories==null');
        mynewcategory=null;
        newcategories=new List<SelectOption>();
        List<Product_Family__c> lista_familias = null;
        
        if(record.Account_for_Price_List__c != null)
        {
            List<Customer_Price_List__c> Acc_Price_List = [select Id, Price_List__c, Price_List__r.Family__c,Price_List__r.Business_Area__c  from Customer_Price_List__c where Id =: record.Account_for_Price_List__c limit 1];
            set<id>listado_familias_sacar = new set<id>();
            List<Item_List_Price__c> query_listado_familias_sacar = [select Item_Name__r.Sourcing_Family__c from Item_List_Price__c where Price_List__c =:Acc_Price_List[0].Price_List__c];
             for(Item_List_Price__c ilp: query_listado_familias_sacar)
            {
                listado_familias_sacar.add(ilp.Item_Name__r.Sourcing_Family__c);
            }
            if(Acc_Price_List[0].Price_List__r.Family__c != null)
                lista_familias = [SELECT Name, Id FROM Product_Family__c where Id =: Acc_Price_List[0].Price_List__r.Family__c and Id IN:listado_familias_sacar order by Name];
            else
                lista_familias = [SELECT Name, Id FROM Product_Family__c where Business_Area__c =: Acc_Price_List[0].Price_List__r.Business_Area__c and Id IN:listado_familias_sacar order by Name];
        }
        else if(record.Catalog_Price_List__c != null)
        {
            List<Price_List__c> Price_List = [select Family__c,Business_Area__c  from Price_List__c where Id =: record.Catalog_Price_List__c limit 1];
            System.debug('getnewcategories with record.Catalog_Price_List__c');
            set<id>listado_familias_sacar = new set<id>();
            List<Item_List_Price__c> query_listado_familias_sacar = [select Item_Name__r.Sourcing_Family__c from Item_List_Price__c where Price_List__c =:record.Catalog_Price_List__c];
            for(Item_List_Price__c ilp: query_listado_familias_sacar)
            {
                listado_familias_sacar.add(ilp.Item_Name__r.Sourcing_Family__c);
            }
                if(Price_List[0].Family__c != null)
                {
                    System.debug('getnewcategories with record.Catalog_Price_List__c and family');
                    lista_familias = [SELECT Name, Id FROM Product_Family__c where Id =: Price_List[0].Family__c and Id IN: listado_familias_sacar order by Name];
                }
                else
                {
                    System.debug('getnewcategories with record.Catalog_Price_List__c and Business Area');
                    lista_familias = [SELECT Name, Id FROM Product_Family__c where Business_Area__c =: Price_List[0].Business_Area__c and Id IN: listado_familias_sacar order by Name];
                }
        }
        else
        {
             lista_familias = [SELECT Name, Id FROM Product_Family__c where Id IN(select Sourcing_Family__c from Sourcing_Item__c where Sourcing_Family__c != null) order by Name];
        }
        if(lista_familias!=null)
            for( Schema.Product_Family__c f : lista_familias)
            {
                newcategories.add(new SelectOption(f.Id,f.Name));
                if(String.IsEmpty(mynewcategory))
                    mynewcategory=f.Id;
            }
    }
    return newcategories;
}
private String mynewcategory=null;
public String getnewcategory()
{
    getnewcategories();
    return mynewcategory;
}
public void setnewcategory(String value)
{
    if(String.IsEmpty(value))
        value=null;
    if(mynewcategory!=value)
        mynewcategory=value;
}

private List<SelectOption> pricelists=null;
public  List<SelectOption> getpricelists()
{
    if(pricelists==null)
    {
        pricelists=new List<SelectOption>();
        pricelists.add(new SelectOption('','-- Select --'));
        if(record.Account_for__r.Business_Area__c != null)
        for(String val:record.Account_for__r.Business_Area__c.split(';',0))
        {
            List<Price_List__c> Price_List = [select Id, Name from Price_List__c where Business_Area__c =: val order by Name];
            for(Price_List__c pl: Price_List)
                pricelists.add(new SelectOption(pl.Id,pl.Name));
        }
    }
    return pricelists;
}
    private ApexPages.StandardController con;
    public NEU_OM_CreateItemsLinesAndDiscount(ApexPages.StandardController stdController) {
        editPriceList=true;
        if (!Test.isRunningTest())
        stdController.AddFields(new String[]
            {
                'Id',
                'Name',
                'Account_for__c',
                'Account_for_Record_Type__c',
                'Catalog_Price_List__r.Business_Area__c',
                'Catalog_Price_List__r.Family__c',
                'Account_for__r.Business_Area__c',
                'Catalog_Price_List__c',
                'Account_for_Price_List__c',
                'Account_for_Price_List__r.Price_List__c',
                'Account_for_Price_List__r.Price_List__r.Business_Area__c',
                'Account_for_Price_List__r.Price_List__r.Family__c'
            });
        con=stdController;
        record=(Customer_Quote__c)stdController.getRecord();
        if((record.Account_for_Price_List__c!=null)||(record.Catalog_Price_List__c !=null))
            editPriceList=false;
        TempPrice_List=record.Catalog_Price_List__c;
    }
    public void categories()
    {
        Item_List_Price = null;
        newcategories=null;
        record.Catalog_Price_List__c=TempPrice_List;
        System.debug('newcategories=null');
    }
    
    //Consultar las lineas insertadas
    public List<Quote_Item_Line__c> getquoteItemLines()
    {
        if(String.IsNotEmpty(getnewcategory()))
            quoteItemLines = [select Id, Amount__c, Total_Shipping_Volume_m3__c, Unit_of_measure__c, Name, Price__c, List_Price__c, Item_Price__c, Item_Name__r.Item_Price__c, Extension_Item_Name__c, Total_Shipping_Weight_Kgs__c, Weight_Kgs__c , Units__c , Item_Name__c, Item_Name__r.Name, Subfamily__r.Id, Subfamily__r.Name, Discount__c from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id and Item_Name__r.Sourcing_Family__c =: getnewcategory() order by Name];
        else
            quoteItemLines = [select Id, Amount__c, Total_Shipping_Volume_m3__c, Unit_of_measure__c, Name, Price__c, List_Price__c, Item_Price__c, Item_Name__r.Item_Price__c, Extension_Item_Name__c, Total_Shipping_Weight_Kgs__c, Weight_Kgs__c , Units__c , Item_Name__c, Item_Name__r.Name, Subfamily__r.Id, Subfamily__r.Name, Discount__c from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id order by Name];
    
        return quoteItemLines;
    }

    public List<NEUEBUSCM_Quote_Item_Line_s> getFamilyList(String family)
    {
            String myPriceList=null;
            if(record.Account_for_Price_List__c != null)
            {
                List<Customer_Price_List__c> Acc_Price_List = [select Id,Name, Price_List__c  from Customer_Price_List__c where Id =: record.Account_for_Price_List__c order by Name];
                myPriceList=Acc_Price_List[0].Price_List__c;
            }
            else if(record.Catalog_Price_List__c!=null)
                myPriceList=record.Catalog_Price_List__c;
                
            List<NEUEBUSCM_Quote_Item_Line_s> Family_Item_List_Price=new List<NEUEBUSCM_Quote_Item_Line_s>();
            List<Sourcing_Item__c> lista_items_query = null;
            List<Item_List_Price__c> lista_item_list = null;
            if(String.IsNotEmpty(family))
            {
                if(myPriceList != null)
                    lista_item_list = [select Id, Price_List__c, Item_Name__c, Item_Name__r.Weight_Kgs__c, Item_Name__r.Current_Supplier__c,Item_Name__r.Item_Price__c, Item_Name__r.Account_Owner__c, Item_Name__r.Unit_of_measure__c, Item_Name__r.Subfamily__r.Name, Item_Name__r.Name, Item_Price__c, Item_Name__r.Sourcing_Family__r.Name, List_Price__c from Item_List_Price__c where Price_List__c=:myPriceList and Item_Name__r.Sourcing_Family__c =: family order by Name];
            }
            else
            {
                if(myPriceList != null)
                    lista_item_list = [select Id, Price_List__c, Item_Name__c,Item_Name__r.Weight_Kgs__c, Item_Name__r.Current_Supplier__c,Item_Name__r.Item_Price__c, Item_Name__r.Account_Owner__c, Item_Name__r.Unit_of_measure__c, Item_Name__r.Subfamily__r.Name, Item_Name__r.Name, Item_Price__c, Item_Name__r.Sourcing_Family__r.Name, List_Price__c from Item_List_Price__c where Price_List__c=:myPriceList order by Name];
            }
            
            if(myPriceList == null)
            {
                if(String.IsNotEmpty(family))
                    lista_items_query =[select Id, Name, Weight_Kgs__c,Current_Supplier__c,Account_Owner__c, Unit_of_measure__c, Subfamily__r.Name, Sourcing_Family__r.Name, Item_Price__c  from Sourcing_Item__c where Sourcing_Family__c =: family];
                else
                    lista_items_query =[select Id, Name, Weight_Kgs__c,Current_Supplier__c,Account_Owner__c, Unit_of_measure__c, Subfamily__r.Name, Sourcing_Family__r.Name, Item_Price__c from Sourcing_Item__c limit 1000];
            }
            if(myPriceList != null)
            {
                for(Item_List_Price__c lp: lista_item_list)
                {
                    Quote_Item_Line__c quote_line = new Quote_Item_Line__c();
                    quote_line.Import_Export_Quote__c=record.Id;
                    quote_line.Units__c=1;
                    quote_line.Price__c=(lp.List_Price__c!=null?lp.List_Price__c:lp.Item_Price__c);
                    quote_line.Unit_Origin_Buy_Price__c=lp.Item_Price__c;
                    quote_line.Item_Name__c=lp.Item_Name__c;
                    quote_line.Item_Name__r=lp.Item_Name__r;
                    quote_line.Item_List_Price__c=lp.Id;
                    quote_line.Item_List_Price__r=lp;
                    if(record.Account_for_Record_Type__c=='Supplier')
                        quote_line.Item_Supplier_Owner__c=record.Account_for__c;
                    else if(lp.Item_Name__r.Current_Supplier__c!=null)
                        quote_line.Item_Supplier_Owner__c=lp.Item_Name__r.Current_Supplier__c;
                    else
                        quote_line.Item_Supplier_Owner__c=lp.Item_Name__r.Account_Owner__c;
                    quote_line.Family__c=lp.Item_Name__r.Sourcing_Family__c;
                    quote_line.Subfamily__c=lp.Item_Name__r.Subfamily__c;
                    quote_line.Subfamily__r=lp.Item_Name__r.Subfamily__r;
                    Family_Item_List_Price.add(new NEUEBUSCM_Quote_Item_Line_s(quote_line));
                }
            }
            else
            {
                for(Sourcing_Item__c lp: lista_items_query)
                {
                    Quote_Item_Line__c quote_line = new Quote_Item_Line__c();
                    quote_line.Import_Export_Quote__c=record.Id;
                    quote_line.Units__c=1;
                    quote_line.Price__c=lp.Item_Price__c;
                    quote_line.Unit_Origin_Buy_Price__c=lp.Item_Price__c;
                    quote_line.Item_Name__c=lp.Id;
                    quote_line.Item_Name__r=lp;
                    if(record.Account_for_Record_Type__c=='Supplier')
                        quote_line.Item_Supplier_Owner__c=record.Account_for__c;
                    else if(lp.Current_Supplier__c!=null)
                        quote_line.Item_Supplier_Owner__c=lp.Current_Supplier__c;
                    else
                        quote_line.Item_Supplier_Owner__c=lp.Account_Owner__c;
                    quote_line.Family__c=lp.Sourcing_Family__c;
                    quote_line.Subfamily__c=lp.Subfamily__c;
                    quote_line.Subfamily__r=lp.Subfamily__r;
                    Family_Item_List_Price.add(new NEUEBUSCM_Quote_Item_Line_s(quote_line));
                }
            }
            
            return Family_Item_List_Price;
    }
    
    public void delete_item_line_select()
  {
      List<Quote_Item_Line__c> lines_del = null;
      lines_del=[select Id,Name from Quote_Item_Line__c where  Id =:id_oi];
      try
      {
        delete lines_del;
        quoteItemLines = null;
        Item_List_Price = null;
      } 
     catch(Exception ex){}
  }
    public PageReference return_quote()
    {
        return con.view();
    }
    
    // rellenar la lista y Sacar los items no insertados
    public List<NEUEBUSCM_Quote_Item_Line_s> getItem_List_Price()
    {
        
        if(Item_List_Price==null)
            Item_List_Price=new List<NEUEBUSCM_Quote_Item_Line_h>();
        
        List<NEUEBUSCM_Quote_Item_Line_s>ret=null;
        
        for(NEUEBUSCM_Quote_Item_Line_h myitem:Item_List_Price)
            if(myitem.family==getnewcategory())
                ret=myitem.mylist;
        if(ret==null)
        {
            ret=getFamilyList(mynewcategory);
            NEUEBUSCM_Quote_Item_Line_h myitem=new NEUEBUSCM_Quote_Item_Line_h();
            myitem.family=getnewcategory();
            myitem.mylist=ret;
            Item_List_Price.add(myitem);
        }
        
        return ret;
    }
    
    public class NEUEBUSCM_Quote_Item_Line_h
    {
        public List<NEUEBUSCM_Quote_Item_Line_s>mylist=null;
        public String family=''; 
    }
    
    //clase nuevo objeto
    public class NEUEBUSCM_Quote_Item_Line_s
    {
        public Quote_Item_Line__c quote_line {get; set;}
        public boolean selected {get; set;}
        
        public NEUEBUSCM_Quote_Item_Line_s(Quote_Item_Line__c quote_line)
        {
            this.quote_line=quote_line;
            this.selected=false;
        }
        
    }   
    //Consultar las insertadas nuevo objet    
    public void crearlineaquoteitem()
    {   
        if((Item_List_Price!=null))
        {
            List<Quote_Item_Line__c> toInsert=new List<Quote_Item_Line__c>();
            List<Quote_Item_Line__c> Quote_items = [select Id from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id];
            integer contadordelineas=Quote_items.size();
            for(NEUEBUSCM_Quote_Item_Line_h myitem:Item_List_Price)
            {
                for(NEUEBUSCM_Quote_Item_Line_s line:myitem.mylist)
                {
                    if(line.selected)
                    {
                        contadordelineas ++;
                        string nombre_linea = '';
                        line.quote_line.Name=string.valueof(contadordelineas);
                        while(line.quote_line.Name.length()<3)
                            line.quote_line.Name='0'+line.quote_line.Name;
                        toInsert.add(line.quote_line);
                    }
                }
            }
            if(toInsert.size()>0)
            {
                try{
                    insert toInsert;
                }
                catch(Exception e)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                    return;
                }
                Item_List_Price=null;
                if((record.Account_for_Price_List__c != null || record.Catalog_Price_List__c!=null))
                    update record;
                editPriceList=false;
                return;
            }
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You haven\'t selected any Item to create Quote Item Lines'));
    }
   
}