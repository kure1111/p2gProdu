public with sharing class NEU_Show_File
{
    public String contentType {get;set;}
    public ContentVersion record {get;set;}
    public String documentBase64 {get;set;}
    public String fileName {get;set;}
    public String url_doc {get;set;}

    public PageReference getDocumentBase64()
    {
        try
        {
            if(documentBase64==null)
            {
                Id idfile = ApexPages.currentPage().getParameters().get('id');

                String tipo_de_objeto_string = ''+ idfile.getsobjecttype();
                if(tipo_de_objeto_string != 'ContentVersion')
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The document viewer is only valid for Files'));
                    return null;
                }

                contentType =  ApexPages.currentPage().getParameters().get('contentType');

                record = [Select Id, Title, VersionData, FileExtension, ContentSize from ContentVersion where Id =:idfile];


                if(record != null)
                {
                    if(record.ContentSize < 1572864)//Maximum PDF file size BLOG URL for a Visualforce page rendered 1.5MB  1572864
                    {
                        documentBase64 = EncodingUtil.base64Encode(record.VersionData);

                        if(String.isEmpty(contentType))
                            contentType = 'application/octet-stream';//Default ContentType

                        fileName = record.Title;
                    }
                    else
                    {
                        PageReference pgReturnPage;
                        String returnUrl = Site.getBaseURL() +'/sfc/servlet.shepherd/version/download/'+ record.Id;
                        pgReturnPage = new PageReference(returnUrl);
                        pgReturnPage.setRedirect(true);
                        return pgReturnPage;
                    }
                }
            }
            return null;
        }
        catch(Exception e)
        {
            return null;
        }
    }
}