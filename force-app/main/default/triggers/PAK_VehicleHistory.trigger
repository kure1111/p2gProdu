trigger PAK_VehicleHistory on Vehicle__c (after update) {
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
                //PAK_VehicleHistoryHelper.ProccessVehicles(Trigger.OldMap, Trigger.New);
                Map<Id,Vehicle__c> OldMap = Trigger.OldMap;
                List<Vehicle__c> NewVehicle = Trigger.New;
                
                for(Vehicle__c unidad : NewVehicle){
                    //HACE REFERENCIA AL VALOR ANTERIOR DE LA CUENTA
                    Vehicle__c oldVehicle = OldMap.get(unidad.Id);
                    User = unidad.LastModifiedById; //Id del último usuario que modificó el registro
                    ModificationDate = System.now();//Captura la fecha actual
                    RecordID = unidad.Id;//Captura el ID de la cuenta modificada
                    
                    //CAMPO ﻿Account for (SCP)
                    if(unidad.Account_for_SCP__c != oldVehicle.Account_for_SCP__c){
                        FieldLabel += String.valueOf(aux) + '. ﻿Account for (SCP)<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.Account_for_SCP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.Account_for_SCP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Año
                    if(unidad.Ano__c != oldVehicle.Ano__c){
                        FieldLabel += String.valueOf(aux) + '. Año<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.Ano__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.Ano__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Color
                    if(unidad.Color_Tracto__c != oldVehicle.Color_Tracto__c){
                        FieldLabel += String.valueOf(aux) + '. Color<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.Color_Tracto__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.Color_Tracto__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Currency
                    if(unidad.CurrencyIsoCode != oldVehicle.CurrencyIsoCode){
                        FieldLabel += String.valueOf(aux) + '. Currency<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.CurrencyIsoCode + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.CurrencyIsoCode + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Marca
                    if(unidad.Marca__c != oldVehicle.Marca__c){
                        FieldLabel += String.valueOf(aux) + '. Marca<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.Marca__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.Marca__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Modelo
                    if(unidad.Modelo__c != oldVehicle.Modelo__c){
                        FieldLabel += String.valueOf(aux) + '. Modelo<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.Modelo__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.Modelo__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Num Placa Tracto
                    if(unidad.Num_Placa_Tracto__c != oldVehicle.Num_Placa_Tracto__c){
                        FieldLabel += String.valueOf(aux) + '. Num Placa Tracto<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.Num_Placa_Tracto__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.Num_Placa_Tracto__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Owner
                    if(unidad.OwnerId != oldVehicle.OwnerId){
                        FieldLabel += String.valueOf(aux) + '. Owner<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.OwnerId + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.OwnerId + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Tipo de Caja
                    if(unidad.Tipo_de_Caja__c != oldVehicle.Tipo_de_Caja__c){
                        FieldLabel += String.valueOf(aux) + '. Tipo de Caja<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.Tipo_de_Caja__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.Tipo_de_Caja__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Vehicle Name
                    if(unidad.Name != oldVehicle.Name){
                        FieldLabel += String.valueOf(aux) + '. Vehicle Name<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldVehicle.Name + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + unidad.Name + '<br/>';
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
                F_HT.Vehicle_History__c = RecordID;
                //GUARDA EL REGISTRO
                Database.insert(F_HT);
            }
        }
    }

}