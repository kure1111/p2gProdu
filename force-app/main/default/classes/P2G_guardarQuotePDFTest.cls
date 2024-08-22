@isTest
public class P2G_guardarQuotePDFTest {
	@isTest(SeeAllData=true)
    public static void P2G_guardarQuotePDFTest(){
        QuoteLineItem quoteLine = [SELECT Id, QuoteId FROM QuoteLineItem LIMIT 1];
        Quote quote = new Quote();
        quote.Id = quoteLine.QuoteId;
         Test.startTest();
         	ApexPages.StandardController sc = new ApexPages.StandardController(quote);
        	P2G_crearQuotePDF crea = new P2G_crearQuotePDF(sc);
        	PageReference pdf = Page.P2G_crearQuotePDF;
            pdf.getParameters().put('id',quote.Id);
            Blob body = Blob.valueOf('24314');
        	P2G_guardarQuotePDF guardar = new P2G_guardarQuotePDF(sc);
        	guardar.savePdf();
         Test.stopTest();
    }
}