/**
 * Created by aserrano on 14/12/2017.
 */

public with sharing class NEU_Air_Manifest_save_pdf
{
    public Air_Waybill__c record {get;set;}
    public string language {get;set;}
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

    public NEU_Air_Manifest_save_pdf(ApexPages.StandardController stdController)
    {
        con = stdController;

        try
        {
            record = [SELECT Id, Name, Shipment__r.Account_for__r.Name  FROM Air_Waybill__c WHERE id = :con.getRecord().Id];

        }
        catch(Exception ee){record = new Air_Waybill__c();}

    }

    private List<SelectOption> newcategories=null;
    public  List<SelectOption> getnewcategories()
    {
        if(newcategories==null)
        {
            newcategories=new List<SelectOption>();
            newcategories.add(new SelectOption('EN','EN'));
            newcategories.add(new SelectOption('ES','ES'));
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
        if(language =='EN')
        {
            pdf = Page.NEU_Air_Manifest_pdf_ES; //CAMBIAR POR INGLES
        }
        else
        {
            pdf = Page.NEU_Air_Manifest_pdf_ES;
        }



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
        documento_asociado.Name = record.name +'AirManifest.pdf';
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

        new_document.Account__c = record.Shipment__r.Account_for__c;
        new_document.Name = 'AirManifest_'+ record.Name +'.pdf';
        new_document.Shipment__c = record.Id;

        new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId();

        try
        {
            insert new_document;
            return new PageReference('/'+record.Id);
        }
        catch(Exception ex){return null;}

    }
}