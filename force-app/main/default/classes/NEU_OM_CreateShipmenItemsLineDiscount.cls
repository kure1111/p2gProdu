public with sharing class NEU_OM_CreateShipmenItemsLineDiscount {

public Shipment__c record = null;
private List<Shipment_Line__c> ShipmentItemsLines=null;
private List<Product_Family__c> family =null; 
public  List<NEUEBUSCM_Shipment_Item_Line_h> Item_List_Price = null;
public string accountpricelist {get;set;}
public string listado_familias {get;set;}
public string listado_accountpricelist {get;set;}
public string field_accountpricelist {get;set;}
public string listado_pricelist {get;set;}
public string field_pricelist {get;set;}
public string listadodecheck {get;set;}
public string nombrepricelist {get;set;}
public string bloqueolookup {get;set;}
public string idaccountpricelist{get;set;}
public boolean sf1{get;set;}
public Boolean editPriceList{get;set;}
public String id_oi {get;set;}
private string family_field='';
private string variador='';
public String TempPrice_List='';
private List<SelectOption> newcategories=null;
public boolean chekeados{get;set;}

public String getfamily_field(){
    return family_field;
}
public void setfamily_field(String value){
    if(family_field!=value)
    {
        family_field=value;
    }
}

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
        ShipmentItemsLines = null;
    }
}
public void categories()
{
        Item_List_Price = null;
        newcategories=null;
        record.Catalog_Price_List__c=TempPrice_List;
        System.debug('newcategories=null');
}
//------------------------ver
public  List<SelectOption> getnewcategories()
{
    System.debug('getnewcategories with?');
    if(newcategories==null)
    {
        System.debug('getnewcategories with newcategories==null');
        mynewcategory=null;
        newcategories=new List<SelectOption>();
        List<Product_Family__c> lista_familias = null;
        
        if(record.Account_for_Catalog_Price_List__c != null)
        {
            List<Customer_Price_List__c> Acc_Price_List = [select Id, Price_List__c, Price_List__r.Family__c,Price_List__r.Business_Area__c  from Customer_Price_List__c where Id =: record.Account_for_Catalog_Price_List__c limit 1];
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

//ApexPages.StandardController con;
    
    public NEU_OM_CreateShipmenItemsLineDiscount(ApexPages.StandardController stdController) {
     //   con = stdController;
        editPriceList=true;
       /* system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Account_for__c, Account_for_Record_Type__c,  Catalog_Price_List__r.Business_Area__c, Catalog_Price_List__r.Family__c, Account_for__r.Business_Area__c, Catalog_Price_List__c, Account_for_Catalog_Price_List__c, Account_for_Catalog_Price_List__r.Price_List__c, Account_for_Catalog_Price_List__r.Price_List__r.Business_Area__c, Account_for_Catalog_Price_List__r.Price_List__r.Family__c from Shipment__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Shipment__c();
        }*/
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
                'Account_for_Catalog_Price_List__c',
                'Account_for_Catalog_Price_List__r.Price_List__c',
                'Account_for_Catalog_Price_List__r.Price_List__r.Business_Area__c',
                'Account_for_Catalog_Price_List__r.Price_List__r.Family__c'
            });
        record=(Shipment__c)stdController.getRecord();
        
         if((record.Account_for_Catalog_Price_List__c !=null)||(record.Catalog_Price_List__c !=null))
            editPriceList=false;
        TempPrice_List=record.Catalog_Price_List__c;
        sf1=(Apexpages.currentPage().getParameters().get('sf1')!=null);
        chekeados =false;
       /* accountpricelist = '';
        family_field = '';
        listado_familias= '';
        listado_accountpricelist = '';
        listado_pricelist = '';
        field_accountpricelist = '';
        field_pricelist = '';
        listadodecheck = '';
        nombrepricelist = '';
        bloqueolookup = '';
        chekeados =false;*/
        //botones familias

        /*List<Product_Family__c> lista_familias = new List<Product_Family__c>();
        if(record.Account_for_Catalog_Price_List__r.Price_List__r.Family__c != null)
        {
             lista_familias = [SELECT Name, Id, Business_Area__c FROM Product_Family__c where Id =: record.Account_for_Catalog_Price_List__r.Price_List__r.Family__c order by Name];
            
        }
        else
        {
            if(record.Catalog_Price_List__r.Family__c != null)
            {
                 lista_familias = [SELECT Name, Id, Business_Area__c FROM Product_Family__c where Id =: record.Catalog_Price_List__r.Family__c order by Name];
                 bloqueolookup ='none';
            }
            else
            {
                if(record.Account_for_Catalog_Price_List__c != null)
                {
                    List<Item_List_Price__c> query_listado_familias_sacar = [select Item_Name__r.Sourcing_Family__c from Item_List_Price__c where Price_List__c =:record.Account_for_Catalog_Price_List__r.Price_List__c];
                    set<id>listado_familias_sacar = new set<id>();
                    for(Item_List_Price__c ilp: query_listado_familias_sacar)
                    {
                        listado_familias_sacar.add(ilp.Item_Name__r.Sourcing_Family__c);
                    }
                    lista_familias = [SELECT Name, Id, Business_Area__c  FROM Product_Family__c where Business_Area__c =: record.Account_for_Catalog_Price_List__r.Price_List__r.Business_Area__c and Id IN:listado_familias_sacar order by Name];
                    bloqueolookup ='none';
                }
                else if(record.Catalog_Price_List__c != null)
                {
                    List<Item_List_Price__c> query_listado_familias_sacar = [select Item_Name__r.Sourcing_Family__c from Item_List_Price__c where Price_List__c =:record.Catalog_Price_List__c];
                    set<id>listado_familias_sacar = new set<id>();
                    for(Item_List_Price__c ilp: query_listado_familias_sacar)
                    {
                      listado_familias_sacar.add(ilp.Item_Name__r.Sourcing_Family__c);
                    }
                    lista_familias = [SELECT Name, Id, Business_Area__c  FROM Product_Family__c where Business_Area__c =: record.Catalog_Price_List__r.Business_Area__c and Id IN:listado_familias_sacar order by Name];
                    bloqueolookup ='none';
                }
                else
                {
                     lista_familias = [SELECT Name, Id FROM Product_Family__c where Id IN(select Sourcing_Family__c from Sourcing_Item__c where Sourcing_Family__c != null) order by Name];
                }
            }
        }
        
        integer contador = 0;
        for(Product_Family__c pf : lista_familias)
        {
            if(contador == 0)
            {
                listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio" checked="checked"><label for="'+pf.Name+'" class="listafamilias" style="border-bottom-left-radius: 0px;">'+pf.Name+'</label>';
                family_field = pf.Name;
            }
            else
            {
                if(lista_familias.size() == lista_familias.size())
                    listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio"><label for="'+pf.Name+'" class="listafamilias" style="border-bottom-right-radius: 0px;">'+pf.Name+'</label>';
                else
                    listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio"><label for="'+pf.Name+'" class="listafamilias">'+pf.Name+'</label>';
            }
            contador ++;
        }
        
        //Account Price List
        if(record.Account_for_Catalog_Price_List__c != null)
        {
            listado_accountpricelist +=' <select class="listaaccountpricelist" style="width: 380px;" disabled>';
            field_accountpricelist = record.Account_for_Catalog_Price_List__r.Price_List__c;
        }
        else
        {
            if(record.Catalog_Price_List__c != null)
                listado_accountpricelist +=' <select class="listaaccountpricelist" style="width: 380px;" disabled>';
            else
                listado_accountpricelist +=' <select class="listaaccountpricelist" style="width: 380px;" >';
        }
        
        listado_accountpricelist +='                <option value="0" class="0" >-- Select --</option>';
        
        List<Customer_Price_List__c> Customer_Price_List = null;
        Customer_Price_List = [select Id,Customer__c, Price_List__c, Price_List__r.Name from Customer_Price_List__c where Customer__c =: record.Account_for__c order by Name];
        for(Customer_Price_List__c pl: Customer_Price_List)
        {   
            if(pl.Price_List__c == record.Account_for_Catalog_Price_List__r.Price_List__c)
                listado_accountpricelist += '<option value="'+pl.Price_List__c+'" selected>'+pl.Price_List__r.Name+'</option>';
            else
                listado_accountpricelist += '<option value="'+pl.Price_List__c+'">'+pl.Price_List__r.Name+'</option>';
        }
        listado_accountpricelist +=' </select>';
        
        if(record.Account_for_Catalog_Price_List__r.Price_List__c != null)
            listado_accountpricelist = record.Account_for_Catalog_Price_List__r.Price_List__c;
        
            
        //Price List
        if(record.Catalog_Price_List__c != null)
            {
                listado_pricelist +=' <select class="listapricelist" style="width: 380px;" disabled >';
                
            }
            else
                if(record.Account_for_Catalog_Price_List__c != null)
                    listado_pricelist +=' <select class="listapricelist" style="width: 380px;" disabled >';
                else
                    listado_pricelist +=' <select class="listapricelist" style="width: 380px;" >';
            listado_pricelist +='               <option value="0" class="0" >-- Select --</option>';
            
        if(field_accountpricelist == '')
        {
            if(record.Catalog_Price_List__c != null)
                field_accountpricelist = record.Catalog_Price_List__c;  
            
            List<Price_List__c> Price_List = null;
            
            string consulta_bussiness_area ='';
            consulta_bussiness_area = record.Account_for__r.Business_Area__c;
            String[] bussiness_area = new String[]{};
            
            if(consulta_bussiness_area != null && consulta_bussiness_area != '')
                bussiness_area = consulta_bussiness_area.split(';',0);  
    
            string comprobante ='';
            for(integer z = 0; z < bussiness_area.size(); z++)
            {
                Price_List = [select Id, Name, Business_Area__c from Price_List__c where Business_Area__c =: bussiness_area[z] order by Name];
                for(Price_List__c pl: Price_List)
                {   
                        if(pl.Id == record.Catalog_Price_List__c)
                            listado_pricelist += '<option value="'+pl.Id+'" selected>'+pl.Name+'</option>';
                        else
                            listado_pricelist += '<option value="'+pl.Id+'">'+pl.Name+'</option>';
                }
                
            }
            
        }
        listado_pricelist +=' </select>'; 
        
            if(ApexPages.currentPage().getParameters().get('test') != null)
                families();*/
    }
    
    public void families()
    {
       /* string businessarea= '';
        string family='';
        integer contador = 0;
        listado_familias = '';
        Item_List_Price=null;
        if(ApexPages.currentPage().getParameters().get('test') != null)
        {
             Price_List__c b = new Price_List__c(Name = 'Test acount',Business_Area__c = 'Sales');
             insert b;
             field_accountpricelist =b.Id;
             List<Price_List__c> Price_List = null;
             Price_List = [select Id,Name, Family__c, Business_Area__c from Price_List__c where Id =: field_accountpricelist order by Name];
        }
        if((record.Account_for_Catalog_Price_List__c == null && record.Catalog_Price_List__c == null) || ApexPages.currentPage().getParameters().get('test') != null)
        {
            
            List<Price_List__c> Price_List = null;
            List<Customer_Price_List__c> Acc_Price_List = null;
            if(ApexPages.currentPage().getParameters().get('test') == 'true')
            {
                nombrepricelist='test';
            }
            if(ApexPages.currentPage().getParameters().get('test') == 'false')
            {
                nombrepricelist=null;
            }
                if((nombrepricelist != null && nombrepricelist != '') )
                {
                    if(ApexPages.currentPage().getParameters().get('test') == null)
                    {
                        Acc_Price_List = [select Id,Name, Price_List__c  from Customer_Price_List__c where Name =: nombrepricelist order by Name];
                        Price_List = [select Id,Name, Family__c, Business_Area__c from Price_List__c where Id =: Acc_Price_List[0].Price_List__c order by Name];
                        idaccountpricelist = Acc_Price_List[0].Id;
                    }
                    else
                    {
                    
                        Acc_Price_List = [select Id,Name, Price_List__c  from Customer_Price_List__c limit 1];
                        Price_List = [select Id,Name, Family__c, Business_Area__c from Price_List__c limit 1];
                        idaccountpricelist = Acc_Price_List[0].Id;
                    }
                    for(Price_List__c pl: Price_List)
                    {   
                        if(pl.Family__c != null)
                            family =pl.Family__c;
                        if(pl.Business_Area__c != null)
                            businessarea = pl.Business_Area__c;
                            field_accountpricelist =pl.id;
                    }
                }
                else
                {
                    if(field_accountpricelist != null && field_accountpricelist != '')
                    {
                        Price_List = [select Id,Name, Family__c, Business_Area__c from Price_List__c where Id =: field_accountpricelist order by Name];
                
                        for(Price_List__c pl: Price_List)
                        {   
                            if(pl.Family__c != null)
                                family =pl.Family__c;
                            if(pl.Business_Area__c != null)
                                businessarea = pl.Business_Area__c;
                                field_accountpricelist =pl.id;
                        }
                    }
                }
                
            
                if(Price_List != null)
                {
                    List<Product_Family__c> lista_familias = null;
                    if(family != '')
                         lista_familias = [SELECT Name, Id, Business_Area__c FROM Product_Family__c where Id =: family order by Name];
                    else
                    {
                        if(businessarea != '')
                            lista_familias = [SELECT Name, Id, Business_Area__c  FROM Product_Family__c where Business_Area__c =: businessarea order by Name];
                    }
                    
                    if(ApexPages.currentPage().getParameters().get('test') != null)
                        lista_familias = [SELECT Name, Id, Business_Area__c  FROM Product_Family__c order by Name];
                        
                    for(Product_Family__c pf : lista_familias)
                    {
                        if(contador == 0)
                        {
                            listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio" checked="checked"><label for="'+pf.Name+'" class="listafamilias" style="border-bottom-left-radius: 0px;" onchange="cambiarfamilia();">'+pf.Name+'</label>';
                            family_field = pf.Name;
                        }
                        else
                        {
                            if(lista_familias.size() == lista_familias.size())
                                listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio"><label for="'+pf.Name+'" class="listafamilias" style="border-bottom-right-radius: 0px;" onchange="cambiarfamilia();">'+pf.Name+'</label>';
                            else
                                listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio"><label for="'+pf.Name+'" class="listafamilias" onchange="cambiarfamilia();">'+pf.Name+'</label>';
                        }
                        contador ++;
                    }
                }
                else
                {
                    
                    
                    List<Product_Family__c> lista_familias = null;
                    if(family != '')
                         lista_familias = [SELECT Name, Id, Business_Area__c FROM Product_Family__c where Id =: family order by Name];
                    else
                    {
                        if(businessarea != '')
                            lista_familias = [SELECT Name, Id, Business_Area__c  FROM Product_Family__c where Business_Area__c =: businessarea order by Name];
                        else
                            lista_familias = [SELECT Name, Id FROM Product_Family__c where Id IN(select Sourcing_Family__c from Sourcing_Item__c where Sourcing_Family__c != null) order by Name];
                    }
                    
                    if(ApexPages.currentPage().getParameters().get('test') != null)
                        lista_familias = [SELECT Name, Id, Business_Area__c  FROM Product_Family__c order by Name];
                        
                    for(Product_Family__c pf : lista_familias)
                    {
                        if(contador == 0)
                        {
                            listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio" checked="checked"><label for="'+pf.Name+'" class="listafamilias" style="border-bottom-left-radius: 0px;" onchange="cambiarfamilia();">'+pf.Name+'</label>';
                            family_field = pf.Name;
                        }
                        else
                        {
                            if(lista_familias.size() == lista_familias.size())
                                listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio"><label for="'+pf.Name+'" class="listafamilias" style="border-bottom-right-radius: 0px;" onchange="cambiarfamilia();">'+pf.Name+'</label>';
                            else
                                listado_familias +='<input type="radio" id="'+pf.Name+'" name="radio"><label for="'+pf.Name+'" class="listafamilias" onchange="cambiarfamilia();">'+pf.Name+'</label>';
                        }
                        contador ++;
                    }
                    
                }
        }
    */
        
    }
    
    //Consultar las lineas insertadas
    public List<Shipment_Line__c> getShipmentItemsLines()
    {
        
        if(String.IsNotEmpty(getnewcategory()))
            ShipmentItemsLines = [select Id, Sell_Origin_Amount__c, Shipping_Volume_m3__c, Container_Number__c, Unit_of_measure__c, Name, Unit_Origin_Sell_Price__c,  Item_Name__r.Item_Price__c, Extension_Item_Name__c, Shipping_Weight_Kg__c, Import_Export_Quote__r.Country_ofLoad__r.ISO_Code__c, Units_Shipped__c, Item_Name__c, Item_Name__r.Name, Import_Export_Quote__c, Item_Name__r.Subfamily__r.Name, Item_Name__r.Sourcing_Family__r.Name, Shipment__c from Shipment_Line__c where Shipment__c =: record.Id and Item_Name__r.Sourcing_Family__c =: getnewcategory() order by Name];
        else
            ShipmentItemsLines = [select Id, Sell_Origin_Amount__c, Shipping_Volume_m3__c, Container_Number__c, Unit_of_measure__c, Name, Unit_Origin_Sell_Price__c,  Item_Name__r.Item_Price__c, Extension_Item_Name__c, Shipping_Weight_Kg__c, Import_Export_Quote__r.Country_ofLoad__r.ISO_Code__c, Units_Shipped__c, Item_Name__c, Item_Name__r.Name, Import_Export_Quote__c, Item_Name__r.Subfamily__r.Name, Shipment__c from Shipment_Line__c where Shipment__c =: record.Id order by Name];
    
        return ShipmentItemsLines;
    }

    public List<NEUEBUSCM_Shipment_Item_Line_s> getFamilyList(String family)
    {
            
            String myPriceList=null;
            if(record.Account_for_Catalog_Price_List__c != null)
            {
                List<Customer_Price_List__c> Acc_Price_List = [select Id,Name, Price_List__c  from Customer_Price_List__c where Id =: record.Account_for_Catalog_Price_List__c order by Name];
                myPriceList=Acc_Price_List[0].Price_List__c;
            }
            else if(record.Catalog_Price_List__c!=null)
                myPriceList=record.Catalog_Price_List__c;
            
            List<NEUEBUSCM_Shipment_Item_Line_s> Family_Item_List_Price=new List<NEUEBUSCM_Shipment_Item_Line_s>();
            List<Item_List_Price__c> lista_item_list = null;
            List<Sourcing_Item__c> lista_items_query = null;
            
            if(String.IsNotEmpty(family))
            {
                 if(myPriceList != null)
                    lista_item_list = [select Id, Price_List__c, Item_Name__c, Item_Name__r.Weight_Kgs__c, Item_Name__r.Current_Supplier__c, Item_Name__r.Item_Price__c, Item_Name__r.Account_Owner__c, Item_Name__r.Unit_of_measure__c, Item_Name__r.Subfamily__r.Name, Item_Name__r.Name, Item_Price__c, Item_Name__r.Sourcing_Family__r.Name, List_Price__c from Item_List_Price__c where Price_List__c =: myPriceList and Item_Name__r.Sourcing_Family__c =: family order by Name];
            }
            else
            {
                if(myPriceList != null)
                    lista_item_list = [select Id, Price_List__c, Item_Name__c,Item_Name__r.Weight_Kgs__c, Item_Name__r.Current_Supplier__c, Item_Name__r.Item_Price__c, Item_Name__r.Account_Owner__c, Item_Name__r.Unit_of_measure__c, Item_Name__r.Subfamily__r.Name, Item_Name__r.Name, Item_Price__c, Item_Name__r.Sourcing_Family__r.Name, List_Price__c from Item_List_Price__c where Price_List__c =: myPriceList order by Name];
            }
            
            if(myPriceList == null)
            {
              if(String.IsNotEmpty(family))
                lista_items_query =[select Id, Name, Weight_Kgs__c,Current_Supplier__c,Account_Owner__c, Unit_of_measure__c, Subfamily__r.Name, Sourcing_Family__r.Name, Item_Price__c  from Sourcing_Item__c where Sourcing_Family__c =: family];
              else
                lista_items_query =[select Id, Name, Weight_Kgs__c,Current_Supplier__c,Account_Owner__c, Unit_of_measure__c, Subfamily__r.Name, Sourcing_Family__r.Name, Item_Price__c from Sourcing_Item__c limit 1000];
            }
            
           /* List<Shipment_Line__c> Quote_Item = null;
            if(family != '')
                Quote_Item = [select Id, Name, Shipment__c, Item_Name__c, Item_Name__r.Sourcing_Family__r.Name from Shipment_Line__c where Shipment__c =: record.Id  and Item_Name__r.Sourcing_Family__r.Name =: family order by Name];
            else
                Quote_Item = [select Id, Name, Shipment__c, Item_Name__c, Item_Name__r.Sourcing_Family__r.Name from Shipment_Line__c where Shipment__c =: record.Id order by Name];
        */
            if( ApexPages.currentPage().getParameters().get('test') != null)
                lista_item_list = [select Id, Price_List__c, Item_Name__c,Item_Name__r.Weight_Kgs__c, Item_Name__r.Current_Supplier__c, Item_Name__r.Account_Owner__c, Item_Name__r.Unit_of_measure__c, Item_Name__r.Subfamily__r.Name, Item_Name__r.Name, Item_Price__c, Item_Name__r.Sourcing_Family__r.Name, List_Price__c from Item_List_Price__c  order by Name];
            boolean insertar = true;
            
            if(myPriceList != null)
            {
                for(Item_List_Price__c lp: lista_item_list)
                {
                    /*for(Shipment_Line__c qi: Quote_Item) Permitir insertar un item ams de una vez
                    {
                        if(lp.Item_Name__c == qi.Item_Name__c)
                        {
                            insertar = false;
                            break;
                        }
                    }*/
                    if(insertar || ApexPages.currentPage().getParameters().get('test') != null)
                    {
                        Shipment_Line__c ship_line = new Shipment_Line__c();
                        ship_line.Units_Shipped__c = 1;
                        ship_line.Unit_Origin_Sell_Price__c = (lp.List_Price__c != null ? lp.List_Price__c : lp.Item_Price__c);
                        //ship_line.Shipping_Weight_Kg__c = 
                        //ship_line.Shipping_Volume_m3__c = 
                        Family_Item_List_Price.add(new NEUEBUSCM_Shipment_Item_Line_s(lp,lp.Item_Name__r,ship_line,false, '', '', '1', (lp.List_Price__c != null ? string.valueof(lp.List_Price__c) : string.valueof(lp.Item_Price__c)), ''));
                    }
                    insertar = true;
                }
            }
            else
            {
                  for(Sourcing_Item__c lp: lista_items_query)
                  {
                    /*for(Shipment_Line__c qi: Quote_Item) Permitir insertar un item ams de una vez
                    {
                        if(lp.Item_Name__c == qi.Item_Name__c)
                        {
                            insertar = false;
                            break;
                        }
                    }*/
                      
                    if(insertar || ApexPages.currentPage().getParameters().get('test') != null)
                    {
                        Shipment_Line__c ship_line = new Shipment_Line__c();
                        ship_line.Units_Shipped__c = 1;
                        ship_line.Unit_Origin_Sell_Price__c = (lp.Item_Price__c != null ? lp.Item_Price__c : 0);
                        //ship_line.Shipping_Weight_Kg__c = 
                        //ship_line.Shipping_Volume_m3__c = 
                        Family_Item_List_Price.add(new NEUEBUSCM_Shipment_Item_Line_s(null,lp,ship_line,false, '', '', '1', (lp.Item_Price__c  != null ? string.valueof(lp.Item_Price__c ) : '0'), ''));
                    }
                    insertar = true;
                  }
                  
            }
            
            return Family_Item_List_Price;
    }
    
    public void delete_item_line_select()
  {
      List<Shipment_Line__c> lines_del = null;
      lines_del=[select Id,Name from Shipment_Line__c where  Id =:id_oi];
      try
      {
        delete lines_del;
        ShipmentItemsLines = null;
        Item_List_Price = null;
      } 
     catch(Exception ex){}
  }
    public PageReference return_shipment()
    {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    // rellenar la lista y Sacar los items no insertados
    public List<NEUEBUSCM_Shipment_Item_Line_s> getItem_List_Price()
    {
        
        if(Item_List_Price==null)
            Item_List_Price=new List<NEUEBUSCM_Shipment_Item_Line_h>();
        
        List<NEUEBUSCM_Shipment_Item_Line_s>ret=null;
        
        for(NEUEBUSCM_Shipment_Item_Line_h myitem:Item_List_Price)
            if(myitem.family==getnewcategory())
                ret=myitem.mylist;
        if(ret==null)
        {
            ret=getFamilyList(mynewcategory);
            NEUEBUSCM_Shipment_Item_Line_h myitem=new NEUEBUSCM_Shipment_Item_Line_h();
            myitem.family=getnewcategory();
            myitem.mylist=ret;
            Item_List_Price.add(myitem);
        }
        
        return ret;
    }
    
    
    
    public class NEUEBUSCM_Shipment_Item_Line_h
    {
        public List<NEUEBUSCM_Shipment_Item_Line_s>mylist=null;
        public String family=''; 
    }
    
    //clase nuevo objeto
    public class NEUEBUSCM_Shipment_Item_Line_s
    {
        public Item_List_Price__c line {get; set;}
        public Sourcing_Item__c line2 {get; set;}
        public Shipment_Line__c ship_line {get; set;}
        public boolean selected {get; set;}
        public String extensionitemname {get; set;}
        public String units {get; set;}
        public String shippingweight {get; set;}
        public String price {get; set;}
        public String volumen {get; set;}
        
        
        public NEUEBUSCM_Shipment_Item_Line_s(Item_List_Price__c line,Sourcing_Item__c line2, Shipment_Line__c ship_line,boolean selected, String extensionitemname, String shippingweight, String units, String price, String volumen)
        {
            this.line=line;
            this.line2=line2;
            this.ship_line=ship_line;
            this.selected=selected;
            this.extensionitemname=extensionitemname;
            this.shippingweight=shippingweight;
            this.units=units;
            this.price=price;
            this.volumen=volumen;
        }
        
    }   
    //Consultar las insertadas nuevo objet    
    public void crearlineaquoteitem()
    {   
        if(Item_List_Price!=null)
        {
            List<Shipment_Line__c> Ship_items = null;
                Ship_items = [select Id, Name, Shipment__c from Shipment_Line__c where Shipment__c =: record.Id  order by Name];
            
            integer contadordelineas = 0;
            contadordelineas =Ship_items.size();
            string myName='';
            for(NEUEBUSCM_Shipment_Item_Line_h myitem:Item_List_Price)
            {
                for (NEUEBUSCM_Shipment_Item_Line_s lines:myitem.mylist)
                {
                    
                    if(lines.selected)
                    {
                        chekeados =true;
                        contadordelineas ++;
                        Shipment_Line__c myLine= new Shipment_Line__c();
                        myline.Shipment__c=record.Id;
                        myName=String.valueOf(contadordelineas);
                        while(myName.Length()<3)
                            myName='0'+myName;
                        myline.Name = myName;
                        myline.Extension_Item_Name__c=lines.extensionitemname;
                        myline.Item_Name__c = lines.line2.Id;
                        //myline.Manual_Units__c = decimal.valueof(lines.units);
                        if(lines.ship_line != null)
                            myline.Units_Shipped__c = lines.ship_line.Units_Shipped__c;
                        if(lines.ship_line != null)
                            myline.Shipping_Weight_Kg__c = lines.ship_line.Shipping_Weight_Kg__c;
                        if(lines.ship_line != null)
                            myline.Shipping_Volume_m3__c = lines.ship_line.Shipping_Volume_m3__c;   
                        if(lines.ship_line != null)
                            myline.Container_Number__c = lines.ship_line.Container_Number__c; 
                        //myline.Manual_Price__c = decimal.valueof(lines.price);
                        if(lines.ship_line != null)
                            myline.Unit_Origin_Sell_Price__c = lines.ship_line.Unit_Origin_Sell_Price__c;
                    //  myline.Item_List_Price__c=lines.line.Id;
                    /*  if(record.Account_for_Record_Type__c == 'Supplier')
                        {
                            myline.Item_Supplier_Owner__c = record.Account_for__c;
                        }
                        else
                        {
                            if(lines.line.Item_Name__r.Current_Supplier__c != null)
                                myline.Item_Supplier_Owner__c=lines.line.Item_Name__r.Current_Supplier__c;
                            else
                                myline.Item_Supplier_Owner__c=lines.line.Item_Name__r.Account_Owner__c;
                        }   */
                        if(lines.line.Item_Name__r.Sourcing_Family__c != null)
                            myline.Family__c=lines.line2.Sourcing_Family__c;
                        if(lines.line.Item_Name__r.Subfamily__c != null)
                            myline.Subfamily__c =lines.line2.Subfamily__c;
                        try
                        {
                            insert myLine;
                
                        }
                        catch(Exception e){}
                    }
                }
            }
            
          /*  Item_List_Price=null;
            if((record.Catalog_Price_List__c == null && record.Account_for_Catalog_Price_List__c == null) || ApexPages.currentPage().getParameters().get('test') != null)
            {
                if(nombrepricelist != null && nombrepricelist != '' && idaccountpricelist != null)
                    record.Account_for_Catalog_Price_List__c = idaccountpricelist;
                else
                {
                    if(field_accountpricelist != null && field_accountpricelist != ''  && field_accountpricelist != '0')
                        record.Catalog_Price_List__c = field_accountpricelist;
                }
                
                
                try
                {
                    update record;
                }
                catch(Exception ex)
                {
                    
                }
            }*/
            
            if(chekeados)
            {
                Item_List_Price=null;
                if((record.Account_for_Catalog_Price_List__c != null || record.Catalog_Price_List__c!=null))
                {
                    //try
                    //{
                        update record;
                    /*}
                    catch(Exception ex)
                    {
                        
                    }*/
                    editPriceList=false;
                }
            }
        }
    }
}