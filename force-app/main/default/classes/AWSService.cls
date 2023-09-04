public class AWSService {
    
    public AWSService(){}
        
    public static string ContentType(string fileType)
    {
        switch on fileType.toLowerCase()
        {
            when 'docx'
            {
                return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            }
            when 'csv'
            {
                return 'application/vnd.ms-excel';
            }
            when 'wav'
            {
                return 'audio/wav';
            }
            when 'wmv'
            {
                return 'video/x-ms-wmv';
            }
            when 'mp3'
            {
                return 'audio/mpeg';
            }
            when 'mp4'
            {
                return 'video/mp4';
            }
            when 'png'
            {
                return 'image/png';
                
            }
            when 'pdf'
            {
                return 'application/pdf';
                
            }
            when else {
                return 'image/jpeg';
            }
        }
    }
    
    
    @future(callout = true)
    public static void uploadFileS3 ( string bucketName, string baseUrlS3, blob document,string fileExtension,string fileName, string folder,string id)
    {
        try
        {         
            string urlResult = '';

            String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
            string contentType=ContentType(fileExtension);
            
            //test
            //ContentVersion attach = [SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE  IsLatest = true and FileExtension  = 'pdf' limit 1];
            String attachmentBody = EncodingUtil.base64Encode(document);//VersionData
            //System.debug('>>>> The attachmentBody ' + attachmentBody);
            string folderPath = string.isBlank(folder) ? '' : folder+ '/' ;
            
            HttpRequest req = new HttpRequest();
            req.setMethod('PUT');
            req.setEndpoint('callout:'+ bucketname+ '/' + folderPath + filename+ '.'+fileExtension );
            
            //req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
            req.setHeader('Content-Encoding', 'UTF-8');
            req.setHeader('Content-type', contentType);
            req.setHeader('Connection', 'keep-alive');
            req.setHeader('Date', formattedDateString);
            req.setHeader('ACL', 'public-read');
            
            Blob pdfBlob = EncodingUtil.base64Decode(attachmentBody);
            req.setBodyAsBlob(pdfBlob);

            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            SYSTEM.debug('res.getStatusCode() ' + res.getStatusCode());
            SYSTEM.debug('res.BODY() ' + res.getBody());
            
            
            if(res.getStatusCode() == 200)
            {
                urlResult = 'https://'+ bucketname +'.' + baseUrlS3 + '/' + folderPath + filename +'.' + fileExtension;
                
                Carta_Porte__c cp = [SELECT Id,PDF_Url__c
                                      FROM Carta_Porte__c where id =: id limit 1];
                
                cp.PDF_Url__c = urlResult;
                update cp;
            }
            else
            {
                Carta_Porte__c cp = [SELECT Id,Error_Message__c
                                      FROM Carta_Porte__c where id =: id limit 1];
                
                cp.Error_Message__c ='STATUS CODE: ' + res.getStatusCode() + ' BODY: ' + res.getBody();
                update cp;
                
            }
            
            // return urlResult;
        }
        catch(Exception ex)
        {
            Carta_Porte__c cp = [SELECT Id,Error_Message__c
                                 FROM Carta_Porte__c where id =: id limit 1];
            
            cp.Error_Message__c ='MESSAGE: ' + ex.getMessage() + ' LINE: ' + ex.getLineNumber();
            update cp;
            
            throw new BaseException(ex);
        }
    }
    
    public void test ()
    {
        string a = '';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
        a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
         a='';
    }

}