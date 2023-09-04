public class NEU_SP_Notifications_PDF {
   
	public Shipment_Program__c record;
	
    public string string_pdf {get;set;}
	public string cabecera {get;set;}
    public string cuerpo_notificacion {get;set;}
    public string asunto {get;set;}
    
	public List<Shipment__c> lista_sp {get; set;}{
		lista_sp = new List<Shipment__c>();
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
            
    public NEU_SP_Notifications_PDF(ApexPages.StandardController stdController) 
    {
        con = stdController;
      	/* DATOS DEL SHIPMENT PROGRAM */ 
		try { 
			record = [select Id, Name, Route__r.Name, Vessel__r.Name, Pallet_Container_Type__r.Name 
					  from Shipment_Program__c where id = :con.getRecord().id];
		} 
		catch( Exception ee) 
		{ 
			record = new Shipment_Program__c();
		} 
		
      	/* DATOS SHIPMENTS DEL SHIPMENT PROGRAM */
      	try{  
			lista_sp = [select Id, Name, Carrier__r.Name, Consignee__r.Name, Shipper__r.Name
						from Shipment__c where Inbound_Consolidation_Program__c =: record.Id];
      	} catch(Exception ee) { 
        	lista_sp = new List<Shipment__c>();
      	} 

        cabecera = 	 '<table id="table_head">';
		cabecera +=  '	<tr>';
		cabecera +=  '		<th><img src="https://c.eu2.content.force.com/servlet/servlet.ImageServer?id=015b0000000AeRa&oid=00Db0000000cLrt&lastMod=1386235275000" class="logo"></img></th>';
		cabecera +=  '	</tr>';
		cabecera +=  '</table>';
	
		if(ApexPages.currentPage().getParameters().get('optionTemplate') != null)
		{
			optionTemplate = integer.valueof(ApexPages.currentPage().getParameters().get('optionTemplate'));
		}
		
		if(ApexPages.currentPage().getParameters().get('optionLanguage') != null)
		{
			optionLanguage = integer.valueof(ApexPages.currentPage().getParameters().get('optionLanguage'));
		}

		load_template();	
    }
    
    public void load_template()
    {
		if (optionTemplate==1)
		{
			if(optionLanguage==1)
			{
				asunto = 'Booking Confirmation of Shipments Program: ' + record.Name;
				load_template_booking_english(); 
			}
			else
			{
				asunto = 'Confirmación de Reserva del Shipments Program: ' + record.Name;
				load_template_booking_spanish(); 
			}			
		}
		string_pdf = cuerpo_notificacion;
    }
    
    /* ######################## COMIENZO PLANTILLAS ######################## */
    public void load_template_booking_english(){
		cuerpo_notificacion  = cabecera;
		cuerpo_notificacion +=  '<table id="table_body">';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '			<p>Dear Customer,</p>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '			<p>Below you can find details of our service.</p>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<table class="tabla">';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Shipment Program Name</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';	
		cuerpo_notificacion +=  '					<td>'+(record.Name != null ? record.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Route</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Route__r.Name != null ? record.Route__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td>&nbsp;</td>';
		cuerpo_notificacion +=  '					<td>&nbsp;</td>';
		cuerpo_notificacion +=  '					<td>&nbsp;</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Vessel</b></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Vessel__r.Name != null ? record.Vessel__r.Name : '&nbsp;')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><p><b>Container Size/type</b></p></td>';
		cuerpo_notificacion +=  '					<td>:</td>';
		cuerpo_notificacion +=  '					<td>'+(record.Pallet_Container_Type__r.Name != null ? record.Pallet_Container_Type__r.Name : '')+'</td>';
		cuerpo_notificacion +=  '				</tr>';
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '			<p><b>Outbound Shipments (Included in this Program)</b></p>';
		cuerpo_notificacion +=  '			<p>&nbsp;</p>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '	<tr>';
		cuerpo_notificacion +=  '		<td>';
		cuerpo_notificacion +=  '			<table class="tabla">';
		cuerpo_notificacion +=  '				<tr>';
		cuerpo_notificacion +=  '					<td><b>Shipment</b></td>';
		cuerpo_notificacion +=  '					<td><b>Carrier</b></td>';
		cuerpo_notificacion +=  '					<td><b>Shipper</b></td>';
		cuerpo_notificacion +=  '					<td><b>Consignee</b></td>';
		cuerpo_notificacion +=  '				</tr>';
        for(Shipment__c s: lista_sp)
        {		
			cuerpo_notificacion +=  '				<tr>';
			cuerpo_notificacion +=  '					<td>'+(s.Name != null ? s.Name : '&nbsp;')+'</td>';	
			cuerpo_notificacion +=  '					<td>'+(s.Carrier__r.Name != null ? s.Carrier__r.Name : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(s.Shipper__r.Name != null ? s.Shipper__r.Name : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '					<td>'+(s.Consignee__r.Name != null ? s.Consignee__r.Name : '&nbsp;')+'</td>';
			cuerpo_notificacion +=  '				</tr>';
        }
		cuerpo_notificacion +=  '			</table>';
		cuerpo_notificacion +=  '		</td>';
		cuerpo_notificacion +=  '	</tr>';
		cuerpo_notificacion +=  '</table>';
    }
    
    public void load_template_booking_spanish(){
		cuerpo_notificacion  = cabecera;
		cuerpo_notificacion +=  'En construcción';
    }
    /* ######################## FINAL PLANTILLAS ######################## */    
    
}