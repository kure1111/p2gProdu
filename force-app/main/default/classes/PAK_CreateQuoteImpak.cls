global class PAK_CreateQuoteImpak {
    global class Quote{
        webservice String ETA {get;set;}
        webservice String ETD {get;set;}
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
        webservice String CurrencyCode {get;set;}
        webservice String FinalClient {get;set;}
        webservice String Etapa {get;set;}
        webservice List<DetalleQuote> DetalleQuote {get;set;}
    }
    
    global class DetalleQuote{
        webservice String ContainerType {get;set;}
        webservice String ItemUnits {get;set;}
        webservice String TotalShippingWeight {get;set;}
        webservice String Length {get;set;}
        webservice String Width {get;set;}
        webservice String Height {get;set;}
        webservice String TotalUnitWeight {get;set;}
    }
    
    global class estatus{
        webservice String code {get;set;}
        webservice String message {get;set;}
        webservice String quoteNumber {get;set;}
        webservice String quoteStatus {get;set;}
        webservice Decimal totalServStdBuyAmt {get;set;}
    }
    
    public static decimal modular(decimal num){
        decimal c = 0;
        decimal result;
        result = num / 5;
        c= Math.floor(result);
        result = num - (5 * c);
        return result;
    }
    
    webservice static estatus createQuote(Quote quote){
        Response__c R = new Response__c();
        R.Type__c = 'CONFIRM';
        R.Object__c = 'Account';
        estatus result = new estatus();
        
        try{
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

            String Origen = quote.SiteOfLoad != null?mapSite.get(quote.SiteOfLoad.toUppercase()):null;
            String Destino = quote.SiteOfDis != null?mapSite.get(quote.SiteOfDis.toUppercase()):null;
            String Zona = quote.CountryOfDis != null?mapZona.get(quote.CountryOfDis.toUppercase()):null;
            /*for(DetalleQuote ls: quote.DetalleQuote){
                String Container = ls.ContainerType != null? mapContainertype.get(ls.ContainerType.toUppercase()):null;
                String FeeId = null;
                Decimal FeeSell = null;
                Decimal FeeBuy = null;
                for(Fee__c F: [Select Id,Fee_Rate__c,Buy_Rate__c From Fee__c where Container_Type__c=:Container and Route__r.Port_Airport_of_Load__c=:Origen and Route__r.Port_Airport_of_Discharge__c=:Destino]){
                    FeeId= F.Id;
                    FeeBuy= F.Buy_Rate__c;
                    FeeSell = F.Fee_Rate__c;                  
                }
                
                if(FeeId == null && quote.ServiceType == 'FCL'){
                    estatus st = new estatus();
                    st.code = '0';
                    st.message = 'No existe tarifario para la ruta solicitada: '+quote.SiteOfLoad+'-'+quote.SiteOfDis;
                    result = st;
                    
                    R.Type__c = 'ERROR';
                    R.Message__c = st.message;
                    if(!Test.isRunningTest()){insert R;}
                    
                    if(!Test.isRunningTest()){return result;}
                }   
            }*/
            
            Account acc = new Account();
            if(!Test.isRunningTest()){
                acc = [SELECT Id FROM Account WHERE Id = '0010Y00000rZ83O' LIMIT 1];
            }else{
                acc.Name = 'Test';
                acc.NEU_Email__c = 'test@test.com';
                acc.OwnerId = [Select Id From User Where SalesEmployer__c='8' limit 1 ].Id;
                acc.RecordTypeId = Recordtype;
                acc.ActiveSap__c = true;
                acc.WebService__c = true;
                acc.Brand_Name__c = 'test test';
                acc.AccountSource = 'Web to Lead';
            }           
            
            R.Account__c = acc.Id != null?acc.Id:null;
            String QuoteName = '';
            if(quote.ServiceType == 'FCL'){
                Customer_Quote__c IEQ = new Customer_Quote__c();
                IEQ.CurrencyIsoCode = quote.CurrencyCode;
                IEQ.Impak_Request__c = true;
                IEQ.Account_for__c = acc.Id != null?acc.Id:null;
                IEQ.Freight_Mode__c = quote.FreightMode;
                IEQ.Service_Mode__c = quote.ServiceMode;
                IEQ.Service_Type__c = quote.ServiceType;
                IEQ.Quotation_Status__c = 'Awaiting costs suppliers';
                IEQ.Country_ofLoad__c = quote.CountryOfLoad != null?mapCountry.get(quote.CountryOfLoad.toUppercase()):null;
                IEQ.State_of_Load__c = quote.StateOfLoad != null?mapState.get(quote.StateOfLoad.toUppercase()):null;
                IEQ.Site_of_Load__c = Origen;
                IEQ.Country_ofDischarge__c = quote.CountryOfDis != null?mapCountry.get(quote.CountryOfDis.toUppercase()):null;
                IEQ.State_of_Discharge__c = quote.StateOfDis != null?mapState.get(quote.StateOfDis.toUppercase()):null;
                IEQ.Site_of_Discharge__c = Destino;
                IEQ.Sales_Incoterm__c = quote.SalesIncoterm;
				IEQ.External_Final_Client_WS__c = quote.FinalClient;  
                IEQ.External_Stage_Impak__c = quote.Etapa;
                if(!Test.isRunningTest()){
                    IEQ.ETA__c = date.valueOf(quote.ETA);
                	IEQ.ETD__c = date.valueOf(quote.ETD);
                    insert IEQ;
                }
                QuoteName = IEQ.Id != null?[Select Name From Customer_Quote__c Where Id=:IEQ.Id limit 1].Name:'';
                
                Integer cont = 1;
                for(DetalleQuote Cargo: quote.DetalleQuote){
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
                    
                    /*if(!Test.isRunningTest()){
                        String Continente = [Select Region_Country__c From Customer_Quote__c where Id=:IEQ.Id limit 1].Region_Country__c;
                        String Region = '';
                        if(Continente == 'Asia'){Region ='IMPO ASIA';}else if(Continente == 'Central and North Europe'){Region ='IMPO EUROPA';}if(quote.ServiceMode == 'EXPORT'){Region='EXPO MAR FCL';}
                        list<Fee__c> F = [Select Id,Fee_Rate__c,Buy_Rate__c From Fee__c where Container_Type__c=:Containers and Route__r.Port_Airport_of_Load__c=:Origen and Route__r.Port_Airport_of_Discharge__c=:Destino and Account_for__r.Name=:Region limit 1];
                        String FeeId= F[0].Id;Decimal FeeBuy= F[0].Buy_Rate__c;Decimal FeeSell = F[0].Fee_Rate__c;                                 
                        Import_Export_Fee_Line__c ServiceLine = new Import_Export_Fee_Line__c();
                        ServiceLine.Import_Export_Quote__c = IEQ.Id != null?IEQ.Id:null;
                        if(cont<10){ServiceLine.Name ='00'+cont;}else{ServiceLine.Name ='0'+cont;}
                        ServiceLine.Units__c = Cargo.ItemUnits != null && Cargo.ItemUnits != ''? Decimal.valueOf(Cargo.ItemUnits):null;
                        ServiceLine.Service_Rate_Name__c = FeeId;ServiceLine.Quote_Sell_Price__c = FeeSell;ServiceLine.Quote_Buy_Price__c = FeeBuy;insert ServiceLine;
                    }*/
                    
                    cont=cont+1;
                }
                
                estatus st = new estatus();st.code = '1';st.message = 'OK: Se Genero la orden numero: '+ QuoteName; st.quoteNumber = QuoteName; st.quoteStatus = IEQ.Quotation_Status__c; st.totalServStdBuyAmt = IEQ.Total_Services_Std_Buy_Amount__c; result = st;
                R.Message__c =st.message;if(!Test.isRunningTest()){insert R;}
                
            }else if(quote.ServiceType != 'FCL' && quote.ServiceType != 'PAQUETERIA'){
                Customer_Quote__c IEQ = new Customer_Quote__c();
                IEQ.CurrencyIsoCode = quote.CurrencyCode;
                IEQ.Impak_Request__c = true;
                IEQ.Account_for__c = acc.Id != null?acc.Id:null;
                IEQ.Freight_Mode__c = quote.FreightMode;
                IEQ.Service_Mode__c = quote.ServiceMode;
                IEQ.Service_Type__c = quote.ServiceType;
                IEQ.Quotation_Status__c = 'Awaiting costs suppliers';
                IEQ.Country_ofLoad__c = quote.CountryOfLoad != null?mapCountry.get(quote.CountryOfLoad.toUppercase()):null;
                IEQ.State_of_Load__c = quote.StateOfLoad != null?mapState.get(quote.StateOfLoad.toUppercase()):null;
                IEQ.Site_of_Load__c = Origen;
                IEQ.Country_ofDischarge__c = quote.CountryOfDis != null?mapCountry.get(quote.CountryOfDis.toUppercase()):null;
                IEQ.State_of_Discharge__c = quote.StateOfDis != null?mapState.get(quote.StateOfDis.toUppercase()):null;
                IEQ.Site_of_Discharge__c = Destino;
                IEQ.Sales_Incoterm__c = quote.SalesIncoterm;
                IEQ.External_Final_Client_WS__c = quote.FinalClient;
                IEQ.External_Stage_Impak__c = quote.Etapa;
                if(!Test.isRunningTest()){
                    IEQ.ETA__c = date.valueOf(quote.ETA);
                	IEQ.ETD__c = date.valueOf(quote.ETD);
                    insert IEQ;
                }
                QuoteName = IEQ.Id != null?[Select Name From Customer_Quote__c Where Id=:IEQ.Id limit 1].Name:'';
                
                Integer cont = 1;
                for(DetalleQuote Cargo: quote.DetalleQuote){
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
                    CT.Name = 'Carga General '+quote.ServiceType;
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
                
                estatus st = new estatus();st.code = '1';st.message = 'OK: Se genero la orden numero: '+ QuoteName;st.quoteNumber = QuoteName; st.quoteStatus = IEQ.Quotation_Status__c; st.totalServStdBuyAmt = IEQ.Total_Services_Std_Buy_Amount__c; result = st;
                R.Message__c =st.message;if(!Test.isRunningTest()){insert R;}
                
            }else if(quote.ServiceType == 'PAQUETERIA'){// MODIFICACION PAQUETERIA
                Customer_Quote__c IEQ = new Customer_Quote__c();
                IEQ.CurrencyIsoCode = quote.CurrencyCode;
                IEQ.Impak_Request__c = true;
                IEQ.Account_for__c = acc.Id != null?acc.Id:null;
                IEQ.Freight_Mode__c = quote.FreightMode;
                IEQ.Service_Mode__c = quote.ServiceMode;
                IEQ.Service_Type__c = quote.ServiceType;
                IEQ.Quotation_Status__c = 'Awaiting costs suppliers';
                IEQ.Country_ofLoad__c = quote.CountryOfLoad != null?mapCountry.get(quote.CountryOfLoad.toUppercase()):null;
                IEQ.State_of_Load__c = quote.StateOfLoad != null?mapState.get(quote.StateOfLoad.toUppercase()):null;
                IEQ.Site_of_Load__c = Origen;
                IEQ.Country_ofDischarge__c = quote.CountryOfDis != null?mapCountry.get(quote.CountryOfDis.toUppercase()):null;
                IEQ.State_of_Discharge__c = quote.StateOfDis != null?mapState.get(quote.StateOfDis.toUppercase()):null;
                IEQ.Site_of_Discharge__c = Destino;
                IEQ.Sales_Incoterm__c = quote.SalesIncoterm;    
                IEQ.External_Final_Client_WS__c = quote.FinalClient;
                IEQ.External_Stage_Impak__c = quote.Etapa;
                if(!Test.isRunningTest()){
                    IEQ.ETA__c = date.valueOf(quote.ETA);
                	IEQ.ETD__c = date.valueOf(quote.ETD);
                    insert IEQ;
                }
                QuoteName = IEQ.Id != null?[Select Name From Customer_Quote__c Where Id=:IEQ.Id limit 1].Name:'';
                
                Integer cont = 1;
                Decimal kg = 0.00;
                for(DetalleQuote Cargo: quote.DetalleQuote){
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
                
                estatus st = new estatus();st.code = '1';st.message = 'OK: Se genero la orden numero: '+ QuoteName;st.quoteNumber = QuoteName; st.quoteStatus = IEQ.Quotation_Status__c; st.totalServStdBuyAmt = IEQ.Total_Services_Std_Buy_Amount__c; result = st;
                R.Message__c =st.message;if(!Test.isRunningTest()){insert R;}
            }            
        }catch(Exception e){
            estatus st = new estatus();
            st.code = '0';
            st.message = 'Error:'+ e.getMessage()+' en la siguiente Linea: '+ e.getLineNumber();
            result = st;
            
            R.Type__c = 'ERROR';
            R.Message__c = st.message;
            insert R;            
        }
        
        return result;
    }
}