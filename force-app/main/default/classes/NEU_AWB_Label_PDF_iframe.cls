public with sharing class NEU_AWB_Label_PDF_iframe {
	
    public Air_Waybill__c record;
    public String string_awb {get;set;}
    private String codigo;
    ApexPages.StandardController con;
    
    public NEU_AWB_Label_PDF_iframe(ApexPages.StandardController stdController) 
    {
    	con = stdController;
        
    	// DATOS DEL WAYBILL
        try 
        {
        	record = [SELECT Id, Name, Accounting_Information__c, Carrier_Account__r.Name, Total_Number_of_Pieces__c,
        			  Airport_of_Destination_Code__c, Airline_Code_Number__c, Serial_Number__c 	
        			  FROM Air_Waybill__c WHERE Id = :con.getRecord().Id];
        } 
        catch(Exception ee){record = new Air_Waybill__c();}
         
        
        List<Air_Waybill_Line__c> waybill_lines = [SELECT Id, Name, No_of_Pieces__c from Air_Waybill_Line__c where Air_Waybill__c =: record.Id];
                      
        Integer count = 1;
        string_awb ='';
        
        for(Air_Waybill_Line__c wayLine : waybill_lines)
		{
			for(Integer I = 1; I <= wayLine.No_of_Pieces__c; I++)
			{
                codigo = '0000'+count;
				if(count == record.Total_Number_of_Pieces__c)
					string_awb += '<div id="contenedor" style="margin:0;">';	
		        else		        	
		        	string_awb += '<div id="contenedor"  style="page-break-after: always;margin:0;">';          
		        	
				// MASTER AIR WAYBILL
				
			        // CARRIER ACCOUNT
					string_awb += '<div class="airlineName">';
					string_awb += '		<h1 class="carrierName" style="padding: 5%!important;">'+record.Carrier_Account__r.Name+'</h1>'; 
					string_awb += '</div>'; 
			        
			        // BAR CODE 1
					string_awb += '<div class="barCoded">';
					
			        string_awb += '		<img src="https://barcode.tec-it.com/barcode.ashx?data='+record.Airline_Code_Number__c+record.Serial_Number__c+'0'+codigo.right(4)+'&amp;code=Code128&amp;multiplebarcodes=false&amp;translate-esc=true&amp;unit=Fit&amp;dpi=96&amp;imagetype=Png&amp;rotation=0&amp;color=%23000000&amp;bgcolor=%23ffffff&amp;qunit=Mm&amp;quiet=0&amp;download=true"/>';
			        
					string_awb += '</div>';	        
					
			        //WAYBILL NO, DESTINATION && TOTAL PIECES	         
		    		string_awb += '<div class="waybillTable">';
					string_awb += '	<table border="1" class="mainTable" cellspacing="0" cellpadding="0">';
					string_awb += '		<tr>';
					string_awb += '			<td colspan="2"><span>WAYBILL NO</span><h1 class="tableData">'+record.Airline_Code_Number__c+'-'+record.Serial_Number__c+'</h1></td>';
					string_awb += '		</tr>';
					string_awb += '		<tr>';
					string_awb += '			<td class="tdSecondary"><span>DESTINATION</span><h1 class="tableData">'+record.Airport_of_Destination_Code__c+'</h1></td>';
					string_awb += '			<td class="tdSecondary"><span>TOTAL NO PIECES</span><h1 class="tableData">'+String.valueOf(record.Total_Number_of_Pieces__c)+'</h1></td>';
					string_awb += '		</tr>';
					string_awb += '	</table>';	
					string_awb += '</div>';	 
		    		 		    		 
		    		//OPTIONAL INFORMATION    		
					string_awb += '<div class="optionalInformation">';
					string_awb += '	<span class="optional1">';
					string_awb += '	<span class="titleOptional">Optional Information:</span> ';
					string_awb += '	<br/>';
					string_awb += '	</span>';				
					string_awb += '</div>';
		    		
		    		//FOOTER
		    		string_awb += '<div class="nPages">';	
					string_awb += '	<hr/>';						
					string_awb += '	<span class="pages">'+count+' of '+String.valueOf(record.Total_Number_of_Pieces__c)+'</span>';
					string_awb += '</div>';
		    
		    		//ENDING CONTENEDOR
		    		string_awb += '</div>';   
		    		count++;
			}
		}  
    		
	}
    
}