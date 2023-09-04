public with sharing class NEU_OM_UploadItems
{
    public Supply_Project__c record;
    public List<Items_to_Supply__c> actual_items
    {
    	get
    	{
    		if(actual_items==null)
	        actual_items = [select Id, Name, Supply_Project__c, Sourcing_Item__c, Sourcing_Item__r.Account_Owner__c, Sourcing_Item__r.Name, Observations__c, Quantity__c, Sourcing_Item__r.Sourcing_Item_Code__c, 
		        Sourcing_Item__r.Technical_description__c, Sourcing_Item__r.Units_x_Master_Box__c, Target_Price__c, Sourcing_Item__r.Item_Price__c, Sourcing_Item__r.Sourcing_Family__c
		        from Items_to_Supply__c where Supply_Project__c =: record.Id];
        	return actual_items;
        }
    	set
    	{
    		if(actual_items!=value)
    		{
    			actual_items=value;
    			actual_items_family=null;
    			numerodelinea=null;
    		}
    	}
    }
    public List<Items_to_Supply__c> actual_items_family
    {
    	get
    	{
    		if(actual_items_family==null)
    		{
    			if(id_family=='1')
			        actual_items_family = [select Id, Name, Supply_Project__c, Sourcing_Item__c, Sourcing_Item__r.Account_Owner__c, Sourcing_Item__r.Name, Observations__c, Quantity__c, Sourcing_Item__r.Sourcing_Item_Code__c, 
				        Sourcing_Item__r.Technical_description__c, Sourcing_Item__r.Units_x_Master_Box__c, Target_Price__c , Sourcing_Item__r.Item_Price__c, Sourcing_Item__r.Sourcing_Family__c
				        from Items_to_Supply__c where Supply_Project__c =: record.Id];
			    else if(id_family=='2')
			        actual_items_family = [select Id, Name, Supply_Project__c, Sourcing_Item__c, Sourcing_Item__r.Account_Owner__c, Sourcing_Item__r.Name, Observations__c, Quantity__c, Sourcing_Item__r.Sourcing_Item_Code__c, 
				        Sourcing_Item__r.Technical_description__c, Sourcing_Item__r.Units_x_Master_Box__c, Target_Price__c , Sourcing_Item__r.Item_Price__c, Sourcing_Item__r.Sourcing_Family__c
				        from Items_to_Supply__c where Supply_Project__c =: record.Id and Sourcing_Item__r.Sourcing_Family__c = null];
			    else
			        actual_items_family = [select Id, Name, Supply_Project__c, Sourcing_Item__c, Sourcing_Item__r.Account_Owner__c, Sourcing_Item__r.Name, Observations__c, Quantity__c, Sourcing_Item__r.Sourcing_Item_Code__c, 
				        Sourcing_Item__r.Technical_description__c, Sourcing_Item__r.Units_x_Master_Box__c, Target_Price__c , Sourcing_Item__r.Item_Price__c, Sourcing_Item__r.Sourcing_Family__c
				        from Items_to_Supply__c where Supply_Project__c =: record.Id and Sourcing_Item__r.Sourcing_Family__c =: id_family];
    		}
		    return actual_items_family;
    	}
    	set
    	{
    		if(actual_items_family!=value)
    		{
    			actual_items_family=value;
    			new_items=null;
    		}
    	}
    }
    public List<items_s> new_items
    {
    	get
    	{
    		if(new_items==null)
    		{
    			new_items=new List<items_s>();
				List<Sourcing_Item__c> items_family=null;
				if(id_family=='1')
					items_family=database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name, Sourcing_Item_Code__c, Account_Owner__c, Sourcing_Family__c, Technical_description__c, Units_x_Master_Box__c, Item_Price__c from Sourcing_Item__c');    			
        		else if(id_family=='2')
					items_family=database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name, Sourcing_Item_Code__c, Account_Owner__c, Sourcing_Family__c, Technical_description__c, Units_x_Master_Box__c, Item_Price__c from Sourcing_Item__c where Sourcing_Family__c = null');    			
        		else
					items_family=database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name, Sourcing_Item_Code__c, Account_Owner__c, Sourcing_Family__c, Technical_description__c, Units_x_Master_Box__c, Item_Price__c from Sourcing_Item__c where Sourcing_Family__c =: id_family');    			
	            for(Sourcing_Item__c it : items_family)
	            {
		            Items_to_Supply__c item_to_supply = new Items_to_Supply__c();
	                new_items.add(new items_s(item_to_supply,it,it.Id, NEU_Utils.safeString(it.Sourcing_Item_Code__c),it.Name,NEU_Utils.safeString(it.Technical_description__c), 0.00, NEU_Utils.safeInteger(it.Units_x_Master_Box__c),NEU_Utils.safeDecimal(it.Item_Price__c), '', false,
		                options, NEU_CurrencyUtils.getCurrencyIsoCode(it)));
	            }
    		}
    		return new_items;
    	}
    	set
    	{
    		if(new_items!=value)
    		{
    			new_items=value;
	            nombre_de_items=null;
    		}
    	}
    }
    public List<items_s> items_to_save {get;set;}
    public String id_oi {get;set;}
    public String id_family
    {
    	get
    	{
    		if(id_family==null)
    			if(family_list.size()>0)
    				id_family=family_list[0].getValue();
    		return id_Family;
    	}
    	set
    	{
    		if(id_family!=value)
    		{
    			id_family=value;
    			current_family=null;
		    	actual_items_family=null;
    		}
    	}
    }
    public String current_family
    {
    	get
    	{
    		if(current_family==null)
    			for(SelectOption o:family_list)
	    			if(id_family==o.getValue())
	    			{
	    				current_family=o.getLabel();
	    				break;
	    			}
	    	return current_family;
    	}
    	set
    	{
    		if(current_family!=value)
    		{
    			current_family=value;
    		}
    	}
    }
    public String resultado {get;set;}
    
    public String numerodelinea
    {
    	get
    	{
    		if(numerodelinea==null)
    		{
    			numerodelinea=String.valueOf(actual_items.size()+1);
				while(numerodelinea.length()<3)
					numerodelinea='0'+numerodelinea;   			
    		}
    		return numerodelinea;
    	}
    	set
    	{
    		if(numerodelinea!=value)
    			numerodelinea=value;
    	}
    }
    public String extensionitemname {get;set;}
    public List<SelectOption> options
    {
    	get
    	{
    		if(options==null)
    		{
		        options = new List<SelectOption>(); 
		        for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
		        {
		            if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
		            {
		              options.add(new SelectOption(lu,lu));
		              break;
		            }
		        }
		        for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
		        {
		            if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
		              options.add(new SelectOption(lu,lu));
		        }
    		}
    		return options;
    	}
    	set
    	{
    		if(options!=value)
    			options=value;
    	}
    }
    public string moneda_seleccionada_nuevo_item {get;set;}
    public String technical_description {get;set;}
    public string units {get;set;}
    public string shippingweight {get;set;}
    public string precio {get;set;}
    public string volumen {get;set;}
    public string precio_objetivo {get;set;}
    public string observations_for_suppliers {get;set;}
    public Sourcing_Item__c new_sourcing_item {get;set;}
    public Items_to_Supply__c new_item_to_supply {get;set;}
  
    public boolean esta_creado_el_item {get;set;}
  
    public string nombre_de_items
    {
    	get
    	{
    		if(nombre_de_items==null)
    		{
    			nombre_de_items='';
	            for(items_s li:new_items)
	                nombre_de_items +=li.item_name+'_&_';
	            System.debug('nombre_de_items relleno='+nombre_de_items);
    		}
    		return nombre_de_items;
    	}
    	set
    	{
    		if(nombre_de_items!=value)
    		{
    			nombre_de_items=value;
    			if(nombre_de_items==null)
		            System.debug('nombre_de_items relleno=null');
		        else
		            System.debug('nombre_de_items relleno='+nombre_de_items);
    		}
    	}
    }
    
    public string technical_description_input {get;set;}
    
    public string errores {get;set;}
    
    public boolean mostrar_boton {get;set;}
    //FAMILIES
    public List<SelectOption> family_list{ 
	    get{
	    	if(family_list==null)
	    	{
		        List<Product_Family__c> family = null;
		        if(record.Sourcing_Family__c != null)
		            family = [select Id, Name from Product_Family__c where Id =: record.Sourcing_Family__c order by Name asc];
		        else if(record.Business_Area__c != null)
		            family = [select Id, Name, Business_Area__c from Product_Family__c where Business_Area__c =: record.Business_Area__c order by Name asc];
		        else
		            family = [select Id, Name from Product_Family__c order by Name asc];
		        family_list = new List<SelectOption>();
		        for(Product_Family__c f : family)
		        {
		            family_list.add(new SelectOption(f.Id,f.Name));
		            if(String.IsEmpty(id_family))
		            	id_family=f.Id;
		        }
	            family_list.add(new SelectOption('2','Other'));
	            if(String.IsEmpty(id_family))
	            	id_family='2';
	            //family_list.add(new SelectOption('1','All'));
	    	}
	        return family_list;
	    }
	    set{
	    	if(family_list!=value)
	    		family_list=value;
	    }
   }
    
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
    
    public class items_s
    {
        public Items_to_Supply__c item_to_supply{get;set;}
        public Sourcing_Item__c item{get;set;}
        public String item_id {get;set;}
        public String item_code {get;set;}
        public String item_name {get;set;}
        public String technical_description {get;set;}
        public Decimal quantity {get;set;}
        public Integer units_x_box {get;set;}
        public Decimal price {get;set;}
        public String observations {get;set;}
        public Boolean selected {get;set;}
        public List<SelectOption> currencys {get;set;}
        public string currency_selected {get;set;}
        
        public items_s(Items_to_Supply__c item_to_supply, Sourcing_Item__c item, String item_id, String item_code, String item_name, String technical_description, Decimal quantity, Integer units_x_box, Decimal price, String observations, Boolean selected,
        List<SelectOption> currencys, string currency_selected)
        {
            this.item_to_supply = item_to_supply;
            this.item = item;
            this.item_id = item_id;
            this.item_code = item_code;
            this.item_name = item_name;
            this.technical_description = technical_description;
            this.quantity = quantity;
            this.units_x_box = units_x_box;
            this.price = price;
            this.observations = observations;
            this.selected = selected;
            this.currencys = currencys;
            this.currency_selected = currency_selected;
        }
    }

    ApexPages.StandardController con;
    
    public NEU_OM_UploadItems(ApexPages.StandardController stdController) 
    {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        	Id recordid=con.getRecord().Id;
        record = database.query('select Id'+NEU_CurrencyUtils.CurrencyISOCode()+', Name, Business_Area__c, Sourcing_Family__c, Subfamily__c, Customer__c from Supply_Project__c where id = :recordid');
        } catch( Exception ee) { 
            record = new Supply_Project__c();
        }
        
        mostrar_boton = false;
        List<Import_Export_Fee_Line__c> listado_fees = [select Id  from Import_Export_Fee_Line__c where Supply_Project__c =: record.Id and Units__c > 0 limit 1];
        if(listado_fees.size() >0)
            mostrar_boton = true;
        
        
        new_item_to_supply = new Items_to_Supply__c();
        new_sourcing_item = new Sourcing_Item__c();
    }
    
    public PageReference get_oi_from_family()
    {
    	nombre_de_items=null;
        return null;
    }
    
    public PageReference create_oi()
    {
        List<Items_to_Supply__c> oi_to_save = new List<Items_to_Supply__c>();
        
        decimal numerodelinea = actual_items.size()+1;
        string numerodelinea_string = string.valueof(numerodelinea);
        errores ='';
        for(items_s it : new_items)
        {
            if(it.selected == true)
            {
               // if(it.quantity >0)
               if(it.item_to_supply.Quantity__c >0)
                {
                    Items_to_Supply__c new_oi = new Items_to_Supply__c();
                    while(numerodelinea_string.length()<3)
                    {
                      numerodelinea_string ='0'+numerodelinea_string;
                    }
                    new_oi.Name = numerodelinea_string;
                    new_oi.Supply_Project__c = record.Id;
                    new_oi.Sourcing_Item__c = it.item_id;
                   // new_oi.Quantity__c = it.quantity;
                    new_oi.Quantity__c = it.item_to_supply.Quantity__c;
                   // new_oi.Target_Price__c = it.price;
                    new_oi.Target_Price__c = it.item_to_supply.Target_Price__c;
                    new_oi.Observations__c = it.observations;
                    NEU_CurrencyUtils.setCurrencyIsoCode(new_oi,it.currency_selected);
                    oi_to_save.add(new_oi);
                    numerodelinea ++;
                    numerodelinea_string = string.valueof(numerodelinea);
                }
                else
                {
                    if(errores == '')
                        errores +='Please, fill Quantity on the Item '+it.item_name+'\n';
                    else
                        errores +=' and Item '+ it.item_name;
                }
            }
        }
        
        List<items_s> items = new List<items_s>();
        if(errores == '')
        {
            try
            {
                insert oi_to_save;
            }
            catch(Exception ex){resultado = ''+ex;}
        }
        actual_items=null;
        return null;
    }
    
    public PageReference delete_oi()
    {
        List<Items_to_Supply__c> oi_to_delete = [select Id, Name, Sourcing_Item__c from Items_to_Supply__c where Id =: id_oi];
        delete oi_to_delete;
        actual_items=null;
        return null;
    }
    
    public void crearlineaSupplyitem()
    {
      List<Items_to_Supply__c> supply_item = new List<Items_to_Supply__c>();
      Items_to_Supply__c Items_to_Supply = new Items_to_Supply__c();  
      Items_to_Supply.Supply_Project__c =record.Id;
      
      while(numerodelinea.length()<3)
      {
        numerodelinea ='0'+numerodelinea;
      }
      Items_to_Supply.Name = numerodelinea;
  
      if(new_item_to_supply != null && new_item_to_supply.Quantity__c != null)
        Items_to_Supply.Quantity__c = new_item_to_supply.Quantity__c;
      if(observations_for_suppliers != null && observations_for_suppliers != '') 
        Items_to_Supply.Observations__c = observations_for_suppliers;
       if(new_item_to_supply != null && new_item_to_supply.Target_Price__c != null)
        Items_to_Supply.Target_Price__c = new_item_to_supply.Target_Price__c;
       if(esta_creado_el_item == false)
       {
           List<Sourcing_Item__c> lista_items = new List<Sourcing_Item__c>();
           Sourcing_Item__c Sourcing_Item = new Sourcing_Item__c();  
           Sourcing_Item.Name = extensionitemname;
           if(new_sourcing_item != null && new_sourcing_item.Item_Price__c !=null)
             Sourcing_Item.Item_Price__c = new_sourcing_item.Item_Price__c;
           Sourcing_Item.Account_Owner__c = record.Customer__c;
           if(new_item_to_supply != null && new_item_to_supply.Quantity__c != null)
             Sourcing_Item.Weight_Kgs__c = NEU_Utils.safeDecimal(NEU_Utils.toDecimal(shippingweight))/new_item_to_supply.Quantity__c;
           if(technical_description != null && technical_description != '') 
             Sourcing_Item.Technical_description__c = technical_description;
           Sourcing_Item.Units_x_Master_Box__c = 1;
           if(id_family.length()>1)
	           Sourcing_Item.Sourcing_Family__c = id_family;
            if(new_item_to_supply != null && new_item_to_supply.Quantity__c != null)
           {
             Sourcing_Item.Master_Box_Length_cm__c =(NEU_Utils.safeDecimal(NEU_Utils.toDecimal(volumen))/new_item_to_supply.Quantity__c)*100;
             Sourcing_Item.Master_Box_Width_cm__c =100;
             Sourcing_Item.Master_Box_Height_cm__c =100;
           }
           NEU_CurrencyUtils.setCurrencyIsoCode(Sourcing_Item,moneda_seleccionada_nuevo_item); 
           
             
           lista_items.add(Sourcing_Item);
          try
          {
              insert lista_items;
          }
          catch (Exception ex)
          {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));
          }
          
          if(lista_items.size() > 0)
          {
            Items_to_Supply.Sourcing_Item__c = lista_items[0].Id;
          }  
      }
      else
      {
        List<Sourcing_Item__c> newitems = [select id, Name from Sourcing_Item__c where Name =:extensionitemname];
        supply_item = [select Sourcing_Item__r.Name from Items_to_Supply__c where Sourcing_Item__r.Name =:extensionitemname];
        if(newitems.size() > 0 && supply_item.size()==0)//--- puede que si lo encuentra hay que avisar o actualizar 
        {
          Items_to_Supply.Sourcing_Item__c = newitems[0].Id;
        } 
        else
        {
            if(newitems.size() > 0 && supply_item.size()>0)
            {
                Items_to_Supply = supply_item[0];
                if(new_item_to_supply != null && new_item_to_supply.Quantity__c != null)
                    Items_to_Supply.Quantity__c = new_item_to_supply.Quantity__c;
                  if(observations_for_suppliers != null && observations_for_suppliers != '') 
                    Items_to_Supply.Observations__c = observations_for_suppliers;
                   if(new_item_to_supply != null && new_item_to_supply.Target_Price__c != null)
                    Items_to_Supply.Target_Price__c = new_item_to_supply.Target_Price__c;
            }
        }
      }
      
      try
      {
        if(supply_item.size()==0)
          insert Items_to_Supply;
        else
        {
                update Items_to_Supply;
        }
      }
      catch (Exception ex)
      {
      	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex));
      }
          
      extensionitemname ='';
      new_item_to_supply = new Items_to_Supply__c();
      new_sourcing_item = new Sourcing_Item__c();
      units ='';
      shippingweight ='';
      precio ='';
      volumen = '';
      precio_objetivo = '';
      technical_description = '';
      observations_for_suppliers = '';
      moneda_seleccionada_nuevo_item = '';
      actual_items=null;
    }
    
    public PageReference return_project()
    {
    	return con.view();
    }
}