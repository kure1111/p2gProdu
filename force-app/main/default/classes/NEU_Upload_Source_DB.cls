public with sharing class NEU_Upload_Source_DB {
	private Source_DB__c o=null;
	ApexPages.StandardController con=null;
    public NEU_Upload_Source_DB(ApexPages.StandardController stdController)
    {
        if (!Test.isRunningTest())
            stdController.AddFields(new String[]{'Id','File_URL__c'});
        con=stdController;
        o=(Source_DB__c)con.getRecord();
    }
    public transient Blob mydocument{get;set;}
    public transient String mydocumentname{get;set;}

    public PageReference backtoview()
    {
    	return con.view();
    }
    public Pagereference upload()
    {
        if(String.IsNotEmpty(mydocumentName))
        {
            if(mydocumentName.tolowerCase().endsWith('.xlsx'))
            {
                try{
                	Document document1=new Document();
                	document1.Body=mydocument;
                	document1.Name=mydocumentname;
	                document1.AuthorId = UserInfo.getUserId();
			        List<Folder> sourcedbdirectory = [Select Id, Name from Folder where Name='Source DB'];
	                if(sourcedbdirectory.size()>0)
	                    document1.FolderId = sourcedbdirectory[0].Id;
                    insert document1;
                    o.File_URL__c='/servlet/servlet.FileDownload?file='+document1.Id;
                    return con.save();
                }
                catch (Exception e)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                }
            }
            else
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The file must be an xlsx file'));
        }
        else
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select an Excel document'));
        return null;
    }
}