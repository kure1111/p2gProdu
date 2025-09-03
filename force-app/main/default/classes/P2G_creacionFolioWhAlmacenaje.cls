public with sharing class P2G_creacionFolioWhAlmacenaje {
    @AuraEnabled(cacheable=false)
    public static Quote_Item_Line__c getCargoLine(String idQuote){
        Quote_Item_Line__c cargoLine = [SELECT Id,Name,CE_Descripcion_de_Producto_PAK__c,Container_Type__r.Name, Clave_de_Servicio__r.Name,
                                           Extension_Item_Name__c,CurrencyIsoCode,Units__c,Total_Shipping_Weight_Kgs__c,Peso_Neto__c,Total_Shipping_Volume_m3__c,
                                           Material_Peligroso_Cat__r.Name,Embalaje_Cat__r.Name FROM Quote_Item_Line__c WHERE Import_Export_Quote__c =: idQuote LIMIT 1];
        return cargoLine;
    }
    @AuraEnabled(cacheable=false)
    public static Import_Export_Fee_Line__c getServiceLine(String idQuote){
        Import_Export_Fee_Line__c serviceLine = [SELECT Id, Name,Service_Rate_Category__c, Quote_Buy_Price__c,Sap_Service_Type__c,Buy_Rate__c,
                                                 route__c, Quote_Sell_Price__c,Units__c,CurrencyIsoCode,Service_Rate_Name__r.Name,Sell_Rate__c
                                                 FROM Import_Export_Fee_Line__c WHERE Import_Export_Quote__c =: idQuote 
                                                 order by CreatedDate desc limit 1];
        return serviceLine;
    }
    
    @AuraEnabled(cacheable=false)
    public static P2G_CreacionFoliosWrapper.folio creaFolios(P2G_CreacionFoliosWrapper.folio fleteNacional,P2G_CreacionFoliosWrapper.cargoLine cargoLine){
        System.debug('folio que llega: '+fleteNacional);
        Customer_Quote__c creaFolios = new Customer_Quote__c();
        Quote_Item_Line__c creaCargo = new Quote_Item_Line__c();
        Sourcing_Item__c creaItem = new Sourcing_Item__c();
        Fee__c creaServiceRate = new Fee__c();
        Import_Export_Fee_Line__c creaServiceLine = new Import_Export_Fee_Line__c();
        Location__c locLoad = new Location__c();
        Location__c locDischarged = new Location__c();
        try{
            Account almacen2go = [SELECT Id, Name FROM Account WHERE Name = 'ALMACEN 2GO LOGISTIC CLIENTE' limit 1];
            Catalogo_SAT__c idUnidadPeso = [SELECT Id, Name FROM Catalogo_SAT__c where Name = 'Pallet' limit : 1];
            fleteNacional.recordTypeUnidad = idUnidadPeso.Id;
            Container_Type__c idContainerType = [SELECT Id, Name FROM Container_Type__c where Name = 'Caja 53 FT' limit 1];
            fleteNacional.idConteinerType = idContainerType.Id;
            cargoLine.idConteinerType = idContainerType.Id;
            List<Location__c> location = [SELECT Id, Name, Country__c, State__c FROM Location__c WHERE Id=:fleteNacional.idSideLoad OR Id=:fleteNacional.idSideDischarged];
            for(Location__c loc : location){
                if(fleteNacional.idSideLoad == loc.Id){
                    locLoad = loc;
                }
                if(fleteNacional.idSideDischarged == loc.Id){
                    locDischarged = loc;
                }
            }
            string name = cargoLine.extencionItemName;
            string account = fleteNacional.idAccount;
            string divisa = cargoLine.currencyIsoCode;
            fleteNacional = P2G_CreacionFoliosWrapper.tipoServicio(fleteNacional);
            //Creación de folios y de item dependiendo de el numero de folios a crear
            creaFolios = creaImportExportQuote(fleteNacional,locLoad,locDischarged);
            creaItem = P2G_CreacionFolios.creaItem(name, account, divisa);       
            insert creaFolios;
            insert creaItem;
            //creacion de cargo line
            cargoLine.idQuote = creaFolios.Id;
            cargoLine.idItem = creaItem.Id;
            creaCargo = P2G_CreacionFolios.createCargoLine(cargoLine); 
            insert creaCargo;
            //consulta IEQO para traer la ruta
            Customer_Quote__c IEQO = [SELECT id, Name, Route__c FROM Customer_Quote__c WHERE Id =: creaFolios.Id LIMIT 1];
            fleteNacional.id = IEQO.Id;
            fleteNacional.Name = IEQO.Name;
            System.debug('consulta quote '+IEQO);
            //crear service line
            creaServiceRate = P2G_creacionFolioInternacionales.CreateServiceRate(IEQO.Route__c,cargoLine.idSST,fleteNacional);
            insert creaServiceRate;
            //creacion de service line
            creaServiceLine = P2G_creacionFolioInternacionales.CreateServiceLine(IEQO.Id,creaServiceRate);
            Insert creaServiceLine;
            
            // crea shipments si es el cliente Almacenaje
            if(fleteNacional.idAccount == almacen2go.Id){
                futureM(IEQO.Id);
            }
            fleteNacional.error='sin error';
            System.debug('la lista de folios creados: '+ IEQO);  
        }catch(Exception e){
            fleteNacional.error='Error crea Folios WH - Almacenaje: '+e.getMessage()+e.getLineNumber();
            System.debug('Error crea Folios WH - Almacenaje: '+e.getMessage()+e.getLineNumber());     
        }
        return fleteNacional;
    }
    public static Customer_Quote__c creaImportExportQuote(P2G_CreacionFoliosWrapper.folio fleteNacional,Location__c locationLoad,Location__c locationDischarge){
        Customer_Quote__c quote = new Customer_Quote__c();
        String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
        String[] Awaitingloadtime = fleteNacional.Awaitingloadtime.split(':');
        String[] Awaitingunloadtime = fleteNacional.Awaitingunloadtime.split(':');
            quote.RecordTypeId = recordTypeId;
            quote.Clave_de_Unidad_de_Peso__c = fleteNacional.recordTypeUnidad;
            quote.Name='.';
            quote.Account_for__c = fleteNacional.idAccount;
            quote.Team__c = fleteNacional.team;
            quote.Quotation_Status__c = fleteNacional.quotationStatus;
            if(fleteNacional.reference != '' && fleteNacional.reference != null){
                quote.Customer_Reference__c = fleteNacional.reference;}
            if(fleteNacional.idReferenceForm != '' && fleteNacional.idReferenceForm != null){
                quote.Customer_Reference_Form__c = fleteNacional.idReferenceForm;}
            quote.Valid_From__c = system.today();
            quote.Valid_Until__c = system.today();
            quote.Country_ofLoad__c = locationLoad.Country__c;
            quote.State_of_Load__c = locationLoad.State__c;
            quote.Site_of_Load__c = fleteNacional.idSideLoad;
            quote.Country_ofDischarge__c = locationDischarge.Country__c;
            quote.State_of_Discharge__c = locationDischarge.State__c;
            quote.Site_of_Discharge__c = fleteNacional.idSideDischarged;
            quote.ETD__c = Date.valueOf(fleteNacional.etd);
            quote.ETA__c = Date.valueOf(fleteNacional.eta);
            quote.Community_Status__c = fleteNacional.CommunityStatus;
            quote.Awaiting_load_time__c = Time.newInstance( Integer.valueOf(Awaitingloadtime[0]) //hour
                                                           ,Integer.valueOf(Awaitingloadtime[1]) //min
                                                           ,0,0);
            quote.Awaiting_unload_time__c = Time.newInstance( Integer.valueOf(Awaitingunloadtime[0]) //hour
                                                             ,Integer.valueOf(Awaitingunloadtime[1]) //min
                                                             ,0,0);
            quote.Account_Origin_Address__c = fleteNacional.AccountOriginAddress;
            quote.Account_Destination_Address__c = fleteNacional.AccountDestinAddress;
            quote.Pricing_Executive__c = UserInfo.getUserId();
            quote.Container_Type__c = fleteNacional.idConteinerType;
            quote.Comercio_Exterior__c = fleteNacional.comercioExterior;
            quote.Freight_Mode__c = fleteNacional.freighMode;
            quote.CurrencyIsoCode = fleteNacional.rurrencyIsoCode;
            quote.Only_Warehouse_Service__c = fleteNacional.warehouseService;
            return quote;
    }
    public static Shipment_Fee_Line__c crearShipmnetServiceLine(Import_Export_Fee_Line__c IEQO, string idShip){
        Shipment_Fee_Line__c serviceLine = new Shipment_Fee_Line__c();
            serviceLine.Import_Export_Quote__c = IEQO.Import_Export_Quote__c;
            serviceLine.Shipment__c = idShip;
            serviceLine.Name = '001';
            serviceLine.Units__c = 1;
            serviceLine.CurrencyIsoCode = IEQO.currencyIsoCode;
            serviceLine.Service_Rate_Name__c = IEQO.Service_Rate_Name__c;
            serviceLine.Shipment_Sell_Price__c = IEQO.Service_Rate_Name__r.Fee_Rate__c;
            serviceLine.Shipment_Buy_Price__c = IEQO.Service_Rate_Name__r.Buy_Rate__c;
            serviceLine.Es_de_IEQ__c = true;
        return serviceLine;
    }
    public static Shipment__c closedShiment(Shipment__c ship){
        Vehicle__c vehicle = [SELECT Id, Account_for_SCP__c FROM Vehicle__c WHERE Account_for_SCP__r.Name = 'ALMACEN 2GO LOGISTIC CARRIER' limit 1];
        Operadores__c operator = [SELECT Id, Account__c, Vehicle_del__c FROM Operadores__c WHERE Account__r.Name = 'ALMACEN 2GO LOGISTIC CARRIER' limit 1];
            ship.Carrier__c = vehicle.Account_for_SCP__c;
            ship.National_Operator__c = operator.Id;
            ship.Vehicle__c = vehicle.Id;
        	ship.Shipment_Status_Plann__c = 'Confirmed';
        return Ship;
    }
    @future
    public static void futureM(String idfolio){
        Shipment_Fee_Line__c creaShipmentServiceLine = new Shipment_Fee_Line__c();
        Shipment__c ship = new Shipment__c();
        NEU_StaticVariableHelper.setBoolean1(true);
        ship = creaShipment(idfolio);
        Import_Export_Fee_Line__c IEQO = [SELECT Id, Name, Import_Export_Quote__c, CurrencyIsoCode,Service_Rate_Name__c,
                                          Service_Rate_Name__r.Fee_Rate__c, Service_Rate_Name__r.Buy_Rate__c
                                          FROM Import_Export_Fee_Line__c WHERE Import_Export_Quote__c =: idfolio LIMIT 1];
        //cambiar el status de los IEQO a aprobar
        Customer_Quote__c folio = new Customer_Quote__c();
        folio.Quotation_Status__c = 'Approved as Succesful';
        folio.id = IEQO.Import_Export_Quote__c;
        folio.Last_Shipment__c = ship.id;
        update folio;
        // crear Shipment Service line
        creaShipmentServiceLine = crearShipmnetServiceLine(IEQO, ship.Id);
        insert creaShipmentServiceLine;
        //aprobar Shipment
        ship = closedShiment(ship);
        update ship;
        Set<Id> ordersIds = new Set<Id>{ship.Order__c};
        sendToSap(ordersIds);
        ship.Shipment_Status_Plann__c = 'Closed';
        update ship;
        NEU_StaticVariableHelper.setBoolean1(false);
    }
    public static Shipment__c creaShipment(String idfolio){
        Shipment_Program__c filter_program =new Shipment_Program__c();
        Customer_Quote__c folio = [SELECT Id, Name, Approved_Date_time01__c, Account_for__c, Sales_Incoterm__c, Pickup_Cartage__c, Supplier_Account__c, Nature_Merchandise__c,
                                             Container_Type__c, Purchase_Incoterm__c, Service_Mode__c, Move_Type__c ,Origin_Address__c, Supplier_Shipper_Contact__c, 
                                             Account_Origin_Address__c, Consignee__c, Consignee_Contact__c, Account_Destination_Address__c, Destination_Address__c, 
                                             Customer_Reference__c, Warehouse__c, Only_Warehouse_Service__c, Border__c, Customs__c, Origin_Location__Latitude__s, 
                                             Origin_Location__Longitude__s, Destination_Location__Latitude__s, Destination_Location__Longitude__s, Kms__c, Freight_Mode__c,Service_Type__c,Route__c,
                                             Route__r.Name, CurrencyIsoCode, Country_ofDischarge__c, Country_ofLoad__c, State_of_Discharge__c, State_of_Load__c, Site_of_Discharge__c, Site_of_Load__c,
                                             ETA__c, ETD__c, Awaiting_unload_time__c, Container_Count__c, Awaiting_load_time__c, 
                                             Last_Shipment__c, Pricing_Executive__r.Email 
                                             FROM Customer_Quote__c where Id =: idfolio LIMIT 1]; 
        Shipment__c new_shipment = new Shipment__c();
        system.debug('Inicio creacion Shipment');
        List<Shipment_Consolidation_Data__c> scd = [select Id, Name, Import_Export_Quote__c from Shipment_Consolidation_Data__c where Import_Export_Quote__c =: folio.Id];
        new_shipment.Name = 'SP-' + folio.Name + (scd.size() == 0 ? '' : '-'+(scd.size()+1));
        new_shipment.MBL_Number__c= filter_program.MBL_Number__c;
        new_shipment.MAWB_Number__c= filter_program.MAWB_Number__c;
        new_shipment.Sea_Booking_Number__c= filter_program.Sea_Booking_Number__c;
        new_shipment.Voyage_Number_s__c= filter_program.Voyage_Number_sp__c;
        new_shipment.Truck_Number__c= filter_program.Truck_Number__c;
        new_shipment.Trailer_Number__c= filter_program.Trailer_Number__c;        
        new_shipment.Rail_Container_Number__c= filter_program.Rail_Container_Number__c;
        new_shipment.SMGS__c= filter_program.SMGS__c;
        new_shipment.CIM_Number__c= filter_program.CIM_Number__c;                    
        new_shipment.Freight_Mode__c = folio.Freight_Mode__c;
        new_shipment.Account_for__c=folio.Account_for__c;        
        new_shipment.Sales_Incoterm__c = folio.Sales_Incoterm__c;
        new_shipment.Pickup_Cartage__c = folio.Pickup_Cartage__c;
        new_shipment.Supplier_Account__c= folio.Supplier_Account__c;
        new_shipment.Country_of_Discharge__c =folio.Country_ofDischarge__c;
        new_shipment.Country_of_Load__c =folio.Country_ofLoad__c;
        new_shipment.State_of_Discharge__c = folio.State_of_Discharge__c;
        new_shipment.State_of_Load__c = folio.State_of_Load__c;
        new_shipment.Site_of_Discharge__c =folio.Site_of_Discharge__c;
        new_shipment.Site_of_Load__c =folio.Site_of_Load__c;
        new_shipment.Container_Type__c = folio.Container_Type__c;        
        new_shipment.Purchase_Incoterm__c = folio.Purchase_Incoterm__c; 
        new_shipment.Service_Mode__c = folio.Service_Mode__c;
        new_shipment.Service_Type__c =  folio.Service_Type__c;
        new_shipment.Move_Type__c = folio.Move_Type__c;
        new_shipment.Origin_Address__c = folio.Origin_Address__c;
        new_shipment.Shipper_Contact__c = folio.Supplier_Shipper_Contact__c;
        new_shipment.Account_Origin_Address__c = folio.Account_Origin_Address__c;
        new_shipment.Consignee__c = folio.Consignee__c;
        new_shipment.Consignee_Contact__c = folio.Consignee_Contact__c;
        new_shipment.Account_Destination_Address__c = folio.Account_Destination_Address__c;
        new_shipment.Destination_Address__c = folio.Destination_Address__c;
        new_shipment.Account_Shipment_Reference__c = folio.Customer_Reference__c;
        new_shipment.Warehouse__c = folio.Warehouse__c;
        new_shipment.Only_Warehouse_Service__c = folio.Only_Warehouse_Service__c;
        new_shipment.Border__c = folio.Border__c;
        new_shipment.Customs__c = folio.Customs__c;
        new_shipment.Origin_Location__Latitude__s = folio.Origin_Location__Latitude__s;        
        new_shipment.Destination_Location__Latitude__s = folio.Destination_Location__Latitude__s;
        new_shipment.Origin_Location__Longitude__s = folio.Origin_Location__Longitude__s;
        new_shipment.Destination_Location__Longitude__s = folio.Destination_Location__Longitude__s;
        new_shipment.Kms__c = folio.Kms__c;
        new_shipment.N_Containers__c = folio.Container_Count__c;              
        new_shipment.ETA_Point_of_Discharge__c=folio.ETA__c;
        new_shipment.ETD_from_Point_of_Load__c = folio.ETD__c;
        new_shipment.ETA_Time_Point_of_Discharge__c= folio.Awaiting_unload_time__c;
        new_shipment.ETD_Time_from_Point_of_Load__c = folio.Awaiting_load_time__c;
        String folioNumber = folio.Name;
        insert new_shipment;
        Order order = creaOrder(new_shipment);
        new_shipment.Order__c = order.Id;             
        update new_shipment;
        system.debug('Fin creacion del Shipment');
        system.debug('Creacion del objeto Shipment_Consolidation_Data__c');
        Shipment_Consolidation_Data__c data = new Shipment_Consolidation_Data__c();
        data.Shipment__c= new_shipment.Id;
        data.Import_Export_Quote__c =folio.Id;
        data.Customer_Buyer__c = folio.Account_for__c;
        data.Import_Export_Route__c = folio.Route__c;
        data.Name='001';
        insert data;
        NEU_Generate_Shipments.getSPCargoLine(folio,new_shipment, data);
        return new_shipment;
    }
    public static Order creaOrder(Shipment__c shipment){
        Order order = new Order();
        Id stdPriceBook = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1].Id;
        List<Product2> prods = [SELECT Id FROM Product2 WHERE Name = :shipment.Name limit 1];
        Product2 p;
        PricebookEntry pbe;
        if(prods.size()>0){            
            p = prods[0];
            pbe = [SELECT Id FROM PricebookEntry WHERE Product2Id =:p.Id LIMIT 1];
        }else{            
            p = new Product2(Name=shipment.Name, IsActive = true);
            insert p;
            pbe = new PricebookEntry();
            pbe.IsActive = true;
            pbe.UnitPrice = 1;
            pbe.Product2Id = p.Id;
            pbe.Pricebook2Id = stdPriceBook;
            insert pbe;
        }
        order.Pricebook2Id = stdPriceBook;
        order.DefaultProduct__c = p.Id;
        order.DefaultPbe__c = pbe.Id;  
        order.AccountId = shipment.Account_for__c;
        order.Status = 'Draft';
        order.EffectiveDate = Date.today();
        order.Shipment__c = shipment.Id;
        insert order;
        
        Return order;
    }
    public static void sendToSap(Set<Id> ordersIds){
        System.debug('SendToSAP APEX CLASS');
        List<Response__c> responses = new List<Response__c>();
        Date d = Date.today();
        String fecha = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/yyyy'); 
        String Org = '';
        if([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox){Org = 'QA';}else{Org = 'PROD';}
        List<Order> lstOrders = [SELECT Id, OrderNumber, TotalAmount, OrdenVenta__c, Shipment__c, Shipment__r.Name, Shipment__r.Account_for__r.Venta_Sap__c, 
                                 Shipment__r.Shipment_Status_Plann__c, Shipment__r.Shipment_Status__c, Shipment__r.Freight_Mode__c, 
                                 Shipment__r.Service_Mode__c, Shipment__r.Account_for__r.Owner.SalesEmployer__c, Shipment__r.Vendedor_Adicional__c,
                                 Shipment__r.Carrier__r.Customer_Id__c, Shipment__r.Acuse_en_SAP__c, Shipment__r.Operation_Executive__r.Name,
                                 Shipment__r.Operation_Executive_2__r.Name, Shipment__r.State_of_Load__c, Shipment__r.State_of_Load__r.Name, Shipment__r.Route__c,
                                 Shipment__r.Route__r.Name, Shipment__r.State_of_Discharge__r.Name, Shipment__r.CurrencyIsoCode, Shipment__r.Orden_de_Compra__c,
                                 Shipment__r.Account_for__r.Owner.Workplace__c,
                                 Shipment__r.Profit__c,Shipment__r.Account_Shipment_Reference__c,
                                 Shipment__r.Account_for__r.Customer_Id__c, Shipment__r.Plaza_Vendedor__c,
                                 Shipment__r.ShipmentService__c, Shipment__r.State_of_Load__r.Zone__c, Shipment__r.Site_of_Load__r.State__r.Zone__c,
                                 (SELECT Id, ServLine_Name__c, UnitPrice, Quantity, Service_Rate_Name__c, Std_Buy_Amount__c, Retention__c,
                                  Group__c, VAT__c, CurrencyLine__c, ItemCode__c, ShipServLineId__c, ItemStatus_SAP__c, ItemStatus_Shipment__c 
                                  FROM OrderItems)
                                 FROM Order 
                                 WHERE Id IN: ordersIds AND Shipment__c != NULL];
        System.debug('SOSAP ORDERS size: ' + lstOrders.size());
        System.debug('SOSAP ORDERS: ' + lstOrders);
        if(lstOrders.size()!=0){
            system.debug('Entrando al filtro');
            set<string> idsShip = new set<string>();
            Map<string,string> ShipDate = new Map<string,string>();
            for(Order o : lstOrders){
                idsShip.add(o.Shipment__c);
            }
            system.debug('imprimiendo idsShip: '+idsShip);
            list<Shipment_Fee_Line__c> Lines = [SELECT Id,Name,Units__c,CurrencyIsoCode,Shipment_Sell_Price__c,Shipment_Sell_Net_Price__c,Std_Buy_Amount__c,Shipment_Buy_Price__c,Concept_1__c,SAP__c, Service_Rate_Name__r.SAP_Service_Type__r.Code__c,Service_Rate_Name__r.SAP_Service_Type__r.Group__c,Service_Rate_Name__r.SAP_Service_Type__r.Name,Service_Rate_Name__r.SAP_Service_Type_Buy__r.Code__c, Currency_Buy_Price__c,
                                                Conversion_Rate_to_Buy_Currency_Header__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT_Withholding__c,Service_Rate_Name__r.Tipo_RetencionProveedores__c,Service_Rate_Name__r.SAP_Service_Type__r.VAT__c,Service_Rate_Name__r.Carrier_Account__r.Name,Service_Rate_Name__r.Carrier_Account__r.Customer_Id__c,SST_Orden_compra__c,
                                                SST_Estatus_orden_compra__c,/*SST_Sociedad__c,*/Service_Rate_Name__r.Tipo_RetencionClientes__c, Service_Rate_Name__r.P2G_SapDevolucion__c, Shipment__c
                                                FROM Shipment_Fee_Line__c WHERE Shipment__c in:idsShip ]; //and SAP__c=false
            list<String> linesIDs= new list<String>();
            for(Shipment_Fee_Line__c Line:Lines){
                linesIDs.add(Line.id);
            }
            List<OrderItem> oiList = [SELECT ID,ItemStatus_Shipment__c,ShipServLineId__c FROM OrderItem WHERE ShipServLineId__c IN: linesIDs];
            Status_Datetime__c statusdate =new Status_Datetime__c();
            statusdate.Shipment__c=Lines[0].Shipment__c;
            statusdate.Status_Value__c='Confirmed';
            insert statusdate;
            list<Status_Datetime__c>  statusShip =  [SELECT Shipment__C,CREATEDDATE 
                                                     FROM Status_Datetime__c 
                                                     WHERE  Shipment__C in:idsShip 
                                                     and (Is_Ready_1__c = true or  Is_Ready_2__c = true)
                                                     ORDER BY Shipment__C, CREATEDDATE asc ];
            system.debug('imprimiendo Lines: '+Lines);
            system.debug('imprimiendo statusShip: '+statusShip);
            if(statusShip.size()!=0){
                for(Status_Datetime__c stad : statusShip )
                {
                    if(!ShipDate.containsKey(stad.Shipment__C))
                        ShipDate.put(stad.Shipment__C, stad.CREATEDDATE.formatGMT('yyyy-MM-dd'));
                }  
                for(Order o : lstOrders){
                    String Body = '';
                    try{
                        system.debug(' XXXX   RASTREO PROFIT ' + O.SHIPMENT__R.PROFIT__c );
                        Body = SendOrderSAP.setRequestHeader(o, fecha, ShipDate.get(o.Shipment__c) ); 
                        string bodyLines = SendOrderSAP.setRequestLines(Lines, o.Shipment__c,oiList);
                        if(bodyLines== null ){
                            Response__c R = new Response__c(Object__c = 'Order', Order__c = o.Id, Message__c = 'No se pueden mandar lineas de venta con SapServiceType que no empiezen con SP', Type__c = 'ERROR', Message_2__c = Body);
                            responses.add(R);
                            break;
                        }else{
                            Body += bodyLines;
                        }
                        Body += SendOrderSAP.setRequestFooter(o, Org);
                        System.debug('SOSAP REQ: ' + Body);
                        HttpResponse response = SendOrderSAP.sendRequest(Body);
                        //  sendRequest(Body);
                        SendOrderSAP.processResponse(response, o.Id, responses, Body);
                    }catch(Exception e){
                        Response__c R = new Response__c();
                        R.Object__c = 'Order';
                        R.Order__c = o.Id;
                        R.Message__c = e.getLineNumber()+': '+e.getMessage();
                        R.Type__c = 'ERROR';
                        R.Message_2__c = Body;
                        responses.add(R);
                    } 
                }      
                System.debug('SOSAP Responses: ' + responses.size());
                if(responses.size()>0){insert responses;}  
            }
            else{
                system.debug('¡ALERTA! el shipment  no se mando a SAP ya que no cuenta con statusDateTime o no cumple con las validaciones de la query');
            }
        }
        else{
            system.debug('lstOrders no cuenta con registros');
        }
    }
}