public class NEU_MD_Associated_Documents_old
{
    public  List<others_document_s> List_others_documents = null;
    public  List<others_document_s> List_personal_documents = null;
    public string tipo_documento_id {get;set;}
    public boolean estoy_en_site{get;set;}
    public Shipment__c shipment_reference{get;set;}
    public string display_buttons1
    {
        get
        {
            if (display_buttons1 == null)
                display_buttons1 = '';
            return display_buttons1;
        }
        set;
    }

    public string display_buttons2
    {
        get
        {
            if (display_buttons2 == null)
                display_buttons2 = 'none';
            return display_buttons2;
        }
        set;
    }

    public string url_base
    {
        get
        {
            if (url_base == null)
            {
                url_base = '';
                url_base = ApexPages.currentPage().getParameters().get('url_int');
            }
            return url_base;
        }
        set;
    }

    public string id_cabecera
    {
        get
        {
            if (id_cabecera == null)
                id_cabecera = ApexPages.currentPage().getParameters().get('id');
            return id_cabecera;
        }
        set;
    }

    public NEU_MD_Associated_Documents_old()
    {
        estoy_en_site = false;
        List<User> usuario_logueado = [select Id, Name from user where id=: UserInfo.getUserId()];
        if(usuario_logueado  != null && usuario_logueado.size()> 0)
        {
            if(usuario_logueado[0].Name == 'Neurored')//----cambiar esto luego
                estoy_en_site = true;

        }

        List<Shipment__c> Shipment = [select Id,Name,    Number__c, CreatedBy.Email, LastModifiedBy.Email, Supplier_Account__c , Supplier_Account__r.Name, Nature_Merchandise__c, Container_Type__c, Container_Type__r.Name, Account_Shipment_Reference__c from Shipment__c where id =: ApexPages.currentPage().getParameters().get('id')];
        if(Shipment != null && Shipment.size()>0)
            shipment_reference = Shipment[0];

        List<Shipment_Program__c> query_Shipment_Program = [select Id, Name, Files_Account_Owner__c  from Shipment_Program__c where Id =: ApexPages.currentPage().getParameters().get('id')];
        if(query_Shipment_Program != null && query_Shipment_Program.size()>0)
            if(query_Shipment_Program[0].Files_Account_Owner__c == null)
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: the field "Files Account Owner" is empty'));
    }

    public class others_document_s
    {
        //public Document documento_asociado{get; set;}
        public String Document_Type {get; set;}
        public String Document_Description {get; set;}
        public String Document_Reference {get; set;}
        public String clase_documento {get; set;}
        public String clase_documento2 {get; set;}
        public String Document_Type_Id {get; set;}
        public transient Blob documento_asociado{get;set;}
        public transient String documento_asociadoName{get;set;}
        public String document_insert_Id {get; set;}
        public boolean ya_hay_uno_del_mismo_tipo {get; set;}
        public boolean available_community {get;set;}

        public others_document_s(/*Document documento_asociado,*/ String Document_Type,  String Document_Description , String Document_Reference, String clase_documento, String clase_documento2, String Document_Type_Id, Blob documento_asociado, String documento_asociadoName, boolean ya_hay_uno_del_mismo_tipo, boolean available_community)
        {
            //this.documento_asociado=documento_asociado;
            this.Document_Type=Document_Type;
            this.Document_Description=Document_Description;
            this.Document_Reference=Document_Reference;
            this.clase_documento=clase_documento;
            this.clase_documento2=clase_documento2;
            this.Document_Type_Id=Document_Type_Id;
            this.documento_asociado=documento_asociado;
            this.documento_asociadoName=documento_asociadoName;
            this.ya_hay_uno_del_mismo_tipo=ya_hay_uno_del_mismo_tipo;
            this.available_community = available_community;
        }
    }

    /* public class Personal_document_s
    {
            public Document documento_asociado{get; set;}
            public String Document_Type {get; set;}
            public String Document_Description {get; set;}
            public String Document_Reference {get; set;}
            public String clase_documento {get; set;}
            public String clase_documento2 {get; set;}

            public Personal_document_s(Document documento_asociado, String Document_Type,  String Document_Description , String Document_Reference, String clase_documento, String clase_documento2 )
            {
                this.documento_asociado=documento_asociado;
                this.Document_Type=Document_Type;
                this.Document_Description=Document_Description;
                this.Document_Reference=Document_Reference;
                this.clase_documento=clase_documento;
                this.clase_documento2=clase_documento2;
            }
    }*/
    public List<others_document_s> getList_personal_documents()
    {
        if(List_personal_documents == null)
        {
            List_personal_documents =new List<others_document_s>();

            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Associated_Document__c.Document_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            integer contador = 1;
            //para saber si ese tipo de documento ya hya uno
            id tipo_de_objeto = ApexPages.currentPage().getParameters().get('id');

            string tipo_de_objeto_string = string.valueof(tipo_de_objeto.getSobjectType());
            tipo_de_objeto_string = tipo_de_objeto_string.replace('NEUEBUSCM__','');
            system.debug('hola '+ tipo_de_objeto_string);
            List<Associated_Document__c> listado_documentos_asociados = null;
            if(tipo_de_objeto_string == 'Claim__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Claim__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Shipment_Consolidation_Data__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Shipment_Consolidation_Data__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Transport_Packaging_Data__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Shipment_Packaging_Consolidation_Data__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Shipment__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Shipment__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Supply_Project__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Supply_Project__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Shopping_Cart__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Shopping_Cart__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Supplier_Quote__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Supplier_Quote__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Customer_Quote__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Import_Export_Quote__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Shipment_Program__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Consolidation_Program__c  =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Invoice__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Invoice__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Account')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Account__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            else if(tipo_de_objeto_string == 'Shipment_Disbursement__c')
            {
                listado_documentos_asociados = [select id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Available_for_Community__c from Associated_Document__c where Shipment_Disbursement__c =: ApexPages.currentPage().getParameters().get('id') order by CreatedDate desc];
            }
            boolean existe_del_mismo_tipo = false;
            for( Schema.PicklistEntry f : ple)
            {
                //options.add(new SelectOption(f.getValue(),f.getValue()));
                //Document documento_asociado_new = new Document();
                Blob  documento_asociado_new;
                if(listado_documentos_asociados != null && listado_documentos_asociados.size()>0)
                {
                    for(Associated_Document__c ad: listado_documentos_asociados)
                    {
                        if(ad.Document_Type__c == f.getValue())
                        {
                            existe_del_mismo_tipo = true;
                            List_personal_documents.add(new others_document_s(/*documento_asociado_new,*/ f.getValue(),(ad.Document_Description__c != null ? ad.Document_Description__c : ''),(ad.Document_Reference__c != null ? ad.Document_Reference__c :''),f.getValue().replace(' ','')+contador, contador+f.getValue()+contador, f.getValue().replace(' ',''), documento_asociado_new, '', true, ad.Available_for_Community__c));
                            break;
                        }
                    }
                    if(existe_del_mismo_tipo == false)
                        List_personal_documents.add(new others_document_s(/*documento_asociado_new,*/ f.getValue(),'','',f.getValue().replace(' ','')+contador, contador+f.getValue()+contador, f.getValue().replace(' ',''), documento_asociado_new, '', false, false));

                }
                else
                        List_personal_documents.add(new others_document_s(/*documento_asociado_new,*/ f.getValue(),'','',f.getValue().replace(' ','')+contador, contador+f.getValue()+contador, f.getValue().replace(' ',''), documento_asociado_new, '', false, false));

                existe_del_mismo_tipo = false;
                contador ++;
            }
        }

        return List_personal_documents;
    }

    //---------------------
    public void Upload_Document()
    {
        boolean todo_correcto = true;
        Document document1=new Document();
        Attachment attach = new Attachment();
        string texto_email = '';
        if(shipment_reference != null)
            texto_email +='Please see bellow the documents just uploaded on shipment '+ shipment_reference.Name+':';
        else
                texto_email +='Please see bellow the documents just uploaded on shipment :';
        texto_email +='\n';

        if(tipo_documento_id != null && tipo_documento_id != '')
        {
            for(others_document_s od: List_personal_documents)
            {
                if(od.Document_Type == tipo_documento_id)
                {
                    if(od.documento_asociado != null)
                    {
                        List<Folder> directorio = new List<Folder>();
                        directorio = [Select Id, Name from Folder where Name =: tipo_documento_id];
                        if(directorio.size()<1)
                        {
                            directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
                        }

                        if(od.documento_asociadoName != '' && od.documento_asociadoName != null)
                        {
                            //------------------------
                            document1=new Document();
                            document1.Body=od.documento_asociado;
                            document1.Name=od.documento_asociadoName;
                            document1.AuthorId = UserInfo.getUserId();
                            texto_email +=od.documento_asociadoName+'\n';
                            //-----------------------
                            //od.documento_asociado.AuthorId = UserInfo.getUserId();
                            if(directorio.size()>0)
                                document1.FolderId = directorio[0].Id;
                            //  od.documento_asociado.FolderId = directorio[0].Id;
                            //od.documento_asociado.IsPublic = true;
                            document1.IsPublic = true;

                            if(tipo_documento_id == 'Acuse')
                            {
                                attach.Body = od.documento_asociado;
                                attach.Name = od.documento_asociadoName;
                                attach.ParentId = ApexPages.currentPage().getParameters().get('id');
                                attach.OwnerId = UserInfo.getUserId();
                            }
                        }

                        try
                        {
                            if(od.documento_asociadoName != '' && od.documento_asociadoName != null && od.documento_asociado != null)
                            {
                                insert document1;

                                if(tipo_documento_id == 'Acuse')
                                    insert attach;
                            }
                            else
                            {
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                                todo_correcto = false;
                            }
                        }
                        catch (DMLException e)
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                            todo_correcto = false;

                        }

                        //-------------------------------
                        if(todo_correcto == true)
                        {
                            List<Claim__c> claims = null;
                            List<Shipment_Consolidation_Data__c> Shipment_Consolidation_Data = null;
                            List<Transport_Packaging_Data__c> Transport_Packaging_Data = null;
                            List<Shipment__c> Shipment = null;
                            List<Supply_Project__c> Supply_Project = null;
                            List<Shopping_Cart__c> Shopping_Cart = null;
                            List<Supplier_Quote__c> Supplier_Quote = null;
                            List<Customer_Quote__c> Customer_Quote = null;
                            List<Shipment_Program__c> Shipment_Program = null;
                            List<Invoice__c> invoices = null;
                            List<Shipment_Consolidation_Data__c> shipments_import_export = null;
                            List<Account> cuentas = null;
                            List<Shipment_Disbursement__c> Shipment_Disbursement = null;

                            id tipo_de_objeto = ApexPages.currentPage().getParameters().get('id');
                            string tipo_de_objeto_string = string.valueof(tipo_de_objeto.getSobjectType());
                            tipo_de_objeto_string = tipo_de_objeto_string.replace('NEUEBUSCM__','');

                            if(tipo_de_objeto_string == 'Claim__c')
                                claims = [select Id, Name, Shopping_Cart__c, Shipment__c, Supply_Project__c, Customer__c from Claim__c where id =: ApexPages.currentPage().getParameters().get('id')];
                            else if(tipo_de_objeto_string == 'Shipment_Consolidation_Data__c')
                                Shipment_Consolidation_Data = [select Id,Name, Import_Export_Quote__c, Shipment__c, Shopping_Cart__c, Supplier_Quote__c,Import_Export_Quote__r.Account_for__c, Shipment__r.Account_for__c, Shopping_Cart__r.Customer__c, Supplier_Quote__r.Customer__c from Shipment_Consolidation_Data__c where id =: ApexPages.currentPage().getParameters().get('id') ];
                            else if(tipo_de_objeto_string == 'Transport_Packaging_Data__c')
                                Transport_Packaging_Data = [select Id, Name,Shipment__c,Transporter__c,Shipment__r.Account_for__c  from Transport_Packaging_Data__c where id =: ApexPages.currentPage().getParameters().get('id')];
                            else if(tipo_de_objeto_string == 'Shipment__c')
                            {
                                Shipment = [select Id,Name, Account_for__c from Shipment__c where id =: ApexPages.currentPage().getParameters().get('id')];
                                shipments_import_export =[select id, Name, Import_Export_Quote__c from Shipment_Consolidation_Data__c where Shipment__c =:  ApexPages.currentPage().getParameters().get('id')];
                            }
                            else if(tipo_de_objeto_string == 'Supply_Project__c')
                                Supply_Project = [select Id, Name,Customer__c  from Supply_Project__c where id =: ApexPages.currentPage().getParameters().get('id')];
                            else if(tipo_de_objeto_string == 'Shopping_Cart__c')
                                Shopping_Cart = [select Id, Name, Customer__c from Shopping_Cart__c where id =: ApexPages.currentPage().getParameters().get('id')];
                            else if(tipo_de_objeto_string == 'Supplier_Quote__c')
                                Supplier_Quote = [select Id, Name,Customer__c, Supplier__c,Supply_Project__c,Supplier_Request_RFP__c  from Supplier_Quote__c where id =: ApexPages.currentPage().getParameters().get('id')];
                            else if(tipo_de_objeto_string == 'Customer_Quote__c')
                                Customer_Quote = [select Id, Name, Account_for__c, Supply_Project_Name__c  from Customer_Quote__c where id =: ApexPages.currentPage().getParameters().get('id')];
                            else if(tipo_de_objeto_string == 'Shipment_Program__c')
                                Shipment_Program = [select Id, Name, Files_Account_Owner__c  from Shipment_Program__c where id =: ApexPages.currentPage().getParameters().get('id')];
                            else if(tipo_de_objeto_string == 'Invoice__c')
                                invoices = [select Id, Name, Account__c, Import_Export_Quote_Order__c from Invoice__c where id =: ApexPages.currentPage().getParameters().get('id')];
                            else if(tipo_de_objeto_string == 'Account')
                                cuentas = [select Id, Name  from Account where id =: ApexPages.currentPage().getParameters().get('id')];
                            else if(tipo_de_objeto_string == 'Shipment_Disbursement__c')
                                Shipment_Disbursement = [select Id, Name, Shipment__c, Account__c from Shipment_Disbursement__c where id =: ApexPages.currentPage().getParameters().get('id')];
                            Associated_Document__c new_document= new Associated_Document__c();
                            if(od.documento_asociadoName != '' && od.documento_asociadoName != null)
                            {
                                new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+document1.Id+'&oid=' + UserInfo.getOrganizationId();
                                string nombredeldocumento = od.documento_asociadoName;
                                Integer indiceDePunto = nombredeldocumento.indexOf('.');
                                new_document.Name=nombredeldocumento.substring(0, indiceDePunto);

                            }

                            new_document.Available_for_Community__c = od.available_community;
                            new_document.Type__c = 'Document';
                            new_document.Document_Reference__c=od.Document_Reference;
                            new_document.Document_Description__c = od.Document_Description;
                            new_document.Document_Type__c=tipo_documento_id;

                            if(Shopping_Cart != null && Shopping_Cart.size() > 0)
                            {
                                new_document.Account__c = Shopping_Cart[0].Customer__c;
                                new_document.Shopping_Cart__c =Shopping_Cart[0].Id;
                            }
                            else if(Supplier_Quote != null && Supplier_Quote.size() > 0)
                            {
                                new_document.Account__c = Supplier_Quote[0].Supplier__c;
                                new_document.Supplier_Quote__c =Supplier_Quote[0].Id;
                                new_document.Supplier_Request_RFP__c =Supplier_Quote[0].Supplier_Request_RFP__c;
                                new_document.Supply_Project__c =Supplier_Quote[0].Supply_Project__c;
                            }
                            else if(Customer_Quote != null && Customer_Quote.size() > 0)
                            {
                                new_document.Account__c = Customer_Quote[0].Account_for__c;
                                new_document.Import_Export_Quote__c=Customer_Quote[0].Id;
                                if(Customer_Quote[0].Supply_Project_Name__c != null)
                                    new_document.Supply_Project__c =Customer_Quote[0].Supply_Project_Name__c;
                            }
                            else if(Shipment_Program != null && Shipment_Program.size() > 0)
                            {
                                new_document.Account__c = Shipment_Program[0].Files_Account_Owner__c;
                                new_document.Consolidation_Program__c=Shipment_Program[0].Id;

                            }
                            else if(Supply_Project != null && Supply_Project.size() > 0)
                            {
                                new_document.Account__c = Supply_Project[0].Customer__c;
                                new_document.Supply_Project__c =Supply_Project[0].Id;
                            }
                            else if(Shipment != null && Shipment.size() > 0)
                            {
                                new_document.Account__c = Shipment[0].Account_for__c;
                                new_document.Shipment__c=Shipment[0].Id;
                                if(shipments_import_export != null && shipments_import_export.size()==1)
                                    new_document.Import_Export_Quote__c = shipments_import_export[0].Import_Export_Quote__c;
                            }
                            else if(Transport_Packaging_Data != null && Transport_Packaging_Data.size() > 0)
                            {
                                new_document.Account__c = Transport_Packaging_Data[0].Shipment__r.Account_for__c;
                                new_document.Shipment__c=Transport_Packaging_Data[0].Shipment__c;
                                new_document.Shipment_Packaging_Consolidation_Data__c =Transport_Packaging_Data[0].Id;

                            }
                            else if(Shipment_Consolidation_Data != null && Shipment_Consolidation_Data.size() > 0)
                            {
                                if(Shipment_Consolidation_Data[0].Shopping_Cart__c != null)
                                {
                                    new_document.Shopping_Cart__c =Shipment_Consolidation_Data[0].Shopping_Cart__c;
                                    new_document.Account__c = Shipment_Consolidation_Data[0].Shopping_Cart__r.Customer__c;
                                }
                                if(Shipment_Consolidation_Data[0].Shipment__c != null)
                                {
                                    new_document.Shipment__c=Shipment_Consolidation_Data[0].Shipment__c;
                                    new_document.Account__c = Shipment_Consolidation_Data[0].Shipment__r.Account_for__c;
                                }
                                if(Shipment_Consolidation_Data[0].Supplier_Quote__c != null)
                                {
                                    new_document.Supplier_Quote__c =Shipment_Consolidation_Data[0].Supplier_Quote__c;
                                    new_document.Account__c = Shipment_Consolidation_Data[0].Supplier_Quote__r.Customer__c;
                                }
                                if(Shipment_Consolidation_Data[0].Import_Export_Quote__c != null)
                                {
                                    new_document.Import_Export_Quote__c=Shipment_Consolidation_Data[0].Import_Export_Quote__c;
                                    new_document.Account__c = Shipment_Consolidation_Data[0].Import_Export_Quote__r.Account_for__c;
                                }
                                new_document.Shipment_Consolidation_Data__c =Shipment_Consolidation_Data[0].Id;

                            }
                            else if(invoices != null && invoices.size() > 0)
                            {
                                new_document.Account__c = invoices[0].Account__c;
                                if(invoices[0].Import_Export_Quote_Order__c != null)
                                    new_document.Import_Export_Quote__c= invoices[0].Import_Export_Quote_Order__c;
                                new_document.Invoice__c = invoices[0].Id;
                            }
                            else if(claims != null && claims.size() > 0)
                            {
                                new_document.Account__c = claims[0].Customer__c;
                                if(claims[0].Shopping_Cart__c != null)
                                    new_document.Shopping_Cart__c =claims[0].Shopping_Cart__c;
                                if(claims[0].Shipment__c != null)
                                    new_document.Shipment__c=claims[0].Shipment__c;
                                if(claims[0].Supply_Project__c != null)
                                    new_document.Supply_Project__c =claims[0].Supply_Project__c;
                                new_document.Claim__c=claims[0].Id;
                            }
                            else if(cuentas != null && cuentas.size() > 0)
                            {
                                new_document.Account__c = cuentas[0].Id;
                            }
                            else if(Shipment_Disbursement != null && Shipment_Disbursement.size() > 0)
                            {
                                if(Shipment_Disbursement[0].Account__c != null)
                                    new_document.Account__c = Shipment_Disbursement[0].Account__c;
                                if(Shipment_Disbursement[0].Shipment__c != null)
                                    new_document.Shipment__c = Shipment_Disbursement[0].Shipment__c;
                                new_document.Shipment_Disbursement__c = Shipment_Disbursement[0].Id;
                            }

                            try
                            {
                                insert new_document;
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'Document Uploaded Correctly'));

                                //ACUSE SHIPMENT
                                if(new_document.Document_Type__c == 'Acuse')
                                {
                                    List<Shipment__c> shipment_to_update = [select Id, Name, VERIFY_ACUSE_SAP__c, Date_Verify_Acuse_SAPTxt__c
                                    from Shipment__c where Id =: ApexPages.currentPage().getParameters().get('id')];
                                    if(shipment_to_update.size() > 0)
                                    {
                                        shipment_to_update[0].VERIFY_ACUSE_SAP__c = true;
                                        shipment_to_update[0].Date_Verify_Acuse_SAPTxt__c = system.now();

                                        update shipment_to_update;
                                    }
                                }

                                // od.Document_Reference = '';
                                // od.Document_Description = '';
                                od.ya_hay_uno_del_mismo_tipo = true;
                            }
                            catch(Exception e)
                            {
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+e));todo_correcto = false;
                            }

                            //aviso de que se a subido algo desde el sitio publico
                            if(estoy_en_site == true && shipment_reference != null )
                            {
                                String estilo_email = '';
                                estilo_email += 'body{width:100%; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
                                estilo_email += 'p{margin:0; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
                                estilo_email += '.user_name{font-weight:bold;}';

                                string description_task = texto_email;
                                texto_email +='If you want to see these documents uploaded <a href="https://login.salesforce.com/'+shipment_reference.Id+'"> https://login.salesforce.com/'+ shipment_reference.Id +'</a>';
                                description_task +='If you want to see these documents uploaded https://login.salesforce.com/'+shipment_reference.Id;
                                Map<String, String> listado_receptores = new Map<String, String>();
                                listado_receptores.put('oscar@neurored.com','oscar@neurored.com');
                                //incluir el creador
                                listado_receptores.put(shipment_reference.CreatedBy.Email,shipment_reference.CreatedBy.Email);

                                //el ultimo que lo modifica
                                listado_receptores.put(shipment_reference.LastModifiedBy.Email,shipment_reference.LastModifiedBy.Email);

                                //el que envio el correo
                                List<Task> listado_tareas = [select Id, OwnerId, Owner.Email from Task where Send_Emails__c =: true and WhatId =: shipment_reference.Id];
                                if(listado_tareas != null && listado_tareas.size()>0)
                                {
                                    for(Task t: listado_tareas)
                                    {
                                        if(t.Owner.Email != null)
                                            listado_receptores.put(t.Owner.Email, t.Owner.Email);
                                    }
                                }
                                List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                mail.setToAddresses(listado_receptores.values());

                                mail.setSenderDisplayName('Neurored');
                                mail.setSubject('Uploaded Document in Shipment '+shipment_reference.Name);

                                mail.setBccSender(false);
                                mail.setUseSignature(false);
                                mail.setCharset('UTF-8');
                                mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(texto_email != null ? texto_email.replace('\n','<br/>') : '')+'<br/></body></html>');
                                theEmails.add(mail);
                                List<Messaging.Email> allMails = new List<Messaging.Email>();
                                for(Integer j = 0; j < theEmails.size(); j++)
                                {
                                    allMails.add(theEmails.get(j));
                                }

                                try
                                {
                                    Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
                                    Task new_task_account = new Task();
                                    new_task_account.ActivityDate = system.today();
                                    new_task_account.Subject = 'Uploaded Document in Shipment '+shipment_reference.Name;
                                    new_task_account.Status = 'Completed';
                                    new_task_account.Type = 'Email';
                                    new_task_account.OwnerId = UserInfo.getUserId();
                                    new_task_account.WhatId = shipment_reference.Id;
                                    //  new_task_account.Send_Emails__c = true;
                                    new_task_account.Priority = 'Normal';
                                    string descripcion_email = (description_task != null ? description_task  :'');
                                    new_task_account.Description = descripcion_email;
                                    insert new_task_account;
                                }
                                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}
                            }

                        }
                        //------------------------------------

                    }
                }
            }

            tipo_documento_id = null;
        }
    }
    //--------------------

    public List<others_document_s> getList_others_documents()
    {
        if(List_others_documents == null)
        {
            List_others_documents=new List<others_document_s>();
            //Document documento_asociado_new = new Document();
            Blob documento_asociado_new;
            List_others_documents.add(new others_document_s(/*documento_asociado_new,*/ 'Other','','','document1', '1document1','', documento_asociado_new, '', false, false));
            // Document documento_asociado_new2 = new Document();
            Blob documento_asociado_new2;
            List_others_documents.add(new others_document_s(/*documento_asociado_new2,*/ 'Other','','','document2', '2document2','', documento_asociado_new2, '', false, false));
            // Document documento_asociado_new3 = new Document();
            Blob documento_asociado_new3;
            List_others_documents.add(new others_document_s(/*documento_asociado_new3,*/ 'Other','','','document3', '3document3','', documento_asociado_new3, '', false, false));
            //Document documento_asociado_new4 = new Document();
            Blob documento_asociado_new4;
            List_others_documents.add(new others_document_s(/*documento_asociado_new4,*/ 'Other','','','document4', '4document4','', documento_asociado_new4, '', false, false));
            //Document documento_asociado_new5 = new Document();
            Blob documento_asociado_new5;
            List_others_documents.add(new others_document_s(/*documento_asociado_new5,*/ 'Other','','','document5', '5document5','', documento_asociado_new5, '', false, false));
        }

        return List_others_documents;
    }



    public void Upload_Documents()
    {
        boolean todo_correcto = true;
        //--------------------------
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder];
        List<Folder> directorio2 = [Select Id, Name from Folder where Name =:'Associated Documents'];
        string texto_email = '';
        if(shipment_reference != null)
            texto_email +='Please see bellow the documents just uploaded on shipment '+ shipment_reference.Name+':';
        else
                texto_email +='Please see bellow the documents just uploaded on shipment :';
        texto_email +='\n';

        //---------------------------
        // List<Document> listado_documentos = new List<Document>();
        for(others_document_s od: List_personal_documents)
        {
            if(od.documento_asociado != null)
            {
                if(od.documento_asociadoName != '' && od.documento_asociadoName != null)
                {
                    Document document1=new Document();
                    document1.Body=od.documento_asociado;
                    document1.Name=od.documento_asociadoName;
                    document1.AuthorId = UserInfo.getUserId();
                    texto_email +=od.documento_asociadoName+'\n';

                    // od.documento_asociado.AuthorId = UserInfo.getUserId();
                    //od.documento_asociado.IsPublic = true;
                    document1.IsPublic = true;
                    boolean folder_encontrado = false;
                    for(Folder d :directorio)
                    {
                        if(d.Name == od.Document_Type)
                        {
                            //od.documento_asociado.FolderId = d.Id;
                            document1.FolderId = d.Id;
                            folder_encontrado = true;
                            break;
                        }
                    }
                    if(folder_encontrado == false)
                        document1.FolderId = directorio2[0].Id;
                    //od.documento_asociado.FolderId = directorio2[0].Id;
                    //listado_documentos.add(od.documento_asociado);
                    // listado_documentos.add(document1);

                    Attachment attach = new Attachment();
                    if(od.Document_Type == 'Acuse')
                    {
                        attach.Body = od.documento_asociado;
                        attach.Name = od.documento_asociadoName;
                        attach.ParentId = ApexPages.currentPage().getParameters().get('id');
                        attach.OwnerId = UserInfo.getUserId();
                    }

                    try
                    {
                        if(document1.Body != null && document1.Name != null)
                        {
                            if (!Test.isRunningTest())
                            {
                                insert document1;
                                od.document_insert_Id = document1.Id;

                                if(od.Document_Type == 'Acuse')
                                    insert attach;
                            }
                        }
                        else
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                            todo_correcto = false;
                        }
                    }
                    catch (DMLException e)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                        todo_correcto = false;

                    }

                    folder_encontrado = false;
                }
            }
        }
        for(others_document_s od: List_others_documents)
        {
            if(od.documento_asociado != null)
            {
                if(od.documento_asociadoName != '' && od.documento_asociadoName != null)
                {
                    Document document1=new Document();
                    document1.Body=od.documento_asociado;
                    document1.Name=od.documento_asociadoName;
                    document1.AuthorId = UserInfo.getUserId();
                    /*od.documento_asociado.AuthorId = UserInfo.getUserId();
                    od.documento_asociado.IsPublic = true;*/
                    texto_email +=od.documento_asociadoName+'\n';
                    document1.IsPublic = true;
                    boolean folder_encontrado = false;
                    for(Folder d :directorio)
                    {
                        if(d.Name == od.Document_Type)
                        {
                            //od.documento_asociado.FolderId = d.Id;
                            document1.FolderId = d.Id;
                            folder_encontrado = true;
                            break;
                        }
                    }
                    if(folder_encontrado == false)
                        document1.FolderId = directorio2[0].Id;
                    //  od.documento_asociado.FolderId = directorio2[0].Id;
                    // listado_documentos.add(od.documento_asociado);
                    //listado_documentos.add(document1);

                    try
                    {
                        if(document1.Body != null && document1.Name != null)
                        {
                            if (!Test.isRunningTest())
                            {
                                insert document1;
                                od.document_insert_Id = document1.Id;
                            }
                        }
                        else
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                            todo_correcto = false;
                        }
                    }
                    catch (DMLException e)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                        todo_correcto = false;

                    }
                    folder_encontrado = false;
                }
            }
        }

        /*try
          {
              if(listado_documentos != null && listado_documentos.size()>0)
              {
                  if (!Test.isRunningTest())
                      insert listado_documentos;
              }
              else
              {
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
                   todo_correcto = false;
              }
          }
          catch (DMLException e)
          {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
              todo_correcto = false;

          }*/
        if(todo_correcto == true)
        {
            List<Claim__c> claims = null;
            List<Shipment_Consolidation_Data__c> Shipment_Consolidation_Data = null;
            List<Transport_Packaging_Data__c> Transport_Packaging_Data = null;
            List<Shipment__c> Shipment = null;
            List<Supply_Project__c> Supply_Project = null;
            List<Shopping_Cart__c> Shopping_Cart = null;
            List<Supplier_Quote__c> Supplier_Quote = null;
            List<Customer_Quote__c> Customer_Quote = null;
            List<Shipment_Program__c> Shipment_Program = null;
            List<Invoice__c> invoices = null;
            List<Shipment_Consolidation_Data__c> shipments_import_export = null;
            List<Account> cuentas = null;
            List<Shipment_Disbursement__c> Shipment_Disbursement = null;

            id tipo_de_objeto = ApexPages.currentPage().getParameters().get('id');
            string tipo_de_objeto_string = string.valueof(tipo_de_objeto.getSobjectType());
            tipo_de_objeto_string = tipo_de_objeto_string.replace('NEUEBUSCM__','');

            if(tipo_de_objeto_string == 'Claim__c')
                claims = [select Id, Name, Shopping_Cart__c, Shipment__c, Supply_Project__c, Customer__c from Claim__c where id =: ApexPages.currentPage().getParameters().get('id')];
            else if(tipo_de_objeto_string == 'Shipment_Consolidation_Data__c')
                Shipment_Consolidation_Data = [select Id,Name, Import_Export_Quote__c, Shipment__c, Shopping_Cart__c, Supplier_Quote__c,Import_Export_Quote__r.Account_for__c, Shipment__r.Account_for__c, Shopping_Cart__r.Customer__c, Supplier_Quote__r.Customer__c from Shipment_Consolidation_Data__c where id =: ApexPages.currentPage().getParameters().get('id') ];
            else if(tipo_de_objeto_string == 'Transport_Packaging_Data__c')
                Transport_Packaging_Data = [select Id, Name,Shipment__c,Transporter__c,Shipment__r.Account_for__c  from Transport_Packaging_Data__c where id =: ApexPages.currentPage().getParameters().get('id')];
            else if(tipo_de_objeto_string == 'Shipment__c')
            {
                Shipment = [select Id,Name, Account_for__c from Shipment__c where id =: ApexPages.currentPage().getParameters().get('id')];
                shipments_import_export =[select id, Name, Import_Export_Quote__c from Shipment_Consolidation_Data__c where Shipment__c =:  ApexPages.currentPage().getParameters().get('id')];
            }
            else if(tipo_de_objeto_string == 'Supply_Project__c')
                Supply_Project = [select Id, Name,Customer__c  from Supply_Project__c where id =: ApexPages.currentPage().getParameters().get('id')];
            else if(tipo_de_objeto_string == 'Shopping_Cart__c')
                Shopping_Cart = [select Id, Name, Customer__c from Shopping_Cart__c where id =: ApexPages.currentPage().getParameters().get('id')];
            else if(tipo_de_objeto_string == 'Supplier_Quote__c')
                Supplier_Quote = [select Id, Name,Customer__c, Supplier__c,Supply_Project__c,Supplier_Request_RFP__c  from Supplier_Quote__c where id =: ApexPages.currentPage().getParameters().get('id')];
            else if(tipo_de_objeto_string == 'Customer_Quote__c')
                Customer_Quote = [select Id, Name,Account_for__c,Supply_Project_Name__c  from Customer_Quote__c where id =: ApexPages.currentPage().getParameters().get('id')];
            else if(tipo_de_objeto_string == 'Shipment_Program__c')
                Shipment_Program = [select Id, Name, Files_Account_Owner__c from Shipment_Program__c where id =: ApexPages.currentPage().getParameters().get('id')];
            else if(tipo_de_objeto_string == 'Invoice__c')
                invoices = [select Id, Name, Account__c, Import_Export_Quote_Order__c from Invoice__c where id =: ApexPages.currentPage().getParameters().get('id')];
            else if(tipo_de_objeto_string == 'Account')
                cuentas = [select Id, Name  from Account where id =: ApexPages.currentPage().getParameters().get('id')];
            else if(tipo_de_objeto_string == 'Shipment_Disbursement__c')
                Shipment_Disbursement = [select Id, Name, Shipment__c, Account__c from Shipment_Disbursement__c where id =: ApexPages.currentPage().getParameters().get('id')];
            List<Associated_Document__c> List_new_document= new List<Associated_Document__c>();
            for(others_document_s od: List_personal_documents)
            {
                if(od.documento_asociado != null)
                {
                    if(od.documento_asociadoName != '' && od.documento_asociadoName != null)
                    {
                        Associated_Document__c new_document= new Associated_Document__c();
                        new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+od.document_insert_Id+'&oid=' + UserInfo.getOrganizationId();//--------------falta aqui el id
                        string nombredeldocumento = od.documento_asociadoName;
                        Integer indiceDePunto = nombredeldocumento.indexOf('.');
                        new_document.Name=nombredeldocumento.substring(0, indiceDePunto);
                        new_document.Document_Reference__c=od.Document_Reference;
                        new_document.Document_Description__c = od.Document_Description;
                        new_document.Document_Type__c=od.Document_type;
                        new_document.Available_for_Community__c = od.available_community;
                        new_document.Type__c = 'Document';

                        if(Shopping_Cart != null && Shopping_Cart.size() > 0)
                        {
                            new_document.Account__c = Shopping_Cart[0].Customer__c;
                            new_document.Shopping_Cart__c =Shopping_Cart[0].Id;
                        }
                        else if(Supplier_Quote != null && Supplier_Quote.size() > 0)
                        {
                            new_document.Account__c = Supplier_Quote[0].Supplier__c;
                            new_document.Supplier_Quote__c =Supplier_Quote[0].Id;
                            new_document.Supplier_Request_RFP__c =Supplier_Quote[0].Supplier_Request_RFP__c;
                            new_document.Supply_Project__c =Supplier_Quote[0].Supply_Project__c;
                        }
                        else if(Customer_Quote != null && Customer_Quote.size() > 0)
                        {
                            new_document.Account__c = Customer_Quote[0].Account_for__c;
                            new_document.Import_Export_Quote__c=Customer_Quote[0].Id;
                            if(Customer_Quote[0].Supply_Project_Name__c != null)
                                new_document.Supply_Project__c =Customer_Quote[0].Supply_Project_Name__c;
                        }
                        else if(Shipment_Program!= null && Shipment_Program.size() > 0)
                        {
                            new_document.Account__c = Shipment_Program[0].Files_Account_Owner__c;
                            new_document.Consolidation_Program__c=Shipment_Program[0].Id;
                        }
                        else if(Supply_Project != null && Supply_Project.size() > 0)
                        {
                            new_document.Account__c = Supply_Project[0].Customer__c;
                            new_document.Supply_Project__c =Supply_Project[0].Id;
                        }
                        else if(Shipment != null && Shipment.size() > 0)
                        {
                            new_document.Account__c = Shipment[0].Account_for__c;
                            new_document.Shipment__c=Shipment[0].Id;
                            if(shipments_import_export != null && shipments_import_export.size()==1)
                                new_document.Import_Export_Quote__c = shipments_import_export[0].Import_Export_Quote__c;
                        }
                        else if(Transport_Packaging_Data != null && Transport_Packaging_Data.size() > 0)
                        {
                            new_document.Account__c = Transport_Packaging_Data[0].Shipment__r.Account_for__c;
                            new_document.Shipment__c=Transport_Packaging_Data[0].Shipment__c;
                            new_document.Shipment_Packaging_Consolidation_Data__c =Transport_Packaging_Data[0].Id;

                        }
                        else if(Shipment_Consolidation_Data != null && Shipment_Consolidation_Data.size() > 0)
                        {
                            if(Shipment_Consolidation_Data[0].Shopping_Cart__c != null)
                            {
                                new_document.Shopping_Cart__c =Shipment_Consolidation_Data[0].Shopping_Cart__c;
                                new_document.Account__c = Shipment_Consolidation_Data[0].Shopping_Cart__r.Customer__c;
                            }
                            if(Shipment_Consolidation_Data[0].Shipment__c != null)
                            {
                                new_document.Shipment__c=Shipment_Consolidation_Data[0].Shipment__c;
                                new_document.Account__c = Shipment_Consolidation_Data[0].Shipment__r.Account_for__c;
                            }
                            if(Shipment_Consolidation_Data[0].Supplier_Quote__c != null)
                            {
                                new_document.Supplier_Quote__c =Shipment_Consolidation_Data[0].Supplier_Quote__c;
                                new_document.Account__c = Shipment_Consolidation_Data[0].Supplier_Quote__r.Customer__c;
                            }
                            if(Shipment_Consolidation_Data[0].Import_Export_Quote__c != null)
                            {
                                new_document.Import_Export_Quote__c=Shipment_Consolidation_Data[0].Import_Export_Quote__c;
                                new_document.Account__c = Shipment_Consolidation_Data[0].Import_Export_Quote__r.Account_for__c;
                            }
                            new_document.Shipment_Consolidation_Data__c =Shipment_Consolidation_Data[0].Id;

                        }
                        else if(claims != null && claims.size() > 0)
                        {
                            new_document.Account__c = claims[0].Customer__c;
                            if(claims[0].Shopping_Cart__c != null)
                                new_document.Shopping_Cart__c =claims[0].Shopping_Cart__c;
                            if(claims[0].Shipment__c != null)
                                new_document.Shipment__c=claims[0].Shipment__c;
                            if(claims[0].Supply_Project__c != null)
                                new_document.Supply_Project__c =claims[0].Supply_Project__c;
                            new_document.Claim__c=claims[0].Id;
                        }
                        else if(invoices != null && invoices.size() > 0)
                        {
                            new_document.Account__c = invoices[0].Account__c;
                            if(invoices[0].Import_Export_Quote_Order__c!= null)
                                new_document.Import_Export_Quote__c=invoices[0].Import_Export_Quote_Order__c;
                            new_document.Invoice__c = invoices[0].Id;
                        }
                        else if(cuentas != null && cuentas.size() > 0)
                        {
                            new_document.Account__c = cuentas[0].Id;
                        }
                        else if(Shipment_Disbursement != null && Shipment_Disbursement.size() > 0)
                        {
                            if(Shipment_Disbursement[0].Account__c != null)
                                new_document.Account__c = Shipment_Disbursement[0].Account__c;
                            if(Shipment_Disbursement[0].Shipment__c != null)
                                new_document.Shipment__c = Shipment_Disbursement[0].Shipment__c;
                            new_document.Shipment_Disbursement__c = Shipment_Disbursement[0].Id;
                        }
                        List_new_document.add(new_document);
                    }
                }
            }

            //---------------------

            for(others_document_s od: List_others_documents)
            {
                if(od.documento_asociado != null)
                {
                    if(od.documento_asociadoName != '' && od.documento_asociadoName != null)
                    {
                        Associated_Document__c new_document= new Associated_Document__c();
                        new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+od.document_insert_Id+'&oid=' + UserInfo.getOrganizationId();//------falta aqui el id
                        string nombredeldocumento = od.documento_asociadoName;
                        Integer indiceDePunto = nombredeldocumento.indexOf('.');
                        new_document.Name=nombredeldocumento.substring(0, indiceDePunto);
                        new_document.Document_Reference__c=od.Document_Reference;
                        new_document.Document_Description__c = od.Document_Description;
                        new_document.Document_Type__c=od.Document_type;
                        new_document.Available_for_Community__c = od.available_community;
                        new_document.Type__c = 'Document';

                        if(Shopping_Cart != null && Shopping_Cart.size() > 0)
                        {
                            new_document.Account__c = Shopping_Cart[0].Customer__c;
                            new_document.Shopping_Cart__c =Shopping_Cart[0].Id;
                        }
                        else if(Supplier_Quote != null && Supplier_Quote.size() > 0)
                        {
                            new_document.Account__c = Supplier_Quote[0].Supplier__c;
                            new_document.Supplier_Quote__c =Supplier_Quote[0].Id;
                            new_document.Supplier_Request_RFP__c =Supplier_Quote[0].Supplier_Request_RFP__c;
                            new_document.Supply_Project__c =Supplier_Quote[0].Supply_Project__c;
                        }
                        else if(Customer_Quote != null && Customer_Quote.size() > 0)
                        {
                            new_document.Account__c = Customer_Quote[0].Account_for__c;
                            new_document.Import_Export_Quote__c=Customer_Quote[0].Id;
                            if(Customer_Quote[0].Supply_Project_Name__c != null)
                                new_document.Supply_Project__c =Customer_Quote[0].Supply_Project_Name__c;
                        }
                        else if(Shipment_Program != null && Shipment_Program.size() > 0)
                        {
                            new_document.Account__c = Shipment_Program[0].Files_Account_Owner__c;
                            new_document.Consolidation_Program__c=Shipment_Program[0].Id;
                        }
                        else if(Supply_Project != null && Supply_Project.size() > 0)
                        {
                            new_document.Account__c = Supply_Project[0].Customer__c;
                            new_document.Supply_Project__c =Supply_Project[0].Id;
                        }
                        else if(Shipment != null && Shipment.size() > 0)
                        {
                            new_document.Account__c = Shipment[0].Account_for__c;
                            new_document.Shipment__c=Shipment[0].Id;
                            if(shipments_import_export != null && shipments_import_export.size()==1)
                                new_document.Import_Export_Quote__c = shipments_import_export[0].Import_Export_Quote__c;
                        }
                        else if(Transport_Packaging_Data != null && Transport_Packaging_Data.size() > 0)
                        {
                            new_document.Account__c = Transport_Packaging_Data[0].Shipment__r.Account_for__c;
                            new_document.Shipment__c=Transport_Packaging_Data[0].Shipment__c;
                            new_document.Shipment_Packaging_Consolidation_Data__c =Transport_Packaging_Data[0].Id;

                        }
                        else if(Shipment_Consolidation_Data != null && Shipment_Consolidation_Data.size() > 0)
                        {
                            if(Shipment_Consolidation_Data[0].Shopping_Cart__c != null)
                            {
                                new_document.Shopping_Cart__c =Shipment_Consolidation_Data[0].Shopping_Cart__c;
                                new_document.Account__c = Shipment_Consolidation_Data[0].Shopping_Cart__r.Customer__c;
                            }
                            if(Shipment_Consolidation_Data[0].Shipment__c != null)
                            {
                                new_document.Shipment__c=Shipment_Consolidation_Data[0].Shipment__c;
                                new_document.Account__c = Shipment_Consolidation_Data[0].Shipment__r.Account_for__c;
                            }
                            if(Shipment_Consolidation_Data[0].Supplier_Quote__c != null)
                            {
                                new_document.Supplier_Quote__c =Shipment_Consolidation_Data[0].Supplier_Quote__c;
                                new_document.Account__c = Shipment_Consolidation_Data[0].Supplier_Quote__r.Customer__c;
                            }
                            if(Shipment_Consolidation_Data[0].Import_Export_Quote__c != null)
                            {
                                new_document.Import_Export_Quote__c=Shipment_Consolidation_Data[0].Import_Export_Quote__c;
                                new_document.Account__c = Shipment_Consolidation_Data[0].Import_Export_Quote__r.Account_for__c;
                            }
                            new_document.Shipment_Consolidation_Data__c =Shipment_Consolidation_Data[0].Id;

                        }
                        else if(invoices != null && invoices.size() > 0)
                        {
                            new_document.Account__c = invoices[0].Account__c;
                            if(invoices[0].Import_Export_Quote_Order__c != null)
                                new_document.Import_Export_Quote__c = invoices[0].Import_Export_Quote_Order__c;
                            new_document.Invoice__c = invoices[0].Id;
                        }
                        else if(claims != null && claims.size() > 0)
                        {
                            new_document.Account__c = claims[0].Customer__c;
                            if(claims[0].Shopping_Cart__c != null)
                                new_document.Shopping_Cart__c =claims[0].Shopping_Cart__c;
                            if(claims[0].Shipment__c != null)
                                new_document.Shipment__c=claims[0].Shipment__c;
                            if(claims[0].Supply_Project__c != null)
                                new_document.Supply_Project__c =claims[0].Supply_Project__c;
                            new_document.Claim__c=claims[0].Id;
                        }
                        else if(cuentas != null && cuentas.size() > 0)
                        {
                            new_document.Account__c = cuentas[0].Id;
                        }
                        else if(Shipment_Disbursement != null && Shipment_Disbursement.size() > 0)
                        {
                            if(Shipment_Disbursement[0].Account__c != null)
                                new_document.Account__c = Shipment_Disbursement[0].Account__c;
                            if(Shipment_Disbursement[0].Shipment__c != null)
                                new_document.Shipment__c = Shipment_Disbursement[0].Shipment__c;
                            new_document.Shipment_Disbursement__c = Shipment_Disbursement[0].Id;
                        }
                        List_new_document.add(new_document);
                    }
                }
            }


            if(List_new_document != null && List_new_document.size()>0)
            {
                try
                {
                    insert List_new_document;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'Document Uploaded Correctly'));
                }
                catch(Exception e)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+e));todo_correcto = false;
                }
            }
            //vaciar los campos
            for(others_document_s od: List_others_documents)
            {
                if(od.documento_asociado != null)
                {
                    if(od.documento_asociadoName != '' && od.documento_asociadoName != null)
                    {

                        od.Document_Reference = '';
                        od.Document_Description = '';
                    }
                }
            }
            for(others_document_s od: List_personal_documents)
            {
                if(od.documento_asociado != null)
                {
                    if(od.documento_asociadoName != '' && od.documento_asociadoName != null)
                    {

                        //od.Document_Reference = '';
                        //od.Document_Description = '';
                        od.ya_hay_uno_del_mismo_tipo = true;
                    }
                }
            }


            //aviso de que se a subido algo desde el sitio publico
            if(estoy_en_site == true && shipment_reference != null )
            {
                String estilo_email = '';
                estilo_email += 'body{width:100%; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
                estilo_email += 'p{margin:0; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
                estilo_email += '.user_name{font-weight:bold;}';

                string description_task = texto_email;
                texto_email +='If you want to see these documents uploaded <a href="https://login.salesforce.com/'+shipment_reference.Id+'"> https://login.salesforce.com/'+ shipment_reference.Id +'</a>';
                description_task +='If you want to see these documents uploaded https://login.salesforce.com/'+shipment_reference.Id;
                Map<String, String> listado_receptores = new Map<String, String>();
                //listado_receptores.put('oscar@neurored.com','oscar@neurored.com');
                //incluir el creador
                listado_receptores.put(shipment_reference.CreatedBy.Email,shipment_reference.CreatedBy.Email);

                //el ultimo que lo modifica
                listado_receptores.put(shipment_reference.LastModifiedBy.Email,shipment_reference.LastModifiedBy.Email);

                //el que envio el correo
                List<Task> listado_tareas = [select Id, OwnerId, Owner.Email from Task where Send_Emails__c =: true and WhatId =: shipment_reference.Id];
                if(listado_tareas != null && listado_tareas.size()>0)
                {
                    for(Task t: listado_tareas)
                    {
                        if(t.Owner.Email != null)
                            listado_receptores.put(t.Owner.Email, t.Owner.Email);
                    }
                }
                List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(listado_receptores.values());

                mail.setSenderDisplayName('Neurored');
                mail.setSubject('Uploaded Document in Shipment '+shipment_reference.Name);

                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setCharset('UTF-8');
                mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+(texto_email != null ? texto_email.replace('\n','<br/>') : '')+'<br/></body></html>');
                theEmails.add(mail);
                List<Messaging.Email> allMails = new List<Messaging.Email>();
                for(Integer j = 0; j < theEmails.size(); j++)
                {
                    allMails.add(theEmails.get(j));
                }

                try
                {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
                    Task new_task_account = new Task();
                    new_task_account.ActivityDate = system.today();
                    new_task_account.Subject = 'Uploaded Document in Shipment '+shipment_reference.Name;
                    new_task_account.Status = 'Completed';
                    new_task_account.Type = 'Email';
                    new_task_account.OwnerId = UserInfo.getUserId();
                    new_task_account.WhatId = shipment_reference.Id;
                    // new_task_account.Send_Emails__c = true;
                    new_task_account.Priority = 'Normal';
                    string descripcion_email = (description_task != null ? description_task  :'');
                    new_task_account.Description = descripcion_email;
                    insert new_task_account;
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}
            }



        }

        /* List<Folder> directorio = new List<Folder>();
         directorio = [Select Id, Name from Folder where Name =: Document_type];//Document_type
         if(directorio.size()<1)
         {
             directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
         }
         todo_correcto = true;
         //DOCUMENTO1
         if(documento_asociado.Name != '' && documento_asociado.Name != null)
         {
             documento_asociado.AuthorId = UserInfo.getUserId();
             if(directorio.size()>0)
                 documento_asociado.FolderId = directorio[0].Id;
             documento_asociado.IsPublic = true;
         }

         try
         {
             if(documento_asociado.Name != '' && documento_asociado.Name != null)
                 insert documento_asociado;
            display_buttons1='none';
            display_buttons2='';
         }
         catch (DMLException e)
         {
             display_buttons1='';
             display_buttons2='none';
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
             todo_correcto = false;

         }

         List<Claim__c> claims = [select Id, Name, Shopping_Cart__c, Shipment__c, Supply_Project__c, Customer__c from Claim__c where id =: ApexPages.currentPage().getParameters().get('id')];
         List<Shipment_Consolidation_Data__c> Shipment_Consolidation_Data = [select Id,Name, Import_Export_Quote__c, Shipment__c, Shopping_Cart__c, Supplier_Quote__c,Import_Export_Quote__r.Account_for__c, Shipment__r.Account_for__c, Shopping_Cart__r.Customer__c, Supplier_Quote__r.Customer__c from Shipment_Consolidation_Data__c where id =: ApexPages.currentPage().getParameters().get('id') ];
         List<Transport_Packaging_Data__c> Transport_Packaging_Data = [select Id, Name,Shipment__c,Transporter__c,Shipment__r.Account_for__c  from Transport_Packaging_Data__c where id =: ApexPages.currentPage().getParameters().get('id')];
         List<Shipment__c> Shipment = [select Id,Name, Account_for__c from Shipment__c where id =: ApexPages.currentPage().getParameters().get('id')];
         List<Supply_Project__c> Supply_Project = [select Id, Name,Customer__c  from Supply_Project__c where id =: ApexPages.currentPage().getParameters().get('id')];
         List<Shopping_Cart__c> Shopping_Cart = [select Id, Name, Customer__c from Shopping_Cart__c where id =: ApexPages.currentPage().getParameters().get('id')];
         List<Supplier_Quote__c> Supplier_Quote = [select Id, Name,Customer__c, Supplier__c,Supply_Project__c,Supplier_Request_RFP__c  from Supplier_Quote__c where id =: ApexPages.currentPage().getParameters().get('id')];
         List<Customer_Quote__c> Customer_Quote = [select Id, Name,Account_for__c,Supply_Project_Name__c  from Customer_Quote__c where id =: ApexPages.currentPage().getParameters().get('id')];
         List<Account> cuentas = [select Id, Name  from Account where id =: ApexPages.currentPage().getParameters().get('id')];
         List<Shipment_Disbursement__c> Shipment_Disbursement = [select Id, Name, Shipment__c, Account__c from Shipment_Disbursement__c where id =: ApexPages.currentPage().getParameters().get('id')];
         id_cabecera =  ApexPages.currentPage().getParameters().get('id');

         Associated_Document__c new_document= new Associated_Document__c();
         if(documento_asociado.Name != '' && documento_asociado.Name != null)
         {

             new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId();
             string nombredeldocumento = documento_asociado.Name;
             Integer indiceDePunto = nombredeldocumento.indexOf('.');
             new_document.Name=nombredeldocumento.substring(0, indiceDePunto);

         }

         if(Manual_Document_URL != null & Manual_Document_URL != '' )
         {
             new_document.Manual_Document_URL__c = Manual_Document_URL;
         }

         new_document.Document_Reference__c=Document_Reference;
         new_document.Document_Description__c = Document_Description;
         new_document.Document_Type__c=Document_type;

         if(Shopping_Cart.size() > 0)
         {
             new_document.Account__c = Shopping_Cart[0].Customer__c;
             new_document.Shopping_Cart__c =Shopping_Cart[0].Id;
         }
         else if(Supplier_Quote.size() > 0)
         {
             new_document.Account__c = Supplier_Quote[0].Supplier__c;
             new_document.Supplier_Quote__c =Supplier_Quote[0].Id;
             new_document.Supplier_Request_RFP__c =Supplier_Quote[0].Supplier_Request_RFP__c;
             new_document.Supply_Project__c =Supplier_Quote[0].Supply_Project__c;
         }
         else if(Customer_Quote.size() > 0)
         {
             new_document.Account__c = Customer_Quote[0].Account_for__c;
             new_document.Import_Export_Quote__c=Customer_Quote[0].Id;
             if(Customer_Quote[0].Supply_Project_Name__c != null)
                 new_document.Supply_Project__c =Customer_Quote[0].Supply_Project_Name__c;
         }
         else if(Supply_Project.size() > 0)
         {
             new_document.Account__c = Supply_Project[0].Customer__c;
             new_document.Supply_Project__c =Supply_Project[0].Id;
         }
         else if(Shipment.size() > 0)
         {
             new_document.Account__c = Shipment[0].Account_for__c;
             new_document.Shipment__c=Shipment[0].Id;
         }
         else if(Transport_Packaging_Data.size() > 0)
         {
             new_document.Account__c = Transport_Packaging_Data[0].Shipment__r.Account_for__c;
             new_document.Shipment__c=Transport_Packaging_Data[0].Shipment__c;
             new_document.Shipment_Packaging_Consolidation_Data__c =Transport_Packaging_Data[0].Id;

         }
         else if(Shipment_Consolidation_Data.size() > 0)
         {
             if(Shipment_Consolidation_Data[0].Shopping_Cart__c != null)
             {
                 new_document.Shopping_Cart__c =Shipment_Consolidation_Data[0].Shopping_Cart__c;
                 new_document.Account__c = Shipment_Consolidation_Data[0].Shopping_Cart__r.Customer__c;
             }
             if(Shipment_Consolidation_Data[0].Shipment__c != null)
             {
                 new_document.Shipment__c=Shipment_Consolidation_Data[0].Shipment__c;
                 new_document.Account__c = Shipment_Consolidation_Data[0].Shipment__r.Account_for__c;
             }
             if(Shipment_Consolidation_Data[0].Supplier_Quote__c != null)
             {
                 new_document.Supplier_Quote__c =Shipment_Consolidation_Data[0].Supplier_Quote__c;
                 new_document.Account__c = Shipment_Consolidation_Data[0].Supplier_Quote__r.Customer__c;
             }
             if(Shipment_Consolidation_Data[0].Import_Export_Quote__c != null)
             {
                 new_document.Import_Export_Quote__c=Shipment_Consolidation_Data[0].Import_Export_Quote__c;
                 new_document.Account__c = Shipment_Consolidation_Data[0].Import_Export_Quote__r.Account_for__c;
             }
             new_document.Shipment_Consolidation_Data__c =Shipment_Consolidation_Data[0].Id;

         }
         else if(claims.size() > 0)
         {
             new_document.Account__c = claims[0].Customer__c;
             if(claims[0].Shopping_Cart__c != null)
                 new_document.Shopping_Cart__c =claims[0].Shopping_Cart__c;
             if(claims[0].Shipment__c != null)
                 new_document.Shipment__c=claims[0].Shipment__c;
             if(claims[0].Supply_Project__c != null)
                 new_document.Supply_Project__c =claims[0].Supply_Project__c;
             new_document.Claim__c=claims[0].Id;
         }
         else if(cuentas.size() > 0)
         {
             new_document.Account__c = cuentas[0].Id;
         }
         else if(Shipment_Disbursement.size() > 0)
         {
             if(Shipment_Disbursement[0].Account__c != null)
                 new_document.Account__c = Shipment_Disbursement[0].Account__c;
             if(Shipment_Disbursement[0].Shipment__c != null)
                 new_document.Shipment__c = Shipment_Disbursement[0].Shipment__c;
             new_document.Shipment_Disbursement__c = Shipment_Disbursement[0].Id;
         }

         try
         {
             insert new_document;
             display_buttons1='none';
             display_buttons2='';
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'Document Uploaded Correctly'));
         }
         catch(Exception e)
         {
             display_buttons1='';
             display_buttons2='none';
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+e));todo_correcto = false;
         }*/
    }

    public PageReference cancel_document()
    {
        PageReference pgReturnPage;
        String returnUrl = '/' + ApexPages.currentPage().getParameters().get('id');
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }

}