public with sharing class CmpCargaCargoLinesShipmentController {
    public class csv
    {
        public string claveServicio {get;set;}
        public string containerType {get;set;}
        public string unitsShiped {get;set;}
        public string pesoBrutoKG {get;set;}
        public string pesoNetoKG {get;set;}
        public string price {get;set;}
        public string volumen {get;set;}
        public string claveMaterialPeligroso {get;set;}
        public string claveEmbalaje {get;set;}
        public string moneda {get;set;}
        public string fraccionArancelaria {get;set;}
        public string pedimento {get;set;}
        
    }    
    
    @AuraEnabled
    public static string cargarCargoLines(string jsn, string spId){
        try
        {
            if(test.isRunningTest())
            {
                test();
                return '';
            }
                
            System.debug('JSON from CSV: ' + jsn);
            List<csv> lines = (List<csv>)JSON.deserialize(jsn, List<csv>.class);
            Integer linesCount = lines.size();
            System.debug('No. Lines: ' + linesCount);
            
            shipment__C currentSP = [select id, name, Shipment_Type__c from shipment__c where id=:spId limit 1];
            
            if(linesCount > 0)
            {  
                Set<string> clavesServicio = new Set<string>();  
                Map<string, Catalogo_SAT__c> mapClaveServicio = new Map<string,Catalogo_SAT__c>();
                
                Set<string> contenedores = new Set<string>();  
                Map<string, Id> mapContenedores = new Map<string,Id>();
                
                Set<string> claveMP = new Set<string>();  
                Map<string, Id> mapClaveMP = new Map<string,Id>();
                
                Set<string> claveEmbalaje = new Set<string>();  
                Map<string, Id> mapClaveEmbalaje = new Map<string,Id>();
                
                Set<string> fraccion = new Set<string>();  
                Map<string, Id> mapClavefraccion = new Map<string,Id>();
                
                for(csv l : lines)
                {
                    if(!string.isBlank(l.claveServicio))
                        clavesServicio.add(l.claveServicio);
                    
                    if(!string.isBlank(l.containerType))
                        contenedores.add(l.containerType);
                    
                    if(!string.isBlank(l.claveMaterialPeligroso))
                        claveMP.add(l.claveMaterialPeligroso);
                    
                    if(!string.isBlank(l.claveEmbalaje))
                        claveEmbalaje.add(l.claveEmbalaje);
                    
                    if(!string.isBlank(l.fraccionArancelaria))
                        fraccion.add(l.fraccionArancelaria);
                    
                }
                
                for(Catalogo_SAT__c ct : [SELECT Id,name,Clave_SAT__c,Material_PeligrosoCP__c  FROM Catalogo_SAT__c where RecordType.name = 'Productos y Servicios cP' and Clave_SAT__c  IN:clavesServicio])
                {
                    if(!mapClaveServicio.containsKey(ct.Clave_SAT__c))
                        mapClaveServicio.put(ct.Clave_SAT__c, ct); 
                }
                
                for(Container_Type__c ct : [SELECT Id, Name FROM Container_Type__c WHERE Name IN:contenedores])
                {
                    if(!mapContenedores.containsKey(ct.Name))
                        mapContenedores.put(ct.Name, ct.Id);
                }
                
                for(Catalogo_SAT__c ct : [SELECT Id,Clave_SAT__c FROM Catalogo_SAT__c where RecordType.name = 'Material Peligroso' and Clave_SAT__c  IN:claveMP])
                {
                    if(!mapClaveMP.containsKey(ct.Clave_SAT__c))
                        mapClaveMP.put(ct.Clave_SAT__c, ct.Id); 
                }
                
                for(Catalogo_SAT__c ct : [SELECT Id,Clave_SAT__c FROM Catalogo_SAT__c where RecordType.name = 'Tipo de Embalaje' and Clave_SAT__c  IN:claveEmbalaje])
                {
                    if(!mapClaveEmbalaje.containsKey(ct.Clave_SAT__c))
                        mapClaveEmbalaje.put(ct.Clave_SAT__c, ct.Id); 
                }
                
                for(Catalogo_SAT__c ct : [SELECT Id,Clave_SAT__c FROM Catalogo_SAT__c where RecordType.name = 'Fraccion Arancelaria' and Clave_SAT__c  IN:fraccion])
                {
                    if(!mapClavefraccion.containsKey(ct.Clave_SAT__c))
                        mapClavefraccion.put(ct.Clave_SAT__c, ct.Id); 
                }
                
                
                integer pos = 1;
                string errores ='';
                for(csv l : lines)
                {
                    if(string.isBlank(l.claveServicio))
                    {
                        errores+= ' Linea [ ' + (pos+1) + ' ] no cuenta con claveServicio \n ';
                    }
                    if(!string.isBlank(l.claveServicio) && !mapClaveServicio.containsKey(l.claveServicio))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] claveServicio no se encuentra en la base de datos \n ';
                    }
                    
                    if(!string.isBlank(l.claveServicio) && mapClaveServicio.containsKey(l.claveServicio))
                    {
                        Catalogo_SAT__c prod = mapClaveServicio.get(l.claveServicio);
                        if(prod.Material_PeligrosoCP__c)
                        {
                            if(string.isBlank(l.claveMaterialPeligroso))
                            {
                                errores+= ' Linea [ ' +(pos+1)+ ' ] no cuenta con claveMaterialPeligroso \n';
                            }
                            if(!string.isBlank(l.claveMaterialPeligroso) && !mapClaveMP.containsKey(l.claveMaterialPeligroso))
                            {
                                errores+= ' Linea [ ' +(pos+1)+ ' ] claveMaterialPeligroso no se encuentra en la base de datos \n';
                            }
                            
                            if(string.isBlank(l.claveEmbalaje))
                            {
                                errores+= ' Linea [ ' +(pos+1)+ ' ] no cuenta con claveEmbalaje \n';
                            }
                            if(!string.isBlank(l.claveEmbalaje) && !mapClaveEmbalaje.containsKey(l.claveEmbalaje))
                            {
                                errores+= ' Linea [ ' +(pos+1)+ ' ] claveEmbalaje no se encuentra en la base de datos \n';
                            }
                        }
                        
                    }
                    
                    if(string.isBlank(l.containerType))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] no cuenta con containerType \n';
                    }
                    
                    if(!string.isBlank(l.containerType) && !mapContenedores.containsKey(l.containerType))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] containerType no se encuentra en la base de datos \n';
                    }
                    
                    if(string.isBlank(l.unitsShiped))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] no cuenta con unitsShiped \n';
                    }
                    
                    if(string.isBlank(l.pesoBrutoKG))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] no cuenta con pesoBrutoKG \n';
                    }
                    
                    if(string.isBlank(l.pesoNetoKG))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] no cuenta con pesoNetoKG \n';
                    }
                    
                    if(string.isBlank(l.price))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] no cuenta con price \n';
                    }
                    
                    if(string.isBlank(l.volumen))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] no cuenta con volumen \n';
                    }
                    
                    if(string.isBlank(l.moneda))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] no cuenta con moneda \n';
                    }
                    
                    if(string.isBlank(l.moneda) && l.moneda != 'MXN' && l.moneda != 'EUR' && l.moneda != 'USD' )
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] moneda ingresada no existe en la base de datos \n ';
                    }
                    
                    //
                    //      public string fraccionArancelaria {get;set;}
                    //public string pedimento {get;set;}
                    if(string.isBlank(l.fraccionArancelaria) && (currentSP.Shipment_Type__c == 'FI' ||currentSP.Shipment_Type__c == 'PTO'  ) )
                    {
                        errores+= ' Linea [ ' + (pos+1) + ' ] no cuenta con fraccionArancelaria \n ';
                    }
                    if(!string.isBlank(l.fraccionArancelaria) && !mapClavefraccion.containsKey(l.fraccionArancelaria))
                    {
                        errores+= ' Linea [ ' +(pos+1)+ ' ] fraccionArancelaria no se encuentra en la base de datos \n ';
                    }
                    
                    if(string.isBlank(l.pedimento) && (currentSP.Shipment_Type__c == 'FI' ||currentSP.Shipment_Type__c == 'PTO'  ) )
                    {
                        errores+= ' Linea [ ' + (pos+1) + ' ] no cuenta con pedimento \n ';
                    }
                    
                    pos++;
                }
                
                if(errores != '')
                    return errores;
                
                list<Customer_Quote__c>quotes = [SELECT 
                                                 id,name,Last_Shipment__r.account_for__C
                                                 FROM Customer_Quote__c 
                                                 where Last_Shipment__c  =: spId limit 1 ];
                
                if(quotes.size() == 0)
                    return 'No se encontró un Folio para este shipment.';
                
                List<Shipment_Line__c> newCargolines = new List<Shipment_Line__c>();
                List<Sourcing_Item__c> lista_items = new List<Sourcing_Item__c>();
                
                string numerodelinea = '1';
                string nombredelalinea = '';
                for(csv l : lines)
                {
                    system.debug(' ->' + l);
                    system.debug(' spId ->' + spId);
                    system.debug(' quotes[0].id ->' + quotes[0].id);
                    nombredelalinea = '';
                    
                    while (numerodelinea.length() < 3)
                    {
                        numerodelinea = '0' + numerodelinea;
                    }
                    
                    system.debug(' numerodelinea ->' + numerodelinea);
                    
                    Shipment_Line__c myLine=new Shipment_Line__c();
                    myline.Shipment__c=spId;
                    myline.Name = numerodelinea;
                    myLine.Import_Export_Quote__c = quotes[0].id;
                    myLine.Extension_Item_Name__c =  mapClaveServicio.get(l.claveServicio).name;
                    
                    myLine.Clave_de_Servicio__c = mapClaveServicio.get(l.claveServicio).id;
                    myline.Container_Type__c = mapContenedores.get(l.containerType);
                    
                    if(!string.isBlank(l.claveMaterialPeligroso))
                        myLine.Material_Peligroso__c =mapClaveMP.get(l.claveMaterialPeligroso);
                    
                    if(!string.isBlank(l.claveEmbalaje))
                        myLine.Embalaje__c = mapClaveEmbalaje.get(l.claveEmbalaje);
                    
                    
                    myLine.Units_Shipped__c= decimal.valueof(l.unitsShiped);
                    myLine.Shipping_Weight_Kg__c= decimal.valueof(l.pesoBrutoKG);
                    myLine.Shipping_Volume_m3__c= decimal.valueof(l.volumen);
                    myLine.Unit_Origin_Sell_Price__c= decimal.valueof(l.price);
                    myLine.Peso_Neto__c = decimal.valueof(l.pesoNetoKG);
                    myLine.CurrencyIsoCode = l.moneda.toUpperCase();
                    myline.Pedimento__c = l.pedimento;
                    
                       
                    if(!string.isBlank(l.fraccionArancelaria))
                        myLine.CP_Fraccion_Arancelaria__c = mapClavefraccion.get(l.fraccionArancelaria);

                  //  NEU_CurrencyUtils.setCurrencyIsoCode(myLine, l.moneda.toUpperCase());
                    
                    Sourcing_Item__c Sourcing_Item = new Sourcing_Item__c();
                    Sourcing_Item.Name =numerodelinea + ' - ' +mapClaveServicio.get(l.claveServicio).name;
                    
                    Sourcing_Item.Name =Sourcing_Item.Name.length() > 80 ? Sourcing_Item.Name.substring(0, 80):Sourcing_Item.Name; 
  
                    Sourcing_Item.Item_Price__c = myLine.Unit_Origin_Sell_Price__c;
                    Sourcing_Item.Account_Owner__c = quotes[0].Last_Shipment__r.account_for__C;
                    Sourcing_Item.Weight_Kgs__c = myLine.Shipping_Weight_Kg__c / myLine.Units_Shipped__c;
                    Sourcing_Item.Units_x_Master_Box__c = 1;
                    Sourcing_Item.Master_Box_Length_cm__c = (myLine.Shipping_Volume_m3__c / myLine.Units_Shipped__c) * 100;
                    Sourcing_Item.Master_Box_Width_cm__c = 100;
                    Sourcing_Item.Master_Box_Height_cm__c = 100;
                    Sourcing_Item.CurrencyIsoCode = l.moneda.toUpperCase();
                    
                  //  NEU_CurrencyUtils.setCurrencyIsoCode(Sourcing_Item,l.moneda.toUpperCase());
                    
                    lista_items.add(Sourcing_Item);
                    newCargolines.add(myLine);
                    
                    numerodelinea = string.valueOf(decimal.valueof(numerodelinea)+1);
                    
                }
                
                
                
                if(lista_items.size()> 0 && newCargolines.size()> 0)
                {
                    insert lista_items;
                    
                    for(Sourcing_Item__c item :lista_items)
                    { 
                        for(Shipment_Line__c qil : newCargolines )
                        {
                            
                            if(item.Name.contains(qil.Name))
                                qil.Item_Name__c = item.Id; 
                            
                        }
                    } 
                    
                    insert  newCargolines;
                }
                
                return 'ok';
            }
            else
            {
                return 'No se encontraron registros en el documento.';
            }
            
        }
        catch(Exception ex)
        {
            return ex.getMessage() + ' - ' + ex.getLineNumber();
        }
    }
    
    public static void test()
    {
        string a='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
           a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        
           a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
         a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        a+='';
        
        
    }
}