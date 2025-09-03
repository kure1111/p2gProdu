trigger PAK_ShipmentHistory on Shipment__c (after update) {
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
           //PAK_ShipmentHistoryHelper.ProccessShipments(Trigger.OldMap, Trigger.New);
            if(!RecursiveCheck.triggerMonitor.contains('PAK_ShipmentHistory')){
                RecursiveCheck.triggerMonitor.add('PAK_ShipmentHistory');
                Map<Id,Shipment__c> OldMap = Trigger.OldMap;
                List<Shipment__c> NewShip = Trigger.New;
                for(Shipment__c ship : NewShip){
                    
                    //HACE REFERENCIA AL VALOR ANTERIOR DE LA CUENTA
                    Shipment__c oldShipment = OldMap.get(ship.Id);
                    User = ship.LastModifiedById; //Id del último usuario que modificó el registro
                    ModificationDate = System.now();//Captura la fecha actual
                    RecordID = ship.Id;//Captura el ID del shipment modificada
                    
                    //CAMPO Acuse en SAP
                    if(ship.Acuse_en_SAP__c != oldShipment.Acuse_en_SAP__c){
                        FieldLabel += String.valueOf(aux) + '. Acuse en SAP<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Acuse_en_SAP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Acuse_en_SAP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO ACUSE RECIBIDO
                    if(ship.VERIFY_ACUSE_SAP__c != oldShipment.VERIFY_ACUSE_SAP__c){
                        FieldLabel += String.valueOf(aux) + '. ACUSE RECIBIDO<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.VERIFY_ACUSE_SAP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.VERIFY_ACUSE_SAP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Autoriza Venta menor a Cotizacion
                    if(ship.Sell_Amount_Bloq__c != oldShipment.Sell_Amount_Bloq__c){
                        FieldLabel += String.valueOf(aux) + '. Autoriza Venta menor a Cotizacion<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Sell_Amount_Bloq__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Sell_Amount_Bloq__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO AUTORIZADO FP/FO
                    if(ship.AUTORIZADO_FP_FO__c != oldShipment.AUTORIZADO_FP_FO__c){
                        FieldLabel += String.valueOf(aux) + '. AUTORIZADO FP/FO<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.AUTORIZADO_FP_FO__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.AUTORIZADO_FP_FO__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO AUTORIZAR GASTO EXTRA
                    if(ship.AUTORIZAR_GASTO_EXTRA__c != oldShipment.AUTORIZAR_GASTO_EXTRA__c){
                        FieldLabel += String.valueOf(aux) + '. AUTORIZAR GASTO EXTRA<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.AUTORIZAR_GASTO_EXTRA__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.AUTORIZAR_GASTO_EXTRA__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Cargo insurance
                    if(ship.Cargo_insurance__c != oldShipment.Cargo_insurance__c){
                        FieldLabel += String.valueOf(aux) + '. Cargo insurance<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Cargo_insurance__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Cargo_insurance__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Carrier
                    if(ship.Carrier__c != oldShipment.Carrier__c){
                        FieldLabel += String.valueOf(aux) + '. Carrier<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Carrier__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Carrier__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Cliente con cita
                    if(ship.Cliente_con_cita2__c != oldShipment.Cliente_con_cita2__c){
                        FieldLabel += String.valueOf(aux) + '. Cliente con cita<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Cliente_con_cita2__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Cliente_con_cita2__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Container Count
                    if(ship.N_Containers__c != oldShipment.N_Containers__c){
                        FieldLabel += String.valueOf(aux) + '. Container Count<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.N_Containers__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.N_Containers__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Conversion Rate Date
                    if(ship.Conversion_Rate_Date__c != oldShipment.Conversion_Rate_Date__c){
                        FieldLabel += String.valueOf(aux) + '. Conversion Rate Date<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Conversion_Rate_Date__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Conversion_Rate_Date__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Country of Discharge
                    if(ship.Country_of_Discharge__c != oldShipment.Country_of_Discharge__c){
                        FieldLabel += String.valueOf(aux) + '. Country of Discharge<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Country_of_Discharge__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Country_of_Discharge__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Country of Load
                    if(ship.Country_of_Load__c != oldShipment.Country_of_Load__c){
                        FieldLabel += String.valueOf(aux) + '. Country of Load<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Country_of_Load__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Country_of_Load__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Currency
                    if(ship.CurrencyIsoCode != oldShipment.CurrencyIsoCode){
                        FieldLabel += String.valueOf(aux) + '. Currency<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.CurrencyIsoCode + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.CurrencyIsoCode + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Customs Broker
                    if(ship.Customs_Broker__c != oldShipment.Customs_Broker__c){
                        FieldLabel += String.valueOf(aux) + '. Customs Broker<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Customs_Broker__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Customs_Broker__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Date Planner Confirmed
                    if(ship.Date_Planner_Confirmed__c != oldShipment.Date_Planner_Confirmed__c){
                        FieldLabel += String.valueOf(aux) + '. Date Planner Confirmed<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Date_Planner_Confirmed__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Date_Planner_Confirmed__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Date Receive from SAP
                    if(ship.Date_Receive_from_SAP__c != oldShipment.Date_Receive_from_SAP__c){
                        FieldLabel += String.valueOf(aux) + '. Date Receive from SAP<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Date_Receive_from_SAP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Date_Receive_from_SAP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Delivery Address
                    if(ship.Destination_Address__c != oldShipment.Destination_Address__c){
                        FieldLabel += String.valueOf(aux) + '. Delivery Address<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Destination_Address__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Destination_Address__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Devolución
                    if(ship.Devolucion__c != oldShipment.Devolucion__c){
                        FieldLabel += String.valueOf(aux) + '. Devolución<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Devolucion__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Devolucion__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Documentos de Cruce
                    if(ship.Documentos_de_Cruce__c != oldShipment.Documentos_de_Cruce__c){
                        FieldLabel += String.valueOf(aux) + '. Documentos de Cruce<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Documentos_de_Cruce__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Documentos_de_Cruce__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Email Sales Executive
                    if(ship.Email_Sales_ExecutiveSP__c != oldShipment.Email_Sales_ExecutiveSP__c){
                        FieldLabel += String.valueOf(aux) + '. Email Sales Executive<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Email_Sales_ExecutiveSP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Email_Sales_ExecutiveSP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Enable Route Options
                    if(ship.Enable_Route_Options__c != oldShipment.Enable_Route_Options__c){
                        FieldLabel += String.valueOf(aux) + '. Enable Route Options<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Enable_Route_Options__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Enable_Route_Options__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Enviado Sap
                    if(ship.Enviado_Sap__c != oldShipment.Enviado_Sap__c){
                        FieldLabel += String.valueOf(aux) + '. Enviado Sap<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Enviado_Sap__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Enviado_Sap__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Estatus Cerrado
                    if(ship.Estatus_Cerrado__c != oldShipment.Estatus_Cerrado__c){
                        FieldLabel += String.valueOf(aux) + '. Estatus Cerrado<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Estatus_Cerrado__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Estatus_Cerrado__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO ETA
                    if(ship.ETA_Point_of_Discharge__c != oldShipment.ETA_Point_of_Discharge__c){
                        FieldLabel += String.valueOf(aux) + '. ETA<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.ETA_Point_of_Discharge__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.ETA_Point_of_Discharge__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO ETA Time
                    if(ship.ETA_Time_Point_of_Discharge__c != oldShipment.ETA_Time_Point_of_Discharge__c){
                        FieldLabel += String.valueOf(aux) + '. ETA Time<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.ETA_Time_Point_of_Discharge__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.ETA_Time_Point_of_Discharge__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO ETD
                    if(ship.ETD_from_Point_of_Load__c != oldShipment.ETD_from_Point_of_Load__c){
                        FieldLabel += String.valueOf(aux) + '. ETD<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.ETD_from_Point_of_Load__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.ETD_from_Point_of_Load__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO ETD Time
                    if(ship.ETD_Time_from_Point_of_Load__c != oldShipment.ETD_Time_from_Point_of_Load__c){
                        FieldLabel += String.valueOf(aux) + '. ETD Time<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.ETD_Time_from_Point_of_Load__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.ETD_Time_from_Point_of_Load__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO ATA
                    if(ship.ATA__c != oldShipment.ATA__c){
                        FieldLabel += String.valueOf(aux) + '. ATA<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.ATA__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.ATA__c + '<br/>';
                        aux = aux + 1;
                    }
                    //Modificó Status Planner
                    if(ship.Modifico_Status_Planner__c != oldShipment.Modifico_Status_Planner__c){
                        FieldLabel += String.valueOf(aux) + '. Modificó Status Planner<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Modifico_Status_Planner__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Modifico_Status_Planner__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Final Client
                    if(ship.Name_Cliente__c != oldShipment.Name_Cliente__c){
                        FieldLabel += String.valueOf(aux) + '. Final Client<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Name_Cliente__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Name_Cliente__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Freight Mode
                    if(ship.Freight_Mode__c != oldShipment.Freight_Mode__c){
                        FieldLabel += String.valueOf(aux) + '. Freight Mode<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Freight_Mode__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Freight_Mode__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Freight Rates Requests
                    if(ship.Marketplace_Auction__c != oldShipment.Marketplace_Auction__c){
                        FieldLabel += String.valueOf(aux) + '. Freight Rates Requests<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Marketplace_Auction__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Marketplace_Auction__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Hazardous
                    if(ship.Hazardous__c != oldShipment.Hazardous__c){
                        FieldLabel += String.valueOf(aux) + '. Hazardous<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Hazardous__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Hazardous__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Margen Operativo %
                    if(ship.Order_Margen_Operativo__c != oldShipment.Order_Margen_Operativo__c){
                        FieldLabel += String.valueOf(aux) + '. Margen Operativo %<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Order_Margen_Operativo__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Order_Margen_Operativo__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Monitoreo Recepción Acuse
                    if(ship.Monitoreo_Recepci_n_Acuse__c != oldShipment.Monitoreo_Recepci_n_Acuse__c){
                        FieldLabel += String.valueOf(aux) + '. Monitoreo Recepción Acuse<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Monitoreo_Recepci_n_Acuse__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Monitoreo_Recepci_n_Acuse__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Notificar Gasto Extra
                    if(ship.NotificarGastoExtra__c != oldShipment.NotificarGastoExtra__c){
                        FieldLabel += String.valueOf(aux) + '. Notificar Gasto Extra<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.NotificarGastoExtra__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.NotificarGastoExtra__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO OK FACTURAR
                    if(ship.OK_FACTURAR_FI__c != oldShipment.OK_FACTURAR_FI__c){
                        FieldLabel += String.valueOf(aux) + '. OK FACTURAR<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.OK_FACTURAR_FI__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.OK_FACTURAR_FI__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Only Warehouse Service
                    if(ship.Only_Warehouse_Service__c != oldShipment.Only_Warehouse_Service__c){
                        FieldLabel += String.valueOf(aux) + '. Only Warehouse Service<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Only_Warehouse_Service__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Only_Warehouse_Service__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Operation Executive
                    if(ship.Operation_Executive__c != oldShipment.Operation_Executive__c){
                        FieldLabel += String.valueOf(aux) + '. Operation Executive<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Operation_Executive__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Operation_Executive__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Order
                    if(ship.Order__c != oldShipment.Order__c){
                        FieldLabel += String.valueOf(aux) + '. Order<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Order__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Order__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Pickup Address
                    if(ship.Origin_Address__c != oldShipment.Origin_Address__c){
                        FieldLabel += String.valueOf(aux) + '. Pickup Address<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Origin_Address__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Origin_Address__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Placas Validadas
                    if(ship.Placas_Validadas__c != oldShipment.Placas_Validadas__c){
                        FieldLabel += String.valueOf(aux) + '. Placas Validadas<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Placas_Validadas__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Placas_Validadas__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Record Type
                    if(ship.RecordTypeId != oldShipment.RecordTypeId){
                        FieldLabel += String.valueOf(aux) + '. Record Type<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.RecordTypeId + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.RecordTypeId + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Reparto
                    if(ship.Reparto__c != oldShipment.Reparto__c){
                        FieldLabel += String.valueOf(aux) + '. Reparto<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Reparto__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Reparto__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Route
                    if(ship.Route__c != oldShipment.Route__c){
                        FieldLabel += String.valueOf(aux) + '. Route<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Route__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Route__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO SAP Invoiced
                    if(ship.SAP_Invoiced__c != oldShipment.SAP_Invoiced__c){
                        FieldLabel += String.valueOf(aux) + '. SAP Invoiced<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.SAP_Invoiced__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.SAP_Invoiced__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Sell Price Modified
                    if(ship.Sell_Price_Modified__c != oldShipment.Sell_Price_Modified__c){
                        FieldLabel += String.valueOf(aux) + '. Sell Price Modified<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Sell_Price_Modified__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Sell_Price_Modified__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Service Mode
                    if(ship.Service_Mode__c != oldShipment.Service_Mode__c){
                        FieldLabel += String.valueOf(aux) + '. Service Mode<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Service_Mode__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Service_Mode__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Service Type
                    if(ship.Service_Type__c != oldShipment.Service_Type__c){
                        FieldLabel += String.valueOf(aux) + '. Service Type<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Service_Type__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Service_Type__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment Cerrado
                    if(ship.SPCerrado__c != oldShipment.SPCerrado__c){
                        FieldLabel += String.valueOf(aux) + '. Shipment Cerrado<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.SPCerrado__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.SPCerrado__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment Customer Evaluate
                    if(ship.Shipment_Customer_Evaluate__c != oldShipment.Shipment_Customer_Evaluate__c){
                        FieldLabel += String.valueOf(aux) + '. Shipment Customer Evaluate<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Shipment_Customer_Evaluate__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Shipment_Customer_Evaluate__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment Number
                    if(ship.Name != oldShipment.Name){
                        FieldLabel += String.valueOf(aux) + '. Shipment Number<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Name + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Name + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment Status Monitoreo
                    if(ship.Shipment_Status_Mon__c != oldShipment.Shipment_Status_Mon__c){
                        FieldLabel += String.valueOf(aux) + '. Shipment Status Monitoreo<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Shipment_Status_Mon__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Shipment_Status_Mon__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Shipment Status Planner
                    if(ship.Shipment_Status_Plann__c != oldShipment.Shipment_Status_Plann__c){
                        FieldLabel += String.valueOf(aux) + '. Shipment Status Planner<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Shipment_Status_Plann__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Shipment_Status_Plann__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Site of Discharge
                    if(ship.Site_of_Discharge__c != oldShipment.Site_of_Discharge__c){
                        FieldLabel += String.valueOf(aux) + '. Site of Discharge<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Site_of_Discharge__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Site_of_Discharge__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Site of Load
                    if(ship.Site_of_Load__c != oldShipment.Site_of_Load__c){
                        FieldLabel += String.valueOf(aux) + '. Site of Load<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Site_of_Load__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Site_of_Load__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Solicitud de Maniobras
                    if(ship.Solicitud_de_Maniobras__c != oldShipment.Solicitud_de_Maniobras__c){
                        FieldLabel += String.valueOf(aux) + '. Solicitud de Maniobras<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Solicitud_de_Maniobras__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Solicitud_de_Maniobras__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO SP Evaluated
                    if(ship.SP_Evaluated__c != oldShipment.SP_Evaluated__c){
                        FieldLabel += String.valueOf(aux) + '. SP Evaluated<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.SP_Evaluated__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.SP_Evaluated__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO State of Discharge
                    if(ship.State_of_Discharge__c != oldShipment.State_of_Discharge__c){
                        FieldLabel += String.valueOf(aux) + '. State of Discharge<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.State_of_Discharge__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.State_of_Discharge__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO State of Load
                    if(ship.State_of_Load__c != oldShipment.State_of_Load__c){
                        FieldLabel += String.valueOf(aux) + '. State of Load<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.State_of_Load__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.State_of_Load__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Status Acuse SAP
                    if(ship.Status_Acuse_SAP__c != oldShipment.Status_Acuse_SAP__c){
                        FieldLabel += String.valueOf(aux) + '. Status Acuse SAP<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Status_Acuse_SAP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Status_Acuse_SAP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Status Shipment SAP
                    if(ship.Status_Shipment__c != oldShipment.Status_Shipment__c){
                        FieldLabel += String.valueOf(aux) + '. Status Shipment SAP<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Status_Shipment__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Status_Shipment__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO VERIFY PAK CONTROL
                    if(ship.VERIFY_PAK_CONTROL__c != oldShipment.VERIFY_PAK_CONTROL__c){
                        FieldLabel += String.valueOf(aux) + '. VERIFY PAK CONTROL<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.VERIFY_PAK_CONTROL__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.VERIFY_PAK_CONTROL__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO VoBo Acuse SAP
                    if(ship.VoBo_Acuse_SAP__c != oldShipment.VoBo_Acuse_SAP__c){
                        FieldLabel += String.valueOf(aux) + '. VoBo Acuse SAP<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.VoBo_Acuse_SAP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.VoBo_Acuse_SAP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Total Payment SAP
                    if(ship.Pago_Contado_SAP__c != oldShipment.Pago_Contado_SAP__c){
                        FieldLabel += String.valueOf(aux) + '. Total Payment SAP<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Pago_Contado_SAP__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Pago_Contado_SAP__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Date time Finished monitoreo
                    if(ship.Date_time_FN_Finished__c != oldShipment.Date_time_FN_Finished__c){
                        FieldLabel += String.valueOf(aux) + '. Date time Finished monitoreo<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Date_time_FN_Finished__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Date_time_FN_Finished__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Ocean Expo Shipment Status
                    if(ship.Shipment_Status__c != oldShipment.Shipment_Status__c){
                        FieldLabel += String.valueOf(aux) + '. Ocean Expo Shipment Status<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Shipment_Status__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Shipment_Status__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Ocean Impo Shipment Status
                    if(ship.Ocean_Shipment_Status__c != oldShipment.Ocean_Shipment_Status__c){
                        FieldLabel += String.valueOf(aux) + '. Ocean Impo Shipment Status<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Ocean_Shipment_Status__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Ocean_Shipment_Status__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Air Shipment Status
                    if(ship.Air_Shipment_Status__c != oldShipment.Air_Shipment_Status__c){
                        FieldLabel += String.valueOf(aux) + '. Air Shipment Status<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Air_Shipment_Status__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Air_Shipment_Status__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Routing Operation Status
                    if(ship.Routing_Operation_Status__c != oldShipment.Routing_Operation_Status__c){
                        FieldLabel += String.valueOf(aux) + '. Routing Operation Status<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Routing_Operation_Status__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Routing_Operation_Status__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Tipo de Carta Porte
                    if(ship.Traslado_Ingreso__c != oldShipment.Traslado_Ingreso__c){
                        FieldLabel += String.valueOf(aux) + '. Tipo de Carta Porte<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldShipment.Traslado_Ingreso__c + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + ship.Traslado_Ingreso__c + '<br/>';
                        aux = aux + 1;
                    }
                    //CAMPO Placed Time
                    if (ship.Equip_Placed__c != oldShipment.Equip_Placed__c) {
                        // Obtener la zona horaria del usuario actual
                        TimeZone localTimeZone = UserInfo.getTimeZone();
                    
                        // Convertir las horas UTC a la hora local
                        DateTime oldPlacedTimeUTC = oldShipment.Equip_Placed__c;
                        DateTime newPlacedTimeUTC = ship.Equip_Placed__c;
                    
                        // Convertir UTC a la hora local
                        DateTime oldPlacedTimeLocal = oldPlacedTimeUTC != null 
                            ? oldPlacedTimeUTC.addSeconds(localTimeZone.getOffset(oldPlacedTimeUTC) / 1000)
                            : null;
                        DateTime newPlacedTimeLocal = newPlacedTimeUTC.addSeconds(localTimeZone.getOffset(newPlacedTimeUTC) / 1000);
                    
                        // Formatear las horas en la hora local del usuario
                        String oldPlacedTimeLocalStr = oldPlacedTimeLocal != null 
                            ? oldPlacedTimeLocal.format('dd/MM/yyyy hh:mm a', 'en_US') 
                            : 'null';
                        String newPlacedTimeLocalStr = newPlacedTimeLocal.format('dd/MM/yyyy hh:mm a', 'en_US');
                    
                        // Concatenar los valores formateados en la zona horaria local
                        FieldLabel += String.valueOf(aux) + '. Placed Time<br/>';
                        OriginalValues += String.valueOf(aux) + '. ' + oldPlacedTimeLocalStr + '<br/>';
                        NewValues += String.valueOf(aux) + '. ' + newPlacedTimeLocalStr + '<br/>';
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
                    F_HT.Shipment_History__c = RecordID;
                    //GUARDA EL REGISTRO
                    Database.insert(F_HT);
                }
            }
        }
    }
    
}