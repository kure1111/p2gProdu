public with sharing class NEU_OM_Shipment_Management {
    
    public Supplier_Quote__c record;
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
    
    public List<SelectOption> Numero_shipment = null;
    private string Numero_shipment_selected='';
    public string unidades_quoted {get;set;}
    ApexPages.StandardController con;

    public NEU_OM_Shipment_Management(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Supplier_Request_RFP__c, Supplier_Request_RFP__r.Max_Shipment__c, Max_Deliveries__c, Contract_Duration_months__c from Supplier_Quote__c where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Supplier_Quote__c();
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
        public Supplier_Quote_Line__c sup_quot_line {get; set;}
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
        public Date fecha {get; set;}
        public String idprincipal {get; set;}
        public String iditem_mod {get; set;}
        public decimal cantidad_inicial {get; set;}
        
        public decimal unidades_x_caja_linea{get; set;}//ok
        public decimal peso_x_caja_linea{get; set;}//ok
        public decimal volumen_x_caja_linea{get; set;} //Ok
        public decimal peso_item_sin_caja{get; set;}//ok
        
         public decimal Total_Shipping_Weight_Kgs{get; set;}
        public decimal Total_Shipping_Volume_m3{get; set;}
        
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
         public String unidades_x_caja_lineaSep
        {
          get
          {
            if(unidades_x_caja_linea !=null)
              return unidades_x_caja_linea.format();
            return null;
          }
          set
          {
            unidades_x_caja_linea=NEU_Utils.toDecimal(value);
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
              if(sup_quot_line.Quantity__c !=null)
                return sup_quot_line.Quantity__c.format();
            return null;
          }
          set
          {
            if(sup_quot_line!=null)
              sup_quot_line.Quantity__c=NEU_Utils.toDecimal(value);
          }
        }
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
        
        public supplier_quote_line_s(Supplier_Quote_Line__c sup_quot_line,Sourcing_Item__c line,boolean selected,
         String observaciones, decimal supply, decimal totalpeso, decimal totalcajas, decimal totalpesoenvio, decimal volumen_master_box, 
         decimal total_pallet_linea, boolean tiene_relacion_con_pallet, string relacion_con_pallet, List<SelectOption> shipment_number , 
         String shipment_number_selected, Date fecha, String idprincipal, String iditem_mod, decimal cantidad_inicial,
         decimal unidades_x_caja_linea, decimal peso_x_caja_linea, decimal volumen_x_caja_linea, decimal peso_item_sin_caja )
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
            
            this.unidades_x_caja_linea = unidades_x_caja_linea;
            this.peso_x_caja_linea = peso_x_caja_linea;
            this.volumen_x_caja_linea = volumen_x_caja_linea;
            this.peso_item_sin_caja = peso_item_sin_caja;
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
            
            List<Supplier_Quote_Line__c> listaintems = new List<Supplier_Quote_Line__c>();
            listaintems = [select Id,Name,Quantity__c,Consolidated__c,Observations__c,Delivery_Number__c,Delivery_Date__c,Item__c,
            Item__r.Name,Item__r.Item_Price__c,Item__r.Safety_Stock_Item_Unit_of_measure__c, Total_Weight_Kg__c, Total_Volume_m3__c,
            Item__r.Reorder_Level_Item_Unit_of_measure__c, Item__r.Master_Box_Description__c, Item__r.Master_Box_Gross_Weight_kg__c,Expense_Amount__c,
            Item__r.Master_Box_Volume_m3__c, Item__r.Unit_of_measure__c, Item__r.Order_Observations__c, Duty__c,Percent_Duty__c, Customs_Value__c, Sales_Tax__c, Percent_Taxes__c, Item_Units_x_Packaging__c,
            Packaging_Gross_Weight_kg__c, Packaging_Volume_m3__c, Supplier_Item_Weight_kg__c, Item__r.Weight_Kgs__c, Item__r.Sourcing_Family__c, Item__r.Sourcing_Family__r.Name, Item__r.Inventory_Position__c, Item__r.Safety_Stock_Manual__c, Item__r.Safety_Stock_Formula__c, Item__r.AVG_Dem_in_Lead_Time__c, Item__r.Reorder_Level__c, Item__r.Inventory_Position_Reorder_Level__c, Item__r.Minimum_Order_Quantity__c, Item__r.Optimal_Order_Quantity__c, Item__r.Current_Supplier__c, Item__r.Current_Supplier__r.Name, Item__r.Account_Owner__c, Item__r.Account_Owner__r.Name, Item__r.Units_x_Master_Box__c, Item__r.Consolidate_by_BOM__c, Item__r.RecordTypeId, Item__r.Subfamily__c, Supplier_Quote__c  from Supplier_Quote_Line__c where Supplier_Quote__c =: record.Id and Active__c =: true order by Name]; //Item__r.Stock__c
            
            //listado shipments
            List<SelectOption>  shipments_combo = new List<SelectOption>();
            shipments_combo.add(new SelectOption('', ''));
              if(record.Max_Deliveries__c != null)
              {
                  integer i =1;
                  while( i <= record.Max_Deliveries__c)
                  {
                        shipments_combo.add(new SelectOption(string.valueof(i), 'Delivery '+i));
                        i++;
                  } 
              }
             decimal need = 0;
             decimal totalcajas=0;
             decimal totalpesolinea = 0;
             decimal ratio=1;
             decimal totalvolumen_x_ratio =0;
             string relaciones = '';
            for(Supplier_Quote_Line__c li : listaintems)
            {
                relaciones = '';
                for(Item_Pallet_Type__c ip: items_pallet_type)
                {
                    if(ip.Item_Name__c == li.Item__c)
                    {
                        //relaciones = ip.Pallet_Type__c+'_'+ip.Packages_Pallet__c+'|';
                        relaciones += ip.Pallet_Type__c+'_'+((NEU_Utils.safeDecimal(li.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(li.Item_Units_x_Packaging__c)*ip.Packages_Pallet__c : (NEU_Utils.safeDecimal(li.Item__r.Units_x_Master_Box__c) != 0 ? NEU_Utils.safeDecimal(li.Item__r.Units_x_Master_Box__c)*ip.Packages_Pallet__c:0)))+'|';
                    }
                    
                }
                need = 0;
                totalcajas=0;
                totalpesolinea = 0;
                ratio=1;
                totalvolumen_x_ratio =0;
                need = li.Quantity__c;
                
           
                  if(li.Item_Units_x_Packaging__c >0)
                 {
                    totalcajas = (need/li.Item_Units_x_Packaging__c).round(roundingMode.UP);
                 }
                 else
                 {
                    if(li.Item__r.Units_x_Master_Box__c != null)
                        totalcajas = (need/li.Item__r.Units_x_Master_Box__c).round(roundingMode.UP);
                    else
                      totalcajas = need;
                 } 
                
               if(li.Packaging_Gross_Weight_kg__c >0)
                  totalpesolinea =  totalcajas*li.Packaging_Gross_Weight_kg__c;
                else
                {
                    if(li.Item__r.Master_Box_Gross_Weight_kg__c >0)
                        totalpesolinea = totalcajas*li.Item__r.Master_Box_Gross_Weight_kg__c;
                    else
                    {
                        if(totalcajas != null && totalcajas != 0 && li.Item__r.Weight_Kgs__c != null)
                            totalpesolinea = totalcajas * li.Item__r.Weight_Kgs__c;
                        else
                            totalpesolinea = 0;
                    }
                }
                
                    
                if(li.Packaging_Volume_m3__c > 0)
                   totalvolumen_x_ratio = li.Packaging_Volume_m3__c;
                else  
                {
                   if(li.Item__r.Master_Box_Volume_m3__c != null)
                        totalvolumen_x_ratio = li.Item__r.Master_Box_Volume_m3__c;
                   else
                        totalvolumen_x_ratio = 0;
                }   
                if(li.Quantity__c != null)
                {
                listado_supplierquoteline.add(new supplier_quote_line_s(li,li.Item__r,false,li.Observations__c,need,//sourcing item, selected, observaciones, supply(unidades)
                       // (li.Packaging_Gross_Weight_kg__c >0 ? (totalcajas*li.Packaging_Gross_Weight_kg__c).round(roundingMode.UP) :(li.Item__r.Master_Box_Gross_Weight_kg__c  != null ? (totalcajas*li.Item__r.Master_Box_Gross_Weight_kg__c).round(roundingMode.UP) : (li.Item__r.Weight_Kgs__c != null ? li.Item__r.Weight_Kgs__c*totalcajas : 0))),//totalpeso
                        (NEU_Utils.safeDecimal(li.Total_Weight_Kg__c) != 0 ? ((li.Total_Weight_Kg__c/li.Quantity__c)*need).setScale(2,roundingMode.UP) : 0),//totalpeso
                        (totalcajas != 0 ? totalcajas : 0),//totalcajas
                        (totalpesolinea > totalvolumen_x_ratio ?  totalpesolinea.round(roundingMode.UP) : totalvolumen_x_ratio.round(roundingMode.UP)),//totalpeso envio
                        //(li.Packaging_Volume_m3__c >0 ? (totalcajas*li.Packaging_Volume_m3__c) :(li.Item__r.Master_Box_Volume_m3__c != null ? (totalcajas*li.Item__r.Master_Box_Volume_m3__c).setScale(2,roundingMode.UP) : 0)),//volumen master box
                        (NEU_Utils.safeDecimal(li.Total_Volume_m3__c) != 0 ? ((li.Total_Volume_m3__c/li.Quantity__c)*need) : 0),//volumen master box
                        0,//numero pallet por linea
                        false,//relacion con pallet
                        relaciones,//relaciones con los pallet
                        shipments_combo,//shipment number
                        string.valueof(li.Delivery_Number__c),//shipment seleccionado
                        li.Delivery_Date__c,//fecha
                        li.Id,//id principal
                        li.Id,//id item
                        li.Quantity__c,
                        (li.Item_Units_x_Packaging__c >0 ? li.Item_Units_x_Packaging__c: li.Item__r.Units_x_Master_Box__c ),
                        //(li.Packaging_Gross_Weight_kg__c > 0 ? li.Packaging_Gross_Weight_kg__c : li.Item__r.Master_Box_Gross_Weight_kg__c),
                        (NEU_Utils.safeDecimal(li.Total_Weight_Kg__c) != 0 ? ((li.Total_Weight_Kg__c/li.Quantity__c)).setScale(4,roundingMode.UP) : 0),
                        //(li.Packaging_Volume_m3__c >0 ? li.Packaging_Volume_m3__c : li.Item__r.Master_Box_Volume_m3__c),
                         (NEU_Utils.safeDecimal(li.Total_Volume_m3__c) != 0 ? ((li.Total_Volume_m3__c/li.Quantity__c)) : 0),
                        //(li.Supplier_Item_Weight_kg__c >0 ? li.Supplier_Item_Weight_kg__c : li.Item__r.Weight_Kgs__c)));
                        (NEU_Utils.safeDecimal(li.Total_Weight_Kg__c) != 0 ? ((li.Total_Weight_Kg__c/li.Quantity__c)).setScale(4,roundingMode.UP) : 0)));
                }
                
            }
        }
        
        return listado_supplierquoteline;
    }
    
     public void cancelar()
    {
        listado_supplierquoteline = null;
    }
    
    public PageReference guardar_nuevos_deliverys()
    {
        
        con.save();
        Numero_shipment = null;
        listado_supplierquoteline = null;
        String returnUrl = '/apex/NEU_OM_Shipment_Management'; 
        PageReference pgReturnPage  = new PageReference(returnUrl);
        pgReturnPage.getParameters().put('id', record.Id);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    
    public void Recalcular()
    {
         List<Supplier_Quote_Line__c> listaintems = new List<Supplier_Quote_Line__c>();
         listaintems = [select Id,Name,Quantity__c,Delivery_Date__c,Item__c, Total_Weight_Kg__c, Total_Volume_m3__c, Item_Units_x_Packaging__c,Packaging_Gross_Weight_kg__c, Packaging_Volume_m3__c, Supplier_Item_Weight_kg__c,Item__r.Name,Item__r.Item_Price__c,Item__r.Safety_Stock_Item_Unit_of_measure__c,Item__r.Reorder_Level_Item_Unit_of_measure__c, Item__r.Master_Box_Description__c, Item__r.Master_Box_Gross_Weight_kg__c, Item__r.Master_Box_Volume_m3__c, Item__r.Unit_of_measure__c, Item__r.Order_Observations__c, Item__r.Weight_Kgs__c, Item__r.Sourcing_Family__c, Item__r.Sourcing_Family__r.Name, Item__r.Inventory_Position__c, Item__r.Safety_Stock_Manual__c, Item__r.Safety_Stock_Formula__c, Item__r.AVG_Dem_in_Lead_Time__c, Item__r.Reorder_Level__c, Item__r.Inventory_Position_Reorder_Level__c, Item__r.Minimum_Order_Quantity__c, Item__r.Optimal_Order_Quantity__c, Item__r.Current_Supplier__c, Item__r.Current_Supplier__r.Name, Item__r.Account_Owner__c, Item__r.Account_Owner__r.Name, Item__r.Units_x_Master_Box__c, Item__r.Consolidate_by_BOM__c, Item__r.RecordTypeId, Item__r.Subfamily__c, Supplier_Quote__c  from Supplier_Quote_Line__c where Supplier_Quote__c =: record.Id and Active__c =: true order by Name]; //Item__r.Stock__c
         decimal total_unidades_linea = 0;
         decimal posicion = 0;//caso de añadir nueva linea
         decimal nuevos_items = 0;
         integer contador_de_posicion = 0;
         boolean encontrados = false;
         
         decimal need = 0;
         decimal totalcajas=0;
         decimal totalpesolinea = 0;
         decimal ratio=1;
         decimal totalvolumen_x_ratio =0;
         String relacion_con_pallet = '';
         List<SelectOption> shipment_number = null;
         nuevos_items = listado_supplierquoteline.size();
         for(Supplier_Quote_Line__c li : listaintems)
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
                    relacion_con_pallet = sup.relacion_con_pallet;
                    shipment_number = sup.shipment_number;
                    contador_de_posicion ++;
                    encontrados = true;
                }
                if(encontrados == false)
                    contador_de_posicion ++;
            }
            //en caso de no coincidir las lineas
            if(li.Quantity__c > total_unidades_linea)
            {
                need = 0;
                totalcajas=0;
                totalpesolinea = 0;
                ratio=1;
                totalvolumen_x_ratio =0;
                
                need = li.Quantity__c-total_unidades_linea;
                //calculo de pesos Y volumen
                
                  
                 if(li.Item_Units_x_Packaging__c >0)
                 {
                    totalcajas = (need/li.Item_Units_x_Packaging__c).round(roundingMode.UP);
                 }
                 else
                 {
                    if(li.Item__r.Units_x_Master_Box__c != null)
                        totalcajas = (need/li.Item__r.Units_x_Master_Box__c).round(roundingMode.UP);
                    else
                      totalcajas = need;
                 } 
                 
                
                if(li.Packaging_Gross_Weight_kg__c >0)
                  totalpesolinea =  totalcajas*li.Packaging_Gross_Weight_kg__c;
                else
                {
                    if(li.Item__r.Master_Box_Gross_Weight_kg__c >0)
                        totalpesolinea = totalcajas*li.Item__r.Master_Box_Gross_Weight_kg__c;
                    else
                    {
                        if(totalcajas != null && totalcajas != 0 && li.Item__r.Weight_Kgs__c != null)
                            totalpesolinea = totalcajas * li.Item__r.Weight_Kgs__c;
                        else
                            totalpesolinea = 0;
                    }
                }  
              
              
                if(li.Packaging_Volume_m3__c > 0)
                   totalvolumen_x_ratio = li.Packaging_Volume_m3__c;
                else  
                {
                   if(li.Item__r.Master_Box_Volume_m3__c != null)
                        totalvolumen_x_ratio = li.Item__r.Master_Box_Volume_m3__c;
                   else
                        totalvolumen_x_ratio = 0;
                }       
                //-----------------------------------------------------------------------------
                
                
                //insert nueva linea
                if(contador_de_posicion<listado_supplierquoteline.size())
                {
                        listado_supplierquoteline.add(contador_de_posicion,new supplier_quote_line_s(null,li.Item__r,false,'',need,//sourcing item, selected, observaciones, supply(unidades)
                       // (li.Packaging_Gross_Weight_kg__c >0 ? (totalcajas*li.Packaging_Gross_Weight_kg__c).round(roundingMode.UP) :(li.Item__r.Master_Box_Gross_Weight_kg__c  != null ? (totalcajas*li.Item__r.Master_Box_Gross_Weight_kg__c).round(roundingMode.UP) : (li.Item__r.Weight_Kgs__c != null ? li.Item__r.Weight_Kgs__c*totalcajas : 0))),//totalpeso
                        (NEU_Utils.safeDecimal(li.Total_Weight_Kg__c) != 0 ? ((li.Total_Weight_Kg__c/li.Quantity__c)*need).setScale(2,roundingMode.UP) : 0),//totalpeso
                        (totalcajas != 0 ? totalcajas : 0),//totalcajas
                        (totalpesolinea > totalvolumen_x_ratio ?  totalpesolinea.round(roundingMode.UP) : totalvolumen_x_ratio.round(roundingMode.UP)),//totalpeso envio
                        //(li.Packaging_Volume_m3__c >0 ? (totalcajas*li.Packaging_Volume_m3__c) :(li.Item__r.Master_Box_Volume_m3__c != null ? (totalcajas*li.Item__r.Master_Box_Volume_m3__c).setScale(2,roundingMode.UP) : 0)),//volumen master box
                         (NEU_Utils.safeDecimal(li.Total_Volume_m3__c) != 0 ? ((li.Total_Volume_m3__c/li.Quantity__c)*need) : 0),//volumen master box
                        0,//numero pallet por linea
                        false,//relacion con pallet
                        relacion_con_pallet,//relaciones con los pallet
                        shipment_number,//shipment number
                        '',//shipment seleccionado
                        null,//fecha
                        li.Id,//idprincipal
                        li.Id+'_'+nuevos_items,//id item
                        li.Quantity__c,
                        (li.Item_Units_x_Packaging__c >0 ? li.Item_Units_x_Packaging__c: li.Item__r.Units_x_Master_Box__c ),
                        //(li.Packaging_Gross_Weight_kg__c > 0 ? li.Packaging_Gross_Weight_kg__c : li.Item__r.Master_Box_Gross_Weight_kg__c),
                        (NEU_Utils.safeDecimal(li.Total_Weight_Kg__c) != 0 ? ((li.Total_Weight_Kg__c/li.Quantity__c)).setScale(4,roundingMode.UP) : 0),
                        //(li.Packaging_Volume_m3__c >0 ? li.Packaging_Volume_m3__c : li.Item__r.Master_Box_Volume_m3__c),
                        (NEU_Utils.safeDecimal(li.Total_Volume_m3__c) != 0 ? ((li.Total_Volume_m3__c/li.Quantity__c)) : 0),
                        //(li.Supplier_Item_Weight_kg__c >0 ? li.Supplier_Item_Weight_kg__c : li.Item__r.Weight_Kgs__c)));
                        (NEU_Utils.safeDecimal(li.Total_Weight_Kg__c) != 0 ? ((li.Total_Weight_Kg__c/li.Quantity__c)).setScale(4,roundingMode.UP) : 0)));
                }
                else
                {
                        listado_supplierquoteline.add(new supplier_quote_line_s(null,li.Item__r,false,'',need,//sourcing item, selected, observaciones, supply(unidades)
                        //(li.Packaging_Gross_Weight_kg__c >0 ? (totalcajas*li.Packaging_Gross_Weight_kg__c).round(roundingMode.UP) :(li.Item__r.Master_Box_Gross_Weight_kg__c  != null ? (totalcajas*li.Item__r.Master_Box_Gross_Weight_kg__c).round(roundingMode.UP) : (li.Item__r.Weight_Kgs__c != null ? li.Item__r.Weight_Kgs__c*totalcajas : 0))),//totalpeso
                        (NEU_Utils.safeDecimal(li.Total_Weight_Kg__c) != 0 ? ((li.Total_Weight_Kg__c/li.Quantity__c)*need).setScale(2,roundingMode.UP) : 0),//totalpeso
                        (totalcajas != 0 ? totalcajas : 0),//totalcajas
                        (totalpesolinea > totalvolumen_x_ratio ?  totalpesolinea.round(roundingMode.UP) : totalvolumen_x_ratio.round(roundingMode.UP)),//totalpeso envio
                        //(li.Packaging_Volume_m3__c >0 ? (totalcajas*li.Packaging_Volume_m3__c) :(li.Item__r.Master_Box_Volume_m3__c != null ? (totalcajas*li.Item__r.Master_Box_Volume_m3__c).setScale(2,roundingMode.UP) : 0)),//volumen master box
                         (NEU_Utils.safeDecimal(li.Total_Volume_m3__c) != 0 ? ((li.Total_Volume_m3__c/li.Quantity__c)*need) : 0),//volumen master box
                        0,//numero pallet por linea
                        false,//relacion con pallet
                        relacion_con_pallet,//relaciones con los pallet
                        shipment_number,//shipment number
                        '',//shipment seleccionado
                        null,//fecha
                        li.Id,//idprincipal
                        li.Id+'_'+nuevos_items,//id item
                        li.Quantity__c,  
                        (li.Item_Units_x_Packaging__c >0 ? li.Item_Units_x_Packaging__c: li.Item__r.Units_x_Master_Box__c ),
                       // (li.Packaging_Gross_Weight_kg__c > 0 ? li.Packaging_Gross_Weight_kg__c : li.Item__r.Master_Box_Gross_Weight_kg__c),
                       (NEU_Utils.safeDecimal(li.Total_Weight_Kg__c) != 0 ? ((li.Total_Weight_Kg__c/li.Quantity__c)).setScale(4,roundingMode.UP) : 0),
                       // (li.Packaging_Volume_m3__c >0 ? li.Packaging_Volume_m3__c : li.Item__r.Master_Box_Volume_m3__c),
                       (NEU_Utils.safeDecimal(li.Total_Volume_m3__c) != 0 ? ((li.Total_Volume_m3__c/li.Quantity__c)) : 0),
                       // (li.Supplier_Item_Weight_kg__c >0 ? li.Supplier_Item_Weight_kg__c : li.Item__r.Weight_Kgs__c)));
                       (NEU_Utils.safeDecimal(li.Total_Weight_Kg__c) != 0 ? ((li.Total_Weight_Kg__c/li.Quantity__c)).setScale(4,roundingMode.UP) : 0)));
                }
                   
            }
     
            total_unidades_linea = 0;
            shipment_number = null;
            relacion_con_pallet = '';
            
         }   
         
            
    }
    
    public void Actualizar_lineas()
    {
        List<Supplier_Quote_Line__c> listaintems = new List<Supplier_Quote_Line__c>();
        listaintems = [select Id,Name,Delivery_Date__c,Quantity__c,Item__c,Duty__c,Customs_Value__c,Percent_Duty__c,Sales_Tax__c,Percent_Taxes__c,  Item_Units_x_Packaging__c,Packaging_Gross_Weight_kg__c, Packaging_Volume_m3__c, Supplier_Item_Weight_kg__c,Observations__c,Item__r.Name,Item__r.Item_Price__c,Item__r.Safety_Stock_Item_Unit_of_measure__c,Item__r.Reorder_Level_Item_Unit_of_measure__c, Item__r.Master_Box_Description__c, Item__r.Master_Box_Gross_Weight_kg__c, Item__r.Master_Box_Volume_m3__c, Item__r.Unit_of_measure__c, Item__r.Order_Observations__c, Item__r.Weight_Kgs__c, Item__r.Sourcing_Family__c, Item__r.Sourcing_Family__r.Name, Item__r.Inventory_Position__c, Item__r.Safety_Stock_Manual__c, Item__r.Safety_Stock_Formula__c, Item__r.AVG_Dem_in_Lead_Time__c, Item__r.Reorder_Level__c, Item__r.Inventory_Position_Reorder_Level__c, Item__r.Minimum_Order_Quantity__c, Item__r.Optimal_Order_Quantity__c, Item__r.Current_Supplier__c, Item__r.Current_Supplier__r.Name, Item__r.Account_Owner__c, Item__r.Account_Owner__r.Name, Item__r.Units_x_Master_Box__c, Item__r.Consolidate_by_BOM__c, Item__r.RecordTypeId, Item__r.Subfamily__c, Supplier_Quote__c  from Supplier_Quote_Line__c where Supplier_Quote__c =: record.Id and Active__c =: true order by Name]; //Item__r.Stock__c
        
        for(Supplier_Quote_Line__c li : listaintems)
        {
            for(supplier_quote_line_s liqo :listado_supplierquoteline)
            {
                if(li.Id == liqo.idprincipal && li.Quantity__c != liqo.supply && liqo.sup_quot_line == null)
                {
                    splitSupQuoteLine(li.Id, Integer.valueOf(liqo.supply), liqo.fechaField.Delivery_Date__c, liqo.shipment_number_selected, liqo.observaciones,NEU_Utils.safeDecimal(liqo.Total_Shipping_Weight_Kgs), NEU_Utils.safeDecimal(liqo.Total_Shipping_Volume_m3));
                    li.Quantity__c =li.Quantity__c - liqo.supply;
                    
                }
                if(li.Id == liqo.idprincipal && liqo.sup_quot_line != null)
                {
                    li.Total_Weight_Kg__c = NEU_Utils.safeDecimal(liqo.Total_Shipping_Weight_Kgs);
                    li.Total_Volume_m3__c = NEU_Utils.safeDecimal(liqo.Total_Shipping_Volume_m3);
                    li.Expense_Amount__c = (liqo.sup_quot_line.Expense_Amount__c != null && NEU_Utils.safeDecimal(liqo.sup_quot_line.Expense_Amount__c) != 0 ? (liqo.sup_quot_line.Expense_Amount__c/liqo.sup_quot_line.Quantity__c)* liqo.supply: 0);
                    
                    li.Duty__c = (NEU_Utils.safeDecimal(li.Duty__c) != 0 ? (li.Duty__c/liqo.cantidad_inicial)*liqo.supply : 0);
                    li.Customs_Value__c = (NEU_Utils.safeDecimal(li.Customs_Value__c) != 0 ? (li.Customs_Value__c/liqo.cantidad_inicial)*liqo.supply : 0);
                    li.Percent_Duty__c = (NEU_Utils.safeDecimal(li.Duty__c) != 0 && NEU_Utils.safeDecimal(li.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(li.Duty__c)/NEU_Utils.safeDecimal(li.Customs_Value__c)*100 : 0);
                    li.Sales_Tax__c = (NEU_Utils.safeDecimal(li.Sales_Tax__c) != 0 ? (li.Sales_Tax__c/liqo.cantidad_inicial)*liqo.supply : 0);
                    li.Percent_Taxes__c = (NEU_Utils.safeDecimal(li.Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(li.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(li.Sales_Tax__c)/NEU_Utils.safeDecimal(li.Customs_Value__c)*100 : 0);
                    
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
                }
            }
        }
        
        record.Supplier_Quote_Status__c = 'Approved';
        record.RecordTypeId = Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Order').getRecordTypeId();
      try
       {
            update record;
            update listaintems;
       }
       catch(Exception ex){}
    }
    
   private void splitSupQuoteLine(String lineid,Integer units, Date fecha, string number_delivery, string obser,decimal peso, decimal volumen)
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
        Supplier_Quote_Line__c newline=lines[0].clone(false,true);
        newline.Quantity__c=units;
        newLine.Consolidated__c=false;
        newLine.Delivery_Date__c = fecha;
        newLine.Total_Weight_Kg__c =  peso;
        newLine.Total_Volume_m3__c = volumen;
        newLine.Expense_Amount__c =  (NEU_Utils.safeDecimal(lines[0].Expense_Amount__c) != 0 ? (lines[0].Expense_Amount__c/lines[0].Quantity__c)*units : 0);
        if(number_delivery != null && number_delivery != '')
            newLine.Delivery_Number__c = decimal.valueof(number_delivery);
        else
            newLine.Delivery_Number__c = null;
        newLine.Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 ? (lines[0].Duty__c/lines[0].Quantity__c)*units : 0);
        newLine.Customs_Value__c = (NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0 ? (lines[0].Customs_Value__c/lines[0].Quantity__c)*units : 0);
        newLine.Percent_Duty__c = (NEU_Utils.safeDecimal(newLine.Duty__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Duty__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
        newLine.Sales_Tax__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 ? (lines[0].Sales_Tax__c/lines[0].Quantity__c)*units : 0);
        newLine.Percent_Taxes__c = (NEU_Utils.safeDecimal(newLine.Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Sales_Tax__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
        if (obser != null)
            newLine.Observations__c = obser;
        insert newline;
      }      
    }
  }
}