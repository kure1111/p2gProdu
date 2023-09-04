@isTest
global class ControlRoomSPMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://api-staging-control-room.pak2go.digital/api/v1/sales-force/shipments', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Authorization', 'KqyACw5uU2xlvTA2PeP+UkT3TlW44gSJ2mg4SDxOHOxG/f8tHtGpb8MSXyp+KnEkNqklRA==');
        res.setHeader('Content-Type','application/json;charset=UTF-8');
        res.setBody('{"msg":"success"}');
        res.setStatusCode(200);
        return res;
    }
}