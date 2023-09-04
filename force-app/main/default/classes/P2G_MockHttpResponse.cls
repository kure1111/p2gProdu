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
        return response;
    }    
}