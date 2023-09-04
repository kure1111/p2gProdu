trigger PAK_OrderHistory on Order (after update) {
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
                //PAK_OrderHistoryHelper.ProccessOrders(Trigger.OldMap, Trigger.New);
                Map<Id,Order> OldMap = Trigger.OldMap;
                List<Order> NewOrder = Trigger.New;
                
                for(Order ord : NewOrder){
                    //HACE REFERENCIA AL VALOR ANTERIOR DE LA ORDEN
                    Order oldOrder = OldMap.get(ord.Id);
                    User = ord.LastModifiedById; //Id del último usuario que modificó el registro
                    ModificationDate = System.now();//Captura la fecha actual
                    RecordID = ord.Id;//Captura el ID de la orden modificada
                    
                    //CAMPO ﻿Account Name
                    if(ord.AccountId != oldOrder.AccountId){
                        FieldLabel += String.valueOf(aux) + '. ﻿Account Name<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.AccountId + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.AccountId + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Date Receive from SAP
                    if(ord.Date_Receive_from_SAP__c != oldOrder.Date_Receive_from_SAP__c){
                        FieldLabel += String.valueOf(aux) + '. Date Receive from SAP<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.Date_Receive_from_SAP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.Date_Receive_from_SAP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO DefaultPbe
                    if(ord.DefaultPbe__c != oldOrder.DefaultPbe__c){
                        FieldLabel += String.valueOf(aux) + '. DefaultPbe<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.DefaultPbe__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.DefaultPbe__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO DefaultProduct
                    if(ord.DefaultProduct__c != oldOrder.DefaultProduct__c){
                        FieldLabel += String.valueOf(aux) + '. DefaultProduct<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.DefaultProduct__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.DefaultProduct__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Orden de Venta
                    if(ord.OrdenVenta__c != oldOrder.OrdenVenta__c){
                        FieldLabel += String.valueOf(aux) + '. Orden de Venta<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.OrdenVenta__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.OrdenVenta__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Order Amount
                    if(ord.TotalAmount != oldOrder.TotalAmount){
                        FieldLabel += String.valueOf(aux) + '. Order Amount<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.TotalAmount + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.TotalAmount + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Order Currency
                    if(ord.CurrencyIsoCode != oldOrder.CurrencyIsoCode){
                        FieldLabel += String.valueOf(aux) + '. Order Currency<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.CurrencyIsoCode + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.CurrencyIsoCode + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Order Owner
                    if(ord.OwnerId != oldOrder.OwnerId){
                        FieldLabel += String.valueOf(aux) + '. Order Owner<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.OwnerId + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.OwnerId + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Order Start Date
                    if(ord.EffectiveDate != oldOrder.EffectiveDate){
                        FieldLabel += String.valueOf(aux) + '. Order Start Date<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.EffectiveDate + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.EffectiveDate + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Price Book
                    if(ord.Pricebook2Id != oldOrder.Pricebook2Id){
                        FieldLabel += String.valueOf(aux) + '. Price Book<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.Pricebook2Id + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.Pricebook2Id + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Reduction Order
                    if(ord.IsReductionOrder != oldOrder.IsReductionOrder){
                        FieldLabel += String.valueOf(aux) + '. Reduction Order<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.IsReductionOrder + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.IsReductionOrder + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment
                    if(ord.Shipment__c != oldOrder.Shipment__c){
                        FieldLabel += String.valueOf(aux) + '. Shipment<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.Shipment__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.Shipment__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Solicitud compra
                    if(ord.Solicitud_compra__c != oldOrder.Solicitud_compra__c){
                        FieldLabel += String.valueOf(aux) + '. Solicitud compra<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.Solicitud_compra__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.Solicitud_compra__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Status
                    if(ord.Status != oldOrder.Status){
                        FieldLabel += String.valueOf(aux) + '. Status<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldOrder.Status + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ord.Status + '<br/>';
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
                F_HT.Order_History__c = RecordID;
                //GUARDA EL REGISTRO
                Database.insert(F_HT);
            }
        }
    }
    
}