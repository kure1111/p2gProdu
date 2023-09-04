public with sharing class NEU_OM_Allocate_Account_PriceList {

    public Account record;
    public  List<pricelists_s> listado_pricelist = null;
    private List<SelectOption> newcategories=null;
    public string comprobante_bussiness_area = '';
    public String id_oi {get;set;}
    
    ApexPages.StandardController con;
    
    public  List<SelectOption> getnewcategories()
    {
      if(newcategories==null)
      {
          mynewcategory=null;
          newcategories=new List<SelectOption>();
          string consulta_bussiness_area ='';
          consulta_bussiness_area = record.Business_Area__c;
          String[] bussiness_area = new String[]{};
        
          if(consulta_bussiness_area != null && consulta_bussiness_area != '')
            bussiness_area = consulta_bussiness_area.split(';',0);  
    
          string comprobante ='';
          for(integer z = 0; z < bussiness_area.size(); z++)
          {
              if(comprobante_bussiness_area.contains(bussiness_area[z]) == false)
              {
                  newcategories.add(new SelectOption(bussiness_area[z],bussiness_area[z]));
                  if(String.IsEmpty(mynewcategory))
                      mynewcategory=bussiness_area[z];
                    
                  comprobante_bussiness_area +=bussiness_area[z];
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
        public Price_List__c line {get; set;}
        public boolean selected {get; set;}
        public boolean insertado {get; set;}

        
      public pricelists_s(Price_List__c line,boolean selected, boolean insertado)
      {
        this.line=line;
        this.selected=selected;
        this.insertado=insertado;
      }
    }
    
    public List<pricelists_s> getlistado_pricelist()
    {

          listado_pricelist = new List<pricelists_s>();
          List<Customer_Price_List__c> Customer_List = new List<Customer_Price_List__c>();
          Customer_List = [select Id,Name, Customer__c, Price_List__c, Customer__r.Business_Area__c, Price_List__r.Business_Area__c, Price_List__r.Name, Price_List__r.Description__c, Price_List__r.Family__c, Price_List__r.Subfamily__c from Customer_Price_List__c where Customer__c =: record.Id and Price_List__r.Business_Area__c  =:getnewcategory() order by Price_List__r.Name];
          String[] listpriceanadidos = new String [Customer_List.size()];
          for(Customer_Price_List__c cpl :Customer_List )
          {
            listpriceanadidos.add(cpl.Price_List__c);
            listado_pricelist.add(new pricelists_s(cpl.Price_List__r,false,true));
          }
          
          List<Price_List__c> Price_List = new List<Price_List__c>();
          Price_List = [select Id, Name, Business_Area__c, Subfamily__r.Name, Family__r.Name, Description__c, Family__c, Subfamily__c from Price_List__c where Business_Area__c =:getnewcategory() and id Not IN:listpriceanadidos   order by Name];
           for(Price_List__c cpl :Price_List )
          {
            listado_pricelist.add(new pricelists_s(cpl,false,false));
          }
          
          return listado_pricelist;
    }
    
    
    public NEU_OM_Allocate_Account_PriceList(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Business_Area__c from Account where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Account();
        }
        
        
    }
    
    public void asignar_price_list()
    {
         for (pricelists_s lines:listado_pricelist)
         {
            if(lines.selected)
            {
              Customer_Price_List__c myLine= new Customer_Price_List__c();
              myline.Name=record.Name;
              myline.Customer__c=record.Id;
              myline.Price_List__c=lines.line.Id;
                
              try
              {
                insert myLine;
          
              }
              catch(Exception e){}
            }
        }
        
    }
    
    public void delete_supplier_select()
    {
        List<Customer_Price_List__c> lines_del = null;
        lines_del=[select Id,Name, Customer__c, Price_List__c from Customer_Price_List__c where Customer__c =: record.Id and Price_List__c =:id_oi];
        try
        {
           delete lines_del;
        } 
        catch(Exception ex){}
    }
  
      public PageReference return_project()
      {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
      }
    
}