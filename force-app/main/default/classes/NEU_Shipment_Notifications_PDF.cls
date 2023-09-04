public with sharing class NEU_Shipment_Notifications_PDF {
    
    public Shipment__c record;
    
    public List<Quote_Item_Line__c> lst_cargo_lines_ie;
    
    public string string_pdf {get;set;}
    public string logotipo {get;set;}
    public string cuerpo_notificacion {get;set;}
    public string asunto {get;set;}
    
    public List<Shipment_Fee_Line__c> listado_de_lineas_de_fees {get; set;}{
        listado_de_lineas_de_fees = new List<Shipment_Fee_Line__c>();
    }
    
    public List<Shipment_Line__c> query_shipment_lines {get; set;}{
        query_shipment_lines = new List<Shipment_Line__c>();
    }

    public Integer optionTemplate { get; set; }
    {
       optionTemplate = 1;
    }
    
    public Integer optionLanguage { get; set; }
    {
       optionLanguage = 1;
    }
        
    ApexPages.StandardController con;
            
    public NEU_Shipment_Notifications_PDF(ApexPages.StandardController stdController) 
    {
        con = stdController;

		/* DATOS DEL SHIPMENT */   
		try { 
			record = [
				select Id, Name, Equipment__c, Flight_Number__c, Service_Mode__c, Account_Shipment_Reference__c, Shipment_Status_Plann__c,
					ETA_Point_of_Discharge__c, ETA_Time_Point_of_Discharge__c, ETD_from_Point_of_Load__c, ETD_Time_from_Point_of_Load__c,
					Departure_Time__c, Loading_Time_Hours__c, Unloading_Time_Hours__c, Equip_Loaded__c, Equip_Placed__c, Equip_Unloaded__c, Equip_Reserved__c, Equip_Solicited__c, 
					MAWB_Number__c, Service_Type__c, Freight_Mode__c, HBL_Number__c, MBL_Number__c, Voyage_Number_s__c, Voyage_Number__c, Sea_Booking_Number__c, 
					Sea_Container_Number__c, Special_Notes__c, Positioning__c, Positioning_Schedule__c,
					Truck_Number__c, Trailer_Number__c, Total_Transit_Time_Hours__c, Shipment_Status__c, Shipment_Status_Mon__c,
					Account_for__c, Account_for__r.Name, Consignee__c, Consignee__r.Name,  Carrier__c, Carrier__r.Name,
					Supplier_Account__c, Supplier_Account__r.Name, Forwarder__c, Notify_Party__r.Name, Total_Weight_Kg__c,
					Country_of_Load__c, Country_of_Load__r.Name, Country_of_Discharge__c, Country_of_Discharge__r.Name, 
					State_of_Load__c, State_of_Load__r.Name, State_of_Discharge__c, State_of_Discharge__r.Name,
					Site_of_Load__c, Site_of_Load__r.Name, Site_of_Discharge__c, Site_of_Discharge__r.Name, Nature_Merchandise__c,
					Truck_Vessel_Flight__c, Truck_Vessel_Flight__r.Name, Container_Type__r.Name, Account_for_Customer_Name__c,
					National_Operator__c, National_Operator__r.Name, Vehicle__c, Vehicle__r.Name, Vehicle__r.Num_Placa_Caja__c, Vehicle__r.Num_Placa_Caja_2__c,
					Name_Cliente__c, Workplace_PlannerFN__c, FN_Remission__c, FN_Confirmation__c, FN_Sale_Order_Number__c, FN_Purchase_Order_Number__c,
					FN_Invoice_Number__c, FN_Trip_Term__c, FN_Report_of_the_Day__c, FN_Rampa__c, FN_Enrampe_Time__c, FN_Receipt_of_Sheets__c, FN_Concentrado_Monitoreo__c, ATA__c, ATD__c, Monitoreo_Executive__c
				from Shipment__c where id = :con.getRecord().id
			];
            // Closing_of_Documents__c, Closing_of_Dispach__c
            
		} catch( Exception ee) { 
			record = new Shipment__c();
		}

        /* DATOS CARGO LINES */ 
        try{  
            query_shipment_lines = [select id, Name, Item_Name__c, Shipping_Weight_Kg__c, Shipping_Volume_m3__c, 
                                    Container_Number__c, Extension_Item_Name__c, Units_Shipped__c, Item_Name__r.Name 
                                    from Shipment_Line__c where Shipment__c =: record.Id order by Name];
        } catch(Exception ee) { 
            query_shipment_lines = new List<Shipment_Line__c>();
        }
        
        /* DATOS SERVICE LINES */
        try{  
            listado_de_lineas_de_fees = [select Id, Name, Service_Rate_Name__r.Name, Rate_Type__c, Units__c, Sell_Rate__c  
                                         from Shipment_Fee_Line__c where Shipment__c =: record.Id order by Name];
        } catch(Exception ee) { 
            listado_de_lineas_de_fees = new List<Shipment_Fee_Line__c>();
        }
          
        cuerpo_notificacion = '';
    
        if(ApexPages.currentPage().getParameters().get('optionTemplate') != null)
        {
            optionTemplate = integer.valueof(ApexPages.currentPage().getParameters().get('optionTemplate'));
        }
        
        if(ApexPages.currentPage().getParameters().get('optionLanguage') != null)
        {
            optionLanguage = integer.valueof(ApexPages.currentPage().getParameters().get('optionLanguage'));
        }
    }
    
    public void load_template()
    {
    	logotipo = '';
    	List<Document> query_logo = [Select Id from Document where Name = 'logo_pak2go_notifications'];
    	if(query_logo.size() > 0)
    		logotipo = '<img src="'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+query_logo[0].Id+'&oid='+UserInfo.getOrganizationId()+'"/>';
    	
        if(optionTemplate==1)
        {
            if(optionLanguage==1)
            {
                asunto = 'Arrival Confirmation: ' + record.Name;
                load_template_arrival_confirmation_english(); 
            }
            else
            {
                asunto = 'Confirmación de Arribo: ' + record.Name;
                load_template_arrival_confirmation_spanish(); 
            }
        }
        else if (optionTemplate==2)
        {
            if(optionLanguage==1)
            {
                asunto = 'Arrival Notification: ' + record.Name;
                load_template_arrival_notification_english(); 
            }
            else
            {
                asunto = 'Notificación de Arribo: ' + record.Name;
                load_template_arrival_notification_spanish(); 
            }           
        }
        else if (optionTemplate==3)
        {
            if(optionLanguage==1)
            {
                asunto = 'Shipment Tracking: ' + record.Name;
				load_template_shipment_tracking_english_ata();
            }
            else
            {
                asunto = 'Seguimiento de Embarque: ' + record.Name;
				load_template_shipment_tracking_spanish_ata();
            }           
        }
        else if (optionTemplate==4)
        {
            if(optionLanguage==1)
            {
                asunto = 'Departure Confirmation: ' + record.Name;
                load_template_departure_confirmation_english(); 
            }
            else
            {
                asunto = 'Confirmación de Zarpe: ' + record.Name;
                load_template_departure_confirmation_spanish(); 
            }           
        }
        else if (optionTemplate==5)
        {
            if(optionLanguage==1)
            {
                asunto = 'Booking Confirmation: ' + record.Name;
                load_template_booking_confirmation_english(); 
            }
            else
            {
                asunto = 'Confirmación de Booking: ' + record.Name;
                load_template_booking_confirmation_spanish(); 
            }           
        }
        else if (optionTemplate==6)
        {
            if(optionLanguage==1)
            {
                asunto = 'Departure Timetable: ' + record.Name;
                load_template_departure_timetable_english(); 
            }
            else
            {
                asunto = 'Itinerario de Salida: ' + record.Name;
                load_template_departure_timetable_spanish(); 
            }           
        }
		else if (optionTemplate==7)
		{
			if(optionLanguage==1)
			{
				asunto = 'Departure Confirmation FI: ' + record.Name;
				load_template_departure_confirmationFI_english();
			}
			else
			{
				asunto = 'Confirmación de Zarpe FI: ' + record.Name;
				load_template_departure_confirmationFI_spanish();
			}
		}
		else if (optionTemplate==20)
		{
			if(optionLanguage==1)
			{
				asunto = 'FN - Standard: ' + record.Name;
				load_template_fn_estandar_english();
			}
			else
			{
				asunto = 'FN - Estándar: ' + record.Name;
				load_template_fn_estandar_spanish();
			}
		}
		else if (optionTemplate==21)
		{
			List<Shipment_Line__c> lst_cargo_lines_shipment = [
				SELECT Id, Name, Import_Export_Quote__c
				FROM Shipment_Line__c
				WHERE Shipment__c =: record.Id
			];
			
			Set<Id> lst_cargo_lines_ie_ids = new Set<Id>();
			for(Shipment_Line__c shipment_line : lst_cargo_lines_shipment){
				lst_cargo_lines_ie_ids.add(shipment_line.Import_Export_Quote__c);
			}
			
			
			lst_cargo_lines_ie = [
				SELECT Id, Name, Extension_Item_Name__c, Item_Name__c, Item_Name__r.Name
				FROM Quote_Item_Line__c
				WHERE Import_Export_Quote__c IN:lst_cargo_lines_ie_ids
			];
			
			if(optionLanguage==1)
			{
				asunto = 'FN - Manantiales la Asuncion: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_manantiales_asuncion_english();
			}
			else
			{
				asunto = 'FN - Manantiales la Asuncion: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_manantiales_asuncion_spanish();
			}
		}
		else if (optionTemplate==22)
		{
			if(optionLanguage==1)
			{
				asunto = 'FN - Cerveceria Modelo: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_cerveceria_modelo_english();
			}
			else
			{
				asunto = 'FN - Cerveceria Modelo: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_cerveceria_modelo_spanish();
			}
		}
		else if (optionTemplate==23)
		{
			if(optionLanguage==1)
			{
				asunto = 'FN - Owens: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_owens_english();
			}
			else
			{
				asunto = 'FN - Owens: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_owens_spanish();
			}
		}
		else if (optionTemplate==24)
		{
			if(optionLanguage==1)
			{
				asunto = 'FN - Kimberly Clark: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_kimberly_clark_english();
			}
			else
			{
				asunto = 'FN - Kimberly Clark: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_kimberly_clark_spanish();
			}
		}
		else if (optionTemplate==25)
		{
			if(optionLanguage==1)
			{
				asunto = 'FN - Bonafont: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_bonafont_english();
			}
			else
			{
				asunto = 'FN - Bonafont: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_bonafont_spanish();
			}
		}
		else if (optionTemplate==26)
		{
			if(optionLanguage==1)
			{
				asunto = 'FN - Barcel: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_barcel_english();
			}
			else
			{
				asunto = 'FN - Barcel: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_barcel_spanish();
			}
		}
		else if (optionTemplate==27)
		{
			if(optionLanguage==1)
			{
				asunto = 'FN - Sealy: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_sealy_english();
			}
			else
			{
				asunto = 'FN - Sealy: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_sealy_spanish();
			}
		}
		else if (optionTemplate==28)
		{
			if(optionLanguage==1)
			{
				asunto = 'FN - Standard: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_estandar_customer_english();
			}
			else
			{
				asunto = 'FN - Estándar: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_fn_estandar_customer_spanish();
			}
		}
		else if (optionTemplate==29)
		{
			if(optionLanguage==1)
			{
				asunto = 'PTO - Standard: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_pto_estandar_english();
			}
			else
			{
				asunto = 'PTO - Estándar: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_pto_estandar_spanish();
			}
		}
		else if (optionTemplate==30)
		{
			if(optionLanguage==1)
			{
				asunto = 'Air Shipment Tracking: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_air_shipment_tracking_english();
			}
			else
			{
				asunto = 'Air Shipment Tracking: ' + record.Name + ' - ' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '/'+ NEU_Utils.safeString(record.Site_of_Discharge__r.Name);
				load_template_air_shipment_tracking_spanish();
			}
		}
		
		string_pdf = cuerpo_notificacion;
	}
	
	/* ######################## COMIENZO PLANTILLAS ######################## */
	
	public void load_template_fn_estandar_english(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - STANDARD</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_estandar_spanish(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - ESTANDAR</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_manantiales_asuncion_english(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - MANANTIALES LA ASUNCION</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Reference</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Invoice</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Purchase Order</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Effective date</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Date of Delivery</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Appointment time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Confirmation Number</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Transportation Line</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Report of the Day</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Note</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Ramp</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Enrampe Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folios Receipt</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Planner</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Place</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Remission__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Invoice_Number__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Purchase_Order_Number__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Confirmation__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + (record.Carrier__c != null ? record.Carrier__r.Name : '') + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Report_of_the_Day__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Name) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Rampa__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Enrampe_Time__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Receipt_of_Sheets__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Plann__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Workplace_PlannerFN__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_manantiales_asuncion_spanish(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - MANANTIALES LA ASUNCION</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Reference</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Invoice</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Purchase Order</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Effective date</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Date of Delivery</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Appointment time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Confirmation Number</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Transportation Line</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Report of the Day</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Note</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Ramp</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Enrampe Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folios Receipt</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Planner</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Place</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Remission__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Invoice_Number__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Purchase_Order_Number__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Confirmation__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + (record.Carrier__c != null ? record.Carrier__r.Name : '') + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Report_of_the_Day__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Name) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Rampa__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Enrampe_Time__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Receipt_of_Sheets__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Plann__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Workplace_PlannerFN__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_cerveceria_modelo_english(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - CERVECERIA MODELO</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cadena</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Confirmation</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Note</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + record.Name + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Confirmation__c) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + ' ' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_cerveceria_modelo_spanish(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - CERVECERIA MODELO</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cadena</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Confirmation</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Note</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + record.Name + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Confirmation__c) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + ' ' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_owens_english(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - OWENS</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Box(1) Registration Number</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Box(2) Registration Number</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Note</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Num_Placa_Caja__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Num_Placa_Caja_2__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_owens_spanish(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - OWENS</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Box(1) Registration Number</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Box(2) Registration Number</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Note</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Num_Placa_Caja__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Num_Placa_Caja_2__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_kimberly_clark_english(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - KIMBERLY CLARK</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Confirmation</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Concentrate Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Trip Term</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Note</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Confirmation__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Concentrado_Monitoreo__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + ' ' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Trip_Term__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_kimberly_clark_spanish(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - KIMBERLY CLARK</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Confirmation</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Concentrate Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Trip Term</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Note</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Confirmation__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Concentrado_Monitoreo__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + ' ' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Trip_Term__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_bonafont_english(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - BONAFONT</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Original Order</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Order</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_Shipment_Reference__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Concentrado_Monitoreo__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_bonafont_spanish(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - BONAFONT</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Original Order</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Order</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_Shipment_Reference__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Concentrado_Monitoreo__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_barcel_english(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - BARCEL</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Orden de Venta</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Hora</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA / Hora</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Sale_Order_Number__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + ' ' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_barcel_spanish(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - BARCEL</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Orden de Venta</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Hora</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA / Hora</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Sale_Order_Number__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + ' ' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_sealy_english(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - SEALY</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Orden de Venta</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Hora</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA / Hora</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Sale_Order_Number__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + ' ' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_sealy_spanish(){
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - SEALY</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Orden de Venta</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD / Hora</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA / Hora</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.FN_Sale_Order_Number__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETD_from_Point_of_Load__c) + ' ' + NEU_Utils.safeString(record.ETD_Time_from_Point_of_Load__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.ETA_Point_of_Discharge__c) + ' ' + NEU_Utils.safeString(record.ETA_Time_Point_of_Discharge__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	
	public void load_template_arrival_confirmation_english()
	{
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">ARRIVAL CONFIRMATION</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_arrival_confirmation_spanish()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">CONFIRMACIÓN DE ARRIBO</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_arrival_notification_english()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">ARRIVAL NOTIFICATION</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ATD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ATD__c != null ? record.ATD__c.day()+'/'+record.ATD__c.month()+'/'+record.ATD__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ATA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ATA__c != null ? record.ATA__c.day()+'/'+record.ATA__c.month()+'/'+record.ATA__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_arrival_notification_spanish()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">NOTIFICACIÓN DE ARRIBO</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ATD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ATD__c != null ? record.ATD__c.day()+'/'+record.ATD__c.month()+'/'+record.ATD__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ATA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ATA__c != null ? record.ATA__c.day()+'/'+record.ATA__c.month()+'/'+record.ATA__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th v>Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_shipment_tracking_english()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">SHIPMENT TRACKING</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		/*cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		/*cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }

	public void load_template_shipment_tracking_english_ata()
	{
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">SHIPMENT TRACKING</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		/*cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		/*cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ATD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ATD__c != null ? record.ATD__c.day()+'/'+record.ATD__c.month()+'/'+record.ATD__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ATA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ATA__c != null ? record.ATA__c.day()+'/'+record.ATA__c.month()+'/'+record.ATA__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}

	public void load_template_shipment_tracking_spanish()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">SEGUIMIENTO DE EMBARQUE</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		/*cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		/*cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }

	public void load_template_shipment_tracking_spanish_ata()
	{
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">SEGUIMIENTO DE EMBARQUE</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		/*cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		/*cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ATD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ATD__c != null ? record.ATD__c.day()+'/'+record.ATD__c.month()+'/'+record.ATD__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ATA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ATA__c != null ? record.ATA__c.day()+'/'+record.ATA__c.month()+'/'+record.ATA__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
    
    public void load_template_departure_confirmation_english()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">DEPARTURE CONFIRMATION</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_departure_confirmation_spanish()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">CONFIRMACIÓN DE ZARPE</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Contenedor:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Sea_Container_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.MBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HBL:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.HBL_Number__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }

	public void load_template_departure_confirmationFI_english()
	{
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">DEPARTURE CONFIRMATION FI</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment Status:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Shipment_Status__c != null ? record.Shipment_Status__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Truck Number:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Number__c != null ? record.Truck_Number__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Trailer Number:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Trailer_Number__c != null ? record.Trailer_Number__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Total Transit Time (hrs):</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Total_Transit_Time_Hours__c != null ? record.Total_Transit_Time_Hours__c.format() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}

	public void load_template_departure_confirmationFI_spanish()
	{
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">CONFIRMACIÓN DE ZARPE FI</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado del Shipment:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Shipment_Status__c != null ? record.Shipment_Status__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Número de Camión:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Number__c != null ? record.Truck_Number__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Número de Tráiler:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Trailer_Number__c != null ? record.Trailer_Number__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Total Transit Time (hrs):</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Total_Transit_Time_Hours__c != null ? record.Total_Transit_Time_Hours__c.format() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
    
    public void load_template_booking_confirmation_english()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">BOOKING CONFIRMATION</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cierre de Documentos / VGM:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Closing_of_Documents__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cierre de Despacho:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Closing_of_Dispach__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Posicionamiento:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Positioning__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Horario de Posicionamiento:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Positioning_Schedule__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_booking_confirmation_spanish()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">CONFIRMACIÓN DE BOOKING</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cierre de Documentos / VGM:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Closing_of_Documents__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cierre de Despacho:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Closing_of_Dispach__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Posicionamiento:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Positioning__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Horario de Posicionamiento:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Positioning_Schedule__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_departure_timetable_english()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">DEPARTURE TIMETABLE</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cierre de Documentos / VGM:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Closing_of_Documents__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cierre de Despacho:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Closing_of_Dispach__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Posicionamiento:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Positioning__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Horario de Posicionamiento:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Positioning_Schedule__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_departure_timetable_spanish()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">ITINERARIO DE SALIDA</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Pais de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Estado de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.State_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Sitio de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th class="pBottom" style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Equipo requerido:</th>';
		cuerpo_notificacion +=  '		<td class="pBottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equipment__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Naviera:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Booking:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Sea_Booking_Number__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Buque:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Truck_Vessel_Flight__c != null ? record.Truck_Vessel_Flight__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Viaje:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Voyage_Number_s__c != null ? record.Voyage_Number_s__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cierre de Documentos / VGM:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Closing_of_Documents__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cierre de Despacho:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Closing_of_Dispach__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Posicionamiento:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Positioning__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Horario de Posicionamiento:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Positioning_Schedule__c) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Comentarios Adicionales:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+ NEU_Utils.safeString(record.Special_Notes__c) +'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_fn_estandar_customer_english()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - STANDARD</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_fn_estandar_customer_spanish()
	{
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">FN - ESTANDAR</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_pto_estandar_english()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">PTO - STANDARD</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_pto_estandar_spanish()
	{
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;padding-bottom: 10px;font-size: 25px;text-align: center;white-space: nowrap;">PTO - ESTANDAR</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black; padding-bottom: 10px;text-align: center;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td colspan="2" style="padding: 10px;font-family: Arial, Helvetica, sans-serif;font-size: 12px;">';
		cuerpo_notificacion +=  '			<table class="tabla" rules="groups" cellspacing="0" cellpadding="0" style="border: 2px solid black;padding: 5px;width: 100%;">';
		cuerpo_notificacion +=  '				<thead style="border-bottom: 2px solid black;">';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipment</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Customer</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Load</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Site of Discharge</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Operator</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Vehicle</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Monitoreo Executive </th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Special Notes</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Status Monitoreo</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Loading Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Departure Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Arrival Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloading Placed Time</th>';
		cuerpo_notificacion +=  '						<th style="padding: 10px;width: 10%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Unloaded Time</th>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</thead>';
		cuerpo_notificacion +=  '				<tbody>';
		cuerpo_notificacion +=  '					<tr>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Account_for_Customer_Name__c) +'</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.National_Operator__r.Name) + '</td>';
cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Vehicle__r.Name) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Monitoreo_Executive__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Special_Notes__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Shipment_Status_Mon__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Loaded__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Placed__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Departure_Time__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Reserved__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Solicited__c) + '</td>';
		cuerpo_notificacion +=  '						<td style="padding: 10px;font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Equip_Unloaded__c) + '</td>';
		cuerpo_notificacion +=  '					</tr>';
		cuerpo_notificacion +=  '				</body>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
	}
	
	public void load_template_air_shipment_tracking_english()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">AIR SHIPMENT TRACKING</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Aerolínea:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Aeropuerto de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Aeropuerto de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HAWB:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;"></td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MAWB:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.MAWB_Number__c != null ? record.MAWB_Number__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Mercancía:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Nature_Merchandise__c != null ? record.Nature_Merchandise__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Peso:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Total_Weight_Kg__c != null ? string.valueof(record.Total_Weight_Kg__c) : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_air_shipment_tracking_spanish()
    {
		cuerpo_notificacion +=  '<br/><table class="tabla" rules="groups" cellspacing="0" cellpadding="0">';
		cuerpo_notificacion +=  '<thead>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=	'		<th colspan="2" style="font-family: Arial, Helvetica, sans-serif;">AIR SHIPMENT TRACKING</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th colspan="2" style="border-bottom: 2px solid black;">'+logotipo+'</th>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</thead>';
		cuerpo_notificacion +=  '<tbody>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Folio:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+record.Name+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Shipper:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Cnee:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Consignee__c != null ? record.Consignee__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Aerolínea:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Carrier__c != null ? record.Carrier__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th>Aeropuerto de Carga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Load__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Aeropuerto de Descarga:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">' + NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + '</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETD:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETD_from_Point_of_Load__c != null ? record.ETD_from_Point_of_Load__c.day()+'/'+record.ETD_from_Point_of_Load__c.month()+'/'+record.ETD_from_Point_of_Load__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr class="centroGrande">';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">ETA:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.ETA_Point_of_Discharge__c != null ? record.ETA_Point_of_Discharge__c.day()+'/'+record.ETA_Point_of_Discharge__c.month()+'/'+record.ETA_Point_of_Discharge__c.year() : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		/*cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">HAWB:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;"></td>';
		cuerpo_notificacion +=  '	</tr>';*/
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">MAWB:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.MAWB_Number__c != null ? record.MAWB_Number__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Mercancía:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Nature_Merchandise__c != null ? record.Nature_Merchandise__c : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<th style="width: 30%; text-align:left; font-family: Arial, Helvetica, sans-serif; font-size: 12px;">Peso:</th>';
		cuerpo_notificacion +=  '		<td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">'+(record.Total_Weight_Kg__c != null ? string.valueof(record.Total_Weight_Kg__c) : '')+'</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</tbody>';
		cuerpo_notificacion +=  '</table>';
    }
    /* ######################## FINAL PLANTILLAS ######################## */ 
}