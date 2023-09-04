public with sharing class NEU_Customers_Community_Login 
{
    public String username {get; set;}
    public String password {get; set;}
    public String lang {get;set;}
    public String url_bg {get;set;}
    public String resultado {get;set;}   
    
    public pageReference select_language()
    {
         /** LOGIN FOR APP **/
        if(Apexpages.currentPage().getParameters().get('un') != null)
        {
            PageReference redirect_error = new PageReference('/customers/NEU_Customers_Community_Login');  
            redirect_error.getParameters().put('error','true');
            String startUrl = System.currentPageReference().getParameters().get('startURL') != null ? System.currentPageReference().getParameters().get('startURL') : '/s/';        	
        	Blob response = EncodingUtil.base64Decode(EncodingUtil.urlDecode(Apexpages.currentPage().getParameters().get('un'),'UTF-8'));
            String[] credentials = response.toString().split('¡AppXamarin!');

            if(credentials.size() == 2)
            {                
                PageReference new_redirect = new PageReference('/s/');
                
                new_redirect = Site.login(credentials[0],credentials[1],startUrl);
                
                if(new_redirect != null)
                {
                    return new_redirect;
                }    
                else
                {
                    resultado = 'Insert your password. User: '+credentials[0]+', pass'+credentials[1]+', startUrl:'+startUrl;                  
                    return redirect_error;
                }
            }
            else
                return redirect_error;
        }
        
        if(Apexpages.currentPage().getParameters().get('un') != null) {
            Blob response = EncodingUtil.base64Decode(Apexpages.currentPage().getParameters().get('un'));
            String credentials = response.toString();
        }
        
        lang = 'es';
        
        if(Apexpages.currentPage().getParameters().get('lang') != null) {
            if(Apexpages.currentPage().getParameters().get('lang') == 'es') { lang = 'es'; }
            else { lang = 'en'; }
        }
        
        return null;
    }

    public pageReference login() {
        
        /** LOGIN FOR WEB **/
        if(username != null && username != '') {
            if(password != null && password != '') {
                return  Site.login(username,password,'/s/');           
            } else { 
                resultado = 'Insert your password.';                  
                return null;
            }
        } else { 
            resultado = 'Insert your user.'; 
            return null; 
        }    
    }//fin metodo
}