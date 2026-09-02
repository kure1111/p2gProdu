@IsTest
public class P2G_PakQuoteToCifidTest {
    private class PakQuoteToCifidMock implements WebServiceMock {

        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {            
            PakQuoteToCifid.quoteFromPakResponse_element resp =
                new PakQuoteToCifid.quoteFromPakResponse_element();

            PakQuoteToCifid.estatus status = new PakQuoteToCifid.estatus();
            status.code = '200';
            status.message = 'OK';
            status.impakQuote = 'IMP-0001';

            resp.result = status;

            response.put('response_x', resp);
        }
    }
    
    @IsTest
    static void testQuoteFromPak() {        
        Test.setMock(WebServiceMock.class, new PakQuoteToCifidMock());

        PakQuoteToCifid.Quote quote = new PakQuoteToCifid.Quote();
        quote.quoteName = 'Test Quote';
        quote.accountFor = 'Account Test';
        quote.contacto = 'Contacto Test';
        quote.customerType = 'Cliente';
        quote.moneda = 'USD';
        quote.incoterm = 'FOB';
        quote.freigthMode = 'Air';
        quote.serviceType = 'Import';
        quote.quoteStatus = 'New';
        quote.originAddress = 'Origen';
        quote.destinationAddress = 'Destino';
        quote.ETD = Date.today();
        quote.ETA = Date.today().addDays(10);
        
        PakQuoteToCifid.Pak_Quote service = new PakQuoteToCifid.Pak_Quote();

        Test.startTest();
        PakQuoteToCifid.estatus result = service.quoteFromPak(quote);
        Test.stopTest();
    }

}