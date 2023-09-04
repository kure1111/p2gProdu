public with sharing class NEU_BL_pdf
{
	public Shipment__c record;
	public String hbl {get;set;}

	ApexPages.StandardController con;

	public NEU_BL_pdf(ApexPages.StandardController stdController)
	{

		con = stdController;
		List<Shipment_Line__c> lines;


		/*BillingStreet, BillingCity, BillingState, BillingPostalCode,
        BillingCountry,
        */

		try
		{
			record = [SELECT Id, Name, Supplier_Account__c, Supplier_Account__r.Name, Supplier_Account__r.BillingStreet,
					Supplier_Account__r.BillingCity, Supplier_Account__r.BillingState, Supplier_Account__r.BillingPostalCode, Supplier_Account__r.BillingCountry,
					Supplier_Account__r.NEU_Email__c, Supplier_Account__r.Phone, Consignee__c, Consignee__r.Name, Consignee__r.BillingStreet,
					Consignee__r.BillingCity, Consignee__r.BillingState, Consignee__r.BillingPostalCode, Consignee__r.BillingCountry,
					Consignee__r.NEU_Email__c, Consignee__r.Phone, Notify_Party__c, Notify_Party__r.Name, Notify_Party__r.BillingStreet,
					Notify_Party__r.BillingCity, Notify_Party__r.BillingState, Notify_Party__r.BillingPostalCode, Notify_Party__r.BillingCountry,
					Notify_Party__r.NEU_Email__c, Notify_Party__r.Phone, Truck_Vessel_Flight__r.Name, Voyage_Number_s__c, Site_of_Load__r.Name,
					Country_of_Load__r.Name, Site_of_Discharge__r.Name, Country_of_Discharge__r.Name, ETD_from_Point_of_Load__c,
					ETA_Point_of_Discharge__c, HBL_Number__c, Total_Weight_Kg__c, Delivery_Cartage__r.Name, Shipper_Contact__r.Name,
					Shipper_Contact__r.Phone, Shipper_Contact__r.Email, Total_Units_Shipped__c, Container_Type__c,
					Carrier__r.Name, Description_Packages_Goods__c, Freight_Amount__c, Freight_payable_at__c,HBL_Number_Replace__c, Total_Volume_m3__c,
					Container_Type__r.Name FROM Shipment__c WHERE id = :con.getRecord().Id];
		}
		catch(Exception ee){record = new Shipment__c();}

		if(record.Id != null)
		{
			lines = [
					SELECT Id, Units_Shipped__c, Container_Type__r.Name, Container_Number__c, Extension_Item_Name__c
					FROM Shipment_Line__c
					WHERE Shipment__c = :record.Id
			];
		}

		integer cont = 0;

		String comment = 'Received in apparent good order and condition except as otherwise noted the total number of containers or other packages or units enumerated below for transportation from the place of receipt to the place of delivery subject to the terms hereof. One of the signed bill of lading must be surrendered duly endorsed in exchange for the Goods or delivery order. On presentation of this document (duly endorsed) to the Carrier by or on behalf of the Holder, the rights, the liabilities arising in accordance with the terms hereof shall (without prejudice to any rule of common law or statute rendering them binding on the merchant) become binding in all respects between the Carrier and the Holder as though the contract evidenced hereof made between them.';

		hbl = '';
		hbl += '<div class="pagina">';
		hbl += '<table class="tabla">';
		hbl += '  <tr class="zona1" style="height:20px">';
		hbl += '    <td rowspan="2" class="zona1">';
		hbl += '       <p class="header">SHIPPER: </p>';
		hbl += '       <p class="datos">'+NEU_Utils.safeString(record.Supplier_Account__r.Name)+'</p>';
		hbl += '       <p class="datos">'+NEU_Utils.safeString(record.Supplier_Account__r.BillingStreet)+'</p>';
		hbl += '       <p class="datos">' + (record.Supplier_Account__r.BillingPostalCode!=null?'CP:'+ record.Supplier_Account__r.BillingPostalCode:'') +
				' '+ NEU_Utils.safeString(record.Supplier_Account__r.BillingCity) + ' ' + NEU_Utils.safeString(record.Supplier_Account__r.BillingState) +
				' '+ NEU_Utils.safeString(record.Supplier_Account__r.BillingCountry) +'</p>';
		hbl += '       <p class="datos">'+(record.Shipper_Contact__r.Name!=null?'Contacto: '+record.Shipper_Contact__r.Name:'')+'</p>';
		hbl += '       <p class="datos">'+(record.Shipper_Contact__r.Email!=null?'Email: '+record.Shipper_Contact__r.Email:'')+'</p>';
		hbl += '       <p class="datos">'+(record.Shipper_Contact__r.Phone!=null?'Phone: '+record.Shipper_Contact__r.Phone:'')+'</p>';
		hbl += '    </td>';
		hbl += '    <td>';
		hbl += '      <p class="headerXL">BILL OF LANDING NO: ' + NEU_Utils.safeString(record.HBL_Number_Replace__c) +'</p>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr style="height:100px">';
		hbl += '    <td class="logoP2g">';
		hbl += '      <img src="'+ PageReference.forResource('p2goLogoPeq').getUrl() + '"/>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr style="height:120px">';
		hbl += '    <td class="zona1">';
		hbl += '       <p class="header">CONSIGNEE: </p>';
		hbl += '       <p class="datos">'+NEU_Utils.safeString(record.Consignee__r.Name)+'</p>';
		hbl += '       <p class="datos">'+NEU_Utils.safeString(record.Consignee__r.BillingStreet)+'</p>';
		hbl += '       <p class="datos">' + (record.Consignee__r.BillingPostalCode!=null?'CP:'+ record.Consignee__r.BillingPostalCode:'') +
				' '+ NEU_Utils.safeString(record.Consignee__r.BillingCity) + ' ' + NEU_Utils.safeString(record.Consignee__r.BillingState) +
				' '+ NEU_Utils.safeString(record.Consignee__r.BillingCountry) +'</p>';
		hbl += '       <p class="datos">'+(record.Consignee__r.NEU_Email__c!=null?'Email: '+record.Consignee__r.NEU_Email__c:'')+'</p>';
		hbl += '       <p class="datos">'+(record.Consignee__r.Phone!=null?'Phone: '+record.Consignee__r.Phone:'')+'</p>';
		hbl += '    </td>';
		hbl += '    <td class="logoSea">';
		hbl += '      <img src="'+ PageReference.forResource('p2goLogoSea').getUrl() + '"/>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr style="height:120px">';
		hbl += '    <td class="zona1">';
		hbl += '       <p class="header">NOTIFY PARTY: </p>';
		hbl += '       <p class="datos">'+NEU_Utils.safeString(record.Notify_Party__r.Name)+'</p>';
		hbl += '       <p class="datos">'+NEU_Utils.safeString(record.Notify_Party__r.BillingStreet)+'</p>';
		hbl += '       <p class="datos">' + (record.Notify_Party__r.BillingPostalCode!=null?'CP:'+ record.Notify_Party__r.BillingPostalCode:'') +
				' '+ NEU_Utils.safeString(record.Notify_Party__r.BillingCity) + ' ' + NEU_Utils.safeString(record.Notify_Party__r.BillingState) +
				' '+ NEU_Utils.safeString(record.Notify_Party__r.BillingCountry) +'</p>';
		hbl += '       <p class="datos">'+(record.Notify_Party__r.NEU_Email__c!=null?'Email: '+record.Notify_Party__r.NEU_Email__c:'')+'</p>';
		hbl += '       <p class="datos">'+(record.Notify_Party__r.Phone!=null?'Phone: '+record.Notify_Party__r.Phone:'')+'</p>';
		hbl += '    </td>';
		hbl += '    <td class="zona1">';
		hbl += '       <p class="header">DELIVERY AGENT ADRESS: </p>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '</table>';

		hbl += '<table class="tabla">';
		hbl += '  <tr>';
		hbl += '    <td class="zona2">';
		hbl += '       <p class="header">VESSEL AND VOYAGE: </p>';
		hbl += '       <p class="datosBig">'+NEU_Utils.safeString(record.Truck_Vessel_Flight__r.Name)+' / ' +
				+ NEU_Utils.safeString(record.Voyage_Number_s__c) + '</p>';
		hbl += '    </td>';
		hbl += '    <td class="zona2">';
		hbl += '      <p class="header">PORT OF LOADING: </p>';
		hbl += '      <p class="datosBig">'+NEU_Utils.safeString(record.Site_of_Load__r.Name) + ', ' + NEU_Utils.safeString(record.Country_of_Load__r.Name)+'</p>';
		hbl += '    </td>';
		hbl += '    <td class="zona2" rowspan="2">';
		hbl += '      <p class="header">BY SEA </p>';
		hbl += '      <p style="FONT-SIZE: xx-large; MARGIN-TOP: 13px; MARGIN-BOTTOM: 0; TEXT-ALIGN: CENTER; FONT-WEIGHT: bold; COLOR: #b09824;">COPY NON NEGOTIABLE</p>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr>';
		hbl += '    <td class="zona2">';
		hbl += '       <p class="header">PORT OF DISCHARGE: </p>';
		hbl += '      <p class="datosBig">'+NEU_Utils.safeString(record.Site_of_Discharge__r.Name) + ', ' + NEU_Utils.safeString(record.Country_of_Discharge__r.Name)+'</p>';
		hbl += '    </td>';
		hbl += '    <td class="zona2">';
		hbl += '      <p class="header">FINAL DESTINATION: </p>';
		hbl += '      <p class="datosBig">'+ NEU_Utils.safeString(record.Delivery_Cartage__r.Name)+'</p>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr style="height:25px">';
		hbl += '    <td colspan="3" style="text-align: center;">';
		hbl += '       <p class="header">PARTICULARS FURNISHED BY SHIPPER </p>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '</table>';

		hbl += '<table class="tabla">';
		hbl += '  <tr>';
		hbl += '    <td class="center" style="width: 25%;">';
		hbl += '       <p class="header">CONTAINER NUMBER, SEAL NUMBER: </p>';
		hbl += '    </td>';
		hbl += '    <td class="center" style="width: 45%;">';
		hbl += '      <p class="header">DESCRIPTION OF PACKAGES AND GOODS: </p>';
		hbl += '    </td>';
		hbl += '    <td class="center" style="width: 10%;">';
		hbl += '      <p class="header">GROSS CARGO </p>';
		hbl += '    </td>';
		hbl += '    <td class="center" style="width: 20%;">';
		hbl += '      <p class="header">MEASUREMENT: </p>';
		hbl += '    </td>';
		hbl += '  </tr>';

		String containersData = '';
		containersData += '<p class="datosBig" style="margin-bottom: 10px;">Total Units: '+ NEU_Utils.safeString(record.Total_Units_Shipped__c)+'</p>';
		//lista de container types
		if(record.Container_Type__r.Id != null)
		{
			containersData += '<p class="datosBig" style="margin-bottom: 10px;">' + NEU_Utils.safeString(record.Container_Type__r.Name) + '</p>';
		}
		else
		{
			containersData += '<p class="datos" style="margin-bottom: 10px;">';
			if(lines != null)
			{
				for (Shipment_Line__c line : lines)
				{
					containersData += NEU_Utils.safeString(line.Units_Shipped__c)
					+' X ' + NEU_Utils.safeString(line.Extension_Item_Name__c)+'<br/>';

					/*
                    +' X ' + NEU_Utils.safeString(line.Container_Type__r.Name)
                    +' ' + NEU_Utils.safeString(line.Container_Number__c) + '<br/>';
                    */
				}
			}
			containersData += '</p>';
		}

		containersData += '<p class="datosBig">'+ NEU_Utils.safeString(record.Carrier__r.Name)+'</p>';

		hbl += '  <tr>';
		hbl += '    <td class="zona3 vTop" rowspan="2" style="width: 25%;">';
		hbl +=         containersData;
		hbl += '    </td>';
		hbl += '    <td class="vTop" style="width: 46%; border: 0px">';
		hbl += '      <p class="datosBig">'+ NEU_Utils.safeString(record.Description_Packages_Goods__c)+'</p>';
		hbl += '    </td>';
		hbl += '    <td class="vTop center" style="width: 12%; height:110px">';
		hbl += '      <p class="datos">'+ NEU_Utils.safeString(record.Total_Weight_Kg__c) +' Kg</p>';
		hbl += '      <p class="datos">'+ NEU_Utils.safeString(record.Total_Volume_m3__c) +' M3</p>';


		hbl += '    </td>';
		hbl += '    <td style="width: 17%; height:110px">';
		hbl += '      ';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr>';
		hbl += '    <td class="zona3" style="width: 46%; height:30px; text-align: right; border: 0px;">';
		hbl += '      <p class="header">TOTAL: </p>';
		hbl += '    </td>';
		hbl += '    <td class="zona3 center" style="width: 12%; height:30px">';
		hbl += '      <p class="datos">'+ NEU_Utils.safeString(record.Total_Weight_Kg__c) +' Kg</p>';
		hbl += '      <p class="datos">'+ NEU_Utils.safeString(record.Total_Volume_m3__c) +' M3</p>';
		//hbl += '      <p class="header">TOTAL: </p>';
		hbl += '    </td>';
		hbl += '    <td class="zona3" style="width: 17%; height:30px">';
		hbl += '      ';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '</table>';

		hbl += '<table class="tabla">';
		hbl += '  <tr>';
		hbl += '    <td colspan="2" style="width: 70%; height:25px">';
		hbl += '       <p class="header">FREIGHT AND CHARGE: </p>';
		hbl += '    </td>';
		hbl += '    <td rowspan="5" class="vTop" style="width: 30%; height:230px">';
		hbl += '       <p class="littleBlue">' + comment + '</p>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr>';
		hbl += '    <td class="center" style="width: 35%; height:25px">';
		hbl += '       <p class="header">CHARGES: </p>';
		hbl += '    </td>';
		hbl += '    <td class="center" style="width: 35%; height:25px">';
		hbl += '       <p class="header">PREPAID: </p>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr>';
		hbl += '    <td style="width: 35%; height:105px">';
		hbl += '       ';
		hbl += '    </td>';
		hbl += '    <td style="width: 35%; height:105px">';
		hbl += '       ';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr>';
		hbl += '    <td class="vTop" style="width: 35%; height:45px">';
		hbl += '       <p class="header">FREIGHT AMOUNT: </p>';
		hbl += '      <p class="datosBig">'+ NEU_Utils.safeString(record.Freight_Amount__c) +'</p>';
		hbl += '    </td>';
		hbl += '    <td class="vTop" style="width: 35%; height:45px">';
		hbl += '       <p class="header vTop">PLACE OF BOARD: </p>';
		hbl += '       <p class="datosBig">' + (record.Delivery_Cartage__r!=null?NEU_Utils.safeString(record.Delivery_Cartage__r.Name) :
				NEU_Utils.safeString(record.Site_of_Load__r.Name) + ', ' + NEU_Utils.safeString(record.Country_of_Load__r.Name)) + '</p>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '  <tr>';
		hbl += '    <td class="vTop" style="width: 35%; height:45px">';
		hbl += '       <p class="header vTop">FREIGHT PAYABLE AT: </p>';
		hbl += '      <p class="datosBig">'+ NEU_Utils.safeString(record.Freight_payable_at__c) +'</p>';
		hbl += '    </td>';
		hbl += '    <td class="vTop" style="width: 35%; height:45px">';
		hbl += '       <p class="header vTop">DATE OF BOARD: </p>';
		hbl += '       <p class="datosBig">' + (record.ETD_from_Point_of_Load__c!=null?record.ETD_from_Point_of_Load__c.format():'') + '</p>';
		hbl += '    </td>';
		hbl += '  </tr>';
		hbl += '</table>';



		hbl += '</div>';
	}
}