public with sharing class NEU_OM_Assign_Transport_Packaging_Data {

    private Transport_Packaging_Data__c record=null;
    private List<Shipment_lines_s> Shipment_lines = null;
    public string resultado {get;set;}
    public decimal TotalNumberBoxes {get;set;}
    public decimal TotalNumberPallets {get;set;}
    public decimal Grossweight {get;set;}
    public decimal Cube {get;set;}
    public decimal TotalNumberCont {get;set;}
    public decimal FreeSpaceCont  {get;set;}
    public string porc_ocupacion {get;set;}
    public List<SelectOption> containers = null;
    private string container_selected='';
    
    public decimal ocupacion_volumen =0;
    public decimal ocupacion_pallet =0; 
    public decimal ocupacion_peso  =0;
    public List<Shipment_Line__c> listadeitems = null;
    public List<Pallet_Container_Type__c> lista_contenedores  = null;
    public List<Item_Pallet_Type__c> lista_pallets = null;
    
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
        List<Pallet_Container_Type__c> lista_contenedores = new List<Pallet_Container_Type__c>();
        lista_contenedores = [select Id, Name, Pallet_Type__c from Pallet_Container_Type__c order by Name limit 100];
        containers = new List<SelectOption>();
        containers.add(new SelectOption('0', '-- Select Pallet/Container Type --'));
        boolean selected=false;
        for(Pallet_Container_Type__c cp : lista_contenedores)
        {
            if(cp.id== record.Container_Pallets__c && selected == false)
            {
                container_selected=cp.Id;
                selected = true;
            }
            containers.add(new SelectOption(cp.Id, cp.Name));
        }
   
        return containers; 
    }
    
    public NEU_OM_Assign_Transport_Packaging_Data(ApexPages.StandardController stdController)
    {
         if (!Test.isRunningTest()) {
            stdController.AddFields(new String[]
            {
              'Id',
              'Name',
              'Total_Weight_Items_Kg__c',
              'Container_Pallets__c',
              'Number_of_Packages__c',
              'Total_Number_Pallets__c',
              'Total_Weight_Items_Kg__c',
              'Gross_Volume__c',
              'Transport_type__c',
              'N_Containers__c',
              'Free_Space_Container__c',
              'Ocuped_Space_Container__c',
              'Total_Weight_Items_Kg__c',
              'Shipment__c'
            });
         }
        record=(Transport_Packaging_Data__c)stdController.getRecord();
        TotalNumberBoxes = 0;
        TotalNumberPallets = 0;
        Grossweight = 0;
        Cube = 0;
        TotalNumberCont= 0;
        FreeSpaceCont = 0;
        string porc_ocupacion = '0';
    }
    

    public class Shipment_lines_s
    {
        public Shipment_Line__c line {get; set;}
        public boolean selected {get; set;}
        public boolean tiene_relacion_pallet {get; set;}
        
        public Shipment_lines_s(Shipment_Line__c line, boolean selected, boolean tiene_relacion_pallet)
        {
                this.line=line;
                this.selected=selected;
                this.tiene_relacion_pallet=tiene_relacion_pallet;
        }
    } 
        
    public List<Shipment_lines_s> getShipment_lines()
    {
       /* if(Shipment_lines == null)
        {
          Shipment_lines=new List<Shipment_lines_s>();
          List<Shipment_Line__c> lines_insertadas = null;
          lines_insertadas=[select Id,Name,Shipment__c,Import_Export_Quote__c,Total_Volume_m3__c,Quote_Item_Line__c,Item_Name__c,Units_Shipped__c,Product_Value_Shipped__c,Total_Weight_Kg__c,Supplier_Total_Volume_m3__c,Supplier_Total_Weight_kg__c,Total_Shipping_Weight_Kg__c,Shipment_Consolidation_Data__c,Packaging_File_Number__c, Item_Name__r.Unit_of_measure__c, Final_Total_Weight_Kg__c, Manual_Shipping_Volume_m3__c from Shipment_Line__c where Shipment__c =: record.Shipment__c and Packaging_File_Number__c =: record.Id];
          for(Shipment_Line__c l:lines_insertadas)
          {
                Shipment_lines.add(new Shipment_lines_s(l,true,false));
          }
         
          List<Shipment_Line__c> lines = null;
          lines=[select Id,Name,Shipment__c,Import_Export_Quote__c,Total_Volume_m3__c,Quote_Item_Line__c,Item_Name__c,Units_Shipped__c,Product_Value_Shipped__c,Total_Weight_Kg__c,Supplier_Total_Volume_m3__c,Supplier_Total_Weight_kg__c,Total_Shipping_Weight_Kg__c,Shipment_Consolidation_Data__c,Packaging_File_Number__c, Item_Name__r.Unit_of_measure__c, Final_Total_Weight_Kg__c, Manual_Shipping_Volume_m3__c from Shipment_Line__c where Shipment__c =: record.Shipment__c and Packaging_File_Number__c =: null];
         
          if(ApexPages.currentPage().getParameters().get('test') != null)
             lines=[select Id,Name,Shipment__c,Import_Export_Quote__c,Total_Volume_m3__c,Quote_Item_Line__c,Item_Name__c,Units_Shipped__c,Product_Value_Shipped__c,Total_Weight_Kg__c,Supplier_Total_Volume_m3__c,Supplier_Total_Weight_kg__c,Total_Shipping_Weight_Kg__c,Shipment_Consolidation_Data__c,Packaging_File_Number__c, Item_Name__r.Unit_of_measure__c, Final_Total_Weight_Kg__c, Manual_Shipping_Volume_m3__c from Shipment_Line__c limit 2];
         
            for(Shipment_Line__c l:lines)
            {
                if(ApexPages.currentPage().getParameters().get('test') != null)
                    Shipment_lines.add(new Shipment_lines_s(l,true,true));
                else
                    Shipment_lines.add(new Shipment_lines_s(l,false,false));
                
            }
        }*/
        
         if(Shipment_lines == null)
        {
             Shipment_lines=new List<Shipment_lines_s>();
             List<Transport_Packaging_Line__c> lines_insertadas = null;
             lines_insertadas=[select Id, Name, Shipment_Item_Line__r.Shipment__c, Shipment_Item_Line__r.Name, Shipment_Item_Line__r.Item_Name__r.Name, Shipment_Item_Line__r.Item_Name__r.Unit_of_measure__c,
             Shipment_Item_Line__r.Shipment_Consolidation_Data__c, Shipment_Item_Line__r.Units_Shipped__c, Shipment_Item_Line__r.Sell_Origin_Amount__c, Shipment_Item_Line__r.Supplier_Total_Weight_kg__c ,
             Shipment_Item_Line__r.Shipping_Weight_Kg__c, Shipment_Item_Line__r.Supplier_Total_Volume_m3__c, Shipment_Item_Line__r.Shipping_Volume_m3__c from Transport_Packaging_Line__c where Shipment_Item_Line__r.Shipment__c =: record.Shipment__c and Transport_Packaging_Data__c =: record.Id];
             List<Id> shipment_lines_ya_insertadas = new List<Id>();
             string contenedor_de_lineas_de_shipment = '';
             
             for(Transport_Packaging_Line__c l:lines_insertadas)
             {
                   Shipment_lines.add(new Shipment_lines_s(l.Shipment_Item_Line__r,true,false));
                   if(contenedor_de_lineas_de_shipment.contains(l.Shipment_Item_Line__c)==false)
                       shipment_lines_ya_insertadas.add(l.Shipment_Item_Line__c);
                   
                   contenedor_de_lineas_de_shipment +=l.Shipment_Item_Line__c;
             }
             
             
            List<Transport_Packaging_Line__c> lines = null;
            lines=[select Id,Name,Shipment_Item_Line__r.Shipment__c,Shipment_Item_Line__r.Name,Transport_Packaging_Data__r.Transport_type__c from Transport_Packaging_Line__c where Shipment_Item_Line__r.Shipment__c =: record.Shipment__c];// and Transport_type__c != Transport_type__c
            
            List<Shipment_Line__c> lines_shipment = null;
            lines_shipment=[select Id, Name,Shipment__c, Item_Name__r.Name, Item_Name__r.Unit_of_measure__c,
            Shipment_Consolidation_Data__c, Units_Shipped__c, Sell_Origin_Amount__c, Supplier_Total_Weight_kg__c ,
            Shipping_Weight_Kg__c, Supplier_Total_Volume_m3__c, Shipping_Volume_m3__c from Shipment_Line__c where Shipment__c =: record.Shipment__c and id not in: shipment_lines_ya_insertadas];
         
         
            if(ApexPages.currentPage().getParameters().get('test') != null)
            {
               lines=[select Id,Name,Shipment_Item_Line__r.Shipment__c,Shipment_Item_Line__r.Name,Transport_Packaging_Data__r.Transport_type__c from Transport_Packaging_Line__c limit 2];
               lines_shipment=[select Id, Name, Item_Name__r.Name, Item_Name__r.Unit_of_measure__c,  
               Shipment_Consolidation_Data__c, Units_Shipped__c, Sell_Origin_Amount__c, Supplier_Total_Weight_kg__c ,
               Shipping_Weight_Kg__c, Supplier_Total_Volume_m3__c, Shipping_Volume_m3__c from Shipment_Line__c limit 2];
            }
            
            boolean encontrado = true;
            for(Shipment_Line__c l:lines_shipment)
            {
            
                for(Transport_Packaging_Line__c lt:lines)
                {
                    if(l.Id == lt.Shipment_Item_Line__c)
                    {
                        if(lt.Transport_Packaging_Data__r.Transport_type__c != record.Transport_type__c)
                        {
                            encontrado = true;
                        
                        }
                        else
                            encontrado = false;
                        break;
                            
                    }
                }
                
                if(encontrado == true || ApexPages.currentPage().getParameters().get('test') != null)
                {
                    if(ApexPages.currentPage().getParameters().get('test') != null)
                        Shipment_lines.add(new Shipment_lines_s(l,true,true));
                    else
                        Shipment_lines.add(new Shipment_lines_s(l,false,false));
                }
                encontrado = true;
            }
  
        }
        
        
        return Shipment_lines;
        
    }   
    
    public Boolean getShowShipmentItemsLines()
    {
        if(getShipment_lines()!=null)
            return Shipment_lines.size()>0;
        return false;
    }
    
    public void calcular()
    {
        TotalNumberBoxes = 0;
        TotalNumberPallets = 0;
        Grossweight = 0;
        Cube = 0;
        TotalNumberCont = 0;
        FreeSpaceCont =0;
        boolean encontrado =false;
        porc_ocupacion = '0%';
        decimal total_pallet_linea = 0;
        
        listadeitems = null;
        listadeitems = [select Id, Name, Shipment__c,Supplier_Total_Volume_m3__c, Item_Units_x_Packaging__c, Shipping_Volume_m3__c,Shipping_Weight_Kg__c, Supplier_Total_Weight_kg__c,  Shipment__r.Name, Units_Shipped__c, Item_Name__c, Item_Name__r.Units_x_Master_Box__c, Item_Name__r.Master_Box_Volume_m3__c, Item_Name__r.Master_Box_Gross_Weight_kg__c from Shipment_Line__c where Shipment__c =: record.Shipment__c order by Name];
        
        //si ha elegido un container pallets
        lista_contenedores  = null;
        lista_contenedores = [select Id, Name, Pallet_Type__c, Container_Type__c, Container_Type__r.Cargo_Weight_Kg__c, Container_Type__r.Cargo_Volume_m3__c, Number_of_Pallets__c from Pallet_Container_Type__c where id =: container_selected  order by Name];
        
        List<Item_Pallet_Type__c> lista_pallets = new List<Item_Pallet_Type__c>();
        if(lista_contenedores.size()>0)
            lista_pallets = [select Id, Name, Pallet_Type__c, Packages_Pallet__c, Item_Name__c, Pallet_Type__r.Pallet_Weight_Kg__c, Pallet_Type__r.Pallet_Volume_m3__c  from Item_Pallet_Type__c where Pallet_Type__c =: lista_contenedores[0].Pallet_Type__c order by Name];
        
        for(Shipment_lines_s sl: getShipment_lines())
        {
            for(Shipment_Line__c items_off : listadeitems)
             {
                if(sl.line.Id == items_off.Id && sl.selected == true)
                {
                    //TotalNumberBoxes +=(items_off.Item_Name__r.Units_x_Master_Box__c != null && items_off.Item_Name__r.Units_x_Master_Box__c !=0 ? (items_off.Units_Shipped__c/items_off.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP) : 0);
                    TotalNumberBoxes +=(NEU_Utils.safeDecimal(items_off.Item_Units_x_Packaging__c )!= 0 ? (items_off.Units_Shipped__c/items_off.Item_Units_x_Packaging__c).round(roundingMode.UP) :(items_off.Item_Name__r.Units_x_Master_Box__c != null && items_off.Item_Name__r.Units_x_Master_Box__c !=0 ? (items_off.Units_Shipped__c/items_off.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP) : 0));
                    for(Item_Pallet_Type__c ip :lista_pallets )
                    {
                        if(ip.Item_Name__c == items_off.Item_Name__c)
                        {
                            //total_pallet_linea = (ip.Packages_Pallet__c != null && ip.Packages_Pallet__c > 0 && items_off.Item_Name__r.Units_x_Master_Box__c != null && items_off.Item_Name__r.Units_x_Master_Box__c  > 0 ? (((items_off.Units_Shipped__c/items_off.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP))/ip.Packages_Pallet__c).round(roundingMode.UP) : 0);   
                            
                            total_pallet_linea = (ip.Packages_Pallet__c != null && ip.Packages_Pallet__c > 0 ?  
                            (NEU_Utils.safeDecimal(items_off.Item_Units_x_Packaging__c )!= 0 ? 
                            ip.Packages_Pallet__c*items_off.Item_Units_x_Packaging__c/items_off.Units_Shipped__c: 
                             ( NEU_Utils.safeDecimal(items_off.Item_Name__r.Units_x_Master_Box__c )!= 0 ? items_off.Item_Name__r.Units_x_Master_Box__c*ip.Packages_Pallet__c/items_off.Units_Shipped__c  : 0))  : 0 );
                            
                            TotalNumberPallets +=total_pallet_linea;
                            if(ip.Pallet_Type__r.Pallet_Weight_Kg__c != null && ip.Pallet_Type__r.Pallet_Weight_Kg__c !=0 )
                                Grossweight += ip.Pallet_Type__r.Pallet_Weight_Kg__c*total_pallet_linea;
                            if(ip.Pallet_Type__r.Pallet_Volume_m3__c != null && ip.Pallet_Type__r.Pallet_Volume_m3__c !=0 ) 
                                Cube += ip.Pallet_Type__r.Pallet_Volume_m3__c*total_pallet_linea;
                            encontrado =true;
                            sl.tiene_relacion_pallet =false;
                            break;
                        }
                    }
                    if(encontrado == false)
                    {
                        TotalNumberPallets += 0;
                        sl.tiene_relacion_pallet = true;
                    }
                    
                    encontrado = false;
                   // Grossweight += (items_off.Item_Name__r.Units_x_Master_Box__c != null && items_off.Item_Name__r.Units_x_Master_Box__c !=0 &&  items_off.Item_Name__r.Master_Box_Gross_Weight_kg__c != null && items_off.Item_Name__r.Master_Box_Gross_Weight_kg__c !=0 ? items_off.Item_Name__r.Master_Box_Gross_Weight_kg__c*((items_off.Units_Shipped__c/items_off.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP)):(items_off.Supplier_Total_Weight_kg__c >0 ? items_off.Supplier_Total_Weight_kg__c: NEU_Utils.safeDecimal(items_off.Shipping_Weight_Kg__c)));
                    Grossweight += (NEU_Utils.safeDecimal(items_off.Shipping_Weight_Kg__c) != 0 ? items_off.Shipping_Weight_Kg__c : 0 );
                    //Cube += (items_off.Item_Name__r.Master_Box_Volume_m3__c != null && items_off.Item_Name__r.Master_Box_Volume_m3__c != 0 && items_off.Item_Name__r.Units_x_Master_Box__c != null && items_off.Item_Name__r.Units_x_Master_Box__c != 0  ? items_off.Item_Name__r.Master_Box_Volume_m3__c*((items_off.Units_Shipped__c/items_off.Item_Name__r.Units_x_Master_Box__c).round(roundingMode.UP)): (items_off.Supplier_Total_Volume_m3__c  >0 ? items_off.Supplier_Total_Volume_m3__c : NEU_Utils.safeDecimal(items_off.Shipping_Volume_m3__c) ));
                    Cube += (NEU_Utils.safeDecimal(items_off.Shipping_Volume_m3__c) != 0 ? items_off.Shipping_Volume_m3__c : 0 );
                    total_pallet_linea = 0;
                    break;
                }
                else
                     sl.tiene_relacion_pallet =false;
             }
         }
         ocupacion_volumen=0;
         ocupacion_pallet =0;
         ocupacion_peso = 0;
        //calcula porcenta ocupacion
        if(lista_contenedores.size()>0)
        {               
            ocupacion_peso = (lista_contenedores[0].Container_Type__r.Cargo_Weight_Kg__c >0 ? (Grossweight/lista_contenedores[0].Container_Type__r.Cargo_Weight_Kg__c):0);
            ocupacion_volumen=(lista_contenedores[0].Container_Type__r.Cargo_Volume_m3__c >0 ?(Cube/lista_contenedores[0].Container_Type__r.Cargo_Volume_m3__c):0); 
            ocupacion_pallet =(lista_contenedores[0].Number_of_Pallets__c >0 ? (TotalNumberPallets/lista_contenedores[0].Number_of_Pallets__c):0);
            
                if(ocupacion_peso > ocupacion_pallet)
                {
                    if(ocupacion_peso > ocupacion_volumen)
                    {
                        TotalNumberCont = (Grossweight/lista_contenedores[0].Container_Type__r.Cargo_Weight_Kg__c).round(roundingMode.UP);
                        
                    }
                    else
                    {
                        TotalNumberCont = (Cube/lista_contenedores[0].Container_Type__r.Cargo_Volume_m3__c).round(roundingMode.UP);
                        
                    }
                }
                else
                {
                    if(ocupacion_pallet > ocupacion_volumen)
                    {
                        TotalNumberCont =  (lista_contenedores[0].Number_of_Pallets__c > 0 ? (TotalNumberPallets/lista_contenedores[0].Number_of_Pallets__c).round(roundingMode.UP):0);
                        
                    }
                    else
                    {
                        TotalNumberCont = (Cube/lista_contenedores[0].Container_Type__r.Cargo_Volume_m3__c).round(roundingMode.UP);
                    }
                }
            
            
              if(ocupacion_peso > ocupacion_pallet)
              {
                    if(ocupacion_peso > ocupacion_volumen)
                        FreeSpaceCont =(TotalNumberCont- ocupacion_peso)*100;
                    else
                        FreeSpaceCont =(TotalNumberCont- ocupacion_volumen)*100;
                }
                else
                {
                    if(ocupacion_pallet > ocupacion_volumen)
                        FreeSpaceCont =(TotalNumberCont- ocupacion_pallet)*100;
                    else
                        FreeSpaceCont =(TotalNumberCont- ocupacion_volumen)*100;
                }
            }
            Grossweight = Grossweight.setScale(2, RoundingMode.HALF_UP).doubleValue();
            Cube = Cube.setScale(2);
            
            porc_ocupacion = (100 -(FreeSpaceCont > 0 ? FreeSpaceCont : 100 )).setScale(2) +'%';
            FreeSpaceCont =  FreeSpaceCont.setScale(2);
    }
    
    public void crearelacion()
    {
        string comprobante = '';
        list<Transport_Packaging_Line__c> lista_transpor_packaging_line_insert = new list<Transport_Packaging_Line__c>();
        list<Transport_Packaging_Line__c> lista_transpor_packaging_line_del = new list<Transport_Packaging_Line__c>();
        list<Transport_Packaging_Line__c> lista_transpor_packaging_line_query = [select Id, Name, Transport_Packaging_Data__c, Shipment_Item_Line__c from Transport_Packaging_Line__c where Transport_Packaging_Data__c =: record.Id];
        string nombre_nueva_linea = '';
        string contador_nueva_linea = '';
        integer contado_lineas_nuevas = lista_transpor_packaging_line_query.size()+1;
        boolean ya_insertado= false;
        for (Shipment_lines_s lines:getShipment_lines())
        {
            if(lines.selected == true)
            {
                
                for(Transport_Packaging_Line__c tpl: lista_transpor_packaging_line_query)
                {
                    if(tpl.Shipment_Item_Line__c == lines.line.Id)
                    {
                        ya_insertado = true;
                        break;
                    }
                }
                if(ya_insertado == false)
                {
                  nombre_nueva_linea = '';
                  Transport_Packaging_Line__c nueva_linea = new Transport_Packaging_Line__c();
                  while(nombre_nueva_linea.length() < 3)
                  {
                    contador_nueva_linea +='0';
                    nombre_nueva_linea =contador_nueva_linea+contado_lineas_nuevas;
                  } 
                  nueva_linea.Name = nombre_nueva_linea;
                  nueva_linea.Shipment_Item_Line__c = lines.line.Id;
                  nueva_linea.Transport_Packaging_Data__c = record.Id;
                  lista_transpor_packaging_line_insert.add(nueva_linea);
                  contado_lineas_nuevas ++;
                  contador_nueva_linea ='';
                }
                ya_insertado = false;
            }
            else
            {
                for(Transport_Packaging_Line__c tpl: lista_transpor_packaging_line_query)
                {
                    if(tpl.Shipment_Item_Line__c == lines.line.Id && lines.selected == false)
                    {
                        lista_transpor_packaging_line_del.add(tpl);
                    }
                }
            }
        }
        
        try
        {
            insert lista_transpor_packaging_line_insert;
            if(lista_transpor_packaging_line_del.size()>0)
                delete lista_transpor_packaging_line_del;
        }
        catch(Exception ex)
        {
        }   
        
        Shipment_lines = null;
        decimal totalpeso=0;
        decimal totalvolumen=0;
        
        lista_transpor_packaging_line_query = [select Id, Name, Transport_Packaging_Data__c, Shipment_Item_Line__c, 
        Shipment_Item_Line__r.Supplier_Total_Weight_kg__c, Shipment_Item_Line__r.Shipping_Weight_Kg__c, Shipment_Item_Line__r.Supplier_Total_Volume_m3__c,
        Shipment_Item_Line__r.Shipping_Volume_m3__c from Transport_Packaging_Line__c where Transport_Packaging_Data__c =: record.Id];
        
        for (Transport_Packaging_Line__c line: lista_transpor_packaging_line_query)
        {
            totalpeso += (line.Shipment_Item_Line__r.Supplier_Total_Weight_kg__c != null ? line.Shipment_Item_Line__r.Supplier_Total_Weight_kg__c : line.Shipment_Item_Line__r.Shipping_Weight_Kg__c);
            totalvolumen += (line.Shipment_Item_Line__r.Supplier_Total_Volume_m3__c != null ? line.Shipment_Item_Line__r.Supplier_Total_Volume_m3__c : line.Shipment_Item_Line__r.Shipping_Volume_m3__c); 
        }
        record.Total_Weight_Items_Kg__c=totalpeso;
        record.Gross_Volume__c=totalvolumen;
        
        if(container_selected != null && container_selected != '' && container_selected !='0')
            record.Container_Pallets__c = container_selected;
        
        record.Number_of_Packages__c = TotalNumberBoxes;
        record.Total_Number_Pallets__c = TotalNumberPallets;
        record.Total_Weight_Items_Kg__c =  Grossweight;
        record.Gross_Volume__c = Cube;
        
        record.N_Containers__c = TotalNumberCont;
        record.Free_Space_Container__c =FreeSpaceCont;
        record.Ocuped_Space_Container__c =decimal.valueOf(porc_ocupacion.substring(0,porc_ocupacion.length()-1));
        
        try 
        {
            update record;
        }
        
        catch(Exception ex){}
    
    }
        
}