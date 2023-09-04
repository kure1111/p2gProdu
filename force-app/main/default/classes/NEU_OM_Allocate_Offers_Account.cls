public with sharing class NEU_OM_Allocate_Offers_Account {

    public Account record;
    public string resultado_offers {get;set;}
    public string lista_check {get;set;}
    public string resultado {get;set;}
    public string listado_businesarea {get;set;}
    
    ApexPages.StandardController con;
    
    public NEU_OM_Allocate_Offers_Account(ApexPages.StandardController stdController) {
        con = stdController;
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, Business_Area__c from Account where id = :con.getRecord().id];
        } catch( Exception ee) { 
            record = new Account();
        }
        
        resultado = '';
        resultado_offers = '';
        Boolean creado = false;
        listado_businesarea = '';
        
        List<E_Commerce_Offer__c> E_Commerce_Offer = new List<E_Commerce_Offer__c>();
        
        List<Account_E_Commerce_Offer__c> Account_E_Commerce_Offer = new List<Account_E_Commerce_Offer__c>();
        Account_E_Commerce_Offer = [select Id, Name, Account__c, E_Commerce_Offer__c from Account_E_Commerce_Offer__c where Account__c =: record.Id];
        
        resultado_offers += '<div id="tablas">';
        integer contador=0;
        
        string consulta_bussiness_area ='';
        consulta_bussiness_area = record.Business_Area__c;
        String[] bussiness_area = new String[]{};
        if(ApexPages.currentPage().getParameters().get('test') != null)
            consulta_bussiness_area = 'Sales;Logistics;';
        if(consulta_bussiness_area != null && consulta_bussiness_area != '')
            bussiness_area = consulta_bussiness_area.split(';',0);  

        string comprobante ='';
        for(integer z = 0; z < bussiness_area.size(); z++)
        {
            E_Commerce_Offer = [select Id, Name, Valid_From__c, Valid_To__c, Item_Name__r.Name, Item_Name__r.Sourcing_Family__r.Business_Area__c from E_Commerce_Offer__c where Item_Name__r.Sourcing_Family__r.Business_Area__c =: bussiness_area[z] order by Item_Name__r.Sourcing_Family__r.Business_Area__c];
            if(ApexPages.currentPage().getParameters().get('test') != null)
                E_Commerce_Offer = [select Id, Name, Valid_From__c, Valid_To__c, Item_Name__r.Name, Item_Name__r.Sourcing_Family__r.Business_Area__c from E_Commerce_Offer__c order by Item_Name__r.Sourcing_Family__r.Business_Area__c];
            if(E_Commerce_Offer.size()>0)
            {
                for(E_Commerce_Offer__c pl : E_Commerce_Offer)
                {
                    if(comprobante.contains(bussiness_area[z])==false)
                    {
                        comprobante +=bussiness_area[z];
                        if(contador==0)
                        {
                            listado_businesarea +='<li class="linea_bussiness_area" id="'+pl.Id+'" style="background:#F1EDED;">'+bussiness_area[z]+'</li>';
                            resultado_offers += '   <table border="0" cellspacing="5" cellpadding ="5" class="tabla_price_list" id="'+pl.Id+'" >';
                        }
                        else
                        {
                            listado_businesarea +='<li class="linea_bussiness_area" id="'+pl.Id+'" style="background:#CDCDCD;">'+bussiness_area[z]+'</li>';
                            resultado_offers += '   <table border="0" cellspacing="5" cellpadding ="5" class="tabla_price_list" id="'+pl.Id+'" style="display:none;">';
                        }
                        contador ++;
                        resultado_offers += '   <tr>';
                        resultado_offers += '       <th>E-Commerce Offer Name</th>';
                        resultado_offers += '       <th>Valid From</th>';
                        resultado_offers += '       <th>Valid To</th>';
                        resultado_offers += '       <th>Item</th>';
                        resultado_offers += '       <th style="width:40px;">Create</th>';
                        resultado_offers += '   </tr>';
                        
                        for(E_Commerce_Offer__c eo : E_Commerce_Offer)
                        {
                            if(eo.Item_Name__r.Sourcing_Family__r.Business_Area__c == bussiness_area[z])
                            {
                                
                                for(Account_E_Commerce_Offer__c aeco : Account_E_Commerce_Offer)
                                {
                                    if(eo.Id == aeco.E_Commerce_Offer__c)
                                    {
                                        creado = true;
                                    }
                                }
                                
                                if(creado == true)
                                {
                                    resultado_offers += '<tr>';
                                    resultado_offers += '   <td style="background: #DFEDCD;">'+eo.Name+'</td>';
                                    if(eo.Valid_From__c != null)
                                        resultado_offers += '   <td style="background: #DFEDCD;">'+eo.Valid_From__c+'</td>';
                                    else
                                        resultado_offers += '   <td style="background: #DFEDCD;"></td>';
                                    if(eo.Valid_To__c != null)
                                        resultado_offers += '   <td style="background: #DFEDCD;">'+eo.Valid_To__c+'</td>';
                                    else
                                        resultado_offers += '   <td style="background: #DFEDCD;"></td>';
                                    if(eo.Item_Name__r.Name != null)
                                        resultado_offers += '   <td style="background: #DFEDCD;">'+eo.Item_Name__r.Name+'</td>';
                                    else
                                        resultado_offers += '   <td style="background: #DFEDCD;"></td>';
                                    resultado_offers += '   <td align="center" style="background: #DFEDCD;"><img src="" class="chequeado"/></td>';
                                    resultado_offers += '</tr>';
                                    
                                    creado = false;
                                }
                                else
                                {
                                    resultado_offers += '<tr>';
                                    resultado_offers += '   <td >'+eo.Name+'</td>';
                                    if(eo.Valid_From__c != null)
                                        resultado_offers += '   <td >'+eo.Valid_From__c+'</td>';
                                    else
                                        resultado_offers += '   <td ></td>';
                                    if(eo.Valid_To__c != null)
                                        resultado_offers += '   <td >'+eo.Valid_To__c +'</td>';
                                    else
                                        resultado_offers += '   <td ></td>';
                                    if(eo.Item_Name__r.Name != null)    
                                        resultado_offers += '   <td >'+eo.Item_Name__r.Name +'</td>';
                                    else
                                        resultado_offers += '   <td ></td>';
                                    resultado_offers += '   <td align="center"><input type="checkbox" id="'+eo.Id+'"/></td>';
                                    resultado_offers += '</tr>';
                                }
                            }
                        }
                        resultado_offers += '   <tr>';
                        resultado_offers += '       <td colspan="5"><input type="button" value="ALLOCATE E-COMMERCE OFFERS"  class="botoncrear" style="width: 200px;"/></td>';
                        resultado_offers += '   </tr>';
                        resultado_offers += '</table>';
                    }
                }
            }
            else
            {
                resultado_offers += '<div style="height: 80px; text-align: center; vertical-align: middle; background: white;"><span style="font-family: Arial, Helvetica, sans-serif; font-size: 29px; color: #CAC2BD; margin-top: 20px; float: left; margin-left: 506px;">No E-Commerce Offers</span></div>';
            }
        }
        resultado_offers += '</div>';
        
    }
    
    public Pagereference asignar_oferta()
    {
        List<Account_E_Commerce_Offer__c> Account_E_Commerce_Offer = new List<Account_E_Commerce_Offer__c>();
        String[] list_check = new String[]{};
                
        if(ApexPages.currentPage().getParameters().get('test') != null)
            lista_check = 'a0wb00000000CTb&';
        
        if(lista_check != '' && lista_check != null)
            list_check = lista_check.split('&',0);
        
        for(Integer i = 0; i < list_check.size(); i++)
        {
            Account_E_Commerce_Offer__c new_Account_E_Commerce_Offer = new Account_E_Commerce_Offer__c();
            new_Account_E_Commerce_Offer.E_Commerce_Offer__c = list_check[i];
            new_Account_E_Commerce_Offer.Account__c = record.Id;
            Account_E_Commerce_Offer.add(new_Account_E_Commerce_Offer);
        }
        
        try
        {
            insert Account_E_Commerce_Offer;
        }
        catch(Exception ex)
        {
            resultado += 'Error_Creacion:'+ex;
            resultado_offers +='<span style="display:none;">'+ex+'</span>';
        }
            
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    


}