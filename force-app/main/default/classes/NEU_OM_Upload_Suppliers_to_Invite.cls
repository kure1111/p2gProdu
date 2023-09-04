public with sharing class NEU_OM_Upload_Suppliers_to_Invite {
    

    public Supply_Project__c record;
    private List<Supplier_s> lista_suppliers = null;
    private List<Supplier_to_Invite__c> lista_todos_suppliers = null;
    public String orden_quotes {get;set;}
    private List<SelectOption> newcategories=null;
    public String id_oi {get;set;}
    public String[] ordenacion_quotes;
    public String comprobante_familias {get;set;}

  public String subfamily{get;
    set
    {
      if(subfamily!=value)
      {
        subfamily=value;
        lista_suppliers = null;
        items=null;
        item=null;
      }
    }
  }
    public List<SelectOption> subfamilies
    {
        get
        {
            if((subfamilies==null)&&(String.IsNotEmpty(getnewcategory())))
            {
                subfamilies=new List<SelectOption>();
                subfamilies.add(new SelectOption('','All Subfamilies'));
                for(Subfamily__c f:[select Id,Name from Subfamily__c where Product_Family__c=:getnewcategory() order by Name])
                if(f.Name.length()>40)
                    subfamilies.add(new SelectOption(f.Id,f.Name.Substring(40)));
                else
                    subfamilies.add(new SelectOption(f.Id,f.Name));
            }
            return subfamilies;
        }
        set;
    }
  public string item{get;
    set
    {
      if(item!=value)
      {
        item=value;
        lista_suppliers = null;
      }
    }
  }
    public List<SelectOption> items
    {
        get
        {
            if((items==null)&&(String.IsNotEmpty(getnewcategory())))
            {
                items=new List<SelectOption>();
                items.add(new SelectOption('','All Items'));
                List<Sourcing_Item__c>is;
                if(String.IsEmpty(subfamily))
                  is=[select Id,Name from Sourcing_Item__c where Sourcing_Family__c=:getnewcategory() order by Name];
                else
                  is=[select Id,Name from Sourcing_Item__c where Subfamily__c=:subfamily order by Name];
                for(Sourcing_Item__c f:is)
                  if(f.Name.length()>40)
                      items.add(new SelectOption(f.Id,f.Name.Substring(40)));
                  else
                      items.add(new SelectOption(f.Id,f.Name));
            }
            return items;
        }
        set;
    }
    
    ApexPages.StandardController con;
   //lista de abajo todos los suppliers insertados
    public  List<Supplier_to_Invite__c> getlista_todos_suppliers()
    {
        List<Supplier_to_Invite__c> lista_todos_suppliers=new List<Supplier_to_Invite__c>();
        lista_todos_suppliers = [select Id,Name, Supply_Project__c, Account__c, Account__r.Name, Account__r.Brand_Name__c, Account__r.Activity_Sector__c, Account__r.Description, Account__r.Quality_Products_Score__c, Account__r.Delivery_Times_Score__c, Account__r.Colaboration_Score__c, Account__r.Prices_Score__c, Account__r.Efficiency_Level_Score__c, Rol__c, Responsible_for_the_Project__c, Responsible_for_the_Project__r.Name from Supplier_to_Invite__c where Supply_Project__c =: record.Id];
        return lista_todos_suppliers;
    }
    
    public  List<SelectOption> getnewcategories()
    {
      if(newcategories==null)
      {
          mynewcategory=null;
          newcategories=new List<SelectOption>();
          List<SelectOption> options = new List<SelectOption>();
          List<Family_Supplied__c> familiesup = new List<Family_Supplied__c>();
          
          
          
          
       
      if(record.Sourcing_Family__c != null)
        familiesup = [select Id, Name, Family__c, Family__r.Name, Supplier_Account__c, Supplier_Account__r.Name, Supplier_Account__r.Status_Account__c, Supplier_Account__r.Brand_Name__c, Supplier_Account__r.Activity_Sector__c, Supplier_Account__r.Description, Supplier_Account__r.Quality_Products_Score__c, Supplier_Account__r.Prices_Score__c, Supplier_Account__r.Colaboration_Score__c, Supplier_Account__r.Delivery_Times_Score__c, Supplier_Account__r.Efficiency_Level_Score__c, Family__r.Business_Area__c, Supplier_Account__r.RecordTypeId from Family_Supplied__c where  (Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId()  or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Purchase Agent').getRecordTypeId()) and  Family__c =: record.Sourcing_Family__c order by Family__r.Name];
      else if(record.Business_Area__c != null)
        familiesup = [select Id, Name, Family__c, Family__r.Name, Supplier_Account__c, Supplier_Account__r.Name, Supplier_Account__r.Status_Account__c, Supplier_Account__r.Brand_Name__c, Supplier_Account__r.Activity_Sector__c, Supplier_Account__r.Description, Supplier_Account__r.Quality_Products_Score__c, Supplier_Account__r.Prices_Score__c, Supplier_Account__r.Colaboration_Score__c, Supplier_Account__r.Delivery_Times_Score__c, Supplier_Account__r.Efficiency_Level_Score__c, Family__r.Business_Area__c, Supplier_Account__r.RecordTypeId from Family_Supplied__c where  (Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId()  or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Purchase Agent').getRecordTypeId()) and Family__r.Business_Area__c =: record.Business_Area__c order by Family__r.Name];
      else
        familiesup = [select Id, Name, Family__c, Family__r.Name, Supplier_Account__c, Supplier_Account__r.Name, Supplier_Account__r.Status_Account__c, Supplier_Account__r.Brand_Name__c, Supplier_Account__r.Activity_Sector__c, Supplier_Account__r.Description, Supplier_Account__r.Quality_Products_Score__c, Supplier_Account__r.Prices_Score__c, Supplier_Account__r.Colaboration_Score__c, Supplier_Account__r.Delivery_Times_Score__c, Supplier_Account__r.Efficiency_Level_Score__c, Family__r.Business_Area__c, Supplier_Account__r.RecordTypeId from Family_Supplied__c where  (Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId()  or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Purchase Agent').getRecordTypeId()) order by Family__r.Name];
          
          
          comprobante_familias = '';
          for(Family_Supplied__c fs : familiesup)
          {
            if(comprobante_familias.contains(fs.Family__c) == false)
            {
                newcategories.add(new SelectOption(fs.Family__c,fs.Family__r.Name));
                if(String.IsEmpty(mynewcategory))
                    mynewcategory=fs.Family__c;
                    
                comprobante_familias +=fs.Family__c;
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
            subfamilies=null;
            subfamily=null;
      items=null;
      item=null; 
            lista_suppliers = null;
    }
    }

    public class Supplier_s implements Comparable
    {
        public Account line {get; set;}
        public boolean selected {get; set;}
        public boolean insertado {get; set;}
        public List<SelectOption> contact {get; set;}
        public string contact_select {get; set;}
        public string campo_compare  {get; set;}
        public string orden_de_comparacion{get;set;}
        public Supplier_s(Account line, boolean selected, boolean insertado, List<SelectOption> contact, string contact_select )
        {
                this.line=line;
                this.selected=selected;
                this.insertado=insertado;
                this.contact=contact;
                this.contact_select = contact_select;
        }
        
        
           public Integer compareTo(Object compareTo) {
            
              system.debug('upload suppliers to invite'+compareTo);
              Supplier_s compareToEmp = (Supplier_s)compareTo;
              if(campo_compare  == 'line.Name')
              {
                if(line.Name == compareToEmp.line.Name) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Name > compareToEmp.line.Name) return 1;
                }
                else
                    if (line.Name < compareToEmp.line.Name) return 1;
              
              }
              
               if(campo_compare  == 'line.Brand_Name__c')
              {
                if(line.Brand_Name__c == compareToEmp.line.Brand_Name__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Brand_Name__c > compareToEmp.line.Brand_Name__c) return 1;
                }
                else
                    if (line.Brand_Name__c < compareToEmp.line.Brand_Name__c) return 1;
              
              }
              
               if(campo_compare  == 'line.Activity_Sector__c')
              {
                if(line.Activity_Sector__c == compareToEmp.line.Activity_Sector__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Activity_Sector__c > compareToEmp.line.Activity_Sector__c) return 1;
                }
                else
                    if (line.Activity_Sector__c < compareToEmp.line.Activity_Sector__c) return 1;
              
              }
              
               if(campo_compare  == 'line.Description')
              {
                if(line.Description== compareToEmp.line.Description) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Description> compareToEmp.line.Description) return 1;
                }
                else
                    if (line.Description< compareToEmp.line.Description) return 1;
              
              }
              
               if(campo_compare  == 'contact_select')
              {
                if(contact_select == compareToEmp.contact_select) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (contact_select > compareToEmp.contact_select) return 1;
                }
                else
                    if (contact_select < compareToEmp.contact_select) return 1;
              
              }
              
               if(campo_compare  == 'line.Quality_Products_Score__c')
              {
                if(line.Quality_Products_Score__c == compareToEmp.line.Quality_Products_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Quality_Products_Score__c > compareToEmp.line.Quality_Products_Score__c) return 1;
                }
                else
                    if (line.Quality_Products_Score__c < compareToEmp.line.Quality_Products_Score__c) return 1;
              
              }
              
               if(campo_compare  == 'line.Prices_Score__c')
              {
                if(line.Prices_Score__c == compareToEmp.line.Prices_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Prices_Score__c > compareToEmp.line.Prices_Score__c) return 1;
                }
                else
                    if (line.Prices_Score__c < compareToEmp.line.Prices_Score__c) return 1;
              
              }
              
               if(campo_compare  == 'line.Colaboration_Score__c')
              {
                if(line.Colaboration_Score__c == compareToEmp.line.Colaboration_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Colaboration_Score__c > compareToEmp.line.Colaboration_Score__c) return 1;
                }
                else
                    if (line.Colaboration_Score__c < compareToEmp.line.Colaboration_Score__c) return 1;
              
              }
              
               if(campo_compare  == 'line.Delivery_Times_Score__c')
              {
                if(line.Delivery_Times_Score__c == compareToEmp.line.Delivery_Times_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Delivery_Times_Score__c > compareToEmp.line.Delivery_Times_Score__c ) return 1;
                }
                else
                    if (line.Delivery_Times_Score__c < compareToEmp.line.Delivery_Times_Score__c) return 1;
              
              }
              
                if(campo_compare  == 'line.Efficiency_Level_Score__c')
              {
                if(line.Efficiency_Level_Score__c == compareToEmp.line.Efficiency_Level_Score__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (line.Efficiency_Level_Score__c > compareToEmp.line.Efficiency_Level_Score__c) return 1;
                }
                else
                    if (line.Efficiency_Level_Score__c < compareToEmp.line.Efficiency_Level_Score__c) return 1;
              
              }
              
               return -1;
           }
              
    } 
    
    public void go_compare()
    {
      
        ordenacion_quotes = new String[]{};
        if(orden_quotes != null)
        {
            ordenacion_quotes = orden_quotes.split('-'); 
            for(Supplier_s li: getlista_suppliers())
            {
              li.campo_compare = ordenacion_quotes[0];
              li.orden_de_comparacion = ordenacion_quotes[1];
            }  
        lista_suppliers.sort();
        }
          
    }
        
    public List<Supplier_s> getlista_suppliers()
    {
        if(lista_suppliers == null)
        {
          lista_suppliers=new List<Supplier_s>();
          List<Supplier_to_Invite__c> lines_insertadas =[select Id,Name, Supply_Project__c, Account__c, Account__r.Name, Account__r.Brand_Name__c, Account__r.Activity_Sector__c, Account__r.Description, Account__r.Quality_Products_Score__c, Account__r.Delivery_Times_Score__c, Account__r.Colaboration_Score__c, Account__r.Prices_Score__c, Account__r.Efficiency_Level_Score__c, Rol__c, Responsible_for_the_Project__c, Responsible_for_the_Project__r.Name from Supplier_to_Invite__c where Supply_Project__c =: record.Id order by Account__r.Name];
          List<Contact> contacts = [select Id, Name, AccountId, Email from Contact where Email != null];
          List<Family_Supplied__c> familiesup = [select Id, Name,  Family__r.id,Subfamily__c,Item__c, Supplier_Account__c, Supplier_Account__r.Name, Supplier_Account__r.Status_Account__c, Supplier_Account__r.Brand_Name__c, Supplier_Account__r.Activity_Sector__c, Supplier_Account__r.Description, Supplier_Account__r.Quality_Products_Score__c, Supplier_Account__r.Prices_Score__c, Supplier_Account__r.Colaboration_Score__c, Supplier_Account__r.Delivery_Times_Score__c, Supplier_Account__r.Efficiency_Level_Score__c, Family__r.Business_Area__c, Supplier_Account__r.RecordTypeId from Family_Supplied__c where  (Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId()  or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Purchase Agent').getRecordTypeId()) and Family__c =: getnewcategory() order by Supplier_Account__r.Status_Account__c];
        
          String[] arrayids = new String[lines_insertadas.size()];
          string contenedor_de_cuentas = '';
          //los suppliers insertados
          for(Supplier_to_Invite__c l:lines_insertadas)
          {
            for(Family_Supplied__c fs: familiesup)
            {
              if(String.IsNotEmpty(subfamily))
                if(subfamily!=fs.Subfamily__c)
                  continue;
              if(String.IsNotEmpty(item))
                if(item!=fs.Item__c)
                  continue;
                  
                if(fs.Supplier_Account__c == l.Account__c)
                {
                    arrayids.add(l.Account__c);
                    List<SelectOption> options = new List<SelectOption>(); 
                    /*for(Contact co : contacts)
                    {
                        if(co.AccountId == l.Account__c)
                            options.add(new SelectOption(co.Id,co.Name));
                            
                    }  */
                    if(contenedor_de_cuentas == '' || contenedor_de_cuentas.contains(l.Account__c) == false)
                      lista_suppliers.add(new Supplier_s(l.Account__r,false,true,options, l.Responsible_for_the_Project__r.Name));     
                  contenedor_de_cuentas += l.Account__c;
                }
            }   
          }
          
          //los suppliers no insertados
          
            familiesup = [select Id, Name, Family__r.id,Subfamily__c,Item__c, Supplier_Account__r.Id, Supplier_Account__r.Name, Supplier_Account__r.Status_Account__c, Supplier_Account__r.Brand_Name__c, Supplier_Account__r.Activity_Sector__c, Supplier_Account__r.Description, Supplier_Account__r.Quality_Products_Score__c, Supplier_Account__r.Prices_Score__c, Supplier_Account__r.Colaboration_Score__c, Supplier_Account__r.Delivery_Times_Score__c, Supplier_Account__r.Efficiency_Level_Score__c, Family__r.Business_Area__c, Supplier_Account__r.RecordTypeId from Family_Supplied__c where  (Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId() or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId()  or Supplier_Account__r.RecordTypeId =:Schema.SobjectType.Account.getRecordTypeInfosByName().get('Purchase Agent').getRecordTypeId()) and Supplier_Account__c not IN: arrayids and Family__c =: getnewcategory() order by Supplier_Account__r.Status_Account__c];
            boolean inserted=false;
            for(Family_Supplied__c fs : familiesup)
            {
              inserted=false;
              for(Supplier_s s:lista_suppliers)
              {
                if(s.line.Id==fs.Supplier_Account__r.Id)
                {
                  inserted=true;
                  break;
                }
              }
              if(inserted)
                continue;
                
              if(String.IsNotEmpty(subfamily))
                if(subfamily!=fs.Subfamily__c)
                  continue;
                  
              if(String.IsNotEmpty(item))
                if(item!=fs.Item__c)
                  continue;
                  
                List<SelectOption> options = new List<SelectOption>(); 
                for(Contact co : contacts)
                {
                    if(co.AccountId == fs.Supplier_Account__c)
                        options.add(new SelectOption(co.Id,co.Name));
                }
                 
                lista_suppliers.add(new Supplier_s(fs.Supplier_Account__r,false,false,options,'')); 
            }
        }
        return lista_suppliers;
        
    }  
      public NEU_OM_Upload_Suppliers_to_Invite(ApexPages.StandardController stdController) {
        
           con = stdController;
              system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Subfamily__c, Sourcing_Family__c, Sourcing_Family__r.Name, Subfamily__r.Name, Business_Area__c from Supply_Project__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
          record = new Supply_Project__c();
        }
  }
  
  
  public void crearsupplierinvite()
  {
     for (Supplier_s lines:getlista_suppliers())
     {
          
          if(lines.selected)
          {
            Supplier_to_Invite__c myLine= new Supplier_to_Invite__c();
            myline.Supply_Project__c=record.Id;
            myline.Name = lines.line.Name;
            myline.Account__c=lines.line.Id;
            if(lines.contact_select != null && lines.contact_select != '')
              myline.Responsible_for_the_Project__c = lines.contact_select;
              
            try
            {
              insert myLine;
        
            }
            catch(Exception e){}
          }
    }
    lista_suppliers = null;
    
    
  }
  
  public void delete_supplier_select()
  {
      List<Supplier_to_Invite__c> lines_del = null;
      lines_del=[select Id,Name, Supply_Project__c, Account__c, Account__r.Name, Account__r.Brand_Name__c, Account__r.Activity_Sector__c, Account__r.Description, Account__r.Quality_Products_Score__c, Account__r.Delivery_Times_Score__c, Account__r.Colaboration_Score__c, Account__r.Prices_Score__c, Account__r.Efficiency_Level_Score__c, Rol__c, Responsible_for_the_Project__c, Responsible_for_the_Project__r.Name from Supplier_to_Invite__c where Supply_Project__c =: record.Id and Account__c =:id_oi];
      try
      {
        delete lines_del;
      } 
     catch(Exception ex){}
     
     lista_suppliers = null;
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