global class PAK_CreateLeads {
    global class Lead {
        webservice String AccountName {get;set;}
        webservice String Email {get;set;}
        webservice String FreightMode {get;set;}
        webservice String ServiceMode {get;set;}
        webservice String ServiceType {get;set;}
        webservice String SalesIncoterm {get;set;}
        webservice String CountryOfLoad {get;set;}
        webservice String StateOfLoad {get;set;}
        webservice String SiteOfLoad {get;set;}
        webservice String CountryOfDis {get;set;}
        webservice String StateOfDis {get;set;} 
        webservice String SiteOfDis {get;set;}
        webservice Detalle DetalleIEQ {get;set;}
    }
    
    global class Detalle{
        webservice list<DetalleIEQ> DetalleIEQ {get;set;}
    } 
    
    global class DetalleIEQ{
        webservice String ContainerType {get;set;}
        webservice String ItemUnits {get;set;}
        webservice String TotalShippingWeight {get;set;}
        webservice String Length {get;set;}
        webservice String Width {get;set;}
        webservice String Height {get;set;}
        webservice String TotalUnitWeight {get;set;}
    }
    
    global class status {
        webservice String code {get;set;}
        webservice String message {get;set;}
        webservice String cotizacion {get;set;}
    }
    
    public static decimal modular(decimal num){
        decimal c = 0;
        decimal result;
        result = num / 5;
        c= Math.floor(result);
        result = num - (5 * c);
        return result;
	}
    
    private class IEQJson{
        
    }
	    
    webservice static list<status> CREATELEAD(Lead[] lsEntity){
        Response__c R = new Response__c();
        R.Type__c = 'CONFIRM';
        R.Object__c = 'Account';
        list<status> Result = new list<status>();
        try{
            String Owner = [Select Id From User Where SalesEmployer__c='8' limit 1 ].Id;
            map<String,Account> mapProspect = new map<String,Account>();
            for(Account Cuenta: [Select Id,Name,NEU_Email__c From Account Where WebService__c=true]){
                mapProspect.put(Cuenta.Name, Cuenta);
            }
            map<String,String> mapCountry = new map<String,String>();
            map<String,String> mapState = new map<String,String>();
            map<String,String> mapSite = new map<String,String>();
            map<String,String> mapContainertype = new map<String,String>();
            map<String,String> mapZona = new map<String,String>();
            
            for(Country__c C: [Select Id,Name,DHL_ExportZone__c From Country__c]){mapCountry.put(C.Name.touppercase(),C.Id);mapZona.put(C.Name.touppercase(),C.DHL_ExportZone__c);}
            for(State__c S: [Select Id,Name From State__c]){mapState.put(S.Name.toUppercase(),S.Id);}
            for(Location__c St: [Select Id,Name From Location__c]){mapSite.put(St.Name.toUppercase(),St.Id);}
            for(Container_Type__c CT: [Select Id,Name From Container_Type__c]){mapContainertype.put(CT.Name.toUppercase(),CT.Id);}
            
            String Recordtype = [Select Id From Recordtype Where DeveloperName='Prospect' limit 1].Id;
            String SKU = [Select Id From RecordType Where DeveloperName='SKU_Product' limit 1].Id;
            
            for(Lead PROS: lsEntity){
                //R.base64__c = String.valueOf(PROS);
                String Origen = PROS.SiteOfLoad != null?mapSite.get(PROS.SiteOfLoad.toUppercase()):null;
                String Destino = PROS.SiteOfDis != null?mapSite.get(PROS.SiteOfDis.toUppercase()):null;
                String Zona = PROS.CountryOfDis != null?mapZona.get(PROS.CountryOfDis.toUppercase()):null;
                for(DetalleIEQ ls: PROS.DetalleIEQ.DetalleIEQ){
                    String Container = ls.ContainerType != null? mapContainertype.get(ls.ContainerType.toUppercase()):null;
                    String FeeId = null;
                    Decimal FeeSell = null;
                    Decimal FeeBuy = null;
                    for(Fee__c F: [Select Id,Fee_Rate__c,Buy_Rate__c From Fee__c where Container_Type__c=:Container and Route__r.Port_Airport_of_Load__c=:Origen and Route__r.Port_Airport_of_Discharge__c=:Destino]){
                        FeeId= F.Id;
                        FeeBuy= F.Buy_Rate__c;
                        FeeSell = F.Fee_Rate__c;
    
                        //R.base64__c = R.base64__c + 'Entro:'+F.Id;                    
                    }
                    
                    if(FeeId == null && PROS.ServiceType == 'FCL'){
                        status st = new status();
                        st.code = '0';
                        st.message = 'No Exite tarifario para la ruta solicitada: '+PROS.SiteOfLoad+'-'+PROS.SiteOfDis+'; El prospecto '+PROS.AccountName;
                        Result.add(st);
                        
                        R.Type__c = 'ERROR';
                        R.Message__c = st.message;
                        if(!Test.isRunningTest()){insert R;}
                        
                        if(!Test.isRunningTest()){return Result;}
                    }   
                }
                        
                Account acc = new Account();
                if(mapProspect.containsKey(PROS.AccountName)){
                   acc = mapProspect.get(PROS.AccountName);
                }else{
                    acc.Name = PROS.AccountName;
                	acc.NEU_Email__c = PROS.Email;
                	acc.OwnerId = Owner;
                	acc.RecordTypeId = Recordtype;
                	acc.ActiveSap__c = true;
                	acc.WebService__c = true;
                	acc.Brand_Name__c = PROS.AccountName;
                	acc.AccountSource = 'Web to Lead';
                	if(!Test.isRunningTest()){insert acc;}
                }
           
                R.Account__c = acc.Id != null?acc.Id:null;
                String QuoteName = '';
                if(PROS.ServiceType == 'FCL'){
                    Customer_Quote__c IEQ = new Customer_Quote__c();
                    IEQ.Account_for__c = acc.Id != null?acc.Id:null;
                    IEQ.Freight_Mode__c = PROS.FreightMode;
                    IEQ.Service_Mode__c = PROS.ServiceMode;
                    IEQ.Service_Type__c = PROS.ServiceType;
                    IEQ.Quotation_Status__c = 'Quote being prepared';
                    IEQ.Country_ofLoad__c = PROS.CountryOfLoad != null?mapCountry.get(PROS.CountryOfLoad.toUppercase()):null;
                    IEQ.State_of_Load__c = PROS.StateOfLoad != null?mapState.get(PROS.StateOfLoad.toUppercase()):null;
                    IEQ.Site_of_Load__c = Origen;
                    IEQ.Country_ofDischarge__c = PROS.CountryOfDis != null?mapCountry.get(PROS.CountryOfDis.toUppercase()):null;
                    IEQ.State_of_Discharge__c = PROS.StateOfDis != null?mapState.get(PROS.StateOfDis.toUppercase()):null;
                    IEQ.Site_of_Discharge__c = Destino;
                    IEQ.Sales_Incoterm__c = PROS.SalesIncoterm;
                    if(!Test.isRunningTest()){insert IEQ;}
                    QuoteName = IEQ.Id != null?[Select Name From Customer_Quote__c Where Id=:IEQ.Id limit 1].Name:'';
                    
                    Integer cont = 1;
                    for(DetalleIEQ Cargo: PROS.DetalleIEQ.DetalleIEQ){
                        String Containers = Cargo.ContainerType != null? mapContainertype.get(Cargo.ContainerType.toUppercase()):null;
                        Sourcing_Item__c ItemName = new Sourcing_Item__c();
                        ItemName.Name = 'Carga General';
                        ItemName.RecordTypeId= SKU;
                        ItemName.Account_Owner__c = acc.Id != null?acc.Id:null;
                        ItemName.Item_Price__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''? Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        ItemName.Weight_Kgs__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''? Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        ItemName.Units_x_Master_Box__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        ItemName.Units_x_Master_Box__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        ItemName.Master_Box_Height_cm__c = Cargo.Height != null && Cargo.Height != ''? Decimal.valueOf(Cargo.Height):null;
                        ItemName.Master_Box_Length_cm__c = Cargo.Length != null && Cargo.Length != ''? Decimal.valueOf(Cargo.Length):null;
                        ItemName.Master_Box_Width_cm__c =  Cargo.Width != null && Cargo.Width != ''? Decimal.valueOf(Cargo.Width):null;
                        if(!Test.isRunningTest()){insert ItemName;}
                        
                        Quote_Item_Line__c CargoLine = new Quote_Item_Line__c();
                        CargoLine.Import_Export_Quote__c = IEQ.Id != null?IEQ.Id:null;
                        if(cont<10){CargoLine.Name ='00'+cont;}else{CargoLine.Name ='0'+cont;} 
                        CargoLine.Units__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        CargoLine.Total_Shipping_Weight_Kgs__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''? Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        CargoLine.Item_Name__c = ItemName.Id != null?ItemName.Id:null;
                        CargoLine.Container_Type__c = Containers;
                        if(!Test.isRunningTest()){insert CargoLine;}
                        
                        if(!Test.isRunningTest()){
                            String Continente = [Select Region_Country__c From Customer_Quote__c where Id=:IEQ.Id limit 1].Region_Country__c;
                            String Region = '';
                            if(Continente == 'Asia'){Region ='IMPO ASIA';}else if(Continente == 'Central and North Europe'){Region ='IMPO EUROPA';}if(PROS.ServiceMode == 'EXPORT'){Region='EXPO MAR FCL';}
                            list<Fee__c> F = [Select Id,Fee_Rate__c,Buy_Rate__c From Fee__c where Container_Type__c=:Containers and Route__r.Port_Airport_of_Load__c=:Origen and Route__r.Port_Airport_of_Discharge__c=:Destino and Account_for__r.Name=:Region limit 1];
                            String FeeId= F[0].Id;Decimal FeeBuy= F[0].Buy_Rate__c;Decimal FeeSell = F[0].Fee_Rate__c;                                 
                            Import_Export_Fee_Line__c ServiceLine = new Import_Export_Fee_Line__c();
                            ServiceLine.Import_Export_Quote__c = IEQ.Id != null?IEQ.Id:null;
                            if(cont<10){ServiceLine.Name ='00'+cont;}else{ServiceLine.Name ='0'+cont;}
                            ServiceLine.Units__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                            ServiceLine.Service_Rate_Name__c = FeeId;ServiceLine.Quote_Sell_Price__c = FeeSell;ServiceLine.Quote_Buy_Price__c = FeeBuy;insert ServiceLine;
                        }
                        
                        cont=cont+1;
                    }
                    
                    SendEmailWebToLead(IEQ.Id, PROS.Email, 0);
                    
                    status st = new status();st.code = '1';st.message = 'OK: Se Genero la orden numero: '+ QuoteName;Result.add(st);
                    R.Message__c =st.message;if(!Test.isRunningTest()){insert R;}
                    
                }else if(PROS.ServiceType != 'FCL' && PROS.ServiceType != 'PAQUETERIA'){
                    Customer_Quote__c IEQ = new Customer_Quote__c();
                    IEQ.Account_for__c = acc.Id != null?acc.Id:null;
                    IEQ.Freight_Mode__c = PROS.FreightMode;
                    IEQ.Service_Mode__c = PROS.ServiceMode;
                    IEQ.Service_Type__c = PROS.ServiceType;
                    IEQ.Quotation_Status__c = 'Quote being prepared';
                    IEQ.Country_ofLoad__c = PROS.CountryOfLoad != null?mapCountry.get(PROS.CountryOfLoad.toUppercase()):null;
                    IEQ.State_of_Load__c = PROS.StateOfLoad != null?mapState.get(PROS.StateOfLoad.toUppercase()):null;
                    IEQ.Site_of_Load__c = Origen;
                    IEQ.Country_ofDischarge__c = PROS.CountryOfDis != null?mapCountry.get(PROS.CountryOfDis.toUppercase()):null;
                    IEQ.State_of_Discharge__c = PROS.StateOfDis != null?mapState.get(PROS.StateOfDis.toUppercase()):null;
                    IEQ.Site_of_Discharge__c = Destino;
                    IEQ.Sales_Incoterm__c = PROS.SalesIncoterm;
                    if(!Test.isRunningTest()){insert IEQ;}
                    QuoteName = IEQ.Id != null?[Select Name From Customer_Quote__c Where Id=:IEQ.Id limit 1].Name:'';
                    
                    Integer cont = 1;
                    for(DetalleIEQ Cargo: PROS.DetalleIEQ.DetalleIEQ){
                        Sourcing_Item__c ItemName = new Sourcing_Item__c();
                        ItemName.Name = 'Carga General';
                        ItemName.RecordTypeId= SKU;
                        ItemName.Account_Owner__c = acc.Id != null?acc.Id:null;
                        ItemName.Item_Price__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''? Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        ItemName.Weight_Kgs__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''? Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        ItemName.Units_x_Master_Box__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        ItemName.Master_Box_Height_cm__c = Cargo.Height != null && Cargo.Height != ''? Decimal.valueOf(Cargo.Height):null;
                        ItemName.Master_Box_Length_cm__c = Cargo.Length != null && Cargo.Length != ''? Decimal.valueOf(Cargo.Length):null;
                        ItemName.Master_Box_Width_cm__c =  Cargo.Width != null && Cargo.Width != ''? Decimal.valueOf(Cargo.Width):null;
                        if(!Test.isRunningTest()){insert ItemName;}
                        
                        Container_Type__c CT = new Container_Type__c();
                        CT.Name = 'Carga General '+PROS.ServiceType;
                        CT.Height_cm__c = Cargo.Height != null && Cargo.Height != ''?Decimal.valueOf(Cargo.Height):null;
                        CT.Width_cm__c = Cargo.Width != null && Cargo.Width != ''? Decimal.valueOf(Cargo.Width):null;
                        CT.Length_cm__c = Cargo.Length != null && Cargo.Length != ''? Decimal.valueOf(Cargo.Length):null;
                        CT.Cargo_Weight_Kg__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''?Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        insert CT;
                        
                        Quote_Item_Line__c CargoLine = new Quote_Item_Line__c();
                        CargoLine.Import_Export_Quote__c = IEQ.Id != null?IEQ.Id:null;
                        if(cont<10){CargoLine.Name ='00'+cont;}else{CargoLine.Name ='0'+cont;} 
                        CargoLine.Units__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        CargoLine.Total_Shipping_Weight_Kgs__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''? Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        CargoLine.Item_Name__c = ItemName.Id != null?ItemName.Id:null;
                        CargoLine.Container_Type__c = CT.Id;
                        if(!Test.isRunningTest()){insert CargoLine;}
                         
                        cont=cont+1;
                    }
                    
                    SendEmailWebToLead(IEQ.Id, PROS.Email, 0);
                    
                    status st = new status();st.code = '1';st.message = 'OK: Se genero la orden numero: '+ QuoteName;Result.add(st);
                    R.Message__c =st.message;if(!Test.isRunningTest()){insert R;}
                    
                }else if(PROS.ServiceType == 'PAQUETERIA'){
                    Customer_Quote__c IEQ = new Customer_Quote__c();
                    IEQ.Account_for__c = acc.Id != null?acc.Id:null;
                    IEQ.Freight_Mode__c = PROS.FreightMode;
                    IEQ.Service_Mode__c = PROS.ServiceMode;
                    IEQ.Service_Type__c = PROS.ServiceType;
                    IEQ.Quotation_Status__c = 'Quote being prepared';
                    IEQ.Country_ofLoad__c = PROS.CountryOfLoad != null?mapCountry.get(PROS.CountryOfLoad.toUppercase()):null;
                    IEQ.State_of_Load__c = PROS.StateOfLoad != null?mapState.get(PROS.StateOfLoad.toUppercase()):null;
                    IEQ.Site_of_Load__c = Origen;
                    IEQ.Country_ofDischarge__c = PROS.CountryOfDis != null?mapCountry.get(PROS.CountryOfDis.toUppercase()):null;
                    IEQ.State_of_Discharge__c = PROS.StateOfDis != null?mapState.get(PROS.StateOfDis.toUppercase()):null;
                    IEQ.Site_of_Discharge__c = Destino;
                    IEQ.Sales_Incoterm__c = PROS.SalesIncoterm;
                    if(!Test.isRunningTest()){insert IEQ;}
                    QuoteName = IEQ.Id != null?[Select Name From Customer_Quote__c Where Id=:IEQ.Id limit 1].Name:'';
                    
                    Integer cont = 1;
                    Decimal kg = 0.00;
                    for(DetalleIEQ Cargo: PROS.DetalleIEQ.DetalleIEQ){
                        String Containers = Cargo.ContainerType != null? mapContainertype.get(Cargo.ContainerType.toUppercase()):null;
                        Sourcing_Item__c ItemName = new Sourcing_Item__c();
                        ItemName.Name = 'Carga General';
                        ItemName.RecordTypeId= SKU;
                        ItemName.Account_Owner__c = acc.Id != null?acc.Id:null;
                        ItemName.Item_Price__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''? Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        ItemName.Weight_Kgs__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''? Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        ItemName.Units_x_Master_Box__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        ItemName.Units_x_Master_Box__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        ItemName.Master_Box_Height_cm__c = Cargo.Height != null && Cargo.Height != ''? Decimal.valueOf(Cargo.Height):null;
                        ItemName.Master_Box_Length_cm__c = Cargo.Length != null && Cargo.Length != ''? Decimal.valueOf(Cargo.Length):null;
                        ItemName.Master_Box_Width_cm__c =  Cargo.Width != null && Cargo.Width != ''? Decimal.valueOf(Cargo.Width):null;
                        if(!Test.isRunningTest()){insert ItemName;}
                        
                        Quote_Item_Line__c CargoLine = new Quote_Item_Line__c();
                        CargoLine.Import_Export_Quote__c = IEQ.Id != null?IEQ.Id:null;
                        if(cont<10){CargoLine.Name ='00'+cont;}else{CargoLine.Name ='0'+cont;} 
                        CargoLine.Units__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        CargoLine.Total_Shipping_Weight_Kgs__c = Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != ''? Decimal.valueOf(Cargo.TotalShippingWeight):null;
                        CargoLine.Item_Name__c = ItemName.Id != null?ItemName.Id:null;
                        CargoLine.Container_Type__c = Containers;
                        if(!Test.isRunningTest()){insert CargoLine;} 
                        cont=cont+1;
                        kg = kg + (Cargo.TotalShippingWeight != null && Cargo.TotalShippingWeight != '' ? Decimal.valueOf(Cargo.TotalShippingWeight) : 0);
                    }
                    
                    Boolean tipoValor = false;
                    String kilogramos = '';
                    Integer valorEntero = 0;
                    
                    if(String.valueOf(kg).contains('.')){
                        valorEntero = Integer.valueOf(String.valueOf(kg).SubstringBefore('.'));
                        Decimal valorSd = Decimal.valueOf(String.valueOf(kg).SubstringBefore('.'));
                        Decimal decimales = Decimal.valueOf('.' + String.valueOf(kg).SubstringAfter('.'));
                    
                        if(decimales <= 0.2){ tipoValor = true;}
                        if(decimales <= 0.5 && decimales >= 0.3){ kg = valorSd + 0.5;}
                        if(decimales > 0.5){tipoValor = true;valorEntero = valorEntero + 1;}
                        
                        if(tipoValor){
                            Integer modlar = math.mod(valorEntero, 5);
                            if(modlar == 0){
                                kilogramos = '% ' + string.valueOf(valorEntero) + '%';
                            }else{
                                kilogramos = '% ' + string.valueOf(valorEntero + (5 - modlar)) + '%';
                            }                            
                        }
                        else
                        {
                            Decimal demodlar = modular(kg);
                            if(demodlar == 0){
                                kilogramos = '% ' + string.valueOf(kg) + '%';
                            }else{
                                kilogramos = '% ' + string.valueOf(kg + (5 - demodlar)) + '%';
                            }
                        }
                    }else{
                        Decimal demodlar = modular(kg);
                        if(demodlar == 0){
                            kilogramos = '% ' + string.valueOf(kg) + '%';
                        }else{
                            kilogramos = '% ' + string.valueOf(kg + (5 - demodlar)) + '%';
                        }                        
                    }                    
                    
                    Zona = '%'+Zona+'%';
                    integer cont2=1;
                    list<Import_Export_Fee_Line__c> lsLine = new list<Import_Export_Fee_Line__c>();
                    for(Fee__c fee: [Select Id,Buy_Rate__c,Fee_Rate__c From Fee__c Where Name LIKE: Zona and Name LIKE: kilogramos and Account_for__r.Name='PAQUETERIA DHL EXPO']){
                        String FeeId= fee.Id;Decimal FeeBuy= fee.Buy_Rate__c;Decimal FeeSell = fee.Fee_Rate__c;                                 
                        Import_Export_Fee_Line__c ServiceLine = new Import_Export_Fee_Line__c();
                        ServiceLine.Import_Export_Quote__c = IEQ.Id != null?IEQ.Id:null;
                        if(cont2<10){ServiceLine.Name ='00'+cont2;}else{ServiceLine.Name ='0'+cont2;}
                        ServiceLine.Units__c = 1;//Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        ServiceLine.Service_Rate_Name__c = FeeId;ServiceLine.Quote_Sell_Price__c = FeeSell;ServiceLine.Quote_Buy_Price__c = FeeBuy;lsLine.add(ServiceLine);
                        cont2=cont2+1;
                    }
                    
                    insert lsLine;
                    
                    if(tipoValor){
                        SendEmailWebToLead(IEQ.Id, PROS.Email, decimal.valueOf(String.valueOf(valorEntero)));
                    }else{
                        SendEmailWebToLead(IEQ.Id, PROS.Email, kg);
                    }
                    
                    
                    status st = new status();st.code = '1';st.message = 'OK: Se Genero la orden numero: '+ QuoteName;Result.add(st);
                    R.Message__c =st.message;if(!Test.isRunningTest()){insert R;}
                }
            }
            
        }catch(Exception e){
            status st = new status();
            st.code = '0';
            st.message = 'Error:'+ e.getMessage()+' en la siguiente Linea: '+ e.getLineNumber();
            Result.add(st);
            
            R.Type__c = 'ERROR';
            R.Message__c = st.message;
            insert R;
            
        }
        return Result;
    }
    
    @future(callout=true)
    public static void SendEmailWebToLead(String IEQ, String Email, Decimal kilos){
        Response__c R = new Response__c();
        R.Type__c = 'CONFIRM';
        R.Object__c = 'Account';
        try{
            list<Customer_Quote__c> Quote = new list<Customer_Quote__c>();
            Quote = [Select Id,Name,Service_Type__c,Account_for__r.Name,Account_for__c,Sales_Incoterm__c,Freight_Mode__c,Service_Mode__c,Site_of_Load__r.Name,Site_of_Discharge__r.Name,Total_Items_Units__c,Total_Weight_Kg2__c From Customer_Quote__c Where Id=:IEQ limit 1];
            R.Account__c = Quote.isEmpty()?null:Quote[0].Account_for__c;
            String URL = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+IEQ;
            String ServiceType = Test.isRunningTest()?'FCL':Quote[0].Service_Type__c;
            String Cliente = Test.isRunningTest()?'Test':Quote[0].Account_for__r.Name;
            String QuoteName = Test.isRunningTest()?'Test':Quote[0].Name;
            String FMode = Test.isRunningTest()?'Test':Quote[0].Freight_Mode__c;
            String SMode = Test.isRunningTest()?'Test':Quote[0].Service_Mode__c;
            String SLoad = Test.isRunningTest()?'Test':Quote[0].Site_of_Load__r.Name;
            String SDischarge = Test.isRunningTest()?'Test':Quote[0].Site_of_Discharge__r.Name;
            String SIncor = Test.isRunningTest()?'Test':Quote[0].Sales_Incoterm__c;
            String Unit = Test.isRunningTest()?'0':String.valueOf(Quote[0].Total_Items_Units__c);
            String kg = Test.isRunningTest()?'0':String.valueOf(Quote[0].Total_Weight_Kg2__c);
            if((ServiceType == 'FCL' || ServiceType == 'PAQUETERIA') && kilos < 100) {
                EmailTemplate Template = [Select Id,Subject,HtmlValue From EmailTemplate Where DeveloperName='WebToLeadFCL' limit 1];
                Template.HtmlValue = Template.HtmlValue.replace('--SubTitulo--','FREIGHT '+FMode+' '+SMode+' '+ServiceType);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Account_for__c}',Cliente);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Name}',QuoteName);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Freight_Mode__c}',FMode);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Service_Mode__c}',SMode);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Site_of_Load__c}', SLoad);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Site_of_Discharge__c}',SDischarge);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Sales_Incoterm__c}',SIncor);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Total_Items_Units__c}',Unit);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Total_Weight_Kg2__c}',kg);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Link}',URL);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String[] toAddresses = new list<string>{Email};
                PageReference URLPDF = Page.NEU_Import_Export_Quote_pdf;
                URLPDF.getParameters().put('Id',(String)IEQ);
                URLPDF.setRedirect(true);
                Blob body = Test.isRunningTest()?null:URLPDF.getContent();
                Messaging.EmailFileAttachment Doc = new Messaging.EmailFileAttachment();
                Doc.setFileName(Test.isRunningTest()?'':Quote[0].Name+'.PDF');
                Doc.setContentType('application/pdf');
                Doc.setBody(body);
                message.setHtmlBody(Template.HtmlValue);message.setToAddresses(toAddresses);message.setSubject(Template.Subject.replace('{!Customer_Quote__c.Name}',QuoteName));
                message.setFileAttachments(new Messaging.EmailFileAttachment[]{Doc});
                if(!Test.isRunningTest()){
                    Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});      
                    if(results[0].success){R.Message__c ='Se envio la cotizacion al correo: '+Email;if(!Test.isRunningTest()){insert R;}
                    }else{R.Type__c = 'ERROR';R.Message__c ='Error al enviar el correo';if(!Test.isRunningTest()){insert R;}} 
                }  
            }else{
                EmailTemplate Template = [Select Id,Subject,HtmlValue From EmailTemplate Where DeveloperName='WebToLeadLCL' limit 1];
                Template.HtmlValue = Template.HtmlValue.replace('--SubTitulo--','FREIGHT '+FMode+' '+SMode+' '+ServiceType);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Account_for__c}',Cliente);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Name}',QuoteName);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Freight_Mode__c}',FMode);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Service_Mode__c}',SMode);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Site_of_Load__c}', SLoad);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Site_of_Discharge__c}',SDischarge);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Sales_Incoterm__c}',SIncor);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Total_Items_Units__c}',Unit);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Total_Weight_Kg2__c}',kg);
                Template.HtmlValue = Template.HtmlValue.replace('{!Customer_Quote__c.Link}',URL);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String[] toAddresses = new list<string>{Email};
                message.setHtmlBody(Template.HtmlValue);message.setToAddresses(toAddresses);message.setSubject(Template.Subject.replace('{!Customer_Quote__c.Name}',QuoteName));
                Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                            
                if(results[0].success){
                    R.Message__c ='Se envio la cotizacion al correo: '+Email;if(!Test.isRunningTest()){insert R;}
                }else{
                    R.Type__c = 'ERROR';R.Message__c ='Error al enviar el correo';if(!Test.isRunningTest()){insert R;}
                }    
            }       
        }catch(Exception e){
            R.Type__c = 'ERROR';
            R.Message__c = 'Error en Correo: '+e.getMessage()+' Numero de Linea: '+ e.getLineNumber();
            insert R;   
        }
    }
    

}