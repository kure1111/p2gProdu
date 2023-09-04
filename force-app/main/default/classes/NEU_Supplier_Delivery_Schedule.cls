public with sharing class NEU_Supplier_Delivery_Schedule {
  
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
  public Customer_Quote__c record;
  public  List<supplier_quote_line_s> listado_supplierquoteline = null;
  
  public decimal TotalNumberBoxes {get;set;}
  public decimal TotalNumberPallets {get;set;}
  public decimal Grossweight {get;set;}
  public decimal Cube {get;set;}
  public decimal TotalNumberCont {get;set;}
  public decimal FreeSpaceCont  {get;set;}
  public string porc_ocupacion {get;set;}
    
  public string max_peso_container {get;set;}
  public string max_volumen_container {get;set;}
  public string num_cont_x_pallet {get;set;}
    
  public boolean la_lista_no_cero {get;set;}
  public string ids_pallet_idscontenedores {get;set;}
  public List<SelectOption> containers = null;
  private string container_selected='';
    
  private List<SelectOption> Numero_shipment = null;
  private string Numero_shipment_selected='';
  public string unidades_quoted {get;set;}
  public Supplier_Quote_Line__c id_nueva_linea{get;set;}
  
  public decimal nuevos_items;
  public string id_principal_check{get;set;}
  
  public List<Quote_Item_Line__c> lista_quotes_lines = null;
  public List<Quote_Item_Line__c> lista_update_split = null;
  public List<Supplier_Quote_Line__c> lista_update_split_sup = null;
  ApexPages.StandardController con;

  public NEU_Supplier_Delivery_Schedule(ApexPages.StandardController stdController) {
       con = stdController;
          system.debug( con.getRecord() );
    try { 
    record = [select Id, Name, Quotation_Status__c, Max_Deliveries__c , Contract_Duration_months__c, RecordTypeId from Customer_Quote__c where id = :con.getRecord().id];
    } catch( Exception ee) { 
      record = new Customer_Quote__c();
    }
  }
  
  public String getcontainer_selected() 
    {
       return container_selected;
    }
            
    public void setcontainer_selected(String container_selected)
    {
        this.container_selected = container_selected;
    }
    
    public List<SelectOption> getcontainers()
    {
      if(containers==null)
      {
          List<Pallet_Container_Type__c> lista_contenedores = new List<Pallet_Container_Type__c>();
          lista_contenedores = [select Id, Name, Pallet_Type__c, Pallet_Type__r.Pallet_Volume_m3__c, Pallet_Type__r.Pallet_Weight_Kg__c, Container_Type__c, Container_Type__r.Cargo_Volume_m3__c, Container_Type__r.Cargo_Weight_Kg__c, Number_of_Pallets__c from Pallet_Container_Type__c order by Name];
          containers = new List<SelectOption>();
          ids_pallet_idscontenedores = '';
          containers.add(new SelectOption('0', '-- Select Pallet/Container Type --'));
        
          for(Pallet_Container_Type__c cp : lista_contenedores)
          {
                containers.add(new SelectOption(cp.Id, cp.Name));
                ids_pallet_idscontenedores +=cp.id+'_'+ cp.Pallet_Type__c+'_'+cp.Pallet_Type__r.Pallet_Volume_m3__c+'_'+cp.Pallet_Type__r.Pallet_Weight_Kg__c+'_'+ cp.Container_Type__r.Cargo_Volume_m3__c+'_'+cp.Container_Type__r.Cargo_Weight_Kg__c+'_'+cp.Number_of_Pallets__c+'|';
          }
      }
        return containers; 
    }
    
    public String getNumero_shipment_selected() 
    {
       return Numero_shipment_selected;
    }
            
    public void setNumero_shipment_selected(String Numero_shipment_selected)
    {
        this.Numero_shipment_selected = Numero_shipment_selected;
    }
    
    public List<SelectOption> getNumero_shipment()
    {
      if(Numero_shipment==null)
      {
          Numero_shipment = new List<SelectOption>();
          if(record.Max_Deliveries__c != null)
          {
              integer i =1;
              while( i <= record.Max_Deliveries__c)
              {
                    Numero_shipment.add(new SelectOption(string.valueof(i), 'Delivery '+i));
                    i++;
              } 
          }
      }
        return Numero_shipment; 
    }
  
  
  public class supplier_quote_line_s
    {
        public Quote_Item_Line__c sup_quot_line {get; set;}
        public Sourcing_Item__c line {get; set;}
        public boolean selected {get; set;}
        public String observaciones {get; set;}
        public decimal supply {get; set;}
        public decimal totalpeso {get; set;}
        public decimal totalcajas {get; set;}
        public decimal totalpesoenvio {get; set;}
        public decimal volumen_master_box {get; set;}
        public decimal total_pallet_linea {get; set;}
        public boolean tiene_relacion_con_pallet {get; set;}
        public String relacion_con_pallet {get; set;}
        public List<SelectOption> shipment_number {get; set;}  
        public String shipment_number_selected {get; set;}
        public Quote_Item_Line__c fechafield{get; set;}
        public String idprincipal {get; set;}
        public String iditem_mod {get; set;}
        public decimal cantidad_inicial {get; set;}
        public boolean mismas_unidades {get; set;}
        public Supplier_Quote_Line__c sup_quote_line{get; set;}
        public boolean calculo_auto{get; set;}
        public String unidades_x_caja_linea{get; set;}
        public decimal peso_x_caja_linea{get; set;}
        public decimal volumen_x_caja_linea{get; set;} 
        public decimal Total_Shipping_Weight_Kgs{get; set;}
        public decimal Total_Shipping_Volume_m3{get; set;}
        public String supplySep
        {
        	get
        	{
        		if(supply!=null)
	        		return supply.format();
	        	return null;
        	}
        	set
        	{
        		System.Debug('supplySep='+value);
        		decimal myvalue=NEU_Utils.toDecimal(value);
        		if(myvalue!=null)
        			supply=myvalue;
        		System.Debug('supply='+String.valueOf(supply));
        	}
        }
        public String totalpesoSep
        {
        	get
        	{
        		if(totalpeso!=null)
	        		return totalpeso.format();
	        	return null;
        	}
        	set
        	{
        		decimal myvalue=NEU_Utils.toDecimal(value);
        		if(myvalue!=null)
        			totalpeso=myvalue;
        	}
        }
        public String volumen_master_boxSep
        {
        	get
        	{
        		if(volumen_master_box!=null)
	        		return volumen_master_box.format();
	        	return null;
        	}
        	set
        	{
        		decimal myvalue=NEU_Utils.toDecimal(value);
        		if(myvalue!=null)
        			volumen_master_box=myvalue;
        	}
        }
        public String total_pallet_lineaSep
        {
        	get
        	{
        		if(total_pallet_linea!=null)
	        		return total_pallet_linea.format();
	        	return null;
        	}
        	set
        	{
        		decimal myvalue=NEU_Utils.toDecimal(value);
        		if(myvalue!=null)
        			total_pallet_linea=myvalue;
        	}
        }
        public String cantidad_inicialSep
        {
        	get
        	{
        		if(cantidad_inicial!=null)
	        		return cantidad_inicial.format();
	        	return null;
        	}
        	set
        	{
        		cantidad_inicial=NEU_Utils.toDecimal(value);
        	}
        }
        public String UnitsSep
        {
        	get
        	{
        		if(sup_quot_line!=null)
	        		if(sup_quot_line.Units__c!=null)
		        		return sup_quot_line.Units__c.format();
	        	return null;
        	}
        	set
        	{
        		if(sup_quot_line!=null)
	        		sup_quot_line.Units__c=NEU_Utils.toDecimal(value);
        	}
        }
        public String totalcajasSep
        {
        	get
        	{
        		if(totalcajas!=null)
	        		return totalcajas.format();
	        	return null;
        	}
        	set
        	{
        		totalcajas=NEU_Utils.toDecimal(value);
        	}
        }
        public supplier_quote_line_s(Quote_Item_Line__c sup_quot_line,Sourcing_Item__c line,boolean selected, 
        String observaciones, decimal supply, decimal totalpeso, decimal totalcajas, decimal totalpesoenvio,
         decimal volumen_master_box, decimal total_pallet_linea, boolean tiene_relacion_con_pallet, 
         string relacion_con_pallet, List<SelectOption> shipment_number , String shipment_number_selected,
          Date fecha, String idprincipal, String iditem_mod, decimal cantidad_inicial , boolean mismas_unidades,
           Supplier_Quote_Line__c sup_quote_line, boolean calculo_auto, decimal unidades_x_caja_linea, decimal peso_x_caja_linea, decimal volumen_x_caja_linea)
        {
            this.sup_quot_line=sup_quot_line;
            this.line=line;
            this.selected=selected;
            this.observaciones=observaciones;
            this.supply=supply;
            this.totalpeso=totalpeso;
            this.totalcajas = totalcajas;
            this.totalpesoenvio = totalpesoenvio;
            this.volumen_master_box = volumen_master_box;
            this.total_pallet_linea = total_pallet_linea;
            this.tiene_relacion_con_pallet = tiene_relacion_con_pallet;
            this.relacion_con_pallet = relacion_con_pallet;
            this.shipment_number = shipment_number;
            this.shipment_number_selected = shipment_number_selected;
            this.fechafield=new Quote_Item_Line__c();
            this.fechafield.Delivery_Date__c = fecha;
            this.idprincipal = idprincipal;
            this.iditem_mod = iditem_mod;
            this.cantidad_inicial = cantidad_inicial;
            this.mismas_unidades = mismas_unidades;
            this.sup_quote_line= sup_quote_line;
            this.calculo_auto = calculo_auto;
            if(unidades_x_caja_linea!=null)
	            this.unidades_x_caja_linea = unidades_x_caja_linea.format();
	        else
	            this.unidades_x_caja_linea = '';
            this.peso_x_caja_linea = peso_x_caja_linea;
            this.volumen_x_caja_linea = volumen_x_caja_linea;
        }
    }
    
    
     public List<supplier_quote_line_s> getlistado_supplierquoteline()
    {
        if(listado_supplierquoteline==null)
        {
            TotalNumberBoxes = 0;
            TotalNumberPallets = 0;
            Grossweight = 0;
            Cube =0; 
            TotalNumberCont = 0;
            FreeSpaceCont = 0;
            porc_ocupacion ='0%';
             
            listado_supplierquoteline=new List<supplier_quote_line_s>();
            
            
            List<Item_Pallet_Type__c> items_pallet_type = new List<Item_Pallet_Type__c>();
            items_pallet_type = [select Id,Name, Item_Name__c, Packages_Pallet__c, Pallet_Type__c from Item_Pallet_Type__c];
            
            List<Quote_Item_Line__c> listaintems = new List<Quote_Item_Line__c>();
            listaintems = [select Id,Name,Units__c,Consolidated__c,Observations__c,Delivery_Number__c,Delivery_Date__c,
            
            Item_Name__c,Item_Name__r.Name,Item_Name__r.Item_Price__c, Packaging_Volume_m3__c,
            Item_Name__r.Safety_Stock_Item_Unit_of_measure__c,Item_Name__r.Reorder_Level_Item_Unit_of_measure__c, Packaging_Gross_Weight_kg__c,
            Item_Name__r.Master_Box_Description__c, Item_Name__r.Master_Box_Gross_Weight_kg__c, Item_Units_x_Packaging__c,
            Item_Name__r.Master_Box_Volume_m3__c, Item_Name__r.Unit_of_measure__c, Supplier_Quote__r.Supplier_Request_RFP__r.Contract_Duration__c,
            Item_Name__r.Order_Observations__c, Item_Name__r.Weight_Kgs__c, Item_Name__r.Sourcing_Family__c, Total_Shipping_Volume_m3__c ,Total_Shipping_Weight_Kgs__c ,
            Item_Name__r.Sourcing_Family__r.Name, Item_Name__r.Inventory_Position__c, Item_Name__r.Safety_Stock_Manual__c, 
            Item_Name__r.Safety_Stock_Formula__c, Item_Name__r.AVG_Dem_in_Lead_Time__c, Item_Name__r.Reorder_Level__c,
            Item_Name__r.Inventory_Position_Reorder_Level__c, Item_Name__r.Minimum_Order_Quantity__c, Expense_Amount__c,
            Item_Name__r.Optimal_Order_Quantity__c, Item_Name__r.Current_Supplier__c, Item_Name__r.Current_Supplier__r.Name, 
            Item_Name__r.Account_Owner__c, Item_Name__r.Account_Owner__r.Name, Item_Name__r.Units_x_Master_Box__c,Duty__c,Percent_Duty__c, Customs_Value__c, Sales_Tax__c, Percent_Taxes__c, Supplier_Quote_Line__r.Duty__c,Supplier_Quote_Line__r.Percent_Duty__c, Supplier_Quote_Line__r.Customs_Value__c, Supplier_Quote_Line__r.Sales_Tax__c, Supplier_Quote_Line__r.Percent_Taxes__c,  Supplier_Quote_Line__r.Quantity__c,
            Item_Name__r.Consolidate_by_BOM__c, Item_Name__r.RecordTypeId, Supplier_Quote__r.Supplier_Request_RFP__r.Max_Shipment__c, 
            Item_Name__r.Subfamily__c, Supplier_Quote__c  from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id order by Name]; //Item_Name__r.Stock__c
            
            //listado shipments
           
            
           decimal need = 0;
           decimal totalcajas=0;
           decimal totalpesolinea = 0;
           decimal ratio=1;
           decimal totalvolumen_x_ratio =0;
             string relaciones = '';
            for(Quote_Item_Line__c li : listaintems)
            {
                //listado delivery number
               List<SelectOption>  shipments_combo = new List<SelectOption>();
               shipments_combo.add(new SelectOption('', ''));
                 if(record.Max_Deliveries__c > 0)
                 {
                    integer i=1;
                    while(i <= record.Max_Deliveries__c)
                    {
                        shipments_combo.add(new SelectOption(string.valueof(i), 'Delivery '+i));
                        i ++;
                    }
                 }
               
                relaciones = '';
                for(Item_Pallet_Type__c ip: items_pallet_type)
                {
                    if(ip.Item_Name__c == li.Item_Name__c)
                    {
                        //relaciones = ip.Pallet_Type__c+'_'+ip.Packages_Pallet__c+'|';
                        relaciones += ip.Pallet_Type__c+'_'+((NEU_Utils.safeDecimal(li.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(li.Item_Units_x_Packaging__c)*ip.Packages_Pallet__c : (NEU_Utils.safeDecimal(li.Item_Name__r.Units_x_Master_Box__c) != 0 ? NEU_Utils.safeDecimal(li.Item_Name__r.Units_x_Master_Box__c)*ip.Packages_Pallet__c:0)))+'|';
                    }
                    
                }
                need = 0;
                totalcajas=0;
                totalpesolinea = 0;
                ratio=1;
                totalvolumen_x_ratio =0;
                need = li.Units__c;
                
                 if(li.Item_Units_x_Packaging__c >0)
                 {
                    totalcajas = (need/li.Item_Units_x_Packaging__c).round(roundingMode.UP);
                 }
                 else
                 {
                    if(li.Item_Name__r.Units_x_Master_Box__c != null)
                        totalcajas = (need/li.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP);
                    else
                      totalcajas = need;
                 } 
                 
                    if(li.Packaging_Gross_Weight_kg__c >0)
                      totalpesolinea =  totalcajas*li.Packaging_Gross_Weight_kg__c;
                    else
                    {
                        if(li.Item_Name__r.Master_Box_Gross_Weight_kg__c >0)
                            totalpesolinea = totalcajas*li.Item_Name__r.Master_Box_Gross_Weight_kg__c;
                        else
                            totalpesolinea= totalcajas*((li.Item_Name__r.Weight_Kgs__c!=null)?li.Item_Name__r.Weight_Kgs__c:0);
                    }
                    
                     if(li.Packaging_Volume_m3__c > 0)
                        totalvolumen_x_ratio = li.Packaging_Volume_m3__c;
                    else  
                        if(li.Item_Name__r.Master_Box_Volume_m3__c != null)
                            totalvolumen_x_ratio = li.Item_Name__r.Master_Box_Volume_m3__c;
                
                listado_supplierquoteline.add(new supplier_quote_line_s(li,li.Item_Name__r,false,li.Observations__c,need,//sourcing item, selected, observaciones, supply(unidades)
                        //(li.Packaging_Gross_Weight_kg__c > 0 ? totalcajas*li.Packaging_Gross_Weight_kg__c : (li.Item_Name__r.Master_Box_Gross_Weight_kg__c  != null ? (totalcajas*li.Item_Name__r.Master_Box_Gross_Weight_kg__c).round(roundingMode.UP) : (li.Item_Name__r.Weight_Kgs__c!=null?li.Item_Name__r.Weight_Kgs__c*need:0)  )),//totalpeso
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)*need).round(roundingMode.UP) : 0),//totalpeso
                        (totalcajas != 0 ? totalcajas : 0),//totalcajas
                        (totalpesolinea > totalvolumen_x_ratio ?  totalpesolinea.round(roundingMode.UP) : totalvolumen_x_ratio.round(roundingMode.UP)),//totalpeso envio
                        //(li.Packaging_Volume_m3__c > 0 ? (totalcajas*li.Packaging_Volume_m3__c).setScale(4,roundingMode.UP) :(li.Item_Name__r.Master_Box_Volume_m3__c != null ? (totalcajas*li.Item_Name__r.Master_Box_Volume_m3__c).setScale(4,roundingMode.UP) : 0)),//volumen master box
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)*need) : 0),//volumen master box
                        0,//numero pallet por linea
                        false,//relacion con pallet
                        relaciones,//relaciones con los pallet
                        shipments_combo,//shipment number
                        string.valueof(li.Delivery_Number__c),//shipment seleccionado
                        li.Delivery_Date__c,//fecha
                        li.Id,//id principal
                        li.Id,//id item
                        li.Units__c,
                        ((li.Supplier_Quote_Line__c != null && li.Supplier_Quote_Line__r.Quantity__c == li.Units__c) || li.Supplier_Quote_Line__c == null ? true : false),// si coinciden con las unidades si tiene relacion
                        li.Supplier_Quote_Line__r,
                        true,
                        (li.Item_Units_x_Packaging__c >0 ? li.Item_Units_x_Packaging__c : (li.Item_Name__r.Units_x_Master_Box__c > 0 ? li.Item_Name__r.Units_x_Master_Box__c : 1)),//unidades x caja
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)).setScale(4,roundingMode.UP) : 0),//peso caja
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)) : 0)));//volumen caja
                
            }
        }
        
        return listado_supplierquoteline;
    }
    
       public void cancelar()
    {
        listado_supplierquoteline = null;
    }
    
    public void calculo_auto()
    {
         List<Quote_Item_Line__c> listaintems = new List<Quote_Item_Line__c>();
         listaintems = [select Id,Name,Units__c,Consolidated__c,Observations__c,Delivery_Number__c,Delivery_Date__c,
            
         Item_Name__c,Item_Name__r.Name,Item_Name__r.Item_Price__c,Packaging_Volume_m3__c,
         Item_Name__r.Safety_Stock_Item_Unit_of_measure__c,Item_Name__r.Reorder_Level_Item_Unit_of_measure__c, Packaging_Gross_Weight_kg__c,
         Item_Name__r.Master_Box_Description__c, Item_Name__r.Master_Box_Gross_Weight_kg__c, Item_Units_x_Packaging__c,
         Item_Name__r.Master_Box_Volume_m3__c, Item_Name__r.Unit_of_measure__c, Supplier_Quote__r.Supplier_Request_RFP__r.Contract_Duration__c,
         Item_Name__r.Order_Observations__c, Item_Name__r.Weight_Kgs__c, Item_Name__r.Sourcing_Family__c, Total_Shipping_Weight_Kgs__c,Total_Shipping_Volume_m3__c,
         Item_Name__r.Sourcing_Family__r.Name, Item_Name__r.Inventory_Position__c, Item_Name__r.Safety_Stock_Manual__c, 
         Item_Name__r.Safety_Stock_Formula__c, Item_Name__r.AVG_Dem_in_Lead_Time__c, Item_Name__r.Reorder_Level__c,
         Item_Name__r.Inventory_Position_Reorder_Level__c, Item_Name__r.Minimum_Order_Quantity__c, Supplier_Quote_Line__r.Quantity__c,
         Item_Name__r.Optimal_Order_Quantity__c, Item_Name__r.Current_Supplier__c, Item_Name__r.Current_Supplier__r.Name, Supplier_Quote_Line__r.Observations__c , Supplier_Quote_Line__r.Delivery_Number__c, Supplier_Quote_Line__r.Delivery_Date__c,
         Item_Name__r.Account_Owner__c, Item_Name__r.Account_Owner__r.Name, Item_Name__r.Units_x_Master_Box__c, 
         Item_Name__r.Consolidate_by_BOM__c, Item_Name__r.RecordTypeId, Supplier_Quote__r.Supplier_Request_RFP__r.Max_Shipment__c,
         Item_Name__r.Subfamily__c, Supplier_Quote__c  from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id order by Name]; //Item_Name__r.Stock__c
              
              
              
         decimal total_unidades_linea = 0;
         decimal posicion = 0;//caso de añadir nueva linea
       //  decimal nuevos_items = 0;
         integer contador_de_posicion = 0;
         boolean encontrados = false;
         
         decimal need = 0;
         decimal totalcajas=0;
         decimal totalpesolinea = 0;
         decimal ratio=1;
         decimal totalvolumen_x_ratio =0;
         String relacion_con_pallet = '';
         List<SelectOption> shipment_number = null;
         
         if(nuevos_items > 0)
            nuevos_items = nuevos_items +7;
         else
            nuevos_items = listado_supplierquoteline.size()+7;
            
         integer i = 0;
         decimal max_max_delivery = 0;
         integer supplier_request_tiempo;
         decimal unidades_x_linea=0;
         decimal unidades_sobrantes = 0;
         date fecha_final;
         date fecha_lista;
         integer intervalo_dias = 0;
         integer delivery_correspondiente = 0;
         
         decimal deliverys_que_quedan = 0;
         decimal total_cajas_calcular = 0;
         
         decimal numero_de_envios = 0;
         decimal numero_de_unidades_restantes = 0;
         
         for(Quote_Item_Line__c li : listaintems)
         {
            encontrados = false;
            
           for(supplier_quote_line_s sup : listado_supplierquoteline)
           {
                contador_de_posicion ++;
                if(li.Id == sup.idprincipal)
                {
                     nuevos_items ++;
                     relacion_con_pallet = '';
                     shipment_number = null;
                     
                     if(sup.idprincipal== id_principal_check)//==
                     {
                         //numero de entregas
                         if(sup.shipment_number_selected == '' || sup.shipment_number_selected == null || sup.shipment_number_selected =='null')
                         {
                             max_max_delivery = record.Max_Deliveries__c;
                         }
                         else
                         {
                         
                            if(record.Max_Deliveries__c >0)
                            {
                            
                                max_max_delivery = record.Max_Deliveries__c-decimal.valueof(sup.shipment_number_selected);
                            }
                         }
                        //tiempo
                       
                        if(sup.fechaField.Delivery_Date__c != null && record.Contract_Duration_months__c > 0)
                        {
                         fecha_lista = sup.fechaField.Delivery_Date__c;
                         
                         supplier_request_tiempo = integer.valueof(record.Contract_Duration_months__c);
                         fecha_final= sup.fechaField.Delivery_Date__c.addMonths(supplier_request_tiempo);
                         intervalo_dias = sup.fechaField.Delivery_Date__c.daysBetween(fecha_final);//fecha de un delivery a otro (se vulve a calcular abajo)
                        }
                         
                         total_unidades_linea =sup.supply;
                         relacion_con_pallet = sup.relacion_con_pallet;
                         shipment_number = sup.shipment_number;
                         
                         unidades_sobrantes = li.Units__c;
                         
                          if(sup.shipment_number_selected == null)
                          {
                             sup.shipment_number_selected ='1';
                             i ++;
                          }
                          
                        
                           if(total_unidades_linea >0 && record.Max_Deliveries__c >0)
                          {
                          
                            deliverys_que_quedan = record.Max_Deliveries__c - integer.valueof(sup.shipment_number_selected)+1;
                            unidades_x_linea = (total_unidades_linea/deliverys_que_quedan).round(System.RoundingMode.UP);
                            if(sup.sup_quot_line.Item_Units_x_Packaging__c >0)
                            {
                                if((math.mod(integer.valueof(unidades_x_linea) ,integer.valueof(sup.sup_quot_line.Item_Units_x_Packaging__c))) != 0 && unidades_x_linea > sup.sup_quot_line.Item_Units_x_Packaging__c)
                                {
                                    
                                    
                                    if(sup.sup_quot_line.Item_Units_x_Packaging__c >0)
                                        total_cajas_calcular = (unidades_x_linea/sup.sup_quot_line.Item_Units_x_Packaging__c).round(roundingMode.UP);
                                    else
                                      total_cajas_calcular = unidades_x_linea;
                                      
                                     if(sup.sup_quot_line.Item_Units_x_Packaging__c >0) 
                                        unidades_x_linea = total_cajas_calcular*sup.sup_quot_line.Item_Units_x_Packaging__c;
                                     else
                                        unidades_x_linea = (total_unidades_linea/deliverys_que_quedan).round(System.RoundingMode.UP);
                                }
                                else
                                    unidades_x_linea = (total_unidades_linea/deliverys_que_quedan).round(System.RoundingMode.UP);
                                
                            }
                            else
                            {
                                if((math.mod(integer.valueof(unidades_x_linea) ,integer.valueof(sup.line.Units_x_Master_Box__c))) != 0 && unidades_x_linea > sup.line.Units_x_Master_Box__c)
                                {
                                    
                                    
                                    if(sup.line.Units_x_Master_Box__c != null)
                                        total_cajas_calcular = (unidades_x_linea/sup.line.Units_x_Master_Box__c).round(roundingMode.UP);
                                    else
                                      total_cajas_calcular = unidades_x_linea;
                                      
                                     if(sup.line.Units_x_Master_Box__c != null) 
                                        unidades_x_linea = total_cajas_calcular*sup.line.Units_x_Master_Box__c;
                                     else
                                        unidades_x_linea = (total_unidades_linea/deliverys_que_quedan).round(System.RoundingMode.UP);
                                }
                                else
                                    unidades_x_linea = (total_unidades_linea/deliverys_que_quedan).round(System.RoundingMode.UP);
                                
                            }
                            
                            sup.supply = unidades_x_linea;
                            
                            if(sup.sup_quot_line.Item_Units_x_Packaging__c > 0)
                                sup.totalcajas = (unidades_x_linea/sup.sup_quot_line.Item_Units_x_Packaging__c).round(System.RoundingMode.UP);
                            else
                            {
                                if(sup.line.Units_x_Master_Box__c != null)
                                  sup.totalcajas = (unidades_x_linea/sup.line.Units_x_Master_Box__c).round(System.RoundingMode.UP);
                                else
                                    sup.totalcajas = unidades_x_linea;
                            }
                          } 
                         encontrados = true;
                         
                         //saber los deliverys
                         numero_de_unidades_restantes =li.Units__c;
                         for(integer z = 0; z < max_max_delivery; z++)
                         {
                            
                            numero_de_unidades_restantes =numero_de_unidades_restantes - unidades_x_linea;
                            if(numero_de_unidades_restantes > 0 && numero_de_unidades_restantes >= unidades_x_linea)
                               system.debug('pasa');
                            else
                            {
                                if(numero_de_unidades_restantes < unidades_x_linea && numero_de_unidades_restantes>0)
                                    system.debug('pasa');
                                else
                                {
                                    break;
                                    
                                }
                            }
                            numero_de_envios ++;
                         }
                  
                         if(numero_de_envios > 0)
                             intervalo_dias = integer.valueof((intervalo_dias/(numero_de_envios)));
                         else
                             intervalo_dias = 0;
                             
                         if(sup.shipment_number_selected != null)
                            delivery_correspondiente = integer.valueof(sup.shipment_number_selected)+1;
                    
                        sup.selected =false;
                        sup.calculo_auto = false;
                        
                        
                        if(sup.sup_quot_line.Packaging_Gross_Weight_kg__c >0)
                          sup.totalpeso =  sup.totalcajas*sup.sup_quot_line.Packaging_Gross_Weight_kg__c;
                        else
                        {
                            if(sup.line.Master_Box_Gross_Weight_kg__c >0)
                                sup.totalpeso = sup.totalcajas*sup.line.Master_Box_Gross_Weight_kg__c;
                            else
                                sup.totalpeso = sup.totalcajas*sup.line.Weight_Kgs__c;
                        }
                        
                        if(sup.sup_quot_line.Packaging_Volume_m3__c >0)
                            sup.volumen_master_box =  (sup.totalcajas*sup.sup_quot_line.Packaging_Volume_m3__c);//.setScale(2,roundingMode.UP)
                        else
                        {
                            if(sup.line.Master_Box_Volume_m3__c >0)
                                sup.volumen_master_box = (sup.totalcajas * sup.line.Master_Box_Volume_m3__c);//.setScale(2,roundingMode.UP)
                            else
                                sup.volumen_master_box = 0;
                        }
                        
                     }
                     break;
                 }
            }
            
              if(max_max_delivery > 0 && encontrados == true)
              {
                contador_de_posicion --;
               while( i < max_max_delivery)
               {
                    nuevos_items ++;
                    contador_de_posicion ++;
                    need = 0;
                    totalcajas=0;
                    totalpesolinea = 0;
                    ratio=1;
                    totalvolumen_x_ratio =0;
                    unidades_sobrantes = unidades_sobrantes - unidades_x_linea;
                    
                    if(unidades_sobrantes > 0 && unidades_sobrantes >= unidades_x_linea)
                        need = unidades_x_linea;
                    else
                    {
                        if(unidades_sobrantes < unidades_x_linea && unidades_sobrantes>0)
                            need = unidades_sobrantes;
                        else
                        {
                            break;
                            need = 0;
                        }
                    }
                    
                    
                   if(intervalo_dias > 0 && fecha_lista != null)
                   {
                     fecha_lista = fecha_lista.addDays(intervalo_dias);
                   }
                 //calculo de pesos Y volumen
                 if(li.Item_Units_x_Packaging__c >0)
                 {
                    totalcajas = (need/li.Item_Units_x_Packaging__c).round(roundingMode.UP);
                 }
                 else
                 {
                    if(li.Item_Name__r.Units_x_Master_Box__c != null)
                        totalcajas = (need/li.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP);
                    else
                      totalcajas = need;
                 }    
                      
                      if(li.Packaging_Gross_Weight_kg__c >0)
                        totalpesolinea = totalcajas *li.Packaging_Gross_Weight_kg__c;
                      else
                      {
                        if( li.Item_Name__r.Master_Box_Gross_Weight_kg__c != null)
                            totalpesolinea = totalcajas * li.Item_Name__r.Master_Box_Gross_Weight_kg__c;
                        else if(li.Item_Name__r.Weight_Kgs__c != null)
                            totalpesolinea = totalcajas * li.Item_Name__r.Weight_Kgs__c;
                        else
                            totalpesolinea = 0;
                      } 
                      
                    if(li.Packaging_Volume_m3__c > 0)
                        totalvolumen_x_ratio = li.Packaging_Volume_m3__c;
                    else  
                        if(li.Item_Name__r.Master_Box_Volume_m3__c != null)
                            totalvolumen_x_ratio = li.Item_Name__r.Master_Box_Volume_m3__c*ratio;

                 //insert nueva linea
                 if(contador_de_posicion<listado_supplierquoteline.size())
                 {
                      listado_supplierquoteline.add(contador_de_posicion,new supplier_quote_line_s(null,li.Item_Name__r,false,'',need,//sourcing item, selected, observaciones, supply(unidades)
                           // (li.Packaging_Gross_Weight_kg__c > 0? totalcajas*li.Packaging_Gross_Weight_kg__c : (li.Item_Name__r.Master_Box_Gross_Weight_kg__c  != null ? (totalcajas*li.Item_Name__r.Master_Box_Gross_Weight_kg__c).round(roundingMode.UP) : ( NEU_Utils.safeDecimal(li.Item_Name__r.Weight_Kgs__c) != 0 ? li.Item_Name__r.Weight_Kgs__c*need : 0  )  )),//totalpeso 
                            (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)*need).round(roundingMode.UP) : 0),//totalpeso
                            (totalcajas != 0 ? totalcajas : 0),//totalcajas
                            (totalpesolinea > totalvolumen_x_ratio ?  totalpesolinea.round(roundingMode.UP) : totalvolumen_x_ratio.round(roundingMode.UP)),//totalpeso envio
                            //(li.Packaging_Volume_m3__c > 0 ? (totalcajas*li.Packaging_Volume_m3__c).setScale(2,roundingMode.UP) :(li.Item_Name__r.Master_Box_Volume_m3__c != null ? (totalcajas*li.Item_Name__r.Master_Box_Volume_m3__c).setScale(2,roundingMode.UP) : 0)),//volumen master box
                            (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)*need) : 0),//volumen master box
                            0,//numero pallet por linea
                            false,//relacion con pallet
                            relacion_con_pallet,//relaciones con los pallet
                            shipment_number,//shipment number
                            string.valueof(delivery_correspondiente),//shipment seleccionado
                            fecha_lista,//fecha
                            li.Id,//idprincipal
                            li.Id+'_'+nuevos_items,//id item
                            li.Units__c,
                            ((li.Supplier_Quote_Line__c != null && li.Supplier_Quote_Line__r.Quantity__c == li.Units__c) || li.Supplier_Quote_Line__c == null ? true : false),// si coinciden con las unidades si tiene relacion
                            li.Supplier_Quote_Line__r,
                            false,
                            (li.Item_Units_x_Packaging__c >0 ? li.Item_Units_x_Packaging__c : (li.Item_Name__r.Units_x_Master_Box__c > 0 ? li.Item_Name__r.Units_x_Master_Box__c : 1)),//unit caja
                            (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)).setScale(4,roundingMode.UP) : 0),//peso caja
                            (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)) : 0)));//volumen caja
                 }
                 else
                 {
                     listado_supplierquoteline.add(new supplier_quote_line_s(null,li.Item_Name__r,false,'',need,//sourcing item, selected, observaciones, supply(unidades)
                           //(li.Packaging_Gross_Weight_kg__c > 0? (totalcajas*li.Packaging_Gross_Weight_kg__c) : (li.Item_Name__r.Master_Box_Gross_Weight_kg__c  != null ? (totalcajas*li.Item_Name__r.Master_Box_Gross_Weight_kg__c).round(roundingMode.UP) : ( NEU_Utils.safeDecimal(li.Item_Name__r.Weight_Kgs__c) != 0 ? li.Item_Name__r.Weight_Kgs__c*need : 0  )  )),//totalpeso
                            (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)*need).round(roundingMode.UP) : 0),//totalpeso
                            (totalcajas != 0 ? totalcajas : 0),//totalcajas
                            (totalpesolinea > totalvolumen_x_ratio ?  totalpesolinea.round(roundingMode.UP) : totalvolumen_x_ratio.round(roundingMode.UP)),//totalpeso envio
                            //(li.Packaging_Volume_m3__c > 0 ? (totalcajas*li.Packaging_Volume_m3__c).setScale(2,roundingMode.UP) :(li.Item_Name__r.Master_Box_Volume_m3__c != null ? (totalcajas*li.Item_Name__r.Master_Box_Volume_m3__c).setScale(2,roundingMode.UP) : 0)),//volumen master box
                            (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)*need) : 0),//volumen master box
                            0,//numero pallet por linea
                            false,//relacion con pallet
                            relacion_con_pallet,//relaciones con los pallet
                            shipment_number,//shipment number
                            string.valueof(delivery_correspondiente),//shipment seleccionado
                            fecha_lista,//fecha
                            li.Id,//idprincipal
                            li.Id+'_'+nuevos_items,//id item
                            li.Units__c,
                            ((li.Supplier_Quote_Line__c != null && li.Supplier_Quote_Line__r.Quantity__c == li.Units__c) || li.Supplier_Quote_Line__c == null ? true : false),// si coinciden con las unidades si tiene relacion
                            li.Supplier_Quote_Line__r,
                            false,
                            (li.Item_Units_x_Packaging__c >0 ? li.Item_Units_x_Packaging__c : (li.Item_Name__r.Units_x_Master_Box__c > 0 ? li.Item_Name__r.Units_x_Master_Box__c : 1)),
                            (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)).setScale(4,roundingMode.UP) : 0),//peso caja
                            (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)): 0)));//volumen caja
                 }
                  i ++;
                  delivery_correspondiente ++;
                       
               }
              }
               contador_de_posicion = 0;
               total_unidades_linea = 0;
               shipment_number = null;
               relacion_con_pallet = '';
               max_max_delivery = 0;
               supplier_request_tiempo = 0;
               fecha_final = null;
               intervalo_dias  = 0;
               fecha_lista = null;
               deliverys_que_quedan = 0;
               i = 0;
               total_cajas_calcular = 0;
               numero_de_envios = 0;
               numero_de_unidades_restantes = 0;
         
        }   
    }
    
    public PageReference guardar_nuevos_deliverys()
    {
        
        con.save();
        String returnUrl = '/apex/NEU_Supplier_Delivery_Schedule'; 
        PageReference pgReturnPage  = new PageReference(returnUrl);
        pgReturnPage.getParameters().put('id', record.Id);
        pgReturnPage.setRedirect(true);
        return pgReturnPage; 
    }
    
    public void Recalcular()
    {
    	System.debug('Recalcular start');
         List<Quote_Item_Line__c> listaintems = new List<Quote_Item_Line__c>();
         listaintems = [select Id,Name,Units__c,Consolidated__c,Observations__c,Delivery_Number__c,Delivery_Date__c,
            
         Item_Name__c,Item_Name__r.Name,Item_Name__r.Item_Price__c, Packaging_Volume_m3__c,
         Item_Name__r.Safety_Stock_Item_Unit_of_measure__c,Item_Name__r.Reorder_Level_Item_Unit_of_measure__c, 
         Item_Name__r.Master_Box_Description__c, Item_Name__r.Master_Box_Gross_Weight_kg__c, Item_Units_x_Packaging__c,
         Item_Name__r.Master_Box_Volume_m3__c, Item_Name__r.Unit_of_measure__c, Packaging_Gross_Weight_kg__c,
         Item_Name__r.Order_Observations__c, Item_Name__r.Weight_Kgs__c, Item_Name__r.Sourcing_Family__c, Total_Shipping_Weight_Kgs__c, Total_Shipping_Volume_m3__c,
         Item_Name__r.Sourcing_Family__r.Name, Item_Name__r.Inventory_Position__c, Item_Name__r.Safety_Stock_Manual__c, 
         Item_Name__r.Safety_Stock_Formula__c, Item_Name__r.AVG_Dem_in_Lead_Time__c, Item_Name__r.Reorder_Level__c,
         Item_Name__r.Inventory_Position_Reorder_Level__c, Item_Name__r.Minimum_Order_Quantity__c, Supplier_Quote_Line__r.Quantity__c,
         Item_Name__r.Optimal_Order_Quantity__c, Item_Name__r.Current_Supplier__c, Item_Name__r.Current_Supplier__r.Name, Supplier_Quote_Line__r.Observations__c , Supplier_Quote_Line__r.Delivery_Number__c, Supplier_Quote_Line__r.Delivery_Date__c,
         Item_Name__r.Account_Owner__c, Item_Name__r.Account_Owner__r.Name, Item_Name__r.Units_x_Master_Box__c, 
         Item_Name__r.Consolidate_by_BOM__c, Item_Name__r.RecordTypeId, Supplier_Quote__r.Supplier_Request_RFP__r.Max_Shipment__c,
         Item_Name__r.Subfamily__c, Supplier_Quote__c  from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id order by Name]; //Item_Name__r.Stock__c
               
              
              
         decimal total_unidades_linea = 0;
         decimal posicion = 0;//caso de añadir nueva linea
        // decimal nuevos_items = 0;
         integer contador_de_posicion = 0;
         boolean encontrados = false;
         
         decimal need = 0;
         decimal totalcajas=0;
         decimal totalpesolinea = 0;
         decimal ratio=1;
         decimal totalvolumen_x_ratio =0;
         String relacion_con_pallet = '';
         List<SelectOption> shipment_number = null;
         if(nuevos_items > 0)
            nuevos_items = nuevos_items +7;
         else
            nuevos_items = listado_supplierquoteline.size()+1;
         
         for(Quote_Item_Line__c li : listaintems)
         {
           nuevos_items ++;
           relacion_con_pallet = '';
           shipment_number = null;
           encontrados = false;
           contador_de_posicion = 0;
           for(supplier_quote_line_s sup : listado_supplierquoteline)
           {
             
             if(li.Id == sup.idprincipal)
             {
               total_unidades_linea +=sup.supply;
               System.Debug('total_unidades_linea='+String.valueOf(total_unidades_linea));
               relacion_con_pallet = sup.relacion_con_pallet;
               shipment_number = sup.shipment_number;
               contador_de_posicion ++;
               encontrados = true;
             }
             if(encontrados == false)
               contador_de_posicion ++;
           }
           //en caso de no coincidir las lineas
           if(li.Units__c > total_unidades_linea)
           {
                need = 0;
                totalcajas=0;
                totalpesolinea = 0;
                ratio=1;
                totalvolumen_x_ratio =0;
                
                need = li.Units__c - total_unidades_linea;
             //calculo de pesos Y volumen
             
             if(li.Item_Units_x_Packaging__c >0)
             {
                totalcajas = (need/li.Item_Units_x_Packaging__c).round(roundingMode.UP);
             }
             else
             {
                if(li.Item_Name__r.Units_x_Master_Box__c != null)
                    totalcajas = (need/li.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP);
                else
                  totalcajas = need;
             } 
             
                    if(li.Packaging_Gross_Weight_kg__c >0)
                      totalpesolinea =  totalcajas*li.Packaging_Gross_Weight_kg__c;
                    else
                    {
                        if(li.Item_Name__r.Master_Box_Gross_Weight_kg__c >0)
                            totalpesolinea = totalcajas*li.Item_Name__r.Master_Box_Gross_Weight_kg__c;
                        else
                            totalpesolinea= totalcajas*((li.Item_Name__r.Weight_Kgs__c!=null)?li.Item_Name__r.Weight_Kgs__c:0);
                    }
                    
                    
                    
                     if(li.Packaging_Volume_m3__c > 0)
                        totalvolumen_x_ratio = li.Packaging_Volume_m3__c;
                    else  
                        if(li.Item_Name__r.Master_Box_Volume_m3__c != null)
                            totalvolumen_x_ratio = li.Item_Name__r.Master_Box_Volume_m3__c;
             
             
             //insert nueva linea
             if(contador_de_posicion<listado_supplierquoteline.size())
             {
                  listado_supplierquoteline.add(contador_de_posicion,new supplier_quote_line_s(null,li.Item_Name__r,false,'',need,//sourcing item, selected, observaciones, supply(unidades)
                       //(li.Packaging_Gross_Weight_kg__c > 0? (totalcajas*li.Packaging_Gross_Weight_kg__c) : (NEU_Utils.safeDecimal(li.Item_Name__r.Master_Box_Gross_Weight_kg__c)  != 0 ? (totalcajas*li.Item_Name__r.Master_Box_Gross_Weight_kg__c).round(roundingMode.UP) : ( NEU_Utils.safeDecimal(li.Item_Name__r.Weight_Kgs__c) != 0 ? li.Item_Name__r.Weight_Kgs__c*need : 0  ))),//totalpeso
                       (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)*need).round(roundingMode.UP) : 0),//totalpeso 
                        (totalcajas != 0 ? totalcajas : 0),//totalcajas
                        (totalpesolinea > totalvolumen_x_ratio ?  totalpesolinea.round(roundingMode.UP) : totalvolumen_x_ratio.round(roundingMode.UP)),//totalpeso envio
                        //(li.Packaging_Volume_m3__c > 0 ? (totalcajas*li.Packaging_Volume_m3__c).setScale(2,roundingMode.UP) :(li.Item_Name__r.Master_Box_Volume_m3__c != null ? (totalcajas*li.Item_Name__r.Master_Box_Volume_m3__c).setScale(2,roundingMode.UP) : 0)),//volumen master box
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)*need) : 0),//volumen master box
                        0,//numero pallet por linea
                        false,//relacion con pallet
                        relacion_con_pallet,//relaciones con los pallet
                        shipment_number,//shipment number
                        '',//shipment seleccionado
                        null,//fecha
                        li.Id,//idprincipal
                        li.Id+'_'+nuevos_items,//id item
                        li.Units__c,
                        ((li.Supplier_Quote_Line__c != null && li.Supplier_Quote_Line__r.Quantity__c == li.Units__c) || li.Supplier_Quote_Line__c == null ? true : false),// si coinciden con las unidades si tiene relacion
                        li.Supplier_Quote_Line__r,
                        false,
                        (li.Item_Units_x_Packaging__c >0 ? li.Item_Units_x_Packaging__c : (li.Item_Name__r.Units_x_Master_Box__c > 0 ? li.Item_Name__r.Units_x_Master_Box__c : 1)),
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)).setScale(4,roundingMode.UP) : 0),//peso caja
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)) : 0)));
             }
             else
             {
                 listado_supplierquoteline.add(new supplier_quote_line_s(null,li.Item_Name__r,false,'',need,//sourcing item, selected, observaciones, supply(unidades)
                        // (li.Packaging_Gross_Weight_kg__c > 0? (totalcajas*li.Packaging_Gross_Weight_kg__c) : (li.Item_Name__r.Master_Box_Gross_Weight_kg__c  != null ? (totalcajas*li.Item_Name__r.Master_Box_Gross_Weight_kg__c).round(roundingMode.UP) : ( NEU_Utils.safeDecimal(li.Item_Name__r.Weight_Kgs__c) != 0 ? li.Item_Name__r.Weight_Kgs__c*need : 0  )  )),//totalpeso
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)*need).round(roundingMode.UP) : 0),//totalpeso
                        (totalcajas != 0 ? totalcajas : 0),//totalcajas
                        (totalpesolinea > totalvolumen_x_ratio ?  totalpesolinea.round(roundingMode.UP) : totalvolumen_x_ratio.round(roundingMode.UP)),//totalpeso envio
                       // (li.Packaging_Volume_m3__c > 0 ? (totalcajas*li.Packaging_Volume_m3__c).setScale(2,roundingMode.UP) :(li.Item_Name__r.Master_Box_Volume_m3__c != null ? (totalcajas*li.Item_Name__r.Master_Box_Volume_m3__c).setScale(2,roundingMode.UP) : 0)),//volumen master box
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)*need) : 0),//volumen master box
                        0,//numero pallet por linea
                        false,//relacion con pallet
                        relacion_con_pallet,//relaciones con los pallet
                        shipment_number,//shipment number
                        '',//shipment seleccionado
                        null,//fecha
                        li.Id,//idprincipal
                        li.Id+'_'+nuevos_items,//id item
                        li.Units__c,
                        ((li.Supplier_Quote_Line__c != null && li.Supplier_Quote_Line__r.Quantity__c == li.Units__c) || li.Supplier_Quote_Line__c == null ? true : false),// si coinciden con las unidades si tiene relacion
                        li.Supplier_Quote_Line__r,
                        false,
                        (li.Item_Units_x_Packaging__c >0 ? li.Item_Units_x_Packaging__c : (li.Item_Name__r.Units_x_Master_Box__c > 0 ? li.Item_Name__r.Units_x_Master_Box__c : 1)),
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Weight_Kgs__c) != 0 ? ((li.Total_Shipping_Weight_Kgs__c/li.Units__c)).setScale(4,roundingMode.UP) : 0),//peso caja
                        (NEU_Utils.safeDecimal(li.Total_Shipping_Volume_m3__c) != 0 ? ((li.Total_Shipping_Volume_m3__c/li.Units__c)): 0)));
             }
                   
           }
     
           total_unidades_linea = 0;
           shipment_number = null;
           relacion_con_pallet = '';
           
         }   
            
    }
    
    public void Actualizar_lineas()
    {
      List<Quote_Item_Line__c> listaintems = new List<Quote_Item_Line__c>();
    
        listaintems = [select Id,Name,Units__c,Consolidated__c,Observations__c,Delivery_Number__c,Delivery_Date__c,
            
         Item_Name__c,Item_Name__r.Name,Item_Name__r.Item_Price__c,
         Item_Name__r.Safety_Stock_Item_Unit_of_measure__c,Item_Name__r.Reorder_Level_Item_Unit_of_measure__c, 
         Item_Name__r.Master_Box_Description__c, Item_Name__r.Master_Box_Gross_Weight_kg__c,
         Item_Name__r.Master_Box_Volume_m3__c, Item_Name__r.Unit_of_measure__c,  Total_Shipping_Weight_Kgs__c,
         Item_Name__r.Order_Observations__c, Item_Name__r.Weight_Kgs__c, Item_Name__r.Sourcing_Family__c, 
         Item_Name__r.Sourcing_Family__r.Name, Item_Name__r.Inventory_Position__c, Item_Name__r.Safety_Stock_Manual__c, 
         Item_Name__r.Safety_Stock_Formula__c, Item_Name__r.AVG_Dem_in_Lead_Time__c, Item_Name__r.Reorder_Level__c,
         Item_Name__r.Inventory_Position_Reorder_Level__c, Item_Name__r.Minimum_Order_Quantity__c, 
         Item_Name__r.Optimal_Order_Quantity__c, Item_Name__r.Current_Supplier__c, Item_Name__r.Current_Supplier__r.Name, 
         Item_Name__r.Account_Owner__c, Item_Name__r.Account_Owner__r.Name, Duty__c,Percent_Duty__c, Customs_Value__c, Sales_Tax__c, Percent_Taxes__c,   Item_Name__r.Units_x_Master_Box__c, 
         Item_Name__r.Consolidate_by_BOM__c, Item_Name__r.RecordTypeId, Supplier_Quote__r.Supplier_Request_RFP__r.Max_Shipment__c, 
         Item_Name__r.Subfamily__c, Supplier_Quote__c, Supplier_Quote_Line__c  from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id order by Name]; //Item_Name__r.Stock__c
         
         List<Supplier_Quote_Line__c> lista_supplier_quote_update_general = new List<Supplier_Quote_Line__c>();
         string comprobante_id_duplicado = '';
         
      for(Quote_Item_Line__c li : listaintems)
      {
        for(supplier_quote_line_s liqo :listado_supplierquoteline)
        {
          if(li.Id == liqo.idprincipal && li.Units__c != liqo.supply && liqo.sup_quot_line == null)
          {
              if(li.Supplier_Quote_Line__c != null)
                splitSupQuoteLine(li.Supplier_Quote_Line__c, Integer.valueOf(liqo.supply), liqo.fechaField.Delivery_Date__c, liqo.shipment_number_selected, liqo.observaciones,NEU_Utils.safeDecimal(liqo.Total_Shipping_Weight_Kgs), NEU_Utils.safeDecimal(liqo.Total_Shipping_Volume_m3));
            splitQuoteLine(li.Id, Integer.valueOf(liqo.supply), liqo.fechaField.Delivery_Date__c, liqo.shipment_number_selected, liqo.observaciones,NEU_Utils.safeDecimal(liqo.Total_Shipping_Weight_Kgs), NEU_Utils.safeDecimal(liqo.Total_Shipping_Volume_m3));
            //li.Expense_Amount__c =  (NEU_Utils.safeDecimal(li.Expense_Amount__c) != 0? (li.Expense_Amount__c / li.Units__c)*(li.Units__c - liqo.supply): 0);
            li.Units__c =li.Units__c - Integer.valueOf(liqo.supply);
          }
             
          if(li.Id == liqo.idprincipal && liqo.sup_quot_line != null)
          {
            li.Total_Shipping_Weight_Kgs__c = NEU_Utils.safeDecimal(liqo.Total_Shipping_Weight_Kgs);
            li.Total_Shipping_Volume_m3__c = NEU_Utils.safeDecimal(liqo.Total_Shipping_Volume_m3);
            
            li.Duty__c = (NEU_Utils.safeDecimal(li.Duty__c) != 0 ? (li.Duty__c/liqo.cantidad_inicial)*liqo.supply : 0);
            li.Customs_Value__c = (NEU_Utils.safeDecimal(li.Customs_Value__c) != 0 ? (li.Customs_Value__c/liqo.cantidad_inicial)*liqo.supply : 0);
            li.Percent_Duty__c = (NEU_Utils.safeDecimal(li.Duty__c) != 0 && NEU_Utils.safeDecimal(li.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(li.Duty__c)/NEU_Utils.safeDecimal(li.Customs_Value__c)*100 : 0);
            li.Sales_Tax__c = (NEU_Utils.safeDecimal(li.Sales_Tax__c) != 0 ? (li.Sales_Tax__c/liqo.cantidad_inicial)*liqo.supply : 0);
            li.Percent_Taxes__c = (NEU_Utils.safeDecimal(li.Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(li.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(li.Sales_Tax__c)/NEU_Utils.safeDecimal(li.Customs_Value__c)*100 : 0);
        
            li.Expense_Amount__c = (liqo.sup_quot_line.Expense_Amount__c != null ? (liqo.sup_quot_line.Expense_Amount__c/liqo.sup_quot_line.Units__c)* liqo.supply: 0);
            if(liqo.fechaField.Delivery_Date__c != null)
              li.Delivery_Date__c = liqo.fechaField.Delivery_Date__c;
            else
              li.Delivery_Date__c = null;
            if(liqo.shipment_number_selected != null && liqo.shipment_number_selected != '')
              li.Delivery_Number__c = decimal.valueOf(liqo.shipment_number_selected);
            else
              li.Delivery_Number__c = null;
            if(liqo.observaciones != null & liqo.observaciones != '')
              li.Observations__c = liqo.observaciones;
              
             if(li.Supplier_Quote_Line__c != null)
              if(comprobante_id_duplicado.contains(li.Supplier_Quote_Line__c) == false)
              {
                if(liqo.sup_quote_line != null)
                {
                    /*if(liqo.fecha != null)
                      liqo.sup_quote_line.Delivery_Date__c = liqo.fecha;
                    else
                      liqo.sup_quote_line.Delivery_Date__c = null;*/
                  
                   /* if(liqo.shipment_number_selected != null && liqo.shipment_number_selected != '')
                      liqo.sup_quote_line.Delivery_Number__c = decimal.valueOf(liqo.shipment_number_selected);
                    else
                      liqo.sup_quote_line.Delivery_Number__c = null;*/
                   
                    liqo.sup_quote_line.Duty__c = (NEU_Utils.safeDecimal(liqo.sup_quote_line.Duty__c) != 0 ? (liqo.sup_quote_line.Duty__c/liqo.sup_quote_line.Quantity__c)*liqo.supply : 0);
                    liqo.sup_quote_line.Customs_Value__c = (NEU_Utils.safeDecimal(liqo.sup_quote_line.Customs_Value__c) != 0 ? (liqo.sup_quote_line.Customs_Value__c/liqo.sup_quote_line.Quantity__c)*liqo.supply : 0);
                    liqo.sup_quote_line.Percent_Duty__c = (NEU_Utils.safeDecimal(liqo.sup_quote_line.Duty__c) != 0 && NEU_Utils.safeDecimal(liqo.sup_quote_line.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(liqo.sup_quote_line.Duty__c)/NEU_Utils.safeDecimal(liqo.sup_quote_line.Customs_Value__c)*100 : 0);
                    liqo.sup_quote_line.Sales_Tax__c = (NEU_Utils.safeDecimal(liqo.sup_quote_line.Sales_Tax__c) != 0 ? (liqo.sup_quote_line.Sales_Tax__c/liqo.sup_quote_line.Quantity__c)*liqo.supply : 0);
                    liqo.sup_quote_line.Percent_Taxes__c = (NEU_Utils.safeDecimal(liqo.sup_quote_line.Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(liqo.sup_quote_line.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(liqo.sup_quote_line.Sales_Tax__c)/NEU_Utils.safeDecimal(liqo.sup_quote_line.Customs_Value__c)*100 : 0);   
                     
                   if(liqo.observaciones != null & liqo.observaciones != '')
                      liqo.sup_quote_line.Observations__c = liqo.observaciones;
                   
                   liqo.sup_quote_line.Quantity__c = liqo.supply;
                   
                   lista_supplier_quote_update_general.add(liqo.sup_quote_line);
                   comprobante_id_duplicado +=liqo.sup_quote_line.Id;
                }
            }
              
          }
        }
        }
        
        record.Quotation_Status__c = 'Approved as Succesful';
        record.RecordTypeId = Schema.SobjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Order').getRecordTypeId();
      try
       {
          update record;
          NEU_StaticVariableHelper.setBoolean1(true);
          if(lista_update_split_sup != null && lista_update_split_sup.size()>0)
            insert lista_update_split_sup;
          if(lista_update_split != null && lista_update_split.size()>0)
          {
            for(Quote_Item_Line__c qil: lista_update_split)
                qil.Supplier_Quote_Line__c = qil.Supplier_Quote_Line__r.Id;
            insert lista_update_split;
          }
          
          if(lista_supplier_quote_update_general.size()>0)
            update lista_supplier_quote_update_general;
          update listaintems;
          NEU_StaticVariableHelper.setBoolean1(false);
       }
       catch(Exception ex){system.debug(ex);}
    }
    
   public void splitQuoteLine(String lineid,Integer units, Date fecha, string number_delivery, string obser, decimal peso, decimal volumen)//private
  {
    List<Quote_Item_Line__c> lista_quotes_lines  = new List<Quote_Item_Line__c>();
    String query='select Id,Name';
    Boolean firstField=true;
    Map<String,Schema.SObjectField>objectFields=Quote_Item_Line__c.getSobjectType().getDescribe().fields.getMap();
    for(String s:objectFields.keySet())
    {
      if((s!='Id')&&(s!='Name'))
        query+=','+s;
    }
    query+=' from Quote_Item_Line__c where Id=\''+lineid+'\'';
    List<Quote_Item_Line__c>lines=database.query(query);
    if(lines.size()>0)
    {
      if((units>0)&&(units<lines[0].Units__c))
      {
        if(lista_update_split == null)
            lista_update_split = new List<Quote_Item_Line__c>();
        Quote_Item_Line__c newline=lines[0].clone(false,true);
        newline.Units__c=units;
        newLine.Consolidated__c=false;
        newLine.Delivery_Date__c = fecha;
        newLine.Total_Shipping_Weight_Kgs__c =  peso;
        newLine.Total_Shipping_Volume_m3__c = volumen;
        
        newLine.Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 ? (lines[0].Duty__c/lines[0].Units__c)*units : 0);
        newLine.Customs_Value__c = (NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0 ? (lines[0].Customs_Value__c/lines[0].Units__c)*units : 0);
        newLine.Percent_Duty__c = (NEU_Utils.safeDecimal(newLine.Duty__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Duty__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
        newLine.Sales_Tax__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 ? (lines[0].Sales_Tax__c/lines[0].Units__c)*units : 0);
        newLine.Percent_Taxes__c = (NEU_Utils.safeDecimal(newLine.Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Sales_Tax__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
        
        newLine.Expense_Amount__c =  (NEU_Utils.safeDecimal(lines[0].Expense_Amount__c) != 0 ? (lines[0].Expense_Amount__c/lines[0].Units__c)*units : 0);
        if(number_delivery != null && number_delivery != '')
          newLine.Delivery_Number__c = decimal.valueof(number_delivery);
         else
           newLine.Delivery_Number__c = null;
        if (obser != null)
          newLine.Observations__c = obser;
          newline.Supplier_Quote_Line__r = id_nueva_linea;
        lista_update_split.add(newline);
        
      }      
    }
  }
  
  
  
   public void splitSupQuoteLine(String lineid,Integer units, Date fecha, string number_delivery, string obser, decimal peso, decimal volumen)//private
  {
    String query='select Id,Name';
    Boolean firstField=true;
    Map<String,Schema.SObjectField>objectFields=Supplier_Quote_Line__c.getSobjectType().getDescribe().fields.getMap();
    for(String s:objectFields.keySet())
    {
      if((s!='Id')&&(s!='Name'))
        query+=','+s;
    }
    query+=' from Supplier_Quote_Line__c where Id=\''+lineid+'\'';
    List<Supplier_Quote_Line__c>lines=database.query(query);
    if(lines.size()>0)
    {
      if((units>0)&&(units<lines[0].Quantity__c))
      {
        if(lista_update_split_sup == null)
            lista_update_split_sup = new List<Supplier_Quote_Line__c>();
        Supplier_Quote_Line__c newline=lines[0].clone(false,true);
        newline.Quantity__c=units;
        //newLine.Delivery_Date__c = fecha;
        newLine.Total_Weight_Kg__c =  peso;
        newLine.Total_Volume_m3__c = volumen;
        newLine.Expense_Amount__c =  (NEU_Utils.safeDecimal(lines[0].Expense_Amount__c) != 0 ? (lines[0].Expense_Amount__c/lines[0].Quantity__c)*units : 0);
       /* if(number_delivery != null && number_delivery != '')
          newLine.Delivery_Number__c = decimal.valueof(number_delivery);
         else
           newLine.Delivery_Number__c = null;*/
        newLine.Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 ? (lines[0].Duty__c/lines[0].Quantity__c)*units : 0);
        newLine.Customs_Value__c = (NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0 ? (lines[0].Customs_Value__c/lines[0].Quantity__c)*units : 0);
        newLine.Percent_Duty__c = (NEU_Utils.safeDecimal(newLine.Duty__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Duty__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
        newLine.Sales_Tax__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 ? (lines[0].Sales_Tax__c/lines[0].Quantity__c)*units : 0);
        newLine.Percent_Taxes__c = (NEU_Utils.safeDecimal(newLine.Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Sales_Tax__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
        if (obser != null)
          newLine.Observations__c = obser;
        //insert newline;
        lista_update_split_sup.add(newline);
        id_nueva_linea = newline;
      }    
    }
    
    
  }
  
}