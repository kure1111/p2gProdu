public with sharing class NEU_OM_Allocate_Account_toPriceList {

    public Price_List__c record;
    public  List<cuentas_s> listado_cuentas = null;
    private List<SelectOption> newcategories=null;
    public string comprobante_familias = '';
    public String id_oi {get;set;}
    
    ApexPages.StandardController con;
    
    public  List<SelectOption> getnewcategories()
    {
      if(newcategories==null)
      {
          mynewcategory=null;
          newcategories=new List<SelectOption>();
          List<SelectOption> options = new List<SelectOption>();
          List<Price_List__c> pricelis = new List<Price_List__c>();
          if(record.Business_Area__c != null)
            pricelis = [select Id, Name, Business_Area__c from Price_List__c where  Business_Area__c =: record.Business_Area__c];
          else
            pricelis = [select Id, Name, Business_Area__c from Price_List__c order by Business_Area__c];
          comprobante_familias = '';
          for(Price_List__c fs : pricelis)
          {
            if(fs.Business_Area__c != null)
                if(comprobante_familias.contains(fs.Business_Area__c) == false)
                {
                    newcategories.add(new SelectOption(fs.Business_Area__c,fs.Business_Area__c));
                    if(String.IsEmpty(mynewcategory))
                        mynewcategory=fs.Business_Area__c;
                        
                    comprobante_familias +=fs.Business_Area__c;
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
    
    public NEU_OM_Allocate_Account_toPriceList(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Business_Area__c from Price_List__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Price_List__c();
        }
        
    }
    
    public class cuentas_s
    {
        public Account line {get; set;}
        public boolean selected {get; set;}
        public boolean insertado {get; set;}
      public cuentas_s(Account line,boolean selected,boolean insertado)
      {
        this.line=line;
        this.selected=selected;
        this.insertado=insertado;
      }
    }
    
    
    public List<cuentas_s> getlistado_cuentas()
    { 
        listado_cuentas=new List<cuentas_s>();
        List<Customer_Price_List__c> Customer_Price_List = new List<Customer_Price_List__c>();
        Customer_Price_List = [select Id, Name, Customer__c, Customer__r.Name, Price_List__c, Customer__r.Record_Type_Name__c , Customer__r.Business_Area__c from Customer_Price_List__c where Price_List__c =: record.Id and Customer__r.Business_Area__c includes (: getnewcategory())];
        String[] cuentas_metidas = new String[Customer_Price_List.size()];
        for(Customer_Price_List__c li: Customer_Price_List)
        {
            cuentas_metidas.add(li.Customer__c);
            listado_cuentas.add(new cuentas_s(li.Customer__r,true,true));   
        }
        List<Account> cuentas = new List<Account>();
        cuentas = [select Id, Name, Business_Area__c, Record_Type_Name__c from Account where Business_Area__c !=: null and id NOT IN: cuentas_metidas and Business_Area__c includes (: getnewcategory()) and (Record_Type_Name__c =:'Customer' or Record_Type_Name__c =:'Supplier')];
          for(Account li: cuentas)
          {
        
            listado_cuentas.add(new cuentas_s(li,false,false));
    
          }
          
        return listado_cuentas;
        
    } 
    
    public void asignar_price_list()
    {
         for (cuentas_s lines:listado_cuentas)
         {
            if(lines.selected == true && lines.insertado== false)
            {
              Customer_Price_List__c myLine= new Customer_Price_List__c();
              myline.Name= lines.line.Name +'-'+record.Name;
              myline.Customer__c=lines.line.Id;
              myline.Price_List__c=record.Id;
                
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
        lines_del=[select Id,Name,Price_List__c,Customer__c  from Customer_Price_List__c where Price_List__c =: record.Id and Customer__c =:id_oi];
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