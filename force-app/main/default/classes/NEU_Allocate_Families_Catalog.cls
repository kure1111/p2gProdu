public with sharing class NEU_Allocate_Families_Catalog {

    public Price_List__c record;
    public  List<pricelists_s> listado_pricelist = null;
    private List<SelectOption> newcategories=null;
    public string comprobante_familias = '';
    public String id_oi {get;set;}
    
    public string search_filter {get;set;}
    public string search_text {get;set;}
    
    
    public string step {get;set;} 
    public integer offset_lines = 0;
    public string sort_value {get;set;}


    
    ApexPages.StandardController con;
    
    public NEU_Allocate_Families_Catalog(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Business_Area__c, Items_Account_Owner__c, Family__c, Subfamily__c from Price_List__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Price_List__c();
        }
        search_filter = '';
    }
    
    public  List<SelectOption> getnewcategories()
    {
      if(newcategories==null)
      {
          mynewcategory=null;
          newcategories=new List<SelectOption>();
        /*List<Product_Family__c> Product_Family = new List<Product_Family__c>();
        
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
            }*/
            
            if(record.Business_Area__c != null)
            {
                newcategories.add(new SelectOption(record.Business_Area__c,record.Business_Area__c));
                if(String.IsEmpty(mynewcategory))
                    mynewcategory=record.Business_Area__c;
            }
            else
            {
                Schema.DescribeFieldResult fieldResult = Account.Business_Area__c.getDescribe();
                 List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                  for( Schema.PicklistEntry f : ple)
                 {
                    newcategories.add(new SelectOption(f.getValue(),f.getValue()));
                    if(String.IsEmpty(mynewcategory))
                        mynewcategory=f.getValue();
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
        mynewcategory=value;
    }
    
    public class pricelists_s
    {
        public Product_Family__c line {get; set;}
        public boolean selected {get; set;}
        public boolean insertado {get; set;}
       
        
      public pricelists_s(Product_Family__c line, boolean selected, boolean insertado)
      {
        this.line=line;
        this.selected=selected;
        this.insertado=insertado;
      }
    }
    
    public List<pricelists_s> getlistado_pricelist()
    {

          listado_pricelist = new List<pricelists_s>();
          List<Product_Family__c> family_List = new List<Product_Family__c>();
          
          if(search_filter !='' && search_filter != null && search_filter !='All') 
          {
            List<sObject> producto_query = Database.query('SELECT Id, Name, Description__c, Ecommerce__c, Url_Image__c, Keywords__c, Ranking__c  FROM Product_Family__c WHERE Name LIKE \''+search_filter+'%\' AND Business_Area__c =\''+getnewcategory()+'\' ORDER BY Name');
            family_List = producto_query;
          }
          else
            family_List = [select Id, Name, Business_Area__c, Description__c, Ecommerce__c, Url_Image__c, Keywords__c, Ranking__c from Product_Family__c where Business_Area__c =: getnewcategory()  order by Name];
         
         List<Catalog_Family__c> family_List_Price = new List<Catalog_Family__c>();
         family_List_Price = [select Id, Name, Family__c, Family__r.Description__c, Family__r.Ecommerce__c, Family__r.Url_Image__c, Family__r.Keywords__c, Family__r.Name from Catalog_Family__c where Catalog_Price_List__c =: record.Id and Family__r.Business_Area__c =: getnewcategory()  order by Family__r.Name];
    

          boolean insertado = false;
          for(Product_Family__c li: family_List)
          {//si ya esta metido salga para eliminar
            for(Catalog_Family__c flp:family_List_Price )
            {
                if(li.Id == flp.Family__c)
                {
                    listado_pricelist.add(new pricelists_s(li,false,true));
                    insertado = true;
                    break;
                }
            }
            if(insertado == false)
                listado_pricelist.add(new pricelists_s(li,false,false));
            insertado= false;
          }
          search_filter = '';
        return listado_pricelist;
        
    } 
    
    
    public void asignar_price_list()
    {
         for (pricelists_s lines:listado_pricelist)
         {
            if(lines.selected)
            {
              Catalog_Family__c myLine= new Catalog_Family__c();
              myline.Family__c = lines.line.Id;
              myline.Catalog_Price_List__c=record.Id;
              try
              {
                insert myLine;
          
              }
              catch(Exception e){}
            }
        }
        
    }
    
    public void delete_item_pricelist_select()
    {
        List<Catalog_Family__c> lines_del = null;
        lines_del=[select Id,Name from Catalog_Family__c where Family__c =: id_oi and Catalog_Price_List__c =: record.Id];
        try
        {
           delete lines_del;
        } 
        catch(Exception ex){}
    }
  
      public PageReference return_pricelist()
      {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
      }

}