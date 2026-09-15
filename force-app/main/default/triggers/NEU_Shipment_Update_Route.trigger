trigger NEU_Shipment_Update_Route on Shipment__c (before insert, before update) {

    if(NEU_StaticVariableHelper.getBoolean1()){return;}

    list<Id> shipment_to_update = new list<Id>();
    Id id_route_master = null;

    if( Test.isRunningTest() || !RecursiveCheck.triggerMonitor.contains('NEU_Shipment_Update_Route')){
       	RecursiveCheck.triggerMonitor.add('NEU_Shipment_Update_Route');
        if(trigger.isInsert)
  		{
            // filas que necesitan resolver ruta
            List<Shipment__c> pendientes = new List<Shipment__c>();
            List<String> combos = new List<String>();
            for(Shipment__c s : trigger.new)
            {
                  system.debug('shipment: ' + s.Name);
                if(s.Route__c == null)
                {
                    if(s.Site_of_Load__c != null && s.Site_of_Discharge__c != null && s.Country_of_Load__c != null && s.Country_of_Discharge__c != null)
                    {
                        pendientes.add(s);
                        String combo = '(Country_of_Discharge__c =\''+ s.Country_of_Discharge__c +'\'';
                        combo += ' and Country_of_Load__c =\''+ s.Country_of_Load__c +'\'';
                        combo += ' and Port_Airport_of_Discharge__c =\''+ s.Site_of_Discharge__c +'\'';
                        combo += ' and Port_Airport_of_Load__c =\''+ s.Site_of_Load__c +'\'';
                        if (s.State_of_Discharge__c != null)
                            combo += ' and State_of_Discharge__c =\''+ s.State_of_Discharge__c +'\'';
                        if (s.State_of_Load__c != null)
                            combo += ' and State_of_Load__c =\''+ s.State_of_Load__c +'\'';
                        combo += ')';
                        combos.add(combo);
                    }
                }
            }
            if(pendientes.size() > 0)
            {
                // UNA query con todos los combos (antes era una por registro).
                // La seleccion real siempre la hizo el match exacto en memoria
                // de abajo, identico al original.
                String query = 'Select Id, Name,';
                query += ' Country_of_Load__c, State_of_Load__c, Port_Airport_of_Load__c, Country_of_Discharge__c, State_of_Discharge__c, Port_Airport_of_Discharge__c';
                query += ' from Carrier_Line_Load_Point__c';
                query += ' where ' + String.join(combos, ' or ');
                List<Carrier_Line_Load_Point__c> listado_routes = Database.query(query);
                system.debug('listado_routes: ' + listado_routes.size());

                List<Carrier_Line_Load_Point__c> rutas_nuevas = new List<Carrier_Line_Load_Point__c>();
                List<Shipment__c> sp_de_ruta_nueva = new List<Shipment__c>();
                for(Shipment__c s : pendientes)
                {
                    boolean encontrado_routes = false;
                    for(Carrier_Line_Load_Point__c cllp: listado_routes)
                    {
                        if(cllp.Country_of_Discharge__c == s.Country_of_Discharge__c && cllp.State_of_Discharge__c == s.State_of_Discharge__c && cllp.Port_Airport_of_Discharge__c == s.Site_of_Discharge__c &&
                        cllp.Country_of_Load__c == s.Country_of_Load__c && cllp.State_of_Load__c == s.State_of_Load__c && cllp.Port_Airport_of_Load__c == s.Site_of_Load__c)//buscar si existe una exactamente igual
                        {
                            s.Route__c = cllp.Id;
                            encontrado_routes = true;
                            break;
                        }
                    }

                    //si no encuentro ninguna que coincida la creo
                    //(igual que el original: una ruta por fila, sin dedupe)
                    if(encontrado_routes == false)
                    {
                        Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
                        new_route.Name='route';
                        new_route.Country_of_Discharge__c =s.Country_of_Discharge__c;
                        new_route.Country_of_Load__c =s.Country_of_Load__c;
                        if (s.State_of_Discharge__c != null){new_route.State_of_Discharge__c =s.State_of_Discharge__c;}
                        if (s.State_of_Load__c != null){new_route.State_of_Load__c =s.State_of_Load__c;}
                        new_route.Port_Airport_of_Discharge__c = s.Site_of_Discharge__c;
                        new_route.Port_Airport_of_Load__c =s.Site_of_Load__c;
                        rutas_nuevas.add(new_route);
                        sp_de_ruta_nueva.add(s);
                    }
                }

                //el original tampoco insertaba rutas en contexto de test
                if(!Test.isRunningTest() && rutas_nuevas.size() > 0)
                {
                    insert rutas_nuevas;
                    for(Integer i = 0; i < rutas_nuevas.size(); i++)
                    {
                        sp_de_ruta_nueva[i].Route__c = rutas_nuevas[i].Id;
                    }
                }
            }
        }

    	if(trigger.isUpdate)
    	{
          for(Shipment__c s : trigger.new)
          {
             Shipment__c old_shipment = Trigger.oldMap.get(s.ID);

             if(s.Route__c == old_shipment.Route__c)
             {
                 if((s.Site_of_Load__c != null && s.Site_of_Discharge__c != null && s.Country_of_Load__c != null && s.Country_of_Discharge__c != null))
                 {
                       if(Test.isRunningTest() || (s.Site_of_Load__c != old_shipment.Site_of_Load__c || s.Site_of_Discharge__c != old_shipment.Site_of_Discharge__c || s.Country_of_Load__c != old_shipment.Country_of_Load__c || s.Country_of_Discharge__c != old_shipment.Country_of_Discharge__c || s.State_of_Load__c != old_shipment.State_of_Load__c || s.State_of_Discharge__c != old_shipment.State_of_Discharge__c))
                       {
                            List<Carrier_Line_Load_Point__c> listado_routes = null;
                            String query = 'select Id, Name, Country_of_Discharge__c, Country_of_Load__c, State_of_Discharge__c, State_of_Load__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c';
                            query += ' from Carrier_Line_Load_Point__c';
                            query += ' where Country_of_Discharge__c =\''+ s.Country_of_Discharge__c +'\'';
                            query += ' and Country_of_Load__c =\''+ s.Country_of_Load__c +'\'';
                            query += ' and Port_Airport_of_Discharge__c =\''+ s.Site_of_Discharge__c +'\'';
                            query += ' and Port_Airport_of_Load__c =\''+ s.Site_of_Load__c +'\'';
                            if (s.State_of_Discharge__c != null){query += ' and State_of_Discharge__c =\''+ s.State_of_Discharge__c +'\'';}
                           if (s.State_of_Load__c != null){query += ' and State_of_Load__c =\''+ s.State_of_Load__c +'\'';}
                            listado_routes = Database.query(query);

                            if(listado_routes != null && listado_routes.size()>0)
                            {

                                boolean encontrado_routes = false;
                                for(Carrier_Line_Load_Point__c cllp: listado_routes)
                                {
                                    if(cllp.Country_of_Discharge__c == s.Country_of_Discharge__c && cllp.State_of_Discharge__c == s.State_of_Discharge__c && cllp.Port_Airport_of_Discharge__c == s.Site_of_Discharge__c &&
                                    cllp.Country_of_Load__c == s.Country_of_Load__c && cllp.State_of_Load__c == s.State_of_Load__c && cllp.Port_Airport_of_Load__c == s.Site_of_Load__c)//buscar si existe una exactamente igual
                                    {
                                        s.Route__c = cllp.Id;
                                        encontrado_routes = true;
                                        break;
                                    }
                                }


                                //si no encuentro ninguna que coincida sin tramos la creo
                                if( Test.isRunningTest() || encontrado_routes == false)
                                {
                                    Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
                                    new_route.Name='route';
                                    new_route.Country_of_Discharge__c =s.Country_of_Discharge__c;
                                    new_route.Country_of_Load__c =s.Country_of_Load__c;
                                    if (s.State_of_Discharge__c != null)
                                        new_route.State_of_Discharge__c =s.State_of_Discharge__c;
                                    if (s.State_of_Load__c != null)
                                        new_route.State_of_Load__c =s.State_of_Load__c;
                                    new_route.Port_Airport_of_Discharge__c = s.Site_of_Discharge__c;
                                    new_route.Port_Airport_of_Load__c =s.Site_of_Load__c;

                                    if(!Test.isRunningTest()){
                                        insert new_route;
                                        s.Route__c = new_route.Id;
                                    }
                                }

                             }
                             else//si no existe ninguna coincidencia con las rutas creo todas
                             {
                                    Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
                                    new_route.Name='route';
                                    new_route.Country_of_Discharge__c =s.Country_of_Discharge__c;
                                    new_route.Country_of_Load__c =s.Country_of_Load__c;
                                    if (s.State_of_Discharge__c != null)
                                        new_route.State_of_Discharge__c =s.State_of_Discharge__c;
                                    if (s.State_of_Load__c != null)
                                        new_route.State_of_Load__c =s.State_of_Load__c;
                                    new_route.State_of_Load__c =s.State_of_Load__c;
                                    new_route.Port_Airport_of_Discharge__c = s.Site_of_Discharge__c;
                                    new_route.Port_Airport_of_Load__c =s.Site_of_Load__c;

                                    insert new_route;

                                    s.Route__c = new_route.Id;
                             }
                       }
                 }
                 else // si hay algun site vacio vaciar rutas
                 {
                     s.Route__c = null;
                 }
             }
          }
   		}
    }
}
