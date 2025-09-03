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
        return guardarPDF();
    }
    public PageReference redirectToEmailQuote() {
        try{
            //obtenemos PDF
            String ids = quote.Id;
            PageReference pdf = Page.P2G_crearQuotePDF;
            pdf.getParameters().put('id',quote.Id);
            Blob body;
            
            if(!Test.isRunningTest()){
            	body = pdf.getContentAsPDF();//pdf.getContent();
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
            QuoteDocument idDoc = [SELECT Id FROM QuoteDocument WHERE QuoteId =: quote.Id Limit 1];
            // Redirigir al usuario a la página de enviar correo electrónico en Lightning
            PageReference emailPage = new PageReference('/lightning/action/quick/Quote.SendEmail');
            emailPage.getParameters().put('objectApiName', 'Quote');
            emailPage.getParameters().put('context', 'RECORD_DETAIL');
            emailPage.getParameters().put('recordId', quote.Id);
            emailPage.getParameters().put('Attachfile', idDoc.Id);
            return emailPage;
        } 
        catch(exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
    }
    public PageReference guardarPDF(){
        try 
        {
            //obtenemos PDF
            String ids = quote.Id;
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
        	return null;
        }
    }
}