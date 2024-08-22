public with sharing class P2G_guardarQuotePDF {
    public Quote quote {get;set;}
    ApexPages.StandardController con;
    
    public P2G_guardarQuotePDF(ApexPages.StandardController stdController){
        con = stdController;
        try 
        { 
            quote = [select Id, Name, Discount from Quote where id =: con.getRecord().id];
        } 
        catch(Exception ee){quote = new Quote();}
    }
    public PageReference savePdf()
    {
        try 
        {
            //obtenemos PDF
            PageReference pdf = Page.P2G_crearQuotePDF;
            pdf.getParameters().put('id',quote.Id);
            Blob body;
            if(!Test.isRunningTest()){
            	body = pdf.getContent();
            }else{
                body = Blob.valueOf('24314');
            }
            //guardar PDF
            ContentVersion cv = new ContentVersion();
            cv.Title = quote.Name+'.pdf';
            cv.PathOnClient = quote.Name+'.pdf';
            cv.VersionData = body;
            insert cv;
            
            // crear QuoteDocument
            QuoteDocument quoteDoc = new QuoteDocument();

            quoteDoc.QuoteId = quote.Id;
            quoteDoc.ContentVersionDocumentId = cv.Id;
            quoteDoc.Document = body;
            
            insert quoteDoc;
            
            //regresar a quote
            //uat  https://pak2gologistics--uat.sandbox.lightning.force.com/lightning/r/Quote/
            //prod https://pak2gologistics.lightning.force.com/lightning/r/Quote/
            String paginaQuote = 'https://pak2gologistics.lightning.force.com/lightning/r/Quote/'+quote.Id+'/view';
            PageReference pageQuote = new PageReference(paginaQuote); // URL de la página web
        	pageQuote.setRedirect(true);
            return pageQuote;
        } 
        catch(exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        return null;
    }
}