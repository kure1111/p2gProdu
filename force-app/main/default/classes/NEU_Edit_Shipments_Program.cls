public with sharing class NEU_Edit_Shipments_Program 
{

   // ordenacion de columnas
     public String[] ordenacion_quotes;
     public String orden_quotes {get;set;}
     
     //filtro de lineas
     private List<Line_s> Lines=null;
     private List<Line_s> Lines_update=null;
     private Set<string> accountid = null;
     private List<SelectOption> accountList=null;
     private String accountName=''; 
     public Integer accountTypeNumber=1;
     private boolean notAuthorizedNumber=false;
     private Integer notConsolidatedNumber=0;
     public decimal valor_zero {get;set;}
     public List<Quote_Item_Line__c> lista_update_split = null;
     public List<Quote_Item_Line__c> lista_update_split2 = null;
     public Supplier_Quote_Line__c id_nueva_linea{get;set;}
     public List<Supplier_Quote_Line__c> lista_update_split_sup = null;
     private Quote_Item_Line__c filtro_fecha = null;
     
     //cal pesos y volumenes
     private string container_selected='';
     public string ids_pallet_idscontenedores {get;set;}
     public List<SelectOption> containers = null;
     public decimal TotalNumberBoxes {get;set;}
     public decimal TotalNumberPallets {get;set;}
     public decimal Grossweight {get;set;}
     public decimal Cube {get;set;}
     public decimal TotalNumberCont {get;set;}
     public decimal FreeSpaceCont  {get;set;}
     public string porc_ocupacion {get;set;}
     public decimal total_pallet_linea  {get;set;}
     public string max_peso_container {get;set;}
     public string max_volumen_container {get;set;}
     public string num_cont_x_pallet {get;set;}
     public boolean la_lista_no_cero {get;set;}
     
     //filtros cabeceras
     public List<String> status_selected {get;set;}
     public Carrier_Line_Load_Point__c new_filter_route_cabeceras {get;set;}
     public Shipment__c new_filter_date_cabeceras {get;set;}
     private List<Import_Export_Supplier_Order_s> List_import_export_supplier_order=null;
     public String orden_cabeceras_modo {get;set;}
     public String orden_cabeceras {get;set;}
     public boolean see_actual_import_export {get;set;}
     public String contenedor_actual_import_export {get;set;}
     public Set<String> contenedor_actual_lines_import_export {get;set;}
     
     private Integer linesTypeNumber=0;
     private String routeid = null;
     private string Freight_Mode_id = null;
        
     public Shipment_Program__c record=null;    
     public boolean todo_insertado = false;
        
     public String alertuser{get;set;}    
        
     public NEU_Edit_Shipments_Program(ApexPages.StandardController stdController) 
     {
            if (!Test.isRunningTest())stdController.AddFields(new String[]{'Id','Name','Type_of_Lines__c','Route__c', 'Route__r.Port_Airport_of_Discharge__c', 'Route__r.Country_of_Discharge__c', 'Route__r.Country_of_Load__c', 'Route__r.Port_Airport_of_Load__c', 'Freight_Mode__c','Planned_ETD__c','Pallet_Container_Type__c','Number_of_Containers__c','Number_of_Packages__c','Number_of_Pallets__c','Total_Gross_Volume_m3__c','Total_Gross_Weight_Kg__c','Route__r.State_of_Discharge__c','Route__r.State_of_Load__c'});
            record=(Shipment_Program__c)stdController.getRecord();
            
            if(record.Type_of_Lines__c != null)
            {
              if(record.Type_of_Lines__c =='Customer Order Lines')
                linesTypeNumber = 1;
              if(record.Type_of_Lines__c =='Supplier Quote Lines')
                linesTypeNumber = 3;
              if(record.Type_of_Lines__c =='Quote Item Lines')
                linesTypeNumber = 2;
            }
            else
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'"Type of Lines" is empty'));
               
             if(record.Route__c != null)
               routeid = record.Route__c;
               
            status_selected = new List<String>();
            status_selected.add('Approved as Succesful');
            status_selected.add('Partially Shipped');   
            new_filter_route_cabeceras = new Carrier_Line_Load_Point__c(); 
            new_filter_date_cabeceras = new Shipment__c();
            if(record.Planned_ETD__c != null)
                new_filter_date_cabeceras.ETD_from_Point_of_Load__c = record.Planned_ETD__c; 
            if(record.Route__c != null) 
            {
                new_filter_route_cabeceras.Country_of_Discharge__c = record.Route__r.Country_of_Load__c;
                new_filter_route_cabeceras.State_of_Discharge__c = record.Route__r.State_of_Load__c;
                new_filter_route_cabeceras.Port_Airport_of_Discharge__c = record.Route__r.Port_Airport_of_Load__c;
            }
            see_actual_import_export = true;
                
            orden_cabeceras = 'Import_Export_Quote__r.Name';
            orden_cabeceras_modo = 'asc';
            
            filtro_fecha = new Quote_Item_Line__c();
            filtro_fecha.Delivery_Date__c = system.today().addDays(90);   
    }
        
    public Boolean getShowLines()
    {
        return getShowShoppingCartLines()||getShowImportExportItemLines()||getShowSupplierQuoteLines()||getShowImportExportItemLines_update()||getShowShoppingCartLines_update()||getShowSupplierQuoteLines_update();
    }
    
    public Boolean getShowShoppingCartLines()
    {
        if(getLines()!=null && linesTypeNumber==1)return Lines.size()>0;
        return false;
    }
    
     public Boolean getShowShoppingCartLines_update()
    {
        if(getLines_update()!=null && linesTypeNumber==1)return Lines_update.size()>0;
        return false;
    }
  
   public Boolean getShowImportExportItemLines()
    {
        if(getLines()!=null && linesTypeNumber==2)return Lines.size()>0;
        return false;
    }
    
    public Boolean getShowImportExportItemLines_update()
    {
        if(getLines_update()!=null && linesTypeNumber==2)return Lines_update.size()>0;
        return false;
    }
    
    public Boolean getShowSupplierQuoteLines()
   {
    if(getLines()!=null && linesTypeNumber==3)
        return Lines.size()>0;return false;
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
   
   public Boolean getShowSupplierQuoteLines_update()
   {
    if(getLines_update()!=null && linesTypeNumber==3)
      return Lines_update.size()>0;return false;
   }
   
    public Boolean getShowConsolidated()
    {
        return notConsolidatedNumber!=0;
    }
    
     public void actualizar_import_export_supplier_order()
    {
      if(orden_cabeceras != 'numero_dias')
        List_import_export_supplier_order = null;
      else
        List_import_export_supplier_order.sort();
    }
    
    public void actualizar_import_export_supplier_order_put_null()
    {
      List_import_export_supplier_order = null;
    }
    
    public class Import_Export_Supplier_Order_s implements Comparable
    {
      public Customer_Quote__c import_export {get; set;}
      public boolean selected {get; set;}
      public integer numero_dias {get; set;}
      private NEU_Edit_Shipments_Program  parent;
      
      public Import_Export_Supplier_Order_s(Customer_Quote__c import_export, boolean selected, NEU_Edit_Shipments_Program parent)
      {
            this.import_export = import_export;
            this.selected = selected;
            this.parent = parent; 
      }
      
      public Integer getnumero_dias2()
      {
            if(parent.new_filter_date_cabeceras !=null && parent.new_filter_date_cabeceras.ETD_from_Point_of_Load__c != null && import_export != null && import_export.Last_Shipment__c != null && import_export.Last_Shipment__r.ETA_Point_of_Discharge__c != null)
            {
              Integer dias = import_export.Last_Shipment__r.ETA_Point_of_Discharge__c.daysBetween(parent.new_filter_date_cabeceras.ETD_from_Point_of_Load__c);
              numero_dias = dias;
              return dias;
            }
            return null;
      }
      
      public Integer compareTo(Object compareTo) 
      {
            Import_Export_Supplier_Order_s compareToEmp = (Import_Export_Supplier_Order_s)compareTo;
            
            if(parent.orden_cabeceras  == 'numero_dias')
            {
              if (numero_dias  == compareToEmp.numero_dias) return 0;
              if(numero_dias == null)return 1;
              if(parent.orden_cabeceras_modo == 'asc')
              {
                    if (numero_dias< compareToEmp.numero_dias) return 1;
              }
              else
              {
                    if (numero_dias > compareToEmp.numero_dias) return 1;
              }
            }
            return -1;  
      }
      
    }
    
    public List<Import_Export_Supplier_Order_s> getList_import_export_supplier_order()
    {
        if(List_import_export_supplier_order == null)
        {
          if(linesTypeNumber == 2)
          {
            List_import_export_supplier_order = new List<Import_Export_Supplier_Order_s>();

            List<Quote_Item_Line__c> query_import_export_real = null;
            
            string query_import_export = '';
            query_import_export +='select Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name, Import_Export_Quote__r.Quotation_Status__c, ';
            query_import_export +='Import_Export_Quote__r.Account_for__c, Import_Export_Quote__r.Account_for__r.Name,';
            query_import_export +='Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Supplier_Account__r.Name,';
            query_import_export +='Import_Export_Quote__r.Last_Shipment__c, Import_Export_Quote__r.Last_Shipment__r.Name, Import_Export_Quote__r.Last_Shipment__r.Shipment_Status__c, ';
            query_import_export +='Import_Export_Quote__r.Last_Shipment__r.Track_Option__c, Import_Export_Quote__r.Last_Shipment__r.Number__c, ';
            query_import_export +='Import_Export_Quote__r.Last_Shipment__r.Site_of_Discharge__c, Import_Export_Quote__r.Nature_Merchandise__c, Import_Export_Quote__r.Total_Items_Units__c, Import_Export_Quote__r.Track_Option__c, Import_Export_Quote__r.Reference_Number__c, Import_Export_Quote__r.Last_Shipment__r.Site_of_Discharge__r.Name,';
            query_import_export +='Import_Export_Quote__r.Last_Shipment__r.ETA_Point_of_Discharge__c,';
            query_import_export +='Import_Export_Quote__r.CreatedDate , Import_Export_Quote__r.Consignee__c, Import_Export_Quote__r.Consignee__r.Name, Import_Export_Quote__r.Site_of_Load__c, Import_Export_Quote__r.Site_of_Load__r.Name,';
            query_import_export +='Import_Export_Quote__r.Site_of_Discharge__c, Import_Export_Quote__r.Site_of_Discharge__r.Name from Quote_Item_Line__c ';
            query_import_export +=' where Name != null ';
            if(status_selected != null && status_selected.size() > 0)
            {
              if(status_selected.size() ==1)
              {
              	//Protect SOSL Injection
              	String status = status_selected[0];
                query_import_export +=' and Import_Export_Quote__r.Quotation_Status__c =: status';
              }
              else
              {
                query_import_export +=' and (';
                for(String st: status_selected)
                {
                  query_import_export +=' Import_Export_Quote__r.Quotation_Status__c =:st or ';
                }
                
                query_import_export = query_import_export.substring(0, query_import_export.length() -3);
                query_import_export +=') ';
              }
            }
            
            if(notAuthorizedNumber == true)
              query_import_export += ' and Import_Export_Quote__r.Authorized_Credit__c = true';
              
            if(new_filter_route_cabeceras != null)
            {
              if(new_filter_route_cabeceras.Country_of_Discharge__c != null)
              {
                query_import_export += ' and ((Import_Export_Quote__r.Last_Shipment__r.Country_of_Discharge__c = \''+ new_filter_route_cabeceras.Country_of_Discharge__c +'\' and Import_Export_Quote__r.Last_Shipment__c != null) or (Import_Export_Quote__r.Last_Shipment__c = null and Import_Export_Quote__r.Country_ofLoad__c = \''+ new_filter_route_cabeceras.Country_of_Discharge__c +'\'))';
              }
              if(new_filter_route_cabeceras.State_of_Discharge__c != null)
              {
                query_import_export += ' and ((Import_Export_Quote__r.Last_Shipment__r.State_of_Discharge__c = \''+ new_filter_route_cabeceras.State_of_Discharge__c +'\' and Import_Export_Quote__r.Last_Shipment__c != null) or (Import_Export_Quote__r.Last_Shipment__c = null and Import_Export_Quote__r.State_of_Load__c = \''+ new_filter_route_cabeceras.State_of_Discharge__c +'\'))';
              }
              if(new_filter_route_cabeceras.Port_Airport_of_Discharge__c != null)
              {
                query_import_export += ' and ((Import_Export_Quote__r.Last_Shipment__r.Site_of_Discharge__c = \''+ new_filter_route_cabeceras.Port_Airport_of_Discharge__c +'\' and Import_Export_Quote__r.Last_Shipment__c != null) or(Import_Export_Quote__r.Last_Shipment__c = null and Import_Export_Quote__r.Site_of_Load__c =\''+ new_filter_route_cabeceras.Port_Airport_of_Discharge__c +'\'))';
              }
            } 
            
            if(orden_cabeceras == 'numero_dias')
            	orden_cabeceras = 'import_export.CreatedDate';
            if(orden_cabeceras.contains('import_export.') == true)
              orden_cabeceras = orden_cabeceras.replace('import_export.','Import_Export_Quote__r.' );
              
            //Protect SOSL Injection
            query_import_export +=' order by '+ String.escapeSingleQuotes(orden_cabeceras+' '+orden_cabeceras_modo) +' nulls last';
            query_import_export_real = Database.query(query_import_export);
            
            string contenedor_import_export = '';
            contenedor_actual_import_export = '';
            string contenedor_import_export2 = '';
            
            List<Shipment_Consolidation_Data__c> query_Import_export_includes = [select Id, Name, Import_Export_Quote__c, Import_Export_Quote__r.Name, 
            Import_Export_Quote__r.Quotation_Status__c, Import_Export_Quote__r.Account_for__c, Import_Export_Quote__r.Account_for__r.Name,
            Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Supplier_Account__r.Name,
            Import_Export_Quote__r.Last_Shipment__c, Import_Export_Quote__r.Last_Shipment__r.Name, Import_Export_Quote__r.Last_Shipment__r.Shipment_Status__c,
            Import_Export_Quote__r.Last_Shipment__r.Track_Option__c, Import_Export_Quote__r.Last_Shipment__r.Number__c,
            Import_Export_Quote__r.Last_Shipment__r.Site_of_Discharge__c, Import_Export_Quote__r.Nature_Merchandise__c, Import_Export_Quote__r.Total_Items_Units__c, Import_Export_Quote__r.Track_Option__c, Import_Export_Quote__r.Reference_Number__c, Import_Export_Quote__r.Last_Shipment__r.Site_of_Discharge__r.Name,
            Import_Export_Quote__r.Last_Shipment__r.ETA_Point_of_Discharge__c, Import_Export_Quote__r.CreatedDate , Import_Export_Quote__r.Consignee__c,
            Import_Export_Quote__r.Consignee__r.Name, Import_Export_Quote__r.Site_of_Load__c, Import_Export_Quote__r.Site_of_Load__r.Name,
            Import_Export_Quote__r.Site_of_Discharge__c,
            Import_Export_Quote__r.Site_of_Discharge__r.Name from Shipment_Consolidation_Data__c where Shipments_Program__c =: record.Id];
            for(Shipment_Consolidation_Data__c scd : query_Import_export_includes)
            {
                if(see_actual_import_export == true)
                {
                    if(contenedor_import_export == '' || contenedor_import_export.contains(scd.Import_Export_Quote__c) == false)
                    {
                        List_import_export_supplier_order.add(new Import_Export_Supplier_Order_s(scd.Import_Export_Quote__r, true, this));
                        contenedor_actual_import_export += scd.Import_Export_Quote__c;
                    }
                    contenedor_import_export += scd.Import_Export_Quote__c;
                }
                else
                {
                    if(contenedor_import_export2 == '' || contenedor_import_export2.contains(scd.Import_Export_Quote__c) == false)
                    {
                        contenedor_actual_import_export += scd.Import_Export_Quote__c;
                    }
                    contenedor_import_export2 += scd.Import_Export_Quote__c;
                }
            }
            
            for(Quote_Item_Line__c cq : query_import_export_real)
            {
              if(contenedor_import_export == '' || contenedor_import_export.contains(cq.Import_Export_Quote__c) == false)
              {
                List_import_export_supplier_order.add(new Import_Export_Supplier_Order_s(cq.Import_Export_Quote__r, (contenedor_actual_import_export != null && contenedor_actual_import_export != '' && contenedor_actual_import_export.contains(cq.Import_Export_Quote__c) ? true : false), this));
                
              }  
              contenedor_import_export +=cq.Import_Export_Quote__c;
            }
          } 
          
          if(linesTypeNumber == 3)
          {
            
          }
          
        }
        return List_import_export_supplier_order;
    }
  
    public List<SelectOption> getcontainers()
    {
        List<Pallet_Container_Type__c> lista_contenedores = new List<Pallet_Container_Type__c>();
        lista_contenedores = [select Id, Name, Pallet_Type__c, Pallet_Type__r.Pallet_Volume_m3__c, Pallet_Type__r.Pallet_Weight_Kg__c, Container_Type__c, Container_Type__r.Cargo_Volume_m3__c, Container_Type__r.Cargo_Weight_Kg__c, Number_of_Pallets__c from Pallet_Container_Type__c order by Name];
        containers = new List<SelectOption>();
        ids_pallet_idscontenedores = '';
        containers.add(new SelectOption('0', '-- Select Pallet/Container Type --'));
      
        for(Pallet_Container_Type__c cp : lista_contenedores)
        {
            if(cp.Id == record.Pallet_Container_Type__c)
            {
              container_selected = cp.Id;
                  containers.add(new SelectOption(cp.Id, cp.Name));
                  ids_pallet_idscontenedores +=cp.id+'_'+ cp.Pallet_Type__c+'_'+cp.Pallet_Type__r.Pallet_Volume_m3__c+'_'+cp.Pallet_Type__r.Pallet_Weight_Kg__c+'_'+ cp.Container_Type__r.Cargo_Volume_m3__c+'_'+cp.Container_Type__r.Cargo_Weight_Kg__c+'_'+cp.Number_of_Pallets__c+'|';
              break;
            }         
        }
        
        for(Pallet_Container_Type__c cp : lista_contenedores)
        {
            if(cp.Id != record.Pallet_Container_Type__c)
            {
                  containers.add(new SelectOption(cp.Id, cp.Name));
                  ids_pallet_idscontenedores +=cp.id+'_'+ cp.Pallet_Type__c+'_'+cp.Pallet_Type__r.Pallet_Volume_m3__c+'_'+cp.Pallet_Type__r.Pallet_Weight_Kg__c+'_'+ cp.Container_Type__r.Cargo_Volume_m3__c+'_'+cp.Container_Type__r.Cargo_Weight_Kg__c+'_'+cp.Number_of_Pallets__c+'|';
            }         
        }
        
        valor_zero = 0;
        return containers; 
    }
    
    public String getFreight_Mode_id()
    {
        return Freight_Mode_id;
    }
    
    public void setFreight_Mode_id(String value)
    {
        if(value!=Freight_Mode_id)
        {
          Freight_Mode_id=value;
          Lines=null;
          Lines_update= null;
          routeid = null;
          accountid = null;
          accountList = null;
          accountName ='';
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
    
      public String getrouteid()
    {
        return routeid;
    }
    
    public void setrouteid(String value)
    {
        if(value!=routeid)
        {
          routeid=value;
          Lines=null;
          Lines_update=null;
          accountid = null;
          accountList = null;
          accountName ='';
        }
    }
    
    public Integer getLinesTypeNumber()
    {
        return linesTypeNumber;
    }
    
    public void setLinesTypeNumber(Integer value)
    {
        if(linesTypeNumber!=value)
        {
            linesTypeNumber=value;
            Lines=null;
            Lines_update=null;
            accountList=null;
            accountid=null;
            accountName ='';
            routeid=null;
            Freight_Mode_id = null;
        }
    }
    
    public boolean getnotAuthorizedNumber()
    {
        return notAuthorizedNumber;
    }
    
    public void setnotAuthorizedNumber(boolean value)
    {
        if(notAuthorizedNumber!=value)
        {
            notAuthorizedNumber=value;
            Lines=null;
            Lines_update=null;
        }
    }
    
       public Integer getNotConsolidatedNumber()
    {
        return notConsolidatedNumber;
    }
    
    public Quote_Item_Line__c getfiltro_fecha()
    {
      return filtro_fecha;
    }
    
    public String listado_import_supplier_quote_cabeceras = '';    
    public String listado_cuentas_import_supplier_quote_cabeceras = '';  
  
    public void cambio_de_fecha()
    {
      Lines=null;
      Lines_update=null;
      
      accountid = new Set<String>();
      listado_import_supplier_quote_cabeceras ='';
      listado_cuentas_import_supplier_quote_cabeceras = '';
      string contenedor_de_cuentas = '';
      if(List_import_export_supplier_order != null && List_import_export_supplier_order.size()>0)
      {
         for(Import_Export_Supplier_Order_s ieso :List_import_export_supplier_order)
         {
            if(ieso.selected  == true)
            {
              listado_import_supplier_quote_cabeceras += '\''+ieso.import_export.Id+'\''+',';
              listado_cuentas_import_supplier_quote_cabeceras += '\''+ieso.import_export.Account_for__c+'\''+',';
              if(contenedor_de_cuentas == '' || contenedor_de_cuentas.contains(ieso.import_export.Account_for__c) ==false)
                accountid.add(ieso.import_export.Account_for__c);
              contenedor_de_cuentas += ieso.import_export.Account_for__c;
            }
          }
       }  
    }
    
    public void setNotConsolidatedNumber(Integer value)
    {
        if(notConsolidatedNumber!=value)
        {
            notConsolidatedNumber=value;
            Lines=null;
            Lines_update=null;
        }
    }
    
       public Set<string> getaccountid()
    {
        return accountid;
    }
    
    public void setaccountid(Set<string> value)
    {
        if(value!=accountid)
        {
            accountid=value; 
            Lines=null;
            Lines_update=null;
            accountName ='';
            List<Account> accounts = [select Name from Account where Id IN: accountid];
            string comprobante = '';
            if(accounts.size()>0)
            {
                for (Account cuentas :accounts)
                {
                    if(comprobante.contains(cuentas.Name) == false)
                        accountName +=cuentas.Name+',';
                    comprobante +=cuentas.Name;
                }
            }   
            else
                accountName='';
            if(accountName != null)
                if(accountName.length()>0)
                    accountName = accountName.substring(0,accountName.length()-1);
        }
    }
    
    public List<SelectOption> getaccountList()
    {
        if(accountList==null)
        {
            accountList = new List<SelectOption>();
            string contenedor_cuentas = '';
            if(linesTypeNumber==1)
            {
                    List<Shopping_Cart_line__c> lineas_items = null;
                    if(accountTypeNumber==1)
                    {
                          lineas_items=[select Id,Name,Item_Name__r.Weight_Kgs__c,Item_Name__r.Master_Box_Volume_m3__c,Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Item_Name__c,Shopping_Cart__r.Authorized_Credit__c,Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Weight_Kgs__c,Consolidated__c,Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Consolidate_by_BOM__c,Item_Name__r.Name,Item_Name__r.Sourcing_Family__r.Name,Item_Name__r.Picking_Rule__c,Net_Price__c,Units__c,Amount__c,Shopping_Cart__r.Id,Shopping_Cart__r.Name,Item_List_Price__c,E_Commerce_Offer__c,Shopping_Cart__r.Customer__r.Developer_Record_Type__c,Shopping_Cart__r.Customer__r.Id,Shopping_Cart__r.Customer__r.Name,Supplier__r.Id,Supplier__r.Name,Supplier__r.Developer_Record_Type__c, Shopping_Cart__r.Delivery_Date__c from Shopping_Cart_line__c where Shopping_Cart__r.Status__c='Close'  order by Shopping_Cart__r.Name,Line_Number__c]; //Item_Name__r.Stock__c
                         if(lineas_items!=null)
                            for(Shopping_Cart_line__c l:lineas_items)
                            {
                                 if(contenedor_cuentas.contains(l.Shopping_Cart__r.Customer__c) == false)
                                 {
                                     accountList.add(new SelectOption(l.Shopping_Cart__r.Customer__c,l.Shopping_Cart__r.Customer__r.Name));
                                     contenedor_cuentas +=l.Shopping_Cart__r.Customer__c;
                                 }
                            }
                    
                    }
            }
            
            if(linesTypeNumber==2)
            {
                    List<Quote_Item_Line__c> lineas_items = null;
                    if(accountTypeNumber==1)
                    {
              
                        if(routeid != null && routeid != '')
                        {
                            if(Freight_Mode_id != null && Freight_Mode_id != '')
                                lineas_items=[select Id,Name,Delivery_Number__c,Delivery_Date__c , Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c,  Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Pickup_Cartage__c, Import_Export_Quote__r.Supply_Project_Name__c, Import_Export_Quote__r.Route__c, Import_Export_Quote__r.Route__r.Name,Item_Name__r.Weight_Kgs__c,Item_Name__c,Item_Name__r.Master_Box_Volume_m3__c,Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Price__c,Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Item_Supplier_Owner__r.Id,Item_Supplier_Owner__r.Name,Item_Supplier_Owner__r.Developer_Record_Type__c,Import_Export_Quote__r.Authorized_Credit__c,Total_Shipping_Weight_Kgs__c,Extension_Item_Name__c,Consolidated__c,Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Name,Item_Name__r.Sourcing_Family__r.Name,Item_Name__r.Picking_Rule__c,Units__c,Amount__c,Import_Export_Quote__r.Id,Import_Export_Quote__r.Name,Item_List_Price__c,Import_Export_Quote__r.Account_for__r.Id,Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Delivery_Date__c, Expense_Amount__c from Quote_Item_Line__c where (Import_Export_Quote__r.Quotation_Status__c ='Approved as Succesful' or Import_Export_Quote__r.Quotation_Status__c='Partially Shipped') and Import_Export_Quote__r.Account_for_Record_Type__c='Customer'  and Import_Export_Quote__r.Route__c =: routeid and Import_Export_Quote__r.Freight_Mode__c =: Freight_Mode_id order by Import_Export_Quote__r.Name,Name];//and Import_Export_Quote__r.Account_for__c IN: accountid //Item_Name__r.Stock__c
                            else
                                lineas_items=[select Id,Name,Delivery_Number__c,Delivery_Date__c , Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c,  Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Pickup_Cartage__c, Import_Export_Quote__r.Supply_Project_Name__c, Import_Export_Quote__r.Route__c, Import_Export_Quote__r.Route__r.Name,Item_Name__r.Weight_Kgs__c,Item_Name__c,Item_Name__r.Master_Box_Volume_m3__c,Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Price__c,Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Item_Supplier_Owner__r.Id,Item_Supplier_Owner__r.Name,Item_Supplier_Owner__r.Developer_Record_Type__c,Import_Export_Quote__r.Authorized_Credit__c,Total_Shipping_Weight_Kgs__c,Extension_Item_Name__c,Consolidated__c,Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Name,Item_Name__r.Sourcing_Family__r.Name,Item_Name__r.Picking_Rule__c,Units__c,Amount__c,Import_Export_Quote__r.Id,Import_Export_Quote__r.Name,Item_List_Price__c,Import_Export_Quote__r.Account_for__r.Id,Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Delivery_Date__c, Expense_Amount__c from Quote_Item_Line__c where (Import_Export_Quote__r.Quotation_Status__c ='Approved as Succesful' or Import_Export_Quote__r.Quotation_Status__c='Partially Shipped') and Import_Export_Quote__r.Account_for_Record_Type__c='Customer'  and Import_Export_Quote__r.Route__c =: routeid order by Import_Export_Quote__r.Name,Name];//and Import_Export_Quote__r.Account_for__c IN: accountid //Item_Name__r.Stock__c
                        }
                        else
                        {
                            if(Freight_Mode_id != null && Freight_Mode_id != '')
                                lineas_items=[select Id,Name,Delivery_Number__c,Delivery_Date__c , Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c,  Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Pickup_Cartage__c, Import_Export_Quote__r.Supply_Project_Name__c, Import_Export_Quote__r.Route__c, Import_Export_Quote__r.Route__r.Name,Item_Name__r.Weight_Kgs__c,Item_Name__c,Item_Name__r.Master_Box_Volume_m3__c,Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Price__c,Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Item_Supplier_Owner__r.Id,Item_Supplier_Owner__r.Name,Item_Supplier_Owner__r.Developer_Record_Type__c,Import_Export_Quote__r.Authorized_Credit__c,Total_Shipping_Weight_Kgs__c,Extension_Item_Name__c,Consolidated__c,Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Name,Item_Name__r.Sourcing_Family__r.Name,Item_Name__r.Picking_Rule__c,Units__c,Amount__c,Import_Export_Quote__r.Id,Import_Export_Quote__r.Name,Item_List_Price__c,Import_Export_Quote__r.Account_for__r.Id,Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Delivery_Date__c, Expense_Amount__c from Quote_Item_Line__c where (Import_Export_Quote__r.Quotation_Status__c ='Approved as Succesful' or Import_Export_Quote__r.Quotation_Status__c='Partially Shipped') and Import_Export_Quote__r.Account_for_Record_Type__c='Customer' and Import_Export_Quote__r.Freight_Mode__c =: Freight_Mode_id  order by Import_Export_Quote__r.Name,Name];//and Import_Export_Quote__r.Account_for__c IN: accountid //Item_Name__r.Stock__c
                            else
                                lineas_items=[select Id,Name,Delivery_Number__c,Delivery_Date__c , Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c,  Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Pickup_Cartage__c, Import_Export_Quote__r.Supply_Project_Name__c, Import_Export_Quote__r.Route__c, Import_Export_Quote__r.Route__r.Name,Item_Name__r.Weight_Kgs__c,Item_Name__c,Item_Name__r.Master_Box_Volume_m3__c,Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Price__c,Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Item_Supplier_Owner__r.Id,Item_Supplier_Owner__r.Name,Item_Supplier_Owner__r.Developer_Record_Type__c,Import_Export_Quote__r.Authorized_Credit__c,Total_Shipping_Weight_Kgs__c,Extension_Item_Name__c,Consolidated__c,Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Name,Item_Name__r.Sourcing_Family__r.Name,Item_Name__r.Picking_Rule__c,Units__c,Amount__c,Import_Export_Quote__r.Id,Import_Export_Quote__r.Name,Item_List_Price__c,Import_Export_Quote__r.Account_for__r.Id,Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Delivery_Date__c, Expense_Amount__c from Quote_Item_Line__c where (Import_Export_Quote__r.Quotation_Status__c ='Approved as Succesful' or Import_Export_Quote__r.Quotation_Status__c='Partially Shipped') and Import_Export_Quote__r.Account_for_Record_Type__c='Customer'  order by Import_Export_Quote__r.Name,Name];//and Import_Export_Quote__r.Account_for__c IN: accountid //Item_Name__r.Stock__c
                        }
                    }
                    
                    if(lineas_items!=null)
                        for(Quote_Item_Line__c l:lineas_items)
                        {
                            if(contenedor_cuentas.contains(l.Import_Export_Quote__r.Account_for__c) == false)
                            {
                                accountList.add(new SelectOption(l.Import_Export_Quote__r.Account_for__c,l.Import_Export_Quote__r.Account_for__r.Name));
                                contenedor_cuentas +=l.Import_Export_Quote__r.Account_for__c;
                            }
                        }
            }
            
            if(linesTypeNumber==3)
            {
                  List<Supplier_Quote_Line__c> lineas_items = null;
                  if(accountTypeNumber==1)
                  {
               
                        if(routeid != null && routeid != '')
                          lineas_items =[select Id,Name,Item__r.Master_Box_Volume_m3__c, Supplier_Quote__r.Supply_Project__r.Sales_Incoterm__c, Supplier_Quote__r.Delivery_Account__c, Supplier_Quote__r.Delivery_Zone__c, Supplier_Quote__r.Route__c,Supplier_Quote__r.Supply_Project__c,  Item__r.Master_Box_Gross_Weight_kg__c,Item__r.Units_x_Master_Box__c,Item__r.Weight_Kgs__c,Total_Weight_Kg__c,Net_Price__c,Net_Amount__c ,Total_Amount__c ,Item__r.Subfamily__c,Item__r.Sourcing_Family__c,Supplier_Quote__r.Supplier_Quote_Status__c,Consolidated__c,Item__r.Id,Item__r.RecordType.DeveloperName,Item__r.Name,Item__r.Sourcing_Family__r.Name,Item__r.Picking_Rule__c,Price__c,Quantity__c,Gross_Buy_Amount__c,Supplier_Quote__r.Id,Supplier_Quote__r.Name,Supplier_Quote__r.Customer__r.Id,Supplier_Quote__r.Customer__r.Name,Supplier_Quote__r.Supplier__r.Id,Supplier_Quote__r.Supplier__r.Name,Supplier_Quote__r.Supplier__r.Developer_Record_Type__c, Unit_Origin_Price__c , Unit_Destination_Price__c ,Packaging_Gross_Weight_kg__c , Supplier_Item_Weight_kg__c , Item_Units_x_Packaging__c , Packaging_Volume_m3__c , Delivery_Number__c, Delivery_Date__c, Expense_Amount__c from Supplier_Quote_Line__c where  Supplier_Quote__r.Supplier_Quote_Status__c='Approved' and Active__c =true and Supplier_Quote__r.Route__c =: routeid order by Supplier_Quote__r.Name, Name, Delivery_Number__c NULLS LAST];//Supplier_Quote__r.Customer__c IN: accountid and //Item__r.Stock__c
                        else
                          lineas_items =[select Id,Name,Item__r.Master_Box_Volume_m3__c, Supplier_Quote__r.Supply_Project__r.Sales_Incoterm__c, Supplier_Quote__r.Delivery_Account__c, Supplier_Quote__r.Delivery_Zone__c, Supplier_Quote__r.Route__c,Supplier_Quote__r.Supply_Project__c,  Item__r.Master_Box_Gross_Weight_kg__c,Item__r.Units_x_Master_Box__c,Item__r.Weight_Kgs__c,Total_Weight_Kg__c,Net_Price__c,Net_Amount__c ,Total_Amount__c ,Item__r.Subfamily__c,Item__r.Sourcing_Family__c,Supplier_Quote__r.Supplier_Quote_Status__c,Consolidated__c,Item__r.Id,Item__r.RecordType.DeveloperName,Item__r.Name,Item__r.Sourcing_Family__r.Name,Item__r.Picking_Rule__c,Price__c,Quantity__c,Gross_Buy_Amount__c,Supplier_Quote__r.Id,Supplier_Quote__r.Name,Supplier_Quote__r.Customer__r.Id,Supplier_Quote__r.Customer__r.Name,Supplier_Quote__r.Supplier__r.Id,Supplier_Quote__r.Supplier__r.Name,Supplier_Quote__r.Supplier__r.Developer_Record_Type__c, Unit_Origin_Price__c , Unit_Destination_Price__c ,Packaging_Gross_Weight_kg__c , Supplier_Item_Weight_kg__c , Item_Units_x_Packaging__c , Packaging_Volume_m3__c , Delivery_Number__c, Delivery_Date__c, Expense_Amount__c from Supplier_Quote_Line__c where  Supplier_Quote__r.Supplier_Quote_Status__c='Approved' and Active__c =true order by Supplier_Quote__r.Name, Name, Delivery_Number__c NULLS LAST];//Supplier_Quote__r.Customer__c IN: accountid and //Item__r.Stock__c
     
                        if(lineas_items !=null)
                            for(Supplier_Quote_Line__c l:lineas_items)
                            {
                                if(l.Supplier_Quote__r.Customer__c != null)
                                    if(contenedor_cuentas.contains(l.Supplier_Quote__r.Customer__c) == false)       
                                    {
                                         accountList.add(new SelectOption(l.Supplier_Quote__r.Customer__c,l.Supplier_Quote__r.Customer__r.Name));
                                         contenedor_cuentas +=l.Supplier_Quote__r.Customer__c;
                                    }
                            }
                  }
            }
        }
        return accountList;
    }
    
    public String getaccountName()
    {
        return accountName;
    }
    
    public class Line_s implements Comparable
    {
        public Quote_Item_Line__c quote_line {get; set;}
        public Shopping_Cart_Line__c shopping_line {get; set;}
        public Supplier_Quote_Line__c supplier_line {get; set;}
        public boolean selected {get; set;}
        public boolean selected2 {get; set;}
        public string extension {get; set;}
        public Integer units{get;set;}
        public Decimal factor{get;set;}
        public Boolean isOK{get;set;}
        public string IdPrincipal{get;set;}
        public string Input{get;set;}
        public Integer icon{get;set;}
        public String supply{get;set;}
        public Integer tosupply{get;set;}
        public Integer nounits{get;set;}
        public decimal total_peso_linea{get;set;}
        public decimal total_volumen_linea{get;set;}
        public decimal total_pallet_linea{get;set;}
        public boolean tiene_pallet{get;set;}
        public String relacion_con_pallet {get; set;}
        public decimal totalcajas{get;set;} 
        public string unidades_iniciales{get;set;} 
        public decimal precio_unidad{get;set;} 
        public boolean check_full{get;set;} 
        public string campo_compare{get;set;}
        public string orden_de_comparacion{get;set;}
        public decimal Units_x_Master_Box{get;set;}
        public decimal peso_item_sin_caja{get;set;}
        public decimal peso_caja_items{get;set;}
        public decimal volumen_caja_items{get;set;}
  
  
        public Shipment_Line__c shipment_line {get; set;}
        public Integer getintegersupply()
        {
            try{
                return Integer.valueOf(supply);
            }
            catch(Exception e){}
            return 0;
        }
        
        public Integer getFinalUnits()
        {
            if(supplier_line!=null)
            {
                if(supplier_line.Quantity__c!=null)
                    return Integer.valueOf(supplier_line.Quantity__c);
            }
            else if(shopping_line!=null)
            {
                if(shopping_line.Units__c!=null)
                    return Integer.valueOf(shopping_line.Units__c);
            }
            else if(quote_line!=null)
            {
                if(quote_line.Units__c!=null)
                    return Integer.valueOf(quote_line.Units__c);
            }
            return 0;
        }
        
        public Integer getFinalStock()
        {
            if(supplier_line!=null)
            {
                if(supplier_line.Item__r!=null)
                	return 0;
            }
            else if(shopping_line!=null)
            {
                if(shopping_line.Item_Name__r!=null)
                	return 0;
            }
            else if(quote_line!=null)
            {
                if(quote_line.Item_Name__r!=null)
                	return 0;
            }
            return 0;
        }
        
        public String getId()
        {
           if(shipment_line != null)
              return shipment_line.Id;
            if(supplier_line!=null)
                return supplier_line.Id;
            if(shopping_line!=null)
                return shopping_line.Id;
            if(quote_line!=null)
                return quote_line.Id;
          
            return null;
        }
        
        public String getHeaderId()
        {
            if(supplier_line!=null)
                return supplier_line.Supplier_Quote__r.Id;
            if(shopping_line!=null)
                return shopping_line.Shopping_Cart__r.Id;
            if(quote_line!=null)
                return quote_line.Import_Export_Quote__r.Id;
            return null;
        }

        public String getItemId()
        {
            if(supplier_line!=null)
            {
                if(supplier_line.Item__r!=null)
                    return supplier_line.Item__r.Id;
            }
            else if(shopping_line!=null)
            {
                if(shopping_line.Item_Name__r!=null)
                    return shopping_line.Item_Name__r.Id;
            }
            else if(quote_line!=null)
            {
                if(quote_line.Item_Name__r!=null)
                    return quote_line.Item_Name__r.Id;
            }
            return null;
        }
        
        public Integer getItemType()
        {
            String DeveloperName=getItemTypeString();
            if(DeveloperName=='SKU_Product')
                return 0;
            else if(DeveloperName=='Service')
                return 1;
            else if(DeveloperName=='Sourcing_Product')
                return 2;
            return 0;
        }
        
        private String getItemTypeString()
        {
            if(supplier_line!=null)
            {
                if(supplier_line.Item__r!=null)
                    return supplier_line.Item__r.RecordType.DeveloperName;
            }
            else if(shopping_line!=null)
            {
                if(shopping_line.Item_Name__r!=null)
                    return shopping_line.Item_Name__r.RecordType.DeveloperName;
            }
            else if(quote_line!=null)
            {
                if(quote_line.Item_Name__r!=null)
                    return quote_line.Item_Name__r.RecordType.DeveloperName;
            }
            return null;
        }
        
        public String getSupplierId()
        {
            if(supplier_line!=null)
            {
                if(supplier_line.Supplier_Quote__r.Supplier__c!=null)
                    if(supplier_line.Supplier_Quote__r.Supplier__r.Developer_Record_Type__c=='Supplier')
                        return supplier_line.Supplier_Quote__r.Supplier__r.Id;
            }
            if(shopping_line!=null)
            {
                if(shopping_line.Supplier__c!=null)
                    if(shopping_line.Supplier__r.Developer_Record_Type__c=='Supplier')
                        return shopping_line.Supplier__r.Id;
            }
            else if(quote_line!=null)
            {
                if(quote_line.Item_Supplier_Owner__c!=null)
                    if(quote_line.Item_Supplier_Owner__r.Developer_Record_Type__c=='Supplier')
                        return quote_line.Item_Supplier_Owner__r.Id;
            }
            return null;
        }
        
        public String getItemName()
        {
            if(supplier_line!=null)
            {
                if(supplier_line.Item__r!=null)
                    return supplier_line.Item__r.Name;
            }
            else if(shopping_line!=null)
            {
                if(shopping_line.Item_Name__r!=null)
                    return shopping_line.Item_Name__r.Name;
            }
            else if(quote_line!=null)
            {
                if(quote_line.Item_Name__r!=null)
                    return quote_line.Item_Name__r.Name;
            }
            return null;
        }
        
        public String getFamilyName()
        {
            if(supplier_line!=null)
            {
                if(supplier_line.Item__r!=null)
                    return supplier_line.Item__r.Sourcing_Family__r.Name;
            }
            else if(shopping_line!=null)
            {
                if(shopping_line.Item_Name__r!=null)
                    return shopping_line.Item_Name__r.Sourcing_Family__r.Name;
            }
            else if(quote_line!=null)
            {
                if(quote_line.Item_Name__r!=null)
                    return quote_line.Item_Name__r.Sourcing_Family__r.Name;
            }
            return null;
        }
         
        public Line_s(Quote_Item_Line__c quote_line,Shopping_Cart_Line__c shopping_line,Supplier_Quote_Line__c supplier_line,boolean selected, string extension,Integer units, string idPrincipal, decimal total_peso_linea, decimal total_volumen_linea, decimal total_pallet_linea, boolean tiene_pallet, String relacion_con_pallet, decimal totalcajas, decimal unidades_iniciales, decimal precio_unidad, boolean check_full)
        {
            this.quote_line=quote_line;
            this.shopping_line=shopping_line;
            this.supplier_line=supplier_line;
            this.selected=selected;
            this.extension=extension;
            this.units=units;
            this.isOK=false;
            this.nounits=0;
            this.idPrincipal=idPrincipal;
            this.icon=0;
            this.selected2=false;
            this.factor=0;
            this.input=null;
            this.supply='';
            this.tosupply=0;
            this.total_peso_linea=total_peso_linea;
            this.total_volumen_linea=total_volumen_linea;
            this.total_pallet_linea=total_pallet_linea;
            this.tiene_pallet = tiene_pallet;
            this.relacion_con_pallet = relacion_con_pallet; 
            this.totalcajas = totalcajas;
            this.unidades_iniciales = unidades_iniciales.format(); 
            this.precio_unidad = precio_unidad;
            this.check_full = check_full;
        }
        
         public Integer compareTo(Object compareTo) {
            
              system.debug('ship_cons_comparar'+compareTo);
              Line_s compareToEmp = (Line_s)compareTo;
              if(campo_compare  == 'total_pallet_linea')
              {
                if (total_pallet_linea  == compareToEmp.total_pallet_linea) return 0;if(orden_de_comparacion == 'asc'){if (total_pallet_linea > compareToEmp.total_pallet_linea) return 1;}else if (total_pallet_linea < compareToEmp.total_pallet_linea) return 1;
              }
              if(campo_compare  == 'total_volumen_linea')
              {
                if (total_volumen_linea  == compareToEmp.total_volumen_linea) return 0;if(orden_de_comparacion == 'asc'){if (total_volumen_linea > compareToEmp.total_volumen_linea) return 1;}else if (total_volumen_linea < compareToEmp.total_volumen_linea) return 1;
              
              }
              if(campo_compare  == 'total_peso_linea')
              {
                if (total_peso_linea  == compareToEmp.total_peso_linea) return 0;if(orden_de_comparacion == 'asc'){if (total_peso_linea > compareToEmp.total_peso_linea) return 1;}else if (total_peso_linea < compareToEmp.total_peso_linea) return 1;
            
              }
              if(campo_compare  == 'extension')
              {
                if (extension  == compareToEmp.extension) return 0;if(orden_de_comparacion == 'asc'){if (extension > compareToEmp.extension) return 1;}else if (extension < compareToEmp.extension) return 1;
            
              }
              if(campo_compare  == 'totalcajas')
              {
                if (totalcajas  == compareToEmp.totalcajas) return 0;if(orden_de_comparacion == 'asc'){if (totalcajas > compareToEmp.totalcajas) return 1;}else if (totalcajas < compareToEmp.totalcajas) return 1;
              
              }
              if(campo_compare  == 'supplier_line.Delivery_Date__c')
              {
                if (supplier_line.Delivery_Date__c  == compareToEmp.supplier_line.Delivery_Date__c) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Delivery_Date__c > compareToEmp.supplier_line.Delivery_Date__c) return 1;}else if (supplier_line.Delivery_Date__c < compareToEmp.supplier_line.Delivery_Date__c) return 1;
            
              }
              if(campo_compare  == 'supplier_line.Delivery_Number__c')
              {
                if (supplier_line.Delivery_Number__c  == compareToEmp.supplier_line.Delivery_Number__c) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Delivery_Number__c > compareToEmp.supplier_line.Delivery_Number__c) return 1;}else if (supplier_line.Delivery_Number__c < compareToEmp.supplier_line.Delivery_Number__c) return 1;
              
              }
              if(campo_compare  == 'supplier_line.Name')
              {
                if (supplier_line.Name  == compareToEmp.supplier_line.Name) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Name > compareToEmp.supplier_line.Name) return 1;}else if (supplier_line.Name < compareToEmp.supplier_line.Name) return 1;
              
              }
              if(campo_compare  == 'supplier_line.Supplier_Quote__r.Name')
              {
                if (supplier_line.Supplier_Quote__r.Name  == compareToEmp.supplier_line.Supplier_Quote__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Supplier_Quote__r.Name > compareToEmp.supplier_line.Supplier_Quote__r.Name) return 1;}else if (supplier_line.Supplier_Quote__r.Name < compareToEmp.supplier_line.Supplier_Quote__r.Name) return 1;
              
              }
              if(campo_compare  == 'supplier_line.Quantity__c')
              {
                if (supplier_line.Quantity__c  == compareToEmp.supplier_line.Quantity__c) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Quantity__c > compareToEmp.supplier_line.Quantity__c) return 1;}else if (supplier_line.Quantity__c < compareToEmp.supplier_line.Quantity__c) return 1;
                
              }
              if(campo_compare  == 'supplier_line.Item__r.Name')
              {
                if (supplier_line.Item__r.Name  == compareToEmp.supplier_line.Item__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Item__r.Name > compareToEmp.supplier_line.Item__r.Name) return 1;}else if (supplier_line.Item__r.Name < compareToEmp.supplier_line.Item__r.Name) return 1;
            
              }
              if(campo_compare  == 'supplier_line.Supplier_Quote__r.Supplier__r.Name')
              {
                if (supplier_line.Supplier_Quote__r.Supplier__r.Name  == compareToEmp.supplier_line.Supplier_Quote__r.Supplier__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Supplier_Quote__r.Supplier__r.Name > compareToEmp.supplier_line.Supplier_Quote__r.Supplier__r.Name) return 1;}else if (supplier_line.Supplier_Quote__r.Supplier__r.Name < compareToEmp.supplier_line.Supplier_Quote__r.Supplier__r.Name) return 1;
              }
              if(campo_compare  == 'supplier_line.Supplier_Quote__r.Customer__r.Name')
              {
                if (supplier_line.Supplier_Quote__r.Customer__r.Name  == compareToEmp.supplier_line.Supplier_Quote__r.Customer__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Supplier_Quote__r.Customer__r.Name > compareToEmp.supplier_line.Supplier_Quote__r.Customer__r.Name) return 1;}else if (supplier_line.Supplier_Quote__r.Customer__r.Name < compareToEmp.supplier_line.Supplier_Quote__r.Customer__r.Name) return 1;
                
              }
              if(campo_compare  == 'supplier_line.Total_Amount__c')
              {
                if (supplier_line.Total_Amount__c  == compareToEmp.supplier_line.Total_Amount__c) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Total_Amount__c > compareToEmp.supplier_line.Total_Amount__c) return 1;}else if (supplier_line.Total_Amount__c < compareToEmp.supplier_line.Total_Amount__c) return 1;
            
              }
              if(campo_compare  == 'supplier_line.Net_Amount__c')
              {
                if (supplier_line.Net_Amount__c  == compareToEmp.supplier_line.Net_Amount__c) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Net_Amount__c > compareToEmp.supplier_line.Net_Amount__c) return 1;}else if (supplier_line.Net_Amount__c < compareToEmp.supplier_line.Net_Amount__c) return 1;
              
              }
              if(campo_compare  == 'supplier_line.Supplier_Quote__r.Supply_Project__r.Name')
              {
                if (supplier_line.Supplier_Quote__r.Supply_Project__r.Name  == compareToEmp.supplier_line.Supplier_Quote__r.Supply_Project__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (supplier_line.Supplier_Quote__r.Supply_Project__r.Name > compareToEmp.supplier_line.Supplier_Quote__r.Supply_Project__r.Name) return 1;}else if (supplier_line.Supplier_Quote__r.Supply_Project__r.Name < compareToEmp.supplier_line.Supplier_Quote__r.Supply_Project__r.Name) return 1;
              
              }
              if(campo_compare  == 'shopping_line.Item_Name__r.Name')
              {
                if (shopping_line.Item_Name__r.Name  == compareToEmp.shopping_line.Item_Name__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (shopping_line.Item_Name__r.Name > compareToEmp.shopping_line.Item_Name__r.Name) return 1;}else if (shopping_line.Item_Name__r.Name < compareToEmp.shopping_line.Item_Name__r.Name) return 1;
                
              }
              if(campo_compare  == 'shopping_line.Supplier__r.Name')
              {
                if (shopping_line.Supplier__r.Name  == compareToEmp.shopping_line.Supplier__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (shopping_line.Supplier__r.Name > compareToEmp.shopping_line.Supplier__r.Name) return 1;}else if (shopping_line.Supplier__r.Name < compareToEmp.shopping_line.Supplier__r.Name) return 1;
                
              }
              if(campo_compare  == 'shopping_line.Shopping_Cart__r.Customer__r.Name')
              {
                if (shopping_line.Shopping_Cart__r.Customer__r.Name  == compareToEmp.shopping_line.Shopping_Cart__r.Customer__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (shopping_line.Shopping_Cart__r.Customer__r.Name > compareToEmp.shopping_line.Shopping_Cart__r.Customer__r.Name) return 1;}else if (shopping_line.Shopping_Cart__r.Customer__r.Name < compareToEmp.shopping_line.Shopping_Cart__r.Customer__r.Name) return 1;
                
              }
              if(campo_compare  == 'shopping_line.Shopping_Cart__r.Delivery_Date__c')
              {
                if (shopping_line.Shopping_Cart__r.Delivery_Date__c  == compareToEmp.shopping_line.Shopping_Cart__r.Delivery_Date__c) return 0;if(orden_de_comparacion == 'asc'){if (shopping_line.Shopping_Cart__r.Delivery_Date__c > compareToEmp.shopping_line.Shopping_Cart__r.Delivery_Date__c) return 1;}else if (shopping_line.Shopping_Cart__r.Delivery_Date__c < compareToEmp.shopping_line.Shopping_Cart__r.Delivery_Date__c) return 1;
                
              }
              if(campo_compare  == 'shopping_line.Name')
              {
                if (shopping_line.Name  == compareToEmp.shopping_line.Name) return 0;if(orden_de_comparacion == 'asc'){if (shopping_line.Name > compareToEmp.shopping_line.Name) return 1;}else if (shopping_line.Name < compareToEmp.shopping_line.Name) return 1;
                
              }
              if(campo_compare  == 'shopping_line.Shopping_Cart__r.Name')
              {
                if (shopping_line.Shopping_Cart__r.Name == compareToEmp.shopping_line.Shopping_Cart__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (shopping_line.Shopping_Cart__r.Name > compareToEmp.shopping_line.Shopping_Cart__r.Name) return 1;}else if (shopping_line.Shopping_Cart__r.Name < compareToEmp.shopping_line.Shopping_Cart__r.Name) return 1;
                
              }
              if(campo_compare  == 'shopping_line.Units__c')
              {
                if (shopping_line.Units__c  == compareToEmp.shopping_line.Units__c) return 0;if(orden_de_comparacion == 'asc'){if (shopping_line.Units__c > compareToEmp.shopping_line.Units__c) return 1;}else if (shopping_line.Units__c < compareToEmp.shopping_line.Units__c) return 1;
                
              }
              if(campo_compare  == 'shopping_line.Net_Price__c')
              {
                if (shopping_line.Net_Price__c  == compareToEmp.shopping_line.Net_Price__c) return 0;if(orden_de_comparacion == 'asc'){if (shopping_line.Net_Price__c > compareToEmp.shopping_line.Net_Price__c) return 1;}else if (shopping_line.Net_Price__c < compareToEmp.shopping_line.Net_Price__c) return 1;
            
              }
              if(campo_compare  == 'shopping_line.Amount__c')
              {
                if (shopping_line.Amount__c  == compareToEmp.shopping_line.Amount__c) return 0;if(orden_de_comparacion == 'asc'){if (shopping_line.Amount__c > compareToEmp.shopping_line.Amount__c) return 1;}else if (shopping_line.Amount__c < compareToEmp.shopping_line.Amount__c) return 1;
              
              }
              if(campo_compare  == 'quote_line.Item_Name__r.Name')
              {
                if (quote_line.Item_Name__r.Name  == compareToEmp.quote_line.Item_Name__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Item_Name__r.Name > compareToEmp.quote_line.Item_Name__r.Name) return 1;}else if (quote_line.Item_Name__r.Name < compareToEmp.quote_line.Item_Name__r.Name) return 1;
              }
              if(campo_compare  == 'quote_line.Item_Supplier_Owner__r.Name')
              {
                if (quote_line.Item_Supplier_Owner__r.Name  == compareToEmp.quote_line.Item_Supplier_Owner__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Item_Supplier_Owner__r.Name > compareToEmp.quote_line.Item_Supplier_Owner__r.Name) return 1;}else if (quote_line.Item_Supplier_Owner__r.Name < compareToEmp.quote_line.Item_Supplier_Owner__r.Name) return 1;
                
              }
              if(campo_compare  == 'quote_line.ETD__c')
              {
                if (quote_line.ETD__c  == compareToEmp.quote_line.ETD__c) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.ETD__c > compareToEmp.quote_line.ETD__c) return 1;}else if (quote_line.ETD__c < compareToEmp.quote_line.ETD__c) return 1;
            
              }
              if(campo_compare  == 'quote_line.Supplier_Quote_Line__r.Delivery_Date__c')
              {
                if (quote_line.Supplier_Quote_Line__r.Delivery_Date__c  == compareToEmp.quote_line.Supplier_Quote_Line__r.Delivery_Date__c) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Supplier_Quote_Line__r.Delivery_Date__c > compareToEmp.quote_line.Supplier_Quote_Line__r.Delivery_Date__c) return 1;}else if (quote_line.Supplier_Quote_Line__r.Delivery_Date__c < compareToEmp.quote_line.Supplier_Quote_Line__r.Delivery_Date__c) return 1;
            
              }
              if(campo_compare  == 'quote_line.Import_Export_Quote__r.Account_for__r.Name')
              {
                if (quote_line.Import_Export_Quote__r.Account_for__r.Name  == compareToEmp.quote_line.Import_Export_Quote__r.Account_for__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Import_Export_Quote__r.Account_for__r.Name > compareToEmp.quote_line.Import_Export_Quote__r.Account_for__r.Name) return 1;}else if (quote_line.Import_Export_Quote__r.Account_for__r.Name < compareToEmp.quote_line.Import_Export_Quote__r.Account_for__r.Name) return 1;
                
              }
              if(campo_compare  == 'quote_line.Delivery_Date__c')
              {
                if (quote_line.Delivery_Date__c  == compareToEmp.quote_line.Delivery_Date__c) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Delivery_Date__c > compareToEmp.quote_line.Delivery_Date__c) return 1;}else if (quote_line.Delivery_Date__c < compareToEmp.quote_line.Delivery_Date__c) return 1;
                
              }
              if(campo_compare  == 'quote_line.Delivery_Number__c')
              {
                if (quote_line.Delivery_Number__c  == compareToEmp.quote_line.Delivery_Number__c) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Delivery_Number__c > compareToEmp.quote_line.Delivery_Number__c) return 1;}else if (quote_line.Delivery_Number__c < compareToEmp.quote_line.Delivery_Number__c) return 1;
              
              }
              if(campo_compare  == 'quote_line.Import_Export_Quote__r.Supplier_Account__c')
              {
                if (quote_line.Import_Export_Quote__r.Supplier_Account__c  == compareToEmp.quote_line.Import_Export_Quote__r.Supplier_Account__c) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Import_Export_Quote__r.Supplier_Account__c > compareToEmp.quote_line.Import_Export_Quote__r.Supplier_Account__c) return 1;}else if (quote_line.Import_Export_Quote__r.Supplier_Account__c < compareToEmp.quote_line.Import_Export_Quote__r.Supplier_Account__c) return 1;
              
              }
              if(campo_compare  == 'shipment_line.Shipment__r.Name')
              {
                if (shipment_line.Shipment__r.Name  == compareToEmp.shipment_line.Shipment__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (shipment_line.Shipment__r.Name > compareToEmp.shipment_line.Shipment__r.Name) return 1;}else if (shipment_line.Shipment__r.Name < compareToEmp.shipment_line.Shipment__r.Name) return 1;
              
              }
              if(campo_compare  == 'shipment_line.Name')
              {
                if (shipment_line.Name  == compareToEmp.shipment_line.Name) return 0;if(orden_de_comparacion == 'asc'){if (shipment_line.Name > compareToEmp.shipment_line.Name) return 1;}else if (shipment_line.Name < compareToEmp.shipment_line.Name) return 1;
              
              }
              if(campo_compare  == 'shipment_line.Unit_Origin_Sell_Price__c')
              {
                if (shipment_line.Unit_Origin_Sell_Price__c  == compareToEmp.shipment_line.Unit_Origin_Sell_Price__c) return 0;if(orden_de_comparacion == 'asc'){if (shipment_line.Unit_Origin_Sell_Price__c > compareToEmp.shipment_line.Unit_Origin_Sell_Price__c) return 1;}else if (shipment_line.Unit_Origin_Sell_Price__c < compareToEmp.shipment_line.Unit_Origin_Sell_Price__c) return 1;
              
              }
              /*if(campo_compare  == 'shipment_line.Shipment__r.Supply_Project__r.Name')
              {
                if (shipment_line.Shipment__r.Supply_Project__r.Name  == compareToEmp.shipment_line.Shipment__r.Supply_Project__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (shipment_line.Shipment__r.Supply_Project__r.Name > compareToEmp.shipment_line.Shipment__r.Supply_Project__r.Name) return 1;}else if (shipment_line.Shipment__r.Supply_Project__r.Name < compareToEmp.shipment_line.Shipment__r.Supply_Project__r.Name) return 1;
              
              }*/
              if(campo_compare  == 'shipment_line.Sell_Origin_Amount__c')
              {
                if (shipment_line.Sell_Origin_Amount__c  == compareToEmp.shipment_line.Sell_Origin_Amount__c) return 0;if(orden_de_comparacion == 'asc'){if (shipment_line.Sell_Origin_Amount__c > compareToEmp.shipment_line.Sell_Origin_Amount__c) return 1;}else if (shipment_line.Sell_Origin_Amount__c < compareToEmp.shipment_line.Sell_Origin_Amount__c) return 1;
              
              }
              if(campo_compare  == 'quote_line.Name')
              {
                if (quote_line.Name  == compareToEmp.quote_line.Name) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Name > compareToEmp.quote_line.Name) return 1;}else if (quote_line.Name < compareToEmp.quote_line.Name) return 1;
                
              }
              if(campo_compare  == 'quote_line.Import_Export_Quote__r.Name')
              {
                if (quote_line.Import_Export_Quote__r.Name == compareToEmp.quote_line.Import_Export_Quote__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Import_Export_Quote__r.Name > compareToEmp.quote_line.Import_Export_Quote__r.Name) return 1;}else if (quote_line.Import_Export_Quote__r.Name < compareToEmp.quote_line.Import_Export_Quote__r.Name) return 1;
              }
              if(campo_compare  == 'quote_line.Units__c')
              {
                if (quote_line.Units__c  == compareToEmp.quote_line.Units__c) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Units__c > compareToEmp.quote_line.Units__c) return 1;}else if (quote_line.Units__c < compareToEmp.quote_line.Units__c) return 1;
              }
              if(campo_compare  == 'quote_line.Price__c')
              {
                if (quote_line.Price__c  == compareToEmp.quote_line.Price__c) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Price__c > compareToEmp.quote_line.Price__c) return 1;}else if (quote_line.Price__c < compareToEmp.quote_line.Price__c) return 1;
            
              }
              if(campo_compare  == 'quote_line.Amount__c')
              {
                if (quote_line.Amount__c  == compareToEmp.quote_line.Amount__c) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Amount__c > compareToEmp.quote_line.Amount__c) return 1;}else if (quote_line.Amount__c < compareToEmp.quote_line.Amount__c) return 1;
              }
              
              if(campo_compare  == 'quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name')
              {
                if (quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name  == compareToEmp.quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name) return 0;if(orden_de_comparacion == 'asc'){if (quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name > compareToEmp.quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name) return 1;}else if (quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name < compareToEmp.quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name) return 1;
              }
              
              return -1;
      }
    }
    
    
    public List<Line_s> getLines()
    {
        
        if(linesTypeNumber==1)
        {
            if(Lines==null)
            {
                Lines=new List<Line_s>();
                List<Shopping_Cart_line__c> lineas_items = null;
                
                string relaciones = '';
                
                String lista_account_id = '';
                if(accountid != null)
                if(accountid.size()>0)
                for(String s : accountid)
                {
                    lista_account_id += '\''+s+'\''+',';
                }
                
                String lista_route_id = '';
                
                List<Item_Pallet_Type__c> items_pallet_type = new List<Item_Pallet_Type__c>();
                items_pallet_type = [select Id,Name, Item_Name__c, Packages_Pallet__c, Pallet_Type__c from Item_Pallet_Type__c];
                String consulta_customer_order = '';
                consulta_customer_order +='select Id,Name,Item_Name__r.Weight_Kgs__c,Item_Name__r.Master_Box_Volume_m3__c,Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Item_Name__c,';
                consulta_customer_order +='Shopping_Cart__r.Authorized_Credit__c,Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Weight_Kgs__c,Consolidated__c,Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Consolidate_by_BOM__c,Item_Name__r.Name,Item_Name__r.Sourcing_Family__r.Name,';
                consulta_customer_order +='Item_Name__r.Picking_Rule__c,Net_Price__c,Units__c,Amount__c,Shopping_Cart__r.Id,Shopping_Cart__r.Name,Item_List_Price__c,E_Commerce_Offer__c,Shopping_Cart__r.Customer__r.Developer_Record_Type__c,';
                consulta_customer_order +='Shopping_Cart__r.Customer__r.Id'+NEU_CurrencyUtils.CurrencyIsoCode('Shopping_Cart__r.Customer__r')+',Shopping_Cart__r.Customer__r.Name,Supplier__r.Id,Supplier__r.Name,Supplier__r.Developer_Record_Type__c, Shopping_Cart__r.Delivery_Date__c from Shopping_Cart_line__c';
                consulta_customer_order +=' where Shopping_Cart__r.Status__c = \'Close\''; //Item_Name__r.Stock__c
                //if(routeid != null)
               // if(routeid.size()>0) -- falta
               //   consulta_import_export +=' and Import_Export_Quote__r.Route__c IN ('+lista_route_id.subString(0,lista_route_id.length()-1)+')'; 
                if(accountid != null)
                {
                    if(accountid.size()>0)
                    {
                        if(accountTypeNumber==2) consulta_customer_order +=' and Supplier__c IN :accountid';
                        else
                            consulta_customer_order +=' and Shopping_Cart__r.Customer__c IN :accountid';
                    }
                    else consulta_customer_order +=' and Supplier__c = null and Shopping_Cart__r.Customer__c = null';
                    
                }
                else
                    consulta_customer_order +=' and Supplier__c = null and Shopping_Cart__r.Customer__c = null';    
                if(notAuthorizedNumber==true)
                    consulta_customer_order +=' and Shopping_Cart__r.Authorized_Credit__c = true';
                if(notConsolidatedNumber==0)    
                    consulta_customer_order +=' and Consolidated__c = false';
                    
                consulta_customer_order +='  order by Shopping_Cart__r.Name,Line_Number__c';
                
                List<sObject> query_customer_order = Database.query(consulta_customer_order);
                lineas_items = query_customer_order;
                
                if(lineas_items!=null)
                    for(Shopping_Cart_line__c l:lineas_items)
                    {
                        for(Item_Pallet_Type__c ip: items_pallet_type)
                        {
                            if(ip.Item_Name__c == l.Item_Name__c)
                            {
                                relaciones = ip.Pallet_Type__c+'_'+ip.Packages_Pallet__c+'|';
                            }
                        
                        }
                        
                        Line_s thisLine=new Line_s(null,l,null,false,'',0,l.Id,
                        (l.Item_Name__r.Units_x_Master_Box__c != null && l.Item_Name__r.Units_x_Master_Box__c !=0 &&  l.Item_Name__r.Master_Box_Gross_Weight_kg__c != null && l.Item_Name__r.Master_Box_Gross_Weight_kg__c !=0 ? l.Item_Name__r.Master_Box_Gross_Weight_kg__c*((l.Units__c/l.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP)):(l.Item_Name__r.Weight_Kgs__c >0 ? l.Item_Name__r.Weight_Kgs__c*l.Units__c:0)),//peso mirar las units
                        (l.Item_Name__r.Master_Box_Volume_m3__c != null && l.Item_Name__r.Master_Box_Volume_m3__c != 0 && l.Item_Name__r.Units_x_Master_Box__c != null && l.Item_Name__r.Units_x_Master_Box__c != 0  ? l.Item_Name__r.Master_Box_Volume_m3__c*((l.Units__c/l.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP)): 0),//volumen
                        0,//pallet
                        false,relaciones,0,(l.Units__c > 0 ? l.Units__c : 0),(l.Net_Price__c > 0 ? l.Net_Price__c : 0),false);
                        
                        Lines.add(thisLine);
                        
                        if(l.Item_Name__r.Consolidate_by_BOM__c)
                        {
                            List<BOM_Relation__c> inputs=[select Id from BOM_Relation__c where Output_Item__c=:l.Item_Name__r.Id];
                            if(inputs.size()>0)
                                thisLine.icon=2;
                        }
                    }
                    
            }
        }
        
        if(linesTypeNumber==2)
        {
            if(Lines==null)
            {
                string relaciones = '';
              
                List<Item_Pallet_Type__c> items_pallet_type = new List<Item_Pallet_Type__c>();
                items_pallet_type = [select Id,Name, Item_Name__c, Packages_Pallet__c, Pallet_Type__c from Item_Pallet_Type__c];
                
                String lista_account_id = '';
                if(accountid != null)
                if(accountid.size()>0)
                for(String s : accountid)
                {
                    lista_account_id += '\''+s+'\''+',';
                }
                string listado_ids_ie_line = '';
                if(contenedor_actual_lines_import_export != null && contenedor_actual_lines_import_export.size()>0 )
                    for(String s : contenedor_actual_lines_import_export)
                    {
                        listado_ids_ie_line += '\''+s+'\''+',';
                    }
                system.debug('holaquery'+listado_ids_ie_line+contenedor_actual_lines_import_export);
                String lista_route_id = '';
                String lista_Freight_Mode_id = '';
                
                Lines=new List<Line_s>();
                List<Quote_Item_Line__c> lineas_items = null;
                boolean filtro_import_export = false;
                
                CSH_Shipment_Consolidation__c cs = CSH_Shipment_Consolidation__c.getvalues(UserInfo.getUserId());
                if(cs!= null)
                {
                    filtro_import_export = cs.Show_Only_I_E_Lines_without_SO_Line__c;
                    system.debug('ship_cons_user'+ cs.Show_Only_I_E_Lines_without_SO_Line__c);
                }
                else
                {
                   
                    cs  = CSH_Shipment_Consolidation__c.getOrgDefaults();
                    filtro_import_export = cs.Show_Only_I_E_Lines_without_SO_Line__c;
                    system.debug('ship_cons_org'+ cs.Show_Only_I_E_Lines_without_SO_Line__c);
                }
                           
  
                String consulta_import_export = '';
                consulta_import_export +='select Id,Name'+NEU_CurrencyUtils.CurrencyIsoCode('Import_Export_Quote__r.Account_for__r')+',Delivery_Number__c,Delivery_Date__c ,Total_Shipping_Volume_m3__c , Packaging_Volume_m3__c , Supplier_Total_Volume_m3__c , Supplier_Item_Weight_kg__c , Supplier_Total_Weight_kg__c, Weight_Kgs__c , Packaging_Gross_Weight_kg__c , Item_Units_x_Packaging__c , Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c, Import_Export_Quote__r.Freight_Mode__c, Import_Export_Quote__r.Origin_Address__c, Import_Export_Quote__r.Destination_Address__c, Import_Export_Quote__r.Service_Mode__c, Import_Export_Quote__r.Service_Type__c, Import_Export_Quote__r.Move_Type__c ,  Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Pickup_Cartage__c, Import_Export_Quote__r.Supply_Project_Name__c, Import_Export_Quote__r.Supply_Project_Name__r.Name, Import_Export_Quote__r.Route__c,';
                consulta_import_export +='Import_Export_Quote__r.Route__r.Name,Item_Name__r.Weight_Kgs__c,Item_Name__c,Item_Name__r.Master_Box_Volume_m3__c,Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Price__c,Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Item_Supplier_Owner__r.Id,';
                consulta_import_export +='Item_Supplier_Owner__r.Name,Item_Supplier_Owner__r.Developer_Record_Type__c,Import_Export_Quote__r.Authorized_Credit__c,Total_Shipping_Weight_Kgs__c,Extension_Item_Name__c,Consolidated__c,Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Name, Import_Export_Quote__r.Purchase_Incoterm__c,';
                consulta_import_export +='Item_Name__r.Sourcing_Family__r.Name,Item_Name__r.Picking_Rule__c,Units__c,Supplier_Quote_Line__r.Quantity__c,ETD__c,Supplier_Quote_Line__r.Delivery_Date__c,Amount__c,Import_Export_Quote__r.Id,Import_Export_Quote__r.Name,Item_List_Price__c,Import_Export_Quote__r.Account_for__r.Id,Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Delivery_Date__c, Expense_Amount__c from Quote_Item_Line__c';
                consulta_import_export +=' where (Import_Export_Quote__r.Quotation_Status__c = \'Approved as Succesful\' or  Import_Export_Quote__r.Quotation_Status__c = \'Partially Shipped\' or Import_Export_Quote__r.Quotation_Status__c =\'Shipped\')'; //Item_Name__r.Stock__c
                
                if(listado_cuentas_import_supplier_quote_cabeceras != null)
                {   
                    if(listado_cuentas_import_supplier_quote_cabeceras != '')
                        consulta_import_export +=' and Import_Export_Quote__r.Account_for__c IN ('+listado_cuentas_import_supplier_quote_cabeceras.subString(0,listado_cuentas_import_supplier_quote_cabeceras.length()-1)+')';
                }
                if(listado_import_supplier_quote_cabeceras != '' && listado_import_supplier_quote_cabeceras != null)
                {
                  consulta_import_export +=' and Import_Export_Quote__c IN ('+listado_import_supplier_quote_cabeceras.subString(0,listado_import_supplier_quote_cabeceras.length()-1)+')';
                }
                if(listado_ids_ie_line != '' && listado_ids_ie_line != null)
                {
                    consulta_import_export +=' and id not IN ('+listado_ids_ie_line.subString(0,listado_ids_ie_line.length()-1)+')';
                } 

                if(filtro_import_export == true) consulta_import_export +=' and Supplier_Quote__c = null';
                if(accountTypeNumber==2) consulta_import_export +=' and Import_Export_Quote__r.Account_for_Record_Type__c = \'Supplier\'';
                else
                    consulta_import_export +=' and Import_Export_Quote__r.Account_for_Record_Type__c != \'Supplier\'';
                if(notAuthorizedNumber==true) consulta_import_export +=' and Import_Export_Quote__r.Authorized_Credit__c = true';
                  
                consulta_import_export +=' order by Import_Export_Quote__r.Name,Name';
                
                List<sObject> query_import_export = Database.query(consulta_import_export);
                lineas_items = query_import_export;
                string contenedor_de_import_export = '';
                List<String> abecedario = new List<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M','N','O','P','Q','R','S','T','U','V','W', 'X','Y','Z' };
                integer contador_de_abecedario = 0;
                
                if(listado_import_supplier_quote_cabeceras != '' && listado_import_supplier_quote_cabeceras != null)   
                if(lineas_items!=null)
                    for(Quote_Item_Line__c l:lineas_items)
                    {
                        for(Item_Pallet_Type__c ip: items_pallet_type)
                        {
                            if(ip.Item_Name__c == l.Item_Name__c)
                            {
                                 relaciones += ip.Pallet_Type__c+'_'+((NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c)*ip.Packages_Pallet__c : (NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c)*ip.Packages_Pallet__c:0)))+'|';//(NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) : NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c))
                        
                            }
                        }
                        
                        Lines.add(new Line_s(l,null,null,false,l.Extension_Item_Name__c,0,l.Id,
                        NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c),   
                        NEU_Utils.safeDecimal(l.Total_Shipping_Volume_m3__c),
                        0,
                        false,relaciones,0,(l.Units__c > 0 ? l.Units__c: 0),(l.Price__c > 0 ? l.Price__c: 0), false));//pallet
                        Lines[Lines.size()-1].Units_x_Master_Box = (NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) : NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c));
                        Lines[Lines.size()-1].peso_item_sin_caja = (NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) != 0 ? NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) : (NEU_Utils.safeDecimal(l.Item_Name__r.Weight_Kgs__c != 0?l.Item_Name__r.Weight_Kgs__c :(NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c) != 0 ? NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c)/l.Units__c : 0 ))));
                        Lines[Lines.size()-1].peso_caja_items = (NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c)!= 0 ? NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c)/l.Units__c : 0);
                        Lines[Lines.size()-1].volumen_caja_items =(NEU_Utils.safeDecimal(l.Total_Shipping_Volume_m3__c) != 0 ? NEU_Utils.safeDecimal(l.Total_Shipping_Volume_m3__c)/l.Units__c : 0);
                    }
            }
        }
        
        if(linesTypeNumber==3)
        {
            if(Lines == null)
            {
              string relaciones = '';
              
              List<Item_Pallet_Type__c> items_pallet_type = new List<Item_Pallet_Type__c>();
              items_pallet_type = [select Id,Name, Item_Name__c, Packages_Pallet__c, Pallet_Type__c from Item_Pallet_Type__c];
            
              Lines=new List<Line_s>();
              List<Supplier_Quote_Line__c> lineas_items = null;
                
                String lista_account_id = '';
                if(accountid != null && accountid.size()>0)
		{
			for(String s : accountid)
	                {
	                    lista_account_id += '\''+s+'\''+',';
	                }	
		}
                
                String lista_route_id = '';
                
               String consulta_supplier_quote = '';
               consulta_supplier_quote +='select Id,Name'+NEU_CurrencyUtils.CurrencyIsoCode('Supplier_Quote__r.Customer__r')+',Item__r.Master_Box_Volume_m3__c, Supplier_Quote__r.DeliveryAddress__c, Supplier_Total_Volume_m3__c, Total_Volume_m3__c , Supplier_Quote__r.Receipt_Address__c, Supplier_Quote__r.Incoterm__c, Supplier_Quote__r.Move_Type__c, Supplier_Quote__r.Supply_Project__r.Sales_Incoterm__c,Supplier_Quote__r.Delivery_Account__c, Supplier_Quote__r.Delivery_Zone__c, Supplier_Quote__r.Route__c, Supplier_Quote__r.Supply_Project__c, Item__r.Master_Box_Gross_Weight_kg__c,Item__r.Units_x_Master_Box__c,Item__r.Weight_Kgs__c,';
               consulta_supplier_quote +='Total_Weight_Kg__c,Net_Price__c,Net_Amount__c ,Total_Amount__c ,Item__r.Subfamily__c,Item__r.Sourcing_Family__c,Supplier_Quote__r.Supplier_Quote_Status__c,Consolidated__c,Item__r.Id,Item__r.RecordType.DeveloperName, Supplier_Quote__r.Supply_Project__r.Name,';
               consulta_supplier_quote +='Item__r.Name,Item__r.Sourcing_Family__r.Name,Item__r.Picking_Rule__c,Price__c,Quantity__c,Gross_Buy_Amount__c,Supplier_Quote__r.Id,Supplier_Quote__r.Name,Supplier_Quote__r.Customer__r.Id,Supplier_Quote__r.Customer__r.Name,Supplier_Quote__r.Supplier__r.Id,Supplier_Quote__r.Supplier__r.Name,Supplier_Quote__r.Supplier__r.Developer_Record_Type__c,Unit_Origin_Price__c ,';
               consulta_supplier_quote +=' Unit_Destination_Price__c ,Packaging_Gross_Weight_kg__c , Supplier_Item_Weight_kg__c, Item_Units_x_Packaging__c , Packaging_Volume_m3__c , Delivery_Number__c, Delivery_Date__c, Expense_Amount__c from Supplier_Quote_Line__c';
               consulta_supplier_quote +=' where Supplier_Quote__r.Supplier_Quote_Status__c = \'Approved\' and Active__c = true'; //Item__r.Stock__c
               if(String.isNotEmpty(routeid))
                    consulta_supplier_quote +=' and Supplier_Quote__r.Route__c =:routeid';
                if(accountid != null)
                {
                    if(accountid.size()>0)
                    {
                        if(accountTypeNumber==2) consulta_supplier_quote +=' and Supplier_Quote__r.Supplier__c IN :accountid';
                        else
                            consulta_supplier_quote +=' and Supplier_Quote__r.Customer__c IN :accountid';
                    }
                }
                  
                if(notConsolidatedNumber==0)    
                    consulta_supplier_quote +=' and Consolidated__c = false';
                    
                consulta_supplier_quote +=' order by Supplier_Quote__r.Name, Name, Delivery_Number__c NULLS LAST';
               
               List<sObject> query_supplier_quote = Database.query(consulta_supplier_quote);
               lineas_items = query_supplier_quote;
               
               
                string contenedor_de_supplier_quote = ''; 
                List<String> abecedario = new List<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M','N','O','P','Q','R','S','T','U','V','W', 'X','Y','Z' };
                integer contador_de_abecedario = 0;
        
                
              if(lineas_items !=null)
                for(Supplier_Quote_Line__c l:lineas_items)
                {
                    
                    for(Item_Pallet_Type__c ip: items_pallet_type)
                    {
                        if(ip.Item_Name__c == l.Item__c)
                        {
                            relaciones += ip.Pallet_Type__c+'_'+((NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c)*ip.Packages_Pallet__c : (NEU_Utils.safeDecimal(l.Item__r.Units_x_Master_Box__c) != 0 ? NEU_Utils.safeDecimal(l.Item__r.Units_x_Master_Box__c)*ip.Packages_Pallet__c:0)))+'|';
                        }
                        
                    }
                 
                  Lines.add(new Line_s(null,null,l,false,'',0,l.Id,
                  (NEU_Utils.safeDecimal(l.Total_Weight_Kg__c)),
                  
                  NEU_Utils.safeDecimal(l.Total_Volume_m3__c),
                  0,
                  false,relaciones,0,(l.Quantity__c > 0 ? l.Quantity__c: 0),(l.Net_Price__c > 0 ?  l.Net_Price__c:0 ), false));//pallet
                  
                    
                    Lines[Lines.size()-1].Units_x_Master_Box = (NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) : NEU_Utils.safeDecimal(l.Item__r.Units_x_Master_Box__c));
                    Lines[Lines.size()-1].peso_item_sin_caja = (NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) != 0 ? NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) : (NEU_Utils.safeDecimal(l.Item__r.Weight_Kgs__c != 0?l.Item__r.Weight_Kgs__c :(NEU_Utils.safeDecimal(l.Total_Weight_Kg__c) != 0 ? NEU_Utils.safeDecimal(l.Total_Weight_Kg__c)/l.Quantity__c : 0 ))));
                    
                    Lines[Lines.size()-1].peso_caja_items = (NEU_Utils.safeDecimal(l.Total_Weight_Kg__c)!= 0 ? NEU_Utils.safeDecimal(l.Total_Weight_Kg__c)/l.Quantity__c : 0);
                     
                    Lines[Lines.size()-1].volumen_caja_items =(NEU_Utils.safeDecimal(l.Total_Volume_m3__c) != 0 ? NEU_Utils.safeDecimal(l.Total_Volume_m3__c)/l.Quantity__c : 0);
                    
                }
                
            }
        }
        
        return Lines;
    }
    
    
     public List<Line_s> getLines_update()
    {
        if(linesTypeNumber==1)
        {
            if(Lines_update==null)
            {
                Lines_update=new List<Line_s>();
                List<Shipment_Line__c> lineas_items = null;
                
                string relaciones = '';
                
                List<Item_Pallet_Type__c> items_pallet_type = new List<Item_Pallet_Type__c>();
                items_pallet_type = [select Id,Name, Item_Name__c, Packages_Pallet__c, Pallet_Type__c from Item_Pallet_Type__c];
                
                String consulta_customer_order = '';
                consulta_customer_order +='select Id,Name,Item_Name__r.Weight_Kgs__c,Item_Name__r.Master_Box_Volume_m3__c,Quote_Item_Line__c,Shipment__r.Name,Shipment__c,Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Item_Name__c,';
                consulta_customer_order +='Customer_Order__r.Authorized_Credit__c,Shipping_Volume_m3__c,Item_Name__r.Subfamily__c,Extension_Item_Name__c,Item_Name__r.Sourcing_Family__c,Shipping_Weight_Kg__c,Customer_Order_Line__r.Consolidated__c,Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Consolidate_by_BOM__c,Item_Name__r.Name,Item_Name__r.Sourcing_Family__r.Name,';
                consulta_customer_order +='Item_Name__r.Picking_Rule__c,Units_Shipped__c ,Item_Units_x_Packaging__c , Supplier_Item_Weight_kg__c , Sell_Origin_Amount__c , Expense_Amount__c,  Customer_Order_Line__r.Net_Price__c,Customer_Order_Line__r.Units__c,Unit_Origin_Sell_Price__c,Customer_Order_Line__r.Amount__c,Customer_Order__r.Id,Customer_Order__r.Name,Customer_Order_Line__r.Item_List_Price__c,Customer_Order_Line__r.E_Commerce_Offer__c,Customer_Order__r.Customer__r.Developer_Record_Type__c,Customer_Order__r.Customer__r.Id,Customer_Order__r.Customer__r.Name,Customer_Order_Line__r.Supplier__r.Id,Customer_Order_Line__r.Supplier__r.Name,Customer_Order_Line__r.Supplier__r.Developer_Record_Type__c, Customer_Order__r.Delivery_Date__c from Shipment_Line__c';
                consulta_customer_order +=' where (Shipment__r.Inbound_Consolidation_Program__c =\''+record.Id+'\' or Shipment__r.Outbound_Consolidation_Program__c = \''+record.Id+'\')'; //Item_Name__r.Stock__c, Shipment__r.Supply_Project__c , Shipment__r.Supply_Project__r.Name
                consulta_customer_order +='  order by Customer_Order__r.Name, Name';
                
                List<sObject> query_customer_order = Database.query(consulta_customer_order);
                lineas_items = query_customer_order;
                contenedor_actual_lines_import_export = new Set<String>();
                
                if(lineas_items!=null)
                    for(Shipment_Line__c l:lineas_items)
                    {
                        for(Item_Pallet_Type__c ip: items_pallet_type)
                        {
                            if(ip.Item_Name__c == l.Item_Name__c)
                            {
                                relaciones += ip.Pallet_Type__c+'_'+((NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c)*ip.Packages_Pallet__c : (NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c)*ip.Packages_Pallet__c:0)))+'|';
                            }
                        
                        }
                        
                        
                        
                        Line_s thisLine=new Line_s(null,l.Customer_Order_Line__r,null,true,l.Extension_Item_Name__c,0,l.Id,
                        NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c),   
                        NEU_Utils.safeDecimal(l.Shipping_Volume_m3__c),
                        0,//pallet
                        false,relaciones,0,(l.Units_Shipped__c > 0 ? l.Units_Shipped__c : 0),(l.Unit_Origin_Sell_Price__c > 0 ? l.Unit_Origin_Sell_Price__c : 0),false);
                        thisLine.shipment_line = l;
  
                        thisLine.Units_x_Master_Box = (NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) : NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c));
                        
                        thisLine.peso_item_sin_caja = (NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) != 0 ? NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) : (NEU_Utils.safeDecimal(l.Item_Name__r.Weight_Kgs__c != 0?l.Item_Name__r.Weight_Kgs__c :(NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c) != 0 ? NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c)/l.Units_Shipped__c : 0 ))));
                       
                        thisLine.peso_caja_items = (NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c)!= 0 ? NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c)/l.Units_Shipped__c : 0);
                       
                        thisLine.volumen_caja_items =(NEU_Utils.safeDecimal(l.Shipping_Volume_m3__c) != 0 ? NEU_Utils.safeDecimal(l.Shipping_Volume_m3__c)/l.Units_Shipped__c : 0);
                        
                        
                        Lines_update.add(thisLine);
                        
                        if(l.Item_Name__r.Consolidate_by_BOM__c)
                        {
                            List<BOM_Relation__c> inputs=[select Id from BOM_Relation__c where Output_Item__c=:l.Item_Name__r.Id];
                            if(inputs.size()>0)
                                thisLine.icon=2;
                        }
                    }
                    
            }
        }

        if(linesTypeNumber==2)
        {
            if(Lines_update==null)
            {
                string relaciones = '';
                List<Item_Pallet_Type__c> items_pallet_type = new List<Item_Pallet_Type__c>();
                items_pallet_type = [select Id,Name, Item_Name__c, Packages_Pallet__c, Pallet_Type__c from Item_Pallet_Type__c];
                
                Lines_update=new List<Line_s>();
                List<Shipment_Line__c> lineas_items = null;
                boolean filtro_import_export = false;
                
                CSH_Shipment_Consolidation__c cs = CSH_Shipment_Consolidation__c.getvalues(UserInfo.getUserId());
                if(cs!= null)
                {
                    filtro_import_export = cs.Show_Only_I_E_Lines_without_SO_Line__c;
                    system.debug('ship_cons_user'+ cs.Show_Only_I_E_Lines_without_SO_Line__c);
                }
                else
                {
                   
                    cs  = CSH_Shipment_Consolidation__c.getOrgDefaults();
                    filtro_import_export = cs.Show_Only_I_E_Lines_without_SO_Line__c;
                    system.debug('ship_cons_org'+ cs.Show_Only_I_E_Lines_without_SO_Line__c);
                }         
  
                //consulta de shipments lines
                String consulta_import_export = '';
                consulta_import_export +='select Id, Name, Quote_Item_Line__r.Name , Shipment__r.Inbound_Consolidation_Program__c, Quote_Item_Line__r.Delivery_Number__c, Quote_Item_Line__r.Delivery_Date__c , Shipping_Volume_m3__c, Packaging_Volume_m3__c , Supplier_Total_Volume_m3__c , Supplier_Item_Weight_kg__c , Supplier_Total_Weight_kg__c, Total_Weight_Items_Packaging_Kg__c , Packaging_Gross_Weight_kg__c , Item_Units_x_Packaging__c , Quote_Item_Line__r.Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c, Quote_Item_Line__r.Import_Export_Quote__r.Freight_Mode__c, Quote_Item_Line__r.Import_Export_Quote__r.Origin_Address__c, Import_Export_Quote__r.Destination_Address__c, Quote_Item_Line__r.Import_Export_Quote__r.Service_Mode__c, Quote_Item_Line__r.Import_Export_Quote__r.Service_Type__c, Quote_Item_Line__r.Import_Export_Quote__r.Move_Type__c ,  Quote_Item_Line__r.Import_Export_Quote__r.Supplier_Account__c, Quote_Item_Line__r.Import_Export_Quote__r.Pickup_Cartage__c, Quote_Item_Line__r.Import_Export_Quote__r.Supply_Project_Name__c, Import_Export_Quote__r.Supply_Project_Name__r.Name, Quote_Item_Line__r.Import_Export_Quote__r.Route__c,';
                consulta_import_export +='Import_Export_Quote__r.Route__r.Name,Item_Name__r.Weight_Kgs__c,Shipment__c, Quote_Item_Line__r.Units__c,Shipment__r.Name, Quote_Item_Line__r.Item_Name__r.Weight_Kgs__c,Quote_Item_Line__r.Item_Name__c,Quote_Item_Line__r.Item_Name__r.Master_Box_Volume_m3__c,Quote_Item_Line__r.Item_Name__r.Master_Box_Gross_Weight_kg__c, Item_Name__r.Units_x_Master_Box__c, Quote_Item_Line__r.Item_Name__r.Units_x_Master_Box__c,Unit_Origin_Sell_Price__c,Quote_Item_Line__r.Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Quote_Item_Line__r.Item_Supplier_Owner__r.Id,';// ,
                consulta_import_export +='Quote_Item_Line__r.Item_Supplier_Owner__r.Name,Quote_Item_Line__r.Item_Supplier_Owner__r.Developer_Record_Type__c,Quote_Item_Line__r.Import_Export_Quote__r.Authorized_Credit__c,Shipping_Weight_Kg__c,Extension_Item_Name__c,Quote_Item_Line__r.Consolidated__c,Quote_Item_Line__r.Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Name, Quote_Item_Line__r.Import_Export_Quote__r.Purchase_Incoterm__c,';
                consulta_import_export +='Quote_Item_Line__r.Item_Name__r.Sourcing_Family__r.Name,Quote_Item_Line__r.Supplier_Quote_Line__c,Quote_Item_Line__r.Supplier_Quote_Line__r.Quantity__c, Quote_Item_Line__r.Import_Export_Quote__r.Supply_Project_Name__r.Name, Shipment_Consolidation_Data__c, Quote_Item_Line__r.Import_Export_Quote__r.Quotation_Status__c,  Quote_Item_Line__r.Item_Name__r.Name, Quote_Item_Line__r.Import_Export_Quote__r.Name,Item_Name__r.Picking_Rule__c,Units_Shipped__c,Sell_Origin_Amount__c,Import_Export_Quote__r.Id,Import_Export_Quote__r.Name,Quote_Item_Line__r.Import_Export_Quote__r.Account_for__r.Id,Quote_Item_Line__r.Import_Export_Quote__r.Account_for__r.Name, Quote_Item_Line__r.Import_Export_Quote__r.Delivery_Date__c, Expense_Amount__c from Shipment_Line__c';
                consulta_import_export +=' where (Shipment__r.Inbound_Consolidation_Program__c =\''+record.Id+'\' or Shipment__r.Outbound_Consolidation_Program__c = \''+record.Id+'\')'; //Shipment__r.Supply_Project__c, Shipment__r.Supply_Project__r.Name
                if(filtro_import_export == true)
                    consulta_import_export +=' and Quote_Item_Line__r.Supplier_Quote__c = null';
                consulta_import_export +=' order by Import_Export_Quote__r.Name,Name'; //Quote_Item_Line__r.Item_Name__r.Stock__c
     
                List<sObject> query_import_export = Database.query(consulta_import_export);
                lineas_items = query_import_export;
                string contenedor_de_import_export = '';
                contenedor_actual_lines_import_export = new Set<String>();
                
                // version shipment lines
                if(lineas_items!=null)
                    for(Shipment_Line__c l:lineas_items)
                    {
                        for(Item_Pallet_Type__c ip: items_pallet_type)
                        {
                            if(ip.Item_Name__c == l.Item_Name__c)
                            {
                                 relaciones += ip.Pallet_Type__c+'_'+((NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c)*ip.Packages_Pallet__c : (NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c)*ip.Packages_Pallet__c:0)))+'|';//(NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) : NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c))
                        
                            }
                        
                        }
                        if(l.Quote_Item_Line__c != null)
                            contenedor_actual_lines_import_export.add(l.Quote_Item_Line__c);  
                         
                        Lines_update.add(new Line_s(l.Quote_Item_Line__r,null,null,true,l.Extension_Item_Name__c,0,l.Id,
                        NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c),   
                        NEU_Utils.safeDecimal(l.Shipping_Volume_m3__c),
                        0,
                        false,relaciones,0,(l.Units_Shipped__c > 0 ? l.Units_Shipped__c : 0),(l.Unit_Origin_Sell_Price__c > 0 ? l.Unit_Origin_Sell_Price__c: 0), false));//pallet
                        
                        Lines_update[Lines_update.size()-1].Units_x_Master_Box = (NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) : NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c));
                        
                        Lines_update[Lines_update.size()-1].peso_item_sin_caja = (NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) != 0 ? NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) : (NEU_Utils.safeDecimal(l.Item_Name__r.Weight_Kgs__c != 0?l.Item_Name__r.Weight_Kgs__c :(NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c) != 0 ? NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c)/l.Units_Shipped__c : 0 ))));
                       
                        Lines_update[Lines_update.size()-1].peso_caja_items = (NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c)!= 0 ? NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c)/l.Units_Shipped__c : 0);
                       
                        Lines_update[Lines_update.size()-1].volumen_caja_items =(NEU_Utils.safeDecimal(l.Shipping_Volume_m3__c) != 0 ? NEU_Utils.safeDecimal(l.Shipping_Volume_m3__c)/l.Units_Shipped__c : 0);
                        
                        Lines_update[Lines_update.size()-1].shipment_line = l;
                   
                    }
            }
        }
        
         if(linesTypeNumber==3)
        {
            if(Lines_update == null)//---- mirar funcionamiento
            {
                string relaciones = '';
                
                List<Item_Pallet_Type__c> items_pallet_type = new List<Item_Pallet_Type__c>();
                items_pallet_type = [select Id,Name, Item_Name__c, Packages_Pallet__c, Pallet_Type__c from Item_Pallet_Type__c];
              
                Lines_update=new List<Line_s>();
                List<Shipment_Line__c> lineas_items = null;
           
                 String consulta_supplier_quote = '';
                 consulta_supplier_quote +='select Id,Name'+NEU_CurrencyUtils.CurrencyIsoCode('Supplier_Quote_Line__r.Supplier_Quote__r.Customer__r')+',Supplier_Quote_Line__r.Supplier_Quote__r.Supplier_Quote_Status__c,Supplier_Quote_Line__r.Supplier_Quote__r.Id,Supplier_Quote_Line__r.Quantity__c,Supplier_Quote_Line__r.Item__r.Master_Box_Volume_m3__c, Shipment__r.Inbound_Consolidation_Program__c, Supplier_Quote__r.DeliveryAddress__c, Supplier_Quote_Line__r.Supplier_Total_Volume_m3__c, Shipping_Volume_m3__c , Supplier_Quote__r.Receipt_Address__c, Supplier_Quote__r.Incoterm__c, Supplier_Quote__r.Move_Type__c, Supplier_Quote__r.Supply_Project__r.Sales_Incoterm__c,Supplier_Quote__r.Delivery_Account__c, Supplier_Quote__r.Delivery_Zone__c, Shipment__r.Route__c, Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Item_Name__r.Weight_Kgs__c,';
                 consulta_supplier_quote +='Supplier_Item_Weight_kg__c,Unit_Origin_Sell_Price__c,Shipping_Weight_Kg__c ,Supplier_Quote_Line__r.Net_Price__c,Supplier_Quote_Line__r.Net_Amount__c ,Supplier_Quote_Line__r.Total_Amount__c ,Supplier_Quote_Line__r.Item__r.Subfamily__c,Supplier_Quote_Line__r.Item__r.Sourcing_Family__c,Supplier_Quote__r.Supplier_Quote_Status__c,Supplier_Quote_Line__r.Consolidated__c,Supplier_Quote_Line__r.Item__r.Id,Supplier_Quote_Line__r.Item__r.RecordType.DeveloperName, Supplier_Quote__r.Supply_Project__r.Name,';
                 consulta_supplier_quote +='Supplier_Quote_Line__r.Item__r.Name,Supplier_Quote_Line__r.Item__r.Sourcing_Family__r.Name,Item_Name__r.Picking_Rule__c, Shipment__c, Shipment__r.Name, Supplier_Quote_Line__r.Price__c,Units_Shipped__c,Supplier_Quote__r.Id,Supplier_Quote__r.Name,Supplier_Quote_Line__r.Supplier_Quote__r.Customer__r.Id,Supplier_Quote_Line__r.Supplier_Quote__r.Customer__r.Name,Supplier_Quote__r.Supplier__r.Id,Supplier_Quote__r.Supplier__r.Name,Supplier_Quote__r.Supplier__r.Developer_Record_Type__c ,';
                 consulta_supplier_quote +=' Supplier_Quote_Line__r.Unit_Destination_Price__c ,Supplier_Quote_Line__r.Packaging_Gross_Weight_kg__c , Supplier_Quote_Line__r.Supplier_Item_Weight_kg__c, Item_Units_x_Packaging__c ,Sell_Origin_Amount__c, Supplier_Quote_Line__r.Packaging_Volume_m3__c , Supplier_Quote_Line__r.Delivery_Number__c, Supplier_Quote_Line__r.Delivery_Date__c, Supplier_Quote_Line__r.Expense_Amount__c,Extension_Item_Name__c from Shipment_Line__c';
                 consulta_supplier_quote +=' where (Shipment__r.Inbound_Consolidation_Program__c =\''+record.Id+'\' or Shipment__r.Outbound_Consolidation_Program__c = \''+record.Id+'\')';
                 consulta_supplier_quote +=' order by Supplier_Quote__r.Name,Name'; //Supplier_Quote_Line__r.Item__r.Stock__c, Shipment__r.Supply_Project__c,Shipment__r.Supply_Project__r.Name
                 List<sObject> query_supplier_quote = Database.query(consulta_supplier_quote);
                 lineas_items = query_supplier_quote;
                 
                 
                  string contenedor_de_supplier_quote = ''; 
                  List<String> abecedario = new List<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M','N','O','P','Q','R','S','T','U','V','W', 'X','Y','Z' };
                  integer contador_de_abecedario = 0;
          
                // version shipment lines  
                if(lineas_items !=null)
                  for(Shipment_Line__c l:lineas_items)
                  {
                      
                      for(Item_Pallet_Type__c ip: items_pallet_type)
                      {
                          if(ip.Item_Name__c == l.Item_Name__c)
                          {
                              relaciones += ip.Pallet_Type__c+'_'+((NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c)*ip.Packages_Pallet__c : (NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c)*ip.Packages_Pallet__c:0)))+'|';
                          }
                          
                      }
                   
                    Lines_update.add(new Line_s(null,null,l.Supplier_Quote_Line__r,true,l.Extension_Item_Name__c,0,l.Id,
                     NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c),  
                    
                     NEU_Utils.safeDecimal(l.Shipping_Volume_m3__c),
                    0,
                    false,relaciones,0,(l.Units_Shipped__c > 0 ? l.Units_Shipped__c: 0),(l.Unit_Origin_Sell_Price__c > 0 ?  l.Unit_Origin_Sell_Price__c : 0 ), false));//pallet
                    
                      
                      Lines_update[Lines_update.size()-1].Units_x_Master_Box = (NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) : NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c));
                      Lines_update[Lines_update.size()-1].peso_item_sin_caja = (NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) != 0 ? NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) : (NEU_Utils.safeDecimal(l.Item_Name__r.Weight_Kgs__c != 0?l.Item_Name__r.Weight_Kgs__c :(NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c) != 0 ? NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c)/l.Units_Shipped__c : 0 ))));
                      
                      Lines_update[Lines_update.size()-1].peso_caja_items = (NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c)!= 0 ? NEU_Utils.safeDecimal(l.Shipping_Weight_Kg__c)/l.Units_Shipped__c : 0);
                       
                      Lines_update[Lines_update.size()-1].volumen_caja_items =(NEU_Utils.safeDecimal(l.Shipping_Volume_m3__c) != 0 ? NEU_Utils.safeDecimal(l.Shipping_Volume_m3__c)/l.Units_Shipped__c : 0);
                      
                      Lines_update[Lines_update.size()-1].shipment_line = l;
                  }
            }
        }
        return Lines_update;
    }
         

    public void go_compare()
    {
      
        ordenacion_quotes = new String[]{};
        if(orden_quotes != null)
        {
            ordenacion_quotes = orden_quotes.split('-'); 
            for(Line_s li: getLines())
            {
              li.campo_compare = ordenacion_quotes[0];
              li.orden_de_comparacion = ordenacion_quotes[1];
            }  
            Lines.sort();
        }
          
    }
    
    public void go_compare_update()
    {
      
        ordenacion_quotes = new String[]{};
        if(orden_quotes != null)
        {
            ordenacion_quotes = orden_quotes.split('-'); 
            for(Line_s li: getLines_update())
            {
              li.campo_compare = ordenacion_quotes[0];
              li.orden_de_comparacion = ordenacion_quotes[1];
            }  
        Lines_update.sort();
        }
          
    }
    
    public PageReference applyLines2(integer counter) 
    {
      //listas necesarias
      List<Shipment__c> listado_shipments_para_insertar = new List<Shipment__c>();
      List<Shipment_Line__c> listado_shipments_lines_para_insertar = new List<Shipment_Line__c>();
      //string 
      
      List<Supplier_Quote__c> insert_lista_supplier_quote = new List<Supplier_Quote__c>();
      List<Customer_Quote__c> insert_lista_import_export = new List<Customer_Quote__c>();
      List<Shipment_Consolidation_Data__c> insert_lista_shipment_consolidation_data = new List<Shipment_Consolidation_Data__c>();
      List<Quote_Item_Line__c> update_lista_quote_line = new List<Quote_Item_Line__c>();// actualizar unidades y check consolidadas
      List<Shopping_Cart_line__c> update_lista_custom_or = new List<Shopping_Cart_line__c>();// actualizar unidades y check consolidadas
      List<Supplier_Quote_Line__c> update_lista_supplier_quote = new List<Supplier_Quote_Line__c>();// actualizar unidades y check consolidadas
      Shipment__c shipment = null;//nuevos shipments
      Shipment_Line__c shipment_lines = new Shipment_Line__c();//nuevos shipments lines
      Set<Id>ids_import_export = new Set<Id>();//lista de ids para actualizar el status
      Set<Id>ids_customer_order = new Set<Id>();//lista de ids para actualizar el status
      Set<Id>ids_supplier_quote = new Set<Id>();//lista de ids para actualizar el status
      
      if(counter != 0)
      {
        if(linesTypeNumber==1)
        {
          for(Line_s li: getLines())
              {
                li.campo_compare = 'shopping_line.Shopping_Cart__r.Customer__c';
                li.orden_de_comparacion = 'asc';
              }  
              Lines.sort();
        }
        
        if(linesTypeNumber==2)
        {
          for(Line_s li: getLines())
              {
                li.campo_compare = 'quote_line.Import_Export_Quote__r.Account_for__c';
                li.orden_de_comparacion = 'asc';
              }  
              Lines.sort();
        }
        
        if(linesTypeNumber==3)
        {
          for(Line_s li: getLines())
              {
                li.campo_compare = 'supplier_line.Supplier_Quote__r.Customer__c';
                li.orden_de_comparacion = 'asc';
              }  
              Lines.sort();
        }
        
        string contenedor_de_account_for = '';
        boolean encontrado_shipment_supplier = false;
        
        //import-export quote
        if(linesTypeNumber==2)
         for (Line_s lines:getLines())
         {
               if(lines.selected == true)
               {
                 
                 if(contenedor_de_account_for.contains(lines.quote_line.Import_Export_Quote__r.Account_for__c) == false)
                 {
                   shipment = new Shipment__c();
                  listado_shipments_para_insertar.add(shipment);
                  if(linesTypeNumber==2)
                    shipment.Account_for__c=lines.quote_line.Import_Export_Quote__r.Account_for__c;
                  if(linesTypeNumber==2)  
                    shipment.Supplier_Account__c= lines.quote_line.Import_Export_Quote__r.Supplier_Account__c;
                  shipment.Inbound_Consolidation_Program__c = record.id;
                 // shipment.Freight_Mode__c = record.Freight_Mode__c;
                  contenedor_de_account_for +=lines.quote_line.Import_Export_Quote__r.Account_for__c;
                  counter =1;
                 }
                 else
                 {
                   if(lines.quote_line.Import_Export_Quote__r.Supplier_Account__c != shipment.Supplier_Account__c )
                   {
                     for(Shipment__c ship: listado_shipments_para_insertar)//comrpobaciones para crear un nuevo shipment con distinto supplier
                     {
                       if(ship.Account_for__c == lines.quote_line.Import_Export_Quote__r.Account_for__c && shipment.Supplier_Account__c==lines.quote_line.Import_Export_Quote__r.Supplier_Account__c)
                       {
                         encontrado_shipment_supplier = true;
                         shipment = ship;
                         break;
                       }
                     }
                     
                     if(encontrado_shipment_supplier == false)//si no hay ninguno se crear nuevo
                     {
                       shipment = new Shipment__c();
                      listado_shipments_para_insertar.add(shipment);
                      
                      if(linesTypeNumber==2)
                        shipment.Account_for__c=lines.quote_line.Import_Export_Quote__r.Account_for__c;
                      if(linesTypeNumber==2)  
                        shipment.Supplier_Account__c= lines.quote_line.Import_Export_Quote__r.Supplier_Account__c;
                      shipment.Inbound_Consolidation_Program__c = record.id;
                      //shipment.Freight_Mode__c = record.Freight_Mode__c;
                      counter =1;
                     }
                     encontrado_shipment_supplier = false;
                     
                   }
                 }
                     
                    shipment_lines = new  Shipment_Line__c();
                    shipment_lines.Shipment__r=shipment;
                    shipment_lines.Item_Name__c=lines.getItemId();  
                    if(linesTypeNumber==2)
                    {
                        shipment_lines.Import_Export_Quote__c = lines.getHeaderId();
                        shipment_lines.Quote_Item_Line__c=lines.quote_line.Id;
                        shipment_lines.Family__c= lines.quote_line.Item_Name__r.Sourcing_Family__c;
                        shipment_lines.Subfamily__c = lines.quote_line.Item_Name__r.Subfamily__c;
                        NEU_CurrencyUtils.setCurrencyIsoCode(shipment_lines,NEU_CurrencyUtils.getCurrencyIsoCode(lines.quote_line.Import_Export_Quote__r.Account_for__r));
                    }
                    
                    shipment_lines.Extension_Item_Name__c=lines.extension;
                    shipment_lines.Name=String.valueOf(counter);
                  
                    while(shipment_lines.Name.length()<3)
                      shipment_lines.Name='0'+shipment_lines.Name;
                     
                    counter++;               
                    listado_shipments_lines_para_insertar.add(shipment_lines);
                    
                    if(linesTypeNumber==2)//import export
                    {
                        if(NEU_Utils.toDecimal(lines.unidades_iniciales) > lines.quote_line.Units__c && lines.check_full == false)
                        {
                           if(NEU_Utils.toDecimal(lines.unidades_iniciales)  == lines.quote_line.Supplier_Quote_Line__r.Quantity__c)
                              splitSupQuoteLine(lines.quote_line.Supplier_Quote_Line__c, lines.quote_line.Units__c);
                            splitQuoteLine(lines.quote_line.Id,lines.quote_line.Units__c);
                            
                            shipment_lines.Shipping_Volume_m3__c =(lines.quote_line.Total_Shipping_Volume_m3__c != null ? (lines.quote_line.Total_Shipping_Volume_m3__c /NEU_Utils.toDecimal(lines.unidades_iniciales))*lines.quote_line.Units__c : 0 );
                            shipment_lines.Shipping_Weight_Kg__c = (lines.quote_line.Total_Shipping_Weight_Kgs__c != null ? (lines.quote_line.Total_Shipping_Weight_Kgs__c /NEU_Utils.toDecimal(lines.unidades_iniciales))*lines.quote_line.Units__c : 0 );
                        }
                        else if(lines.check_full == true)
                        {
                            shipment_lines.Shipping_Volume_m3__c =(lines.quote_line.Total_Shipping_Volume_m3__c != null ? (lines.quote_line.Total_Shipping_Volume_m3__c /NEU_Utils.toDecimal(lines.unidades_iniciales))*lines.quote_line.Units__c : 0 );
                            shipment_lines.Shipping_Weight_Kg__c = (lines.quote_line.Total_Shipping_Weight_Kgs__c != null ? (lines.quote_line.Total_Shipping_Weight_Kgs__c /NEU_Utils.toDecimal(lines.unidades_iniciales))*lines.quote_line.Units__c : 0 );
                            if(NEU_Utils.toDecimal(lines.unidades_iniciales) >= lines.quote_line.Units__c)
                            {
                                shipment_lines.Units_Shipped__c = lines.quote_line.Units__c;
                                if(lines.quote_line.Consolidated__c==false)
                                {
                                    lines.quote_line.Consolidated__c=true;
                                    lines.quote_line.Units__c = NEU_Utils.toDecimal(lines.unidades_iniciales);
                                    update_lista_quote_line.add(lines.quote_line); 
                                }
                            }
                            else
                            {
                                if(NEU_Utils.toDecimal(lines.unidades_iniciales) <= lines.quote_line.Units__c)
                                {
                                     shipment_lines.Units_Shipped__c = lines.quote_line.Units__c;
                                    if(lines.quote_line.Consolidated__c==false)
                                    {
                                        lines.quote_line.Consolidated__c=true;
                                        lines.quote_line.Units__c = NEU_Utils.toDecimal(lines.unidades_iniciales);
                                        update_lista_quote_line.add(lines.quote_line);
                                    }
                                }
                            }
                        }
                        else if(lines.quote_line.Consolidated__c==false)
                        {
                            lines.quote_line.Consolidated__c=true;
                            update_lista_quote_line.add(lines.quote_line);
                        }
                        
                        ids_import_export.add(lines.quote_line.Import_Export_Quote__c);
                        id_nueva_linea = null;
                    }
                 }
             }//fin for lineas
             
             
        //supplier quote
        if(linesTypeNumber==3)
         for (Line_s lines:getLines())
         {
               if(lines.selected == true)
               {
                 
                 if(contenedor_de_account_for.contains(lines.supplier_line.Supplier_Quote__r.Customer__c) == false)
                 {
                   shipment = new Shipment__c();
                  listado_shipments_para_insertar.add(shipment);
                  if(linesTypeNumber==3)
                    shipment.Account_for__c=lines.supplier_line.Supplier_Quote__r.Customer__c;
                  if(linesTypeNumber==3)  
                    shipment.Supplier_Account__c= lines.supplier_line.Supplier_Quote__r.Supplier__c;
                  shipment.Inbound_Consolidation_Program__c = record.id;
                //  shipment.Freight_Mode__c = record.Freight_Mode__c;
                  contenedor_de_account_for +=lines.supplier_line.Supplier_Quote__r.Customer__c;
                  counter =1;
                 }
                 else
                 {
                   if(lines.supplier_line.Supplier_Quote__r.Supplier__c != shipment.Supplier_Account__c )
                   {
                     for(Shipment__c ship: listado_shipments_para_insertar)//comrpobaciones para crear un nuevo shipment con distinto supplier
                     {
                       if(ship.Account_for__c == lines.supplier_line.Supplier_Quote__r.Customer__c && shipment.Supplier_Account__c == lines.supplier_line.Supplier_Quote__r.Supplier__c)
                       {
                         encontrado_shipment_supplier = true;
                         shipment = ship;
                         break;
                       }
                     }
                     
                     if(encontrado_shipment_supplier == false)//si no hay ninguno se crear nuevo
                     {
                       shipment = new Shipment__c();
                      listado_shipments_para_insertar.add(shipment);
                      
                      if(linesTypeNumber==3)
                        shipment.Account_for__c=lines.supplier_line.Supplier_Quote__r.Customer__c;
                      if(linesTypeNumber==3)  
                        shipment.Supplier_Account__c= lines.supplier_line.Supplier_Quote__r.Supplier__c;
                      shipment.Inbound_Consolidation_Program__c = record.id;
                      //shipment.Freight_Mode__c = record.Freight_Mode__c;
                      counter =1;
                     }
                     encontrado_shipment_supplier = false;
                     
                   }
                 }
                 
                     
                    shipment_lines = new  Shipment_Line__c();
                    shipment_lines.Shipment__r=shipment;
                    shipment_lines.Item_Name__c=lines.getItemId();  
                    
                    if(linesTypeNumber==3)
                    {
                        shipment_lines.Supplier_Quote__c = lines.getHeaderId();
                        shipment_lines.Supplier_Quote_Line__c=lines.supplier_line.Id;
                        shipment_lines.Family__c= lines.supplier_line.Item__r.Sourcing_Family__c;
                        shipment_lines.Subfamily__c = lines.supplier_line.Item__r.Subfamily__c;
                        NEU_CurrencyUtils.setCurrencyIsoCode(shipment_lines,NEU_CurrencyUtils.getCurrencyIsoCode(lines.supplier_line.Supplier_Quote__r.Customer__r));
                    }
                    
                    shipment_lines.Extension_Item_Name__c=lines.extension;
                    shipment_lines.Name=String.valueOf(counter);
                  
                    while(shipment_lines.Name.length()<3)
                      shipment_lines.Name='0'+shipment_lines.Name;
                     
                    counter++;               
                    listado_shipments_lines_para_insertar.add(shipment_lines);
                    
                    if(linesTypeNumber==3)//supplier quote
                    {
                        if(NEU_Utils.toDecimal(lines.unidades_iniciales) > lines.supplier_line.Quantity__c && lines.check_full == false)
                        {
                            splitSupQuoteLine(lines.getId(),lines.supplier_line.Quantity__c);
                            shipment_lines.Shipping_Volume_m3__c =(lines.supplier_line.Total_Volume_m3__c != null ? (lines.supplier_line.Total_Volume_m3__c /NEU_Utils.toDecimal(lines.unidades_iniciales))*lines.supplier_line.Quantity__c : 0 );
                            shipment_lines.Shipping_Weight_Kg__c = (lines.supplier_line.Total_Weight_Kg__c != null ? (lines.supplier_line.Total_Weight_Kg__c /NEU_Utils.toDecimal(lines.unidades_iniciales))*lines.supplier_line.Quantity__c : 0 );
                        }
                        else if(lines.check_full == true)
                        {
                            shipment_lines.Shipping_Volume_m3__c =(lines.supplier_line.Total_Volume_m3__c != null ? (lines.supplier_line.Total_Volume_m3__c /NEU_Utils.toDecimal(lines.unidades_iniciales))*lines.supplier_line.Quantity__c : 0 );
                            shipment_lines.Shipping_Weight_Kg__c = (lines.supplier_line.Total_Weight_Kg__c != null ? (lines.supplier_line.Total_Weight_Kg__c /NEU_Utils.toDecimal(lines.unidades_iniciales))*lines.supplier_line.Quantity__c : 0 );
                            if(NEU_Utils.toDecimal(lines.unidades_iniciales) >= lines.supplier_line.Quantity__c)
                            {
                                shipment_lines.Units_Shipped__c = lines.supplier_line.Quantity__c;
                                if(lines.supplier_line.Consolidated__c==false)
                                {
                                    lines.supplier_line.Consolidated__c=true;
                                    lines.supplier_line.Quantity__c = NEU_Utils.toDecimal(lines.unidades_iniciales);
                                    update_lista_supplier_quote.add(lines.supplier_line);
                                }
                            }
                            else
                            {
                                if(NEU_Utils.toDecimal(lines.unidades_iniciales) <= lines.supplier_line.Quantity__c)
                                {
                                     shipment_lines.Units_Shipped__c = lines.supplier_line.Quantity__c;
                                    if(lines.supplier_line.Consolidated__c==false)
                                    {
                                        lines.supplier_line.Consolidated__c=true;
                                        lines.supplier_line.Quantity__c = NEU_Utils.toDecimal(lines.unidades_iniciales);
                                        update_lista_supplier_quote.add(lines.supplier_line);
                                    }
                                }
                            }
                        }
                        else if(lines.supplier_line.Consolidated__c==false)
                        {
                            lines.supplier_line.Consolidated__c=true;
                            update_lista_supplier_quote.add(lines.supplier_line);
                        }
                        
                        ids_supplier_quote.add(lines.supplier_line.Supplier_Quote__c);
                    
                    }
                 }
             }//fin for lineas
             //---------------------------------------------------------
             
             //insertar y actualizar listas
             if(linesTypeNumber == 2)
               update update_lista_quote_line;//actualiza a consolidado
             if(linesTypeNumber == 1)
               update update_lista_custom_or;//actualiza a consolidado
             if(linesTypeNumber == 3)
               update update_lista_supplier_quote;//actualiza a consolidado  
               
               //hacer efectivos los split
              if(lista_update_split_sup != null && lista_update_split_sup.size()>0)
                upsert lista_update_split_sup;
              lista_update_split_sup = null;
              if(lista_update_split != null && lista_update_split.size()>0)
              {
                for(Quote_Item_Line__c qil: lista_update_split)
                  qil.Supplier_Quote_Line__c = qil.Supplier_Quote_Line__r.Id;
                NEU_StaticVariableHelper.setBoolean1(true);
                insert lista_update_split;
                update lista_update_split2;
                NEU_StaticVariableHelper.setBoolean1(false);
              }
              
            //actualizar las lineas de la import-export a su status correspondiente
            if(ids_import_export != null && ids_import_export.size()>0)
            {
                List<Customer_Quote__c> lista_import_export_to_update = new List<Customer_Quote__c>();
                List<Customer_Quote__c> lista_import_export_to_update2 = new List<Customer_Quote__c>();
                Customer_Quote__c import_export_anterior = new Customer_Quote__c();
                
                List<Quote_Item_Line__c>pending=[select Id, Import_Export_Quote__c, Import_Export_Quote__r.Quotation_Status__c, Consolidated__c from Quote_Item_Line__c where Import_Export_Quote__c IN: ids_import_export order by Import_Export_Quote__c];     
                
                string contenedor_string_import_export_quote = '';
                boolean no_consolidada = false;
                 
                for(Quote_Item_Line__c qil: pending)
                {
                    if(contenedor_string_import_export_quote != '' && contenedor_string_import_export_quote.contains(qil.Import_Export_Quote__c) == false)
                    {
                      if(no_consolidada == false)
                      {
                        import_export_anterior.Quotation_Status__c = 'Shipped';
                        lista_import_export_to_update.add(import_export_anterior);
                      }
                      else
                      {
                        import_export_anterior.Quotation_Status__c = 'Partially Shipped';
                        lista_import_export_to_update2.add(import_export_anterior);
                      }
                      no_consolidada = false;
                    }
                    
                    if(qil.Consolidated__c == false)
                      no_consolidada = true;
                    
                    import_export_anterior = qil.Import_Export_Quote__r;
                    contenedor_string_import_export_quote +=qil.Import_Export_Quote__c;
                    
                }
                  
                if(pending != null && pending.size() > 0)
                {
                      if(no_consolidada == false)
                      {
                         import_export_anterior.Quotation_Status__c = 'Shipped';
                         lista_import_export_to_update.add(import_export_anterior);
                      }
                      else
                      {
                        import_export_anterior.Quotation_Status__c = 'Partially Shipped';
                        lista_import_export_to_update2.add(import_export_anterior);
                      }
                }
          
                if(lista_import_export_to_update != null && lista_import_export_to_update.size()>0)
                  update lista_import_export_to_update;
                if(lista_import_export_to_update2 != null && lista_import_export_to_update2.size()>0)
                  update lista_import_export_to_update2; 
                  
              }
              
              //actualizar cutomer order a su status
              if(ids_customer_order != null && ids_customer_order.size()>0)
              {
                List<Shopping_Cart__c> lista_import_export_to_update = new List<Shopping_Cart__c>();
                List<Shopping_Cart__c> lista_import_export_to_update2 = new List<Shopping_Cart__c>();
                Shopping_Cart__c import_export_anterior = new Shopping_Cart__c();
                
                List<Shopping_Cart_line__c>pending=[select Id, Shopping_Cart__c, Shopping_Cart__r.Status__c, Consolidated__c from Shopping_Cart_line__c where Shopping_Cart__c IN: ids_customer_order order by Shopping_Cart__c];     
                
                string contenedor_string_import_export_quote = '';
                boolean no_consolidada = false;
                 
                  for(Shopping_Cart_line__c qil: pending)
                  {
                    if(contenedor_string_import_export_quote != '' && contenedor_string_import_export_quote.contains(qil.Shopping_Cart__c) == false)
                    {
                      if(no_consolidada == false)
                      {
                        import_export_anterior.Status__c = 'Consolidated';
                        lista_import_export_to_update.add(import_export_anterior);
                      }
                      else
                      {
                        import_export_anterior.Status__c = 'Close';
                        lista_import_export_to_update2.add(import_export_anterior);
                      }
                      no_consolidada = false;
                    }
                    
                    if(qil.Consolidated__c == false)
                      no_consolidada = true;
                    
                    import_export_anterior = qil.Shopping_Cart__r;
                    contenedor_string_import_export_quote +=qil.Shopping_Cart__c;
                    
                  }
                  
                  if(pending != null && pending.size() > 0)
                  {
                      if(no_consolidada == false)
                      {
                         import_export_anterior.Status__c = 'Consolidated';
                         lista_import_export_to_update.add(import_export_anterior);
                      }
                      else
                      {
                        import_export_anterior.Status__c = 'Close';
                        lista_import_export_to_update2.add(import_export_anterior);
                      }
                  }
          
                if(lista_import_export_to_update != null && lista_import_export_to_update.size()>0)
                  update lista_import_export_to_update;
                if(lista_import_export_to_update2 != null && lista_import_export_to_update2.size()>0)
                  update lista_import_export_to_update2; 
              }
              
              //actualizar supplier quote a su status
              if(ids_supplier_quote != null && ids_supplier_quote.size()>0)
              {
                List<Supplier_Quote__c> lista_import_export_to_update = new List<Supplier_Quote__c>();
                List<Supplier_Quote__c> lista_import_export_to_update2 = new List<Supplier_Quote__c>();
                Supplier_Quote__c import_export_anterior = new Supplier_Quote__c();
                
                List<Supplier_Quote_Line__c>pending=[select Id, Supplier_Quote__c, Supplier_Quote__r.Supplier_Quote_Status__c, Consolidated__c from Supplier_Quote_Line__c where Supplier_Quote__c IN: ids_supplier_quote order by Supplier_Quote__c];     
                
                string contenedor_string_import_export_quote = '';
                boolean no_consolidada = false;
                 
                  for(Supplier_Quote_Line__c qil: pending)
                  {
                    if(contenedor_string_import_export_quote != '' && contenedor_string_import_export_quote.contains(qil.Supplier_Quote__c) == false)
                    {
                      if(no_consolidada == false)
                      {
                        import_export_anterior.Supplier_Quote_Status__c = 'Consolidated';
                        lista_import_export_to_update.add(import_export_anterior);
                      }
                      else
                      {
                        import_export_anterior.Supplier_Quote_Status__c = 'Approved';
                        lista_import_export_to_update2.add(import_export_anterior);
                      }
                      no_consolidada = false;
                    }
                    
                    if(qil.Consolidated__c == false)
                      no_consolidada = true;
                    
                    import_export_anterior = qil.Supplier_Quote__r;
                    contenedor_string_import_export_quote +=qil.Supplier_Quote__c;
                    
                  }
                  
                  if(pending != null && pending.size() > 0)
                  {
                      if(no_consolidada == false)
                      {
                         import_export_anterior.Supplier_Quote_Status__c = 'Consolidated';
                         lista_import_export_to_update.add(import_export_anterior);
                      }
                      else
                      {
                        import_export_anterior.Supplier_Quote_Status__c = 'Approved';
                        lista_import_export_to_update2.add(import_export_anterior);
                      }
                  }
          
                if(lista_import_export_to_update != null && lista_import_export_to_update.size()>0)
                  update lista_import_export_to_update;
                if(lista_import_export_to_update2 != null && lista_import_export_to_update2.size()>0)
                  update lista_import_export_to_update2; 
              }
              
              
              //consulta de los shipment existentes para ver si hay alguno igual
              List<Shipment__c> query_shipments = [select Id, Name, Account_for__c, Supplier_Account__c  from Shipment__c where Inbound_Consolidation_Program__c =: record.Id];
              List<Shipment__c> shipment_insert = new List<Shipment__c>();
              List<Shipment_Line__c> shipment_Lines_insert = new List<Shipment_Line__c>();
              boolean existe_shipment = false;
              for(Shipment__c ship: listado_shipments_para_insertar)
              {
                for(Shipment__c ship_exis : query_shipments)
                {
                  if(ship_exis.Account_for__c == ship.Account_for__c && ship_exis.Supplier_Account__c == ship.Supplier_Account__c)
                  {
                    for(Shipment_Line__c ship_li: listado_shipments_lines_para_insertar)
                    {
                      if(ship_li.Shipment__r == ship)
                      {
                        ship_li.Shipment__r = ship_exis;
                        ship_li.Shipment__c = ship_exis.Id;
                        shipment_Lines_insert.add(ship_li);
                      }
                    }
                    existe_shipment = true;
                    break;
                  }
                }
                
                if(existe_shipment == false)
                {
                  shipment_insert.add(ship);
                  for(Shipment_Line__c ship_li: listado_shipments_lines_para_insertar)
                  {
                    if(ship_li.Shipment__r == ship)
                    {
                      shipment_Lines_insert.add(ship_li);
                    }
                  }
                }
                
                existe_shipment = false;
              }
              
              //insertar shipment y lineas nuevos
              if(shipment_insert != null && shipment_insert.size()>0)
                insert shipment_insert;
              
             if(shipment_Lines_insert   != null && shipment_Lines_insert.size()>0)
             {
                 for(Shipment_Line__c shili: shipment_Lines_insert)
                       shili.Shipment__c = shili.Shipment__r.Id;
                       
                 insert shipment_Lines_insert;
             }
            
             //lista para actualizar los campos de los shipment si todos iguales
             List<Shipment__c> lista_update_shipments = new List<Shipment__c>();
             
             //actualizar y crear shipments consolidation data
             if(linesTypeNumber==2)//import export
             {
               List<Shipment_Consolidation_Data__c> query_shipment_conso_data = [select Id, Name, Shipment__c, Shipments_Program__c, Import_Export_Quote__c from Shipment_Consolidation_Data__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id];
               List<Shipment_Line__c> query_shipment_line = [select Id, Name, Shipment_Consolidation_Data__c,Units_Shipped__c, Shipment__c, Import_Export_Quote__c, Sell_Origin_Amount__c  from Shipment_Line__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id and Import_Export_Quote__c !=: null order by Shipment__c];
               boolean ya_tienen_shipment_consolidation = false;
               integer contador_de_shipments_conso_data = 1;
               string nombre_shipment_anterior ='';
               //vacio de unidades para poder sumar todas
               for(Shipment_Consolidation_Data__c ship_consolidation_data: query_shipment_conso_data)
               {
                ship_consolidation_data.Total_Units_Shipped__c = 0;
                ship_consolidation_data.Total_Product_Value_Shipped__c = 0;
                ship_consolidation_data.Shipments_Program__c = record.Id;
               }
               
               for(Shipment_Line__c ship_li : query_shipment_line)
               {
                 for(Shipment_Consolidation_Data__c ship_consolidation_data: query_shipment_conso_data)
                 {
                   if(ship_li.Shipment__c == ship_consolidation_data.Shipment__c && ship_li.Import_Export_Quote__c == ship_consolidation_data.Import_Export_Quote__c)
                   {
                     ship_consolidation_data.Total_Units_Shipped__c += ship_li.Units_Shipped__c;
                     ship_consolidation_data.Total_Product_Value_Shipped__c += ship_li.Sell_Origin_Amount__c;
                     ship_li.Shipment_Consolidation_Data__r = ship_consolidation_data;// no se si existe todavia
                     ya_tienen_shipment_consolidation = true;
                     break;
                   }
                 }
                 
                 if(ya_tienen_shipment_consolidation == false)
                 {
                   Shipment_Consolidation_Data__c new_shipment_consolidation_data = new Shipment_Consolidation_Data__c();
                   new_shipment_consolidation_data.Name=String.valueOf(contador_de_shipments_conso_data);
                      while(new_shipment_consolidation_data.Name.length()<3)
                          new_shipment_consolidation_data.Name='0'+new_shipment_consolidation_data.Name;
                   contador_de_shipments_conso_data ++;
                   new_shipment_consolidation_data.Total_Units_Shipped__c = ship_li.Units_Shipped__c;
                   new_shipment_consolidation_data.Import_Export_Quote__c = ship_li.Import_Export_Quote__c;
                   new_shipment_consolidation_data.Shipment__c = ship_li.Shipment__c;
                   new_shipment_consolidation_data.Total_Product_Value_Shipped__c = ship_li.Sell_Origin_Amount__c;
                   new_shipment_consolidation_data.Total_Units_Shipped__c = ship_li.Units_Shipped__c;
                   new_shipment_consolidation_data.Shipments_Program__c = record.Id;
                   query_shipment_conso_data.add(new_shipment_consolidation_data);//se añade para que la proxima vuelta lo pueda encontrar
                   ship_li.Shipment_Consolidation_Data__r = new_shipment_consolidation_data;// no existe todavia
                 }
                 
                 ya_tienen_shipment_consolidation = false;
                 if(nombre_shipment_anterior != '' && nombre_shipment_anterior != null && ship_li.Shipment__c != nombre_shipment_anterior)
                   contador_de_shipments_conso_data =1;
                 if(nombre_shipment_anterior == '' || nombre_shipment_anterior == null)
                   contador_de_shipments_conso_data =1;
                 nombre_shipment_anterior = ship_li.Shipment__c;
               }
               
               if(query_shipment_conso_data != null && query_shipment_conso_data.size()>0)
               {
                 upsert query_shipment_conso_data;
                 
                 for(Shipment_Line__c ship_li:  query_shipment_line)// recorro para ponerle los ids
                 {
                   ship_li.Shipment_Consolidation_Data__c = ship_li.Shipment_Consolidation_Data__r.Id;
                 }
                 if(query_shipment_line != null && query_shipment_line.size()>0)
                   update query_shipment_line;
               }
               //----------------------esto no se si es correcto porque si ha modificado el shipment a mano sobrescribir¿?¿?¿?¿
               //ver los campos de la import-export y de las lineas si son todos iguales 
               List<Shipment_Consolidation_Data__c> query_shipment_conso_data2 = [select Id, Name, Import_Export_Quote__r.Service_Mode__c, Shipment__r.Country_of_Load__c, Shipment__r.Country_of_Discharge__c, Shipment__r.Site_of_Discharge__c, Import_Export_Quote__r.Container_Type__c, Import_Export_Quote__r.Nature_Merchandise__c, Import_Export_Quote__r.Vessel_Flight__c, Import_Export_Quote__r.Consignee__c, Import_Export_Quote__r.Consignee_Contact__c, Import_Export_Quote__r.Supplier_Shipper_Contact__c, Shipment__c, Shipment__r.Container_Type__c, Shipment__r.Nature_Merchandise__c, Shipment__r.Truck_Vessel_Flight__c, Shipment__r.Consignee_Contact__c, Shipment__r.Consignee__c, Shipment__r.Shipper_Contact__c, Shipment__r.Sales_Incoterm__c, Shipment__r.Pickup_Cartage__c, Shipment__r.Route__c, Shipment__r.Purchase_Incoterm__c, Shipment__r.Service_Mode__c, Shipment__r.Service_Type__c, Shipment__r.Move_Type__c, Shipment__r.Origin_Address__c, Shipment__r.Destination_Address__c, Import_Export_Quote__r.Destination_Address__c, Import_Export_Quote__r.Origin_Address__c, Import_Export_Quote__r.Move_Type__c, Import_Export_Quote__r.Service_Type__c, Import_Export_Quote__r.Purchase_Incoterm__c , Import_Export_Quote__r.Pickup_Cartage__c, Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c, Import_Export_Quote__r.Supply_Project_Name__c, Import_Export_Quote__r.Route__c, Shipment__r.State_of_Load__c, Shipment__r.State_of_Discharge__c from Shipment_Consolidation_Data__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id order by Shipment__c]; //Shipment__r.Supply_Project__c
               string contenedor_shipments = '';
               
               for(Shipment_Consolidation_Data__c scd: query_shipment_conso_data2)
               {
                 if(contenedor_shipments == '' || contenedor_shipments.contains(scd.Shipment__c) == false)
                 {
                     /*
                        Supplier_Account__c, Account_Destination_Address__c, Account_Origin_Address__c,
                     */
                     
                      if(record.Route__c != null)
                      {
                        scd.Shipment__r.Route__c = record.Route__c;
                        scd.Shipment__r.Country_of_Load__c = record.Route__r.Country_of_Load__c;
                        scd.Shipment__r.State_of_Load__c = record.Route__r.State_of_Load__c;
                        scd.Shipment__r.Site_of_Load__c = record.Route__r.Port_Airport_of_Load__c;
                        
                        scd.Shipment__r.Country_of_Discharge__c = record.Route__r.Country_of_Discharge__c;
                        scd.Shipment__r.State_of_Discharge__c = record.Route__r.State_of_Discharge__c;
                        scd.Shipment__r.Site_of_Discharge__c = record.Route__r.Port_Airport_of_Discharge__c;
                      }
                        
                      if(scd.Shipment__r.Shipper_Contact__c == null)
                        scd.Shipment__r.Shipper_Contact__c = scd.Import_Export_Quote__r.Supplier_Shipper_Contact__c;    
                      if(scd.Shipment__r.Consignee__c == null)
                        scd.Shipment__r.Consignee__c = scd.Import_Export_Quote__r.Consignee__c;     
                      if(scd.Shipment__r.Consignee_Contact__c == null)
                        scd.Shipment__r.Consignee_Contact__c = scd.Import_Export_Quote__r.Consignee_Contact__c;     
                      if(scd.Shipment__r.Truck_Vessel_Flight__c == null)
                        scd.Shipment__r.Truck_Vessel_Flight__c = scd.Import_Export_Quote__r.Vessel_Flight__c;   
                      if(scd.Shipment__r.Nature_Merchandise__c == null)
                        scd.Shipment__r.Nature_Merchandise__c = scd.Import_Export_Quote__r.Nature_Merchandise__c;
                      if(scd.Shipment__r.Container_Type__c == null)
                        scd.Shipment__r.Container_Type__c = scd.Import_Export_Quote__r.Container_Type__c;   
                        
                      /*if(scd.Shipment__r.Supply_Project__c == null) 
                        scd.Shipment__r.Supply_Project__c = scd.Import_Export_Quote__r.Supply_Project_Name__c;*/
                      if(scd.Shipment__r.Sales_Incoterm__c == null)
                        scd.Shipment__r.Sales_Incoterm__c = scd.Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c;
                      if(scd.Shipment__r.Pickup_Cartage__c == null)
                        scd.Shipment__r.Pickup_Cartage__c = scd.Import_Export_Quote__r.Pickup_Cartage__c;    
                      if(scd.Shipment__r.Purchase_Incoterm__c == null)
                        scd.Shipment__r.Purchase_Incoterm__c = scd.Import_Export_Quote__r.Purchase_Incoterm__c;     
                      if(scd.Shipment__r.Service_Mode__c == null)
                        scd.Shipment__r.Service_Mode__c = scd.Import_Export_Quote__r.Service_Mode__c;
                      if(scd.Shipment__r.Service_Type__c == null)
                        scd.Shipment__r.Service_Type__c =  scd.Import_Export_Quote__r.Service_Type__c;
                      if(scd.Shipment__r.Move_Type__c == null)
                        scd.Shipment__r.Move_Type__c = scd.Import_Export_Quote__r.Move_Type__c;
                      if(scd.Shipment__r.Origin_Address__c == null)
                        scd.Shipment__r.Origin_Address__c = scd.Import_Export_Quote__r.Origin_Address__c;
                      if(scd.Shipment__r.Destination_Address__c == null)
                        scd.Shipment__r.Destination_Address__c = scd.Import_Export_Quote__r.Destination_Address__c;
                      contenedor_shipments += scd.Shipment__c;
                      lista_update_shipments.add(scd.Shipment__r);
                 }
                 else
                 {
                   for(Shipment__c ship: lista_update_shipments)
                   {
                     if(ship.Id == scd.Shipment__c)
                     {
                          if(ship.Shipper_Contact__c != scd.Import_Export_Quote__r.Supplier_Shipper_Contact__c)
                            ship.Shipper_Contact__c = null;
                          if(ship.Consignee__c != scd.Import_Export_Quote__r.Consignee__c)
                            ship.Consignee__c = null;
                          if(ship.Consignee_Contact__c != scd.Import_Export_Quote__r.Consignee_Contact__c)
                            ship.Consignee_Contact__c = null;
                          if(ship.Truck_Vessel_Flight__c != scd.Import_Export_Quote__r.Vessel_Flight__c)
                            ship.Truck_Vessel_Flight__c = null;
                          if(ship.Nature_Merchandise__c != scd.Import_Export_Quote__r.Nature_Merchandise__c)
                            ship.Nature_Merchandise__c = null;
                          if(ship.Container_Type__c != scd.Import_Export_Quote__r.Container_Type__c)
                            ship.Container_Type__c = null;  
                        
                          /*if(ship.Supply_Project__c != scd.Import_Export_Quote__r.Supply_Project_Name__c)
                            ship.Supply_Project__c = null;*/
                          if(ship.Sales_Incoterm__c != scd.Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c)
                            ship.Sales_Incoterm__c = null;
                          if(ship.Pickup_Cartage__c != scd.Import_Export_Quote__r.Pickup_Cartage__c)
                            ship.Pickup_Cartage__c = null;  
                          if(ship.Purchase_Incoterm__c != scd.Import_Export_Quote__r.Purchase_Incoterm__c)
                            ship.Purchase_Incoterm__c = null;     
                          if(ship.Service_Mode__c != scd.Import_Export_Quote__r.Service_Mode__c)
                            ship.Service_Mode__c = null;
                          if(ship.Service_Type__c != scd.Import_Export_Quote__r.Service_Type__c)
                            ship.Service_Type__c = null;
                          if(ship.Move_Type__c != scd.Import_Export_Quote__r.Move_Type__c)
                            ship.Move_Type__c = null;
                          if(ship.Origin_Address__c != scd.Import_Export_Quote__r.Origin_Address__c)
                            ship.Origin_Address__c = null;
                          if(ship.Destination_Address__c != scd.Import_Export_Quote__r.Destination_Address__c)
                            ship.Destination_Address__c = null;
                       
                       break;
                     }
                   }
                   
                 }
               }//fin for shipment consolidation data
               
             }
             
             //actualizar shipments  y crear shipments consolidation data customer
             if(linesTypeNumber==1)//customer order
             {
               List<Shipment_Consolidation_Data__c> query_shipment_conso_data = [select Id, Name, Shipment__c, Shopping_Cart__c from Shipment_Consolidation_Data__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id];
               List<Shipment_Line__c> query_shipment_line = [select Id, Name, Shipment_Consolidation_Data__c,Units_Shipped__c, Shipment__c, Customer_Order__c, Sell_Origin_Amount__c  from Shipment_Line__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id and Customer_Order__c !=: null order by Shipment__c];
               boolean ya_tienen_shipment_consolidation = false;
               integer contador_de_shipments_conso_data = 1;
               string nombre_shipment_anterior ='';
               //vacio de unidades para poder sumar todas
               for(Shipment_Consolidation_Data__c ship_consolidation_data: query_shipment_conso_data)
               {
                 ship_consolidation_data.Total_Units_Shipped__c = 0;
                 ship_consolidation_data.Total_Product_Value_Shipped__c = 0;
               }
               
               for(Shipment_Line__c ship_li : query_shipment_line)
               {
                 for(Shipment_Consolidation_Data__c ship_consolidation_data: query_shipment_conso_data)
                 {
                   if(ship_li.Shipment__c == ship_consolidation_data.Shipment__c && ship_li.Customer_Order__c == ship_consolidation_data.Shopping_Cart__c)
                   {
                     ship_consolidation_data.Total_Units_Shipped__c = NEU_Utils.safeDecimal(ship_consolidation_data.Total_Units_Shipped__c) + NEU_Utils.safeDecimal(ship_li.Units_Shipped__c);
                     ship_consolidation_data.Total_Product_Value_Shipped__c += ship_li.Sell_Origin_Amount__c;
                     ship_li.Shipment_Consolidation_Data__r = ship_consolidation_data;// no se si existe todavia
                     ya_tienen_shipment_consolidation = true;
                     break;
                   }
                 }
                 
                 if(ya_tienen_shipment_consolidation == false)
                 {
                   Shipment_Consolidation_Data__c new_shipment_consolidation_data = new Shipment_Consolidation_Data__c();
                   new_shipment_consolidation_data.Name=String.valueOf(contador_de_shipments_conso_data);
                      while(new_shipment_consolidation_data.Name.length()<3)
                          new_shipment_consolidation_data.Name='0'+new_shipment_consolidation_data.Name;
                   contador_de_shipments_conso_data ++;
                   new_shipment_consolidation_data.Total_Units_Shipped__c = ship_li.Units_Shipped__c;
                   new_shipment_consolidation_data.Shopping_Cart__c = ship_li.Customer_Order__c;
                   new_shipment_consolidation_data.Shipment__c = ship_li.Shipment__c;
                   new_shipment_consolidation_data.Total_Product_Value_Shipped__c = ship_li.Sell_Origin_Amount__c;
                   new_shipment_consolidation_data.Total_Units_Shipped__c = ship_li.Units_Shipped__c;
                   query_shipment_conso_data.add(new_shipment_consolidation_data);//se añade para que la proxima vuelta lo pueda encontrar
                   ship_li.Shipment_Consolidation_Data__r = new_shipment_consolidation_data;// no existe todavia
                 }
                 
                 ya_tienen_shipment_consolidation = false;
                 if(nombre_shipment_anterior != '' && nombre_shipment_anterior != null && ship_li.Shipment__c != nombre_shipment_anterior)
                   contador_de_shipments_conso_data =1;
                 if(nombre_shipment_anterior == '' || nombre_shipment_anterior == null)
                   contador_de_shipments_conso_data =1;
                 nombre_shipment_anterior = ship_li.Shipment__c;
               }
               
               if(query_shipment_conso_data != null && query_shipment_conso_data.size()>0)
               {
                 upsert query_shipment_conso_data;
                 
                 for(Shipment_Line__c ship_li:  query_shipment_line)// recorro para ponerle los ids
                 {
                   ship_li.Shipment_Consolidation_Data__c = ship_li.Shipment_Consolidation_Data__r.Id;
                 }
                 if(query_shipment_line != null && query_shipment_line.size()>0)
                   update query_shipment_line;
               }
               
             }
             
             //actualizar shipments y crear shipments consolidation data de la supplier quote order

             if(linesTypeNumber==3)//supplier quote
             {
               List<Shipment_Consolidation_Data__c> query_shipment_conso_data = [select Id, Name, Shipment__c, Supplier_Quote__c from Shipment_Consolidation_Data__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id];
               List<Shipment_Line__c> query_shipment_line = [select Id, Name, Shipment_Consolidation_Data__c,Units_Shipped__c, Shipment__c, Supplier_Quote__c, Sell_Origin_Amount__c  from Shipment_Line__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id and Supplier_Quote__c !=: null order by Shipment__c];
               boolean ya_tienen_shipment_consolidation = false;
               integer contador_de_shipments_conso_data = 1;
               string nombre_shipment_anterior ='';
               //vacio de unidades para poder sumar todas
               for(Shipment_Consolidation_Data__c ship_consolidation_data: query_shipment_conso_data)
               {
                 ship_consolidation_data.Total_Units_Shipped__c = 0;
                 ship_consolidation_data.Total_Product_Value_Shipped__c = 0;
               }
               
               for(Shipment_Line__c ship_li : query_shipment_line)
               {
                 for(Shipment_Consolidation_Data__c ship_consolidation_data: query_shipment_conso_data)
                 {
                   if(ship_li.Shipment__c == ship_consolidation_data.Shipment__c && ship_li.Supplier_Quote__c == ship_consolidation_data.Supplier_Quote__c)
                   {
                     ship_consolidation_data.Total_Units_Shipped__c += ship_li.Units_Shipped__c;
                     ship_consolidation_data.Total_Product_Value_Shipped__c += ship_li.Sell_Origin_Amount__c;
                     ship_li.Shipment_Consolidation_Data__r = ship_consolidation_data;// no se si existe todavia
                     ya_tienen_shipment_consolidation = true;
                     break;
                   }
                 }
                 
                 if(ya_tienen_shipment_consolidation == false)
                 {
                   Shipment_Consolidation_Data__c new_shipment_consolidation_data = new Shipment_Consolidation_Data__c();
                   new_shipment_consolidation_data.Name=String.valueOf(contador_de_shipments_conso_data);
                      while(new_shipment_consolidation_data.Name.length()<3)
                          new_shipment_consolidation_data.Name='0'+new_shipment_consolidation_data.Name;
                   contador_de_shipments_conso_data ++;
                   new_shipment_consolidation_data.Total_Units_Shipped__c = ship_li.Units_Shipped__c;
                   new_shipment_consolidation_data.Supplier_Quote__c = ship_li.Supplier_Quote__c;
                   new_shipment_consolidation_data.Shipment__c = ship_li.Shipment__c;
                   new_shipment_consolidation_data.Total_Product_Value_Shipped__c = ship_li.Sell_Origin_Amount__c;
                   new_shipment_consolidation_data.Total_Units_Shipped__c = ship_li.Units_Shipped__c;
                   query_shipment_conso_data.add(new_shipment_consolidation_data);//se añade para que la proxima vuelta lo pueda encontrar
                   ship_li.Shipment_Consolidation_Data__r = new_shipment_consolidation_data;// no existe todavia
                 }
                 
                 ya_tienen_shipment_consolidation = false;
                 if(nombre_shipment_anterior != '' && nombre_shipment_anterior != null && ship_li.Shipment__c != nombre_shipment_anterior)
                   contador_de_shipments_conso_data =1;
                 if(nombre_shipment_anterior == '' || nombre_shipment_anterior == null)
                   contador_de_shipments_conso_data =1;
                 nombre_shipment_anterior = ship_li.Shipment__c;
               }
               
               if(query_shipment_conso_data != null && query_shipment_conso_data.size()>0)
               {
                 upsert query_shipment_conso_data;
                 
                 for(Shipment_Line__c ship_li:  query_shipment_line)// recorro para ponerle los ids
                 {
                   ship_li.Shipment_Consolidation_Data__c = ship_li.Shipment_Consolidation_Data__r.Id;
                 }
                 if(query_shipment_line != null && query_shipment_line.size()>0)
                   update query_shipment_line;
               }
               
               //ver los campos de la supplier quote y de las lineas si son todos iguales 
               List<Shipment_Consolidation_Data__c> query_shipment_conso_data2 = [select Id, Name, Shipment__c, Shipment__r.Sales_Incoterm__c, Shipment__r.Pickup_Cartage__c, Shipment__r.Route__c, Shipment__r.Purchase_Incoterm__c, Shipment__r.Service_Mode__c, Shipment__r.Move_Type__c, Shipment__r.Origin_Address__c, Shipment__r.Destination_Address__c, Supplier_Quote__r.Receipt_Address__c, Supplier_Quote__r.DeliveryAddress__c, Supplier_Quote__r.Move_Type__c, Supplier_Quote__r.Incoterm__c , Supplier_Quote__r.Delivery_Zone__c, Supplier_Quote__r.Supply_Project__r.Sales_Incoterm__c, Supplier_Quote__r.Supply_Project__c, Supplier_Quote__r.Route__c   from Shipment_Consolidation_Data__c where Shipment__r.Inbound_Consolidation_Program__c =: record.Id order by Shipment__c]; //Shipment__r.Supply_Project__c
               string contenedor_shipments = '';
               
               for(Shipment_Consolidation_Data__c scd: query_shipment_conso_data2)
               {
                 if(contenedor_shipments == '' || contenedor_shipments.contains(scd.Shipment__c) == false)
                 {
                      /*if(scd.Shipment__r.Supply_Project__c == null)
                        scd.Shipment__r.Supply_Project__c = scd.Supplier_Quote__r.Supply_Project__c;*/
                      if(scd.Shipment__r.Sales_Incoterm__c == null)
                        scd.Shipment__r.Sales_Incoterm__c = scd.Supplier_Quote__r.Supply_Project__r.Sales_Incoterm__c;
                      if(scd.Shipment__r.Pickup_Cartage__c == null)
                        scd.Shipment__r.Pickup_Cartage__c = scd.Supplier_Quote__r.Delivery_Zone__c;    
                      if(scd.Shipment__r.Route__c == null)
                        scd.Shipment__r.Route__c = scd.Supplier_Quote__r.Route__c;
                      if(scd.Shipment__r.Purchase_Incoterm__c == null)
                        scd.Shipment__r.Purchase_Incoterm__c = scd.Supplier_Quote__r.Incoterm__c;     
                      if(scd.Shipment__r.Move_Type__c == null)
                        scd.Shipment__r.Move_Type__c = scd.Supplier_Quote__r.Move_Type__c;
                      if(scd.Shipment__r.Origin_Address__c == null)
                        scd.Shipment__r.Origin_Address__c = scd.Supplier_Quote__r.DeliveryAddress__c;
                      if(scd.Shipment__r.Destination_Address__c == null)
                        scd.Shipment__r.Destination_Address__c = scd.Supplier_Quote__r.Receipt_Address__c;
                   contenedor_shipments += scd.Shipment__c;
                   lista_update_shipments.add(scd.Shipment__r);
                 }
                 else
                 {
                   for(Shipment__c ship: lista_update_shipments)
                   {
                     if(ship.Id == scd.Shipment__c)
                     {
                          /*if(ship.Supply_Project__c != scd.Supplier_Quote__r.Supply_Project__c)
                            ship.Supply_Project__c = null;*/
                          if(ship.Sales_Incoterm__c != scd.Supplier_Quote__r.Supply_Project__r.Sales_Incoterm__c)
                            ship.Sales_Incoterm__c = null;
                          if(ship.Pickup_Cartage__c != scd.Supplier_Quote__r.Delivery_Zone__c)
                            ship.Pickup_Cartage__c = null;    
                          if(ship.Route__c != scd.Supplier_Quote__r.Route__c)
                            ship.Route__c = null;
                          if(ship.Purchase_Incoterm__c != scd.Supplier_Quote__r.Incoterm__c)
                            ship.Purchase_Incoterm__c = null; 
                          if(ship.Move_Type__c != scd.Supplier_Quote__r.Move_Type__c)
                            ship.Move_Type__c = null;
                          if(ship.Origin_Address__c != scd.Supplier_Quote__r.DeliveryAddress__c)
                            ship.Origin_Address__c = null;
                          if(ship.Destination_Address__c != scd.Supplier_Quote__r.Receipt_Address__c)
                            ship.Destination_Address__c = null;
                          break;
                     }
                   }
                   
                 }
               }
               
             }
       
             if(lista_update_shipments != null && lista_update_shipments.size()>0)
               update lista_update_shipments;
             
             todo_insertado = true;
      } 
      if(new_filter_date_cabeceras != null && new_filter_date_cabeceras.ETD_from_Point_of_Load__c != null)
        if(new_filter_date_cabeceras.ETD_from_Point_of_Load__c != record.Planned_ETD__c) 
        {
            record.Planned_ETD__c = new_filter_date_cabeceras.ETD_from_Point_of_Load__c;
            update record;
        }
            
      
      return new PageReference('/'+record.Id);
    }
    
    public PageReference applyLines()
    {
      // comprobacion de que se han hecho cambios
      Integer counter=0;
      Boolean ship_lines_distintas_unidades = false;
        if(getLines()!=null)
           for(line_s lines:lines)
           {
              if(lines.selected)
              {
                
                    counter=1;
                    if(linesTypeNumber == 1)
                    if(NEU_Utils.toDecimal(lines.unidades_iniciales) < lines.shopping_line.Units__c && lines.check_full == false)
                    {
                      
                        alertuser='you can´t increase units with field F/L unchecked';
                    return null;
                    }
                    
                    if(linesTypeNumber == 2)
                    if(NEU_Utils.toDecimal(lines.unidades_iniciales) < lines.quote_line.Units__c && lines.check_full == false)
                    {
                        alertuser='you can´t increase units with field F/L unchecked';
                    return null;
                    }
                    
                    if(linesTypeNumber == 3)
                    if(NEU_Utils.toDecimal(lines.unidades_iniciales) < lines.supplier_line.Quantity__c && lines.check_full == false)
                    {
                        alertuser='you can´t increase units with field F/L unchecked';
                    return null;
                    }
              }
           }
           
        if(getLines_update()!=null)
          for(line_s lines:Lines_update)
          {
            if(lines.shipment_line.Units_Shipped__c > NEU_Utils.toDecimal(lines.unidades_iniciales))
            {
              alertuser='you can´t increase units';
                return null;
              break;
            }
            if(lines.shipment_line.Units_Shipped__c < NEU_Utils.toDecimal(lines.unidades_iniciales))
              ship_lines_distintas_unidades = true;
          }
          
        if(counter==0 && ship_lines_distintas_unidades == false)
        { 
            alertuser='You must select one or more lines.';
            return null;
        }
        
        // Listas necesarias
        List<Shipment_Line__c> del_shipment_lines = new List<Shipment_Line__c>();//borrar si no tiene unidades
        List<Quote_Item_Line__c> update_import_export = new List<Quote_Item_Line__c>();//quitar el check si el shipment se borra
        List<Shopping_Cart_line__c> update_custom_or = new List<Shopping_Cart_line__c>();//quitar el check si el shipment se borra
        List<Customer_Quote__c> update_import_export2 = new List<Customer_Quote__c>();//actualizar status si el shipment se borra
        List<Shopping_Cart__c> update_custom_or2 = new List<Shopping_Cart__c>();//actualizar status si el shipment se borra
        List<Supplier_Quote_Line__c> update_supplier_quote = new List<Supplier_Quote_Line__c>();//quitar el check si el shipment se borra
        List<Supplier_Quote__c> update_supplier_quote2 = new List<Supplier_Quote__c>();//actualizar status si el shipment se borra
        Set<Id> update_shipment_cosolidation_data = new Set<Id>();//actualizar unidades si se modifican las unidades de las lineas
        Set<Id> update_shipment_cosolidation_data2 = new Set<Id>();//actualizar unidades si se modifican las unidades de las lineas
        List<Shipment_Line__c> update_shipment_lines = new List<Shipment_Line__c>();//actualizar si cambia de unidades
        
        record.Number_of_Containers__c = TotalNumberCont;
        record.Number_of_Packages__c = TotalNumberBoxes;
        record.Number_of_Pallets__c = TotalNumberPallets;
        record.Total_Gross_Volume_m3__c = Cube;
        record.Total_Gross_Weight_Kg__c = Grossweight;
        if(porc_ocupacion != null && porc_ocupacion != '' && porc_ocupacion != '0')
            record.Last_Container_Load__c = decimal.valueOf(porc_ocupacion.substring(0, porc_ocupacion.length()-1));
        if((container_selected!='0')&&(String.IsNotEmpty(container_selected)))
            record.Pallet_Container_Type__c = container_selected;
        else
            record.Pallet_Container_Type__c = null;
        //------------------ puede que haya que modificar los transport¿?¿?
        if(ship_lines_distintas_unidades == true)
        {
          if(Lines_update != null)
            for(line_s li: Lines_update)
            {
              if(li.shipment_line.Units_Shipped__c < NEU_Utils.toDecimal(li.unidades_iniciales))
              {
                if(NEU_Utils.safeDecimal(li.shipment_line.Units_Shipped__c) == 0)// si estra por aquí se eliminará la linea
                {
                  del_shipment_lines.add(li.shipment_line);//antes de eliminar recorre abajo para restar a las shipment consolidation 
                  update_shipment_cosolidation_data.add(li.shipment_line.Shipment_Consolidation_Data__c);
                  if(linesTypeNumber == 1)
                    if(li.shipment_line.Customer_Order_Line__c != null)
                    {
                      update_custom_or.add(li.shopping_line);
                    }
                  if(linesTypeNumber == 2)
                    if(li.shipment_line.Quote_Item_Line__c != null)
                    {
                      update_import_export.add(li.quote_line);
                    }
                    
                  if(linesTypeNumber == 3)
                      if(li.shipment_line.Supplier_Quote_Line__c != null)
                    {
                      update_supplier_quote.add(li.supplier_line);
                    }
                }
                else
                {
                  update_shipment_lines.add(li.shipment_line);  
                }
              }
            }
        }
        
        //inserciones y  actualizaciones
        update record;
        
        //borrar lineas sobrantes y unidades y actualizar relaciones
        if(del_shipment_lines != null && del_shipment_lines.size()>0)
        {
          List<Shipment_Consolidation_Data__c> query_shipment_consolidation_data = [select Id, Name, Total_Units_Shipped__c, Total_Product_Value_Shipped__c  from Shipment_Consolidation_Data__c where ID IN: update_shipment_cosolidation_data];
          List<Shipment_Line__c> consulta_datos_reales_shipment_line = [select id, Name, Sell_Origin_Amount__c, Units_Shipped__c, Shipment_Consolidation_Data__c from Shipment_Line__c where id IN: del_shipment_lines];
          for(Shipment_Consolidation_Data__c qscd :query_shipment_consolidation_data)
          {
            for(Shipment_Line__c ship_li : consulta_datos_reales_shipment_line)
            {
              if(ship_li.Shipment_Consolidation_Data__c == qscd.Id)
              {
                qscd.Total_Units_Shipped__c = qscd.Total_Units_Shipped__c - ship_li.Units_Shipped__c;
                qscd.Total_Product_Value_Shipped__c = qscd.Total_Product_Value_Shipped__c- ship_li.Sell_Origin_Amount__c;
              }
            }
          }
          
          if(query_shipment_consolidation_data != null && query_shipment_consolidation_data.size()>0)
            update query_shipment_consolidation_data;
          
          
          //actualizar import-export
          if(update_import_export != null && update_import_export.size()>0)
          {
            for(Quote_Item_Line__c qil: update_import_export)
            {
              qil.Consolidated__c = false;
              if(qil.Import_Export_Quote__r.Quotation_Status__c == 'Shipped')
                update_import_export2.add(qil.Import_Export_Quote__r);
                
                
            }
            
            update update_import_export;
            //actualizar estado de la cabecera
            if(update_import_export2 != null && update_import_export2.size()>0)
            {
              for(Customer_Quote__c ieq : update_import_export2)
              {
                ieq.Quotation_Status__c = 'Partially Shipped';
              }
              update update_import_export2;
            }  
          }
          
          //actualizar customer orde
          if(update_custom_or != null && update_custom_or.size()>0)
          {
            for(Shopping_Cart_line__c qil: update_custom_or)
            {
              qil.Consolidated__c = false;
              if(qil.Shopping_Cart__r.Status__c == 'Consolidated')
                update_custom_or2.add(qil.Shopping_Cart__r);
                
                
            }
            
            update update_custom_or;
            //actualizar estado de la cabecera
            if(update_custom_or2 != null && update_custom_or2.size()>0)
            {
              for(Shopping_Cart__c ieq : update_custom_or2)
              {
                ieq.Status__c = 'Close';
              }
              update update_custom_or2;
            }  
          }
          
          
          //actualizar supplier quote
          if(update_supplier_quote != null && update_supplier_quote.size()>0)
          {
            for(Supplier_Quote_Line__c qil: update_supplier_quote)
            {
              qil.Consolidated__c = false;
              if(qil.Supplier_Quote__r.Supplier_Quote_Status__c == 'Consolidated')
                update_supplier_quote2.add(qil.Supplier_Quote__r);
            }
            
            update update_supplier_quote;
            //actualizar estado de la cabecera
            if(update_supplier_quote2 != null && update_supplier_quote2.size()>0)
            {
              for(Supplier_Quote__c ieq : update_supplier_quote2)
              {
                ieq.Supplier_Quote_Status__c = 'Approved';
              }
              update update_supplier_quote2;
            }  
          }
          
          
          
          delete del_shipment_lines;
        }//hasta aqui borrado
        
        update_import_export2 = new List<Customer_Quote__c>();//actualizar status si cambia de unidades
        update_supplier_quote2 = new List<Supplier_Quote__c>();//actualizar status si cambia de unidades
        update_custom_or2 = new List<Shopping_Cart__c>();//actualizar status si cambia de unidades
        
        //actualizar lineas con unidades
        if(update_shipment_lines != null && update_shipment_lines.size()>0)
        {
        List<Shipment_Line__c>lineas_shipment = [select Id, Name, Units_Shipped__c,Shipping_Weight_Kg__c, Shipping_Volume_m3__c, Shipment_Consolidation_Data__c from Shipment_Line__c where id IN:update_shipment_lines]; 
        for(Shipment_Line__c sl: lineas_shipment)
        {
          for(line_s li: Lines_update)
          {
            if(li.shipment_line.Units_Shipped__c < NEU_Utils.toDecimal(li.unidades_iniciales) && li.shipment_line.Units_Shipped__c != 0)
                if(li.shipment_line.Id == sl.Id)
                {
                  if(linesTypeNumber==1)
                  {
                    if(li.shopping_line.Units__c == sl.Units_Shipped__c)
                      splitShoppingCartLine(li.shopping_line.Id,li.shipment_line.Units_Shipped__c);
                    if(li.shopping_line.Shopping_Cart__r.Status__c == 'Consolidated')
                      update_custom_or2.add(li.shopping_line.Shopping_Cart__r);
                  }
                  if(linesTypeNumber==2)
                  {system.debug('holaa'+li.quote_line.Units__c+'hola'+sl.Units_Shipped__c);
                     if(li.quote_line.Units__c == li.quote_line.Supplier_Quote_Line__r.Quantity__c && li.quote_line.Units__c == sl.Units_Shipped__c)
                    {
                      splitSupQuoteLine(li.quote_line.Supplier_Quote_Line__c,li.shipment_line.Units_Shipped__c );
                      system.debug('holaapasa2)');
                    } 
                    if(li.quote_line.Units__c == sl.Units_Shipped__c)
                    {
                      splitQuoteLine(li.quote_line.Id,li.shipment_line.Units_Shipped__c);
                      system.debug('holaapasa)');
                    }
                    id_nueva_linea = null;
                     
                    if(li.quote_line.Import_Export_Quote__r.Quotation_Status__c == 'Shipped')
                      update_import_export2.add(li.quote_line.Import_Export_Quote__r);
                  }
                  if(linesTypeNumber==3)
                  {
                    if(li.supplier_line.Quantity__c == sl.Units_Shipped__c)
                      splitSupQuoteLine(li.supplier_line.Id,li.shipment_line.Units_Shipped__c);
                    if(li.supplier_line.Supplier_Quote__r.Supplier_Quote_Status__c == 'Consolidated')
                      update_supplier_quote2.add(li.supplier_line.Supplier_Quote__r);
                  }
                  update_shipment_cosolidation_data2.add(sl.Shipment_Consolidation_Data__c);
                  sl.Units_Shipped__c = li.shipment_line.Units_Shipped__c;
                  if(NEU_Utils.safeDecimal(sl.Shipping_Weight_Kg__c) != 0)
                    sl.Shipping_Weight_Kg__c = (sl.Shipping_Weight_Kg__c/NEU_Utils.toDecimal(li.unidades_iniciales))*li.shipment_line.Units_Shipped__c;
                  if(NEU_Utils.safeDecimal(sl.Shipping_Volume_m3__c) != 0)
                    sl.Shipping_Volume_m3__c = (sl.Shipping_Volume_m3__c/NEU_Utils.toDecimal(li.unidades_iniciales))*li.shipment_line.Units_Shipped__c;
                  id_nueva_linea = null;
                  break;
                }
          }
          
        }
        // recorrer los shipmens conolidation data para restar las unidades
        if(update_shipment_cosolidation_data2 != null && update_shipment_cosolidation_data2.size()>0)
        {
              List<Shipment_Consolidation_Data__c> query_shipment_consolidation_data = [select Id, Name, Total_Units_Shipped__c, Total_Product_Value_Shipped__c from Shipment_Consolidation_Data__c where ID IN: update_shipment_cosolidation_data2];
              for(line_s li: Lines_update)
              {
                for(Shipment_Consolidation_Data__c qscd :query_shipment_consolidation_data)
                {
                  if(li.shipment_line.Shipment_Consolidation_Data__c == qscd.Id)
                  {
                    qscd.Total_Units_Shipped__c = qscd.Total_Units_Shipped__c - NEU_Utils.toDecimal(li.unidades_iniciales) + li.shipment_line.Units_Shipped__c;
                    if(NEU_Utils.safeDecimal(li.shipment_line.Units_Shipped__c) != 0)
                      qscd.Total_Product_Value_Shipped__c = qscd.Total_Product_Value_Shipped__c - ((li.shipment_line.Sell_Origin_Amount__c/li.shipment_line.Units_Shipped__c)*NEU_Utils.toDecimal(li.unidades_iniciales)) +li.shipment_line.Sell_Origin_Amount__c;
                    else
                      qscd.Total_Product_Value_Shipped__c = qscd.Total_Product_Value_Shipped__c - li.shipment_line.Sell_Origin_Amount__c;
                    break;
                  }
                }
              }
              
              if(query_shipment_consolidation_data != null && query_shipment_consolidation_data.size()>0)
                update query_shipment_consolidation_data;
        }
        
        //hacer efectivos los splits 
         if(lista_update_split_sup != null && lista_update_split_sup.size()>0)
            upsert lista_update_split_sup;
          if(lista_update_split != null && lista_update_split.size()>0)
          {
            for(Quote_Item_Line__c qil: lista_update_split)
                  qil.Supplier_Quote_Line__c = qil.Supplier_Quote_Line__r.Id;
            NEU_StaticVariableHelper.setBoolean1(true);
            insert lista_update_split;
            update lista_update_split2; 
            NEU_StaticVariableHelper.setBoolean1(false);
          }
          
          
        lista_update_split_sup = null;  lista_update_split = null;
      
        if(lineas_shipment != null && lineas_shipment.size()>0)
          update lineas_shipment;
          
        //actualizar estado de la cabecera
        if(update_import_export2 != null && update_import_export2.size()>0)
        {
          for(Customer_Quote__c ieq : update_import_export2)
          {
            ieq.Quotation_Status__c = 'Partially Shipped';
          }
          update update_import_export2;
        }
        
        //actualizar estado de la cabecera
        if(update_custom_or2 != null && update_custom_or2.size()>0)
        {
          for(Shopping_Cart__c ieq : update_custom_or2)
          {
            ieq.Status__c = 'Close';
          }
          update update_import_export2;
        }
        
        //actualizar estado de la cabecera
        if(update_supplier_quote2 != null && update_supplier_quote2.size()>0)
        {
          for(Supplier_Quote__c ieq : update_supplier_quote2)
          {
            ieq.Supplier_Quote_Status__c = 'Approved';
          }
          update update_supplier_quote2;
        }    
          

        }//hasta aqui actualizar
        
        //borrar aqui los shipment conso dat que se queden sin unidades
        List<Shipment_Consolidation_Data__c> query_shipment_consolidation_data = [select Id, Name from Shipment_Consolidation_Data__c where (ID IN: update_shipment_cosolidation_data2 or ID IN:update_shipment_cosolidation_data) and Total_Units_Shipped__c = 0];
        if(query_shipment_consolidation_data != null && query_shipment_consolidation_data.size()>0)
          delete query_shipment_consolidation_data;
    
    
        if(counter != 0)
        {
          applyLines2(counter);
          if(todo_insertado == true)
            return new PageReference('/'+record.Id);
          else
            return null;
        }
        else
          return new PageReference('/'+record.Id);
    }
    
    public void splitQuoteLine(String lineid,decimal units)
    {
        String query='select Id,Name';
        Boolean firstField=true;
        decimal cantidad = 0;
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
                cantidad = lines[0].Units__c;
                if(lista_update_split == null)
                    lista_update_split = new List<Quote_Item_Line__c>();
                if(lista_update_split2 == null)
                    lista_update_split2 = new List<Quote_Item_Line__c>();
                Quote_Item_Line__c newline=lines[0].clone(false,true);
                newline.Units__c= cantidad - units;
                newLine.Consolidated__c=false;
                newLine.Total_Shipping_Weight_Kgs__c = (NEU_Utils.safeDecimal(lines[0].Total_Shipping_Weight_Kgs__c) != 0 ? (lines[0].Total_Shipping_Weight_Kgs__c/cantidad)*(cantidad - units) : 0);
                newLine.Total_Shipping_Volume_m3__c = (NEU_Utils.safeDecimal(lines[0].Total_Shipping_Volume_m3__c) != 0 ? (lines[0].Total_Shipping_Volume_m3__c/cantidad)*(cantidad - units) : 0);
                newLine.Expense_Amount__c =  (NEU_Utils.safeDecimal(lines[0].Expense_Amount__c) != 0 ? (lines[0].Expense_Amount__c/cantidad)*(cantidad - units) : 0);
                newLine.Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 ? (lines[0].Duty__c/cantidad)*(cantidad - units) : 0);
                newLine.Customs_Value__c = (NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0 ? (lines[0].Customs_Value__c/cantidad)*(cantidad - units) : 0);
                newLine.Percent_Duty__c = (NEU_Utils.safeDecimal(newLine.Duty__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Duty__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
                newLine.Sales_Tax__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 ? (lines[0].Sales_Tax__c/cantidad)*(cantidad - units) : 0);
                newLine.Percent_Taxes__c = (NEU_Utils.safeDecimal(newLine.Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Sales_Tax__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
                if(id_nueva_linea != null)
                {
                  newline.Supplier_Quote_Line__r = id_nueva_linea;
                }
                lista_update_split.add(newline);
        
                lines[0].Consolidated__c=true;
                lines[0].Total_Shipping_Weight_Kgs__c = (NEU_Utils.safeDecimal(lines[0].Total_Shipping_Weight_Kgs__c) != 0 ? (lines[0].Total_Shipping_Weight_Kgs__c/lines[0].Units__c)*(units) : 0);
                lines[0].Total_Shipping_Volume_m3__c = (NEU_Utils.safeDecimal(lines[0].Total_Shipping_Volume_m3__c) != 0 ? (lines[0].Total_Shipping_Volume_m3__c/lines[0].Units__c)*(units) : 0);
                lines[0].Expense_Amount__c =  (NEU_Utils.safeDecimal(lines[0].Expense_Amount__c) != 0 ? (lines[0].Expense_Amount__c/lines[0].Units__c)*(units) : 0);
                lines[0].Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 ? (lines[0].Duty__c/lines[0].Units__c)*units : 0);
                lines[0].Customs_Value__c = (NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0 ? (lines[0].Customs_Value__c/lines[0].Units__c)*units : 0);
                lines[0].Percent_Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 && NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(lines[0].Duty__c)/NEU_Utils.safeDecimal(lines[0].Customs_Value__c)*100 : 0);
                lines[0].Sales_Tax__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 ? (lines[0].Sales_Tax__c/lines[0].Units__c)*units : 0);
                lines[0].Percent_Taxes__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(lines[0].Sales_Tax__c)/NEU_Utils.safeDecimal(lines[0].Customs_Value__c)*100 : 0);
                lines[0].Units__c=units;
                lista_update_split2.add(lines[0]);
                
            }           
        }
    }
    
    public void splitShoppingCartLine(String lineid,decimal units)//private
    {
        String query='select Id,Name';
        Boolean firstField=true; //-------------- falta aqui hacer las listas para no hacer el update e insert cada vuelta
        decimal cantidad = 0;
        Map<String,Schema.SObjectField>objectFields=Shopping_Cart_Line__c.getSobjectType().getDescribe().fields.getMap();
        for(String s:objectFields.keySet())
        {
            if((s!='Id')&&(s!='Name'))
                query+=','+s;
        }
        query+=' from Shopping_Cart_Line__c where Id=\''+lineid+'\'';
        List<Shopping_Cart_Line__c>lines=database.query(query);
        if(lines.size()>0)
        {
            if((units>0)&&(units<lines[0].Units__c))
            {
                cantidad = lines[0].Units__c;
                lines[0].Units__c=units;
                lines[0].Consolidated__c=true;
                update lines[0];
                Shopping_Cart_Line__c newline=lines[0].clone(false,true);
                newline.Units__c=cantidad - units;
                newLine.Consolidated__c=false;
                insert newline;
            }       
        }
    }
    
  public void splitSupQuoteLine(String lineid,decimal units)
  {
      String query='select Id,Name';
      Boolean firstField=true;
      decimal cantidad = 0;
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
                
              cantidad = lines[0].Quantity__c;
              Supplier_Quote_Line__c newline=lines[0].clone(false,true);
              newline.Quantity__c=cantidad - units;
              newLine.Consolidated__c=false;
              newLine.Total_Weight_Kg__c = (NEU_Utils.safeDecimal(lines[0].Total_Weight_Kg__c) != 0 ? (lines[0].Total_Weight_Kg__c/cantidad)*(cantidad - units) : 0);
              newLine.Total_Volume_m3__c = (NEU_Utils.safeDecimal(lines[0].Total_Volume_m3__c) != 0 ? (lines[0].Total_Volume_m3__c/cantidad)*(cantidad - units) : 0);
              newLine.Expense_Amount__c =  (NEU_Utils.safeDecimal(lines[0].Expense_Amount__c)  != 0 ? (lines[0].Expense_Amount__c/cantidad)*(cantidad - units) : 0);
              newLine.Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 ? (lines[0].Duty__c/cantidad)*(cantidad - units)  : 0);
              newLine.Customs_Value__c = (NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0 ? (lines[0].Customs_Value__c/cantidad)*(cantidad - units) : 0);
              newLine.Percent_Duty__c = (NEU_Utils.safeDecimal(newLine.Duty__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Duty__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
              newLine.Sales_Tax__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 ? (lines[0].Sales_Tax__c/cantidad)*(cantidad - units) : 0);
              newLine.Percent_Taxes__c = (NEU_Utils.safeDecimal(newLine.Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(newLine.Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(newLine.Sales_Tax__c)/NEU_Utils.safeDecimal(newLine.Customs_Value__c)*100 : 0);
              lista_update_split_sup.add(newline);
              
              lines[0].Consolidated__c=true;
              lines[0].Total_Weight_Kg__c =  (NEU_Utils.safeDecimal(lines[0].Total_Weight_Kg__c) != 0 ? (lines[0].Total_Weight_Kg__c/lines[0].Quantity__c)*(units) : 0);
              lines[0].Total_Volume_m3__c = (NEU_Utils.safeDecimal(lines[0].Total_Volume_m3__c) != 0 ? (lines[0].Total_Volume_m3__c/lines[0].Quantity__c)*(units) : 0);
              lines[0].Expense_Amount__c =  (NEU_Utils.safeDecimal(lines[0].Expense_Amount__c)  != 0 ? (lines[0].Expense_Amount__c/lines[0].Quantity__c)*(units) : 0);
              
              lines[0].Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 ? (lines[0].Duty__c/lines[0].Quantity__c)*units : 0);
              lines[0].Customs_Value__c = (NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0 ? (lines[0].Customs_Value__c/lines[0].Quantity__c)*units : 0);
              lines[0].Percent_Duty__c = (NEU_Utils.safeDecimal(lines[0].Duty__c) != 0 && NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(lines[0].Duty__c)/NEU_Utils.safeDecimal(lines[0].Customs_Value__c)*100 : 0);
              lines[0].Sales_Tax__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 ? (lines[0].Sales_Tax__c/lines[0].Quantity__c)*units : 0);
              lines[0].Percent_Taxes__c = (NEU_Utils.safeDecimal(lines[0].Sales_Tax__c) != 0 && NEU_Utils.safeDecimal(lines[0].Customs_Value__c) != 0  ? NEU_Utils.safeDecimal(lines[0].Sales_Tax__c)/NEU_Utils.safeDecimal(lines[0].Customs_Value__c)*100 : 0);
              lines[0].Quantity__c=units;
                            
              lista_update_split_sup.add(lines[0]);
              id_nueva_linea = newline;
          }      
      }
  }
}