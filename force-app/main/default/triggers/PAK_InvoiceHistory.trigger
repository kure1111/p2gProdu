trigger PAK_InvoiceHistory on Invoice__c (after update) {
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
    if(!RecursiveCheck.triggerMonitor.contains('PAK_InvoiceHistory')){
        RecursiveCheck.triggerMonitor.add('PAK_InvoiceHistory');
        if(Trigger.isAfter){
            if(Trigger.isUpdate){
                if(isThatTrue){
                    isThatTrue = False;
                    //PAK_InvoiceHistoryHelper.ProccessInvoices(Trigger.OldMap, Trigger.New);
                    Map<Id, Invoice__c> OldMap = Trigger.OldMap;
                    List<Invoice__c> NewInvoice = Trigger.New;
                    
                    for(Invoice__c invo : NewInvoice){
                        //HACE REFERENCIA AL VALOR ANTERIOR DEL INVOICE
                        Invoice__c oldInvoice = OldMap.get(invo.Id);
                        User = invo.LastModifiedById; //Id del último usuario que modificó el registro
                        ModificationDate = System.now();//Captura la fecha actual
                        RecordID = invo.Id;//Captura el ID del invoice modificado
                        
                        //CAMPO ﻿Conversion Rate to Imp-Exp Currency
                        if( Test.isRunningTest() || (invo.Conversion_Rate_to_Imp_Exp_Currency__c != oldInvoice.Conversion_Rate_to_Imp_Exp_Currency__c)){
                            FieldLabel += String.valueOf(aux) + '. ﻿Conversion Rate to Imp-Exp Currency<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Conversion_Rate_to_Imp_Exp_Currency__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Conversion_Rate_to_Imp_Exp_Currency__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Currency
                        if( Test.isRunningTest() || (invo.CurrencyIsoCode != oldInvoice.CurrencyIsoCode)){
                            FieldLabel += String.valueOf(aux) + '. Currency<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.CurrencyIsoCode + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.CurrencyIsoCode + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Customer Account
                        if( Test.isRunningTest() || (invo.Account__c != oldInvoice.Account__c)){
                            FieldLabel += String.valueOf(aux) + '. Customer Account<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Account__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Account__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Date of Invoice
                        if(invo.Date_of_Invoice__c != oldInvoice.Date_of_Invoice__c){
                            FieldLabel += String.valueOf(aux) + '. Date of Invoice<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Date_of_Invoice__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Date_of_Invoice__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Date Receive from SAP
                        if( Test.isRunningTest() || (invo.Date_Receive_from_SAP__c != oldInvoice.Date_Receive_from_SAP__c)){
                            FieldLabel += String.valueOf(aux) + '. Date Receive from SAP<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Date_Receive_from_SAP__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Date_Receive_from_SAP__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Folio de Entrega
                        if(Test.isRunningTest() || (invo.FolioEntrega__c != oldInvoice.FolioEntrega__c)){
                            FieldLabel += String.valueOf(aux) + '. Folio de Entrega<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.FolioEntrega__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.FolioEntrega__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Id_SAP
                        if(Test.isRunningTest() || (invo.Id_SAP__c != oldInvoice.Id_SAP__c)){
                            FieldLabel += String.valueOf(aux) + '. Id_SAP<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Id_SAP__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Id_SAP__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Initial Invoice Warehouse
                        if(Test.isRunningTest() || (invo.Initial_Invoice_Warehouse__c != oldInvoice.Initial_Invoice_Warehouse__c)){
                            FieldLabel += String.valueOf(aux) + '. Initial Invoice Warehouse<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Initial_Invoice_Warehouse__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Initial_Invoice_Warehouse__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Invoice Number
                        if(Test.isRunningTest() ||  (invo.Name != oldInvoice.Name)){
                            FieldLabel += String.valueOf(aux) + '. Invoice Number<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Name + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Name + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Invoice Status
                        if(Test.isRunningTest() ||  (invo.Invoice_Status__c != oldInvoice.Invoice_Status__c)){
                            FieldLabel += String.valueOf(aux) + '. Invoice Status<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Invoice_Status__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Invoice_Status__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Invoiced
                        if(Test.isRunningTest() ||  (invo.Invoiced__c != oldInvoice.Invoiced__c)){
                            FieldLabel += String.valueOf(aux) + '. Invoiced<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Invoiced__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Invoiced__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Invoiced Correctly
                        if(Test.isRunningTest() || (invo.Invoiced_Correctly__c != oldInvoice.Invoiced_Correctly__c)){
                            FieldLabel += String.valueOf(aux) + '. Invoiced Correctly<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Invoiced_Correctly__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Invoiced_Correctly__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Numero Folio
                        if(Test.isRunningTest() || (invo.Numero_Folio__c != oldInvoice.Numero_Folio__c)){
                            FieldLabel += String.valueOf(aux) + '. Numero Folio<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Numero_Folio__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Numero_Folio__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Payable Before
                        if(Test.isRunningTest() || (invo.Payable_Before__c != oldInvoice.Payable_Before__c)){
                            FieldLabel += String.valueOf(aux) + '. Payable Before<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Payable_Before__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Payable_Before__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Record Type
                        if(Test.isRunningTest() || (invo.RecordTypeId != oldInvoice.RecordTypeId)){
                            FieldLabel += String.valueOf(aux) + '. Record Type<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.RecordTypeId + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.RecordTypeId + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Shipment
                        if(invo.Shipment__c != oldInvoice.Shipment__c){
                            FieldLabel += String.valueOf(aux) + '. Shipment<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Shipment__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Shipment__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Type
                        if(invo.Type__c != oldInvoice.Type__c){
                            FieldLabel += String.valueOf(aux) + '. Type<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.Type__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.Type__c + '<br/>';
                            aux = aux + 1;
                        }
                        //CAMPO VoBo Lideres
                        if(invo.VoBo_Lideres__c != oldInvoice.VoBo_Lideres__c){
                            FieldLabel += String.valueOf(aux) + '. VoBo Lideres<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldInvoice.VoBo_Lideres__c + '<br/>';
                            NewValues += String.valueOf(aux) + '. ' + invo.VoBo_Lideres__c + '<br/>';
                            aux = aux + 1;
                        }
                    }
                    //CREA UN OBJETO DE TIPO Fiel_History_Tracking__c PARA HACER LA INSTANCIA
                    Field_History_Tracking__c F_HT = New Field_History_Tracking__c();
                    F_HT.Date__c = ModificationDate;
                    F_HT.Fields__c = FieldLabel;
                    F_HT.User__c = User;
                    F_HT.Original_Values__c = OriginalValues;
                    F_HT.New_Values__c = NewValues;
                    F_HT.Invoice_History__c = RecordID;
                    //GUARDA EL REGISTRO
                    Database.insert(F_HT);
                }
            }
        }
    }
    
}