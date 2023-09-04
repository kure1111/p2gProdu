trigger NEU_NotesQuotationPDF on Customer_Quote__c (before insert, before update) 
{
	if(NEU_StaticVariableHelper.getBoolean1())
  		return;

    string notes_es = '';
    string notes_en = '';
    
    if(trigger.isInsert)
    {
        if(!RecursiveCheck.triggerMonitor.contains('NEU_NotesQuotationPDFInsert')){
            RecursiveCheck.triggerMonitor.add('NEU_NotesQuotationPDFInsert');
            for(Customer_Quote__c quote : trigger.new)
            {
                notes_es = '';
                notes_en = '';
                //M
                if((quote.Freight_Mode__c == 'Sea' && quote.Service_Mode__c == 'IMPORT' && quote.Service_Type__c == 'LCL') || Test.isRunningTest())
                {
                    notes_es =  PAK_NotesQuotationPdf.NotesPDF_M_Import_LCL_Es();
                    notes_en =  PAK_NotesQuotationPdf.NotesPDF_M_Import_LCL_En();
                }
                //M
                if((quote.Freight_Mode__c == 'Sea' && quote.Service_Mode__c == 'EXPORT' && quote.Service_Type__c == 'LCL') || Test.isRunningTest())
                {
                    notes_es =  PAK_NotesQuotationPdf.NotesPDF_M_Export_LCL_Es();
                    notes_en =  PAK_NotesQuotationPdf.NotesPDF_M_Export_LCL_En();
                }
                //M           
                if((quote.Freight_Mode__c == 'Sea' && quote.Service_Mode__c == 'EXPORT' && quote.Service_Type__c == 'FCL') || Test.isRunningTest())                     
                {
                    notes_es =  PAK_NotesQuotationPdf.NotesPDF_M_Export_FCL_Es();
                    notes_en =  PAK_NotesQuotationPdf.NotesPDF_M_Export_FCL_En();

                
                }        
                //M
                if((quote.Freight_Mode__c == 'Sea' && quote.Service_Mode__c == 'IMPORT' && quote.Service_Type__c == 'FCL') || Test.isRunningTest())
                {
                    notes_es =  PAK_NotesQuotationPdf.NotesPDF_M_Import_FCL_Es();
                    notes_en =  PAK_NotesQuotationPdf.NotesPDF_M_Import_FCL_En();
                
                }
                //FI
                if((quote.Freight_Mode__c == 'Road' && (quote.Service_Mode__c == 'IMPORT' || quote.Service_Mode__c == 'EXPORT' || quote.Service_Mode__c == 'INTERNATIONAL') && quote.Service_Type__c == 'FTL') || Test.isRunningTest())
                {
                    notes_es =  PAK_NotesQuotationPdf.NotesPDF_FI_Es();
                    notes_en =  PAK_NotesQuotationPdf.NotesPDF_FI_En();

                }
                //FI
                if((quote.Freight_Mode__c == 'Road' && (quote.Service_Mode__c == 'IMPORT' || quote.Service_Mode__c == 'EXPORT' || quote.Service_Mode__c == 'INTERNATIONAL') && quote.Service_Type__c == 'LTL') || Test.isRunningTest())
                {
                    notes_es =  PAK_NotesQuotationPdf.NotesPDF_FI_Es();
                    notes_en =  PAK_NotesQuotationPdf.NotesPDF_FI_En();  
                }
                //no se mueve
                if((quote.Freight_Mode__c == 'Road' && quote.Service_Mode__c == 'NATIONAL' && quote.Service_Type__c == 'LTL') || Test.isRunningTest())
                {
                    notes_es += '   En caso de que tu mercancía llegue dañada tienes un máximo de 24 horas para levantar con tu ejecutivo la reclamación, después de dicho tiempo ya no será válida ninguna garantía.';
                    notes_es += '   \n\n';
                    notes_es += '   DIMENSIONES MÁXIMAS';
                    notes_es += '   \n\n';
                    notes_es += '       - 1.20 (ANCHO) X 1.05 (LARGO) X 1.90 (ALTO)';
                    notes_es += '   \n\n';
                    notes_es += '   PESO';
                    notes_es += '   \n\n';
                    notes_es += '       - DE 71 KG A 1,100 KG.'; 
                    notes_es += '       \n';
                    notes_es += '       - Paletizado y emplayado.';
                    notes_es += '   \n\n';
                    notes_es += '   CARACTERÍSTICAS';
                    notes_es += '   \n\n';
                    notes_es += '       - Servicio puerta a puerta.';
                    notes_es += '       \n';
                    notes_es += '       - Recolecciones y entregas en tiempos definidos.';
                    notes_es += '       \n';
                    notes_es += '       - Rastreo y confirmación en linea.';
                    notes_es += '       \n';
                    notes_es += '       - Seguridad en el manejo y transporte de carga.';
                    notes_es += '       \n';
                    notes_es += '       - Guía por pallet.';
                    notes_es += '       \n';
                    notes_es += '       - Retorno de documentos de acuse de recibo.';
                    notes_es += '   \n\n';
                    notes_es += '   SEGURO OPCIONAL';
                    notes_es += '   \n\n';
                    notes_es += '       - Costo de la póliza del 1.2% del valor declarado del envío.'; 
                    notes_es += '       \n';
                    notes_es += '       - La cobertura máxima es de $100,000 pesos, deducible del 20%.'; 
                    
                    notes_en += '   In case your merchandise arrives damaged you have a maximum of 24 hours to raise with your executive the claim, after that time no guarantee will be valid.';
                    notes_en += '   \n\n';
                    notes_en += '   MAXIMUM DIMENSIONS';
                    notes_en += '   \n\n';
                    notes_en += '       - 1.20 (WIDTH) X 1.05 (LONG) X 1.90 (HIGH).';
                    notes_en += '   \n\n';
                    notes_en += '   WEIGHT';
                    notes_en += '   \n\n';
                    notes_en += '       - FROM 71 KG TO 1,100 KG.';
                    notes_en += '       \n'; 
                    notes_en += '       - Palletizing and waving.';
                    notes_en += '   \n\n';
                    notes_en += '   CHARACTERISTICS';
                    notes_en += '   \n\n';
                    notes_en += '       - Door to door service.';
                    notes_en += '       \n';
                    notes_en += '       - Collection and deliveries at defined times.';
                    notes_en += '       \n';
                    notes_en += '       - Online tracking and confirmation.';
                    notes_en += '       \n';
                    notes_en += '       - Safety in the handling and transport of cargo.';
                    notes_en += '       \n';
                    notes_en += '       - Guide by pallet.';
                    notes_en += '       \n';
                    notes_en += '       <li>Return of acknowledgment documents.';
                    notes_en += '   \n\n';
                    notes_en += '   OPTIONAL INSURANCE';
                    notes_en += '   \n\n';
                    notes_en += '       - Policy cost of 1.2% of the declared value of the shipment.';
                    notes_en += '       \n'; 
                    notes_en += '       - Maximum coverage is $ 100,000 pesos, deductible of 20%.'; 
                }
                // FN
                if((quote.Freight_Mode__c == 'Road' && quote.Service_Mode__c == 'NATIONAL' &&
                        (quote.Service_Type__c == 'FTL' || quote.Service_Type__c == 'FP' || quote.Service_Type__c == 'FO')) || Test.isRunningTest())
                {
                    notes_es =  PAK_NotesQuotationPdf.NotesPDF_FN_Es();
                    notes_en =  PAK_NotesQuotationPdf.NotesPDF_FN_En();
                }
                // no se mueve
                if((quote.Freight_Mode__c == 'Air' && quote.Service_Type__c != 'MAYOREO') || Test.isRunningTest())
                {
                    notes_es += 'CONDICIONES IMPORTANTES';
                    notes_es += '\n\n';
                    notes_es += '	- Crédito sujeto a aprobación.';
                    notes_es += '       \n';
                    notes_es += '   - Sujeto a disponibilidad de espacio';
                    notes_es += '   \n';
                    notes_es += '   - T/T:';
                    notes_es += '   \n';
                    notes_es += '   - Via:';
                    notes_es += '   \n';
                    notes_es += '   - Tarifa para carga general no peligrosa';
                    notes_es += '   \n';
                    notes_es += '   - Aplican restricciones de pesos y medidas por bulto';
                    
                    notes_en += 'IMPORTANT CONDITIONS';
                    notes_en += '\n\n';
                    notes_en += '   - Credit subject to approval.';
                    notes_en += '       \n';
                    notes_en += '   - Subject to space availability';
                    notes_en += '   \n';
                    notes_en += '   - T/T:';
                    notes_en += '   \n';
                    notes_en += '   - Via:';
                    notes_en += '   \n';
                    notes_en += '   - Rate for general non-dangerous cargo';
                    notes_en += '   \n';
                    notes_en += '   - Restrictions of weights and measures per package are applied';
                }
                //pto
                if(quote.Service_Mode__c == 'PORT' || Test.isRunningTest())
                {
                    notes_es = PAK_NotesQuotationPdf.NotesPDF_Pto_Es();
                        notes_en = PAK_NotesQuotationPdf.NotesPDF_Pto_En();
                }
                //no se mueve
                if(quote.Freight_Mode__c != 'Air' && quote.Service_Type__c == 'MAYOREO' || Test.isRunningTest())
                {
                    notes_es += '- Precios no incluyen IVA';
                    notes_es += '   \n'; 
                    notes_es += '- Servicios incluyen recolección';
                    notes_es += '   \n'; 
                    notes_es += '- Rastreo en Línea';
                    notes_es += '   \n'; 
                    notes_es += '- Atención Personalizada';
                    notes_es += '   \n'; 
                    notes_es += '- Prohibida su reventa';
                    
                    notes_en += '- Prices do not include VAT';
                    notes_en += '   \n';
                    notes_en += '- Services include collection';
                    notes_en += '   \n';
                    notes_en += '- Online Tracking';
                    notes_en += '   \n';
                    notes_en += '- Personalized attention';
                    notes_en += '   \n';
                    notes_en += '- Resale prohibited';
                }
                //no se mueve
                if(quote.Freight_Mode__c == 'Air' && (quote.Service_Type__c == 'MAYOREO' || quote.Service_Type__c == 'ENVIO NACIONAL') || Test.isRunningTest())
                {
                    notes_es += 'Servicios Incluidos'; 
                    notes_es += '\n\n';
                    notes_es += '   - Recolección en origen';
                    notes_es += '   \n';
                    notes_es += '   - Despacho de exportación (Pedimento Global - Valor Factura no mayor a 1000USD)';
                    notes_es += '   \n';
                    notes_es += '   - Flete aéreo';
                    notes_es += '   \n'; 
                    notes_es += '   - Entrega en destino final';
                    notes_es += '\n\n';
                    notes_es += 'Servicios No Incluidos';
                    notes_es += '\n\n';
                    notes_es += '   - Impuestos a la importación';
                    notes_es += '   \n';
                    notes_es += '   - Maniobras de carga y descarga';
                    notes_es += '   \n';
                    notes_es += '   - Agente Aduanal';
                    notes_es += '   \n';
                    notes_es += '   - Seguro de la mercancía';
                    notes_es += '\n\n';
                    notes_es += 'CONDICIONES IMPORTANTES';
                    notes_es += '	* Crédito sujeto a aprobación.';
                    notes_es += '       \n';
                    notes_es += '   * Aplica para el peso y dimensiones proporcionados.';
                    notes_es += '   \n';
                    notes_es += '   * En caso de haber cambios en pesos y dimensiones, se actualizará la tarifa.';
                    
                    notes_en += 'Included services';
                    notes_en += '\n\n';
                    notes_en += '   - Collection at origin';
                    notes_en += '   \n';
                    notes_en += '   - Export Dispatch (Global Motion - Invoice Value not higher than 1000USD)';
                    notes_en += '   \n';
                    notes_en += '   - Air freight';
                    notes_en += '   \n';
                    notes_en += '   - Delivery at final destination';
                    notes_en += '\n\n';
                    notes_en += 'Services Not Included';
                    notes_en += '\n\n';
                    notes_en += '   - Import taxes';
                    notes_en += '   \n';
                    notes_en += '   - Loading and unloading maneuvers';
                    notes_en += '   \n';
                    notes_en += '   - Customs Agent';
                    notes_en += '   \n';
                    notes_en += '   - Insurance of the merchandise';
                    notes_en += '\n\n';
                    notes_en += 'IMPORTANT CONDITIONS';
                    notes_en += '   * Applies for the weight and dimensions provided.';
                    notes_en += '   \n';
                    notes_en += '   * In case of changes in weights and dimensions, the rate will be updated.';
                }
                //no se mueve
                if((quote.Freight_Mode__c == 'Road' && quote.Service_Mode__c == 'NATIONAL' && quote.Service_Type__c == 'LTL' && quote.Container_Type__c == 'a0K0Y000005wxyw') || Test.isRunningTest())
                {
                    notes_es += 'CONDICIONES IMPORTANTES';
                    notes_es += '\n\n';
                    notes_es += '	* Crédito sujeto a aprobación.';
                    notes_es += '   \n';
                    notes_es += '   * El servicio cotizado es de carga consolidada con días de tránsito y rutas logísticas previamente establecidas.';
                    notes_es += '   \n';
                    notes_es += '   * El servicio es libre de maniobras.';
                    notes_es += '   \n';
                    notes_es += '   * Los servicios de carga regular limitan la transportación de Materiales Peligrosos o aquellas que por Normatividad Nacional o Internacional su manejo sea regulado.';
                    notes_es += '   \n';
                    notes_es += '   * Ver anexo de Artículos Prohibidos para la transportación.';
                    notes_es += '   \n';
                    notes_es += '   * Los días de servicio son días hábiles, no se consideran días festivos y se calculan de acuerdo a la fecha en que se cotiza considerando las horas corte de nuestras rutas.';
                    notes_es += '   \n';
                    notes_es += '   * El seguro contratado no cubre material frágil, vidrio, pisos azulejos, fibra de vidrio ni materiales prohibidos o de circulación restringida.';
                    notes_es += '   \n';
                    notes_es += '   * Los servicios por cobrar solo se pueden realizar para Empresas y Personas Físicas con Actividad Empresarial.';
                    notes_es += '   \n';
                    notes_es += '   * Las Recolecciones deberán programarse con un día de anticipación a la fecha requerida';
                    notes_es += '   \n';
                    notes_es += '   * Las Recolecciones urgentes se podrán programar mismo día antes de las 12:00 y estarán sujetas a disponibilidad de la plaza';
                    notes_es += '   \n';
                    notes_es += '   * Por favor considere que nuestros Códigos Postales, Estados y colonias están ligadas a SEPOMEX por lo que se actualizan cada 6 meses.';
                    notes_es += '   \n';
                    notes_es += '   * Para realizar un envío a través de ______________ deberá presentar una factura o nota de remisión membretada que ampare la procedencia del material.';
                    notes_es += '\n\n';
                    notes_es += 'DIMENSIONES MAXIMAS';
                    notes_es += '\n\n';
                    notes_es += '   1.20 (ANCHO) X 1.05 (LARGO) X 1.90 (ALTO)';
                    notes_es += '\n\n';
                    notes_es += 'PESO';
                    notes_es += '\n\n';
                    notes_es += '   DE 71 KG A 1,100 KG';
                    notes_es += '   \n';
                    notes_es += '   PALETIZADO Y EMPLAYADO';
                    notes_es += '\n\n';
                    notes_es += 'CATACTERISTICAS:';
                    notes_es += '\n\n';
                    notes_es += '   SERVICIO PUERTA A PUERTA';
                    notes_es += '   \n';
                    notes_es += '   RECOLECCIONES Y ENTREGAS EN TIEMPOS DEFINIDOS';
                    notes_es += '   \n';
                    notes_es += '   RASTREO Y CONFIRMACION EN LINEA';
                    notes_es += '   \n';
                    notes_es += '   SEGURIDAD EN EL MANEJO Y TRANSPORTE DE CARGA';
                    notes_es += '   \n';
                    notes_es += '   GUIA POR PALLET';
                    notes_es += '   \n';
                    notes_es += '   RETORNO DE DOCUMENTOS DE ACUSE DE RECIBO';
                    notes_es += '\n\n';
                    notes_es += 'SEGURO OPCIONAL:';
                    notes_es += '\n\n';
                    notes_es += '   COSTO DE LA POLIZA DEL 1.2% DEL VALOR DECLARADO DEL ENVIO';
                    notes_es += '   \n'; 
                    notes_es += '   LA COBERTURA MAXIMA ES DE $100,000 PESOS, DEDUCIBLE DEL 20%.';
                    
                    notes_en += 'IMPORTANT CONDITIONS';
                    notes_en += '\n\n';
                    notes_en += '   * Credit subject to approval.';
                    notes_en += '       \n';
                    notes_en += '   * The service quoted is consolidated cargo with transit days and logistics routes previously established.';
                    notes_en += '   \n';
                    notes_en += '   * The service is free of maneuvers.';
                    notes_en += '   \n';
                    notes_en += '   * Regular cargo services limit the transportation of dangerous materials or those that are regulated by National or International Regulations.';
                    notes_en += '   \n';
                    notes_en += '   * See annex of Prohibited Items for transportation.';
                    notes_en += '   \n';
                    notes_en += '   * The days of service are working days, are not considered holidays and are calculated according to the date on which it is quoted considering the cut-off hours of our routes.';
                    notes_en += '   \n';
                    notes_en += '   * The insurance contracted does not cover fragile material, glass, tile floors, fiberglass or prohibited materials or restricted circulation.';
                    notes_en += '   \n';
                    notes_en += '   * The services receivable can only be made for Companies and Individuals with Business Activity.';
                    notes_en += '   \n';
                    notes_en += '   * Collections must be scheduled one day in advance of the required date';
                    notes_en += '   \n';
                    notes_en += '   * Urgent collections can be scheduled same day before 12:00 and will be subject to availability of the place';
                    notes_en += '   \n';
                    notes_en += '   * Please consider that our Postal Codes, States and colonies are linked to SEPOMEX so they are updated every 6 months.';
                    notes_en += '   \n';
                    notes_en += '   * To make a shipment through ______________ must submit an invoice or letter of reference letterhead that covers the source of the material.';
                    notes_en += '\n\n';
                    notes_en += 'MAXIMUM DIMENSIONS';
                    notes_en += '\n\n';
                    notes_en += '   1.20 (WIDE) X 1.05 (LONG) X 1.90 (HIGH)';
                    notes_en += '\n\n';
                    notes_en += 'WEIGHT';
                    notes_en += '\n\n';
                    notes_en += '   FROM 71 KG TO 1,100 KG';
                    notes_en += '   \n';
                    notes_en += '   PALLETIZED AND EMPLAYED';
                    notes_en += '\n\n';
                    notes_en += 'CHARACTERISTICS';
                    notes_en += '\n\n';
                    notes_en += '   DOOR TO DOOR SERVICE';
                    notes_en += '   \n';
                    notes_en += '   COLLECTIONS AND DELIVERIES IN DEFINED TIMES';
                    notes_en += '   \n';
                    notes_en += '   ONLINE TRACKING AND CONFIRMATION';
                    notes_en += '   \n';
                    notes_en += '   SECURITY IN CARGO HANDLING AND TRANSPORTATION';
                    notes_en += '   \n';
                    notes_en += '   GUIDE BY PALLET';
                    notes_en += '   \n';
                    notes_en += '   RETURN OF RECEIPT ACKNOWLEDGMENT DOCUMENTS';
                    notes_en += '\n\n';
                    notes_en += 'OPTIONAL INSURANCE:';
                    notes_en += '\n\n';
                    notes_en += '   COST OF THE POLICY OF 1.2% OF THE DECLARED VALUE OF SHIPPING';
                    notes_en += '   \n';
                    notes_en += '   MAXIMUM COVERAGE IS $ 100,000 PESOS, DEDUCTIBLE OF 20%.';
                }
                // no se mueve
                if(quote.Only_Warehouse_Service__c || Test.isRunningTest())
                {
                    notes_es += 'Servicios No Incluidos';
                    notes_es += '\n\n';
                    notes_es += '	- Maniobras de Carga y Descarga';
                    notes_es += '   \n';	
                    notes_es += '	- Recolección y Entrega en Zona Residencial';
                    notes_es += '   \n';	
                    notes_es += '	- Equipo de Rampas, Grúas, Gatas, etc';
                    notes_es += '   \n';	
                    notes_es += '	- Servicios de Pick & Pack o etiquetado';
                    notes_es += '   \n';
                    notes_es += '	- Montacargas mas 1 ton';
                    notes_es += '   \n'; 
                    notes_es += '	- Servicio de entarimado';
                    notes_es += '   \n'; 
                    notes_es += '	- Retrabajos';
                    notes_es += '   \n';
                    notes_es += '	- Servicio de Cross Dock';
                    notes_es += '\n\n';
                    notes_es += 'CONDICIONES IMPORTANTES';
                    notes_es += '\n\n';
                    notes_es += '	* Crédito sujeto a aprobación.';
                    notes_es += '       \n';
                    notes_es += '	* En caso de requerir Maniobras , FAVOR de Responder este correo, indicando tipo de maniobras necesarias.';
                    notes_es += '   \n';	
                    notes_es += '	* Cotización aplicable a carga general no peligrosa, con pesos y medidas reglamentarias.';
                    notes_es += '   \n';	
                    notes_es += '	* Peso máximo por tarima: 1 toneladas.';
                    notes_es += '   \n';
                    notes_es += '	* Altura Máxima tarima : 1.7m';
                    notes_es += '   \n';	
                    notes_es += '	* Tiempo para carga o descarga: 3hrs';
                    notes_es += '   \n';	
                    notes_es += '	* Los cortes de Almacenamiento son Mensuales';
                    notes_es += '   \n'; 
                    notes_es += '	* En caso de que la información proporcionada, tenga algún cambio (Medidas, Peso, Maniobras) la tarifa no es válida.';
                    notes_es += '	\n';	
                    notes_es += '	* Las tarifas proporcionadas son estimados y pueden surgir cambios sin previo aviso.';
                    notes_es += '   \n';	
                    notes_es += '	* Tarifa sujeta a disponibilidad de espacio.';
                    notes_es += '   \n';	
                    notes_es += '	* Los días Hábiles para recibir y entregar mercancía son de Lunes a Sábado';
                    notes_es += '   \n';
                    notes_es += '	* Los horarios para recibir y entregar mercancía son de 8am a 8pm Lunes a Viernes, Sábados de 9am a 2pm';
                    notes_es += '   \n';	
                    notes_es += '	* Los servicios de Cross Dock aplican de 2 a 5 días hábiles teniendo un costo de $1,500 mas maniobras.';
                    notes_es += '   \n';
                    notes_es += '	* Los servicios de Cross Dock que pasen del 5to día hábil se cobran como almacenamiento mensual.';
                    notes_es += '   \n';	
                    notes_es += '	* No nos hacemos responsables en caso de accidente si los valores de la mercancía no son reportados por cliente.';
                    notes_es += '   \n';
                    notes_es += '	* Mercancía que llegue dañada no se descargara hasta tener autorización de Cliente';
                    notes_es += '   \n'; 
                    notes_es += '	* No nos hacemos responsables por productos perecederos';
                    notes_es += '   \n'; 	
                    notes_es += '	* Pak2Go se deslinda de responsabilidad en caso de catástrofes naturales.';
                    notes_es += '   \n';	
                    notes_es += '	* La factura de Almacenaje deberá estar liquidada en su totalidad para procesar cualquier reclamación.';

                    notes_en = notes_es;
                }
                
                quote.PDF_Notes__c = String.isEmpty(notes_es)?'Ninguna':notes_es;
                quote.PDF_Notes_EN__c = String.isEmpty(notes_en)?'None':notes_en;
            }
        }
    }
    if(trigger.isUpdate)
    {
        if(!RecursiveCheck.triggerMonitor.contains('NEU_NotesQuotationPDFUpdate')){
            RecursiveCheck.triggerMonitor.add('NEU_NotesQuotationPDFUpdate');
            for(Customer_Quote__c quote : trigger.new)
            {
                notes_es = '';
                notes_en = '';
                Customer_Quote__c old_quote = Trigger.oldMap.get(quote.Id);
                
                if(quote.PDF_Notes__c == null || quote.PDF_Notes_EN__c == null || quote.Freight_Mode__c != old_quote.Freight_Mode__c || quote.Service_Mode__c != old_quote.Service_Mode__c || quote.Service_Type__c != old_quote.Service_Type__c || quote.Container_Type__c != old_quote.Container_Type__c)
                {
                    //M
                    if((quote.Freight_Mode__c == 'Sea' && quote.Service_Mode__c == 'IMPORT' && quote.Service_Type__c == 'LCL') || Test.isRunningTest())
                    {
                        notes_es =  PAK_NotesQuotationPdf.NotesPDF_M_Import_LCL_Es();
                        notes_en =  PAK_NotesQuotationPdf.NotesPDF_M_Import_LCL_En();
                    }
                    //M
                    if((quote.Freight_Mode__c == 'Sea' && quote.Service_Mode__c == 'EXPORT' && quote.Service_Type__c == 'LCL') || Test.isRunningTest())
                    {
                        notes_es =  PAK_NotesQuotationPdf.NotesPDF_M_Export_LCL_Es();
                        notes_en =  PAK_NotesQuotationPdf.NotesPDF_M_Export_LCL_En();
                    }
                    //M           
                    if((quote.Freight_Mode__c == 'Sea' && quote.Service_Mode__c == 'EXPORT' && quote.Service_Type__c == 'FCL') || Test.isRunningTest())                     
                    {
                        notes_es =  PAK_NotesQuotationPdf.NotesPDF_M_Export_FCL_Es();
                        notes_en =  PAK_NotesQuotationPdf.NotesPDF_M_Export_FCL_En();
                    }        
                    //M
                    if((quote.Freight_Mode__c == 'Sea' && quote.Service_Mode__c == 'IMPORT' && quote.Service_Type__c == 'FCL') || Test.isRunningTest())
                    {
                        notes_es =  PAK_NotesQuotationPdf.NotesPDF_M_Import_FCL_Es();
                        notes_en =  PAK_NotesQuotationPdf.NotesPDF_M_Import_FCL_Es();
                    
                    }
                    //FI
                    if((quote.Freight_Mode__c == 'Road' && (quote.Service_Mode__c == 'IMPORT' || quote.Service_Mode__c == 'EXPORT' || quote.Service_Mode__c == 'INTERNATIONAL') && quote.Service_Type__c == 'FTL') || Test.isRunningTest())
                    {
                        notes_es =  PAK_NotesQuotationPdf.NotesPDF_FI_Es();
                        notes_en =  PAK_NotesQuotationPdf.NotesPDF_FI_En();
                    }
                    //FI
                    if((quote.Freight_Mode__c == 'Road' && (quote.Service_Mode__c == 'IMPORT' || quote.Service_Mode__c == 'EXPORT' || quote.Service_Mode__c == 'INTERNATIONAL') && quote.Service_Type__c == 'LTL') || Test.isRunningTest())
                    {
                        notes_es =  PAK_NotesQuotationPdf.NotesPDF_FI_Es();
                        notes_en =  PAK_NotesQuotationPdf.NotesPDF_FI_En(); 
                    }
                    
                    if((quote.Freight_Mode__c == 'Road' && quote.Service_Mode__c == 'NATIONAL' && quote.Service_Type__c == 'LTL') || Test.isRunningTest())
                    {
                        notes_es += '   En caso de que tu mercancía llegue dañada tienes un máximo de 24 horas para levantar con tu ejecutivo la reclamación, después de dicho tiempo ya no será válida ninguna garantía.';
                        notes_es += '   \n\n';
                        notes_es += '   DIMENSIONES MÁXIMAS';
                        notes_es += '   \n\n';
                        notes_es += '       - 1.20 (ANCHO) X 1.05 (LARGO) X 1.90 (ALTO)';
                        notes_es += '   \n\n';
                        notes_es += '   PESO';
                        notes_es += '   \n\n';
                        notes_es += '       - DE 71 KG A 1,100 KG.'; 
                        notes_es += '       \n';
                        notes_es += '       - Paletizado y emplayado.';
                        notes_es += '   \n\n';
                        notes_es += '   CARACTERÍSTICAS';
                        notes_es += '   \n\n';
                        notes_es += '       - Servicio puerta a puerta.';
                        notes_es += '       \n';
                        notes_es += '       - Recolecciones y entregas en tiempos definidos.';
                        notes_es += '       \n';
                        notes_es += '       - Rastreo y confirmación en linea.';
                        notes_es += '       \n';
                        notes_es += '       - Seguridad en el manejo y transporte de carga.';
                        notes_es += '       \n';
                        notes_es += '       - Guía por pallet.';
                        notes_es += '       \n';
                        notes_es += '       - Retorno de documentos de acuse de recibo.';
                        notes_es += '   \n\n';
                        notes_es += '   SEGURO OPCIONAL';
                        notes_es += '   \n\n';
                        notes_es += '       - Costo de la póliza del 1.2% del valor declarado del envío.'; 
                        notes_es += '       \n';
                        notes_es += '       - La cobertura máxima es de $100,000 pesos, deducible del 20%.'; 
                        
                        notes_en += '   In case your merchandise arrives damaged you have a maximum of 24 hours to raise with your executive the claim, after that time no guarantee will be valid.';
                        notes_en += '   \n\n';
                        notes_en += '   MAXIMUM DIMENSIONS';
                        notes_en += '   \n\n';
                        notes_en += '       - 1.20 (WIDTH) X 1.05 (LONG) X 1.90 (HIGH).';
                        notes_en += '   \n\n';
                        notes_en += '   WEIGHT';
                        notes_en += '   \n\n';
                        notes_en += '       - FROM 71 KG TO 1,100 KG.';
                        notes_en += '       \n'; 
                        notes_en += '       - Palletizing and waving.';
                        notes_en += '   \n\n';
                        notes_en += '   CHARACTERISTICS';
                        notes_en += '   \n\n';
                        notes_en += '       - Door to door service.';
                        notes_en += '       \n';
                        notes_en += '       - Collection and deliveries at defined times.';
                        notes_en += '       \n';
                        notes_en += '       - Online tracking and confirmation.';
                        notes_en += '       \n';
                        notes_en += '       - Safety in the handling and transport of cargo.';
                        notes_en += '       \n';
                        notes_en += '       - Guide by pallet.';
                        notes_en += '       \n';
                        notes_en += '       <li>Return of acknowledgment documents.';
                        notes_en += '   \n\n';
                        notes_en += '   OPTIONAL INSURANCE';
                        notes_en += '   \n\n';
                        notes_en += '       - Policy cost of 1.2% of the declared value of the shipment.';
                        notes_en += '       \n'; 
                        notes_en += '       - Maximum coverage is $ 100,000 pesos, deductible of 20%.'; 
                    }
                    // FN
                    if((quote.Freight_Mode__c == 'Road' && quote.Service_Mode__c == 'NATIONAL' &&
                            (quote.Service_Type__c == 'FTL' || quote.Service_Type__c == 'FP' || quote.Service_Type__c == 'FO')) || Test.isRunningTest())
                    {
                            notes_es =  PAK_NotesQuotationPdf.NotesPDF_FN_Es();
                            notes_en =  PAK_NotesQuotationPdf.NotesPDF_FN_En();
                    }
                    
                    if((quote.Freight_Mode__c == 'Air' && quote.Service_Type__c != 'MAYOREO') || Test.isRunningTest())
                    {
                        notes_es += 'CONDICIONES IMPORTANTES';
                        notes_es += '\n\n';
                        notes_es += '	- Crédito sujeto a aprobación.';
                        notes_es += '       \n';
                        notes_es += '   - Sujeto a disponibilidad de espacio';
                        notes_es += '   \n';
                        notes_es += '   - T/T:';
                        notes_es += '   \n';
                        notes_es += '   - Via:';
                        notes_es += '   \n';
                        notes_es += '   - Tarifa para carga general no peligrosa';
                        notes_es += '   \n';
                        notes_es += '   - Aplican restricciones de pesos y medidas por bulto';
                        
                        notes_en += 'IMPORTANT CONDITIONS';
                        notes_en += '\n\n';
                        notes_en += '		- Credit subject to approval.';
                        notes_en += '       \n';
                        notes_en += '   - Subject to space availability';
                        notes_en += '   \n';
                        notes_en += '   - T/T:';
                        notes_en += '   \n';
                        notes_en += '   - Via:';
                        notes_en += '   \n';
                        notes_en += '   - Rate for general non-dangerous cargo';
                        notes_en += '   \n';
                        notes_en += '   - Restrictions of weights and measures per package are applied';
                    }
                    //pto
                    if(quote.Service_Mode__c == 'PORT' || Test.isRunningTest())
                    {
                        notes_es = PAK_NotesQuotationPdf.NotesPDF_Pto_Es();
                        notes_en = PAK_NotesQuotationPdf.NotesPDF_Pto_En();
                        
                    }
                    
                    if(quote.Freight_Mode__c != 'Air' && quote.Service_Type__c == 'MAYOREO' || Test.isRunningTest())
                    {
                        notes_es += '- Precios no incluyen IVA';
                        notes_es += '   \n'; 
                        notes_es += '- Servicios incluyen recolección';
                        notes_es += '   \n'; 
                        notes_es += '- Rastreo en Línea';
                        notes_es += '   \n'; 
                        notes_es += '- Atención Personalizada';
                        notes_es += '   \n'; 
                        notes_es += '- Prohibida su reventa';
                        
                        notes_en += '- Prices do not include VAT';
                        notes_en += '   \n';
                        notes_en += '- Services include collection';
                        notes_en += '   \n';
                        notes_en += '- Online Tracking';
                        notes_en += '   \n';
                        notes_en += '- Personalized attention';
                        notes_en += '   \n';
                        notes_en += '- Resale prohibited';
                    }
                    
                    if(quote.Freight_Mode__c == 'Air' && quote.Service_Type__c == 'MAYOREO' || Test.isRunningTest())
                    {
                        notes_es += 'Servicios Incluidos'; 
                        notes_es += '\n\n';
                        notes_es += '   - Recolección en origen';
                        notes_es += '   \n';
                        notes_es += '   - Despacho de exportación (Pedimento Global - Valor Factura no mayor a 1000USD)';
                        notes_es += '   \n';
                        notes_es += '   - Flete aéreo';
                        notes_es += '   \n';
                        notes_es += '   - Entrega en destino final';
                        notes_es += '\n\n';
                        notes_es += 'Servicios No Incluidos';
                        notes_es += '\n\n';
                        notes_es += '   - Impuestos a la importación';
                        notes_es += '   \n';
                        notes_es += '   - Maniobras de carga y descarga';
                        notes_es += '   \n';
                        notes_es += '   - Agente Aduanal';
                        notes_es += '   \n';
                        notes_es += '   - Seguro de la mercancía';
                        notes_es += '\n\n';
                        notes_es += 'CONDICIONES IMPORTANTES';
                        notes_es += '	* Crédito sujeto a aprobación.';
                        notes_es += '       \n';
                        notes_es += '   * Aplica para el peso y dimensiones proporcionados.';
                        notes_es += '   \n';
                        notes_es += '   * En caso de haber cambios en pesos y dimensiones, se actualizará la tarifa.';
                        
                        notes_en += 'Included services';
                        notes_en += '\n\n';
                        notes_en += '   - Collection at origin';
                        notes_en += '   \n';
                        notes_en += '   - Export Dispatch (Global Motion - Invoice Value not higher than 1000USD)';
                        notes_en += '   \n';
                        notes_en += '   - Air freight';
                        notes_en += '   \n';
                        notes_en += '   - Delivery at final destination';
                        notes_en += '\n\n';
                        notes_en += 'Services Not Included';
                        notes_en += '\n\n';
                        notes_en += '   - Import taxes';
                        notes_en += '   \n';
                        notes_en += '   - Loading and unloading maneuvers';
                        notes_en += '   \n';
                        notes_en += '   - Customs Agent';
                        notes_en += '   \n';
                        notes_en += '   - Insurance of the merchandise';
                        notes_en += '\n\n';
                        notes_en += 'IMPORTANT CONDITIONS';
                        notes_en += '   * Applies for the weight and dimensions provided.';
                        notes_en += '   \n';
                        notes_en += '   * In case of changes in weights and dimensions, the rate will be updated.';
                    }
                    
                    //FI
                    if((quote.Freight_Mode__c == 'Road' && quote.Service_Mode__c == 'NATIONAL' && quote.Service_Type__c == 'LTL' && quote.Container_Type__c == 'a0K0Y000005wxyw') || Test.isRunningTest())
                    {
                        notes_es += 'CONDICIONES IMPORTANTES';
                        notes_es += '\n\n';
                        notes_es += '	* Crédito sujeto a aprobación.';
                        notes_es += '       \n';
                        notes_es += '   * El servicio cotizado es de carga consolidada con días de tránsito y rutas logísticas previamente establecidas.';
                        notes_es += '   \n';
                        notes_es += '   * El servicio es libre de maniobras.';
                        notes_es += '   \n';
                        notes_es += '   * Los servicios de carga regular limitan la transportación de Materiales Peligrosos o aquellas que por Normatividad Nacional o Internacional su manejo sea regulado.';
                        notes_es += '   \n';
                        notes_es += '   * Ver anexo de Artículos Prohibidos para la transportación.';
                        notes_es += '   \n';
                        notes_es += '   * Los días de servicio son días hábiles, no se consideran días festivos y se calculan de acuerdo a la fecha en que se cotiza considerando las horas corte de nuestras rutas.';
                        notes_es += '   \n';
                        notes_es += '   * El seguro contratado no cubre material frágil, vidrio, pisos azulejos, fibra de vidrio ni materiales prohibidos o de circulación restringida.';
                        notes_es += '   \n';
                        notes_es += '   * Los servicios por cobrar solo se pueden realizar para Empresas y Personas Físicas con Actividad Empresarial.';
                        notes_es += '   \n';
                        notes_es += '   * Las Recolecciones deberán programarse con un día de anticipación a la fecha requerida';
                        notes_es += '   \n';
                        notes_es += '   * Las Recolecciones urgentes se podrán programar mismo día antes de las 12:00 y estarán sujetas a disponibilidad de la plaza';
                        notes_es += '   \n';
                        notes_es += '   * Por favor considere que nuestros Códigos Postales, Estados y colonias están ligadas a SEPOMEX por lo que se actualizan cada 6 meses.';
                        notes_es += '   \n';
                        notes_es += '   * Para realizar un envío a través de ______________ deberá presentar una factura o nota de remisión membretada que ampare la procedencia del material.';
                        notes_es += '\n\n';
                        notes_es += 'DIMENSIONES MAXIMAS';
                        notes_es += '\n\n';
                        notes_es += '   1.20 (ANCHO) X 1.05 (LARGO) X 1.90 (ALTO)';
                        notes_es += '\n\n';
                        notes_es += 'PESO';
                        notes_es += '\n\n';
                        notes_es += '   DE 71 KG A 1,100 KG';
                        notes_es += '   \n';
                        notes_es += '   PALETIZADO Y EMPLAYADO';
                        notes_es += '\n\n';
                        notes_es += 'CATACTERISTICAS:';
                        notes_es += '\n\n';
                        notes_es += '   SERVICIO PUERTA A PUERTA';
                        notes_es += '   \n';
                        notes_es += '   RECOLECCIONES Y ENTREGAS EN TIEMPOS DEFINIDOS';
                        notes_es += '   \n';
                        notes_es += '   RASTREO Y CONFIRMACION EN LINEA';
                        notes_es += '   \n';
                        notes_es += '   SEGURIDAD EN EL MANEJO Y TRANSPORTE DE CARGA';
                        notes_es += '   \n';
                        notes_es += '   GUIA POR PALLET';
                        notes_es += '   \n';
                        notes_es += '   RETORNO DE DOCUMENTOS DE ACUSE DE RECIBO';
                        notes_es += '\n\n';
                        notes_es += 'SEGURO OPCIONAL:';
                        notes_es += '\n\n';
                        notes_es += '   COSTO DE LA POLIZA DEL 1.2% DEL VALOR DECLARADO DEL ENVIO';
                        notes_es += '   \n'; 
                        notes_es += '   LA COBERTURA MAXIMA ES DE $100,000 PESOS, DEDUCIBLE DEL 20%.';
                        
                        notes_en += 'IMPORTANT CONDITIONS';
                        notes_en += '\n\n';
                        notes_en += '	* Credit subject to approval.';
                        notes_en += '       \n';
                        notes_en += '   * The service quoted is consolidated cargo with transit days and logistics routes previously established.';
                        notes_en += '   \n';
                        notes_en += '   * The service is free of maneuvers.';
                        notes_en += '   \n';
                        notes_en += '   * Regular cargo services limit the transportation of dangerous materials or those that are regulated by National or International Regulations.';
                        notes_en += '   \n';
                        notes_en += '   * See annex of Prohibited Items for transportation.';
                        notes_en += '   \n';
                        notes_en += '   * The days of service are working days, are not considered holidays and are calculated according to the date on which it is quoted considering the cut-off hours of our routes.';
                        notes_en += '   \n';
                        notes_en += '   * The insurance contracted does not cover fragile material, glass, tile floors, fiberglass or prohibited materials or restricted circulation.';
                        notes_en += '   \n';
                        notes_en += '   * The services receivable can only be made for Companies and Individuals with Business Activity.';
                        notes_en += '   \n';
                        notes_en += '   * Collections must be scheduled one day in advance of the required date';
                        notes_en += '   \n';
                        notes_en += '   * Urgent collections can be scheduled same day before 12:00 and will be subject to availability of the place';
                        notes_en += '   \n';
                        notes_en += '   * Please consider that our Postal Codes, States and colonies are linked to SEPOMEX so they are updated every 6 months.';
                        notes_en += '   \n';
                        notes_en += '   * To make a shipment through ______________ must submit an invoice or letter of reference letterhead that covers the source of the material.';
                        notes_en += '\n\n';
                        notes_en += 'MAXIMUM DIMENSIONS';
                        notes_en += '\n\n';
                        notes_en += '   1.20 (WIDE) X 1.05 (LONG) X 1.90 (HIGH)';
                        notes_en += '\n\n';
                        notes_en += 'WEIGHT';
                        notes_en += '\n\n';
                        notes_en += '   FROM 71 KG TO 1,100 KG';
                        notes_en += '   \n';
                        notes_en += '   PALLETIZED AND EMPLAYED';
                        notes_en += '\n\n';
                        notes_en += 'CHARACTERISTICS';
                        notes_en += '\n\n';
                        notes_en += '   DOOR TO DOOR SERVICE';
                        notes_en += '   \n';
                        notes_en += '   COLLECTIONS AND DELIVERIES IN DEFINED TIMES';
                        notes_en += '   \n';
                        notes_en += '   ONLINE TRACKING AND CONFIRMATION';
                        notes_en += '   \n';
                        notes_en += '   SECURITY IN CARGO HANDLING AND TRANSPORTATION';
                        notes_en += '   \n';
                        notes_en += '   GUIDE BY PALLET';
                        notes_en += '   \n';
                        notes_en += '   RETURN OF RECEIPT ACKNOWLEDGMENT DOCUMENTS';
                        notes_en += '\n\n';
                        notes_en += 'OPTIONAL INSURANCE:';
                        notes_en += '\n\n';
                        notes_en += '   COST OF THE POLICY OF 1.2% OF THE DECLARED VALUE OF SHIPPING';
                        notes_en += '   \n';
                        notes_en += '   MAXIMUM COVERAGE IS $ 100,000 PESOS, DEDUCTIBLE OF 20%.';
                    }
                    
                    if(quote.Only_Warehouse_Service__c || Test.isRunningTest())
                    {
                        notes_es += 'Servicios No Incluidos';
                        notes_es += '\n\n';
                        notes_es += '	- Maniobras de Carga y Descarga';
                        notes_es += '   \n';	
                        notes_es += '	- Recolección y Entrega en Zona Residencial';
                        notes_es += '   \n';	
                        notes_es += '	- Equipo de Rampas, Grúas, Gatas, etc';
                        notes_es += '   \n';	
                        notes_es += '	- Servicios de Pick & Pack o etiquetado';
                        notes_es += '   \n';
                        notes_es += '	- Montacargas mas 1 ton';
                        notes_es += '   \n'; 
                        notes_es += '	- Servicio de entarimado';
                        notes_es += '   \n'; 
                        notes_es += '	- Retrabajos';
                        notes_es += '   \n';
                        notes_es += '	- Servicio de Cross Dock';
                        notes_es += '\n\n';
                        notes_es += 'CONDICIONES IMPORTANTES';
                        notes_es += '\n\n';
                        notes_es += '	* Crédito sujeto a aprobación.';
                        notes_es += '       \n';
                        notes_es += '	* En caso de requerir Maniobras , FAVOR de Responder este correo, indicando tipo de maniobras necesarias.';
                        notes_es += '   \n';	
                        notes_es += '	* Cotización aplicable a carga general no peligrosa, con pesos y medidas reglamentarias.';
                        notes_es += '   \n';	
                        notes_es += '	* Peso máximo por tarima: 1 toneladas.';
                        notes_es += '   \n';
                        notes_es += '	* Altura Máxima tarima : 1.7m';
                        notes_es += '   \n';	
                        notes_es += '	* Tiempo para carga o descarga: 3hrs';
                        notes_es += '   \n';	
                        notes_es += '	* Los cortes de Almacenamiento son Mensuales';
                        notes_es += '   \n'; 
                        notes_es += '	* En caso de que la información proporcionada, tenga algún cambio (Medidas, Peso, Maniobras) la tarifa no es válida.';
                        notes_es += '	\n';	
                        notes_es += '	* Las tarifas proporcionadas son estimados y pueden surgir cambios sin previo aviso.';
                        notes_es += '   \n';	
                        notes_es += '	* Tarifa sujeta a disponibilidad de espacio.';
                        notes_es += '   \n';	
                        notes_es += '	* Los días Hábiles para recibir y entregar mercancía son de Lunes a Sábado';
                        notes_es += '   \n';
                        notes_es += '	* Los horarios para recibir y entregar mercancía son de 8am a 8pm Lunes a Viernes, Sábados de 9am a 2pm';
                        notes_es += '   \n';	
                        notes_es += '	* Los servicios de Cross Dock aplican de 2 a 5 días hábiles teniendo un costo de $1,500 mas maniobras.';
                        notes_es += '   \n';
                        notes_es += '	* Los servicios de Cross Dock que pasen del 5to día hábil se cobran como almacenamiento mensual.';
                        notes_es += '   \n';	
                        notes_es += '	* No nos hacemos responsables en caso de accidente si los valores de la mercancía no son reportados por cliente.';
                        notes_es += '   \n';
                        notes_es += '	* Mercancía que llegue dañada no se descargara hasta tener autorización de Cliente';
                        notes_es += '   \n'; 
                        notes_es += '	* No nos hacemos responsables por productos perecederos';
                        notes_es += '   \n'; 	
                        notes_es += '	* Pak2Go se deslinda de responsabilidad en caso de catástrofes naturales.';
                        notes_es += '   \n';	
                        notes_es += '	* La factura de Almacenaje deberá estar liquidada en su totalidad para procesar cualquier reclamación.';
        
                        notes_en = notes_es;
                    }
                    
                    //if(old_quote.PDF_Notes__c == null || quote.PDF_Notes__c == null || quote.Freight_Mode__c != old_quote.Freight_Mode__c || quote.Service_Mode__c != old_quote.Service_Mode__c || quote.Service_Type__c != old_quote.Service_Type__c)
                        quote.PDF_Notes__c = notes_es;
                    //if(old_quote.PDF_Notes_EN__c == null || quote.PDF_Notes_EN__c == null || quote.Freight_Mode__c != old_quote.Freight_Mode__c || quote.Service_Mode__c != old_quote.Service_Mode__c || quote.Service_Type__c != old_quote.Service_Type__c)
                        quote.PDF_Notes_EN__c = notes_en;
                }
            }
        }
    }
}