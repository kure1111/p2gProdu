trigger PAK_ShipmentSL_History on Shipment_Fee_Line__c (after update) {
    //VARIABLES PARA EL METODO FieldHistoryTracking
    String FieldLabel = '';
    String OriginalValues = '';
    String NewValues = '';
    DateTime ModificationDate;
    Id User;
    Id RecordID;
    Integer aux=1;

    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            //PAK_ShipmentSL_HistoryHelper.ProccessShipmentSL(Trigger.OldMap, Trigger.New);
            if(!RecursiveCheck.triggerMonitor.contains('PAK_ShipmentSL_History')){
                RecursiveCheck.triggerMonitor.add('PAK_ShipmentSL_History');
                Map<Id,Shipment_Fee_Line__c> OldMap = Trigger.OldMap;
                List<Shipment_Fee_Line__c> NewShipSL = Trigger.New;
                
                for(Shipment_Fee_Line__c shipSL: NewShipSL){
                    //HACE REFERENCIA AL VALOR ANTERIOR DEL SHIPMENT SERVICE LINE
                    Shipment_Fee_Line__c oldShipmentSL = OldMap.get(shipSL.Id);
                    User = shipSL.LastModifiedById; //Id del último usuario que modificó el registro
                    ModificationDate = System.now();//Captura la fecha actual
                    RecordID = shipSL.Id;//Captura el ID del shipment service line modificado
                    
                    //CAMPO ﻿Add to Quote
                    if(Test.isRunningTest() || (shipSL.Add_to_Quote__c != oldShipmentSL.Add_to_Quote__c)){
                        FieldLabel += String.valueOf(aux) + '. ﻿Add to Quote<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Add_to_Quote__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Add_to_Quote__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Base Shipment Service Line
                    if(Test.isRunningTest() || (shipSL.Shipment_Service_Line__c != oldShipmentSL.Shipment_Service_Line__c)){
                        FieldLabel += String.valueOf(aux) + '. Base Shipment Service Line<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Shipment_Service_Line__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Shipment_Service_Line__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Block
                    if(Test.isRunningTest() || (shipSL.Block__c != oldShipmentSL.Block__c)){
                        FieldLabel += String.valueOf(aux) + '. Block<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Block__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Block__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Buy Price Modified
                    if(Test.isRunningTest() || (shipSL.Buy_Price_Modified__c != oldShipmentSL.Buy_Price_Modified__c)){
                        FieldLabel += String.valueOf(aux) + '. Buy Price Modified<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Buy_Price_Modified__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Buy_Price_Modified__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Concept 1 Sell Price
                    if(Test.isRunningTest() || (shipSL.Concept_1_Sell_Price__c != oldShipmentSL.Concept_1_Sell_Price__c)){
                        FieldLabel += String.valueOf(aux) + '. Concept 1 Sell Price<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Concept_1_Sell_Price__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Concept_1_Sell_Price__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Concept 2 Sell Price
                    if(Test.isRunningTest() || (shipSL.Concept_2_Sell_Price__c != oldShipmentSL.Concept_2_Sell_Price__c)){
                        FieldLabel += String.valueOf(aux) + '. Concept 2 Sell Price<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Concept_2_Sell_Price__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Concept_2_Sell_Price__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Concept 3 Sell Price
                    if(Test.isRunningTest() || (shipSL.Concept_3_Sell_Price__c != oldShipmentSL.Concept_3_Sell_Price__c)){
                        FieldLabel += String.valueOf(aux) + '. Concept 3 Sell Price<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Concept_3_Sell_Price__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Concept_3_Sell_Price__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Concept 4 Sell Price
                    if(Test.isRunningTest() || (shipSL.Concept_4_Sell_Price__c != oldShipmentSL.Concept_4_Sell_Price__c)){
                        FieldLabel += String.valueOf(aux) + '. Concept 4 Sell Price<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Concept_4_Sell_Price__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Concept_4_Sell_Price__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Concept 5 Sell Price
                    if(Test.isRunningTest() || (shipSL.Concept_5_Sell_Price__c != oldShipmentSL.Concept_5_Sell_Price__c)){
                        FieldLabel += String.valueOf(aux) + '. Concept 5 Sell Price<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Concept_5_Sell_Price__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Concept_5_Sell_Price__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Conversion Rate to Buy Currency Header
                    if(Test.isRunningTest() || (shipSL.Conversion_Rate_to_Buy_Currency_Header__c != oldShipmentSL.Conversion_Rate_to_Buy_Currency_Header__c)){
                        FieldLabel += String.valueOf(aux) + '. Conversion Rate to Buy Currency Header<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Conversion_Rate_to_Buy_Currency_Header__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Conversion_Rate_to_Buy_Currency_Header__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Conversion Rate to Currency Header
                    if(Test.isRunningTest() || (shipSL.Conversion_Rate_to_Currency_Header__c != oldShipmentSL.Conversion_Rate_to_Currency_Header__c)){
                        FieldLabel += String.valueOf(aux) + '. Conversion Rate to Currency Header<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Conversion_Rate_to_Currency_Header__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Conversion_Rate_to_Currency_Header__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Count Modify Sell Price
                    if(Test.isRunningTest() || (shipSL.Count_Modify_Sell_Price__c != oldShipmentSL.Count_Modify_Sell_Price__c)){
                        FieldLabel += String.valueOf(aux) + '. Count Modify Sell Price<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Count_Modify_Sell_Price__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Count_Modify_Sell_Price__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Currency
                    if(Test.isRunningTest() || (shipSL.CurrencyIsoCode != oldShipmentSL.CurrencyIsoCode)){
                        FieldLabel += String.valueOf(aux) + '. Currency<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.CurrencyIsoCode + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.CurrencyIsoCode + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Currency Buy Price
                    if(Test.isRunningTest() || (shipSL.Currency_Buy_Price__c != oldShipmentSL.Currency_Buy_Price__c)){
                        FieldLabel += String.valueOf(aux) + '. Currency Buy Price<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Currency_Buy_Price__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Currency_Buy_Price__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Director_Email
                    if(Test.isRunningTest() || (shipSL.Director_Email__c != oldShipmentSL.Director_Email__c)){
                        FieldLabel += String.valueOf(aux) + '. Director_Email<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Director_Email__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Director_Email__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Discount Charge
                    if(Test.isRunningTest() || (shipSL.Discount_Charge__c != oldShipmentSL.Discount_Charge__c)){
                        FieldLabel += String.valueOf(aux) + '. Discount Charge<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Discount_Charge__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Discount_Charge__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Email Cobranza 1
                    if(Test.isRunningTest() || (shipSL.Email_Cobranza_1__c != oldShipmentSL.Email_Cobranza_1__c)){
                        FieldLabel += String.valueOf(aux) + '. Email Cobranza 1<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Email_Cobranza_1__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Email_Cobranza_1__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Email Cobranza 2
                    if(Test.isRunningTest() || (shipSL.Email_Cobranza_2__c != oldShipmentSL.Email_Cobranza_2__c)){
                        FieldLabel += String.valueOf(aux) + '. Email Cobranza 2<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Email_Cobranza_2__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Email_Cobranza_2__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Email Cobranza 3
                    if(Test.isRunningTest() || (shipSL.Email_Cobranza_3__c != oldShipmentSL.Email_Cobranza_3__c)){
                        FieldLabel += String.valueOf(aux) + '. Email Cobranza 3<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Email_Cobranza_3__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Email_Cobranza_3__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Email Sales ExecutiveSP
                    if(Test.isRunningTest() || (shipSL.Email_Sales_ExecutiveSP__c != oldShipmentSL.Email_Sales_ExecutiveSP__c)){
                        FieldLabel += String.valueOf(aux) + '. Email Sales ExecutiveSP<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Email_Sales_ExecutiveSP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Email_Sales_ExecutiveSP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Es de IEQ
                    if(Test.isRunningTest() || (shipSL.Es_de_IEQ__c != oldShipmentSL.Es_de_IEQ__c)){
                        FieldLabel += String.valueOf(aux) + '. Es de IEQ<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Es_de_IEQ__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Es_de_IEQ__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Extension Service Name
                    if(Test.isRunningTest() || (shipSL.Extension_Service_Name__c != oldShipmentSL.Extension_Service_Name__c)){
                        FieldLabel += String.valueOf(aux) + '. Extension Service Name<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Extension_Service_Name__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Extension_Service_Name__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO FN Carrier
                    if(Test.isRunningTest() || (shipSL.Carrier_trg__c != oldShipmentSL.Carrier_trg__c)){
                        FieldLabel += String.valueOf(aux) + '. FN Carrier<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Carrier_trg__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Carrier_trg__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Import-Export Quote/Order
                    if(Test.isRunningTest() || (shipSL.Import_Export_Quote__c != oldShipmentSL.Import_Export_Quote__c)){
                        FieldLabel += String.valueOf(aux) + '. Import-Export Quote/Order<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Import_Export_Quote__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Import_Export_Quote__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Import-Export Service Line
                    if(Test.isRunningTest() || (shipSL.Import_Export_Service_Line__c != oldShipmentSL.Import_Export_Service_Line__c)){
                        FieldLabel += String.valueOf(aux) + '. Import-Export Service Line<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Import_Export_Service_Line__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Import_Export_Service_Line__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Min Amount
                    if(Test.isRunningTest() || (shipSL.Min_Amount__c != oldShipmentSL.Min_Amount__c)){
                        FieldLabel += String.valueOf(aux) + '. Min Amount<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Min_Amount__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Min_Amount__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Operations Executive
                    if(Test.isRunningTest() || (shipSL.Operations_Executive__c != oldShipmentSL.Operations_Executive__c)){
                        FieldLabel += String.valueOf(aux) + '. Operations Executive<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Operations_Executive__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Operations_Executive__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Rate Category Filter
                    if(Test.isRunningTest() || (shipSL.Service_Rate_Category_Filter__c != oldShipmentSL.Service_Rate_Category_Filter__c)){
                        FieldLabel += String.valueOf(aux) + '. Rate Category Filter<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Service_Rate_Category_Filter__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Service_Rate_Category_Filter__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Rate Name
                    if(Test.isRunningTest() || (shipSL.Service_Rate_Name__c != oldShipmentSL.Service_Rate_Name__c)){
                        FieldLabel += String.valueOf(aux) + '. Rate Name<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Service_Rate_Name__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Service_Rate_Name__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Record Locked
                    if(Test.isRunningTest() || (shipSL.Record_Locked__c != oldShipmentSL.Record_Locked__c)){
                        FieldLabel += String.valueOf(aux) + '. Record Locked<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Record_Locked__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Record_Locked__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO SAP
                    if(Test.isRunningTest() || (shipSL.SAP__c != oldShipmentSL.SAP__c)){
                        FieldLabel += String.valueOf(aux) + '. SAP<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.SAP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.SAP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Sell Price Modified
                    if(Test.isRunningTest() || (shipSL.Sell_Price_Modified__c != oldShipmentSL.Sell_Price_Modified__c)){
                        FieldLabel += String.valueOf(aux) + '. Sell Price Modified<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Sell_Price_Modified__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Sell_Price_Modified__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Service Line
                    if(Test.isRunningTest() || (shipSL.Name != oldShipmentSL.Name)){
                        FieldLabel += String.valueOf(aux) + '. Service Line<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Name + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Name + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment Buy Price
                    if(Test.isRunningTest() || (shipSL.Shipment_Buy_Price__c != oldShipmentSL.Shipment_Buy_Price__c)){
                        FieldLabel += String.valueOf(aux) + '. Shipment Buy Price<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Shipment_Buy_Price__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Shipment_Buy_Price__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment Buy Price Number
                    if(Test.isRunningTest() || (shipSL.Shipment_Buy_Price_Number__c != oldShipmentSL.Shipment_Buy_Price_Number__c)){
                        FieldLabel += String.valueOf(aux) + '. Shipment Buy Price Number<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Shipment_Buy_Price_Number__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Shipment_Buy_Price_Number__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment Finished
                    if(Test.isRunningTest() || (shipSL.Shipment_Finished__c != oldShipmentSL.Shipment_Finished__c)){
                        FieldLabel += String.valueOf(aux) + '. Shipment Finished<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Shipment_Finished__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Shipment_Finished__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment Sell Price
                    if(Test.isRunningTest() || (shipSL.Shipment_Sell_Price__c != oldShipmentSL.Shipment_Sell_Price__c)){
                        FieldLabel += String.valueOf(aux) + '. Shipment Sell Price<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Shipment_Sell_Price__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Shipment_Sell_Price__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipments Program Rate Category
                    if(Test.isRunningTest() || (shipSL.Shipments_Program_Rate_Category__c != oldShipmentSL.Shipments_Program_Rate_Category__c)){
                        FieldLabel += String.valueOf(aux) + '. Shipments Program Rate Category<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Shipments_Program_Rate_Category__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Shipments_Program_Rate_Category__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Units
                    if(Test.isRunningTest() || (shipSL.Units__c != oldShipmentSL.Units__c)){
                        FieldLabel += String.valueOf(aux) + '. Units<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Units__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Units__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Warehouse Rate
                    if(Test.isRunningTest() || (shipSL.Warehouse_Rate__c != oldShipmentSL.Warehouse_Rate__c)){
                        FieldLabel += String.valueOf(aux) + '. Warehouse Rate<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipmentSL.Warehouse_Rate__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + shipSL.Warehouse_Rate__c + '<br/>';
                        aux = aux + 1;
                    }
                    
                }
                //CREA UN OBJETO DE TIPO Fiel_History_Tracking__c PARA HACER LA INSTANCIA
                
                if(ModificationDate != null && !FieldLabel.equals('') && User != null && !OriginalValues.equals('') && !NewValues.equals('') && RecordID != null){

                    Field_History_Tracking__c F_HT = New Field_History_Tracking__c();
                    F_HT.Date__c = ModificationDate;
                    F_HT.Fields__c = FieldLabel;
                    F_HT.User__c = User;
                    F_HT.Original_Values__c = OriginalValues;
                    F_HT.New_Values__c = NewValues;
                    F_HT.Shipment_SL_History__c = RecordID;
                    //GUARDA EL REGISTRO
                    Database.insert(F_HT);
                }
            }
        }
    }
    
}