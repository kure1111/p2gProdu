public with sharing class NEU_BL_save_pdf
{
    public Shipment__c record {get;set;}
    public string language {get; set;}

    public Document documento_asociado
    {
        get
        {
            if (documento_asociado == null)
                documento_asociado = new Document();
            return documento_asociado;
        }
        set;
    }

    ApexPages.StandardController con;

    public NEU_BL_save_pdf(ApexPages.StandardController stdController)
    {
        con = stdController;

        System.debug('id...' + con.getRecord().id);
        try
        {
            record = [select Id, Name, Account_for__c
            from Shipment__c where id =: con.getRecord().id];
        }
        catch(Exception ee){record = new Shipment__c();}
    }

    private List<SelectOption> newcategories=null;
    public  List<SelectOption> getnewcategories()
    {
        if(newcategories==null)
        {
            newcategories=new List<SelectOption>();
            //newcategories.add(new SelectOption('EN','EN'));
            //newcategories.add(new SelectOption('ES','ES'));
            language ='EN';
        }
        return newcategories;
    }

    public void refresh_data()
    {
        try
        {
            update record;
        }
        catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex+' ('+ex.getLineNumber()+')'));}
    }

    public PageReference crear()
    {
        PageReference pdf = null;

        /*
        if(language != 'FFWD' && language != 'FFWD2')
            pdf = Page.NEU_Import_Export_Quote_pdf;
        else if(language == 'FFWD')
        {
            pdf = Page.NEU_Order_Confirmation_IE_pdf;
            pdf.getParameters().put('services_charges','true');
        }
        else
        {
            pdf = Page.NEU_Order_Confirmation_IE_details_pdf;
            pdf.getParameters().put('services_charges','true');
        }
        */

        pdf = Page.NEU_BL_pdf;
        pdf.getParameters().put('id',record.Id);

        Blob body;

        try
        {
            body = pdf.getContent();
        }
        catch (VisualforceException e) { body = Blob.valueOf('Some Text');}

        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
        documento_asociado.Body = body;
        documento_asociado.Name = record.name +'HBL.pdf';
        documento_asociado.AuthorId = UserInfo.getUserId();
        if(directorio.size()>0)
            documento_asociado.FolderId = directorio[0].Id;
        documento_asociado.IsPublic = true;


        try
        {
            if(documento_asociado.Name != '' && documento_asociado.Name != null)
                insert documento_asociado;
        }
        catch (DMLException e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
        }


        Associated_Document__c new_document = new Associated_Document__c();

        new_document.Account__c = record.Account_for__c;
        new_document.Name = 'HBL_'+ record.Name +'.pdf';
        new_document.Shipment__c = record.Id;

        /*
        if(record.Supply_Project_Name__r.Name != null)
            new_document.Supply_Project__c =record.Supply_Project_Name__c;
        */

        new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId();

        try
        {
            insert new_document;
            return new PageReference('/'+record.Id);
        }
        catch(Exception ex){return null;}

    }

}