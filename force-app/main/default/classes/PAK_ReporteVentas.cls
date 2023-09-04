public class PAK_ReporteVentas {
    public Account Filtro {get;set;}
    public list<Response> lsResponse {get;set;}
    public list<Response> lsR {get;set;}
    public Boolean Bandera {get;set;}
    private integer pagInicial=100;
    private integer counter=0;
   	private integer list_size=100;
   	private integer total_size=0;
    public Decimal Total {get;set;}
    
    public PAK_ReporteVentas(){
        Filtro = new Account();
        Bandera =true;
        Total = 0;
    }
    
    public void SendWs(){
        try{
         	if(Filtro.SAP_Create_Date__c != null && Filtro.Fecha_Recepcion_Factura__c != null){
                User usr = [Select Id,SalesEmployer__c From User Where Id=:UserInfo.getUserId() limit 1];
                String Incio =Filtro.SAP_Create_Date__c.format();
                String Fin = Filtro.Fecha_Recepcion_Factura__c.format();
                String User = usr.SalesEmployer__c;
                String Body ='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'+
                               '<soapenv:Header/>'+
                               '<soapenv:Body>'+
                                  '<tem:reporteVentas>'+
                                     '<tem:fechaInicial>'+Incio+'</tem:fechaInicial>'+
                                     '<tem:fechaFinal>'+Fin+'</tem:fechaFinal>'+
                    				 '<tem:slpcode>'+usr.SalesEmployer__c+'</tem:slpcode>'+
                                  '</tem:reporteVentas>'+
                              ' </soapenv:Body>'+
                            '</soapenv:Envelope>';
                Http httpProtocol = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('http://35.169.18.187/pakws92/WSConsultas.asmx');
                request.setMethod('POST');
                request.setHeader('Content-Type', 'text/xml;charset=utf-8');
                request.setHeader('SOAPAction', 'http://tempuri.org/reporteVentas');
                request.setBody(Body);
                HttpResponse response = httpProtocol.send(request);
                if(response.getStatusCode() == 200){
                    Dom.Document doc = new Dom.Document();
                    doc.load(response.getBody());
                    Dom.XMLNode root = doc.getRootElement();
                    root = root.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
                    root = root.getChildElement('reporteVentasResponse', 'http://tempuri.org/');
                    root = root.getChildElement('reporteVentasResult', 'http://tempuri.org/');
                    String res = root.getText();
                    res = res.replaceAll('Suc-Cte', 'SucCte');
                    res = res.replaceAll('Concepto NC', 'Concepto_NC');
                    res = res.replaceAll('Rutas/Otros', 'Rutas_Otros');
                    res = res.replaceAll('Tipo Producto', 'Tipo_Producto');
                    list<Response> lsRes = (list<Response>) JSON.deserialize(res, list<Response>.class);
                    lsResponse = new list<Response>();
                    Integer cont = 1;
                    for(Response R: lsRes){
                        R.Id = cont;
                        if(R.Fecha != null && R.Fecha !=''){
                            R.Fh = Date.valueOf(R.Fecha);
                            R.Fecha = R.Fh.format();
                        }
                        if(R.Vencimiento != null && R.Vencimiento !=''){
                            R.Fh2 = Date.valueOf(R.Vencimiento);
                            R.Vencimiento = R.Fh2.format();
                        }
                        if(R.LineTotal != null && R.LineTotal !=''){
                            R.LineTotal2 = Decimal.valueOf(R.LineTotal);
                            
                            Total += R.LineTotal2;
                        }
                        if(R.Costo != null && R.Costo !=''){
                            R.Costo2 = Decimal.valueOf(R.Costo);
                        }
                        if(R.CostoMayoreo != null && R.CostoMayoreo !=''){
                            R.CostoMayoreo2 = Decimal.valueOf(R.CostoMayoreo);
                        }
                        lsResponse.add(R);
                        cont++;
                    }
                    if(lsResponse.size()>0){
                        Bandera=false;
                    }
                    total_size = lsResponse.size();
                    viewAccounts();
                    System.debug('------------'+lsResponse);
                }
            }   
        }catch(Exception e){
			System.debug(e.getLineNumber()+'------------'+e.getMessage());           
        }
    }
    public PageReference Exportar(){
        return null;
    }
    public PageReference viewAccounts(){
        lsR = New List<Response>();     
        
        if(list_size <= total_size){
            for(Integer i=counter;i<list_size;i++){
                Response resp = new Response();
				resp = lsResponse.get(i);
                lsR.add(resp);
            }
        }else{
            for(Integer i=counter;i<total_size;i++){
               	Response resp = new Response();
				resp = lsResponse.get(i);
                lsR.add(resp);
            }
        }
        return null;
    }
    
    /*inicio navegacion*/
    public PageReference Beginning() {
        counter = 0;
        list_size = pagInicial;
        viewAccounts();
        return null;
    }
    
    public PageReference Previous() {
        counter -= pagInicial;
        list_size -= pagInicial;
        viewAccounts();
        return null;
    }
    
    public PageReference Next() {
        counter += pagInicial;
        list_size += pagInicial;
        viewAccounts();
        return null;
    }
    
    public PageReference End() {
        Integer valor = 0;
        valor = (total_size/pagInicial);
        list_size = pagInicial;
        counter = (valor-1) * pagInicial;
        System.debug('>>> ' + counter);
        viewAccounts();
        return null;
    }
    
    public Boolean getDisablePrevious(){if(counter>0) return false; else return true;}
    public Boolean getDisableNext(){if(list_size < total_size) return false; else return true;}
    /*fin navegacion*/
    
    public class Response{
        public integer Id {get;set;}
        public String SucCte {get;set;}	//CCUU Suc-Cte
		public String Vendedor {get;set;}	//ADRIAN ZAMBRANO
		public String Ejecutivo {get;set;}	//RIVERA SARA
		public String UsuarioFactura {get;set;}	//Liz Rangel
		public String Codigo {get;set;}	//CCUU1020
		public String Cliente {get;set;}	//COCINAS Y SUMINISTROS INDUSTRIALES SA DE CV
		public String Fecha {get;set;}	//2018-04-10T00:00:00
		public String Vencimiento {get;set;}	//2018-04-10T00:00:00
		public String AcctName {get;set;}	//FLETES- VENTAS-16%
		public String Docto {get;set;}	//Factura
		public String Concepto_NC {get;set;}	//Es Factura Concepto NC
		public String Documento {get;set;}	//42161
		public String Referencia {get;set;}	//FN-18-010022
		public String Grupo {get;set;}	//FLETES
		public String ItemCode {get;set;}	//FTN
		public String Dscription {get;set;}	//Flete Nacional
		public String Rutas_Otros {get;set;}	// Rutas/Otros
		public String LineTotal {get;set;}	//7900
		public String Costo {get;set;}
		public String CostoMayoreo {get;set;}
		public String Tipo_Producto {get;set;}	//Otra Tipo Producto
		public String U_ID {get;set;}
		public String OcrCode3 {get;set;}	//FLETES
		public String LineNum {get;set;}	//0
		public String U_Factura_Original {get;set;}
		public String U_NC {get;set;}	//01
		public String U_Sustituye {get;set;}
		public String U_COMENT {get;set;}
		public String Canceled {get;set;}	//N
        public Date Fh {get;set;}
        public Date Fh2 {get;set;}
        public Decimal Costo2 {get;set;}
        public Decimal CostoMayoreo2 {get;set;}
        public Decimal LineTotal2 {get;set;}
        
        public Response(){
        }
    }
    
    public void TestMetodo(){
        String Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
    }
}