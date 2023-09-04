public class NEU_JE_RFP_ext {

    public Supplier_Request_RFP__c request{get;set;}
    
    private Integer progress=0;
    private List<Supplier_Quote_Line_s> newitems=null;
    private Supplier_Quote__c quote=null;
    private Integer counter=0;
    
    public String myid{get;set;}
     
    public String email{get;set;}

    public String secret{get;set;}

    public String error{get;set;}
    
    public String url1{get;set;}
    public String url2{get;set;}
    public String url3{get;set;}
    public String url4{get;set;}
    public String url5{get;set;}
    public String url6{get;set;}
    public String url7{get;set;}
    public String url8{get;set;}
    public String url9{get;set;}
    public String url10{get;set;}
    
    public boolean faltan_documentos{get;set;}
    
    public List<Associated_Document__c> associated_documents_extra;
    public boolean show_document_extra;
    public string supply_project_number{get;set;} 
    
    public string getquoteid()
    {
        if(quote != null)
            if(quote.Id != null)
                return quote.Id;
        return '';
    }
    
    public void setquoteid(string value)
    {
        
    }
    
    private String timeleft(Long milisec)
    {
        Long secs=milisec/1000L;
        String res='';
        Long current=secs/31536000L;//Years
        secs-=current*31536000L;
        if(current>0)
        {
            res=current+'&nbsp;year';
            if(current!=1) res+='s';
        }
        current=secs/2592000L;//Months
        secs-=current*2592000L;
        if(current>0)
        {
            if(res!='') res+=', ';
            res=res+current+'&nbsp;month';
            if(current!=1) res+='s';
        }
        current=secs/86400L;//Days
        secs-=current*86400L;
        if(current>0)
        {
            if(res!='') res+=', ';
            res=res+current+'&nbsp;day';
            if(current!=1) res+='s';
        }
        current=secs/3600L;//Hours
        secs-=current*3600L;
        if(current>0)
        {
            if(res!='') res+=', ';
            res=res+current+'&nbsp;hour';
            if(current!=1) res+='s';
        }
        current=secs/60L;//Minutes
        secs-=current*60L;
        if(current>0)
        {
            if(res!='') res+=', ';
            res=res+current+'&nbsp;minute';
            if(current!=1) res+='s';
        }
        if(secs>0)
        {
            if(res!='') res+=', ';
            res=res+secs+'&nbsp;second';
            if(secs!=1) res+='s';
        }
        return res;
    }
    public NEU_JE_RFP_ext()
    {
        request=null;
        email=Apexpages.currentPage().getParameters().get('email');
        secret=Apexpages.currentPage().getParameters().get('secret');
        myid=Apexpages.currentPage().getParameters().get('rfp');
        if((String.isNotEmpty(email))&&(String.isNotEmpty(secret))&&(String.isNotEmpty(myid)))
        {
            List<Supplier_Request_RFP__c>requestlist= null; string query_string_supplier_request = '';
            query_string_supplier_request +='select Contact_Sent__r.Email,Contact_Sent__r.Other_Email__c,Observations__c,Contact_Sent__c,Contact_Sent__r.Secret__c,Contact_Sent__r.Other_Secret__c,Contact_Sent__r.Self_Registered_Name__c,Supplier__r.NEU_Email__c,Supplier__r.Secret__c,';
            query_string_supplier_request +='    Id,';
            query_string_supplier_request +='    Supplier__c,';
            query_string_supplier_request +='    Supply_Project__c,';
            query_string_supplier_request +='    Estimated_Delivery_Date__c,';
            query_string_supplier_request +='    Date_Limit__c,';
            query_string_supplier_request +='    Incoterm_Request__c,';
            query_string_supplier_request +='    Incoterm_Place__c,';
            query_string_supplier_request +='    Port_Airport_of_Load__c,';
            query_string_supplier_request +='   Supply_Project__r.Country_of_Discharge__c,';
            query_string_supplier_request +='    Supply_Project__r.Port_Airport_of_Discharge__c,';
            query_string_supplier_request +='   Supply_Project__r.State_of_Discharge__c,';
            query_string_supplier_request +='    Country_of_Load__c,';
            query_string_supplier_request +='    Country_of_Load__r.Name,';
            query_string_supplier_request +='    State_of_Load__c,';
            query_string_supplier_request +='    State_of_Load__r.Name,';
            if(UserInfo.isMultiCurrencyOrganization()== true)
                query_string_supplier_request +='    CurrencyIsoCode,';
            query_string_supplier_request +='    CartonBox_Document__c,';
            query_string_supplier_request +='    Labels_Document__c,';
            query_string_supplier_request +='    Pallets_Document__c,';
            query_string_supplier_request +='    Poligag_Document__c,';
            query_string_supplier_request +='    Document_1_Required__c,';
            query_string_supplier_request +='    Document_2_Required__c,';
            query_string_supplier_request +='    Document_3_Required__c,';
            query_string_supplier_request +='    Document_4_Required__c,';
            query_string_supplier_request +='    Document_5_Required__c,';
            query_string_supplier_request +='    Document_6_Required__c,';
            query_string_supplier_request +='    Document_7_Required__c,';
            query_string_supplier_request +='    Document_8_Required__c,';
            query_string_supplier_request +='    Document_9_Required__c,';
            query_string_supplier_request +='    Document_10_Required__c,';
            query_string_supplier_request +='    Supply_Project__r.Sealed__c ,';
            query_string_supplier_request +='    Document_1_Type__c,';
            query_string_supplier_request +='    Document_2_Type__c,';
            query_string_supplier_request +='    Document_3_Type__c,';
            query_string_supplier_request +='    Document_4_Type__c,';
            query_string_supplier_request +='    Document_5_Type__c,';
            query_string_supplier_request +='    Document_6_Type__c,';
            query_string_supplier_request +='    Document_7_Type__c,';
            query_string_supplier_request +='    Document_8_Type__c,';
            query_string_supplier_request +='    Document_9_Type__c,';
            query_string_supplier_request +='    Document_10_Type__c,';
            query_string_supplier_request +='    Supply_Project__r.Supply_Project_Number__c,';
            query_string_supplier_request +='    Visited__c,';
            query_string_supplier_request +='    Customer__c,';
            query_string_supplier_request +='    Auction_Minimum_Increase_Decrease__c,';
            query_string_supplier_request +='    Max_Shipment__c,';
            query_string_supplier_request +='    Contract_Duration__c,';
            query_string_supplier_request +='    LinkedIn_Group_URL__c';
            Id id_query = Id.valueOf(myid);
            query_string_supplier_request +='    from Supplier_Request_RFP__c where Id =:id_query';
                 
            List<sObject> query_supplier_request = Database.query(query_string_supplier_request );
            requestlist = query_supplier_request;     
                 
            if(requestlist.size()>0)
            {
                supply_project_number = requestlist[0].Supply_Project__r.Supply_Project_Number__c;
                read_document();
                //---------------------------------------
                
                
                if(requestlist[0].Contact_Sent__r!=null)
                {
                    if(((requestlist[0].Contact_Sent__r.Email==email)&&(requestlist[0].Contact_Sent__r.Secret__c==secret))||((requestlist[0].Contact_Sent__r.Other_Email__c==email)&&(requestlist[0].Contact_Sent__r.Other_Secret__c==secret)))
                    {
                        request=requestlist[0];
                        getitemstosuplay();
                        return;
                    }
                }
                else
                {
                    if((requestlist[0].Supplier__r.NEU_Email__c==email)&&(requestlist[0].Supplier__r.Secret__c==secret))
                    {
                        request=requestlist[0];
                        getitemstosuplay();
                        return;
                    }
                }
            }
        }
    }
    
    public void read_document()
    {
        List<Supplier_Request_RFP__c>requestlist=[select 
                Id,
                Document_1_Required__c,
                Document_2_Required__c,
                Document_3_Required__c,
                Document_4_Required__c,
                Document_5_Required__c,
                Document_6_Required__c,
                Document_7_Required__c,
                Document_8_Required__c,
                Document_9_Required__c,
                Document_10_Required__c,
                Document_1_Type__c,
                Document_2_Type__c,
                Document_3_Type__c,
                Document_4_Type__c,
                Document_5_Type__c,
                Document_6_Type__c,
                Document_7_Type__c,
                Document_8_Type__c,
                Document_9_Type__c,
                Document_10_Type__c
                
                 from Supplier_Request_RFP__c where Id=:myid];
            if(requestlist.size()>0)
            {
                //comprobar los 10 documentos del proyecto
                // saber si estan todos los documentos subidos
                faltan_documentos = true;
                boolean falta1 = true;
                boolean falta2 = true;
                boolean falta3 = true;
                boolean falta4 = true;
                boolean falta5 = true;
                boolean falta6 = true;
                boolean falta7 = true;
                boolean falta8 = true;
                boolean falta9 = true;
                boolean falta10 = true;
                url1 ='';
                
                if((!requestlist[0].Document_1_Required__c)&&
                        (!requestlist[0].Document_2_Required__c)&&
                        (!requestlist[0].Document_3_Required__c)&&
                        (!requestlist[0].Document_4_Required__c)&&
                        (!requestlist[0].Document_5_Required__c)&&
                        (!requestlist[0].Document_6_Required__c)&&
                        (!requestlist[0].Document_7_Required__c)&&
                        (!requestlist[0].Document_8_Required__c)&&
                        (!requestlist[0].Document_9_Required__c)&&
                        (!requestlist[0].Document_10_Required__c))
                    faltan_documentos=false;
                List<Associated_Document__c> lista_documentos_adjuntos = new List<Associated_Document__c>();
                lista_documentos_adjuntos =[select Id, Name, Document_Type__c, Document_Reference__c, Document_URL__c from Associated_Document__c where Supplier_Request_RFP__c =: myid ];
                if(lista_documentos_adjuntos.size()>0)
                {
                    for(Associated_Document__c asdo: lista_documentos_adjuntos)
                    {
                        if(requestlist[0].Document_1_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_1_Type__c)
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 1') == true)
                                    {
                                        falta1 = false;
                                        url1 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else
                        {
                            falta1 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_1_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 1') == true)
                                        url1 = asdo.Document_URL__c;
                            }
                        }
                        
                        if(requestlist[0].Document_2_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_2_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 2') == true)
                                    {
                                        falta2 = false;
                                        url2 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else
                        {
                            falta2 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_2_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 2') == true)
                                        url2 = asdo.Document_URL__c;
                            }
                        }
                        
                        if(requestlist[0].Document_3_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_3_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 3') == true)
                                    {
                                        falta3 = false;
                                        url3 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else
                        {
                            falta3 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_3_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 3') == true)
                                        url3 = asdo.Document_URL__c;
                            }
                        }
                        
                        if(requestlist[0].Document_4_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_4_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 4') == true)
                                    {
                                        falta4 = false;
                                        url4 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else
                        {
                            falta4 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_4_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 4') == true)
                                        url4 = asdo.Document_URL__c;
                            }
                        }
                        
                        if(requestlist[0].Document_5_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_5_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 5') == true)
                                    {
                                        falta5 = false; 
                                        url5 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else
                        {
                            falta5 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_5_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 5') == true)
                                        url5 = asdo.Document_URL__c;
                            }
                        }
                        
                        if(requestlist[0].Document_6_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_6_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 6') == true)
                                    {
                                        falta6 = false; 
                                        url6 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else
                        {
                            falta6 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_6_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 6') == true)
                                        url6 = asdo.Document_URL__c;
                            }
                        }
                        
                        if(requestlist[0].Document_7_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_7_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 7') == true)
                                    {
                                        falta7 = false; 
                                        url7 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else
                        {
                            falta7 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_7_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 7') == true)
                                        url7 = asdo.Document_URL__c;
                            }
                        }
                        if(requestlist[0].Document_8_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_8_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 8') == true)
                                    {
                                        falta8 = false;     
                                        url8 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else 
                        {
                            falta8 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_8_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 8') == true)
                                        url8 = asdo.Document_URL__c;
                            }
                        }
                        if(requestlist[0].Document_9_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_9_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 9') == true)
                                    {
                                        falta9 = false;
                                        url9 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else
                        {
                            falta9 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_9_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 9') == true)
                                        url9 = asdo.Document_URL__c;
                            }
                        }
                        if(requestlist[0].Document_10_Required__c == true)
                        {
                            if(asdo.Document_Type__c == requestlist[0].Document_10_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 10') == true)
                                    {
                                        falta10 = false;
                                        url10 = asdo.Document_URL__c;
                                    }
                            }
                        }
                        else
                        {
                            falta10 = false;
                            if(asdo.Document_Type__c == requestlist[0].Document_10_Type__c )
                            {
                                if(asdo.Document_Reference__c != null)
                                    if(asdo.Document_Reference__c.contains('Document 10') == true)
                                        url10 = asdo.Document_URL__c;
                            }
                        }
                    }
            }
                if(falta1 == false && falta2 == false && falta3 == false && falta4 == false && falta5 == false && falta6 == false && falta7 == false && falta8 == false && falta9 == false && falta10 == false)
                    faltan_documentos = false;
            }
    }
    
    public Boolean getquoted()
    {
        if(quote!=null)
            return (quote.Id!=null);
        return false;
    }
    public PageReference refreshauction()
    {
        return null;
    }
    public void setcloseauction(Long value){}
    public Long getcloseauction()
    {
        if(request!=null)
        {
            List<Supplier_Request_RFP__c>proys=[select Auction_End_Time__c from Supplier_Request_RFP__c where id=:request.Id];
            if(proys.size()>0)
                if(proys[0].Auction_End_Time__c!=null)
                    return proys[0].Auction_End_Time__c.getTime()-DateTime.now().getTime();
        }
        return 0;
    }
    public String getcloseauctiontext()
    {
        if(request!=null)
        {
            List<Supplier_Request_RFP__c>proys=[select Auction_End_Time__c from Supplier_Request_RFP__c where id=:request.Id];
            if(proys.size()>0)
                if(proys[0].Auction_End_Time__c!=null)
                    return timeleft(proys[0].Auction_End_Time__c.getTime()-DateTime.now().getTime());
        }
        return '';
    }
    public void setstartauction(Long value){}
    public Long getstartauction()
    {
        if(request!=null)
        {
            List<Supplier_Request_RFP__c>proys=[select Auction_Start_Time__c from Supplier_Request_RFP__c where id=:request.Id];
            if(proys.size()>0)
                if(proys[0].Auction_Start_Time__c!=null)
                    return proys[0].Auction_Start_Time__c.getTime()- DateTime.now().getTime();
        }
        return 0;
    }
    public String getstartauctiontext()
    {
        if(request!=null)
        {
            List<Supplier_Request_RFP__c>proys=[select Auction_Start_Time__c from Supplier_Request_RFP__c where id=:request.Id];
            if(proys.size()>0)
                if(proys[0].Auction_Start_Time__c!=null)
                    return timeleft(proys[0].Auction_Start_Time__c.getTime()- DateTime.now().getTime());
        }
        return '';
    }
    public String getendtimetext()
    {
        if(request!=null)
        {
            List<Supplier_Request_RFP__c>proys=[select Auction_End_Time__c from Supplier_Request_RFP__c where id=:request.Id];
            if(proys.size()>0)
                if(proys[0].Auction_End_Time__c!=null)
                    return proys[0].Auction_End_Time__c.format();
        }
        return null;
    }
    public String getstarttimetext()
    {
        if(request!=null)
        {
            List<Supplier_Request_RFP__c>proys=[select Auction_Start_Time__c from Supplier_Request_RFP__c where id=:request.Id];
            if(proys.size()>0)
                if(proys[0].Auction_Start_Time__c!=null)
                    return proys[0].Auction_Start_Time__c.format();
        }
        return null;
    }
    public void setdynamicstateauctiontext(String value){}
    public String getdynamicstateauctiontext()
    {
        if(request!=null)
        {
            List<Supplier_Request_RFP__c>proys=[select Auction_Dynamic_Status__c from Supplier_Request_RFP__c where id=:request.Id];
            if(proys.size()>0)
                return proys[0].Auction_Dynamic_Status__c;
        }
        return null;
    }
    public void setdynamicstateauction(Integer value){}
    public Integer getdynamicstateauction()
    {
        if(request!=null)
        {
            List<Supplier_Request_RFP__c>proys=[select Auction_Dynamic_Status__c from Supplier_Request_RFP__c where id=:request.Id];
            if(proys.size()>0)
                if(proys[0].Auction_Dynamic_Status__c=='Not Started')
                    return 1;
                else if(proys[0].Auction_Dynamic_Status__c=='Started')
                    return 2;
                else if(proys[0].Auction_Dynamic_Status__c=='Closed')
                    return 3;
        }
        return 0;
    }
    private String getdynamicstatus()
    {
        if(quote!=null)
        {
            List<Supplier_Quote__c>quotes=[select Supplier_Quote_Status__c from Supplier_Quote__c where id=:quote.Id];
            if(quotes.size()>0)
                return quotes[0].Supplier_Quote_Status__c;
        }
        return 'Draft';
    }
    public void setranking(String value){}
    public String getranking()
    {
        if((getdynamicstateauction()>1)&&(getquoted()))
        {
            Integer r=NEU_JE_RFP_quote_ranking.getRanking(quote.Id,request.Supply_Project__c);
            if(r>9)
                return 'YOUR RANKING '+String.valueOf(r);
            if(r>0)
                return 'YOUR RANKING 0'+String.valueOf(r);
        }
        return 'YOUR RANKING --';
    }
    public Supplier_Quote__c getquote()
    {
        return quote;
    }
    public Boolean getisopen()
    {
        if(request.Date_Limit__c !=null)
            if(request.Date_Limit__c<Date.today())
                return false;
        if(getquoted())
        {
            if(quote.Valid_for_Auction__c)
                if(getdynamicstateauction()==3)
                    return false;
            String status=getdynamicstatus();
            if(status=='Draft')
                return true;
            if(status=='Sent Bid')
                return true;
            return false;
        }
        return true;
    }

    public Boolean getshowdocuments()
    {
        if(request!=null)
            return ((quote.Supplier_Request_RFP__r.CartonBox_Document__c!=null)||
                    (quote.Supplier_Request_RFP__r.Labels_Document__c!=null)||
                    (quote.Supplier_Request_RFP__r.Pallets_Document__c!=null)||
                    (quote.Supplier_Request_RFP__r.Poligag_Document__c!=null));
        return false;
    }
    
    public Boolean getshow_associated_documents()
    {
            List<Supplier_Request_RFP__c>requestlist=[select Contact_Sent__r.Email,Contact_Sent__r.Secret__c,Supplier__r.NEU_Email__c,Supplier__r.Secret__c,
                Id,
                Supplier__c,
                Supply_Project__c,
                Estimated_Delivery_Date__c,
                Date_Limit__c,
                Incoterm_Request__c,
                Incoterm_Place__c,
            //  CurrencyIsoCode,
                CartonBox_Document__c,
                Labels_Document__c,
                Pallets_Document__c,
                Poligag_Document__c,
                Document_1_Required__c,
                Document_2_Required__c,
                Document_3_Required__c,
                Document_4_Required__c,
                Document_5_Required__c,
                Document_6_Required__c,
                Document_7_Required__c,
                Document_8_Required__c,
                Document_9_Required__c,
                Document_10_Required__c,
                Supply_Project__r.Sealed__c ,
                Document_1_Type__c,
                Document_2_Type__c,
                Document_3_Type__c,
                Document_4_Type__c,
                Document_5_Type__c,
                Document_6_Type__c,
                Document_7_Type__c,
                Document_8_Type__c,
                Document_9_Type__c,
                Document_10_Type__c,
                Visited__c,
                Customer__c,
                Auction_Minimum_Increase_Decrease__c,
                Max_Shipment__c,
                Contract_Duration__c
                 from Supplier_Request_RFP__c where Id=:myid];
            if(requestlist.size()>0)
            {
                return ((requestlist[0].Document_1_Type__c!=null)||
                    (requestlist[0].Document_2_Type__c!=null)||
                    (requestlist[0].Document_3_Type__c!=null)||
                    (requestlist[0].Document_4_Type__c!=null)||
                    (requestlist[0].Document_5_Type__c!=null)||
                    (requestlist[0].Document_6_Type__c!=null)||
                    (requestlist[0].Document_7_Type__c!=null)||
                    (requestlist[0].Document_8_Type__c!=null)||
                    (requestlist[0].Document_9_Type__c!=null)||
                    (requestlist[0].Document_10_Type__c!=null));
            }
        return false;
    }
    
    public boolean getshow_document_extra()
    {
        List<Associated_Document__c> lisadocumento_asociados = [select Id, Name, Document_URL__c, Manual_Document_URL__c, Document_Reference__c, Document_Type__c from Associated_Document__c where Supplier_Request_RFP__c =: myid];
        for(Associated_Document__c ad: lisadocumento_asociados)
        {
            if(ad.Document_Reference__c != null)
            {
                if(ad.Document_Reference__c.contains(supply_project_number + ' - Document') == false)  
                {
                    return true;
                }
            }
            else
                return true;
        }
        return false;
    }
    
    public List<Associated_Document__c> getassociated_documents_extra()
    {
        associated_documents_extra = new List<Associated_Document__c>();
        List<Associated_Document__c> lisadocumento_asociados = [select Id, Name, Document_URL__c, Manual_Document_URL__c, Document_Reference__c, Document_Type__c  from Associated_Document__c where Supplier_Request_RFP__c =: myid];
        for(Associated_Document__c ad: lisadocumento_asociados)
        {
            if(ad.Document_Reference__c != null)
            {
                if(ad.Document_Reference__c.contains(supply_project_number + ' - Document') == false)  
                {
                    associated_documents_extra.add(ad);
                }
            }
            else
                associated_documents_extra.add(ad);
        }
        return associated_documents_extra;
    }
    
    public PageReference setvisited()
    {
        if(request!=null)
            if(!request.Visited__c)
            {
                request.Visited__c=true;
                try{
                    update request;
                }
                catch(Exception e){}
            }
        return null;
    }
    public Boolean getcanmakequestions()
    {
        return false;
        /*if(!Site.isLoginEnabled())
            return false;
        if(!Site.isRegistrationEnabled())
            return false;
        return true;*/
    }
    public PageReference makequestions()
    {
        if((!Site.isLoginEnabled())&&(!Test.isRunningTest()))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Site login is disabled'));
            return null;
        }
        String password=null;
        
        if(NEU_JE_RFP_quote_ranking.validPassword(secret))
            password=secret;
        else if(NEU_JE_RFP_quote_ranking.validPassword('SUPPLIER'+secret))
            password='SUPPLIER'+secret;
        else
            password=NEU_JE_RFP_quote_ranking.newPassword(false,'SUPPLIER');
        if(String.isNotEmpty(request.Contact_Sent__r.Self_Registered_Name__c))
        {
            PageReference res=Site.login(request.Contact_Sent__r.Self_Registered_Name__c,password,'/_ui/core/chatter/groups/GroupProfilePage?g=0F9b00000000Mlh');
            if(res!=null)
                return res;
            return Site.login(request.Contact_Sent__r.Self_Registered_Name__c,null,'/_ui/core/chatter/groups/GroupProfilePage?g=0F9b00000000Mlh');
        }
        if((!Site.isRegistrationEnabled())&&(!Test.isRunningTest()))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Site registration is disabled'));
            return null;
        }
        String profileId = '00eb0000000MrfM'; // To be filled in by customer.
        String accountId = request.Supplier__c; // To be filled in by customer.
        
        User u = new User();
        u.Email = email;
        u.ProfileId = profileId;
        String userId = null;
        Integer counter=0;
        do{
            if(counter==0)
                u.Username = email;
            else
                u.Username = email.replace('@',String.valueOf(counter)+'@');
            u.CommunityNickname=u.Username.substringBefore('@');
            userId=Site.createPortalUser(u, accountId, password, false);
            counter++;
        }while(String.isEmpty(userId) && (counter<100));

        if (String.isNotEmpty(userId)||Test.isRunningTest()) {
            List<Contact>contactlist=[select Id,Self_Registered_Name__c from Contact where Id=:request.Contact_Sent__c];
            if(contactlist.size()>0)
            {
                contactlist[0].Self_Registered_Name__c=u.Username;
                update contactlist[0];
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new string[]{email});
            mail.setSubject('Welcome to '+Site.getMasterLabel());
            mail.setHtmlBody('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html><head></head><body style="font-family:Arial; font-size:14px;">Welcome to '+Site.getMasterLabel()+'<br/><br/>To get started, go to <a href="'+Site.getBaseUrl()+'">'+Site.getBaseUrl()+'</a><br/><br/>User Name: '+u.Username+'<br/><br/>Thanks</body></html>');
            mail.setCharset('UTF-8');
            try{
                System.debug('You have made ' + Limits.getEmailInvocations() + ' email calls out of ' + Limits.getLimitEmailInvocations() + ' allowed');
                Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                if(!resultMail[0].isSuccess())
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'email error'));
            }
            catch(Exception ex)
            {
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            }
            return Site.login(u.Username, password, '/_ui/core/chatter/groups/GroupProfilePage?g=0F9b00000000Mlh');
        }
        return null;
    }
    public PageReference quote()
    {
        read_document();
        if(request==null)
        {
            error='You cannot change the quote at this moment';
            return null;
        }
        if(!getisopen())
        {
            error='You cannot change the quote at this moment';
            return null;
        }
        if(quote.Supplier_Quote_Status__c == 'Sent Bid' || quote.Supplier_Quote_Status__c =='Sent Final Bid')
        {
            if(faltan_documentos != false)
            {
                error='You cannot change the status to Sent Bid if not upload all the document required';
                return null;
            }
        }
        
        if(quote.Valid_Until__c == null)
        {
            error='You must enter a Valid Until, is required';
            return null;
        }
        
        for(Supplier_Quote_Line_s qline:newitems)
        {
            if(qline.line.Quantity__c == null) 
            {
                error='Your Quantity must be filled ';
                return null;
            }
                
            if(qline.line.Supplier_Request_Line__r.Conversion_Factor__c != null)
            {
                  if(qline.line.Supplier_Request_Line__r.Conversion_Factor__c != 0 && qline.line.Supplier_Request_Line__r.Unit_of_measure_RFP__c != null)
                  {
                    if((qline.line.Quantity__c/qline.line.Supplier_Request_Line__r.Conversion_Factor__c) > qline.line.Supplier_Request_Line__r.Quantity__c && qline.line.Supplier_Request_Line__r.Hide_Quantity__c == false)
                    {
                        error='Your Quantity exceeds the maximum requested';
                        return null;
                    }
                  }
                  else
                  {
                       if(qline.line.Quantity__c > qline.line.Supplier_Request_Line__r.Quantity__c && qline.line.Supplier_Request_Line__r.Hide_Quantity__c == false)
                    {
                        error='Your Quantity exceeds the maximum requested';
                        return null;
                    }
                  }
            }
             else
                  {
                       if(qline.line.Quantity__c > qline.line.Supplier_Request_Line__r.Quantity__c && qline.line.Supplier_Request_Line__r.Hide_Quantity__c == false)
                    {
                        error='Your Quantity exceeds the maximum requested';
                        return null;
                    }
                  }
                  
//                    if(qline.line.Price__c != null)  
//                      if(qline.line.Production_Time_Days__c == null)
//                      {
//                            error='You must enter a Production Time, this field is required';
//                            return null;
//                      }
                      
               if(qline.line.Item_Units_x_Packaging__c == null && (qline.line.Packaging_Length_cm__c != null || qline.line.Packaging_Width_cm__c != null || qline.line.Packaging_Height_cm__c != null || qline.line.Supplier_Item_Weight_kg__c != null || qline.line.Packaging_Weight_kg__c != null))
                {
                    error ='You must enter a Item Units / Packaging';
                    return null;
                }
                if(qline.line.Packaging_Length_cm__c != null || qline.line.Packaging_Width_cm__c != null || qline.line.Packaging_Height_cm__c != null)
                {
                    if(qline.line.Packaging_Length_cm__c == null)
                    {
                        error ='You must enter a Packaging Length (cm)';
                        return null;
                    }
                    if(qline.line.Packaging_Width_cm__c == null)
                    {
                        error ='You must enter a Packaging Width (cm)';
                        return null;
                    }
                    if(qline.line.Packaging_Height_cm__c == null)
                    {
                        error ='You must enter a Packaging Height (cm)';
                        return null;
                    }
                } 
                if(qline.line.Packaging_Weight_kg__c != null)
                {
                    if(qline.line.Supplier_Item_Weight_kg__c == null)
                    {
                        error ='You must enter a Supplier Item Weight (kg)';
                        return null;
                    }
                } 
                
        }
        
        if(quote.id==null)
        {
            Supplier_Quote__c qu =NEU_JE_RFP_quote_ranking.insertQuote(quote);
            if(qu == null)
            {
                error ='There is an Error in your data. Please try again';
                return null;
            }
            quote = qu;
        }
        else
        {
            try
            {
                update quote;
            }
            catch(Exception ex){error = 'There is an Error in your data. Please try again'; return null;}
        }
        
        
            
        
        /*if(quote.Supplier_Quote_Status__c == 'Sent Bid' || quote.Supplier_Quote_Status__c =='Sent Final Bid')// no se puede escribir en chatter desde el guest user
        {
            string total_amount_chat = '';
            if(quote.RecordTypeId != Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Hidden Quote').getRecordTypeId())
                total_amount_chat = string.valueof(quote.Total_Amount__c);
            else
                total_amount_chat = '';
            ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, quote.Supply_Project__c, ''+quote.Supplier_Request_RFP__r.Supplier__r.Name+' '+ quote.Supplier_Quote_Status__c +' '+ quote.Id 
                + ' '+ total_amount_chat + '');
            
        }*/
        
        Boolean validforauction=true; 
        if((quote.Valid_for_Auction__c)&&(getdynamicstateauction()==2))
        {
            Decimal total=0;
            Decimal oldtotal=0;
            for(Supplier_Quote_Line_s qline:newitems)
            {
                if(qline.line.Price__c==null)
                    qline.line.Price__c=0;
                    
                    
                if(qline.line.Supplier_Request_Line__r.Conversion_Factor__c >0 && qline.line.Supplier_Request_Line__r.Unit_of_measure_RFP__c != null)    
                  total+=(qline.line.Price__c*qline.line.Supplier_Request_Line__r.Conversion_Factor__c)*(qline.line.Quantity__c/qline.line.Supplier_Request_Line__r.Conversion_Factor__c);
                else
                  total+=qline.line.Price__c*qline.line.Quantity__c;
                  
                if(qline.line.Expense_Amount__c!=null)
                    total+=qline.line.Expense_Amount__c;    
                
                if(qline.oldPrice!=null)
                {
                  if(qline.line.Supplier_Request_Line__r.Conversion_Factor__c >0 && qline.line.Supplier_Request_Line__r.Unit_of_measure_RFP__c != null)
                      oldtotal+=(qline.oldprice)*(qline.line.Quantity__c/qline.line.Supplier_Request_Line__r.Conversion_Factor__c);
                     else
                       oldtotal+=qline.oldprice*qline.line.Quantity__c;
                }
                
                if(qline.oldExpense!=null)
                    oldtotal+=qline.oldExpense;
            }
            if(total>oldtotal)
            {
                error='You cannot increase the total amount';
                return null;
            }
            if((total<oldtotal)&&(quote.Supplier_Request_RFP__r.Auction_Minimum_Increase_Decrease__c!=null))
                if(oldtotal-total<quote.Supplier_Request_RFP__r.Auction_Minimum_Increase_Decrease__c)
                {
                    error='You have not reached the minimum decrease';
                    return null;
                }
            if(total!=oldtotal)
                NEU_JE_RFP_quote_ranking.updateLastBid(request.Supply_Project__c);
        }
        Decimal total=0;
        Integer numberLine=0;
        List<Supplier_Quote_Line__c>toinsert=new List<Supplier_Quote_Line__c>();
        List<Supplier_Quote_Line__c>toupdate=new List<Supplier_Quote_Line__c>();
        
        for(Supplier_Quote_Line_s qline:newitems)
        {
            if(qline.line.Expense_Concept__c!=null)
                qline.line.Expense_Concept__c=qline.line.Expense_Concept__c.trim();
            if(qline.line.Observations__c!=null)
                qline.line.Observations__c=qline.line.Observations__c.trim();
            if(qline.line.Price__c==null)
                validforauction=false;
            
             if(qline.line.Supplier_Request_Line__r.Conversion_Factor__c >0 && qline.line.Supplier_Request_Line__r.Unit_of_measure_RFP__c != null && qline.line.Price__c != null)
              qline.oldprice=qline.line.Price__c*qline.line.Supplier_Request_Line__r.Conversion_Factor__c;
            else
              qline.oldprice=qline.line.Price__c;
              
            
            
             if(qline.line.Supplier_Request_Line__r.Conversion_Factor__c >0 && qline.line.Supplier_Request_Line__r.Unit_of_measure_RFP__c != null)
             {
               if((qline.line.Quantity__c/qline.line.Supplier_Request_Line__r.Conversion_Factor__c) != qline.line.Supplier_Request_Line__r.Quantity__c)
                  validforauction=false;
              if(qline.line.Price__c!=null)
                  total+=(qline.line.Price__c/qline.line.Supplier_Request_Line__r.Conversion_Factor__c)*(qline.line.Quantity__c/qline.line.Supplier_Request_Line__r.Conversion_Factor__c);
             }
             else
             {  
              if(qline.line.Quantity__c != qline.line.Supplier_Request_Line__r.Quantity__c)
                  validforauction=false;
              if(qline.line.Price__c!=null)
                  total+=qline.line.Price__c*qline.line.Quantity__c;
             }  
             
              
            if(qline.line.Supplier_Request_Line__r.Conversion_Factor__c >0 && qline.line.Supplier_Request_Line__r.Unit_of_measure_RFP__c != null && qline.line.Price__c != null)
                 qline.line.Price__c = qline.line.Price__c*qline.line.Supplier_Request_Line__r.Conversion_Factor__c;
          
            if(qline.line.Supplier_Request_Line__r.Conversion_Factor__c >0 && qline.line.Supplier_Request_Line__r.Unit_of_measure_RFP__c != null)
                qline.line.Quantity__c = qline.line.Quantity__c/qline.line.Supplier_Request_Line__r.Conversion_Factor__c;   
            
            qline.oldExpense=qline.line.Expense_Amount__c;
            if(qline.line.Expense_Amount__c!=null)
                total+=qline.line.Expense_Amount__c;
            if(qline.line.Id==null)
            {
                if(numberLine==0)
                {
                    AggregateResult[] groupedResults = [SELECT MAX(Line_Number__c)linenumber from Supplier_Quote_Line__c where Supplier_Quote__c=: quote.Id];
                    if(groupedResults.size()>0)
                    try{
                        numberLine=Integer.valueOf(groupedResults[0].get('linenumber'))+1;
                    }
                    catch(Exception e){}
                    if(numberLine==0)
                        numberLine=1;
                }
                qline.line.Line_Number__c=numberLine;
                numberLine=numberLine+1;
                qline.line.Supplier_Quote__c=quote.id;
                List<RecordType> myRecType = null;
                if(request.Supply_Project__r.Sealed__c == true)
                   myRecType =[Select Id From RecordType  Where DeveloperName = 'Supplier_Quote_Order_Line_Hidden'];
                else
                    myRecType =[Select Id From RecordType  Where DeveloperName = 'Supplier_Quote_Order_Line'];
                if(myRecType.size()>0)
                    qline.line.RecordTypeId=myRecType[0].Id;
                    
                toinsert.add(qline.line);
            }
            else
            {
                toupdate.add(qline.line);
            }
        }
        if(toinsert.size()>0)
            NEU_JE_RFP_quote_ranking.insertQuoteLines(toinsert);
        if(toupdate.size()>0)
            update toupdate;
            
        if(quote.Supply_Project__c == null)
        {
            quote.Supply_Project__c = request.Supply_Project__c;
            if(quote.Country_ofLoad__c == null)
                quote.Country_ofLoad__c = request.Country_of_Load__c;
            if(quote.State_of_Load__c == null)
                quote.State_of_Load__c = request.State_of_Load__c;
            if(quote.Place_of_Delivery__c == null)//puerto de carga
                quote.Place_of_Delivery__c = request.Port_Airport_of_Load__c;
            if(quote.Country_ofDischarge__c == null)
                quote.Country_ofDischarge__c = request.Supply_Project__r.Country_of_Discharge__c;
            if(quote.State_of_Discharge__c == null)
                quote.State_of_Discharge__c = request.Supply_Project__r.State_of_Discharge__c;
            if(quote.Place_of_Receipt__c == null)//puerto descarga
                quote.Place_of_Receipt__c = request.Supply_Project__r.Port_Airport_of_Discharge__c;
            if(quote.Country_ofLoad__c != null && quote.State_of_Load__c != null && quote.Place_of_Delivery__c != null && quote.Country_ofDischarge__c != null && quote.State_of_Discharge__c != null && quote.Place_of_Receipt__c != null)
            {
                List<Carrier_Line_Load_Point__c> lista_rutas = [select Id,Country_of_Discharge__c, Country_of_Load__c, State_of_Discharge__c, State_of_Load__c,
                Port_Airport_of_Discharge__c, Port_Airport_of_Load__c 
                from Carrier_Line_Load_Point__c where Country_of_Discharge__c =: quote.Country_ofDischarge__c and Country_of_Load__c =: quote.Country_ofLoad__c
                and State_of_Discharge__c =: quote.State_of_Discharge__c and State_of_Load__c =: quote.State_of_Load__c 
                and Port_Airport_of_Load__c=:quote.Place_of_Delivery__c and Port_Airport_of_Discharge__c=:quote.Place_of_Receipt__c];
                if(lista_rutas.size()>0)
                    quote.Route__c = lista_rutas[0].Id;
                else
                    quote.Route__c = null;
            }
           // update quote;
        }
        else
        {
            if(quote.Country_ofLoad__c == null)
                quote.Country_ofLoad__c = request.Country_of_Load__c;
            if(quote.State_of_Load__c == null)
                quote.State_of_Load__c = request.State_of_Load__c;
            if(quote.Place_of_Delivery__c == null)//puerto de carga
                quote.Place_of_Delivery__c = request.Port_Airport_of_Load__c;
            if(quote.Country_ofDischarge__c == null)
                quote.Country_ofDischarge__c = request.Supply_Project__r.Country_of_Discharge__c;
            if(quote.State_of_Discharge__c == null)
                quote.State_of_Discharge__c = request.Supply_Project__r.State_of_Discharge__c;
            if(quote.Place_of_Receipt__c == null)//puerto descarga
                quote.Place_of_Receipt__c = request.Supply_Project__r.Port_Airport_of_Discharge__c;
            if(quote.Country_ofLoad__c != null && quote.State_of_Load__c != null && quote.Place_of_Delivery__c != null && quote.Country_ofDischarge__c != null && quote.State_of_Discharge__c != null && quote.Place_of_Receipt__c != null)
            {
                List<Carrier_Line_Load_Point__c> lista_rutas = [select Id,Country_of_Discharge__c, Country_of_Load__c, State_of_Discharge__c, State_of_Load__c,
                Port_Airport_of_Discharge__c, Port_Airport_of_Load__c
                from Carrier_Line_Load_Point__c where Country_of_Discharge__c =: quote.Country_ofDischarge__c and Country_of_Load__c =: quote.Country_ofLoad__c 
                and State_of_Discharge__c =: quote.State_of_Discharge__c and State_of_Load__c =: quote.State_of_Load__c
                and Port_Airport_of_Load__c=:quote.Place_of_Delivery__c and Port_Airport_of_Discharge__c=:quote.Place_of_Receipt__c];
                if(lista_rutas.size()>0)
                    quote.Route__c = lista_rutas[0].Id;
                else
                    quote.Route__c = null;  
            }
            //update quote;
        }
        
        update quote;
        if(quote.Valid_for_Auction__c!=validforauction)
        {
            quote.Valid_for_Auction__c=validforauction;
            update quote;
        }
        List<Technical_Evaluation__c>etoinsert=new List<Technical_Evaluation__c>();
        List<Technical_Evaluation__c>etoupdate=new List<Technical_Evaluation__c>();
        List<Technical_Evaluation__c>etodelete=new List<Technical_Evaluation__c>();
        for(Supplier_Quote_Line_s qline:newitems)
        {
            if(String.isEmpty(qline.line.Expense_Concept__c))
                qline.line.Expense_Concept__c='   ';
            if(String.isEmpty(qline.line.Observations__c))
                qline.line.Observations__c='   ';
            if((qline.line.Id!=null)&&(qline.evaluationcriterias!=null))
            {
                Integer tc=0;
                for(Evaluation_Criteria_s c:qline.evaluationcriterias)
                {
                    Integer current=-1;
                    if(String.isNotEmpty(c.selected))
                        for(Integer counter=0;(counter<c.values.size())&&(counter<c.options.size());counter++)
                            if(c.options.get(counter).getValue()==c.selected)
                            {
                                current=counter;
                                break;
                            }
                    if(current==-1)
                    {
                        if(c.eval!=null)
                        {
                            etodelete.add(c.eval);
                            c.eval=null;
                        }
                    }
                    else
                    {
                        tc=tc+1;
                        String name=String.valueOf(tc);
                        while(name.length()<3)
                            name='0'+name;
                        if(c.eval!=null)
                        {
                            c.eval.Name=name;
                            c.eval.Option_Selected__c=c.options.get(current).getLabel();
                            c.eval.Score__c=c.values.get(current);
                            etoupdate.add(c.eval);
                        }
                        else
                        {
                            c.eval=new Technical_Evaluation__c();
                            c.eval.Evaluation_Criteria__c=c.Id;
                            c.eval.Supplier_Quote_Line__c=qline.line.Id;
                            c.eval.Name=name;
                            c.eval.Option_Selected__c=c.options.get(current).getLabel();
                            c.eval.Score__c=c.values.get(current);
                            etoinsert.add(c.eval);
                        }
                    }
                }
            }
        }
        if(etoinsert.size()>0)
            insert etoinsert;
        if(etoupdate.size()>0)
            update etoupdate;
        if(etodelete.size()>0)
            delete etodelete;
        if(validforauction)
            NEU_JE_RFP_quote_ranking.updateStartingBid(request.Supply_Project__c,total);
        error='';
        newitems=null;
        getitemstosuplay();
        return null;
    }
    
    public class Evaluation_Criteria_s
    {
        public String Id{get;set;}
        public String name{get;set;}
        public String description{get;set;}
        public List<SelectOption> options {get;set;}
        public List<Decimal> values{get;set;}
        public String selected{get;set;}
        public Technical_Evaluation__c eval{get;set;}
    }
    public class Supplier_Quote_Line_s
    {
        public Supplier_Quote_Line__c line{get;set;}
        public Decimal oldPrice;
        public Decimal oldExpense;
        public List<Evaluation_Criteria_s> evaluationcriterias {get;set;}
        public String moneda_selected {get;set;}
        public decimal target_price_mod {get;set;}
        public String quantity_request_line {get;set;}
        public Integer linenumber{get;set;}
    }
    
    
    public List<Supplier_Quote_Line_s>getitemstosuplay()
    {
        if((newitems==null)&&(request!=null))
        {
            List<Supplier_Quote_Line__c>myitems=null;
            List<Supplier_Quote__c> quotes=[select Id,
                                                        Incoterm__c,
                                                    //  CurrencyIsoCode,
                                                        Incoterm_Place__c,
                                                        Valid_Until__c,
                                                        Production_Time_Days__c,
                                                        Collection_Conditions__c,
                                                        Carton_Box_Suppliers__c,
                                                        Poligag_Suppliers__c,
                                                        Labels_Suppliers__c,
                                                        Pallets_Suppliers__c,
                                                        Supplier_Quote_Status__c,
                                                        Supply_Project__c,
                                                        Valid_for_Auction__c,
                                                        Total_Amount__c,
                                                        Total_Amount_Number__c,
                                                        Country_ofLoad__c,
                                                        State_of_Load__c,
                                                        MOQ__c,
                                                        Place_of_Delivery__c,
                                                        Country_ofDischarge__c,
                                                        State_of_Discharge__c,
                                                        Place_of_Receipt__c,
                                                        Route__c,
                                                        Supplier_Request_RFP__r.Estimated_Delivery_Date__c,
                                                        Supplier_Request_RFP__r.Date_Limit__c,
                                                        Supplier_Request_RFP__r.CartonBox_Document__c,
                                                        Supplier_Request_RFP__r.Labels_Document__c,
                                                        Supplier_Request_RFP__r.Pallets_Document__c,
                                                        Supplier_Request_RFP__r.Poligag_Document__c,
                                                        Supplier_Request_RFP__r.Document_1_Type__c,
                                                        Supplier_Request_RFP__r.Document_2_Type__c,
                                                        Supplier_Request_RFP__r.Document_3_Type__c,
                                                        Supplier_Request_RFP__r.Document_4_Type__c,
                                                        Supplier_Request_RFP__r.Document_5_Type__c,
                                                        Supplier_Request_RFP__r.Document_6_Type__c,
                                                        Supplier_Request_RFP__r.Document_7_Type__c,
                                                        Supplier_Request_RFP__r.Document_8_Type__c,
                                                        Supplier_Request_RFP__r.Document_9_Type__c,
                                                        Supplier_Request_RFP__r.Document_10_Type__c,
                                                        Supplier_Request_RFP__r.Supplier__r.Name,
                                                        CreatedById,
                                                        Supplier_Request_RFP__r.Auction_Minimum_Increase_Decrease__c
                                                        from Supplier_Quote__c where Supplier_Request_RFP__c=:request.Id];
            if(quotes.size()>0)
            {
                quote=quotes[0];
                string query_string_supplier_quote_line = ''; 
                query_string_supplier_quote_line +='select Id,'; 
                query_string_supplier_quote_line +='            Item_to_Supply__c,'; 
                query_string_supplier_quote_line +='            Item__c,'; 
                if(UserInfo.isMultiCurrencyOrganization()== true)
                    query_string_supplier_quote_line +='            CurrencyIsoCode,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Target_Price__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Show_Target_Price__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Unit_of_measure__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Unit_of_measure_RFP__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Item_Name__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Technical_Data__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Photo__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Technical_description__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Item_Code__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.HS_Code__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Quantity__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Item_Units_Packaging__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Partial_Quote__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Hide_Quantity__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Packaging_Description__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Packaging_Weight_kg__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Packaging_Gross_Weight_kg__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Packaging_Length_cm__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Packaging_Width_cm__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Packaging_Height_cm__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Packaging_Volume_m3__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Packaging_System__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Packaging_Image__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Sizes_Image__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Family_Name__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Conversion_Factor__c,'; 
                query_string_supplier_quote_line +='            Supplier_Request_Line__r.Subfamily_Name__c,'; 
                query_string_supplier_quote_line +='            Quantity__c,'; 
                query_string_supplier_quote_line +='            Price__c,'; 
                query_string_supplier_quote_line +='            Expense_Concept__c,'; 
                query_string_supplier_quote_line +='            Expense_Amount__c,'; 
                query_string_supplier_quote_line +='            Production_Time_Days__c,'; 
                query_string_supplier_quote_line +='            Observations__c,'; 
                query_string_supplier_quote_line +='            Packaging_Description__c,'; 
                query_string_supplier_quote_line +='            Packaging_Height_cm__c,'; 
                query_string_supplier_quote_line +='            Packaging_Length_cm__c,'; 
                query_string_supplier_quote_line +='            Packaging_Weight_kg__c,'; 
                query_string_supplier_quote_line +='            Packaging_Width_cm__c,'; 
                query_string_supplier_quote_line +='            Packaging_Gross_Weight_kg__c,'; 
                query_string_supplier_quote_line +='            Packaging_Quantity__c,'; 
                query_string_supplier_quote_line +='            Packaging_Volume_m3__c,'; 
                query_string_supplier_quote_line +='            Supplier_Item_Weight_kg__c,'; 
                query_string_supplier_quote_line +='            Item_Units_x_Packaging__c,'; 
                query_string_supplier_quote_line +='            Supplier_Total_Weight_kg__c,'; 
                query_string_supplier_quote_line +='            Supplier_Total_Volume_m3__c'; 
                query_string_supplier_quote_line +='            from Supplier_Quote_Line__c where Supplier_Request_RFP__c = \''+request.Id+'\''; 
                query_string_supplier_quote_line +='            order by Name';
               
                List<sObject> query_supplier_quote_line = Database.query(query_string_supplier_quote_line );
                myitems = query_supplier_quote_line; 
            }
            else
            {
                myitems=new List<Supplier_Quote_Line__c>();
                quote=new Supplier_Quote__c();
                quote.Supplier_Quote_Status__c='Draft';
                quote.Valid_for_Auction__c=false;
                quote.Supplier_Request_RFP__c=request.id;
                quote.Supply_Project__c=request.Supply_Project__c;
                 // -- mod
                quote.Place_of_Delivery__c = request.Port_Airport_of_Load__c;
                quote.Country_ofLoad__c = request.Country_of_Load__c;
                quote.State_of_Load__c = request.State_of_Load__c;
                
                quote.Customer__c=request.Customer__c;
                quote.Incoterm__c=request.Incoterm_Request__c;
                quote.Incoterm_Place__c=request.Incoterm_Place__c;
                quote.Place_of_Delivery__c = request.Port_Airport_of_Load__c;
                quote.Max_Deliveries__c = request.Max_Shipment__c;
                quote.Contract_Duration_months__c = request.Contract_Duration__c;
                NEU_CurrencyUtils.setCurrencyIsoCode(quote, NEU_CurrencyUtils.getCurrencyIsoCode(request));
                quote.Supplier__c=request.Supplier__c;
                List<RecordType> myRecType = null;
                if(request.Supply_Project__r.Sealed__c == true)
                   myRecType =[Select Id From RecordType  Where DeveloperName = 'Supplier_Hidden_Quote'];
                else
                    myRecType =[Select Id From RecordType  Where DeveloperName = 'Supplier_Quote'];
                if(myRecType.size()>0)
                    quote.RecordTypeId=myRecType[0].Id;
                
            }
            string query_string_supplier_request_line = '';
            List<Supplier_Request_Line__c>lines=null;
            
            query_string_supplier_request_line +='select     Item__c,';
            query_string_supplier_request_line +='                                                        Item_to_Supply__c,';
            query_string_supplier_request_line +='                                                        Target_Price__c,';
            query_string_supplier_request_line +='                                                        Show_Target_Price__c,';
            query_string_supplier_request_line +='                                                        Unit_of_measure__c,';
            query_string_supplier_request_line +='                                                        Item_Name__c,';
            query_string_supplier_request_line +='                                                        Technical_Data__c,';
            query_string_supplier_request_line +='                                                        Photo__c,';
            query_string_supplier_request_line +='                                                        Technical_description__c,';
            query_string_supplier_request_line +='                                                        Item_Code__c,';
            query_string_supplier_request_line +='                                                        HS_Code__c,';
            query_string_supplier_request_line +='                                                        Family__c,';
            if(UserInfo.isMultiCurrencyOrganization()== true)
                query_string_supplier_request_line +='                                                        CurrencyIsoCode,';
            query_string_supplier_request_line +='                                                        Family_Name__c,';
            query_string_supplier_request_line +='                                                        Subfamily__c,';
            query_string_supplier_request_line +='                                                        Subfamily_Name__c,';
            query_string_supplier_request_line +='                                                        Item_Units_Packaging__c,';
            query_string_supplier_request_line +='                                                        Packaging_Description__c,';
            //query_string_supplier_request_line +='                                                        Item_to_Supply__r.Fee_to_Supply__c,';
            query_string_supplier_request_line +='                                                        Packaging_Weight_kg__c,';
            query_string_supplier_request_line +='                                                        Partial_Quote__c,';
            query_string_supplier_request_line +='                                                        Hide_Quantity__c,';
            query_string_supplier_request_line +='                                                        Packaging_Gross_Weight_kg__c,';
            query_string_supplier_request_line +='                                                        Unit_of_measure_RFP__c,';
            query_string_supplier_request_line +='                                                        Packaging_Length_cm__c,';
            query_string_supplier_request_line +='                                                        Packaging_Width_cm__c,';
            query_string_supplier_request_line +='                                                        Packaging_Height_cm__c,';
            query_string_supplier_request_line +='                                                        Item_to_Supply__r.Target_Price__c,';
            query_string_supplier_request_line +='                                                        Item_to_Supply__r.Name,';
            query_string_supplier_request_line +='                                                        Packaging_Volume_m3__c,';
            query_string_supplier_request_line +='                                                        Packaging_System__c,';
            query_string_supplier_request_line +='                                                        Conversion_Factor__c,';
            query_string_supplier_request_line +='                                                        Packaging_Image__c,';
            query_string_supplier_request_line +='                                                        Sizes_Image__c,';
            query_string_supplier_request_line +='                                                        Quantity__c';
            query_string_supplier_request_line +='                                                        from Supplier_Request_Line__c where Supplier_Request_RFP__c = \''+request.Id+'\'';
            query_string_supplier_request_line +='     order by Name';
                                                                    
                                                                    
            List<sObject> query_supplier_request_line = Database.query(query_string_supplier_request_line );
            lines = query_supplier_request_line;
                                                                     
            Set<Id>items=new Set<Id>();
            for(Supplier_Request_Line__c line:lines)
            {
                if(line.Conversion_Factor__c != null)
                    if(line.Conversion_Factor__c != 0 && NEU_Utils.safeDecimal(line.Target_Price__c)!=0)
                         line.Target_Price__c = line.Target_Price__c/line.Conversion_Factor__c;
                      
                Boolean lineQuoted=false;
                for(Supplier_Quote_Line__c qline:myitems)
                    if(qline.Item_to_Supply__c==line.Item_to_Supply__c)
                    {
                        items.add(qline.Item__c);
                        
                        if(qline.Supplier_Request_Line__r.Conversion_Factor__c != null)
                            if(qline.Supplier_Request_Line__r.Conversion_Factor__c!=0)
                                qline.Quantity__c =  qline.Quantity__c*qline.Supplier_Request_Line__r.Conversion_Factor__c;
                        
                        if(qline.Supplier_Request_Line__r.Conversion_Factor__c != null)
                        if(qline.Supplier_Request_Line__r.Conversion_Factor__c > 0 && qline.Price__c != null)
                            qline.Price__c = qline.Price__c/qline.Supplier_Request_Line__r.Conversion_Factor__c;
                        qline.Item_to_Supply__r = line.Item_to_Supply__r;
                        
                        lineQuoted=true;
                        break;
                    }
                if(!lineQuoted)
                {
                    Supplier_Quote_Line__c newline=new Supplier_Quote_Line__c();
                    newline.Supplier_Quote__c=quote.id;
                    newline.Supplier_Quote__r=quote;
                    
                    if(line.Hide_Quantity__c==false)
                    {
                        if(line.Conversion_Factor__c != null)
                        {
                          if(line.Conversion_Factor__c != 0 && line.Unit_of_measure_RFP__c != null && line.Quantity__c!=null)
                            newline.Quantity__c=line.Quantity__c*line.Conversion_Factor__c;
                          else
                            newline.Quantity__c=line.Quantity__c;
                        } 
                        else
                         newline.Quantity__c=line.Quantity__c;
                    }
                     else
                       newline.Quantity__c=null;
                     
                    
                    newline.Item_to_Supply__c=line.Item_to_Supply__c;
                    
                    if(line.Conversion_Factor__c != null)
                        if(line.Conversion_Factor__c != 0)
                            newline.Item_to_Supply__r = line.Item_to_Supply__r;  
                        
                    newline.Item__c=line.Item__c;
                    items.add(newline.Item__c);
                    newline.Family__c=line.Family__c;
                    newline.Subfamily__c=line.Subfamily__c;
                    newline.Supplier_Request_RFP__c=request.id;
                    newline.Supplier_Request_Line__c=line.Id;
                    newline.Supplier_Request_Line__r=line;
                   
                   // if(line.Item_to_Supply__r.Fee_to_Supply__c != null)
                      //  newline.Fee_to_Supply__c = line.Item_to_Supply__r.Fee_to_Supply__c;
                    NEU_CurrencyUtils.setCurrencyIsoCode(newline, NEU_CurrencyUtils.getCurrencyIsoCode(line));
                    myitems.add(newline);
                }
            }
            List<Evaluation_Criteria__c>crits=[select Id,Name,Evaluation_Description__c,Option_1__c,Score_Option_1__c,Option_2__c,Score_Option_2__c,Option_3__c,Score_Option_3__c,Option_4__c,Score_Option_4__c,Option_5__c,Score_Option_5__c,Item__c from Evaluation_Criteria__c where Item__c IN :items];
            List<Technical_Evaluation__c>responses=[select Id,Name,Option_Selected__c,Score__c,Evaluation_Criteria__c,Supplier_Quote_Line__c from Technical_Evaluation__c where Evaluation_Criteria__c IN :crits];

            newitems=new List<Supplier_Quote_Line_s>();
            Integer counter=1;
            for(Supplier_Quote_Line__c qline:myitems)
            {
                Supplier_Quote_Line_s newline=new Supplier_Quote_Line_s();
                newline.linenumber=counter++;
                newline.line=qline;
                
                //-------------------------- -------------------------------------------------------------
                 if(qline.Supplier_Request_Line__r.Conversion_Factor__c != null)
                 {
                   if(qline.Supplier_Request_Line__r.Conversion_Factor__c != 0 && qline.Supplier_Request_Line__r.Target_Price__c != null) 
                   {
                     newline.target_price_mod = qline.Supplier_Request_Line__r.Target_Price__c.divide(qline.Supplier_Request_Line__r.Conversion_Factor__c,2);
                     
                   }
                   else
                     newline.target_price_mod = qline.Supplier_Request_Line__r.Target_Price__c;
                 }
                 else
                   newline.target_price_mod = qline.Supplier_Request_Line__r.Target_Price__c;
                   
                
                if(qline.Supplier_Request_Line__r.Conversion_Factor__c != null)
                {
                  if(qline.Supplier_Request_Line__r.Conversion_Factor__c !=0 && qline.Price__c > 0)
                  {
                    newline.oldPrice = qline.Price__c*qline.Supplier_Request_Line__r.Conversion_Factor__c;
                  }
                   else
                     newline.oldPrice=qline.Price__c;
                }
                else
                  newline.oldPrice=qline.Price__c;
                  
                
                newline.oldExpense=qline.Expense_Amount__c;
                
                if(NEU_Utils.safeDecimal(qline.Supplier_Request_Line__r.Conversion_Factor__c)!=0)
                   newline.quantity_request_line = (NEU_Utils.safeDecimal(qline.Supplier_Request_Line__r.Quantity__c)*qline.Supplier_Request_Line__r.Conversion_Factor__c).format();
                else
                   newline.quantity_request_line = NEU_Utils.safeDecimal(qline.Supplier_Request_Line__r.Quantity__c).format();
                  
                newline.moneda_selected = NEU_CurrencyUtils.getCurrencyIsoCode(qline);
                if(String.isEmpty(newline.line.Expense_Concept__c))
                    newline.line.Expense_Concept__c='   ';
                if(String.isEmpty(newline.line.Observations__c))
                    newline.line.Observations__c='   ';
                for(Evaluation_Criteria__c c:crits)
                {
                    if(c.Item__c==qline.Item__c)
                    {
                        if(newline.evaluationcriterias==null)
                            newline.evaluationcriterias=new List<Evaluation_Criteria_s>();
                        Evaluation_Criteria_s myc=new Evaluation_Criteria_s();
                        myc.Id=c.Id;
                        myc.Name=c.Name;
                        myc.description=c.Evaluation_Description__c;
                        String selectedText=null;
                        if(newline.line.Id!=null)
                        {
                            for(Technical_Evaluation__c response:responses)
                                if((response.Evaluation_Criteria__c==c.Id)&&(response.Supplier_Quote_Line__c==newline.line.Id))
                                {
                                    selectedText=response.Option_Selected__c;
                                    myc.eval=response;
                                }
                        }

                        myc.options = new List<SelectOption>();
                        myc.values = new List<Decimal>();
                        if(c.Option_1__c!=null)
                        {
                            myc.options.add(new SelectOption('1',c.Option_1__c));
                            myc.values.add(c.Score_Option_1__c);
                            if(c.Option_1__c==selectedText)
                                myc.selected='1';
                        }
                        if(c.Option_2__c!=null)
                        {
                            myc.options.add(new SelectOption('2',c.Option_2__c));
                            myc.values.add(c.Score_Option_2__c);
                            if(c.Option_2__c==selectedText)
                                myc.selected='2';
                        }
                        if(c.Option_3__c!=null)
                        {
                            myc.options.add(new SelectOption('3',c.Option_3__c));
                            myc.values.add(c.Score_Option_3__c);
                            if(c.Option_3__c==selectedText)
                                myc.selected='3';
                        }
                        if(c.Option_4__c!=null)
                        {
                            myc.options.add(new SelectOption('4',c.Option_4__c));
                            myc.values.add(c.Score_Option_4__c);
                            if(c.Option_4__c==selectedText)
                                myc.selected='4';
                        }
                        if(c.Option_5__c!=null)
                        {
                            myc.options.add(new SelectOption('5',c.Option_5__c));
                            myc.values.add(c.Score_Option_5__c);
                            if(c.Option_5__c==selectedText)
                                myc.selected='5';
                        }
                        if(myc.selected!=null)
                            myc.options.add(new SelectOption('none','(none)'));
                        newline.evaluationcriterias.add(myc);
                    }
                }
                newitems.add(newline);
            }
        }
        return newitems;
    }
    
}