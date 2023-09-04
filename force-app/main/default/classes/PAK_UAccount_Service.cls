global class PAK_UAccount_Service {
    
    webservice static list<status> UAccount(PAK_Update_ACC.UAccount[] lsEntity){
        list<status> result = new list<status>();
        //Log_WS_Account__c LOG = new Log_WS_Account__c();
        String CustomerId;
        try{
            System.debug('PAK_UAccount_Service IN');
            list<Account> Cuentas = new list<Account>();
            String CLIENTE = [Select Id From RecordType Where DeveloperName='Customer'].Id;
            String PROVEEDOR = [Select Id From RecordType Where DeveloperName='Transporter'].Id;
            System.debug('RT CLIENTE: ' + CLIENTE);
           
            for(PAK_Update_ACC.UAccount ACC: lsEntity){
                map<String, String> MapUser = new map<String,String>();
                
                for(User usr:[Select Id, SalesEmployer__c From User Where SalesEmployer__c=:ACC.SalesEmployer and IsActive = true]){
                    MapUser.put(usr.SalesEmployer__c, usr.Id);
                }
               
                Account cuenta = new Account();
                cuenta.Customer_id__c = ACC.Customer_id;
                cuenta.id = ACC.idSFField;
               
                //NUEVO, LIMITE DE CREDITO
                if(!string.isBlank(ACC.currencyIsoCode))
                    cuenta.CurrencyIsoCode = ACC.currencyIsoCode;
                
                if(ACC.Status_Account != '' && ACC.Status_Account != null){if(ACC.Status_Account == '1'){cuenta.ActiveSap__c = true;}else{cuenta.ActiveSap__c = false;}}
                if(ACC.UserNameSAP != '' && ACC.UserNameSAP != null){cuenta.User_SAP__c = ACC.UserNameSAP;}
                if(ACC.Name != '' && ACC.Name != null){cuenta.Name = ACC.Name;}
                if(ACC.Brand_Name != '' && ACC.Brand_Name != null){cuenta.Brand_Name__c = ACC.Brand_Name;}
                if(ACC.Tax_id != '' && ACC.Tax_id != null){cuenta.TAX_ID__c = ACC.Tax_id;}
                if(ACC.Phone != '' && ACC.Phone != null){cuenta.Phone = ACC.Phone;}
                if(ACC.Email != '' && ACC.Email != null){cuenta.NEU_Email__c = ACC.Email;}
                if(ACC.ReqOrdenCompra != '' && ACC.ReqOrdenCompra != null){if(ACC.ReqOrdenCompra == '1'){cuenta.Requiere_Orden_de_Compra__c = true;}else{cuenta.Requiere_Orden_de_Compra__c = false;}}                
                if(ACC.Tipo_de_pago != '' && ACC.Tipo_de_pago != null){cuenta.Tippag_cta__c = ACC.Tipo_de_pago;}
                if(ACC.Forma_de_pago != '' && ACC.Forma_de_pago != null){cuenta.Forpag_cta__c = ACC.Forma_de_pago;}
                if(ACC.Credits_terms !='' && ACC.Credits_terms != null){cuenta.Credit_Terms__c = ACC.Credits_terms;}
                if(ACC.Acuse !='' && ACC.Acuse != null){cuenta.Requiere_Acuse_Sap__c = ACC.Acuse;}
                if(ACC.Credit_Limit !='' && ACC.Credit_Limit != null){cuenta.Credit_Limit__c = Decimal.valueOf(ACC.Credit_Limit);}
                if(ACC.Direccion !='' && ACC.Direccion != null){cuenta.Address_in_Sap__c = ACC.Direccion;}
                if(ACC.SalesEmployer !='' && ACC.SalesEmployer != null && MapUser.containsKey(ACC.SalesEmployer)){cuenta.OwnerId = MapUser.get(ACC.SalesEmployer);}else{cuenta.OwnerId = '0054T000000ZZQ3';}
                
                if(ACC.Anticipo !='' && ACC.Anticipo != null){cuenta.Anticipo__c = ACC.Anticipo;}
                if(ACC.Authorized_credit !='' && ACC.Authorized_credit != null){if(ACC.Authorized_credit == '1'){cuenta.Authorized_Credit__c = true;}else{cuenta.Authorized_Credit__c =false;}}
                if(ACC.Tipo_Acuse !='' && ACC.Tipo_Acuse != null){cuenta.Tipo_de_Acuse_Sap__c = ACC.Tipo_Acuse;}
                if(ACC.Venta !='' && ACC.Venta != null){cuenta.Venta_Sap__c = ACC.Venta;}
                
                system.debug('Tipo de Registro : '+ ACC.RecordType);
                
                if(ACC.RecordType !='L'){
                    if(ACC.RecordType !='' && ACC.RecordType != null)
                    {
                        if(ACC.RecordType =='CLIENTE')
                        {
                            cuenta.RecordTypeId= CLIENTE;
                        }
                        else
                        {
                            cuenta.RecordTypeId= PROVEEDOR;
                        }
                    }
                }
                
                
                if(ACC.Source_Account != '' && ACC.Source_Account != null){cuenta.AccountSource = ACC.Source_Account;}
                cuenta.Motivo_InactivoSAP__c = ACC.MotivoInactivo != null ? ACC.MotivoInactivo : ''; 
                CustomerId = ACC.Customer_id;
                
                //Modificacion 29/03/2019
                if(ACC.CodigoPostal != null && ACC.CodigoPostal != ''){cuenta.BillingPostalCode = ACC.CodigoPostal;}
                if(ACC.Ciudad != null && ACC.Ciudad != ''){cuenta.BillingCity = ACC.Ciudad;}
                if(ACC.Estado != null && ACC.Estado != ''){cuenta.BillingState = ACC.Estado;}
                if(ACC.Pais != null && ACC.Pais != ''){cuenta.BillingCountry = ACC.Pais;}
                if(ACC.Street != null && ACC.Street != ''){cuenta.BillingStreet = ACC.Street;}
                
                
                // 11/04/2019 Proveedores 
                if(ACC.SolicitadoPor != null && ACC.SolicitadoPor != ''){cuenta.Solicitado_por__c = ACC.SolicitadoPor;}// Texto
                if(ACC.CarrierEmail != null && ACC.CarrierEmail  != ''){cuenta.Carrier_Email__c = ACC.CarrierEmail;}// Texto
                if(ACC.WorkPlace != null && ACC.WorkPlace != ''){cuenta.WorkPlace__c = ACC.WorkPlace;}// Texto
                if(ACC.Banco != null && ACC.Banco != ''){cuenta.Bank_Name_Supplier_Form__c = ACC.Banco;} //Texto
                if(ACC.Clabe != null && ACC.Clabe != ''){cuenta.Bank_Clabe__c = ACC.Clabe;} //Texto
                if(ACC.PaisBanco != null && ACC.PaisBanco != ''){cuenta.Bank_Address__c = ACC.PaisBanco;}// Texto
                if(ACC.BancoSup != null && ACC.BancoSup != ''){cuenta.Bank_Name_Supplier_Payment__c = ACC.BancoSup;} // Texto
                if(ACC.CuentaBanco != null && ACC.CuentaBanco != ''){cuenta.Bank_Account_Number__c = ACC.CuentaBanco;}// Texto
                if(ACC.Comentarios != null && ACC.Comentarios != ''){cuenta.Obsycom_cta__c = ACC.Comentarios;}// Texto
                if(ACC.Unidades != null && ACC.Unidades != ''){cuenta.Unidades__c = ACC.Unidades;}// Multipicklist
                if(ACC.GrupoSap != null && ACC.GrupoSap != ''){cuenta.Grupo_SAP__c = ACC.GrupoSap;} // Text
                if(ACC.CuentaEspejo != null && ACC.CuentaEspejo != ''){if(ACC.CuentaEspejo == '1'){cuenta.SCPCuenta_Espejo__c = true;}else{cuenta.SCPCuenta_Espejo__c = false;}} // 1 - True / 2 - False
                if(ACC.Gps != null && ACC.Gps != ''){if(ACC.Gps == '1'){cuenta.Gps_cta__c = true;}else{cuenta.Gps_cta__c = false;}}// 1 - True / 2 - False
                if(ACC.Vetado != null && ACC.Vetado != ''){if(ACC.Vetado == '1'){cuenta.SCPVetado__c = true;}else{cuenta.SCPVetado__c = false;}}// 1 - True / 2 - False
                if(ACC.ReportaVetado != null && ACC.ReportaVetado != ''){cuenta.Reporta_Vetado__c = ACC.ReportaVetado;}// Texto
                if(ACC.Estatus != null){cuenta.Estatus_de_Alta__c = ACC.Estatus;}
                System.debug('ACCT: ' + cuenta);
                
                Cuentas.add(cuenta);
                status st = new status();
                st.code = '1';
                st.message = 'Exitoso- el registro fue actualizado';
                st.registry = ACC;
                result.add(st);
                
                /*LOG.Account_Id__c = ACC.Customer_id;
                LOG.Status_Account__c = ACC.Status_Account;
                LOG.Acuse__c = ACC.Acuse;
                LOG.Anticipo__c = ACC.Anticipo;
                LOG.Authorized_credit__c = ACC.Authorized_credit;
                LOG.Brand_Name__c = ACC.Brand_Name;
                LOG.Credit_Limit__c = ACC.Credit_Limit;
                LOG.Credits_terms__c = ACC.Credits_terms;
                LOG.Forma_de_pago__c = ACC.Forma_de_pago;
                LOG.Name_Account__c = ACC.Name;
                LOG.Phone__c = ACC.Phone;
                LOG.RecordType__c = ACC.RecordType;
                LOG.SalesEmployer__c = ACC.SalesEmployer;
                LOG.Tax_id__c = ACC.Tax_id;
                LOG.Tipo_Acuse__c = ACC.Tipo_Acuse;
                LOG.Tipo_de_pago__c = ACC.Tipo_de_pago;
                LOG.Venta__c = ACC.Venta;
                LOG.Log__c = String.valueOf(ACC);
                LOG.Source_Account__c = ACC.Source_Account;
                LOG.Direccion__c = ACC.Direccion;*/
                
                System.debug('----------'+result);  
            }
            
            upsert Cuentas Customer_Id__c;
        	return result;   
        }catch(Exception e){
            System.debug(e.getCause()); System.debug(e.getMessage()); System.debug(e.getLineNumber());
			status st = new status(); st.code = '0'; st.message = 'Existe un error en el web services Cliente('+CustomerId+'), por favor revise la trasabilidad de la transacción' + e.getCause() +' '+ e.getMessage() +' '+ e.getLineNumber();				
			result.add(st);
            //LOG.Error__c = e.getCause() +' '+ e.getMessage() +' '+ e.getLineNumber();
            //insert LOG;
            
			return result;
        }
        
    }
    global class status {
        webservice String code {get; set;}
        webservice String message {get; set;}
        webservice PAK_Update_ACC.UAccount registry {get; set;}
    }
}