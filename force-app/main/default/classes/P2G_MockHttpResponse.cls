@isTest
global class P2G_MockHttpResponse implements HttpCalloutMock{
    Integer opc;
    global P2G_MockHttpResponse(Integer opcr){
        opc = opcr;
    }
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(opc == 1){        
            response.setBody('{"access_token":"abcd","gofof":"kvk"}');
            response.setStatusCode(200);         
        }
        if(opc == 2){        
            response.setBody('[{"source": {"plan": [{"date": "2023-03-27T21:00:00-06:00", "carrier": {"fiscal_code": "RCO 970529 F57", "company_name": "Recurso Confiable"}, "event_key": "ENTRANCE"}], "track": [], "seal_1": null, "seal_2": null, "ori_aux_1": "Planeador 1", "ori_aux_2": "Operador rcontrol", "ori_aux_3": null, "ori_aux_4": null, "ori_aux_5": null, "region_name": null, "location_name": "PAK2GO CEDIS 1", "location_equiv": ["1"]}, "destiny": [{"ETA": null, "plan": [{"date": "2023-03-27T21:00:00-06:00", "carrier": {"fiscal_code": "RCO 970529 F57", "company_name": "Recurso Confiable"}, "event_key": "ENTRANCE"}], "orden": 1, "track": [], "Reject": {"type": "", "cause": "", "status": false}, "dst_aux_1": null, "semaphore": "Con llegada a origen", "region_name": null, "activity_num": "9090", "location_name": "3PL1 CLOROX", "location_equiv": ["a0H4T000002N4Hy"]}], "stop_id": 58322499, "vehicle": {"eco": null, "plate": "mxb6707"}, "shipment": "9090", "tendering": null, "trailer_1": null, "trailer_2": null, "vehicle_type": "", "PDFCartaPorte": false, "supplier_name": "PAK2GO", "supply_chain_id": 17478013}]');
            response.setStatusCode(200);         
        }
        if(opc == 3){        
            response.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', 'http://tempuri.org/CreateInvoice');
    		response.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="http://tempuri.org/"><CreateInvoiceResponse>Creada Factura:43467C01-F0B9-447A-937B-11F928C1A672<CreateInvoiceResult>Monto Facturado: 2376.00</CreateInvoiceResult> </CreateInvoiceResponse>Invoice Status BU: Send to Sap, Invoice Status AU: Facturado</login></Body></Envelope>');
    		response.setStatusCode(200);         
        }
        if(opc == 4){
            response.setStatusCode(200);
            response.setBody('{"results":[{"geometry":{"location":{"lat":40.7128,"lng":-74.0060}}}]}' );
        }    
        if(opc == 5){
            response.setStatusCode(400);
            response.setBody('prueba de error');
        }
        if(opc == 6){
            PAK_ReporteVentas.Response r = new PAK_reporteVentas.Response();
        r.Id = 123;
        r.SucCte = 'Suc-Cte';
		r.Vendedor = 'Lorem ipsum';
		r.Ejecutivo = 'dolor sit';
		r.UsuarioFactura = 'amet consectetur';
		r.Codigo = 'CCUU1020';
		r.Cliente = 'COCINAS Y SUMINISTROS INDUSTRIALES SA DE CV';
		r.Fecha = '2026-02-01';
		r.Vencimiento = '2026-2-02';
		r.AcctName = 'FLETES- VENTAS-16%';
		r.Docto = 'Factura';
		r.Concepto_NC = 'Concepto NC';
		r.Documento = '42161';
		r.Referencia = 'FN-18-010022';
		r.Grupo = 'FLETES';
		r.ItemCode = 'FTN';
		r.Dscription = 'Flete Nacional';
		r.Rutas_Otros = 'Rutas/Otros';
		r.LineTotal = '7900';
		r.Costo = '123';
		r.CostoMayoreo = '123';
		r.Tipo_Producto = 'Tipo Producto';
		r.U_ID = '999';
		r.OcrCode3 = 'FLETES';
		r.LineNum = '0';
		r.U_Factura_Original = '123';
		r.U_NC = '01';
		r.U_Sustituye = '123';
		r.U_COMENT = '123';
		r.Canceled = 'No';
        r.Fh = Date.newInstance(2026, 2, 03);
        r.Fh2 = Date.newInstance(2026, 2, 04);
        r.Costo2 = 123.01;
        r.CostoMayoreo2 = 123.01;
        r.LineTotal2 = 0.00;
            List<PAK_ReporteVentas.Response> lista = new List<PAK_ReporteVentas.Response>{r};
            String json = JSON.serialize(lista);
			response.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        	request.setHeader('SOAPAction', 'http://tempuri.org/reporteVentas');
    		//response.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+ '<soapenv:Header/>' + '<soapenv:Body>' + '<tem:reporteVentasResult>' + 'Suc-Cte Concepto NC  Rutas/Otros  Tipo Producto' + '<tem:fechaInicial>' + 'inicio' + '</tem:reporteVentasResult>' + '</tem:reporteVentas>'+ ' </soapenv:Body>' + '</soapenv:Envelope>');
            response.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+ '<soapenv:Header/>' +'<soapenv:Body>' + 'http://schemas.xmlsoap.org/soap/envelope/' + '<tem:reporteVentasResponse>' + 'http://tempuri.org/'+ '<tem:reporteVentasResult>'+ json.escapeXml() + '</tem:reporteVentasResult>' + '</tem:reporteVentasResponse>' + ' </soapenv:Body>'+ '</soapenv:Envelope>');
            response.setStatusCode(200);
        }
        if(opc == 7){
            
            
			response.setHeader('Content-Type', 'text/xml;charset=utf-8');
        	request.setHeader('SOAPAction', 'http://tempuri.org/CreateSalesOrder');
    		response.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+ '<soapenv:Header/>' +'<soapenv:Body>' + 'http://schemas.xmlsoap.org/soap/envelope/' + '<tem:reporteVentasResponse>' + 'http://tempuri.org/'+ '<tem:reporteVentasResult>'+ 'Suc-Cte ' + 'Concepto NC ' + 'Rutas/Otros ' + 'Tipo Producto ' + '</tem:reporteVentasResult>' + '</tem:reporteVentasResponse>' + ' </soapenv:Body>'+ '</soapenv:Envelope>');
            response.setStatusCode(200);
        }        
        return response;
    }    
}