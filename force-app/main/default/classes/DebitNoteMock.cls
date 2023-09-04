@isTest
global class DebitNoteMock  implements HttpCalloutMock{
    //Esta clase se utiliza para el metodo uploadFiles y sendAWs

    global HTTPResponse respond(HTTPRequest req){

        //https://s3.us-east-1.amazonaws.com/associateddocs/Shipments/ShipmentsOtros/testDN.pdf
        System.assertEquals('callout:associateddocs/Shipments/ShipmentsOtros/testDN.pdf', req.getEndpoint());
        System.assertEquals('PUT', req.getMethod());
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');


        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Encoding', 'UTF-8');
        res.setHeader('Content-type', 'application/pdf');
        res.setHeader('Connection', 'keep-alive');
        res.setHeader('Date', formattedDateString);
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('ACL', 'public-read');
        res.setBody('JVBERi0xLjQKJeLjz9MKMyAwIG9iaiA8PC9Db2xvclNwYWNlWy9JbmRleGVkL0RldmljZVJHQiA1MSj/7QAAAAD/8gD/9AD/7wD/9QD76QCEegD/9wDVxgDn1gAdGwCckQCilwDh0QD//QDw3wA+OgDOvwCqngDEtgDbzABkXQD//wCBdwC2qQDv3gAzLwAjIACuo');
        res.setStatusCode(200);
        return res;
        
    }
}