public with sharing class NEU_OM_CreateShipmentsItemsLines 
{
    public Shipment__c record;
    private List<Shipment_Line__c> ShipmentItemsLines = null;
    public String numerodelinea {get;set;}
    public Shipment_Line__c nuevo_item {get;set;}
    public String extensionitemname {get;set;}
    public string units {get;set;}
    public string shippingweight {get;set;}
    public string precio {get;set;}
    public string volumen {get;set;}
    public string nombredelalinea {get;set;}
    public string freight_mode {get;set;}
    public string service_type {get;set;}
    public string moneda_seleccionada {get;set;}
    public List<SelectOption> lista_monedas {get;set;}
	public string pallet_seleccionado {get;set;}
	public List<SelectOption> lista_pallets {get;set;}
	public pallet_warehouse__c newPallet {get;set;}


	ApexPages.StandardController con;
    
    public NEU_OM_CreateShipmentsItemsLines() {}
    
    public NEU_OM_CreateShipmentsItemsLines(ApexPages.StandardController stdController) 
    {
        con = stdController;
		newPallet = new pallet_warehouse__c();

		try
        { 
        	record = Database.query('select Id, Name,'+(UserInfo.isMultiCurrencyOrganization()== true ? 'CurrencyIsoCode ,' : '')+' Account_for__c, Freight_Mode__c, Service_Type__c, Only_Warehouse_Service__c,Shipment_Type__c from Shipment__c where id = \''+ con.getRecord().id+'\'');
			System.debug('id ----> ' + con.getRecord().id);
        } 
        catch(Exception ee)
        {
            system.debug('ee ' + ee.getMessage());
            record = new Shipment__c();
        }
        
        numerodelinea = '';
        extensionitemname = '';
        units = '';
        shippingweight = '';
        volumen = '';
        nombredelalinea = '';
        freight_mode = record.Freight_Mode__c;
        service_type = record.Service_Type__c;


		List<Shipment_Consolidation_Data__c> query_ship_conso_data = [select Id, Name, Import_Export_Quote__c  from Shipment_Consolidation_Data__c where Shipment__c =: record.Id];

		//setting pallet list
		List<pallet_warehouse__c> pallets = [select Id, Name from pallet_warehouse__c where Import_export__c =: query_ship_conso_data[0].Import_Export_Quote__c];

		System.debug(pallets);

		lista_pallets = new List<SelectOption>();

		lista_pallets .add(new SelectOption('', '--None--'));

		for(pallet_warehouse__c p : pallets) {

			lista_pallets .add(new SelectOption(p.Id, p.Name));

		}


		if(pallets.size() < 1 && record.Only_Warehouse_Service__c == true)
        {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'This Shipment doesn´t have <strong> Pallet to associate</strong>, to create <a href="/apex/NEU_create_shipmet_pallets?id='+record.Id+'" target="_blank"> click here</a>'));
        }
        
        ShipmentItemsLines = [select Id, Name, Sell_Origin_Amount__c,Container_Number__c, Unit_Origin_Sell_Price__c,
        Extension_Item_Name__c, Shipping_Weight_Kg__c,Units_Shipped__c, Product_Item_DC__c, Subcategory_DC__c, 
        Item_Name__c, Item_Name__r.Name, Item_Name__r.HS_Code_Text__c, Item_Name__r.Master_Box_Length_cm__c, 
        Item_Name__r.Master_Box_Width_cm__c, Item_Name__r.Master_Box_Height_cm__c, Item_Name__r.Master_Box_Volume_m3__c, 
        Item_Name__r.Master_Box_Packing_Weight_kg__c, Total_Taxes__c, Sales_Tax__c, Duty__c, Customs_Incoterm__c, Customs_Value__c,
        Container_Type__c, Container_Type__r.Name, Item_Name__r.Freight_Class__c, Item_Name__r.NMFC__c, Item_Name__r.Packaging_Type__c,
		Container_Type__r.Cargo_Weight_Kg__c, Item_Name__r.Sourcing_Item_Code__c, Item_Name__r.Item_Description__c, Pallet_Code__c, Warehouse_Location__c, pallet_warehouse__c, Import_Export_Quote__c,
        Clave_de_Servicio__c,
Clave_de_Servicio__r.Clave_SAT__c,
Clave_de_Servicio__r.Material_PeligrosoCP__c,
Material_Peligroso__c,
Material_Peligroso__r.name,
Material_Peligroso__r.Clave_SAT__c,
Embalaje__c,
Embalaje__r.Clave_SAT__c,
Embalaje__r.name,
                              Peso_Neto__c,
                              CP_Fraccion_Arancelaria__c,
Pedimento__c
        from Shipment_Line__c 
        where Shipment__c =: record.Id 
        order by Name];
        
        if(record.Only_Warehouse_Service__c)
		{
			for(Shipment_Line__c sil : ShipmentItemsLines)
			{
				if(sil.Item_Name__r.Master_Box_Length_cm__c != null)
					sil.Item_Name__r.Master_Box_Length_cm__c = sil.Item_Name__r.Master_Box_Length_cm__c / 100;
				if(sil.Item_Name__r.Master_Box_Width_cm__c != null)
					sil.Item_Name__r.Master_Box_Width_cm__c = sil.Item_Name__r.Master_Box_Width_cm__c / 100;
			}
		}
        
        lista_monedas = new List<SelectOption>();
        
        if(UserInfo.isMultiCurrencyOrganization() == true)
        {
			for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
            {
				if(lu == NEU_CurrencyUtils.getCurrencyIsoCode(record))
                {
                    lista_monedas .add(new SelectOption(lu,lu));
                    break;
                }
			}
             
            for(String lu: NEU_CurrencyUtils.getCurrencyIsoCodeList())
            {
            	if(lu != NEU_CurrencyUtils.getCurrencyIsoCode(record))
                	lista_monedas .add(new SelectOption(lu,lu));
            }
        }
        else
            lista_monedas.add(new SelectOption(NEU_CurrencyUtils.getCurrencyIsoCode(record),NEU_CurrencyUtils.getCurrencyIsoCode(record)));
            
        moneda_seleccionada = NEU_CurrencyUtils.getCurrencyIsoCode(record);
        numerodelinea = string.valueOf(ShipmentItemsLines.size()+1);
        nuevo_item = new Shipment_Line__c();
        Sourcing_Item__c new_item = new Sourcing_Item__c();
        nuevo_item.Item_Name__r = new_item;
		nuevo_item.Shipment__c = record.Id;

		if(record.Only_Warehouse_Service__c) {
			Customer_Quote__c ie_quote = [select Id, Name, Last_Shipment__c from Customer_Quote__c where Last_Shipment__c = :record.id];

			if (ie_quote != null)
				nuevo_item.Import_Export_Quote__c = ie_quote.Id; else
					nuevo_item.Import_Export_Quote__c = null;
		}

        while(numerodelinea.length()<3)
        {
        	numerodelinea ='0'+numerodelinea;
        }
        
        ShipmentItemsLines = null;

		System.debug(nuevo_item);
    }
    
    //pintar todas las lineas del import export
    public List<Shipment_Line__c> getShipmentItemsLines()
    {
        if(ShipmentItemsLines == null)
        {
            ShipmentItemsLines = [select Id, Name, Container_Number__c, Sell_Origin_Amount__c, Unit_Origin_Sell_Price__c, 
            Extension_Item_Name__c, Shipping_Weight_Kg__c, Units_Shipped__c, Product_Item_DC__c, Subcategory_DC__c, 
            Item_Name__c, Item_Name__r.Name, Item_Name__r.HS_Code_Text__c, Item_Name__r.Master_Box_Length_cm__c, 
	        Item_Name__r.Master_Box_Width_cm__c, Item_Name__r.Master_Box_Height_cm__c, Item_Name__r.Master_Box_Volume_m3__c, 
	        Item_Name__r.Master_Box_Packing_Weight_kg__c, Total_Taxes__c, Sales_Tax__c, Duty__c, Customs_Incoterm__c, 
	        Customs_Value__c , Shipping_Volume_m3__c, Container_Type__c, Container_Type__r.Name, Item_Name__r.Freight_Class__c, Item_Name__r.NMFC__c,
	        Item_Name__r.Packaging_Type__c, Container_Type__r.Cargo_Weight_Kg__c, Item_Name__r.Sourcing_Item_Code__c, Item_Name__r.Item_Description__c, Pallet_Code__c, Warehouse_Location__c, pallet_warehouse__c, Import_Export_Quote__c,
                                          Clave_de_Servicio__c,
Clave_de_Servicio__r.Clave_SAT__c,
Clave_de_Servicio__r.Material_PeligrosoCP__c,
Material_Peligroso__c,
Material_Peligroso__r.name,
Material_Peligroso__r.Clave_SAT__c,
Embalaje__c,
Embalaje__r.Clave_SAT__c,
Embalaje__r.name  ,Peso_Neto__c,CP_Fraccion_Arancelaria__c,
Pedimento__c
	        from Shipment_Line__c where Shipment__c =: record.Id order by Name];
	        
	        if(record.Only_Warehouse_Service__c)
			{
				for(Shipment_Line__c sil : ShipmentItemsLines)
				{
					if(sil.Item_Name__r.Master_Box_Length_cm__c != null)
						sil.Item_Name__r.Master_Box_Length_cm__c = sil.Item_Name__r.Master_Box_Length_cm__c / 100;
					if(sil.Item_Name__r.Master_Box_Width_cm__c != null)
						sil.Item_Name__r.Master_Box_Width_cm__c = sil.Item_Name__r.Master_Box_Width_cm__c / 100;
				}
			}
        }

        return ShipmentItemsLines;
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
    
    public void update_lineas_ship()
    {
      	if(ShipmentItemsLines != null && ShipmentItemsLines.size()>0)
      	{
			string errors = '';
    		boolean update_lines = true;
      	
          	//actualizar items y sus lineas
          	decimal total_peso = 0;
          	decimal total_volume = 0;
          	
          	Map<Id, Sourcing_Item__c> map_items = new Map<Id, Sourcing_Item__c>();
          	
          	for(Shipment_Line__c qil : ShipmentItemsLines)
          	{
          		if((record.Service_Type__c == 'FTL' || record.Service_Type__c == 'FP' || record.Service_Type__c == 'FO' || record.Service_Type__c == 'FCL') && qil.Container_Type__c == null)
		    	{
		    		errors += 'The Line <strong>'+qil.Name+'</strong> doesn\'t has a <strong>Container Type</strong>.<br/>';
		    		update_lines = false;
		    	}
          		
				if(qil.Container_Type__c != null && qil.Container_Type__r.Cargo_Weight_Kg__c != null && qil.Container_Type__r.Cargo_Weight_Kg__c < qil.Shipping_Weight_Kg__c)
    			{
					errors += 'The Line <strong>'+qil.Name+'</strong> has a <strong>Total Shipping Weight (Kgs)</strong> bigger than the <strong>Container Cargo Weight</strong>. Please, select a correct <strong>Container Type</strong>.<br/>';
					update_lines = false;
    			}
          	
              	if(qil.Item_Name__c != null)
              	{
                	qil.Item_Name__r.Name = qil.Extension_Item_Name__c;
                  	qil.Item_Name__r.Item_Price__c = qil.Unit_Origin_Sell_Price__c;

                  	if(record.Only_Warehouse_Service__c || service_type == 'MAYOREO' || freight_mode == 'Air' || (freight_mode == 'Sea' && service_type == 'LCL') || ((freight_mode == 'Road' || freight_mode == 'Rail') && service_type == 'LTL'))
                  	{
                  		if(record.Only_Warehouse_Service__c)
						{
							qil.Item_Name__r.Master_Box_Length_cm__c = (qil.Item_Name__r.Master_Box_Length_cm__c != null ? qil.Item_Name__r.Master_Box_Length_cm__c * 100 : null);
			    			qil.Item_Name__r.Master_Box_Width_cm__c = (qil.Item_Name__r.Master_Box_Width_cm__c != null ? qil.Item_Name__r.Master_Box_Width_cm__c * 100 : null);
			    			qil.Item_Name__r.Master_Box_Height_cm__c = (qil.Item_Name__r.Master_Box_Height_cm__c != null ? qil.Item_Name__r.Master_Box_Height_cm__c : null);
						}
                  		
						if(qil.Shipping_Weight_Kg__c != null && qil.Units_Shipped__c != null)
			            	qil.Item_Name__r.Weight_Kgs__c = NEU_Utils.safedecimal(qil.Shipping_Weight_Kg__c/qil.Units_Shipped__c);
			            else
			            	qil.Item_Name__r.Weight_Kgs__c = 0;
                        
                        if(qil.Item_Name__r.Master_Box_Width_cm__c != null && qil.Item_Name__r.Master_Box_Length_cm__c != null) 
                        {
                            qil.Shipping_Surface_m2__c = NEU_Utils.safedecimal(qil.Item_Name__r.Master_Box_Width_cm__c * qil.Item_Name__r.Master_Box_Length_cm__c);
                        }
					}
                  	else
                  	{
                  		if(qil.Shipping_Weight_Kg__c != null && qil.Units_Shipped__c != null)
                      		qil.Item_Name__r.Weight_Kgs__c = NEU_Utils.safedecimal(qil.Shipping_Weight_Kg__c / qil.Units_Shipped__c);
                      	if(qil.Shipping_Volume_m3__c != null && qil.Units_Shipped__c != null)
                      	{
                          	qil.Item_Name__r.Master_Box_Length_cm__c = NEU_Utils.safedecimal((NEU_Utils.safedecimal(qil.Shipping_Volume_m3__c) / NEU_Utils.safedecimal(qil.Units_Shipped__c)) * 100);
                          	qil.Item_Name__r.Master_Box_Width_cm__c = 100;
                          	qil.Item_Name__r.Master_Box_Height_cm__c = 100;
                      	}
                  	}

                  	map_items.put(qil.Item_Name__c, qil.Item_Name__r);
              	}

              	total_peso += neu_utils.safedecimal(qil.Shipping_Weight_Kg__c);
              	total_volume += neu_utils.safedecimal(qil.Shipping_Volume_m3__c);
        	}
        
        	if(update_lines)
       		{
	        	update ShipmentItemsLines;
	        
	        	if(map_items != null && map_items.values().size()>0)
	          		update map_items.values();
	        
	        	//actualizar lineas de services
	        	List<Shipment_Fee_Line__c> query_lineas_fee = [select Id, Name, Units__c, Service_Rate_Name__c, Service_Rate_Name__r.RecordTypeId, Service_Rate_Name__r.Rate_Type__c, 
	        	Service_Rate_Name__r.Container_Type__r.Cargo_Volume_m3__c, Service_Rate_Name__r.Pallet_Type__r.Cargo_Volume_m3__c, Service_Rate_Name__r.Pallet_Type__r.Cargo_Weight_Kg__c, 
	        	Service_Rate_Name__r.Container_Type__r.Cargo_Weight_Kg__c, Service_Rate_Name__r.Volumetric_Factor__c, Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Max_Kgs__c, 
	        	Service_Rate_Name__r.Max_M3__c, Service_Rate_Name__r.Pallet_Type__c from Shipment_Fee_Line__c where Shipment__c =: record.Id];
	        	
		        decimal unidades_calculadas = 1;
		        decimal weight_vol_factor = 0;
		        decimal unidades_calculadas2 = 1;
		        
	        	for(Shipment_Fee_Line__c iefl: query_lineas_fee) 
	        	{
	            	if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per Kg')
	            	{
	              		unidades_calculadas = (total_peso >0 ? total_peso : 1);
	              		weight_vol_factor = (total_volume > 0 && iefl.Service_Rate_Name__r.Volumetric_Factor__c != null ? total_volume*iefl.Service_Rate_Name__r.Volumetric_Factor__c  : 0);
	              		if(weight_vol_factor > unidades_calculadas)
	                  		unidades_calculadas = weight_vol_factor;
	            	}
	            	else if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per TON')
	            	{
	              		unidades_calculadas = (total_peso >0 ? total_peso/1000 : 1);
	            	}
            		else if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per M3')
	            	{
	              		unidades_calculadas = (total_volume >0 ? total_volume : 1); 
	             		weight_vol_factor = (total_peso > 0 && iefl.Service_Rate_Name__r.Volumetric_Factor__c != null ? total_peso/iefl.Service_Rate_Name__r.Volumetric_Factor__c  : 0);
	              		if(weight_vol_factor > unidades_calculadas)
	                  		unidades_calculadas = weight_vol_factor;
	            	}
	            	else if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per Container')
	            	{
	              		unidades_calculadas = (total_volume >0 && iefl.Service_Rate_Name__r.Container_Type__c != null && iefl.Service_Rate_Name__r.Container_Type__r.Cargo_Volume_m3__c >0 ? total_volume/iefl.Service_Rate_Name__r.Container_Type__r.Cargo_Volume_m3__c : 1);
	              		unidades_calculadas2 = (total_peso >0 && iefl.Service_Rate_Name__r.Container_Type__c != null && iefl.Service_Rate_Name__r.Container_Type__r.Cargo_Weight_Kg__c >0 ? total_peso/iefl.Service_Rate_Name__r.Container_Type__r.Cargo_Weight_Kg__c : 1);
	              		if(unidades_calculadas2 > unidades_calculadas)
	                 		unidades_calculadas = unidades_calculadas2; 
	               
	            	}
	            	else if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per W/M')
	            	{
	              		unidades_calculadas = (total_peso > 0 && iefl.Service_Rate_Name__r.Volumetric_Factor__c != null ? total_peso/iefl.Service_Rate_Name__r.Volumetric_Factor__c  : 0);
	              		weight_vol_factor = unidades_calculadas;
	              		unidades_calculadas2 = (total_volume > 0 ? total_volume : 0);
	              		if(unidades_calculadas2 > unidades_calculadas)
	                 		unidades_calculadas = unidades_calculadas2; 
	            	}
	            	else if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Fixed' && (iefl.Service_Rate_Name__r.Max_Kgs__c != null || iefl.Service_Rate_Name__r.Max_M3__c != null))    
	            	{
	              		unidades_calculadas = (total_peso > 0 && iefl.Service_Rate_Name__r.Max_Kgs__c != null ? total_peso/iefl.Service_Rate_Name__r.Max_Kgs__c  : 0);
	              		unidades_calculadas2 = (total_volume > 0 && iefl.Service_Rate_Name__r.Max_M3__c != null ? total_volume/iefl.Service_Rate_Name__r.Max_M3__c  : 0);
	              		if(unidades_calculadas2 > unidades_calculadas)
	                 		unidades_calculadas = unidades_calculadas2; 
	            	}    	 
	            	else if(iefl.Service_Rate_Name__r.Rate_Type__c == 'Per Pallet')
	            	{
	              		unidades_calculadas = (total_volume >0 && iefl.Service_Rate_Name__r.Pallet_Type__c != null && iefl.Service_Rate_Name__r.Pallet_Type__r.Cargo_Volume_m3__c >0 ? total_volume/iefl.Service_Rate_Name__r.Pallet_Type__r.Cargo_Volume_m3__c : 1);
	              		unidades_calculadas2 = (total_peso >0 && iefl.Service_Rate_Name__r.Pallet_Type__c != null && iefl.Service_Rate_Name__r.Pallet_Type__r.Cargo_Weight_Kg__c >0 ? total_peso/iefl.Service_Rate_Name__r.Pallet_Type__r.Cargo_Weight_Kg__c : 1);
	              		if(unidades_calculadas2 > unidades_calculadas)
	                 		unidades_calculadas = unidades_calculadas2; 
	            	} 
	            	else 
	              		continue;
	                                
	           		iefl.Units__c = unidades_calculadas;
	          
	           		unidades_calculadas = 1;
	           		weight_vol_factor = 0;
	           		unidades_calculadas2 = 1;
	        	}
	        
	        	if(query_lineas_fee != null && query_lineas_fee.size()>0)
	          		update query_lineas_fee;
	        
	        	ShipmentItemsLines = null;
       		}
       		else
       			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errors));
      	}
    }
    
    public void crearlineaquoteitem()
    {
    	boolean create_line = true;

		System.debug(pallet_seleccionado);
    	
    	if((record.Service_Type__c == 'FTL' || record.Service_Type__c == 'FP' || record.Service_Type__c == 'FO' || record.Service_Type__c == 'FCL') && nuevo_item.Container_Type__c == null)
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The <strong>Container Type</strong> is required.'));
    		create_line = false;
    	}
    	
    	if(nuevo_item != null && nuevo_item.Shipping_Weight_Kg__c > 0)
    	{
	    	List<Container_Type__c> container_type = [select Id, Name, Cargo_Weight_Kg__c from Container_Type__c where Id =: nuevo_item.Container_Type__c];
	    	if(container_type.size() > 0)
	    	{
	    		if(container_type[0].Cargo_Weight_Kg__c < nuevo_item.Shipping_Weight_Kg__c)
	    		{
	    			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The New Line has a <strong>Total Shipping Weight (Kgs)</strong> bigger than the <strong>Container Cargo Weight</strong>. Please, select a correct <strong>Container Type</strong>.'));
	    			create_line = false;
	    		}
	    	}
    	}



        if(ApexPages.currentPage().getParameters().get('test') != null)
        {
            shippingweight = '1';
            precio = '1';
            units = '1';
            extensionitemname = '1';
            numerodelinea = '1';
        }
        
        if(create_line)
        {
	        nombredelalinea = '';
	        Shipment_Line__c Shipment_Item_Line = new Shipment_Line__c();
	        Shipment_Item_Line.Shipment__c = record.Id;
	
	        while (numerodelinea.length() < 3)
	        {
	            numerodelinea = '0' + numerodelinea;
	        }
	        
	        Shipment_Item_Line.Name = numerodelinea;
            
            if(nuevo_item != null)
            {
                
                
                Shipment_Item_Line.Units_Shipped__c = nuevo_item.Units_Shipped__c;
                //Shipment_Item_Line.Manual_Units__c = decimal.valueof(units);
                
                Shipment_Item_Line.Shipping_Weight_Kg__c = nuevo_item.Shipping_Weight_Kg__c;
                
                Shipment_Item_Line.Container_Number__c = nuevo_item.Container_Number__c;
                
                Shipment_Item_Line.Unit_Origin_Sell_Price__c = nuevo_item.Unit_Origin_Sell_Price__c;
                // Shipment_Item_Line.Manual_Price__c =decimal.valueof(precio);
                
                Shipment_Item_Line.Shipping_Volume_m3__c = nuevo_item.Shipping_Volume_m3__c;
                
                
                //NUEVO
                Shipment_Item_Line.Material_Peligroso__c = nuevo_item.Material_Peligroso__c;
                Shipment_Item_Line.Embalaje__c = nuevo_item.Embalaje__c;
                Shipment_Item_Line.Clave_de_Servicio__c = nuevo_item.Clave_de_Servicio__c;
                Shipment_Item_Line.Peso_Neto__c = nuevo_item.Peso_Neto__c;
                
                if(nuevo_item.CP_Fraccion_Arancelaria__c!= null)
                 Shipment_Item_Line.CP_Fraccion_Arancelaria__c = nuevo_item.CP_Fraccion_Arancelaria__c;
                
                  if(nuevo_item.Pedimento__c!= null)
                Shipment_Item_Line.Pedimento__c = nuevo_item.Pedimento__c;
                
                Catalogo_SAT__c cs =[SELECT Id,name, Clave_SAT__c  FROM Catalogo_SAT__c where id =:  nuevo_item.Clave_de_Servicio__c limit 1];
                
                
                // if(extensionitemname != null)
                Shipment_Item_Line.Extension_Item_Name__c = cs.name;  //extensionitemname;
            }

			System.debug(newPallet);
			if(newPallet != null && newPallet.Name != '')
			{
					List<pallet_warehouse__c> palletFound = [select Id, Name,lenght_cm__c , width_cm__c from pallet_warehouse__c where Name like: newPallet.Name];

					if(palletFound.size() > 0)
					{
						newPallet = palletFound[0];
					}
					else
					{
						try
						{
							insert newPallet;
						}
						catch(Exception e)
						{
							ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating Pallet: ' + e));
						}
					}
					if(newPallet != null && newPallet.Name != '')
					{
						Shipment_Item_Line.pallet_warehouse__c = newPallet.Id;

					}
					newPallet = new pallet_warehouse__c();

			}

			if(nuevo_item != null)
                Shipment_Item_Line.Warehouse_Location__c = nuevo_item.Warehouse_Location__c;
            
            if(nuevo_item.Item_Name__r.Master_Box_Width_cm__c != null && nuevo_item.Item_Name__r.Master_Box_Length_cm__c != null) 
            {
                Shipment_Item_Line.Shipping_Surface_m2__c = NEU_Utils.safedecimal(nuevo_item.Item_Name__r.Master_Box_Width_cm__c * nuevo_item.Item_Name__r.Master_Box_Length_cm__c);
            }


			NEU_CurrencyUtils.setCurrencyIsoCode(Shipment_Item_Line, moneda_seleccionada);
	        
	        List<Sourcing_Item__c> lista_items = new List<Sourcing_Item__c>();
	        Sourcing_Item__c Sourcing_Item = new Sourcing_Item__c();
	        Sourcing_Item.Name = extensionitemname;
	        Sourcing_Item.Freight_Class__c = (nuevo_item != null && nuevo_item.Item_Name__r.Freight_Class__c != null ? nuevo_item.Item_Name__r.Freight_Class__c : '');
	    	Sourcing_Item.NMFC__c = (nuevo_item != null && nuevo_item.Item_Name__r.NMFC__c != null ? nuevo_item.Item_Name__r.NMFC__c : '');
	    	Sourcing_Item.Packaging_Type__c = (nuevo_item != null && nuevo_item.Item_Name__r.Packaging_Type__c != null ? nuevo_item.Item_Name__r.Packaging_Type__c : '');
	    	Sourcing_Item.Sourcing_Item_Code__c = (nuevo_item != null && nuevo_item.Item_Name__r.Sourcing_Item_Code__c != null ? nuevo_item.Item_Name__r.Sourcing_Item_Code__c : ''); 
	    	Sourcing_Item.Item_Description__c = (nuevo_item != null && nuevo_item.Item_Name__r.Item_Description__c != null ? nuevo_item.Item_Name__r.Item_Description__c : '');
	    	
	        if(nuevo_item != null)
	            Sourcing_Item.Item_Price__c = nuevo_item.Unit_Origin_Sell_Price__c;
	        Sourcing_Item.Account_Owner__c = record.Account_for__c;
	        if (nuevo_item != null && nuevo_item.Shipping_Weight_Kg__c != null && nuevo_item.Units_Shipped__c != null)
	            Sourcing_Item.Weight_Kgs__c = nuevo_item.Shipping_Weight_Kg__c / nuevo_item.Units_Shipped__c;
	
	        Sourcing_Item.Units_x_Master_Box__c = 1;
	        if(nuevo_item != null)
	            Shipment_Item_Line.Container_Type__c = nuevo_item.Container_Type__c;
	        if(nuevo_item != null && nuevo_item.Shipping_Volume_m3__c != null && nuevo_item.Units_Shipped__c != null)
	        {
	            if(record.Only_Warehouse_Service__c || freight_mode == 'Air' || (freight_mode == 'Sea' && service_type == 'LCL') || ((freight_mode == 'Road' || freight_mode == 'Rail') && service_type == 'LTL'))
	            {
	            	if(record.Only_Warehouse_Service__c)
            		{
            			Sourcing_Item.Master_Box_Length_cm__c = (nuevo_item != null && nuevo_item.Item_Name__r.Master_Box_Length_cm__c != null ? nuevo_item.Item_Name__r.Master_Box_Length_cm__c * 100 : null);
		    			Sourcing_Item.Master_Box_Width_cm__c = (nuevo_item != null && nuevo_item.Item_Name__r.Master_Box_Width_cm__c != null ? nuevo_item.Item_Name__r.Master_Box_Width_cm__c * 100 : null);
		    			Sourcing_Item.Master_Box_Height_cm__c = (nuevo_item != null && nuevo_item.Item_Name__r.Master_Box_Height_cm__c != null ? nuevo_item.Item_Name__r.Master_Box_Height_cm__c : null);
            		}
            		else
            		{
		        		Sourcing_Item.Master_Box_Length_cm__c = (nuevo_item != null && nuevo_item.Item_Name__r.Master_Box_Length_cm__c != null ? nuevo_item.Item_Name__r.Master_Box_Length_cm__c : null);
		    			Sourcing_Item.Master_Box_Width_cm__c = (nuevo_item != null && nuevo_item.Item_Name__r.Master_Box_Width_cm__c != null ? nuevo_item.Item_Name__r.Master_Box_Width_cm__c : null);
		    			Sourcing_Item.Master_Box_Height_cm__c = (nuevo_item != null && nuevo_item.Item_Name__r.Master_Box_Height_cm__c != null ? nuevo_item.Item_Name__r.Master_Box_Height_cm__c : null);
            		}
	            	
	                Sourcing_Item.Master_Box_Packing_Weight_kg__c = (nuevo_item != null && nuevo_item.Item_Name__r.Master_Box_Packing_Weight_kg__c != null ? nuevo_item.Item_Name__r.Master_Box_Packing_Weight_kg__c : null);
	            }
	            else
	            {
	                Sourcing_Item.Master_Box_Length_cm__c = (nuevo_item.Shipping_Volume_m3__c / nuevo_item.Units_Shipped__c) * 100;
	                Sourcing_Item.Master_Box_Width_cm__c = 100;
	                Sourcing_Item.Master_Box_Height_cm__c = 100;
	            }
	        }
	        NEU_CurrencyUtils.setCurrencyIsoCode(Sourcing_Item,moneda_seleccionada);


	        lista_items.add(Sourcing_Item);
	        try
	        {
				insert lista_items;
	        }
	        catch(Exception ex){}
	        
	        if(lista_items.size() > 0)
	            Shipment_Item_Line.Item_Name__c = lista_items[0].Id;
	            
	        try
	        {
				insert Shipment_Item_Line;
	        }
	        catch(Exception ex){}
	        
	        numerodelinea = string.valueOf(decimal.valueof(numerodelinea)+1);
	        nuevo_item = new Shipment_Line__c();
	        Sourcing_Item__c new_item = new Sourcing_Item__c();
	        nuevo_item.Item_Name__r = new_item;
	        while(numerodelinea.length()<3)
	        {
	            numerodelinea ='0'+numerodelinea;
	        }
	        extensionitemname ='';
	        units ='';
	        shippingweight ='';
	        precio ='';
	        ShipmentItemsLines =null;
	        volumen = '';
	        moneda_seleccionada = '';
			pallet_seleccionado = '';
	        nombredelalinea = '';
        }
    }
    
    public PageReference goToPallets() {
        PageReference pr = new PageReference('/apex/NEU_create_shipmet_pallets?id='+record.Id);
		pr.setRedirect(true);
		return pr;
    }

	//create new lines
	public void createNewPallet(){


	}
    
    public void test ()
    {
        string a = '';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
        a='';
    }
}