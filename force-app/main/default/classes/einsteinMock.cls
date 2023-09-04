@isTest
global class einsteinMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://api.einstein.ai/v2/vision/ocr', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"');
        res.setBody('{"object":"predictresponse","probabilities":[{"probability":0.7645996,"label":"LICENCIA","boundingBox":{"minX":27,"minY":88,"maxX":335,"maxY":134},"attributes":{"pageNumber":"1","tableId":"None"}}],"task":"text"}');
        res.setStatusCode(200);
        return res;
    }
}