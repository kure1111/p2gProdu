trigger PAK_AccountHistory on Account (after insert,after update) {        
    //VARIABLES PARA EL METODO FieldHistoryTracking
    String FieldLabel = '';
    String OriginalValues = '';
    String NewValues = '';
    String TotalIEQ_Approved = '';
    String Estatus_de_cliente = '';
    DateTime ModificationDate;
    Id User;
    Id RecordID;
    Integer aux=1;
    
    if(!RecursiveCheck.triggerMonitor.contains('PAK_AccountHistory')){
     	RecursiveCheck.triggerMonitor.add('PAK_AccountHistory');
        if(Trigger.isAfter){
            if(Trigger.isInsert){
            List<Account> NewAcc = Trigger.New;
                for(Account Acc:NewAcc){
                    User = Acc.CreatedById;
                    RecordID = Acc.Id;
                }
                
            Field_History_Tracking__c F_HT = New Field_History_Tracking__c();
            F_HT.Fields__c='Nuevo Registro'; 
            F_HT.Original_Values__c = 'False';
            F_HT.New_Values__c = 'True';
            F_HT.Date__c = System.now();
            F_HT.User__c = User;
            F_HT.Account_History__c = RecordID;
            Database.insert(F_HT);               
                                
            }
            if(Trigger.isUpdate){
                 //PAK_HistoryAccountHelper.ProccessAccounts(Trigger.OldMap, Trigger.New);
                    Map<Id,Account> OldMap = Trigger.OldMap;
                    List<Account> NewAcc = Trigger.New;
                    for(Account acc : NewAcc){
                        
                        //HACE REFERENCIA AL VALOR ANTERIOR DE LA CUENTA
                        Account oldAccount = OldMap.get(acc.Id);
                        User = acc.LastModifiedById; //Id del último usuario que modificó el registro
                        ModificationDate = System.now();//Captura la fecha actual
                        RecordID = acc.Id;//Captura el ID de la cuenta modificada
                        
                        //CAMPO Account Currency
                        if(acc.CurrencyIsoCode != oldAccount.CurrencyIsoCode){
                            FieldLabel += String.valueOf(aux) + '. ﻿Account Currency <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.CurrencyIsoCode + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.CurrencyIsoCode + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Account Name
                        if(acc.Name != oldAccount.Name){
                            FieldLabel += String.valueOf(aux) + '. Account Name <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Name + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Name + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Account Owner
                        if(acc.OwnerId != oldAccount.OwnerId){
                            FieldLabel += String.valueOf(aux) + '. Account Owner <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.OwnerId + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.OwnerId + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Account Record Type
                        if(acc.RecordTypeId != oldAccount.RecordTypeId){
                            FieldLabel += String.valueOf(aux) + '. Account Record Type <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.RecordTypeId + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.RecordTypeId + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Account Source
                        if(acc.AccountSource != oldAccount.AccountSource){
                            FieldLabel += String.valueOf(aux) + '. Account Source <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.AccountSource + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.AccountSource + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Acta constitutiva
                        if(acc.Actcons_cta__c != oldAccount.Actcons_cta__c){
                            FieldLabel += String.valueOf(aux) + '. Acta constitutiva <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Actcons_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Actcons_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Acta Constitutiva/Poder Rep Legal
                        if(acc.Acta_Constitutiva_Poder_Rep_Legal__c != oldAccount.Acta_Constitutiva_Poder_Rep_Legal__c){
                            FieldLabel += String.valueOf(aux) + '. Acta Constitutiva/Poder Rep Legal <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Acta_Constitutiva_Poder_Rep_Legal__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Acta_Constitutiva_Poder_Rep_Legal__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Active
                        if(acc.ActiveSap__c != oldAccount.ActiveSap__c){
                            FieldLabel += String.valueOf(aux) + '. Active <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.ActiveSap__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.ActiveSap__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Authorized Credit
                        if(acc.Authorized_Credit__c != oldAccount.Authorized_Credit__c){
                            FieldLabel += String.valueOf(aux) + '. Authorized Credit <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Authorized_Credit__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Authorized_Credit__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Brand Name
                        if(acc.Brand_Name__c != oldAccount.Brand_Name__c){
                            FieldLabel += String.valueOf(aux) + '. Brand Name <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Brand_Name__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Brand_Name__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Capacitación Acuses
                        if(acc.Capacitacion_Acuses__c != oldAccount.Capacitacion_Acuses__c){
                            FieldLabel += String.valueOf(aux) + '. Capacitación Acuses <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Capacitacion_Acuses__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Capacitacion_Acuses__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Capacitación Control Room
                        if(acc.Capacitacion_Control_Room__c != oldAccount.Capacitacion_Control_Room__c){
                            FieldLabel += String.valueOf(aux) + '. Capacitación Control Room <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Capacitacion_Control_Room__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Capacitacion_Control_Room__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Capacitación Operaciones
                        if(acc.Capacitacion_Operaciones__c != oldAccount.Capacitacion_Operaciones__c){
                            FieldLabel += String.valueOf(aux) + '. Capacitación Operaciones <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Capacitacion_Operaciones__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Capacitacion_Operaciones__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Capacitación Portal
                        if(acc.Capacitacion_Portal__c != oldAccount.Capacitacion_Portal__c){
                            FieldLabel += String.valueOf(aux) + '. Capacitación Portal <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Capacitacion_Portal__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Capacitacion_Portal__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Caratula banco con CLABE interbancaria
                        if(acc.Carban_cta__c != oldAccount.Carban_cta__c){
                            FieldLabel += String.valueOf(aux) + '. Caratula banco con CLABE interbancaria <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Carban_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Carban_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Check test
                        if(acc.Check_test__c != oldAccount.Check_test__c){
                            FieldLabel += String.valueOf(aux) + '. Check test <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Check_test__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Check_test__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Ciclo de Cobranza Corto
                        if(acc.Ciclo_de_Cobranza_Corto__c != oldAccount.Ciclo_de_Cobranza_Corto__c){
                            FieldLabel += String.valueOf(aux) + '. Ciclo de Cobranza Corto <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Ciclo_de_Cobranza_Corto__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Ciclo_de_Cobranza_Corto__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Cliente con cita
                        if(acc.Cliente_con_cita__c != oldAccount.Cliente_con_cita__c){
                            FieldLabel += String.valueOf(aux) + '. Cliente con cita <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Cliente_con_cita__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Cliente_con_cita__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Cliente internacional
                        if(acc.Cliente_internacional__c != oldAccount.Cliente_internacional__c){
                            FieldLabel += String.valueOf(aux) + '. Cliente internacional <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Cliente_internacional__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Cliente_internacional__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Comprobante de Domicilio
                        if(acc.Comdom_cta__c != oldAccount.Comdom_cta__c){
                            FieldLabel += String.valueOf(aux) + '. Comprobante de Domicilio <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Comdom_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Comdom_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Convenio firmado Pak2go y proveedor
                        if(acc.Convfirm_cta__c != oldAccount.Convfirm_cta__c){
                            FieldLabel += String.valueOf(aux) + '. Convenio firmado Pak2go y proveedor <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Convfirm_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Convfirm_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO CT-Pat
                        if(acc.CT_Pat__c != oldAccount.CT_Pat__c){
                            FieldLabel += String.valueOf(aux) + '. CT-Pat <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.CT_Pat__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.CT_Pat__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Cuenta con instrumentos de movimiento de
                        if(acc.Cuenta_con_instrumentos_de_movimiento_de__c != oldAccount.Cuenta_con_instrumentos_de_movimiento_de__c){
                            FieldLabel += String.valueOf(aux) + '. Cuenta con instrumentos de movimiento de <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Cuenta_con_instrumentos_de_movimiento_de__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Cuenta_con_instrumentos_de_movimiento_de__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Cuenta con SUA (Sistema Único de Autodet
                        if(acc.Cuenta_con_SUA_Sistema_nico_de_Autodet__c != oldAccount.Cuenta_con_SUA_Sistema_nico_de_Autodet__c){
                            FieldLabel += String.valueOf(aux) + '. Cuenta con SUA (Sistema Único de Autodet <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Cuenta_con_SUA_Sistema_nico_de_Autodet__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Cuenta_con_SUA_Sistema_nico_de_Autodet__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Cuenta Espejo
                        if(acc.SCPCuenta_Espejo__c != oldAccount.SCPCuenta_Espejo__c){
                            FieldLabel += String.valueOf(aux) + '. Cuenta Espejo <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.SCPCuenta_Espejo__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.SCPCuenta_Espejo__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Customer Portal Account
                        if(acc.Customer_Portal_Prospect__c != oldAccount.Customer_Portal_Prospect__c){
                            FieldLabel += String.valueOf(aux) + '. Customer Portal Account <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Customer_Portal_Prospect__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Customer_Portal_Prospect__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Encuesta SCP
                        if(acc.Encuesta_SCP__c != oldAccount.Encuesta_SCP__c){
                            FieldLabel += String.valueOf(aux) + '. Encuesta SCP <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Encuesta_SCP__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Encuesta_SCP__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Enviado SAP
                        if(acc.Enviado_SAP__c != oldAccount.Enviado_SAP__c){
                            FieldLabel += String.valueOf(aux) + '. Enviado SAP <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Enviado_SAP__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Enviado_SAP__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Enviar encuesta
                        if(acc.Enviar_encuesta__c != oldAccount.Enviar_encuesta__c){
                            FieldLabel += String.valueOf(aux) + '. Enviar encuesta <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Enviar_encuesta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Enviar_encuesta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Estatus de cliente
                        if(acc.Estatus_de_cliente__c != oldAccount.Estatus_de_cliente__c){
                            FieldLabel += String.valueOf(aux) + '. Estatus de cliente <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Estatus_de_cliente__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Estatus_de_cliente__c + ' <br/>';
                            Estatus_de_cliente = String.valueOf(acc.Estatus_de_cliente__c);
                            aux = aux + 1;
                        }
                        //CAMPO Evidencia de Visita del Vendedor
                        if(acc.Evidencia_de_Visita_del_Vendedor__c != oldAccount.Evidencia_de_Visita_del_Vendedor__c){
                            FieldLabel += String.valueOf(aux) + '. Evidencia de Visita del Vendedor <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Evidencia_de_Visita_del_Vendedor__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Evidencia_de_Visita_del_Vendedor__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Factoraje
                        if(acc.Factoraje_2__c != oldAccount.Factoraje_2__c){
                            FieldLabel += String.valueOf(aux) + '. Factoraje <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Factoraje_2__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Factoraje_2__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Factura vigente, reciente cancelada
                        if(acc.Factvig_cta__c != oldAccount.Factvig_cta__c){
                            FieldLabel += String.valueOf(aux) + '. Factura vigente, reciente cancelada <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Factvig_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Factvig_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Folio Mkt
                        if(acc.Folio_Mkt__c != oldAccount.Folio_Mkt__c){
                            FieldLabel += String.valueOf(aux) + '. Folio Mkt <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Folio_Mkt__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Folio_Mkt__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Folio MKT
                        if(acc.Folio_Mkt_Ok2_del__c != oldAccount.Folio_Mkt_Ok2_del__c){
                            FieldLabel += String.valueOf(aux) + '. Folio MKT <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Folio_Mkt_Ok2_del__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Folio_Mkt_Ok2_del__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Formato lleno alta de proveedores
                        if(acc.Formalt_cta__c != oldAccount.Formalt_cta__c){
                            FieldLabel += String.valueOf(aux) + '. Formato lleno alta de proveedores <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Formalt_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Formalt_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Foto exterior del Negocio
                        if(acc.Fotext_cta__c != oldAccount.Fotext_cta__c){
                            FieldLabel += String.valueOf(aux) + '. Foto exterior del Negocio <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Fotext_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Fotext_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO GPS
                        if(acc.Gps_cta__c != oldAccount.Gps_cta__c){
                            FieldLabel += String.valueOf(aux) + '. GPS <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Gps_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Gps_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO ID Proveedor SAP
                        if(acc.IDproveesap_cta__c != oldAccount.IDproveesap_cta__c){
                            FieldLabel += String.valueOf(aux) + '. ID Proveedor SAP <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.IDproveesap_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.IDproveesap_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO INE representante legal o dueño
                        if(acc.Inerep_cta__c != oldAccount.Inerep_cta__c){
                            FieldLabel += String.valueOf(aux) + '. INE representante legal o dueño <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Inerep_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Inerep_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO IVA 16%
                        if(acc.IVA_16__c != oldAccount.IVA_16__c){
                            FieldLabel += String.valueOf(aux) + '. IVA 16% <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.IVA_16__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.IVA_16__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO IVA 4%
                        if(acc.IVA_4__c != oldAccount.IVA_4__c){
                            FieldLabel += String.valueOf(aux) + '. IVA 4% <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.IVA_4__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.IVA_4__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Key Account
                        if(acc.Key_Account__c != oldAccount.Key_Account__c){
                            FieldLabel += String.valueOf(aux) + '. Key Account <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Key_Account__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Key_Account__c + ' <br/>';
                            aux = aux + 1;
                        }/*
                        //CAMPO Last Modified By
                        if(acc.LastModifiedById != oldAccount.LastModifiedById){
                            FieldLabel += String.valueOf(aux) + '. Last Modified By<br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.LastModifiedById + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.LastModifiedById + ' <br/>';
                            aux = aux + 1;
                        }*/
                        //CAMPO MC#
                        if(acc.MC_CHECK__c != oldAccount.MC_CHECK__c){
                            FieldLabel += String.valueOf(aux) + '. MC# <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.MC_CHECK__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.MC_CHECK__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Negociacion de tarifas
                        if(acc.Negociacion_de_tarifas__c != oldAccount.Negociacion_de_tarifas__c){
                            FieldLabel += String.valueOf(aux) + '. Negociacion de tarifas <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Negociacion_de_tarifas__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Negociacion_de_tarifas__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Nombre (Prospect)
                        if(acc.Nombre_Prospect__c != oldAccount.Nombre_Prospect__c){
                            FieldLabel += String.valueOf(aux) + '. Nombre (Prospect) <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Nombre_Prospect__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Nombre_Prospect__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Opinion de cumplimiento ante el SAT
                        if(acc.Opinion_de_cumplimiento_ante_el_SAT__c != oldAccount.Opinion_de_cumplimiento_ante_el_SAT__c){
                            FieldLabel += String.valueOf(aux) + '. Opinion de cumplimiento ante el SAT <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Opinion_de_cumplimiento_ante_el_SAT__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Opinion_de_cumplimiento_ante_el_SAT__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Order to Cash
                        if(acc.Order_to_Cash__c != oldAccount.Order_to_Cash__c){
                            FieldLabel += String.valueOf(aux) + '. Order to Cash <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Order_to_Cash__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Order_to_Cash__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Phone
                        if(acc.Phone != oldAccount.Phone){
                            FieldLabel += String.valueOf(aux) + '. Phone <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Phone + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Phone + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Phone test
                        if(acc.Phone_test__c != oldAccount.Phone_test__c){
                            FieldLabel += String.valueOf(aux) + '. Phone test <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Phone_test__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Phone_test__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Potencializacion
                        if(acc.Potencializacion__c != oldAccount.Potencializacion__c){
                            FieldLabel += String.valueOf(aux) + '. Potencializacion <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Potencializacion__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Potencializacion__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Proovedor validado
                        if(acc.Proovedor_validado__c != oldAccount.Proovedor_validado__c){
                            FieldLabel += String.valueOf(aux) + '. Proovedor validado <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Proovedor_validado__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Proovedor_validado__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Prospeccion
                        if(acc.Prospeccion__c != oldAccount.Prospeccion__c){
                            FieldLabel += String.valueOf(aux) + '. Prospeccion <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Prospeccion__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Prospeccion__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Prospeccion  Impak
                        if(acc.Prospeccion_Impak__c != oldAccount.Prospeccion_Impak__c){
                            FieldLabel += String.valueOf(aux) + '. Prospeccion  Impak <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Prospeccion_Impak__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Prospeccion_Impak__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Póliza de seguro de transporte vigente
                        if(acc.Polseg_cta__c != oldAccount.Polseg_cta__c){
                            FieldLabel += String.valueOf(aux) + '. Póliza de seguro de transporte vigente <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Polseg_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Polseg_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Reasignado Direccion
                        if(acc.Reasign_Dir__c != oldAccount.Reasign_Dir__c){
                            FieldLabel += String.valueOf(aux) + '. Reasignado Direccion <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Reasign_Dir__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Reasign_Dir__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Reasignado Direccion SAP
                        if(acc.Reasign_Dir_SAP__c != oldAccount.Reasign_Dir_SAP__c){
                            FieldLabel += String.valueOf(aux) + '. Reasignado Direccion SAP <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Reasign_Dir_SAP__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Reasign_Dir_SAP__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Recuperado
                        if(acc.Recuperado__c != oldAccount.Recuperado__c){
                            FieldLabel += String.valueOf(aux) + '. Recuperado <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Recuperado__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Recuperado__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Recuperado SAP
                        if(acc.Recuperado_SAP__c != oldAccount.Recuperado_SAP__c){
                            FieldLabel += String.valueOf(aux) + '. Recuperado SAP <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Recuperado_SAP__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Recuperado_SAP__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Remote
                        if(acc.Remote__c != oldAccount.Remote__c){
                            FieldLabel += String.valueOf(aux) + '. Remote <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Remote__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Remote__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Requerimientos especificos
                        if(acc.Requerimientos_especificos__c != oldAccount.Requerimientos_especificos__c){
                            FieldLabel += String.valueOf(aux) + '. Requerimientos especificos <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Requerimientos_especificos__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Requerimientos_especificos__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Requiere Orden de Compra
                        if(acc.Requiere_Orden_de_Compra__c != oldAccount.Requiere_Orden_de_Compra__c){
                            FieldLabel += String.valueOf(aux) + '. Requiere Orden de Compra <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Requiere_Orden_de_Compra__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Requiere_Orden_de_Compra__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Responsabilidad contra terceros
                        if(acc.SCPRespons_contra_terceros__c != oldAccount.SCPRespons_contra_terceros__c){
                            FieldLabel += String.valueOf(aux) + '. Responsabilidad contra terceros <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.SCPRespons_contra_terceros__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.SCPRespons_contra_terceros__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO RFC
                        if(acc.Rfcfis_cta__c != oldAccount.Rfcfis_cta__c){
                            FieldLabel += String.valueOf(aux) + '. RFC <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Rfcfis_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Rfcfis_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Specialist
                        if(acc.Specialist__c != oldAccount.Specialist__c){
                            FieldLabel += String.valueOf(aux) + '. Specialist <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Specialist__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Specialist__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Telefono Validado
                        if(acc.Telefono_Validado__c != oldAccount.Telefono_Validado__c){
                            FieldLabel += String.valueOf(aux) + '. Telefono Validado <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Telefono_Validado__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Telefono_Validado__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Test upload
                        if(acc.Test_upload__c != oldAccount.Test_upload__c){
                            FieldLabel += String.valueOf(aux) + '. Test upload <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Test_upload__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Test_upload__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Uso Portal
                        if(acc.Uso_Portal__c != oldAccount.Uso_Portal__c){
                            FieldLabel += String.valueOf(aux) + '. Uso Portal <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Uso_Portal__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Uso_Portal__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Venta IMPAK
                        if(acc.Venta_IMPAK__c != oldAccount.Venta_IMPAK__c){
                            FieldLabel += String.valueOf(aux) + '. Venta IMPAK <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Venta_IMPAK__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Venta_IMPAK__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Vetado
                        if(acc.SCPVetado__c != oldAccount.SCPVetado__c){
                            FieldLabel += String.valueOf(aux) + '. Vetado <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.SCPVetado__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.SCPVetado__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO WebService
                        if(acc.WebService__c != oldAccount.WebService__c){
                            FieldLabel += String.valueOf(aux) + '. WebService <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.WebService__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.WebService__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Venta
                        if(acc.Venta_Sap__c != oldAccount.Venta_Sap__c){
                            FieldLabel += String.valueOf(aux) + '. Venta <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Venta_Sap__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Venta_Sap__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Tipo de Pago
                        if(acc.Tippag_cta__c != oldAccount.Tippag_cta__c){
                            FieldLabel += String.valueOf(aux) + '. Tipo de Pago <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Tippag_cta__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Tippag_cta__c + ' <br/>';
                            aux = aux + 1;
                        }
                        //CAMPO Customer Id
                        if(acc.Customer_Id__c != oldAccount.Customer_Id__c){
                            FieldLabel += String.valueOf(aux) + '. Customer Id <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.Customer_Id__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.Customer_Id__c + ' <br/>';
                            aux = aux + 1;
                        }
                        
                         //CAMPO TOTAL IEQ Approved 
                        if(acc.TOTAL_IEQ__c != oldAccount.TOTAL_IEQ__c){
                            FieldLabel += String.valueOf(aux) + '. TOTAL IEQ Approved <br/>';
                            OriginalValues += String.valueOf(aux) + '. ' + oldAccount.TOTAL_IEQ__c + ' <br/>';
                            NewValues += String.valueOf(aux) + '. ' + acc.TOTAL_IEQ__c + ' <br/>';
                            TotalIEQ_Approved = String.valueOf(acc.TOTAL_IEQ__c);
                            aux = aux + 1;
                        }
                        
                        
                    }
                    //CREA UNA INSTANCIA DE TIPO Fiel_History_Tracking__c PARA HACER EL REGISTRO
                    
                    if(ModificationDate != null && !FieldLabel.equals('') && User != null && !OriginalValues.equals('') && !NewValues.equals('') && RecordID != null){
    
                        Field_History_Tracking__c F_HT = New Field_History_Tracking__c();
                        F_HT.Date__c = ModificationDate;
                        F_HT.Fields__c = FieldLabel;
                        F_HT.User__c = User;
                        F_HT.Original_Values__c = OriginalValues;
                        F_HT.New_Values__c = NewValues;
                        F_HT.Field_Tracking_Total_IEQ_Approved__c = TotalIEQ_Approved;
                        F_HT.Field_Tracking_Estatus_de_cliente__c = Estatus_de_cliente;
                        F_HT.Account_History__c = RecordID;
                        //GUARDA EL REGISTRO
                        Database.insert(F_HT);
                    }               
            }
        }
    }    
    
}