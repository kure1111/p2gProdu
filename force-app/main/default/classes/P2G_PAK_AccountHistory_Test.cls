@isTest
public class P2G_PAK_AccountHistory_Test {    
    @isTest(SeeAllData=true)
    public static void updateAccountTest(){
        Account updatedAcc =[SELECT Id,Name,CurrencyIsoCode,OwnerId, 
                             RecordTypeId, AccountSource, Actcons_cta__c, 
                             Acta_Constitutiva_Poder_Rep_Legal__c, 
                             ActiveSap__c,Authorized_Credit__c,Brand_Name__c, 
                             Capacitacion_Acuses__c,Capacitacion_Control_Room__c,
                             Capacitacion_Operaciones__c,Capacitacion_Portal__c ,
                             Carban_cta__c,Check_test__c,Ciclo_de_Cobranza_Corto__c,
                             Cliente_con_cita__c,Cliente_internacional__c,Convfirm_cta__c,
                             Cuenta_con_instrumentos_de_movimiento_de__c,Cuenta_con_SUA_Sistema_nico_de_Autodet__c,
                             SCPCuenta_Espejo__c,Customer_Portal_Prospect__c,Encuesta_SCP__c,Enviado_SAP__c,
                             Enviar_encuesta__c,SeguimientoProspecto__c,Evidencia_de_Visita_del_Vendedor__c,
                             Factoraje_2__c,Factvig_cta__c,Folio_Mkt__c, Folio_Mkt_Ok2_del__c, Fotext_cta__c, 
                             Gps_cta__c, IDproveesap_cta__c, Inerep_cta__c, IVA_16__c, IVA_4__c, Key_Account__c, 
                             MC_CHECK__c, Negociacion_de_tarifas__c, Nombre_Prospect__c, Opinion_de_cumplimiento_ante_el_SAT__c, 
                             Order_to_Cash__c, Phone, Phone_test__c, Potencializacion__c, Proovedor_validado__c, Prospeccion__c, 
                             Prospeccion_Impak__c, Polseg_cta__c, Reasign_Dir__c, Reasign_Dir_SAP__c, Recuperado_SAP__c, Remote__c,
                             Requerimientos_especificos__c, Requiere_Orden_de_Compra__c, SCPRespons_contra_terceros__c, 
                             Rfcfis_cta__c, Specialist__c, Telefono_Validado__c, Test_upload__c, Uso_Portal__c, Venta_IMPAK__c,
                             SCPVetado__c, WebService__c, Venta_Sap__c, Tippag_cta__c, Customer_Id__c, TOTAL_IEQ__c 
                             FROM Account LIMIT 1];
        //Account oldAccount = testAccount.clone(true, true, true, true);
        Test.startTest();
        NEU_StaticVariableHelper.setBoolean1(true);
        System.debug('updatedAcc '+updatedAcc);
        updatedAcc.CurrencyIsoCode = 'USD';
        updatedAcc.Name = 'Nombre Actualizado';
        //updatedAcc.OwnerId = '005DV00000EDOsaYAH';
        //updatedAcc.RecordTypeId = '0124T000000Py67QAC'; 
        updatedAcc.AccountSource = 'Web';
        updatedAcc.Actcons_cta__c = true;
        updatedAcc.Acta_Constitutiva_Poder_Rep_Legal__c = true;
        updatedAcc.ActiveSap__c = true;
        updatedAcc.Authorized_Credit__c = true;
        updatedAcc.Brand_Name__c = 'Marca Principal';
        updatedAcc.Capacitacion_Acuses__c = true;
        updatedAcc.Capacitacion_Control_Room__c = true;
        updatedAcc.Capacitacion_Operaciones__c = true;
        updatedAcc.Capacitacion_Portal__c = true;
        updatedAcc.Carban_cta__c = true;
        updatedAcc.Check_test__c = true;
        updatedAcc.Ciclo_de_Cobranza_Corto__c = true;
        updatedAcc.Cliente_con_cita__c = true;
        updatedAcc.Cliente_internacional__c = true;
        updatedAcc.Convfirm_cta__c = true;
        updatedAcc.Cuenta_con_instrumentos_de_movimiento_de__c = true;
        updatedAcc.Cuenta_con_SUA_Sistema_nico_de_Autodet__c = true;
        updatedAcc.SCPCuenta_Espejo__c = true;
        updatedAcc.Customer_Portal_Prospect__c = true;
        updatedAcc.Encuesta_SCP__c = true;
        updatedAcc.Enviado_SAP__c = true;
        updatedAcc.Enviar_encuesta__c = true;
        updatedAcc.SeguimientoProspecto__c = 'En progreso';
        updatedAcc.Evidencia_de_Visita_del_Vendedor__c = true;
        updatedAcc.Factoraje_2__c = true;
        updatedAcc.Factvig_cta__c = true;
        updatedAcc.Folio_Mkt__c = 'MK' + System.now().format('yyyyMMdd');
        updatedAcc.Folio_Mkt_Ok2_del__c = 'MK' + System.now().format('yyyyMMdd');
        updatedAcc.Fotext_cta__c = true;
        updatedAcc.Gps_cta__c = true;
        updatedAcc.IDproveesap_cta__c = 'PROV' + System.now().format('yyyyMM');
        updatedAcc.Inerep_cta__c = true;
        updatedAcc.IVA_16__c = true;
        updatedAcc.IVA_4__c = false;
        updatedAcc.Key_Account__c = true;
        updatedAcc.MC_CHECK__c = true;
        updatedAcc.Negociacion_de_tarifas__c = true;
        updatedAcc.Nombre_Prospect__c = 'Prospecto Ejemplo';
        updatedAcc.Opinion_de_cumplimiento_ante_el_SAT__c = true;
        updatedAcc.Order_to_Cash__c = true;
        updatedAcc.Phone = '525555555555';
        updatedAcc.Phone_test__c = '5457876888';
        updatedAcc.Potencializacion__c = true;
        updatedAcc.Proovedor_validado__c = true;
        updatedAcc.Prospeccion__c = true;
        updatedAcc.Prospeccion_Impak__c = true;
        updatedAcc.Polseg_cta__c = true;
        updatedAcc.Reasign_Dir__c = true;
        updatedAcc.Reasign_Dir_SAP__c = true;
        updatedAcc.Recuperado_SAP__c = true;
        updatedAcc.Remote__c = true;
        updatedAcc.Requerimientos_especificos__c = true;
        updatedAcc.Requiere_Orden_de_Compra__c = true;
        updatedAcc.SCPRespons_contra_terceros__c = true;
        updatedAcc.Rfcfis_cta__c = true;
        updatedAcc.Specialist__c = true;
        updatedAcc.Telefono_Validado__c = true;
        updatedAcc.Test_upload__c = true;
        updatedAcc.Uso_Portal__c = true;
        updatedAcc.Venta_IMPAK__c = true;
        updatedAcc.SCPVetado__c = false;
        updatedAcc.WebService__c = true;
        updatedAcc.Venta_Sap__c = '';
        updatedAcc.Tippag_cta__c = 'Transferencia';
        updatedAcc.Customer_Id__c = 'CU'+ System.now().format('yyyyMMdd');
        //updatedAcc.TOTAL_IEQ__c = 100000;
        System.debug('updatedAcc '+updatedAcc);
        update updatedAcc;
        Test.stopTest();
    }  
}