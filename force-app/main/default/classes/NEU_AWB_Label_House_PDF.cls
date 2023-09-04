public class NEU_AWB_Label_House_PDF {
    public Air_Waybill__c record;
    public String string_pdf {get;set;}
    private String codigo;
    public String documentName;
    public Waybill_Consolidation__c consol;
    ApexPages.StandardController con;
    
    public NEU_AWB_Label_House_PDF(ApexPages.StandardController stdController) 
    {
        if (Test.isRunningTest()){
            documentName = 'test';
        }
        else{
            documentName=ApexPages.currentPage().getParameters().get('name');
        }
        if(documentName != null && !documentName.equals('')){
            
            con = stdController;
            
            // DATOS DEL WAYBILL
            try 
            {
                record = [SELECT Id, Name, Accounting_Information__c, Carrier_Account__r.Name, Total_Number_of_Pieces__c,
                          Airport_of_Destination_Code__c, Airline_Code_Number__c, Serial_Number__c 	
                          FROM Air_Waybill__c WHERE Id = :con.getRecord().Id];
            } 
            catch(Exception ee){record = new Air_Waybill__c();}
         
            try{
                consol = [select Id, Name, Consignee_House__c, Consignee_House__r.Name from Waybill_Consolidation__c where Id =: documentName.trim() and Waybill__c =: record.Id];
            }
            catch(Exception ex){
                consol = new Waybill_Consolidation__c();
            }
            
            
            
            
            List<Air_Waybill_Line__c> waybill_lines = [SELECT Id, Name, No_of_Pieces__c from Air_Waybill_Line__c where Air_Waybill__c =: record.Id and House_Reference__c =: consol.Id];
            
            Integer count = 1;
            string_pdf ='';
            Integer totalPiezas = 0;
            
            //cuento el total de pieces para todas las lineas de esa consolidation
            
            for(Air_Waybill_Line__c wayLine : waybill_lines){
                totalPiezas += Integer.valueOf((wayLine.No_of_Pieces__c != null ? wayLine.No_of_Pieces__c : 0));
            }
            codigo = '000'+ String.valueOf(totalPiezas);
            
            for(Integer i = 0; i<totalPiezas; i++ )
            {
                
                if((i+1) == totalPiezas)
                    string_pdf += '<div id="contenedor" style="margin:0;">';	
                else		        	
                    string_pdf += '<div id="contenedor"  style="page-break-after: always;margin:0;">';          
                
                // HOUSE AIR WAYBILL
               
                // CONSIGNEE ACCOUNT
                string_pdf += '<div class="agent">';
                string_pdf += '		<span>Agent</span>';
                string_pdf += '		<span class="agente">'+consol.Consignee_House__r.Name+'</span>'; 
                string_pdf += '</div>'; 
                
                // BAR CODE
                string_pdf += '<div class="barCoded">';
                
                string_pdf += '		<img src="https://barcode.tec-it.com/barcode.ashx?data='+consol.Name.replaceAll('-','')+'&amp;code=Code128&amp;multiplebarcodes=false&amp;translate-esc=true&amp;unit=Fit&amp;dpi=96&amp;imagetype=Png&amp;rotation=0&amp;color=%23000000&amp;bgcolor=%23ffffff&amp;qunit=Mm&amp;quiet=0&amp;download=true"/>';
                
                string_pdf += '</div>';	        
                
                //WAYBILL NO, DESTINATION && TOTAL PIECES	         
                string_pdf += '<div class="numero">';
                string_pdf += '		<span>House Waybill No.</span>';
                string_pdf += '		<span class="agente">'+consol.Name+'</span>';
                string_pdf += '</div>';	 
                  		
                string_pdf += '<div class="conjunto">';
				string_pdf += '		<div id="primero">';
                string_pdf += '			<span>Destination</span>';
                string_pdf += '			<span class="agente">'+(record.Airport_of_Destination_Code__c != null ? record.Airport_of_Destination_Code__c: '&nbsp;')+'</span>';
                string_pdf += '		</div>';
                string_pdf += '		<div id="segundo">';
                string_pdf += '			<span>Total No. of HWB Pieces</span>';
                string_pdf += '			<span class="agente">'+String.valueOf(totalPiezas)+'</span>';
                string_pdf += '		</div>';
                string_pdf += '</div>';
                
                // Bar code 2
                string_pdf += '	<div id="ultimo">';
                string_pdf += '		<img src="https://barcode.tec-it.com/barcode.ashx?data=D'+record.Airport_of_Destination_Code__c+'%2bS'+codigo.right(4)+'&amp;code=Code128&amp;multiplebarcodes=false&amp;translate-esc=true&amp;unit=Fit&amp;dpi=96&amp;imagetype=Png&amp;rotation=0&amp;color=%23000000&amp;bgcolor=%23ffffff&amp;qunit=Mm&amp;quiet=0&amp;download=true"/>';
                string_pdf += '	</div>';
                
                //FOOTER
                string_pdf += '<div class="nPages">';	
                string_pdf += '	<hr/>';						
                string_pdf += '	<span class="pages">'+(i+1)+' of '+String.valueOf(totalPiezas)+'</span>';
                string_pdf += '</div>';
                
                //ENDING CONTENEDOR
                string_pdf += '</div>';   
            }            
        }
    }
}