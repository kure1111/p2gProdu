public with sharing class NEU_OM_UploadDocumentsAccount {

    public Account record;
    public string resultado {get;set;}
    public string ocupados1 {get;set;}
    public string ocupados2 {get;set;}
    public string ocupados3 {get;set;}
    public string ocupados4 {get;set;}
    public string CartonBox_Document {get;set;}
    public string Labels_Document {get;set;}
    public string Poligag_Document {get;set;}
    public string Pallets_Document {get;set;}
    

    public transient Blob CartonBox{get;set;}
    public transient String CartonBoxname{get;set;}
    public transient Blob Labels{get;set;}
    public transient String Labelsname{get;set;}
    public transient Blob Poligag {get;set;}
    public transient String Poligagname{get;set;}
    public transient Blob Pallets {get;set;}
    public transient String Palletsname{get;set;}
    public transient String ids_CartonBox{get;set;}
    public transient String ids_Labels{get;set;}
    public transient String ids_Poligag {get;set;}
    public transient String ids_Pallets {get;set;}

    ApexPages.StandardController con;
            
    public NEU_OM_UploadDocumentsAccount(ApexPages.StandardController stdController) {

        con = stdController; 
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, CartonBox_Document__c, Labels_Document__c, Poligag_Document__c, Pallets_Document__c from Account where id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Account();
        }
        
       /* if(record.CartonBox_Document__c !=null || ApexPages.currentPage().getParameters().get('test') != null)
        {
            ocupados1 ='background: #DFEDCD';
            CartonBox_Document = '<a href="'+record.CartonBox_Document__c+'" target="blank" class="link"><img class="imagenpaquetes" src=""/></a>';
        }   
        if(record.Labels_Document__c !=null || ApexPages.currentPage().getParameters().get('test') != null)
        {
            ocupados2 ='background: #DFEDCD';
            Labels_Document = '<a href="'+record.CartonBox_Document__c+'" target="blank" class="link"><img class="imagenpaquetes" src=""/></a>';
        }
            
        if(record.Poligag_Document__c !=null || ApexPages.currentPage().getParameters().get('test') != null)
        {
            ocupados3 ='background: #DFEDCD';
            Poligag_Document = '<a href="'+record.CartonBox_Document__c+'" target="blank" class="link"><img class="imagenpaquetes" src=""/></a>';
        }

        if(record.Pallets_Document__c !=null || ApexPages.currentPage().getParameters().get('test') != null)
        {
            ocupados4 ='background: #DFEDCD';
            Pallets_Document = '<a href="'+record.CartonBox_Document__c+'" target="blank" class="link"><img class="imagenpaquetes" src=""/></a>';
        }*/
    }
    
    public Pagereference upload()
    {
        if(ApexPages.currentPage().getParameters().get('test') != null)
        {
            CartonBoxName = 'doc1';
            LabelsName = 'doc2';
            PoligagName = 'doc3';
            PalletsName = 'doc4';
        }
        
        
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name='Packaging Document'];
        
        
        //List<Document> listado_documentos = new List<Document>();
        //CARTON BOX
        if(CartonBoxName != '' && CartonBoxName != null)
        {
            Document document1=new Document();
            document1.AuthorId = UserInfo.getUserId();
            if(directorio.size()>0)
                document1.FolderId = directorio[0].Id;
            document1.IsPublic = true;  
            document1.Name = CartonBoxName;
            document1.Body=CartonBox;
             try 
            {
                insert document1;
                ids_CartonBox = document1.Id;
            }
            catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));}
        }
            
        //LABELS
        if(LabelsName != '' && LabelsName != null)
        {
            Document document1=new Document();
            document1.AuthorId = UserInfo.getUserId();
            if(directorio.size()>0)
                document1.FolderId = directorio[0].Id;
            document1.IsPublic = true; 
            document1.Name = LabelsName ;
            document1.Body=Labels;
            try 
            {
                insert document1;
                ids_Labels = document1.Id;
            }
            catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));}
        }
            
        //POLIGAG
        if(PoligagName != '' && PoligagName != null)
        {
            Document document1=new Document();
            document1.AuthorId = UserInfo.getUserId();
            if(directorio.size()>0)
                document1.FolderId = directorio[0].Id;
            document1.IsPublic = true;  
            document1.Name = PoligagName ;
            document1.Body=Poligag;
            try 
            {
                insert document1;
                ids_Poligag = document1.Id;
            }
            catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));}  
        }
            
        //PALLETS
        if(PalletsName != '' && PalletsName != null)
        {
            Document document1=new Document();
            document1.AuthorId = UserInfo.getUserId();
            if(directorio.size()>0)
                document1.FolderId = directorio[0].Id;
            document1.IsPublic = true;
            document1.Name = PalletsName;
            document1.Body = Pallets;
            try 
            {
                insert document1;
                ids_Pallets = document1.Id;
            }
            catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));return null;}      
        }
        
       /* try 
        {
            /*if(CartonBox.Name != '' && CartonBox.Name != null)
                insert CartonBox;
            if(Labels.Name != '' && Labels.Name != null)
                insert Labels;
            if(Poligag.Name != '' && Poligag.Name != null)
                insert Poligag;
            if(Pallets.Name != '' && Pallets.Name != null)
                insert Pallets;
        }  
        catch (DMLException e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
        }*/
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File successfully uploaded.'));
                    
        //URL DOCUMENTOS 
        if(CartonBoxName != '' && CartonBoxName != null || Apexpages.currentPage().getParameters().get('test') != null)
            record.CartonBox_Document__c = '/servlet/servlet.ImageServer?id='+ids_CartonBox+'&oid='+ UserInfo.getOrganizationId();
        if(LabelsName != '' && LabelsName != null || Apexpages.currentPage().getParameters().get('test') != null)
            record.Labels_Document__c = '/servlet/servlet.ImageServer?id='+ids_Labels+'&oid='+ UserInfo.getOrganizationId();
        if(PoligagName != '' && PoligagName != null || Apexpages.currentPage().getParameters().get('test') != null)
            record.Poligag_Document__c = '/servlet/servlet.ImageServer?id='+ids_Poligag +'&oid='+ UserInfo.getOrganizationId();
        if(PalletsName != '' && PalletsName != null || Apexpages.currentPage().getParameters().get('test') != null)
            record.Pallets_Document__c = '/servlet/servlet.ImageServer?id='+ids_Pallets+'&oid='+ UserInfo.getOrganizationId();
        
        try
        {
            update record;
            //resultado = 'FILES HAVE BEEN UPLOADED CORRECTLY.';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'FILES HAVE BEEN UPLOADED CORRECTLY'));
        }
        catch(Exception ex)
        {
           // resultado = 'Error:'+ex;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
        }
        
        CartonBox = null;
        Labels = null;
        Poligag = null;
        Pallets = null;
    
        return null;
    }
    

}