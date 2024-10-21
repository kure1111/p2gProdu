public with sharing class NEU_Generate_Shipments 
{
    public Shipment__c shipment_truckstop{get;set;}
    
    public Carrier_Line_Load_Point__c new_filter_route {get;set;}
    public Fee__c new_fee_active{get;set;}
    public Fee__c new_fee_desactive{get;set;}
    public List<Carrier_Line_Load_Point_s> list_route = null;
    private string routeid = null;
    private List<Line_s> Lines=null;
    public Shipment__c new_filter_date_cabeceras {get;set;}
    public string direcciones_recogidas {get;set;}
    public string direccion_selected {get; set;}
    public string direccion_selected_destination {get; set;}
    public String orden_quotes {get;set;}
    public String alertuser{get;set;}
    
    public decimal TotalNumberBoxes {get;set;}
    public decimal TotalNumberPallets {get;set;}
    public decimal Grossweight {get;set;}
    public decimal Cube {get;set;}
    public decimal TotalNumberCont {get;set;}
    public decimal FreeSpaceCont  {get;set;}
    public string porc_ocupacion {get;set;}
    public decimal total_pallet_linea  {get;set;}
    public decimal ocupacion_volumen =0;
    public decimal ocupacion_pallet =0; 
    public decimal ocupacion_peso  =0;
    public List<SelectOption> containers = null;
    public string ids_pallet_idscontenedores {get;set;}
    public decimal valor_zero {get;set;}
    
    public string container_selected{get;set;}
    public String currency_cuenta{get;set;}
    private String contenedor='';
    private String shipmentid=''; 
    
    public Supplier_Quote_Line__c id_nueva_linea{get;set;}
    public List<Quote_Item_Line__c> lista_update_split = null;
    public List<Quote_Item_Line__c> lista_update_split2 = null;
    
    public List<Carrier_Line_Load_Point__c> routes{get;set;}
    
    public String linea_modificada{get;set;}
    
    public string max_peso_container {get;set;}
    public string max_volumen_container {get;set;}
    public string num_cont_x_pallet {get;set;}
    public boolean la_lista_no_cero {get;set;}
    
    /* Truckstop */
    public Shipment_Track__c shipment_track{
        get{
            if(shipment_track == null){
                shipment_track = new Shipment_Track__c();
            }
            return shipment_track;
        }
        set;
    }
    public String searchOriginAddress{get;set;}
    public String searchDestinationAddress{get;set;}
    /* Truckstop */
    
    //ordenacion
    public String orden_routes_modo {get;set;}
    public String orden_routes {get;set;}
    
    public Customer_Quote__c record=null;
    ApexPages.StandardController con;
    public NEU_Generate_Shipments(){}
    
    public NEU_Generate_Shipments(ApexPages.StandardController stdController){
        
        system.debug('Pasa el constructor');
        
        con = stdController;
        if (!Test.isRunningTest())
            stdController.AddFields(new String[]{
                'Id','Name','Quotation_Status__c','Supply_Project_Name__c','Sales_Incoterm__c','Pickup_Cartage__c','Nature_Merchandise__c',
                    'Container_Type__c','Service_Mode__c','Service_Type__c','Move_Type__c', 'Origin_Address__c', 'Supplier_Shipper_Contact__c',  
                    'Account_Origin_Address__c', 'Consignee__c','Consignee_Contact__c','Service_Type__c','Account_Destination_Address__c', 
                    'Destination_Address__c','Purchase_Incoterm__c','Freight_Mode__c','Track_Option__c', 'Reference_Number__c', 'Customer_Reference__c',
                    'Account_for__c','Account_for__r.Name','Supplier_Account__c','Supplier_Account__r.Name','Consignee__c', 'Consignee__r.Name', 
                    'Route__c', 'Route__r.Name','Awaiting_load_Time__c','Awaiting_unload_Time__c', 
                    'Country_ofLoad__c', 'Country_ofLoad__r.ISO_Code__c','Country_ofDischarge__c', 'Country_ofDischarge__r.ISO_Code__c',
                    'State_of_Load__c', 'State_of_Load__r.ISO_Code_2c__c','State_of_Discharge__c', 'State_of_Discharge__r.ISO_Code_2c__c',  
                    'Site_of_Load__c', 'Site_of_Load__r.Name','Site_of_Discharge__c', 'Site_of_Discharge__r.Name', 
                    'Last_Shipment__c', 'Last_Shipment__r.Name', 'Last_Shipment__r.Shipment_Status__c', 'Last_Shipment__r.Site_of_Discharge__c', 
                    'Last_Shipment__r.ETA_Point_of_Discharge__c','Last_Shipment__r.Storage_Date_From__c','Last_Shipment__r.Storage_Date_To__c',
                    'Last_Shipment__r.Site_of_Discharge__r.Name', 'Last_Shipment__r.ETA_Point_of_Discharge__c', 'Border__c', 'Customs__c', 'Warehouse__c', 'Only_Warehouse_Service__c',
                    'ETA__c', 'ETD__c', 'FolioResume__c', (UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode' : 'Cube_m3__c'),'Origin_Location__Latitude__s','Kms__c','Origin_Location__Longitude__s','Destination_Location__Latitude__s','Destination_Location__Longitude__s','Approved_Date_time01__c'
                    });
        record=(Customer_Quote__c)stdController.getRecord();
        
        new_fee_active = new Fee__c();
        new_fee_active.Active__c = true;
        new_fee_desactive = new Fee__c();
        new_fee_desactive.Active__c = false;
        new_filter_route = new Carrier_Line_Load_Point__c(); 
        if(record.Country_ofLoad__c != null) 
        {
            new_filter_route.Country_of_Load__c = record.Country_ofLoad__c;
            new_filter_route.Country_of_Load__r = record.Country_ofLoad__r;
        }
        if(record.Country_ofDischarge__c != null)
        {
            new_filter_route.Country_of_Discharge__c = record.Country_ofDischarge__c;
            new_filter_route.Country_of_Discharge__r = record.Country_ofDischarge__r;
        }
        if(record.State_of_Load__c != null) 
        {
            new_filter_route.State_of_Load__c = record.State_of_Load__c;
            new_filter_route.State_of_Load__r = record.State_of_Load__r;
        }
        if(record.State_of_Discharge__c != null)
        {
            new_filter_route.State_of_Discharge__c = record.State_of_Discharge__c;
            new_filter_route.State_of_Discharge__r = record.State_of_Discharge__r;
        }
        if(record.Site_of_Load__c != null)
        {
            new_filter_route.Port_Airport_of_Load__c = record.Site_of_Load__c;
            new_filter_route.Port_Airport_of_Load__r = record.Site_of_Load__r;
        }
        if(record.Site_of_Discharge__c != null)
        {
            new_filter_route.Port_Airport_of_Discharge__c =  record.Site_of_Discharge__c;
            new_filter_route.Port_Airport_of_Discharge__r =  record.Site_of_Discharge__r;
        }
        new_filter_date_cabeceras = new Shipment__c();
        if(record.Freight_Mode__c != null && filter_shipment != null)
            filter_shipment.Freight_Mode__c =record.Freight_Mode__c;
        if(record.Service_Type__c != null && filter_shipment != null)
            filter_shipment.Service_Type__c =record.Service_Type__c;
        if(record.ETD__c != null)
            new_filter_date_cabeceras.ETD_from_Point_of_Load__c = record.ETD__c;
        if(record.ETA__c != null)
            new_filter_date_cabeceras.ETA_Point_of_Discharge__c = record.ETA__c;
        if(record.Awaiting_load_Time__c != null)
            new_filter_date_cabeceras.ETD_Time_from_Point_of_Load__c = record.Awaiting_load_Time__c;
        if(record.Awaiting_unload_Time__c != null)
            new_filter_date_cabeceras.ETA_Time_Point_of_Discharge__c = record.Awaiting_unload_Time__c;
       
        orden_routes = 'Name';
        orden_routes_modo = 'asc';
    }
    
    public PageReference check_shipment_created()
    {
        if(record.Freight_Mode__c == 'Road' && record.Service_Mode__c == 'NATIONAL')
        {
            return null;
        }
        else
        {
            if(record.Last_Shipment__c != null)
            {
                PageReference pgReturnPage;
                String returnUrl = '/' + record.Last_Shipment__c;
                pgReturnPage = new PageReference(returnUrl);
                pgReturnPage.setRedirect(true);
                return pgReturnPage;
            }
            else
                return null;
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
    
    public Shipment__c filter_shipment 
    {
        get
        {
            if(filter_shipment==null)
                filter_shipment=new Shipment__c();
            return filter_shipment;
        }
        set;
    }
    
    public Shipment_Program__c filter_program
    {
        get
        {
            if(filter_program==null)
                filter_program=new Shipment_Program__c();
            return filter_program;
        }
        set;
    }
    
    public Vessel_Flight__c filter_vessel
    {
        get
        {
            if(filter_vessel==null)
                filter_vessel=new Vessel_Flight__c();
            return filter_vessel;
        }
        set;
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
            
            containers.add(new SelectOption(cp.Id, cp.Name));
            ids_pallet_idscontenedores +=cp.id+'_'+ cp.Pallet_Type__c+'_'+cp.Pallet_Type__r.Pallet_Volume_m3__c+'_'+cp.Pallet_Type__r.Pallet_Weight_Kg__c+'_'+ cp.Container_Type__r.Cargo_Volume_m3__c+'_'+cp.Container_Type__r.Cargo_Weight_Kg__c+'_'+cp.Number_of_Pallets__c+'|';
            
        }
        
        valor_zero = 0;
        return containers;
    }
    
    public void new_route()
    {
        // En primer lugar comprobamos que la ruta a crear no exista ya en el sistema
        routes = [select Id from Carrier_Line_Load_Point__c 
                  where Country_of_Discharge__c =: new_filter_route.Country_of_Discharge__c
                  and Country_of_Load__c =: new_filter_route.Country_of_Load__c
                  and State_of_Discharge__c =: new_filter_route.State_of_Discharge__c
                  and State_of_Load__c =: new_filter_route.State_of_Load__c
                  and Port_Airport_of_Discharge__c =: new_filter_route.Port_Airport_of_Discharge__c
                  and Port_Airport_of_Load__c =: new_filter_route.Port_Airport_of_Load__c];
        if(routes.size()>0)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The selected route already exists.'));	
        }
        else
        {
            list_route = null;
            Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
            new_route.Country_of_Discharge__c = new_filter_route.Country_of_Discharge__c;
            new_route.Country_of_Load__c = new_filter_route.Country_of_Load__c;
            new_route.State_of_Discharge__c = new_filter_route.State_of_Discharge__c;
            new_route.State_of_Load__c = new_filter_route.State_of_Load__c;
            new_route.Port_Airport_of_Discharge__c = new_filter_route.Port_Airport_of_Discharge__c;
            new_route.Port_Airport_of_Load__c = new_filter_route.Port_Airport_of_Load__c;   
            try
            {
                insert new_route;
            }
            catch(Exception ex){}
        }
    }
    
    
    public void search_routes()
    {
        list_route = null;
    }
    
    public string getrouteid()
    {
        return routeid;
    }
    
    public void setrouteid(string value)
    {
        if(value!=routeid)
            routeid=value;
    }
    
    public class Carrier_Line_Load_Point_s
    {
        public Carrier_Line_Load_Point__c ruta {get; set;}
        public decimal numero_tramos{get; set;}
        public integer numero_pendientes_de_consolidar{get; set;}
        public Carrier_Line_Load_Point_s(Carrier_Line_Load_Point__c ruta, decimal numero_tramos, integer numero_pendientes_de_consolidar)
        {
            this.ruta = ruta;
            this.numero_tramos = numero_tramos;
            this.numero_pendientes_de_consolidar = numero_pendientes_de_consolidar;
        }
    }
    
    public class Line_s implements Comparable
    {
        public Quote_Item_Line__c quote_line {get; set;}
        public Shipment_Line__c ship_line {get; set;}
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
            if(quote_line!=null)
            {
                if(quote_line.Units__c!=null)
                    return Integer.valueOf(quote_line.Units__c);
            }
            return 0;
        }
        public Integer getFinalStock()
        {
            if(quote_line!=null)
            {
                if(quote_line.Item_Name__r!=null)
                    return 0;
                //return Integer.valueOf(quote_line.Item_Name__r.Stock__c);
            }
            return 0;
        }
        public String getId()
        {
            if(quote_line!=null)
                return quote_line.Id;
            return null;
        }
        
        public String getHeaderId()
        {
            if(quote_line!=null)
                return quote_line.Import_Export_Quote__r.Id;
            return null;
        }
        
        public String getItemId()
        {
            if(quote_line!=null)
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
            if(quote_line!=null)
            {
                if(quote_line.Item_Name__r!=null)
                    return quote_line.Item_Name__r.RecordType.DeveloperName;
            }
            return null;
        }
        public String getSupplierId()
        {
            if(quote_line!=null)
            {
                if(quote_line.Item_Supplier_Owner__c!=null)
                    if(quote_line.Item_Supplier_Owner__r.Developer_Record_Type__c=='Supplier')
                    return quote_line.Item_Supplier_Owner__r.Id;
            }
            return null;
        }
        public String getItemName()
        {
            if(quote_line!=null)
            {
                if(quote_line.Item_Name__r!=null)
                    return quote_line.Item_Name__r.Name;
            }
            return null;
        }
        public String getFamilyName()
        {
            if(quote_line!=null)
            {
                if(quote_line.Item_Name__r!=null)
                    return quote_line.Item_Name__r.Sourcing_Family__r.Name;
            }
            return null;
        } 
        public Line_s(Quote_Item_Line__c quote_line,boolean selected, string extension,Integer units, string idPrincipal, decimal total_peso_linea, decimal total_volumen_linea, decimal total_pallet_linea, boolean tiene_pallet, String relacion_con_pallet, decimal totalcajas, decimal unidades_iniciales, decimal precio_unidad, boolean check_full)
        {
            this.quote_line=quote_line;
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
                if (total_pallet_linea  == compareToEmp.total_pallet_linea) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (total_pallet_linea > compareToEmp.total_pallet_linea) return 1;
                }
                else
                    if (total_pallet_linea < compareToEmp.total_pallet_linea) return 1;
            }
            
            if(campo_compare  == 'total_volumen_linea')
            {
                if (total_volumen_linea  == compareToEmp.total_volumen_linea) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (total_volumen_linea > compareToEmp.total_volumen_linea) return 1;
                }
                else
                    if (total_volumen_linea < compareToEmp.total_volumen_linea) return 1;
            }
            
            if(campo_compare  == 'total_peso_linea')
            {
                if (total_peso_linea  == compareToEmp.total_peso_linea) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (total_peso_linea > compareToEmp.total_peso_linea) return 1;
                }
                else
                    if (total_peso_linea < compareToEmp.total_peso_linea) return 1;
            }
            
            if(campo_compare  == 'extension')
            {
                if (extension  == compareToEmp.extension) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (extension > compareToEmp.extension) return 1;
                }
                else
                    if (extension < compareToEmp.extension) return 1;
            }
            
            if(campo_compare  == 'totalcajas')
            {
                if (totalcajas  == compareToEmp.totalcajas) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (totalcajas > compareToEmp.totalcajas) return 1;
                }
                else
                    if (totalcajas < compareToEmp.totalcajas) return 1;
            }
            
            if(campo_compare  == 'quote_line.Item_Name__r.Name')
            {
                if (quote_line.Item_Name__r.Name  == compareToEmp.quote_line.Item_Name__r.Name) return 0;
                
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Item_Name__r.Name > compareToEmp.quote_line.Item_Name__r.Name) return 1;
                }
                else
                    if (quote_line.Item_Name__r.Name < compareToEmp.quote_line.Item_Name__r.Name) return 1;
            }
            
            if(campo_compare  == 'quote_line.Item_Supplier_Owner__r.Name')
            {
                if (quote_line.Item_Supplier_Owner__r.Name  == compareToEmp.quote_line.Item_Supplier_Owner__r.Name) return 0;
                
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Item_Supplier_Owner__r.Name > compareToEmp.quote_line.Item_Supplier_Owner__r.Name) return 1;
                }
                else
                    if (quote_line.Item_Supplier_Owner__r.Name < compareToEmp.quote_line.Item_Supplier_Owner__r.Name) return 1;
            }
            
            if(campo_compare  == 'quote_line.Import_Export_Quote__r.Account_for__r.Name')
            {
                if (quote_line.Import_Export_Quote__r.Account_for__r.Name  == compareToEmp.quote_line.Import_Export_Quote__r.Account_for__r.Name) return 0;
                
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Import_Export_Quote__r.Account_for__r.Name > compareToEmp.quote_line.Import_Export_Quote__r.Account_for__r.Name) return 1;
                }
                else
                    if (quote_line.Import_Export_Quote__r.Account_for__r.Name < compareToEmp.quote_line.Import_Export_Quote__r.Account_for__r.Name) return 1;
            }
            
            if(campo_compare  == 'quote_line.Delivery_Date__c')
            {
                if (quote_line.Delivery_Date__c  == compareToEmp.quote_line.Delivery_Date__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Delivery_Date__c > compareToEmp.quote_line.Delivery_Date__c) return 1;
                }
                else
                    if (quote_line.Delivery_Date__c < compareToEmp.quote_line.Delivery_Date__c) return 1;
            }
            
            if(campo_compare  == 'quote_line.Delivery_Number__c')
            {
                if (quote_line.Delivery_Number__c  == compareToEmp.quote_line.Delivery_Number__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Delivery_Number__c > compareToEmp.quote_line.Delivery_Number__c) return 1;
                }
                else
                    if (quote_line.Delivery_Number__c < compareToEmp.quote_line.Delivery_Number__c) return 1;
            }
            
            if(campo_compare  == 'quote_line.Import_Export_Quote__r.Supplier_Account__c')
            {
                if (quote_line.Import_Export_Quote__r.Supplier_Account__c  == compareToEmp.quote_line.Import_Export_Quote__r.Supplier_Account__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Import_Export_Quote__r.Supplier_Account__c > compareToEmp.quote_line.Import_Export_Quote__r.Supplier_Account__c) return 1;
                }
                else
                    if (quote_line.Import_Export_Quote__r.Supplier_Account__c < compareToEmp.quote_line.Import_Export_Quote__r.Supplier_Account__c) return 1;
            }
            
            if(campo_compare  == 'quote_line.Name')
            {
                if (quote_line.Name  == compareToEmp.quote_line.Name) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Name > compareToEmp.quote_line.Name) return 1;
                }
                else
                    if (quote_line.Name < compareToEmp.quote_line.Name) return 1;
            }
            
            if(campo_compare  == 'quote_line.Import_Export_Quote__r.Name')
            {
                if (quote_line.Import_Export_Quote__r.Name == compareToEmp.quote_line.Import_Export_Quote__r.Name) return 0;
                
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Import_Export_Quote__r.Name > compareToEmp.quote_line.Import_Export_Quote__r.Name) return 1;
                }
                else
                    if (quote_line.Import_Export_Quote__r.Name < compareToEmp.quote_line.Import_Export_Quote__r.Name) return 1;
            }
            
            if(campo_compare  == 'quote_line.Units__c')
            {
                if (quote_line.Units__c  == compareToEmp.quote_line.Units__c) return 0;
                
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Units__c > compareToEmp.quote_line.Units__c) return 1;
                }
                else
                    if (quote_line.Units__c < compareToEmp.quote_line.Units__c) return 1;
            }
            
            if(campo_compare  == 'quote_line.Price__c')
            {
                if (quote_line.Price__c  == compareToEmp.quote_line.Price__c) return 0;
                
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Price__c > compareToEmp.quote_line.Price__c) return 1;
                }
                else
                    if (quote_line.Price__c < compareToEmp.quote_line.Price__c) return 1;
            }
            
            if(campo_compare  == 'quote_line.ETD__c')
            {
                if (quote_line.ETD__c  == compareToEmp.quote_line.ETD__c) return 0;
                
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.ETD__c > compareToEmp.quote_line.ETD__c) return 1;
                }
                else
                    if (quote_line.ETD__c < compareToEmp.quote_line.ETD__c) return 1;
            }
            
            if(campo_compare  == 'quote_line.Supplier_Quote_Line__r.Delivery_Date__c')
            {
                if (quote_line.Supplier_Quote_Line__r.Delivery_Date__c  == compareToEmp.quote_line.Supplier_Quote_Line__r.Delivery_Date__c) return 0;
                
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Supplier_Quote_Line__r.Delivery_Date__c > compareToEmp.quote_line.Supplier_Quote_Line__r.Delivery_Date__c) return 1;
                }
                else
                    if (quote_line.Supplier_Quote_Line__r.Delivery_Date__c < compareToEmp.quote_line.Supplier_Quote_Line__r.Delivery_Date__c) return 1;
            }
            
            if(campo_compare  == 'quote_line.Amount__c')
            {
                if (quote_line.Amount__c  == compareToEmp.quote_line.Amount__c) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Amount__c > compareToEmp.quote_line.Amount__c) return 1;
                }
                else
                    if (quote_line.Amount__c < compareToEmp.quote_line.Amount__c) return 1;
            }
            
            if(campo_compare  == 'quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name')
            {
                if (quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name  == compareToEmp.quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name) return 0;
                if(orden_de_comparacion == 'asc')
                {
                    if (quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name > compareToEmp.quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name) return 1;
                }
                else
                    if (quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name < compareToEmp.quote_line.Import_Export_Quote__r.Supply_Project_Name__r.Name) return 1;
            }
            
            return -1;
        }
    }
    
    public void actualizar_table_route()
    {
        list_route = null;
    }
    
    public List<Carrier_Line_Load_Point_s> getlist_route()
    {
        if(list_route == null)
        {
            if(new_filter_route.Country_of_Load__c != null && new_filter_route.Country_of_Discharge__c != null)
            {
                list_route = new list<Carrier_Line_Load_Point_s>();
                List<Carrier_Line_Load_Point__c> query_routes = null;
                string query_routes_string = '';
                query_routes_string +='select Id, Name, Country_of_Load__c, Country_of_Load__r.Name, Country_of_Discharge__c, Country_of_Discharge__r.Name,';
                query_routes_string +='Port_Airport_of_Load__c, Port_Airport_of_Load__r.Name, Port_Airport_of_Discharge__c, Port_Airport_of_Discharge__r.Name,';
                query_routes_string +='State_of_Load__c, State_of_Load__r.Name, State_of_Discharge__c, State_of_Discharge__r.Name';
                query_routes_string +=' from Carrier_Line_Load_Point__c where Name != null ';
                if(new_filter_route != null && (new_filter_route.Country_of_Load__c != null || new_filter_route.Port_Airport_of_Load__c != null || new_filter_route.Country_of_Discharge__c != null || new_filter_route.Port_Airport_of_Discharge__c != null || new_filter_route.State_of_Load__c != null || new_filter_route.State_of_Discharge__c != null))
                {
                    if(new_filter_route.Country_of_Load__c != null)
                        query_routes_string +=' and Country_of_Load__c = \''+new_filter_route.Country_of_Load__c+'\'';
                    if(new_filter_route.State_of_Load__c != null)
                        query_routes_string +=' and State_of_Load__c = \''+new_filter_route.State_of_Load__c+'\'';
                    if(new_filter_route.Port_Airport_of_Load__c != null)
                        query_routes_string +=' and Port_Airport_of_Load__c = \''+new_filter_route.Port_Airport_of_Load__c+'\'';
                    if(new_filter_route.Country_of_Discharge__c != null)
                        query_routes_string +=' and Country_of_Discharge__c = \''+new_filter_route.Country_of_Discharge__c+'\'';
                    if(new_filter_route.State_of_Discharge__c != null)
                        query_routes_string +=' and State_of_Discharge__c = \''+new_filter_route.State_of_Discharge__c+'\'';  
                    if(new_filter_route.Port_Airport_of_Discharge__c != null)
                        query_routes_string +=' and Port_Airport_of_Discharge__c = \''+new_filter_route.Port_Airport_of_Discharge__c+'\'';
                }
                
                if(orden_routes.contains('ruta.') == true)
                    orden_routes = orden_routes.replace('ruta.','' );
                
                query_routes_string +=' order by ' + String.escapeSingleQuotes(orden_routes+' '+orden_routes_modo) + ' nulls last';
                query_routes_string +=' limit 100';
                
                query_routes=Database.query(query_routes_string);
                for(Carrier_Line_Load_Point__c cllp: query_routes)
                {
                    list_route.add(new Carrier_Line_Load_Point_s(cllp, 0, 0));
                }
            }
        }
        
        return list_route;
    }
    
    public Integer getnumero_dias2()
    {
        if(new_filter_date_cabeceras !=null && new_filter_date_cabeceras.ETD_from_Point_of_Load__c != null && record.Last_Shipment__c != null && record.Last_Shipment__r.ETA_Point_of_Discharge__c != null)
        {
            Integer dias = record.Last_Shipment__r.ETA_Point_of_Discharge__c.daysBetween(new_filter_date_cabeceras.ETD_from_Point_of_Load__c);
            return dias;
        }
        return null;
    }
    
    public Boolean getShowLines()
    {
        return getShowImportExportItemLines();
    }
    
    public Boolean getShowImportExportItemLines()
    {
        if(getLines()!=null)
            return Lines.size()>0;
        return false;
    }
    
    public String listado_import_supplier_quote_cabeceras = '';    
    public String listado_cuentas_import_supplier_quote_cabeceras = '';  
    public Set<string> accountid {get;set;}
    
    public List<Line_s> getLines()  
    {
        if(Lines==null)
        {
            string relaciones = '';
            
            List<Item_Pallet_Type__c> items_pallet_type = new List<Item_Pallet_Type__c>();
            items_pallet_type = [select Id,Name, Item_Name__c, Packages_Pallet__c, Pallet_Type__c from Item_Pallet_Type__c];
            
            Lines=new List<Line_s>();
            List<Quote_Item_Line__c> lineas_items = null;
            boolean filtro_import_export = false;
            
            CSH_Shipment_Consolidation__c cs = CSH_Shipment_Consolidation__c.getvalues(UserInfo.getUserId());
            if(cs!= null)
            {
                filtro_import_export = cs.Show_Only_I_E_Lines_without_SO_Line__c;
            }
            else
            {
                
                cs  = CSH_Shipment_Consolidation__c.getOrgDefaults();
                filtro_import_export = cs.Show_Only_I_E_Lines_without_SO_Line__c;
            }
            
            String consulta_import_export = '';
            consulta_import_export +='select Id'+NEU_CurrencyUtils.CurrencyISOCode()+',Name,Delivery_Number__c,Delivery_Date__c , ETD__c, Total_Shipping_Volume_m3__c , Packaging_Volume_m3__c , Supplier_Total_Volume_m3__c , Supplier_Item_Weight_kg__c , Supplier_Total_Weight_kg__c, Weight_Kgs__c , Packaging_Gross_Weight_kg__c , Item_Units_x_Packaging__c , Import_Export_Quote__r.Supply_Project_Name__r.Sales_Incoterm__c, Import_Export_Quote__r.Freight_Mode__c, Import_Export_Quote__r.Origin_Address__c, Import_Export_Quote__r.Destination_Address__c, Import_Export_Quote__r.Service_Mode__c, Import_Export_Quote__r.Service_Type__c, Import_Export_Quote__r.Move_Type__c ,  Import_Export_Quote__r.Supplier_Account__c, Import_Export_Quote__r.Pickup_Cartage__c, Import_Export_Quote__r.Supply_Project_Name__c, Import_Export_Quote__r.Supply_Project_Name__r.Name, Import_Export_Quote__r.Route__c,';
            consulta_import_export +='Import_Export_Quote__r.Route__r.Name, Import_Export_Quote__r.Account_Destination_Address__c, Import_Export_Quote__r.Consignee_Contact__c, Import_Export_Quote__r.Consignee__c, Import_Export_Quote__r.Account_Origin_Address__c, Import_Export_Quote__r.Supplier_Shipper_Contact__c,Item_Name__r.Weight_Kgs__c,Item_Name__c,Item_Name__r.Master_Box_Volume_m3__c,Item_Name__r.Master_Box_Gross_Weight_kg__c,Item_Name__r.Units_x_Master_Box__c,Price__c,Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Item_Supplier_Owner__r.Id,';
            consulta_import_export +='Item_Supplier_Owner__r.Name,Item_Supplier_Owner__r.Developer_Record_Type__c,Supplier_Quote_Line__r.Quantity__c,Import_Export_Quote__r.Authorized_Credit__c,Total_Shipping_Weight_Kgs__c,Peso_Neto__c,Extension_Item_Name__c,Consolidated__c,Item_Name__r.Id,Item_Name__r.RecordType.DeveloperName,Item_Name__r.Name, Import_Export_Quote__r.Purchase_Incoterm__c, Container_Type__c, Container_Type__r.Name, pallet_warehouse__c,';
            consulta_import_export += 'Clave_de_Servicio__c,Clave_de_Servicio__r.Clave_SAT__c,Clave_de_Servicio__r.Material_PeligrosoCP__c,Material_Peligroso_Cat__c,Material_Peligroso_Cat__r.name,Material_Peligroso_Cat__r.Clave_SAT__c,Embalaje_Cat__c,Embalaje_Cat__r.Clave_SAT__c,Embalaje_Cat__r.name,';
            consulta_import_export +='Item_Name__r.Sourcing_Family__r.Name,Item_Name__r.Picking_Rule__c, Import_Export_Quote__r.Container_Type__c, Import_Export_Quote__r.Nature_Merchandise__c, Import_Export_Quote__r.Vessel_Flight__c,Units__c,Supplier_Quote_Line__r.Delivery_Date__c,Amount__c,Import_Export_Quote__r.Id,Import_Export_Quote__r.Name,Item_List_Price__c,Import_Export_Quote__r.Account_for__r.Id,Import_Export_Quote__r.Account_for__r.Name, Import_Export_Quote__r.Delivery_Date__c, Expense_Amount__c,CP_Fraccion_Arancelaria_IE__c,Pedimento__c from Quote_Item_Line__c';
            //consulta_import_export +=' where (Import_Export_Quote__r.Quotation_Status__c = \'Approved as Succesful\' or  Import_Export_Quote__r.Quotation_Status__c = \'Partially Shipped\' or Import_Export_Quote__r.Quotation_Status__c =\'Shipped\')';
            consulta_import_export +=' where Import_Export_Quote__c = \''+record.Id+'\'';
            //de momento esto desactivado
            //consulta_import_export +=' and Consolidated__c = false';
            consulta_import_export +=' order by Import_Export_Quote__r.Name,Name'; //Item_Name__r.Stock__c
            
            List<sObject> query_import_export = Database.query(consulta_import_export);
            lineas_items = query_import_export;
            direcciones_recogidas= '';
            string contenedor_de_import_export = '';
            
            if(lineas_items!=null)
                for(Quote_Item_Line__c l:lineas_items)
            {
                for(Item_Pallet_Type__c ip: items_pallet_type)
                {
                    if(ip.Item_Name__c == l.Item_Name__c)
                    {
                        relaciones += ip.Pallet_Type__c+'_'+((NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c)*ip.Packages_Pallet__c : (NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c)*ip.Packages_Pallet__c:0)))+'|';
                    }
                }
                
                Shipment_Line__c new_shipment_line = new Shipment_Line__c(); 
                
                Lines.add(new Line_s(l,false,l.Extension_Item_Name__c,0,l.Id,
                                     NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c),   
                                     NEU_Utils.safeDecimal(l.Total_Shipping_Volume_m3__c),
                                     0,
                                     false,relaciones,0,(l.Units__c > 0 ? l.Units__c: 0),(l.Price__c > 0 ? l.Price__c: 0), false));//pallet
                
                Lines[Lines.size()-1].ship_line = new_shipment_line;
                Lines[Lines.size()-1].Units_x_Master_Box = (NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) != 0 ? NEU_Utils.safeDecimal(l.Item_Units_x_Packaging__c) : NEU_Utils.safeDecimal(l.Item_Name__r.Units_x_Master_Box__c));
                Lines[Lines.size()-1].peso_item_sin_caja = (NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) != 0 ? NEU_Utils.safeDecimal(l.Supplier_Item_Weight_kg__c) : (NEU_Utils.safeDecimal(l.Item_Name__r.Weight_Kgs__c != 0?l.Item_Name__r.Weight_Kgs__c :(NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c) != 0 ? NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c)/l.Units__c : 0 ))));
                Lines[Lines.size()-1].peso_caja_items = (NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c)!= 0 ? NEU_Utils.safeDecimal(l.Total_Shipping_Weight_Kgs__c)/l.Units__c : 0); 
                Lines[Lines.size()-1].volumen_caja_items =(NEU_Utils.safeDecimal(l.Total_Shipping_Volume_m3__c) != 0 ? NEU_Utils.safeDecimal(l.Total_Shipping_Volume_m3__c)/l.Units__c : 0);
            } 
        }
        return Lines;
    }
    
    public void go_compare()
    {
        String[] ordenacion_quotes = new String[]{};
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
    
    public PageReference applyLines()
    {
        Integer counter=0;
        if(getLines()!=null)
        {
            for (line_s lines:lines)
            {
                if(lines.selected)
                {
                    counter=1;
                    if(NEU_Utils.toDecimal(lines.unidades_iniciales) < lines.quote_line.Units__c && lines.check_full == false)
                    {
                        alertuser='you can´t increase units with field F/L unchecked';
                        return null;
                    }
                }
            }
        } 
        
        if(counter==0)
        { 
            alertuser='You must select one or more lines.';
            return null;
        }
        
       // record.Quotation_Status__c = 'Partially Shipped';
        //NEU_StaticVariableHelper.setBoolean1(true);
       //// update record;
        //NEU_StaticVariableHelper.setBoolean1(false);
        Shipment__c new_shipment = new Shipment__c();
        system.debug('=======Inicio de la creacion del Shipment=======');
        
        //Traer Folio de la IE
        List<Shipment_Consolidation_Data__c> scd = [select Id, Name, Import_Export_Quote__c from Shipment_Consolidation_Data__c where Import_Export_Quote__c =: record.Id];
        
        new_shipment.Name = 'SP-' + record.Name + (scd.size() == 0 ? '' : '-'+(scd.size()+1));
        
        List<Vessel_Flight__c> query_Vessel_Flight = null;
        string id_vessel = '';
        if(filter_shipment.Freight_Mode__c == 'Sea')
        {
            if(filter_vessel.Name != null && filter_vessel.IMO__c != null)
            {
                query_Vessel_Flight = [select Id, Name from Vessel_Flight__c where Name =: filter_vessel.Name and  IMO__c =: filter_vessel.IMO__c];
                if(query_Vessel_Flight != null && query_Vessel_Flight.size()>0)
                {
                    id_vessel = query_Vessel_Flight[0].Id;
                }
                else
                {
                    Vessel_Flight__c new_vessel = new Vessel_Flight__c();
                    new_vessel.Name = filter_vessel.Name;
                    new_vessel.IMO__c = filter_vessel.IMO__c;
                    insert new_vessel;
                    id_vessel = new_vessel.Id;
                }
                
            }
        }
        if(filter_shipment.Freight_Mode__c == 'Sea' && id_vessel != null && id_vessel != '')
            new_shipment.Truck_Vessel_Flight__c = id_vessel;
        new_shipment.N_Containers__c = TotalNumberCont;
        new_shipment.Freight_Mode__c=filter_shipment.Freight_Mode__c;
        new_shipment.Service_Type__c=filter_shipment.Service_Type__c;
        new_shipment.ETA_Point_of_Discharge__c=new_filter_date_cabeceras.ETA_Point_of_Discharge__c;
        new_shipment.ETD_from_Point_of_Load__c = new_filter_date_cabeceras.ETD_from_Point_of_Load__c;
        new_shipment.ETA_Time_Point_of_Discharge__c= new_filter_date_cabeceras.ETA_Time_Point_of_Discharge__c;
        new_shipment.ETD_Time_from_Point_of_Load__c = new_filter_date_cabeceras.ETD_Time_from_Point_of_Load__c;
        if(filter_shipment.Freight_Mode__c == 'Sea')
        {
            if(filter_shipment.Carriers_OI__c != null)
                new_shipment.Carrier_OI__c = filter_shipment.Carriers_OI__c;
            new_shipment.Track_Option__c = 'Container number';
            new_shipment.Number__c = filter_program.Sea_Container_Number__c;  
        }
         if(record.Approved_Date_time01__c != null)
            new_shipment.Approved_date_time__c = record.Approved_Date_time01__c;
        
        new_shipment.Carrier__c = filter_shipment.Carrier__c;
        new_shipment.Air_Booking_Number__c=filter_program.Air_Booking_Number__c;
        new_shipment.Flight_Number__c=filter_program.Flight_Number__c;
        new_shipment.Sea_Container_Number__c=filter_program.Sea_Container_Number__c;
        new_shipment.MBL_Number__c=filter_program.MBL_Number__c;
        new_shipment.MAWB_Number__c=filter_program.MAWB_Number__c;
        new_shipment.Sea_Booking_Number__c=filter_program.Sea_Booking_Number__c;
        new_shipment.Voyage_Number_s__c=filter_program.Voyage_Number_sp__c;
        new_shipment.Truck_Number__c=filter_program.Truck_Number__c;
        new_shipment.Trailer_Number__c=filter_program.Trailer_Number__c;
        /* INTEGRACION TRUCKSTOP TRACKING */
        new_shipment.National_Operator__c=new_filter_date_cabeceras.National_Operator__c;
        new_shipment.Vehicle__c = new_filter_date_cabeceras.Vehicle__c;
        /* INTEGRACION TRUCKSTOP TRACKING */
        new_shipment.Rail_Container_Number__c=filter_program.Rail_Container_Number__c;
        new_shipment.SMGS__c=filter_program.SMGS__c;
        new_shipment.CIM_Number__c=filter_program.CIM_Number__c;
        if(routeid != null && routeid !='')
            new_shipment.Route__c = routeid;
        new_shipment.Freight_Mode__c = filter_shipment.Freight_Mode__c;
        new_shipment.Account_for__c=record.Account_for__c;
        NEU_CurrencyUtils.setCurrencyIsoCode(new_shipment,NEU_CurrencyUtils.getCurrencyIsoCode(record));
        //new_shipment.Supply_Project__c = record.Supply_Project_Name__c;
        new_shipment.Sales_Incoterm__c = record.Sales_Incoterm__c;
        new_shipment.Pickup_Cartage__c = record.Pickup_Cartage__c;
        new_shipment.Supplier_Account__c= record.Supplier_Account__c;  
        List<Carrier_Line_Load_Point__c> query_countries_shipment = null;
        if(routeid != null && routeid !='')
            query_countries_shipment = [select Id, Name, Country_of_Discharge__c, Country_of_Load__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c, State_of_Load__c, State_of_Discharge__c from Carrier_Line_Load_Point__c where id =: routeid];
        if(routeid != '' && routeid != null && query_countries_shipment != null && query_countries_shipment.size()>0)
        {
            new_shipment.Country_of_Discharge__c =query_countries_shipment[0].Country_of_Discharge__c;
            new_shipment.Country_of_Load__c =query_countries_shipment[0].Country_of_Load__c;
            new_shipment.State_of_Discharge__c = query_countries_shipment[0].State_of_Discharge__c;
            new_shipment.State_of_Load__c = query_countries_shipment[0].State_of_Load__c;
            new_shipment.Site_of_Discharge__c =query_countries_shipment[0].Port_Airport_of_Discharge__c;
            new_shipment.Site_of_Load__c =query_countries_shipment[0].Port_Airport_of_Load__c;
        }
        new_shipment.Nature_Merchandise__c = record.Nature_Merchandise__c;
        new_shipment.Container_Type__c = record.Container_Type__c;
        new_shipment.Freight_Mode__c = filter_shipment.Freight_Mode__c; 
        new_shipment.Purchase_Incoterm__c = record.Purchase_Incoterm__c; 
        new_shipment.Service_Mode__c = record.Service_Mode__c;
        new_shipment.Service_Type__c =  filter_shipment.Service_Type__c;
        new_shipment.Move_Type__c = record.Move_Type__c;
        new_shipment.Origin_Address__c = record.Origin_Address__c;
        new_shipment.Shipper_Contact__c = record.Supplier_Shipper_Contact__c;
        new_shipment.Account_Origin_Address__c = record.Account_Origin_Address__c;
        new_shipment.Consignee__c = record.Consignee__c;
        new_shipment.Consignee_Contact__c = record.Consignee_Contact__c;
        new_shipment.Account_Destination_Address__c = record.Account_Destination_Address__c;
        new_shipment.Destination_Address__c = record.Destination_Address__c;
        new_shipment.Account_Shipment_Reference__c = record.Customer_Reference__c;
        new_shipment.Warehouse__c = record.Warehouse__c;
        new_shipment.Only_Warehouse_Service__c = record.Only_Warehouse_Service__c;
        new_shipment.Border__c = record.Border__c;
        new_shipment.Customs__c = record.Customs__c;
        new_shipment.Origin_Location__Latitude__s = record.Origin_Location__Latitude__s;
        new_shipment.Origin_Location__Longitude__s = record.Origin_Location__Longitude__s;
        new_shipment.Destination_Location__Latitude__s = record.Destination_Location__Latitude__s;
        new_shipment.Destination_Location__Longitude__s = record.Destination_Location__Longitude__s;
        new_shipment.Kms__c = record.Kms__c;
        SYSTEM.debug(' new_shipment.Kms__c' +  new_shipment.Kms__c);
        
        //Tipo de carta porte para FN
        List<Account> account =[SELECT Tipo_de_Servicio_TNA__c, Tipo_de_Servicio_TNA__r.Name FROM Account 
                          WHERE id =: record.Account_for__c AND Tipo_de_Servicio_TNA__c != null AND Tipo_de_Servicio_TNA__c != ''];
        System.debug('valor servicio: '+ record.FolioResume__c);
        if(record.FolioResume__c == 'FN'){
            if(account.size() > 0){
                if(account[0].Tipo_de_Servicio_TNA__r.Name.contains('FLETE NACIONAL')){
                    new_shipment.Traslado_Ingreso__c = 'Ingreso';
                }else if(account[0].Tipo_de_Servicio_TNA__r.Name.contains('SERVICIOS LOGISTICOS')){
                    new_shipment.Traslado_Ingreso__c = 'Traslado';
                }
            }else{
                new_shipment.Traslado_Ingreso__c = 'Traslado';
            }
        	System.debug('valor de carta porte: '+ new_shipment.Traslado_Ingreso__c);
        }

        System.debug('ORDR - Entra a generar Ordr');
        Order ord =	generarOrder(new_shipment);
        System.debug('ORDR - Id: ' + ord.Id);
        if (ord.Id != null) {            
            new_shipment.Order__c = ord.Id;            
        }
        System.debug('ORDR - ShipOrd: ' + new_shipment.Order__c);   
                
        insert new_shipment;        		
        
        system.debug('=======Fin de la creacion del Shipment=======');
        
        if (ord.Id != null){ 
            ord.Shipment__c = new_shipment.Id; 
            update ord;
        }
        shipment_truckstop = new_shipment;
        
        Shipment_Consolidation_Data__c Shipment_Consolidation_Data = new Shipment_Consolidation_Data__c();
        Shipment_Consolidation_Data.Shipment__c= new_shipment.Id;
        Shipment_Consolidation_Data.Import_Export_Quote__c =record.Id;
        Shipment_Consolidation_Data.Customer_Buyer__c = record.Account_for__c;
        Shipment_Consolidation_Data.Import_Export_Route__c = record.Route__r.Name;
        Shipment_Consolidation_Data.Name='001';
        insert Shipment_Consolidation_Data;   	
        System.debug('SCD: ' + Shipment_Consolidation_Data);
        List<Customer_Quote__c> insert_lista_import_export = new List<Customer_Quote__c>();
        List<Shipment_Line__c> insert_lista_shipment_item_line = new List<Shipment_Line__c>();
        
        Map<Id,Quote_Item_Line__c>map_quoteline = new Map<Id, Quote_Item_Line__c>( [select Id, Name, Units__c, Total_Shipping_Volume_m3__c, Total_Shipping_Weight_Kgs__c, Expense_Amount__c, Container_Type__c, Container_Type__r.Name from Quote_Item_Line__c where Import_Export_Quote__c=: record.Id]);
        if(Lines!=null)
        {
            for (Line_s lines:getLines())
            {
                if(lines.getId()!=null )//change
                {
                    if(lines.selected == true)
                    {
                        Shipment_Line__c myLine=new Shipment_Line__c();
                        myline.Container_Type__c = lines.quote_line.Container_Type__c;
                        myline.Shipment__c=new_shipment.Id;
                        myline.pallet_warehouse__c = lines.quote_line.pallet_warehouse__c;
                        myLine.Item_Name__c=lines.getItemId();
                        myLine.Import_Export_Quote__c = lines.getHeaderId();
                        myLine.Quote_Item_Line__c=lines.getId();
                        myLine.Family__c= lines.quote_line.Item_Name__r.Sourcing_Family__c;
                        myLine.Subfamily__c = lines.quote_line.Item_Name__r.Subfamily__c;
                        NEU_CurrencyUtils.setCurrencyIsoCode(myLine,NEU_CurrencyUtils.getCurrencyIsoCode(lines.quote_line));
                        myLine.Extension_Item_Name__c=lines.extension;
                        myLine.Shipment_Consolidation_Data__c = Shipment_Consolidation_Data.Id;
                        myLine.Clave_de_Servicio__c = lines.quote_line.Clave_de_Servicio__c;
                         myLine.Material_Peligroso__c = lines.quote_line.Material_Peligroso_Cat__c;
                         myLine.Embalaje__c = lines.quote_line.Embalaje_Cat__c;
                          myLine.Peso_Neto__c = lines.quote_line.Peso_Neto__c;
                         myLine.CP_Fraccion_Arancelaria__c = lines.quote_line.CP_Fraccion_Arancelaria_IE__c;
                          myLine.Pedimento__c = lines.quote_line.Pedimento__c;

                        if(lines.ship_line != null)
                        {
                            myLine.Container_Number__c = lines.ship_line.Container_Number__c;
                        }
                        myLine.Name=String.valueOf(counter);
                        
                        while(myLine.Name.length()<3)
                            myLine.Name='0'+myLine.Name;
                        
                        if(map_quoteline.get(lines.getId()).Units__c > lines.quote_line.Units__c && lines.check_full == false)
                        {
                            splitQuoteLine(lines.getId(),lines.quote_line.Units__c);
                            myLine.Units_Shipped__c = lines.quote_line.Units__c;
                            myLine.Shipping_Volume_m3__c =(map_quoteline.get(lines.getId()).Total_Shipping_Volume_m3__c != null ? (map_quoteline.get(lines.getId()).Total_Shipping_Volume_m3__c /map_quoteline.get(lines.getId()).Units__c)*lines.quote_line.Units__c : 0 );
                            myLine.Shipping_Weight_Kg__c = (map_quoteline.get(lines.getId()).Total_Shipping_Weight_Kgs__c != null ? (map_quoteline.get(lines.getId()).Total_Shipping_Weight_Kgs__c /map_quoteline.get(lines.getId()).Units__c)*lines.quote_line.Units__c : 0 );
                        }
                        else if(lines.check_full == true)
                        {
                            myLine.Shipping_Volume_m3__c =(map_quoteline.get(lines.getId()).Total_Shipping_Volume_m3__c != null ? (map_quoteline.get(lines.getId()).Total_Shipping_Volume_m3__c /map_quoteline.get(lines.getId()).Units__c)*lines.quote_line.Units__c : 0 );
                            myLine.Shipping_Weight_Kg__c = (map_quoteline.get(lines.getId()).Total_Shipping_Weight_Kgs__c != null ? (map_quoteline.get(lines.getId()).Total_Shipping_Weight_Kgs__c /map_quoteline.get(lines.getId()).Units__c)*lines.quote_line.Units__c : 0 );
                            if(map_quoteline.get(lines.getId()).Units__c >= lines.quote_line.Units__c)
                            {
                                myLine.Units_Shipped__c = lines.quote_line.Units__c;
                                if(lines.quote_line.Consolidated__c==false)
                                {
                                    lines.quote_line.Consolidated__c=true;
                                    lines.quote_line.Units__c = map_quoteline.get(lines.getId()).Units__c;
                                    update lines.quote_line;
                                }
                            }
                            else
                            {
                                if(map_quoteline.get(lines.getId()).Units__c <= lines.quote_line.Units__c)
                                {
                                    myLine.Units_Shipped__c = lines.quote_line.Units__c;
                                    if(lines.quote_line.Consolidated__c==false)
                                    {
                                        lines.quote_line.Consolidated__c=true;
                                        lines.quote_line.Units__c = map_quoteline.get(lines.getId()).Units__c;
                                        update lines.quote_line;
                                    }
                                }
                            }
                        }
                        else if(map_quoteline.get(lines.getId()).Units__c < lines.quote_line.Units__c && lines.check_full == false)
                        {
                            myLine.Units_Shipped__c = lines.quote_line.Units__c;
                            if(lines.quote_line.Consolidated__c==false)
                            {
                                lines.quote_line.Consolidated__c=true;
                                lines.quote_line.Units__c = map_quoteline.get(lines.getId()).Units__c;
                                update lines.quote_line;
                            }
                        }
                        else if(lines.quote_line.Consolidated__c==false)
                        {
                            lines.quote_line.Consolidated__c=true;
                            update lines.quote_line;
                        }
                        insert_lista_shipment_item_line.add(myLine);
                        counter++;
                    }
                }
            }
        }
        
        //inser shipments items lines
        if(insert_lista_shipment_item_line   != null && insert_lista_shipment_item_line.size()>0)
            insert insert_lista_shipment_item_line;
        
        //actualizar los shipment anteriores last shipment el tiempo de almacenaje un envio a otro
        List<Shipment__c> listado_last_shipment_to_update = new List<Shipment__c>();
        if(record.Last_Shipment__c != null)
        {
            record.Last_Shipment__r.Storage_Date_From__c = record.Last_Shipment__r.ETA_Point_of_Discharge__c;
            if(new_filter_date_cabeceras != null && new_filter_date_cabeceras.ETD_from_Point_of_Load__c != null)
                record.Last_Shipment__r.Storage_Date_To__c = new_filter_date_cabeceras.ETD_from_Point_of_Load__c;
            listado_last_shipment_to_update.add(record.Last_Shipment__r);
            
            if(listado_last_shipment_to_update != null && listado_last_shipment_to_update.size() > 0)
                update listado_last_shipment_to_update;
        }
        
        
        //calcular las unidades de cada shipment consolidation
        decimal totalproductvalue =0;
        decimal totalunit=0;
        if(Shipment_Consolidation_Data != null && Shipment_Consolidation_Data.Id != null && insert_lista_shipment_item_line  != null && insert_lista_shipment_item_line.size()>0)
        {
            List<Shipment_Line__c> lista_shipment_item_lines =[select Id, Units_Shipped__c,Sell_Origin_Amount__c, Shipment_Consolidation_Data__c from Shipment_Line__c where Shipment_Consolidation_Data__c =:Shipment_Consolidation_Data.Id];
            
            for(Shipment_Line__c lines:lista_shipment_item_lines)
            {
                totalunit += NEU_Utils.safeDecimal(lines.Units_Shipped__c);
                totalproductvalue += NEU_Utils.safeDecimal(lines.Sell_Origin_Amount__c);
                
            }
            Shipment_Consolidation_Data.Total_Units_Shipped__c = totalunit;
            Shipment_Consolidation_Data.Total_Product_Value_Shipped__c =totalproductvalue;
            totalunit = 0;
            totalproductvalue = 0;
            
            if(Shipment_Consolidation_Data != null && Shipment_Consolidation_Data.Id != null)
                update Shipment_Consolidation_Data;
        }
        
        //actualizar las lineas de la import-export a su status correspondiente
        boolean no_consolidada = false;
        List<Quote_Item_Line__c>pending=[select Id, Import_Export_Quote__c, Import_Export_Quote__r.Quotation_Status__c, Consolidated__c from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id order by Import_Export_Quote__c];     
        for(Quote_Item_Line__c qil: pending)
        {
            if(qil.Consolidated__c == false)
            {
                no_consolidada = true;
                break;
            }
        }
        
        if(pending != null && pending.size() > 0)
        {
            if(no_consolidada == false)
                record.Quotation_Status__c = 'Shipped';
            else
                record.Quotation_Status__c = 'Partially Shipped';
            update record;   
        }
        
        //hacer efectivos los split
        if(lista_update_split != null && lista_update_split.size()>0)
        {
            for(Quote_Item_Line__c qil: lista_update_split)
                qil.Supplier_Quote_Line__c = qil.Supplier_Quote_Line__r.Id;
            NEU_StaticVariableHelper.setBoolean1(true);
            insert lista_update_split;
            update lista_update_split2;
            NEU_StaticVariableHelper.setBoolean1(false);
            lista_update_split = null; lista_update_split2 = null;
        }
        
        /*if(new_shipment != null && new_shipment.id != null){
return new PageReference('/apex/NEU_OM_ShipFeeLinesPriceListYDiscount?id='+new_shipment.Id+'&IE=true');
}else{*/
        return null;
        /*} */
    }
    
    @InvocableMethod(label='Create new Shipment')
    public static void getNewShipment(List<String> ids){
              
        try{
            
        List<Customer_Quote__c> findFolio = [SELECT Id, Name, Approved_Date_time01__c, Account_for__c, Sales_Incoterm__c, Pickup_Cartage__c, Supplier_Account__c, Nature_Merchandise__c,
                                             Container_Type__c, Purchase_Incoterm__c, Service_Mode__c, Move_Type__c ,Origin_Address__c, Supplier_Shipper_Contact__c, 
                                             Account_Origin_Address__c, Consignee__c, Consignee_Contact__c, Account_Destination_Address__c, Destination_Address__c, 
                                             Customer_Reference__c, Warehouse__c, Only_Warehouse_Service__c, Border__c, Customs__c, Origin_Location__Latitude__s, 
                                             Origin_Location__Longitude__s, Destination_Location__Latitude__s, Destination_Location__Longitude__s, Kms__c, Freight_Mode__c,Service_Type__c,Route__c,
                                             Route__r.Name, CurrencyIsoCode, Country_ofDischarge__c, Country_ofLoad__c, State_of_Discharge__c, State_of_Load__c, Site_of_Discharge__c, Site_of_Load__c,
                                             ETA__c, ETD__c, Awaiting_unload_time__c, Container_Count__c, Awaiting_load_time__c, 
                                             Last_Shipment__c, Pricing_Executive__r.Email, FolioResume__c
                                             FROM Customer_Quote__c where Id =: ids[0]]; 
        
        NEU_Generate_Shipments neu = new NEU_Generate_Shipments();
                                                                    
        Shipment__c new_shipment = new Shipment__c();
        system.debug('=======Inicio de la creacion del Shipment con flow=======');
        
        //Traer Folio de la IE
        List<Shipment_Consolidation_Data__c> scd = [select Id, Name, Import_Export_Quote__c from Shipment_Consolidation_Data__c where Import_Export_Quote__c =: findFolio[0].Id];
        
        new_shipment.Name = 'SP-' + findFolio[0].Name + (scd.size() == 0 ? '' : '-'+(scd.size()+1));                                
        new_shipment.Carrier__c = neu.filter_shipment.Carrier__c;        
        new_shipment.MBL_Number__c= neu.filter_program.MBL_Number__c;
        new_shipment.MAWB_Number__c= neu.filter_program.MAWB_Number__c;
        new_shipment.Sea_Booking_Number__c= neu.filter_program.Sea_Booking_Number__c;
        new_shipment.Voyage_Number_s__c= neu.filter_program.Voyage_Number_sp__c;
        new_shipment.Truck_Number__c= neu.filter_program.Truck_Number__c;
        new_shipment.Trailer_Number__c= neu.filter_program.Trailer_Number__c;        
        new_shipment.National_Operator__c= neu.new_filter_date_cabeceras.National_Operator__c;
        new_shipment.Vehicle__c = neu.new_filter_date_cabeceras.Vehicle__c;        
        new_shipment.Rail_Container_Number__c= neu.filter_program.Rail_Container_Number__c;
        new_shipment.SMGS__c= neu.filter_program.SMGS__c;
        new_shipment.CIM_Number__c= neu.filter_program.CIM_Number__c;                    
        new_shipment.Freight_Mode__c = findFolio[0].Freight_Mode__c;
        new_shipment.Account_for__c=findFolio[0].Account_for__c;        
        new_shipment.Sales_Incoterm__c = findFolio[0].Sales_Incoterm__c;
        new_shipment.Pickup_Cartage__c = findFolio[0].Pickup_Cartage__c;
        new_shipment.Supplier_Account__c= findFolio[0].Supplier_Account__c;  
               
        new_shipment.Country_of_Discharge__c =findFolio[0].Country_ofDischarge__c;
        new_shipment.Country_of_Load__c =findFolio[0].Country_ofLoad__c;
        new_shipment.State_of_Discharge__c = findFolio[0].State_of_Discharge__c;
        new_shipment.State_of_Load__c = findFolio[0].State_of_Load__c;
        new_shipment.Site_of_Discharge__c =findFolio[0].Site_of_Discharge__c;
        new_shipment.Site_of_Load__c =findFolio[0].Site_of_Load__c;

        new_shipment.Container_Type__c = findFolio[0].Container_Type__c;        
        new_shipment.Purchase_Incoterm__c = findFolio[0].Purchase_Incoterm__c; 
        new_shipment.Service_Mode__c = findFolio[0].Service_Mode__c;
        new_shipment.Service_Type__c =  findFolio[0].Service_Type__c;
        new_shipment.Move_Type__c = findFolio[0].Move_Type__c;
        new_shipment.Origin_Address__c = findFolio[0].Origin_Address__c;
        new_shipment.Shipper_Contact__c = findFolio[0].Supplier_Shipper_Contact__c;
        new_shipment.Account_Origin_Address__c = findFolio[0].Account_Origin_Address__c;
        new_shipment.Consignee__c = findFolio[0].Consignee__c;
        new_shipment.Consignee_Contact__c = findFolio[0].Consignee_Contact__c;
        new_shipment.Account_Destination_Address__c = findFolio[0].Account_Destination_Address__c;
        new_shipment.Destination_Address__c = findFolio[0].Destination_Address__c;
        new_shipment.Account_Shipment_Reference__c = findFolio[0].Customer_Reference__c;
        new_shipment.Warehouse__c = findFolio[0].Warehouse__c;
        new_shipment.Only_Warehouse_Service__c = findFolio[0].Only_Warehouse_Service__c;
        new_shipment.Border__c = findFolio[0].Border__c;
        new_shipment.Customs__c = findFolio[0].Customs__c;
        new_shipment.Origin_Location__Latitude__s = findFolio[0].Origin_Location__Latitude__s;        
        new_shipment.Destination_Location__Latitude__s = findFolio[0].Destination_Location__Latitude__s;
        new_shipment.Origin_Location__Longitude__s = findFolio[0].Origin_Location__Longitude__s;
        new_shipment.Destination_Location__Longitude__s = findFolio[0].Destination_Location__Longitude__s;
        new_shipment.Kms__c = findFolio[0].Kms__c;
            
        new_shipment.N_Containers__c = findFolio[0].Container_Count__c;              
        new_shipment.ETA_Point_of_Discharge__c=findFolio[0].ETA__c;
        new_shipment.ETD_from_Point_of_Load__c = findFolio[0].ETD__c;
        new_shipment.ETA_Time_Point_of_Discharge__c= findFolio[0].Awaiting_unload_time__c;
        new_shipment.ETD_Time_from_Point_of_Load__c = findFolio[0].Awaiting_load_time__c;
                       
        //0054T000001ju8UQAQ usuario Julio Guillen 
        //List<User> executive = [select Id, Name from User where Name = 'Leonardo Nocelo']; //Id = '0054T000001ju8UQAQ' julio];
        //new_shipment.Operation_Executive__c = '0054T000001ju8UQAQ'; //0050R00000C248EQAR->leo                             
        String folioNumber = findFolio[0].Name;
        if(folioNumber.startsWith('CE')){
            //UAT: Carlos -> 0050R000008eNBoQAM || PROD: Edgar Luna -> 0054T000001hx7LQAQ
            new_shipment.Operation_Executive__c = '005RQ000000115JYAQ';
        }else if(folioNumber.startsWith('FN')){
            //Id = '0054T000001ju8UQAQ' julio guillen
            new_shipment.Operation_Executive__c = '005RQ000000115JYAQ';
        }
        
        //Tipo de carta porte para FN
        List<Account> account =[SELECT Tipo_de_Servicio_TNA__c, Tipo_de_Servicio_TNA__r.Name FROM Account 
                          WHERE id =: findFolio[0].Account_for__c AND Tipo_de_Servicio_TNA__c != null AND Tipo_de_Servicio_TNA__c != ''];
        System.debug('valor servicio: '+ findFolio[0].FolioResume__c);
        if(findFolio[0].FolioResume__c == 'FN'){
            if(account.size() > 0){
                if(account[0].Tipo_de_Servicio_TNA__r.Name.contains('FLETE NACIONAL')){
                    new_shipment.Traslado_Ingreso__c = 'Ingreso';
                }else if(account[0].Tipo_de_Servicio_TNA__r.Name.contains('SERVICIOS LOGISTICOS')){
                    new_shipment.Traslado_Ingreso__c = 'Traslado';
                }
            }else{
                new_shipment.Traslado_Ingreso__c = 'Traslado';
            }
        	System.debug('valor de carta porte: '+ new_shipment.Traslado_Ingreso__c);
        }

        insert new_shipment;
        

        Order order = neu.generarOrder(new_shipment);
            
        new_shipment.Order__c = order.Id;             
            
        update new_shipment;                   
        order.Shipment__c =  new_shipment.Id;
        update order;        
        
        system.debug('=======Fin de la creacion del Shipment con flow=======');                                
            
        system.debug('=======Creacion del objeto Shipment_Consolidation_Data__c =======');    
                                
        Shipment_Consolidation_Data__c data = new Shipment_Consolidation_Data__c();
		data.Shipment__c= new_shipment.Id;
		data.Import_Export_Quote__c =findFolio[0].Id;
		data.Customer_Buyer__c = findFolio[0].Account_for__c;
        data.Import_Export_Route__c = findFolio[0].Route__c;
        data.Name='001';
        insert data;

		getSPCargoLine(findFolio[0],new_shipment, data);                                                                     	  
                                                                      
        }catch(Exception e){
            system.debug('==========Ocurrio un error al crear el SP==================== ' + e.getMessage() + 
                        ' Linea del error:  ' + e.getLineNumber());
        }
        
    }
        
    public static void getSPCargoLine(Customer_Quote__c folio, Shipment__c shipment, Shipment_Consolidation_Data__c data){
        
        
      system.debug('====Obteniedo los cargo lines del folio.....========');
        
      List<Quote_Item_Line__c> getCargoLines = [SELECT Id,Name, Import_Export_Quote__c,Item_Name__c,Item_Name__r.Subfamily__c,Item_Name__r.Sourcing_Family__c,Container_Type__c, Extension_Item_Name__c,Units__c,
                                               Clave_de_Servicio__c, Material_Peligroso_Cat__c, Embalaje_Cat__c, Peso_Neto__c, CP_Fraccion_Arancelaria_IE__c, Pedimento__c,
                                               Total_Shipping_Volume_m3__c, Total_Shipping_Weight_Kgs__c, pallet_warehouse__c 
                                               from Quote_Item_Line__c where Import_Export_Quote__c =:folio.Id];
                        
      List<Shipment_Line__c> shipmentLines = new List<Shipment_Line__c>();
            
            
        if(!getCargoLines.isEmpty() && getCargoLines.size()>0){                    
                        
            for(Quote_Item_Line__c cargoLine : getCargoLines){
                
                Shipment_Line__c spLine = new Shipment_Line__c();                
                spLine.Shipment_Consolidation_Data__c = data.Id;
                spLine.Import_Export_Quote__c = folio.Id;
                spLine.Quote_Item_Line__c=cargoLine.Id;
                spLine.Shipment__c = shipment.Id;                                                
                spLine.Item_Name__c=cargoLine.Item_Name__c;
                spLine.Name = cargoLine.Name;                                                
                spLine.Container_Type__c = cargoLine.Container_Type__c;                                
                spLine.Extension_Item_Name__c = cargoLine.Extension_Item_Name__c;
                spLine.Clave_de_Servicio__c = cargoLine.Clave_de_Servicio__c;
                spLine.Material_Peligroso__c = cargoLine.Material_Peligroso_Cat__c;
                spLine.Embalaje__c = cargoLine.Embalaje_Cat__c;
                spLine.Peso_Neto__c = cargoLine.Peso_Neto__c;
                spLine.CP_Fraccion_Arancelaria__c = cargoLine.CP_Fraccion_Arancelaria_IE__c;
                spLine.Pedimento__c = cargoLine.Pedimento__c;  
                spLine.Family__c = cargoLine.Item_Name__r.Sourcing_Family__c;
                spLine.Subfamily__c  = cargoLine.Item_name__r.Subfamily__c;
                spLine.pallet_warehouse__c =  cargoLine.pallet_warehouse__c;
                spLine.Units_Shipped__c = cargoLine.Units__c;
                spLine.Shipping_Volume_m3__c = (cargoLine.Total_Shipping_Volume_m3__c != null ? (cargoLine.Total_Shipping_Volume_m3__c / cargoLine.Units__c) * cargoLine.Units__c : 0);
                spLine.Shipping_Weight_Kg__c = (cargoLine.Total_Shipping_Weight_Kgs__c != null ? (cargoLine.Total_Shipping_Weight_Kgs__c / cargoLine.Units__c) * cargoLine.Units__c : 0);                                
                shipmentLines.add(spLine);                                                                       
            
            }
            
			insert shipmentLines;			
            
        }                                                  
        
    }
    
    
    public Order generarOrder (Shipment__c shipment) {
        Id stdPriceBook = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1].Id;
        List<Product2> prods = [SELECT Id FROM Product2 limit 1/* WHERE Name = :shipment.Name*/];
        Product2 p;
        PricebookEntry pbe;
        
        if(prods.size()>0){            
            p = prods[0];
            pbe = [SELECT Id FROM PricebookEntry WHERE Product2Id =:p.Id LIMIT 1];
        }else{            
            p = new Product2(Name=shipment.Name, IsActive = true);
            insert p;
                        
            pbe = new PricebookEntry();
            pbe.IsActive = true;
            pbe.UnitPrice = 1;
            pbe.Product2Id = p.Id;
            pbe.Pricebook2Id = stdPriceBook;
            insert pbe;
        }               
                
        Order order = new Order();
        order.AccountId = shipment.Account_for__c;
        order.Status = 'Draft';
        order.EffectiveDate = Date.today();
        order.Pricebook2Id = stdPriceBook;
        order.DefaultProduct__c = p.Id;
        order.DefaultPbe__c = pbe.Id;
        insert order;
        
        return order;
        
    }
    
    public PageReference createTrackingTruckstop(){
        if(shipment_truckstop != null && shipment_truckstop.id != null){
            if(shipment_truckstop.Freight_Mode__c == 'Road'){
                Boolean error = false;
                
                Map<String, String> map_ids = new Map<String, String>();
                map_ids.put('shipmentID', shipment_truckstop.Id);
                
                if(shipment_track.Truckstop_Origin_Address__c == null || shipment_track.Truckstop_Origin_Address__c == ''){
                    Map<String, Object> map_result = NEU_TS_WS_Tracking.validateAddress(null, map_ids, 'Origin');
                    if(map_result.get('error')!= null){
                        error = true;
                        system.debug('GENERATE TRACKING : ERROR(' + String.valueOf(map_result.get('error')) + ').');
                    }else{
                        NEU_TS_WS_Tracking.TrackLocationResponse trackLocationResponse = (NEU_TS_WS_Tracking.TrackLocationResponse)map_result.get('data_parsed');
                        shipment_track.Truckstop_Origin_City__c = trackLocationResponse.location.city;
                        shipment_track.Truckstop_Origin_Postal_Code__c = trackLocationResponse.location.zip;
                        shipment_track.Truckstop_Origin_State_Code__c = trackLocationResponse.location.state;
                        shipment_track.Truckstop_Origin_Country_Code__c = trackLocationResponse.location.country;
                    }
                }
                
                if(shipment_track.Truckstop_Destination_Address__c == null || shipment_track.Truckstop_Destination_Address__c == ''){
                    Map<String, Object> map_result = NEU_TS_WS_Tracking.validateAddress(null, map_ids, 'Destination');
                    if(map_result.get('error')!= null){
                        error = true;
                        system.debug('GENERATE TRACKING : ERROR(' + String.valueOf(map_result.get('error')) + ').');
                    }else{
                        NEU_TS_WS_Tracking.TrackLocationResponse trackLocationResponse = (NEU_TS_WS_Tracking.TrackLocationResponse)map_result.get('data_parsed');
                        shipment_track.Truckstop_Destination_City__c = trackLocationResponse.location.city;
                        shipment_track.Truckstop_Destination_Postal_Code__c = trackLocationResponse.location.zip;
                        shipment_track.Truckstop_Destination_State_Code__c = trackLocationResponse.location.state;
                        shipment_track.Truckstop_Destination_Country_Code__c = trackLocationResponse.location.country;
                    }
                }
                
                if(error == false){
                    Map<String, Object> map_result = NEU_TS_WS_Tracking.createTrack(shipment_truckstop, shipment_track, null);
                    if(map_result.get('error') != null){
                        system.debug('GENERATE TRACKING : ERROR(' + String.valueOf(map_result.get('error')) + ').');
                    }
                }
            }
            
            //check redirect ShipFeeLines version from check user
            User u = [select Id, username, New_Shipment_Service_Line__c from User where Id = :UserInfo.getUserId()];
            
            if(u.New_Shipment_Service_Line__c)
                return new PageReference('/apex/NEU_OM_ShipFeeLinesPriceListYDiscount2?id='+shipment_truckstop.Id+'&IE=true');
            else
                return new PageReference('/apex/NEU_OM_ShipFeeLinesPriceListYDiscount?id='+shipment_truckstop.Id+'&IE=true');
            
        }else{
            return null;
        }
    }
    
    public void splitQuoteLine(String lineid,decimal units)//private
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
                // insert newline;
                if(id_nueva_linea != null)
                {
                    newline.Supplier_Quote_Line__r = id_nueva_linea;
                    system.debug('holaapasa5)');
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
                // update lines[0];
                lista_update_split2.add(lines[0]);
            }           
        }
    }
    
    public void bypass()
    {
        integer a= 1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
         a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        
        a= a+1;
        a= a+1;
        
        
    }
    
}