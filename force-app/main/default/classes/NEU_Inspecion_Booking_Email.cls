public with sharing class NEU_Inspecion_Booking_Email {

  public Shipment__c record;
  public List<User> usuarios {get;set;}
  public String user_list {get;set;}
  public List<cuenta_s> clientes_seleccionados {get;set;}
  public List<documents_s> associated_documents {get;set;}
  public string asunto {get;set;}
  public decimal total_peso_ficheros {get;set;}
  public decimal bytesocupados  {get;set;}
  public string porc_ocupacion {get;set;}
  public string texto_email {get;set;}
  public string tabla_shipping_order {get;set;}
  public string tabla_shipping_order_lines {get;set;}
  public string resultado {get;set;}
  public string OwnerId_task{get;set;}
  public string Status_task{get;set;}
  public Shipment__c Due_Date_task{get;set;}
  public boolean create_task{get;set;}
  public List<SelectOption> select_status_task{get; set;}
  public string priority_task{get;set;}
  public string subject_task{get;set;}
  public List<SelectOption> select_users{get; set;}
  
  public class contacto_s
  {
    public Contact contact {get;set;}
    public Boolean selected {get;set;}
    
      public contacto_s(Contact contact, Boolean selected)
    {
      this.contact = contact;
      this.selected = selected;
    }
  }
  
  public class cuenta_s
  {
    public Account cuenta {get;set;}
    public List<contacto_s> contactos {get;set;}
    public String typo_cuenta {get;set;}
    
    public cuenta_s(Account cuenta, List<contacto_s> contactos, String typo_cuenta)
    {
      this.cuenta = cuenta;
      this.contactos = contactos;
      this.typo_cuenta = typo_cuenta;
    }
  }
  
   public class documents_s
    {
      public Boolean selected {get;set;}
      public String name {get;set;}
      public String document_type {get;set;}
      public String document_reference {get;set;}
      public String document_description {get;set;}
      public String document_url {get;set;}
      public String id_doc {get;set;}
      public decimal espacio{get;set;}
      public String porespacio{get;set;}
      
      public documents_s(Boolean selected, String name, String document_type, String document_reference, String document_description, String document_url, String id_doc, decimal espacio, string porespacio)
      {
        this.selected = selected;
        this.name = name;
        this.document_type = document_type;
        this.document_reference = document_reference;
        this.document_description = document_description;
        this.document_url = document_url;
        this.id_doc = id_doc;
        this.espacio= espacio;
        this.porespacio= porespacio;
      }
    }
  
  ApexPages.StandardController con;
  
  private void addaccount(Account myaccount,Id myId, string tipo)
  {
    cuenta_s new_account = new cuenta_s(myaccount,null,'');
  
    List<Contact> contactos_cuenta = [select Id, Name, Email, AccountId from Contact where AccountId =: myId];//and Email != null
    List<contacto_s> contactos = new List<contacto_s>();
    for(Contact c : contactos_cuenta)
    {
      contactos.add(new contacto_s(c,false));
    }
    new_account.typo_cuenta = tipo;
    new_account.contactos = contactos;
    
    clientes_seleccionados.add(new_account);
  }
  public NEU_Inspecion_Booking_Email(ApexPages.StandardController stdController) 
  {
       con = stdController;
          system.debug( con.getRecord() );
    try { 
    record = [select Id, Name, Account_for__c, Account_for__r.Name, Carrier__c, Carrier__r.Name, Freight_Mode__c, Pickup_Cartage__r.Name , 
    Forwarder__c,Inbound_Consolidation_Program__r.Pallet_Container_Type__r.Name, Consignee__c , Consignee__r.Name,   Contact__r.Phone, Inbound_Consolidation_Program__r.Number_of_Pallets__c, Total_Volume_m3__c,
     Delivery_Cartage__c, Purchase_Incoterm__c, Site_of_Load__c, Site_of_Load__r.Name, ETD_from_Point_of_Load__c , Notify_Party__c, Notify_Party__r.Name, Shipper__c, Shipper__r.Name, Total_Weight_Kg__c, Contact__r.Name, Forwarder__r.Name,
     Supplier_Account__c,
     Supplier_Account__r.Name from Shipment__c where id = :con.getRecord().id];
    } catch( Exception ee) { 
      record = new Shipment__c();
    }
    asunto='Shipment: ' + record.Name;
    subject_task = '';
    subject_task = 'Shipment: ' + record.Name;
     Due_Date_task = new Shipment__c();
    select_users = new List<SelectOption>(); 
    Status_task = 'In Progress';
    priority_task = 'Normal';
    select_status_task = new List<SelectOption>(); 
    Schema.DescribeFieldResult fieldResult = Task.Status .getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for( Schema.PicklistEntry f : ple)
    {
        select_status_task .add(new SelectOption(f.getValue(),f.getValue()));
    }
    OwnerId_task = UserInfo.getUserId();
    create_task = true;
    texto_email='';//'To See shipment go to: \n '+string.valueof(URL.getSalesforceBaseUrl().toExternalForm()+'?Id=' +record.Id);
    
    
    //tabla a enviar en el correo lineas
    decimal total_cajas = 0;
    tabla_shipping_order_lines = '';
  //  tabla_shipping_order_lines ='<div id="contenedor>';
    List<Shipment_Line__c> lista_de_lineas_envios = [select id, Name, Packaging_Quantity__c,Shipping_Volume_m3__c,
    Shipping_Weight_Kg__c, Item_Name__r.Sourcing_Item_Code__c , Unit_Destination_Price__c, Conversion_Rate_to_Currency_Header__c,
    Packaging_Volume_m3__c ,Packaging_Weight_kg__c ,Packaging_Length_cm__c ,Units_Shipped__c , Item_Name__r.Name, Item_Units_x_Packaging__c , Packaging_Height_cm__c , 
    Packaging_Gross_Weight_kg__c , Item_Name__r.Url_Photo_1__c,Expense_Concept__c,Expense_Amount__c ,
    Packaging_Width_cm__c, Quote_Item_Line__r.Name, HS_Code__c, Shipment__r.Name,
    Item_Name__r.Item_Description__c  from Shipment_Line__c where Shipment__c =: record.Id];
    // informacion de packaging
        tabla_shipping_order_lines +='<div id="mid">';
        tabla_shipping_order_lines +='  <h1 class="title_import_export_details">PACKING INFORMATION</h1>';
        tabla_shipping_order_lines +='<hr/>';
        tabla_shipping_order_lines +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
        tabla_shipping_order_lines += '<tr>';
        tabla_shipping_order_lines += '  <th align="center" style="text-align: left;">LINE</th>';
        tabla_shipping_order_lines += '  <th align="center" style="text-align: left;">ITEM CODE</th>';
        tabla_shipping_order_lines += '  <th align="center" style="text-align: left;">ITEM</th>'; 
        tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">TOTAL </br> UNITS</th>'; 
        tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">UNITS </br> /CARTON</th>';
        tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">NUMBER </br>OF </br>CARTONS</th>';
        tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">CTN </br>DIMENSIONS</th>';
        tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">CTN</br>VOLUME</th>';  
        tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">VOLUME </br>(CBM)</th>';  
        tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">GW/CARTON </br>(KG)</th>';
        tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">TOTAL GW </br>(KG)</th>'; 
        tabla_shipping_order_lines += '</tr>';
            
    if(lista_de_lineas_envios != null)
        for(Shipment_Line__c ship_li : lista_de_lineas_envios)
        {
            tabla_shipping_order_lines += '  <tr>';
            tabla_shipping_order_lines += '    <td align="center">'+(ship_li.Name != null ? ship_li.Name :'')+'</td>';
            tabla_shipping_order_lines += '    <td align="center">'+ship_li.Item_Name__r.Sourcing_Item_Code__c+'</td>';
            tabla_shipping_order_lines += '    <td align="center">'+ship_li.Item_Name__r.Name+'</td>';
            tabla_shipping_order_lines += '    <td align="right">'+(ship_li.Units_Shipped__c != null ? ship_li.Units_Shipped__c.format() : '')+'</td>';
            tabla_shipping_order_lines += '    <td align="right">'+(ship_li.Item_Units_x_Packaging__c != null ? ship_li.Item_Units_x_Packaging__c.format() : '')+'</td>';
            tabla_shipping_order_lines += '    <td align="right">'+(ship_li.Packaging_Quantity__c != null ? ship_li.Packaging_Quantity__c.format() : '')+'</td>';
            tabla_shipping_order_lines += '    <td align="right">'+(ship_li.Packaging_Length_cm__c != null ? ship_li.Packaging_Length_cm__c.format() : '')+'*'+(ship_li.Packaging_Width_cm__c != null ? ship_li.Packaging_Width_cm__c.format() : '')+'*'+(ship_li.Packaging_Height_cm__c != null ? ship_li.Packaging_Height_cm__c.format() : '')+'</td>';
            tabla_shipping_order_lines += '    <td align="right">'+(ship_li.Packaging_Volume_m3__c != null ? ship_li.Packaging_Volume_m3__c.format() : '')+'</td>';
            tabla_shipping_order_lines += '    <td align="right">'+(ship_li.Shipping_Volume_m3__c != null ? ship_li.Shipping_Volume_m3__c.format() : '')+'</td>';
            tabla_shipping_order_lines += '    <td align="right">'+(ship_li.Packaging_Gross_Weight_kg__c != null ? ship_li.Packaging_Gross_Weight_kg__c.format() : '')+'</td>';
            tabla_shipping_order_lines += '    <td align="right">'+(ship_li.Shipping_Weight_Kg__c != null ? ship_li.Shipping_Weight_Kg__c.format() : '')+'</td>';
            tabla_shipping_order_lines += '</tr>';
        }
      //ÚLTIMA PÁGINA  
    tabla_shipping_order_lines += '    <tr>';
    tabla_shipping_order_lines += '      <td align="right" style="background-color: white;"></td>';
    tabla_shipping_order_lines += '      <td align="right" style="background-color: white;"></td>';
    tabla_shipping_order_lines += '      <td align="right" style="background-color: white;"></td>';
    tabla_shipping_order_lines += '      <td align="right" style="background-color: white;"></td>';
    tabla_shipping_order_lines += '      <td align="right" style="background-color: white;"></td>';
    tabla_shipping_order_lines += '      <td align="right" style="background-color: white;"></td>';
    tabla_shipping_order_lines += '      <td align="right" style="background-color: white;"></td>';
    tabla_shipping_order_lines += '      <th>Total</th>';
    tabla_shipping_order_lines += '      <td align="right">'+record.Total_Volume_m3__c.format()+'</td>';
    tabla_shipping_order_lines += '      <th>Total</th>';
    tabla_shipping_order_lines += '      <td align="right">'+record.Total_Weight_Kg__c.format()+'</td>';
    tabla_shipping_order_lines += '    </tr>';
    tabla_shipping_order_lines +='          </table>';
    tabla_shipping_order_lines += '     </div>';
    
    
    // informacion tecnica ite   m
    tabla_shipping_order_lines +='<div id="mid">';
    tabla_shipping_order_lines +='  <h1 class="title_import_export_details">ITEM SPECIFIC INFORMATION</h1>';
    tabla_shipping_order_lines +='<hr/>';
    tabla_shipping_order_lines +='<table border="0" cellspacing="5" cellpadding="5" id="table_invoice" >';
    tabla_shipping_order_lines += '<tr>';
    tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">LINE</th>';
    tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">ITEM CODE</th>';
    tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">ITEM, DIMENSIONS,</br> MATERIAL, </br> WEIGHT, </br>COLOURS</th>';
    tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">LOGO: TYPE, COLOR.,</br> POS., DESCRIP., </br>DIMENS.</th>';
    tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">PACKAGING</th>';
    tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">SPECIAL </br>PACKAGING </br>REQUIREMENTS</th>'; 
    tabla_shipping_order_lines += '  <th align="center" style="text-align: center;">REQUIRED </br>CERTIFICATIONS</th>';
    tabla_shipping_order_lines += '</tr>';
    if(lista_de_lineas_envios != null)
        for(Shipment_Line__c ship_li : lista_de_lineas_envios)
        {
          tabla_shipping_order_lines += '  <tr>';
          tabla_shipping_order_lines += '    <td align="center">'+(ship_li.Name != null ? ship_li.Name :'')+'</td>';
          tabla_shipping_order_lines += '    <td align="center">'+ship_li.Item_Name__r.Sourcing_Item_Code__c+' | '+ship_li.Item_Name__r.Sourcing_Item_Code__c+'</td>';//--- falta un tipo de codigo
          tabla_shipping_order_lines += '    <td align="center">'+ship_li.Item_Name__r.Name+', '+ship_li.Packaging_Volume_m3__c+'m3, '+ship_li.Packaging_Weight_kg__c+'kg</td>';
          tabla_shipping_order_lines += '    <td align="center"></td>';//------------rellenar estos
          tabla_shipping_order_lines += '    <td align="center"></td>';
          tabla_shipping_order_lines += '    <td align="center"></td>';
          tabla_shipping_order_lines += '    <td align="center"></td>';//'+(o.Item_Name__r.Item_Description__c != null ? o.Item_Name__r.Item_Description__c : '')+'
          tabla_shipping_order_lines += '</tr>';
        }
        
    tabla_shipping_order_lines +='          </table>';
    tabla_shipping_order_lines += '     </div>';    
    tabla_shipping_order_lines += '</div>';
    //----------------------------------------
    //tabla a enviar en el correo cabecera
    tabla_shipping_order = '<div id="contenedor" style="    width: 700px;">';
    tabla_shipping_order +='    <div id="top" >';
    tabla_shipping_order +='        <table style="    float: left;  width: 700px;"><tr><th style="width: 50%;     color: #642279;     text-align: center;" colspan="2">INSPECTION BOOKING</th></tr></table>';
    tabla_shipping_order += '   </div>';
    tabla_shipping_order +='    <div id="mid" >';
    tabla_shipping_order +='        <table border="0" cellspacing="5" cellpadding="5" id="table_invoice" style="height: 400px;">';  
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th>Inspection Company</th>';
    tabla_shipping_order +='                <td></td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th>Supplier</th>';
    tabla_shipping_order +='                <td>'+(record.Supplier_Account__c != null ? record.Supplier_Account__r.Name : '')+'</td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th >Factory address</th>';
    tabla_shipping_order +='                <td></td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th> Supplier contact person</th>';
    tabla_shipping_order +='                <td>'+(record.Contact__c != null ? record.Contact__r.Name : '')+'</td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th>Supplier contact Tel.</th>';
    tabla_shipping_order +='                <td>'+(record.Contact__c != null ? record.Contact__r.Phone : '')+'</td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th>Shipment nr</th>';
    tabla_shipping_order +='                <td>'+record.Name+'</td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th>Goods ready date (DT)</th>';
    tabla_shipping_order +='                <td></td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th>Estimated Time of Departure (ETD)</th>';
    if(record.ETD_from_Point_of_Load__c != null)
        tabla_shipping_order +='                <td >'+record.ETD_from_Point_of_Load__c+'</td>';
    else
        tabla_shipping_order +='                <td ></td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th>Suggested inspection date</th>';
    tabla_shipping_order +='                <td></td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='            <tr>';
    tabla_shipping_order +='                <th>Inspection fee </th>';
    tabla_shipping_order +='                <td></td>';
    tabla_shipping_order +='            </tr>';
    tabla_shipping_order +='        </table>';
    tabla_shipping_order += '   </div>';
    
    
   
    
     //incluir tabla abajo las cuentas del shipment
    clientes_seleccionados = new List<cuenta_s>();
    addaccount(record.Account_for__r,record.Account_for__c,'Account for (Buyer)');
    if(record.Carrier__c!=null)
      addaccount(record.Carrier__r,record.Carrier__c,'Carrier');
    if(record.Consignee__c != null)
        addaccount(record.Consignee__r,record.Consignee__c,'Consignee Account (Destination)');
    if(record.Forwarder__c!=null)
      addaccount(record.Forwarder__r,record.Forwarder__c,'Forwarder');
    if(record.Notify_Party__c != null)
        addaccount(record.Notify_Party__r,record.Notify_Party__c,'Notify Party');
    if(record.Shipper__c != null)
       addaccount(record.Shipper__r,record.Shipper__c , 'Shipper');
    if(record.Supplier_Account__c!=null)
      addaccount(record.Supplier_Account__r,record.Supplier_Account__c,'Supplier/Shipper Account (Origin)');
          

    usuarios = [select Id, Name, IsActive, Email from User where IsActive = true and  ContactId =: null and (NOT  Name like: '%Guest User%') limit 1000];
    for(User us : usuarios)
          select_users .add(new SelectOption(us.Id,us.Name));
    
    porc_ocupacion = '0';
    bytesocupados   = 0;

    List<Associated_Document__c> documents = new List<Associated_Document__c>();
    documents = [select Id, Name, Document_Description__c, Document_Reference__c, Document_Type__c, Document_URL__c, Shipment__c, Account__c
    from Associated_Document__c where Shipment__c =: record.Id order by Document_Type__c];
      
    List<documents_s> docs = new List<documents_s>();
    
    for(Associated_Document__c ad : documents)
    {
        String id_doc = '';
      if (!Test.isRunningTest()) 
          if(ad.Document_URL__c != null && ad.Document_URL__c != '')
          {
            if(ad.Document_URL__c.contains('?id=') == true)
                id_doc = ad.Document_URL__c.substringBetween('?id=','&oid=');
              else if(ad.Document_URL__c.contains('?file=') == true)
                id_doc = ad.Document_URL__c.substringBetween('?file=','&oid=');
              docs.add(new documents_s(false, ad.Name, ad.Document_Type__c, ad.Document_Reference__c, ad.Document_Description__c, (ad.Document_URL__c != null ? ad.Document_URL__c : ''), id_doc,0,'0'));
          }
    }

    if (!Test.isRunningTest()) 
    {
        for(documents_s ad : docs)
        {
            if(ad.id_doc != null)
            {
                List<Document> doc = [select Id, Name, Body from Document where Id =: ad.id_doc];
             
                if(doc.size()>0)
                { 
                  Blob b = doc[0].Body;
                  ad.espacio = b.size();
                  if(b.size()> 5242880)
                      ad.porespacio = '100';
                  else
                     ad.porespacio = string.valueof(b.size()*100/5242880);  
                }
            
            }
        }
    }
    associated_documents = docs;
  }
  
  public void send_email()
  {
    List<Contact> contacts = [select Id, Name, Email, AccountId from Contact where Email != null and AccountId =: record.Account_for__c];

    List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();
    
    String[] receptores = new String[]{};// email contactos seleccionados tabla cuentas
    String[] receptoresId = new String[]{};// id contactos seleccionados tabla cuentas crear tarea
    String[] receptores_users= new String[]{};// usuarios seleccionados para el email
    string nombre_documentos_enviados = '';
    Set<Id> list_contactos = new Set<id>();
    //Email Administración
    if(user_list != null && user_list != '' && user_list != '[]')
      receptores_users = user_list.split(',',0);
    
      //--------------------
    //envio de documentos adjuntos
     List<Messaging.EmailFileAttachment> documentos_adjuntos = new List<Messaging.EmailFileAttachment>();
    total_peso_ficheros =0;
    integer lugar_extension_fichero = 0;
    string nombre_ficheros_extension = '';
    string nombre_ficheros = '';
      
    for(documents_s ad : associated_documents)
    {
        if(ad.selected)
        {
           List<Document> doc = [select Id, Name, Body, Type, DeveloperName from Document where Id =: ad.id_doc];
           nombre_documentos_enviados += ad.Name +' ('+URL.getSalesforceBaseUrl().toExternalForm() + ad.document_url+') \n';
          if(doc.size()>0)
          {
            
            Blob b = doc[0].Body;
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            if(ad.Name.contains('.') == true)
               efa.setFileName(ad.name);
            else
            {
               string documento_typo = doc[0].Type;
               efa.setContentType('application/'+documento_typo);
               string name_documento_adjunto = ad.name+'.'+doc[0].Type;
               efa.setFileName(name_documento_adjunto);
                 
            } 
            if(efa.FileName.contains('.html'))
                efa.FileName = efa.FileName.replace('.html','.'+doc[0].Type);
            efa.setBody(b);
            total_peso_ficheros += b.size();
            documentos_adjuntos.add(efa); 
          }
        }
    }
    
    //------------------------------  
    List<StaticResource> query_logo = [Select body, name, id,SystemModStamp, NamespacePrefix from StaticResource where Name = 'company_logo'];
    
    List<SObject> relaciones_con_task = new List<SObject>();

    String estilo_email = '';
    estilo_email += 'body{width:100%; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
    estilo_email += 'p{margin:0; font-family: Arial, Helvetica, sans-serif; font-size:12px;}';
    estilo_email += '.user_name{font-weight:bold;}';
    estilo_email += '#table_invoice{width: 700px;   margin: 10px 0 20px 0;  float: left;}';
    estilo_email += '#table_invoice th{color: #642279;  font-size: 12px; font-family:  Arial, Helvetica, sans-serif;    text-align: left;   padding-left: 0;    border-bottom: 2px solid #eadfed;   font-weight:normal;        font-size: 8px;     width: 50%;}';
    estilo_email += '#table_invoice td{color: #908e8e;  font-size: 12px;    font-family:  Arial, Helvetica, sans-serif; background: #f3ecf4;    font-size: 10px;     width: 50%;}';
    estilo_email += '.title_import_export_details{font-size: 12px!important;            font-weight: bold!important;            margin-top: 4px!important; color:#642279; font-family:  Arial, Helvetica, sans-serif;}';
    List<User> user_loged = [select Id, Name, FirstName, LastName, Department, Title, Street, Phone, MobilePhone, Email 
    from User where Id =: UserInfo.getUserId() limit 1];
    String firma = '';
    if(user_loged.size() > 0)
    {
      firma += '<br/>';
      firma += '<p class="user_name">'+(user_loged[0].FirstName != null ? user_loged[0].FirstName : '')+' '+user_loged[0].LastName+'</p>';
      firma += '<p class="user_company">'+(user_loged[0].Department != null ? user_loged[0].Department : '')+'</p>';
      firma += '<p class="user_rol">'+(user_loged[0].Title != null ? user_loged[0].Title : '')+'</p>';
      firma += '<br/>';
      firma += '<p class="user_address2">'+(user_loged[0].Street != null ? user_loged[0].Street : '')+'</p>';
      //firma += '<p class="user_phone">Tel: '+(user_loged[0].Phone != null ? user_loged[0].Phone : '')+', Móvil: '+(user_loged[0].MobilePhone != null ? user_loged[0].MobilePhone : '')+'</p>';
      //firma += '<p class="user_email">E-mail: '+(user_loged[0].Email != null ? user_loged[0].Email : '')+'</p>';
      firma += '<br/>';
      firma += '<img src="'+URL.getSalesforceBaseUrl().toExternalForm()+'/resource/'+ query_logo[0].SystemModStamp.getTime() + '/'+ (query_logo[0].NamespacePrefix != null && query_logo[0].NamespacePrefix!= '' ? query_logo[0].NamespacePrefix+ '__' : '')+ 'company_logo" />';
    }
    boolean hay_envio = false;
    String contactos = '';
    String texto_email_form = texto_email;
    
    if(clientes_seleccionados != null)
    {
      for(cuenta_s c : clientes_seleccionados)
      {
        if(c.contactos != null)
        {
          for(contacto_s con : c.contactos)
          {
            if(con.selected)
            {
              receptores.add(con.contact.Email);
              receptoresId.add(con.contact.Id);
              contactos += con.contact.Name+', ';
            //  list_contactos.add(con.contact.Id);
              hay_envio = true;
            }
          }
        }

        if(receptores.size()>0)
        {
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setFileAttachments(documentos_adjuntos);
          mail.setToAddresses(receptores);
          mail.setCcAddresses(receptores_users);
          mail.setSenderDisplayName((user_loged.size() > 0 ? (user_loged[0].FirstName != null ? user_loged[0].FirstName : '') +' '+user_loged[0].LastName : 'Kaelis'));
          mail.setSubject(asunto);
          mail.setBccSender(false); 
          mail.setUseSignature(false); 
          mail.setCharset('UTF-8');
          mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+tabla_shipping_order+' '+tabla_shipping_order_lines+'<br/>'+(texto_email != null ? texto_email.replace('\n','<br/>') : '')+'<br/>'+firma+'</body></html>');
          theEmails.add(mail);
          
          receptores.clear();
         //list_contactos = new List<id>();
          receptoresId.clear();
          contactos = '';
        
        }
      }
    }
    
    // si no hay ningun cliente envio a los users
    if(hay_envio == false)
    {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setFileAttachments(documentos_adjuntos);
      mail.setToAddresses(receptores_users);
      mail.setSenderDisplayName((user_loged.size() > 0 ? (user_loged[0].FirstName != null ? user_loged[0].FirstName : '')  +' '+user_loged[0].LastName : 'Kaelis'));
      mail.setSubject(asunto);
      mail.setBccSender(false); 
      mail.setUseSignature(false); 
      mail.setCharset('UTF-8');
      mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">'+estilo_email+'</style></head><body>'+tabla_shipping_order+' '+tabla_shipping_order_lines+'<br/>'+(texto_email != null ? texto_email.replace('\n','<br/>') : '')+'<br/>'+firma+'</body></html>');
      theEmails.add(mail);
      
    }
        
    List<Messaging.Email> allMails = new List<Messaging.Email>();
    for(Integer j = 0; j < theEmails.size(); j++)
    {
      allMails.add(theEmails.get(j));
    }
    
    try
    {
      Messaging.SendEmailResult[] results = Messaging.sendEmail(allMails);
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'The email was sent successfully.'));
    }
    catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}
    
    receptores.clear();
    list_contactos = new Set<id>();
    receptoresId.clear();
    contactos = '';
    //insertar tareas despues del envio del email
    if(clientes_seleccionados != null)
    {
      for(cuenta_s c : clientes_seleccionados)
      {
        if(c.contactos != null)
        {
          for(contacto_s con : c.contactos)
          {
            if(con.selected)
            {
              receptores.add(con.contact.Email);
              receptoresId.add(con.contact.Id);
              contactos += con.contact.Name+', ';
              list_contactos.add(con.contact.Id);
              hay_envio = true;
            }
          }
        }
        
        if(receptores.size()>0)
        {
          if(create_task == true)
          {
              //TAREA CUENTA
              Task new_task_account = new Task();
              new_task_account.ActivityDate = Due_Date_task.Conversion_Rate_Date__c;
              new_task_account.Subject = subject_task ;//'Shipment Order';
              new_task_account.Status = Status_task;
              new_task_account.Type = 'Email';
              new_task_account.OwnerId = OwnerId_task;
              new_task_account.WhatId = record.Id;
              if(!NEU_TaskUtils.withTaskRelation())
                new_task_account.WhoId = receptoresId[0];
              new_task_account.Priority = priority_task;
              new_task_account.Send_Inspection_Booking__c  = true;
              string descripcion_email = (texto_email != null ? texto_email + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados  :'')) ;
              new_task_account.Description = descripcion_email;//(descripcion_email != null ? (descripcion_email.length() < 255 ? descripcion_email : descripcion_email.substring(0,255)) :'');
              
              
              try
              {
                insert new_task_account;
              }
              catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}  
              
              for(Id i: list_contactos)
              {
                SObject new_task_relation=NEU_TaskUtils.newTaskRelation(new_task_account.Id,false,i);
                if(new_task_relation!=null)
                    relaciones_con_task.add(new_task_relation);
              }
          } 
          
          
        }
        receptores.clear();
          list_contactos = new Set<id>();
          receptoresId.clear();
          contactos = '';
      }
    } 
        
     // si no hay ningun cliente envio a los users
    if(hay_envio == false)
    {
         if(create_task == true)
         {
              //TAREA CUENTA
              Task new_task_account = new Task();
              new_task_account.ActivityDate = Due_Date_task.Conversion_Rate_Date__c;
              new_task_account.Subject = subject_task ;//'Shipment Order';
              new_task_account.Status = Status_task;
              new_task_account.Type = 'Email';
              new_task_account.OwnerId = OwnerId_task;
              new_task_account.WhatId = record.Id;
              new_task_account.Priority = priority_task;
              new_task_account.Send_Inspection_Booking__c  = true;
              string descripcion_email = (texto_email != null ? texto_email + (nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :''):(nombre_documentos_enviados != '' ? '\n Documents: \n '+nombre_documentos_enviados :'')) ;
              new_task_account.Description = descripcion_email;//(descripcion_email != null ? (descripcion_email.length() < 255 ? descripcion_email : descripcion_email.substring(0,255)) :'');
             
              try
              {
                 insert new_task_account;
              }
              catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}  
          
          }
    }
        
        
       //CREACIÓN DE TAREAS
        if(create_task == true)
        {
            if(relaciones_con_task.size()>0)
            {
                try
                {
                    insert relaciones_con_task;
                }
                catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: '+ex));}
            }
        }
  }
  
  public PageReference return_shipment()
  {
    PageReference pgReturnPage;
    String returnUrl = '/' + record.Id;
      pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
    return pgReturnPage;
  }
}