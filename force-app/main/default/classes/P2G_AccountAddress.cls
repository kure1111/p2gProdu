public class P2G_AccountAddress {
    @AuraEnabled
    public static list<Account_Address__c> getAddress(String address){
        String searchKeyword = '%' + address + '%';
        //String recordCarrier = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        list<Account_Address__c> AccountListRecord = new list<Account_Address__c>();
        for(Account_Address__c accountSearch : [SELECT Id, Name FROM Account_Address__c
                                                WHERE status__c = 'Validado'AND Active__c = true AND Name LIKE : searchKeyword limit 15]){
                                                    AccountListRecord.add(accountSearch);
                                                }
        if(AccountListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..');
        }
        return AccountListRecord;
    } 
    
    @AuraEnabled
    public static list<Catalogo_SAT__c> getCP(String cp){
        String searchKeyword = '%' + cp + '%';
        String record = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();
        
        list<Catalogo_SAT__c> catalogoSAT = new list<Catalogo_SAT__c>();
        for(Catalogo_SAT__c accountSearch : [SELECT Id, Name , Clave_Relacion_SAT__r.Name, Municipio_Ref_CP__r.Name FROM Catalogo_SAT__c
                                             WHERE recordTypeId =:record AND Name LIKE : searchKeyword limit 15]){
                                                 catalogoSAT.add(accountSearch);
                                             }
        
        if(catalogoSAT.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return catalogoSAT;
    } 
     
    @AuraEnabled
    public static List<MapMarker> getMapMarkers(String cp) {
        string searchKeyword = cp.substring(0, 4)+'%';
        String record = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();
        
        // Crear una lista de MapMarker para almacenar los marcadores
        List<MapMarker> markers = new List<MapMarker>();
        
        list<Catalogo_SAT__c> catalogoSAT = new list<Catalogo_SAT__c>();
        for(Catalogo_SAT__c accountSearch : [SELECT Id, Name FROM Catalogo_SAT__c
                                             WHERE recordTypeId =:record AND Name LIKE : searchKeyword limit 15]){
                                                 catalogoSAT.add(accountSearch);
                                             }
        
        if(catalogoSAT.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        list<Account_Address__c> listAddress = new list<Account_Address__c>();
        listAddress = [SELECT Id, Name,status__c,Codigo_Postal_CP__c ,Address__c,Address_Coordinates__Latitude__s,
                       Address_Coordinates__Longitude__s,CalleEspejo__c  ,Numero_Ext_cp__c,Colonia_espejo__c,
                       Codigo_Postal_CP__r.Name,LocalidadEspejo__r.Name,EstadoEspejo__r.Name,PaisEspejo__r.Name
                       FROM Account_Address__c
                       WHERE (status__c ='Validado' OR status__c ='Pendiente') AND Codigo_Postal_CP__r.Name LIKE : searchKeyword
                       ORDER BY status__c DESC];
    
        for(Account_Address__c item:listAddress){
            Boolean yellowColor = false;
            if(item.status__c =='Pendiente'){
                yellowColor = true;
            }
            markers.add(new MapMarker(item.Address_Coordinates__Latitude__s,item.Address_Coordinates__Longitude__s ,
                                      item.Name,
                                      item.Id,
                                      item.Address__c,yellowColor,
                                      item.CalleEspejo__c, item.Numero_Ext_cp__c,item.Colonia_espejo__c,
                                     item.Codigo_Postal_CP__r.Name,item.LocalidadEspejo__r.Name,item.EstadoEspejo__r.Name,
                                     item.PaisEspejo__r.Name));
            
        }
        System.debug('XXXX: '+markers);
        return markers;
    }
    
    @AuraEnabled
    public static List<MapMarker> getMapMarkersByName(String name) {
        
        // Crear una lista de MapMarker para almacenar los marcadores
        List<MapMarker> markers = new List<MapMarker>();
        
        list<Account_Address__c> listAddress = new list<Account_Address__c>();
        listAddress = [SELECT Id, Name,status__c,Codigo_Postal_CP__c ,Address__c,Address_Coordinates__Latitude__s,
                       Address_Coordinates__Longitude__s,CalleEspejo__c  ,Numero_Ext_cp__c,Colonia_espejo__c,
                       Codigo_Postal_CP__r.Name,LocalidadEspejo__r.Name,EstadoEspejo__r.Name,PaisEspejo__r.Name
                       FROM Account_Address__c
                       WHERE Name LIKE : name AND (status__c = 'Validado' OR status__c = 'Pendiente') 
                       ORDER BY status__c DESC];
        
        for(Account_Address__c item:listAddress){
            Boolean yellowColor = false;
            if(item.status__c =='Pendiente'){
                yellowColor = true;
            }
            markers.add(new MapMarker(item.Address_Coordinates__Latitude__s,item.Address_Coordinates__Longitude__s ,
                                      item.Name,
                                      item.Id,
                                      item.Address__c,yellowColor,
                                      item.CalleEspejo__c, item.Numero_Ext_cp__c,item.Colonia_espejo__c,
                                     item.Codigo_Postal_CP__r.Name,item.LocalidadEspejo__r.Name,item.EstadoEspejo__r.Name,
                                     item.PaisEspejo__r.Name));
        }
        return markers;
    }
    
    public class MapMarker {
        @AuraEnabled
        public Map<String, Object> location;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String mapIcon;
        @AuraEnabled
        public String calle;
        @AuraEnabled
        public String numero;
        @AuraEnabled
        public String colonia;
        @AuraEnabled
        public String codigoPostal;
        @AuraEnabled
        public String localidad;
        @AuraEnabled
        public String estado;
        @AuraEnabled
        public String pais;
        @AuraEnabled
        public String status;
        public MapMarker(Decimal lat, Decimal lng, String title,String id,String address, Boolean color,
                        String calle,String numero,String colonia,String codigoPostal,String localidad,String estado,String pais) {
                        this.location = new Map<String, Object>{
                            'Latitude' => String.valueOf(lat),  // Convertir Decimal a String
                            'Longitude' => String.valueOf(lng)  // Convertir Decimal a String
                        };
                        this.title = title;
            			this.description = address;
            			this.id = id;
                        this.calle = calle;
                        this.numero = numero;
                        this.colonia = colonia; 
                        this.codigoPostal=codigoPostal;
                        this.localidad=localidad;
                        this.estado=estado;
                        this.pais=pais;
            			this.mapIcon = 'http://maps.google.com/mapfiles/ms/icons/red-dot.png';
                        this.status = 'Validado';
             			if (color) {
            				this.mapIcon = 'http://maps.google.com/mapfiles/ms/icons/yellow-dot.png';
                            this.status = 'Pendiente';
        				}
            			
        }
        
    }
    
    @AuraEnabled
    public static String createAddress(List<String> direccion) {
        System.debug('DATOSR: '+direccion[0]);
        System.debug('DATOSR: '+direccion[1]);
        System.debug('DATOSR: '+direccion[2]);
        System.debug('DATOSR: '+direccion[3]);
        System.debug('DATOSR: '+direccion[4]);
        System.debug('DATOSR: '+direccion[5]);
        System.debug('DATOSR: '+direccion[6]);
        System.debug('DATOSR: '+direccion[7]);
        System.debug('DATOSR: '+direccion[8]);
        String val = 'no';
        // Asignar los valores de la lista a las variables correspondientes
        String pais = direccion[0];
        String paisConAcento = obtenerPaisConAcento(pais);
        String estado = direccion[1];
        //String municipio = direccion[2];
        String localidad = direccion[3];
        String colonia = direccion[4];
        String calle = direccion[5];
        String numero = direccion[6];
        String codigoPostal = direccion[7];
        String nombre = direccion[8];
        String address = direccion[9];
        Decimal lat = Double.valueOf(direccion[10]);
        Decimal lng = Double.valueOf(direccion[11]);
        
        Set<String> listaIds = new Set<String>();
        List<Account_Address__c> listAddress = [SELECT Id,Name,Address__c,Referencia__c,Address_Coordinates__Latitude__s
                                             ,Address_Coordinates__Longitude__s,Numero_Ext_cp__c,
                                             Calle_cat__c,Codigo_Postal_CP__c,Codigo_Postal_CP__r.Name,Colonia_cp__c,Colonia_cp__r.Name,
                                             Localidad_Cat2__c,Municipio_Cat2__c,Estado_cat2__c,Colonia_espejo__c,Pais_cat1__c,CreatedDate,Status__c,Active__c
                                             FROM Account_Address__c 
                                             WHERE Codigo_Postal_CP__r.Pais_RefCP__r.Name ='méxico'
                                             AND Codigo_Postal_CP__r.Name =:codigoPostal
                                             //AND Colonia_cp__r.Name =:colonia
                                             AND Colonia_espejo__c =:colonia
                                             AND (status__c = 'Validado' OR status__c = 'Pendiente')
                                            ];
        
        
        //List<Catalogo_SAT__c> lista = [SELECT Id, Name FROM Catalogo_SAT__c WHERE Pais_RefCP__r.Name =:paisConAcento
         //                              AND Localidad_Ref_CP__r.Name =:localidad
          //                             AND Clave_Relacion_SAT__r.Name =:estado];
        
        List<Catalogo_SAT__c> lista = [SELECT Id,Name,Pais_RefCP__c,Localidad_Ref_CP__c,Clave_Relacion_SAT__c FROM Catalogo_SAT__c WHERE Name =:codigoPostal
                                       AND Pais_RefCP__r.Name =:paisConAcento];
        
        
        for(Catalogo_SAT__c item:lista){
            listaIds.add(item.Id); 
        }

        List<Catalogo_SAT__c> listaColExiste = [SELECT Id, Name,Codigo_Postal__c FROM Catalogo_SAT__c WHERE (Name =:colonia AND Codigo_Postal__c IN: listaIds)
        AND recordTypeId ='0124T000000Q3D0QAK' 
       ];
        
        List<Catalogo_SAT__c> listaCol = [SELECT Id, Name,Codigo_Postal__c FROM Catalogo_SAT__c WHERE Codigo_Postal__c ='a3K4T000000R0f6UAC'
                                          AND recordTypeId ='0124T000000Q3D0QAK' 
                                         ];
        
        if(listAddress.size() > 0){
            //duplicada, mostrar ubis en mapaa y pregutar si aun asi quiere continuarr
            val = 'duplicado';
            
        }
        else{
            //crear
            if(lista.size() > 0){
                System.debug('nombre: '+nombre);
                Account_Address__c newAddress = new Account_Address__c();
        		newAddress.Name = nombre;
                newAddress.Address__c = address;
                newAddress.Address_Coordinates__Latitude__s = lat;
                newAddress.Address_Coordinates__Longitude__s = lng;
                newAddress.CalleEspejo__c = calle; //
                newAddress.CodigoPostalEspejo__c = lista[0].Id;//codigoPostal;
                newAddress.Colonia_espejo__c = colonia;//
                newAddress.LocalidadEspejo__c = lista[0].Localidad_Ref_CP__c;//localidad;
                //newAddress.Municipio_Cat2__c = municipio; saca de codigo postal del sat
                newAddress.EstadoEspejo__c = lista[0].Clave_Relacion_SAT__c;//estado;
                newAddress.PaisEspejo__c = lista[0].Pais_RefCP__c;//pais
            
            	newAddress.Codigo_Postal_CP__c = lista[0].Id; //poner condicion 
                            	if(listaColExiste.size() > 0){
                    newAddress.Colonia_cp__c = listaColExiste[0].Id;
                }
                else {
                    if(listaCol.size() > 0){
                        newAddress.Colonia_cp__c = listaCol[0].Id;
                    }    

                }
                newAddress.Numero_Ext_cp__c = numero;
                newAddress.Calle_cat__c = calle;
            	insert newAddress;
            	sendAccountCR(newAddress.Id);
            	val = newAddress.Id;
                
            }
            	
        }
        return val;
    }
    
    @AuraEnabled
    public static String createAddressD(List<String> direccion) {
        System.debug('DATOSR: '+direccion[0]);
        System.debug('DATOSR: '+direccion[1]);
        System.debug('DATOSR: '+direccion[2]);
        System.debug('DATOSR: '+direccion[3]);
        System.debug('DATOSR: '+direccion[4]);
        System.debug('DATOSR: '+direccion[5]);
        System.debug('DATOSR: '+direccion[6]);
        System.debug('DATOSR: '+direccion[7]);
        System.debug('DATOSR: '+direccion[8]);
        String val = 'no';
        // Asignar los valores de la lista a las variables correspondientes
        String pais = direccion[0];
        String paisConAcento = obtenerPaisConAcento(pais);
        String estado = direccion[1];
        //String municipio = direccion[2];
        String localidad = direccion[3];
        String colonia = direccion[4];
        String calle = direccion[5];
        String numero = direccion[6];
        String codigoPostal = direccion[7];
        String nombre = direccion[8];
        String address = direccion[9];
        Decimal lat = Double.valueOf(direccion[10]);
        Decimal lng = Double.valueOf(direccion[11]);
        
        Set<String> listaIds = new Set<String>();
        
        
        List<Catalogo_SAT__c> lista = [SELECT Id,Name,Pais_RefCP__c,Localidad_Ref_CP__c,Clave_Relacion_SAT__c FROM Catalogo_SAT__c WHERE Name =:codigoPostal
                                       AND Pais_RefCP__r.Name =:paisConAcento];
        
        
        for(Catalogo_SAT__c item:lista){
            listaIds.add(item.Id); 
        }

        List<Catalogo_SAT__c> listaColExiste = [SELECT Id, Name,Codigo_Postal__c FROM Catalogo_SAT__c WHERE (Name =:colonia AND Codigo_Postal__c IN: listaIds)
        AND recordTypeId ='0124T000000Q3D0QAK' 
       ];
       
        List<Catalogo_SAT__c> listaCol = [SELECT Id, Name,Codigo_Postal__c FROM Catalogo_SAT__c WHERE (Name =:colonia OR Codigo_Postal__c IN: listaIds)
                                          AND recordTypeId ='0124T000000Q3D0QAK'
                                         ];
        

            //crear
            if(lista.size() > 0){
                System.debug('nombre: '+nombre);
                Account_Address__c newAddress = new Account_Address__c();
        		newAddress.Name = nombre;
                newAddress.Address__c = address;
                newAddress.Address_Coordinates__Latitude__s = lat;
                newAddress.Address_Coordinates__Longitude__s = lng;
                newAddress.CalleEspejo__c = calle; //
                newAddress.CodigoPostalEspejo__c = lista[0].Id;//codigoPostal;
                newAddress.Colonia_espejo__c = colonia;//
                newAddress.LocalidadEspejo__c = lista[0].Localidad_Ref_CP__c;//localidad;
                //newAddress.Municipio_Cat2__c = municipio; saca de codigo postal del sat
                newAddress.EstadoEspejo__c = lista[0].Clave_Relacion_SAT__c;//estado;
                newAddress.PaisEspejo__c = lista[0].Pais_RefCP__c;//pais
            
            	newAddress.Codigo_Postal_CP__c = lista[0].Id; //poner condicion
            	if(listaColExiste.size() > 0){
                    newAddress.Colonia_cp__c = listaColExiste[0].Id;
                }
                else {
                    if(listaCol.size() > 0){
                        newAddress.Colonia_cp__c = listaCol[0].Id;
                    }    

                }
                newAddress.Numero_Ext_cp__c = numero;
                newAddress.Calle_cat__c = calle;

            	insert newAddress;
            	sendAccountCR(newAddress.Id);
            	val = newAddress.Id;      
            	
        }
        return val;
    }
    
    @Future(callout=true)
    public static void sendAccountCR(String idAddress){
        try{
            List<Account_Address__c> addressesToUpdate =[SELECT Id, Name,Address_Coordinates__Latitude__s,
                                                         Address_Coordinates__Longitude__s,
                                                         Address__c 
                                                         FROM Account_Address__c WHERE id=:idAddress];
            //addressesToUpdate.add(address);
            P2G_updateAddresWs.listAddressNew(addressesToUpdate);
        }catch(Exception e){
            System.debug('Error al enviar');
        }
    }
    
    public static String obtenerPaisConAcento(String pais) {
        // Mapa de países con acentos
        Map<String, String> paisesConAcentos = new Map<String, String>{
            'mexico' => 'México',
                'espana' => 'España',
                'peru' => 'Perú',
                'republica dominicana' => 'República Dominicana'
                };
                    
                    if (pais == null) return '';
        
        // Normaliza el nombre del país a minúsculas y sin acentos
        String paisNormalizado = pais.toLowerCase()
            .replaceAll('á', 'a')
            .replaceAll('é', 'e')
            .replaceAll('í', 'i')
            .replaceAll('ó', 'o')
            .replaceAll('ú', 'u');
        
        // Busca el nombre con acento en el mapa
        if (paisesConAcentos.containsKey(paisNormalizado)) {
            return paisesConAcentos.get(paisNormalizado);
        }
        
        // Devuelve el mismo nombre si no hay acento
        return pais;
    }
    
    @AuraEnabled
    public static List<MapMarker> getResume(String idAddress){
        System.debug('idResume: '+idAddress);
        List<MapMarker> markers = new List<MapMarker>();
        list<Account_Address__c> listAddress = new list<Account_Address__c>();
        listAddress = [SELECT Id, Name,status__c,Codigo_Postal_CP__c ,Address__c,Address_Coordinates__Latitude__s,
                       Address_Coordinates__Longitude__s,CalleEspejo__c  ,Numero_Ext_cp__c,Colonia_espejo__c,
                       Codigo_Postal_CP__r.Name,LocalidadEspejo__r.Name,EstadoEspejo__r.Name,PaisEspejo__r.Name
                       FROM Account_Address__c
                       WHERE id=:idAddress];
        for(Account_Address__c item:listAddress){
                    Boolean yellowColor = false;
                    if(item.status__c =='Pendiente'){
                        yellowColor = true;
                    }
                    markers.add(new MapMarker(item.Address_Coordinates__Latitude__s,item.Address_Coordinates__Longitude__s ,
                                      item.Name,
                                      item.Id,
                                      item.Address__c,yellowColor,
                                      item.CalleEspejo__c, item.Numero_Ext_cp__c,item.Colonia_espejo__c,
                                     item.Codigo_Postal_CP__r.Name,item.LocalidadEspejo__r.Name,item.EstadoEspejo__r.Name,
                                     item.PaisEspejo__r.Name));
                }
                return markers;      
            }
    
    @AuraEnabled
    public static List<MapMarker> getDuplicates(String codigoPostal, String colonia){
        List<MapMarker> markers = new List<MapMarker>();
        List<Account_Address__c> listAddress = [SELECT Id, Name,status__c,Codigo_Postal_CP__c ,Address__c,Address_Coordinates__Latitude__s,
                                               Address_Coordinates__Longitude__s,CalleEspejo__c  ,Numero_Ext_cp__c,Colonia_espejo__c,
                                               Codigo_Postal_CP__r.Name,LocalidadEspejo__r.Name,EstadoEspejo__r.Name,PaisEspejo__r.Name
                                               FROM Account_Address__c 
                                                WHERE Codigo_Postal_CP__r.Pais_RefCP__r.Name ='méxico'
                                                AND Codigo_Postal_CP__r.Name =:codigoPostal
                                                AND (status__c = 'Validado' OR status__c = 'Pendiente')
                                                AND Colonia_espejo__c =:colonia
                                            ];
        for(Account_Address__c item:listAddress){
                    Boolean yellowColor = false;
                    if(item.status__c =='Pendiente'){
                        yellowColor = true;
                    }
                    markers.add(new MapMarker(item.Address_Coordinates__Latitude__s,item.Address_Coordinates__Longitude__s ,
                                      item.Name,
                                      item.Id,
                                      item.Address__c,yellowColor,
                                      item.CalleEspejo__c, item.Numero_Ext_cp__c,item.Colonia_espejo__c,
                                     item.Codigo_Postal_CP__r.Name,item.LocalidadEspejo__r.Name,item.EstadoEspejo__r.Name,
                                     item.PaisEspejo__r.Name));
                }
                return markers;      
            }
    
    
}