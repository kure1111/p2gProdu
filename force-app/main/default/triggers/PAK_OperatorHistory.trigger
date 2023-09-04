trigger PAK_OperatorHistory on Operadores__c (after update) {
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
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            if(isThatTrue){
                isThatTrue = False;
                //PAK_OperatorHistoryHelper.ProcessOperator(Trigger.OldMap, Trigger.New);
                Map<Id, Operadores__c> OldMap = Trigger.OldMap;
                List<Operadores__c> NewOper = Trigger.New;
                for(Operadores__c oper : NewOper){
                    
                    //HACE REFERENCIA AL VALOR ANTERIOR DEL OPERADOR
                    Operadores__c oldOperator = OldMap.get(oper.Id);
                    User = oper.LastModifiedById; //Id del último usuario que modificó el registro
                    ModificationDate = System.now();//Captura la fecha actual
                    RecordID = oper.Id;//Captura el ID del operador modificada
                    
                    //CAMPO ﻿Apto
                    if(oper.Apto_ope__c != oldOperator.Apto_ope__c){
                        FieldLabel += String.valueOf(aux) + '. ﻿Apto<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Apto_ope__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Apto_ope__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Celular
                    if(oper.Cel_ope__c != oldOperator.Cel_ope__c){
                        FieldLabel += String.valueOf(aux) + '. Celular<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Cel_ope__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Cel_ope__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Currency
                    if(oper.CurrencyIsoCode != oldOperator.CurrencyIsoCode){
                        FieldLabel += String.valueOf(aux) + '. Currency<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.CurrencyIsoCode + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.CurrencyIsoCode + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Fecha Validado
                    if(oper.Fecha_Validado__c != oldOperator.Fecha_Validado__c){
                        FieldLabel += String.valueOf(aux) + '. Fecha Validado<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Fecha_Validado__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Fecha_Validado__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Med Preventiva
                    if(oper.Medprev_ope__c != oldOperator.Medprev_ope__c){
                        FieldLabel += String.valueOf(aux) + '. Med Preventiva<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Medprev_ope__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Medprev_ope__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Med Preventiva Vigente
                    if(oper.Medprevvig_ope__c != oldOperator.Medprevvig_ope__c){
                        FieldLabel += String.valueOf(aux) + '. Med Preventiva Vigente<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Medprevvig_ope__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Medprevvig_ope__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Nombre Operador
                    if(oper.Name != oldOperator.Name){
                        FieldLabel += String.valueOf(aux) + '. Nombre Operador<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Name + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Name + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Num. Licencia Vigente
                    if(oper.Numlicvig_ope__c != oldOperator.Numlicvig_ope__c){
                        FieldLabel += String.valueOf(aux) + '. Num. Licencia Vigente<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Numlicvig_ope__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Numlicvig_ope__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Operador Validado
                    if(oper.Operador_Validado__c != oldOperator.Operador_Validado__c){
                        FieldLabel += String.valueOf(aux) + '. Operador Validado<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Operador_Validado__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Operador_Validado__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Proovedor validado
                    if(oper.Proovedor_validado__c != oldOperator.Proovedor_validado__c){
                        FieldLabel += String.valueOf(aux) + '. Proovedor validado<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Proovedor_validado__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Proovedor_validado__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Tarjeta de Circulación
                    if(oper.Tarcir_ope__c != oldOperator.Tarcir_ope__c){
                        FieldLabel += String.valueOf(aux) + '. Tarjeta de Circulación<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Tarcir_ope__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Tarcir_ope__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Teléfono fijo
                    if(oper.Telfij_ope__c != oldOperator.Telfij_ope__c){
                        FieldLabel += String.valueOf(aux) + '. Teléfono fijo<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Telfij_ope__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Telfij_ope__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Validado
                    if(oper.Validado__c != oldOperator.Validado__c){
                        FieldLabel += String.valueOf(aux) + '. Validado<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Validado__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Validado__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Validate Pak Control
                    if(oper.Validate_Pak_Control__c != oldOperator.Validate_Pak_Control__c){
                        FieldLabel += String.valueOf(aux) + '. Validate Pak Control<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOperator.Validate_Pak_Control__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + oper.Validate_Pak_Control__c + '<br/>';
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
                F_HT.Operator_History__c = RecordID;
                //GUARDA EL REGISTRO
                Database.insert(F_HT);
            }
        }
    }
    
}