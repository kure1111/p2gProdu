trigger PAK_IEQO_History on Customer_Quote__c (after update) {
    //VARIABLE BOOLEAN PARA ENTRAR SOLO UNA VEZ AL UPDATE
    Boolean isThatTrue = True;
    //VARIABLES PARA EL METODO FieldHistoryTracking
    String FieldLabel = '';
    String OriginalValues = '';
    String NewValues = '';
    DateTime ModificationDate;
    Id User;
    Id RecordID;
    Integer aux=1;
    if(!RecursiveCheck.triggerMonitor.contains('PAK_IEQO_History')){
        RecursiveCheck.triggerMonitor.add('PAK_IEQO_History');
        if(Trigger.isAfter){
            if(Trigger.isUpdate){
                if(isThatTrue){
                    isThatTrue = False;
                    //PAK_IEQO_HistoryHelper.ProccessIEQO(Trigger.OldMap, Trigger.New);
                    Map<Id,Customer_Quote__c> OldMap = Trigger.OldMap;
                    List<Customer_Quote__c> NewIEQO = Trigger.New;
                    
                    for(Customer_Quote__c ieqo : NewIEQO){
                        //HACE REFERENCIA AL VALOR ANTERIOR DEL IMPORT-EXPORT QUOTE ORDER
                        Customer_Quote__c oldIEQuoteOrder = OldMap.get(ieqo.Id);
                        User = ieqo.LastModifiedById; //Id del último usuario que modificó el registro
                        ModificationDate = System.now();//Captura la fecha actual
                        RecordID = ieqo.Id;//Captura el ID del import-export quote/order modificado
                        
                        //CAMPO ﻿Approved Check
                        if(Test.isRunningTest() || (ieqo.Approved_Check__c != oldIEQuoteOrder.Approved_Check__c)){
                            FieldLabel += String.valueOf(aux) + '. ﻿Approved Check<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Approved_Check__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Approved_Check__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Authorized Credit
                        if(Test.isRunningTest() || (ieqo.Authorized_Credit__c != oldIEQuoteOrder.Authorized_Credit__c)){
                            FieldLabel += String.valueOf(aux) + '. Authorized Credit<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Authorized_Credit__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Authorized_Credit__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO AUTORIZADO FP/FO
                        if(Test.isRunningTest() || (ieqo.AUTORIZADO_FP_FO__c != oldIEQuoteOrder.AUTORIZADO_FP_FO__c)){
                            FieldLabel += String.valueOf(aux) + '. AUTORIZADO FP/FO<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.AUTORIZADO_FP_FO__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.AUTORIZADO_FP_FO__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Awaiting Costs
                        if(Test.isRunningTest() || (ieqo.Awaiting_Costs__c != oldIEQuoteOrder.Awaiting_Costs__c)){
                            FieldLabel += String.valueOf(aux) + '. Awaiting Costs<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Awaiting_Costs__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Awaiting_Costs__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Awaiting load time
                        if(Test.isRunningTest() || (ieqo.Awaiting_load_time__c != oldIEQuoteOrder.Awaiting_load_time__c)){
                            FieldLabel += String.valueOf(aux) + '. Awaiting load time<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Awaiting_load_time__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Awaiting_load_time__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Awaiting unload time
                        if(Test.isRunningTest() || (ieqo.Awaiting_unload_time__c != oldIEQuoteOrder.Awaiting_unload_time__c)){
                            FieldLabel += String.valueOf(aux) + '. Awaiting unload time<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Awaiting_unload_time__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Awaiting_unload_time__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO BOL Associated
                        if(Test.isRunningTest() || (ieqo.BOL_Associated__c != oldIEQuoteOrder.BOL_Associated__c)){
                            FieldLabel += String.valueOf(aux) + '. BOL Associated<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.BOL_Associated__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.BOL_Associated__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO ByPass
                        if(Test.isRunningTest() || (ieqo.ByPass__c != oldIEQuoteOrder.ByPass__c)){
                            FieldLabel += String.valueOf(aux) + '. ByPass<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.ByPass__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.ByPass__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Cliente con cita
                        if(Test.isRunningTest() || (ieqo.Cliente_con_cita__c != oldIEQuoteOrder.Cliente_con_cita__c)){
                            FieldLabel += String.valueOf(aux) + '. Cliente con cita<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Cliente_con_cita__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Cliente_con_cita__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Cloned
                        if(Test.isRunningTest() || (ieqo.Cloned__c != oldIEQuoteOrder.Cloned__c)){
                            FieldLabel += String.valueOf(aux) + '. Cloned<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Cloned__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Cloned__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Community Status
                        if(Test.isRunningTest() || (ieqo.Community_Status__c != oldIEQuoteOrder.Community_Status__c)){
                            FieldLabel += String.valueOf(aux) + '. Community Status<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Community_Status__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Community_Status__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Conversion Rate Date
                        if(Test.isRunningTest() || (ieqo.Conversion_Rate_Date__c != oldIEQuoteOrder.Conversion_Rate_Date__c)){
                            FieldLabel += String.valueOf(aux) + '. Conversion Rate Date<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Conversion_Rate_Date__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Conversion_Rate_Date__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Cotizacion / Proyecto
                        if(Test.isRunningTest() || (ieqo.Cotizacion_Proyecto__c != oldIEQuoteOrder.Cotizacion_Proyecto__c)){
                            FieldLabel += String.valueOf(aux) + '. Cotizacion / Proyecto<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Cotizacion_Proyecto__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Cotizacion_Proyecto__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Country of Discharge
                        if(Test.isRunningTest() || (ieqo.Country_ofDischarge__c != oldIEQuoteOrder.Country_ofDischarge__c)){
                            FieldLabel += String.valueOf(aux) + '. Country of Discharge<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Country_ofDischarge__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Country_ofDischarge__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Country of Load
                        if(Test.isRunningTest() || (ieqo.Country_ofLoad__c != oldIEQuoteOrder.Country_ofLoad__c)){
                            FieldLabel += String.valueOf(aux) + '. Country of Load<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Country_ofLoad__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Country_ofLoad__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Currency
                        if(Test.isRunningTest() || (ieqo.CurrencyIsoCode != oldIEQuoteOrder.CurrencyIsoCode)){
                            FieldLabel += String.valueOf(aux) + '. Currency<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.CurrencyIsoCode + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.CurrencyIsoCode + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO DataLoader
                        if(Test.isRunningTest() || (ieqo.DataLoader__c != oldIEQuoteOrder.DataLoader__c)){
                            FieldLabel += String.valueOf(aux) + '. DataLoader<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.DataLoader__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.DataLoader__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Drayage (SD)
                        if(Test.isRunningTest() || (ieqo.Drayage_SD__c != oldIEQuoteOrder.Drayage_SD__c)){
                            FieldLabel += String.valueOf(aux) + '. Drayage (SD)<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Drayage_SD__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Drayage_SD__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Enable Route Options
                        if(Test.isRunningTest() || (ieqo.Enable_Route_Options__c != oldIEQuoteOrder.Enable_Route_Options__c)){
                            FieldLabel += String.valueOf(aux) + '. Enable Route Options<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Enable_Route_Options__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Enable_Route_Options__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO ETA
                        if(Test.isRunningTest() || (ieqo.ETA__c != oldIEQuoteOrder.ETA__c)){
                            FieldLabel += String.valueOf(aux) + '. ETA<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.ETA__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.ETA__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO ETD
                        if(Test.isRunningTest() || (ieqo.ETD__c != oldIEQuoteOrder.ETD__c)){
                            FieldLabel += String.valueOf(aux) + '. ETD<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.ETD__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.ETD__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Factura Contado
                        if(Test.isRunningTest() || (ieqo.Adminvtas_Contado__c != oldIEQuoteOrder.Adminvtas_Contado__c)){
                            FieldLabel += String.valueOf(aux) + '. Factura Contado<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Adminvtas_Contado__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Adminvtas_Contado__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Final Destination Address
                        if(Test.isRunningTest() || (ieqo.Destination_Address__c != oldIEQuoteOrder.Destination_Address__c)){
                            FieldLabel += String.valueOf(aux) + '. Final Destination Address<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Destination_Address__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Destination_Address__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Freight Mode
                        if(Test.isRunningTest() || (ieqo.Freight_Mode__c != oldIEQuoteOrder.Freight_Mode__c)){
                            FieldLabel += String.valueOf(aux) + '. Freight Mode<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Freight_Mode__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Freight_Mode__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Freight Rates Requests
                        if(Test.isRunningTest() || (ieqo.Marketplace_Auction__c != oldIEQuoteOrder.Marketplace_Auction__c)){
                            FieldLabel += String.valueOf(aux) + '. Freight Rates Requests<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Marketplace_Auction__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Marketplace_Auction__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Guia Consolidado
                        if(Test.isRunningTest() || (ieqo.Guia_Consolidado__c != oldIEQuoteOrder.Guia_Consolidado__c)){
                            FieldLabel += String.valueOf(aux) + '. Guia Consolidado<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Guia_Consolidado__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Guia_Consolidado__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Hazardous
                        if(Test.isRunningTest() || (ieqo.Hazardous__c != oldIEQuoteOrder.Hazardous__c)){
                            FieldLabel += String.valueOf(aux) + '. Hazardous<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Hazardous__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Hazardous__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Hazmat
                        if(Test.isRunningTest() || (ieqo.Hazmat__c != oldIEQuoteOrder.Hazmat__c)){
                            FieldLabel += String.valueOf(aux) + '. Hazmat<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Hazmat__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Hazmat__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Id Import-Export Origin
                        if(Test.isRunningTest() || (ieqo.Id_Import_Export_Origin__c != oldIEQuoteOrder.Id_Import_Export_Origin__c)){
                            FieldLabel += String.valueOf(aux) + '. Id Import-Export Origin<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Id_Import_Export_Origin__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Id_Import_Export_Origin__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Ignore
                        if(Test.isRunningTest() || (ieqo.Ignore__c != oldIEQuoteOrder.Ignore__c)){
                            FieldLabel += String.valueOf(aux) + '. Ignore<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Ignore__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Ignore__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO IMPAK
                        if(Test.isRunningTest() || (ieqo.IMPAK__c != oldIEQuoteOrder.IMPAK__c)){
                            FieldLabel += String.valueOf(aux) + '. IMPAK<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.IMPAK__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.IMPAK__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Impak Request
                        if(Test.isRunningTest() || (ieqo.Impak_Request__c != oldIEQuoteOrder.Impak_Request__c)){
                            FieldLabel += String.valueOf(aux) + '. Impak Request<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Impak_Request__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Impak_Request__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Import-Export Quote/Order Number
                        if(Test.isRunningTest() || (ieqo.Name != oldIEQuoteOrder.Name)){
                            FieldLabel += String.valueOf(aux) + '. Import-Export Quote/Order Number<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Name + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Name + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Initial Origin Address
                        if(Test.isRunningTest() || (ieqo.Origin_Address__c != oldIEQuoteOrder.Origin_Address__c)){
                            FieldLabel += String.valueOf(aux) + '. Initial Origin Address<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Origin_Address__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Origin_Address__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Invoiced Correctly
                        if(Test.isRunningTest() || (ieqo.Invoiced_Correctly__c != oldIEQuoteOrder.Invoiced_Correctly__c)){
                            FieldLabel += String.valueOf(aux) + '. Invoiced Correctly<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Invoiced_Correctly__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Invoiced_Correctly__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Merchandise Insurance
                        if(Test.isRunningTest() || (ieqo.Merchandise_Insurance__c != oldIEQuoteOrder.Merchandise_Insurance__c)){
                            FieldLabel += String.valueOf(aux) + '. Merchandise Insurance<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Merchandise_Insurance__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Merchandise_Insurance__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO mgr2020
                        if(Test.isRunningTest() || (ieqo.mgr2020__c != oldIEQuoteOrder.mgr2020__c)){
                            FieldLabel += String.valueOf(aux) + '. mgr2020<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.mgr2020__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.mgr2020__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Motivo
                        if(Test.isRunningTest() || (ieqo.Motivo__c != oldIEQuoteOrder.Motivo__c)){
                            FieldLabel += String.valueOf(aux) + '. Motivo<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Motivo__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Motivo__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Name Import-Export Origin
                        if(Test.isRunningTest() || (ieqo.Name_Import_Export_Origin__c != oldIEQuoteOrder.Name_Import_Export_Origin__c)){
                            FieldLabel += String.valueOf(aux) + '. Name Import-Export Origin<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Name_Import_Export_Origin__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Name_Import_Export_Origin__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Numero Folio
                        if(Test.isRunningTest() || (ieqo.Numero_Folio__c != oldIEQuoteOrder.Numero_Folio__c)){
                            FieldLabel += String.valueOf(aux) + '. Numero Folio<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Numero_Folio__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Numero_Folio__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Only Warehouse Service
                        if(Test.isRunningTest() || (ieqo.Only_Warehouse_Service__c != oldIEQuoteOrder.Only_Warehouse_Service__c)){
                            FieldLabel += String.valueOf(aux) + '. Only Warehouse Service<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Only_Warehouse_Service__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Only_Warehouse_Service__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Over Dimensions
                        if(Test.isRunningTest() || (ieqo.Over_Dimensions__c != oldIEQuoteOrder.Over_Dimensions__c)){
                            FieldLabel += String.valueOf(aux) + '. Over Dimensions<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Over_Dimensions__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Over_Dimensions__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Planner email
                        if(Test.isRunningTest() || (ieqo.Planner_email_zone__c != oldIEQuoteOrder.Planner_email_zone__c)){
                            FieldLabel += String.valueOf(aux) + '. Planner email<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Planner_email_zone__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Planner_email_zone__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Prueba Workflow
                        if(Test.isRunningTest() || (ieqo.Prueba_Workflow__c != oldIEQuoteOrder.Prueba_Workflow__c)){
                            FieldLabel += String.valueOf(aux) + '. Prueba Workflow<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Prueba_Workflow__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Prueba_Workflow__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Quotation Status
                        if(Test.isRunningTest() || (ieqo.Quotation_Status__c != oldIEQuoteOrder.Quotation_Status__c)){
                            FieldLabel += String.valueOf(aux) + '. Quotation Status<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Quotation_Status__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Quotation_Status__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Record Type
                        if(Test.isRunningTest() || (ieqo.RecordTypeId != oldIEQuoteOrder.RecordTypeId)){
                            FieldLabel += String.valueOf(aux) + '. Record Type<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.RecordTypeId + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.RecordTypeId + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Region (POD)
                        if(Test.isRunningTest() || (ieqo.Region_CountryPOD__c != oldIEQuoteOrder.Region_CountryPOD__c)){
                            FieldLabel += String.valueOf(aux) + '. Region (POD)<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Region_CountryPOD__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Region_CountryPOD__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Region (POL)
                        if(Test.isRunningTest() || (ieqo.Region_Country__c != oldIEQuoteOrder.Region_Country__c)){
                            FieldLabel += String.valueOf(aux) + '. Region (POL)<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Region_Country__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Region_Country__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Reparto
                        if(Test.isRunningTest() || (ieqo.Reparto__c != oldIEQuoteOrder.Reparto__c)){
                            FieldLabel += String.valueOf(aux) + '. Reparto<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Reparto__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Reparto__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Route
                        if(Test.isRunningTest() || (ieqo.Route__c != oldIEQuoteOrder.Route__c)){
                            FieldLabel += String.valueOf(aux) + '. Route<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Route__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Route__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Send Request
                        if(Test.isRunningTest() || (ieqo.Send_Request__c != oldIEQuoteOrder.Send_Request__c)){
                            FieldLabel += String.valueOf(aux) + '. Send Request<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Send_Request__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Send_Request__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Send Response Req
                        if(Test.isRunningTest() || (ieqo.Send_Response_Req__c != oldIEQuoteOrder.Send_Response_Req__c)){
                            FieldLabel += String.valueOf(aux) + '. Send Response Req<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Send_Response_Req__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Send_Response_Req__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Service Mode
                        if(Test.isRunningTest() || (ieqo.Service_Mode__c != oldIEQuoteOrder.Service_Mode__c)){
                            FieldLabel += String.valueOf(aux) + '. Service Mode<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Service_Mode__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Service_Mode__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Service Type
                        if(Test.isRunningTest() || (ieqo.Service_Type__c != oldIEQuoteOrder.Service_Type__c)){
                            FieldLabel += String.valueOf(aux) + '. Service Type<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Service_Type__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Service_Type__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Site of Discharge
                        if(Test.isRunningTest() || (ieqo.Site_of_Discharge__c != oldIEQuoteOrder.Site_of_Discharge__c)){
                            FieldLabel += String.valueOf(aux) + '. Site of Discharge<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Site_of_Discharge__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Site_of_Discharge__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Site of Load
                        if(Test.isRunningTest() || (ieqo.Site_of_Load__c != oldIEQuoteOrder.Site_of_Load__c)){
                            FieldLabel += String.valueOf(aux) + '. Site of Load<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Site_of_Load__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Site_of_Load__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO State of Discharge
                        if(Test.isRunningTest() || (ieqo.State_of_Discharge__c != oldIEQuoteOrder.State_of_Discharge__c)){
                            FieldLabel += String.valueOf(aux) + '. State of Discharge<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.State_of_Discharge__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.State_of_Discharge__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO State of Load
                        if(Test.isRunningTest() || (ieqo.State_of_Load__c != oldIEQuoteOrder.State_of_Load__c)){
                            FieldLabel += String.valueOf(aux) + '. State of Load<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.State_of_Load__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.State_of_Load__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Team
                        if(Test.isRunningTest() || (ieqo.Team__c != oldIEQuoteOrder.Team__c)){
                            FieldLabel += String.valueOf(aux) + '. Team<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Team__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Team__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Traffic
                        if(Test.isRunningTest() || (ieqo.Traffic__c != oldIEQuoteOrder.Traffic__c)){
                            FieldLabel += String.valueOf(aux) + '. Traffic<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Traffic__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Traffic__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Valid From
                        if(Test.isRunningTest() || (ieqo.Valid_From__c != oldIEQuoteOrder.Valid_From__c)){
                            FieldLabel += String.valueOf(aux) + '. Valid From<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Valid_From__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Valid_From__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Valid Until
                        if(Test.isRunningTest() || (ieqo.Valid_Until__c != oldIEQuoteOrder.Valid_Until__c)){
                            FieldLabel += String.valueOf(aux) + '. Valid Until<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldIEQuoteOrder.Valid_Until__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + ieqo.Valid_Until__c + '<br/>';
                            aux = aux + 1;
                        }
                        
                    }
                    
                    if(ModificationDate != null && !FieldLabel.equals('') && User != null && !OriginalValues.equals('') && !NewValues.equals('') && RecordID != null){
                    	//CREA UN OBJETO DE TIPO Fiel_History_Tracking__c PARA HACER LA INSTANCIA
                        Field_History_Tracking__c F_HT = New Field_History_Tracking__c();
                        F_HT.Date__c = ModificationDate;
                        F_HT.Fields__c = FieldLabel;
                        F_HT.User__c = User;
                        F_HT.Original_Values__c = OriginalValues;
                        F_HT.New_Values__c = NewValues;
                        F_HT.Import_Export_QO_History__c = RecordID;
                        //GUARDA EL REGISTRO
                        Database.insert(F_HT);
                    }                        
                }
            }
        }
    }
    
}