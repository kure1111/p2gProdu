public with sharing class NEU_First_Steps {
    
    public void update_transport_id()
    {
//                String toolingendpoint = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/services/data/v31.0/tooling/';
                String toolingendpoint = 'callout:Self/services/data/v31.0/tooling/';

                HttpRequest req = new HttpRequest();
//                req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
//                req.setHeader('Content-Type', 'application/json');
                String endpoint = toolingendpoint+'query/?q=select+id+from+CustomObject+where+DeveloperName%3D%27Transport_Packaging_Data%27';
                req.setEndpoint(endpoint);
                req.setMethod('GET');
                Http h = new Http();
                String result;
                if (!Test.isRunningTest())
                {
                    HttpResponse res = h.send(req);
                    result=res.getBody();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'First call result='+res.getStatusCode()));
                }
                else
                    result='..."Id":"123456789012345678"';
                result=result.substring(result.indexOf('"Id":"')+6);
                result=result.substring(0,result.indexOf('"'));

                req = new HttpRequest();
                //req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
                //req.setHeader('Content-Type', 'application/json');
                endpoint = toolingendpoint+'query/?q=select+id+from+CustomField+where+DeveloperName%3D%27Shipment%27+and+TableEnumOrId%3D%27'+EncodingUtil.urlEncode(result,'UTF-8')+'%27';
                req.setEndpoint(endpoint);
                req.setMethod('GET');
                h = new Http();
                if (!Test.isRunningTest())
                {
                    HttpResponse res = h.send(req);
                    result=res.getBody();
                }
                else
                    result='..."Id":"123456789012345678"';
                result=result.substring(result.indexOf('"Id":"')+6);
                result=result.substring(0,result.indexOf('"'));
                if(result.length()==18)
                    result=result.substring(0,15);
                if(result.length()==15)
                {
                    CSH_Shipment__c ssr = CSH_Shipment__c.getOrgDefaults();
                    if(ssr==null)
                        ssr=new CSH_Shipment__c();
                    ssr.Transport_Packaging_Data_Lookup_Id__c=result;
                        upsert ssr;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Transport Packaging Data Lookup Id updated. Value='+result));
                    return;
                }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Transport Packaging Data Lookup Id not updated'));
    }

    public void insert_countries()
    {
        List<Country__c> lista_country = new List<Country__c>();
        List<Country__c> query_countries = [select Id, Name, ISO_Code__c, Region__c, ISO_Code_2c__c   from Country__c];
        Map<string,Country__c > map_countries = new Map<string,Country__c>();
        for(Country__c co: query_countries )
        {
            map_countries.put(co.ISO_Code__c, co);
        }
        Country__c nuevo_country = new Country__c();
        
        nuevo_country = new Country__c(Name='Mayotte',Region__c='Africa',ISO_Code__c='MYT', ISO_Code_2c__c = 'YT'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Ivory Coast',Region__c='Africa',ISO_Code__c='CIV', ISO_Code_2c__c = 'CI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Spain',Region__c='Mediterranean',ISO_Code__c='ESP', ISO_Code_2c__c = ''); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Cuba',Region__c='Caribbean',ISO_Code__c='CUB', ISO_Code_2c__c = 'CU'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Cyprus',Region__c='Mediterranean',ISO_Code__c='CYP', ISO_Code_2c__c = 'CY'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Czech Republic',Region__c='Central and North Europe',ISO_Code__c='CZE', ISO_Code_2c__c = 'CZ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Denmark',Region__c='Central and North Europe',ISO_Code__c='DNK', ISO_Code_2c__c = 'DK'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Republic of Djibouti',Region__c='Africa',ISO_Code__c='DJI', ISO_Code_2c__c = 'DJ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Dominica',Region__c='Caribbean',ISO_Code__c='DMA', ISO_Code_2c__c = 'DM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Dominican Republic',Region__c='Caribbean',ISO_Code__c='DOM', ISO_Code_2c__c = 'DO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Timor-Leste',Region__c='Asia',ISO_Code__c='TMP', ISO_Code_2c__c = ''); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Ecuador',Region__c='South America',ISO_Code__c='ECU', ISO_Code_2c__c = 'EC'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Egypt',Region__c='Africa',ISO_Code__c='EGY', ISO_Code_2c__c = 'EG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Croatia',Region__c='Central and North Europe',ISO_Code__c='HRV', ISO_Code_2c__c = 'HR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='El Salvador',Region__c='Central America',ISO_Code__c='SLV', ISO_Code_2c__c = 'SV'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Guine',Region__c='Africa',ISO_Code__c='GNQ', ISO_Code_2c__c = 'GQ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Eritrea',Region__c='Africa',ISO_Code__c='ERI', ISO_Code_2c__c = 'ER'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Estonia',Region__c='Central and North Europe',ISO_Code__c='EST', ISO_Code_2c__c = 'EE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Ethiopia',Region__c='Africa',ISO_Code__c='ETH', ISO_Code_2c__c = 'ET'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Falkland Islands (Malvinas)',Region__c='South America',ISO_Code__c='FLK', ISO_Code_2c__c = 'FK'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Faroe Islands',Region__c='Central and North Europe',ISO_Code__c='FRO', ISO_Code_2c__c = 'FO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Fiji',Region__c='Australia/Oceania',ISO_Code__c='FJI', ISO_Code_2c__c = 'FJ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Finland',Region__c='Central and North Europe',ISO_Code__c='FIN', ISO_Code_2c__c = 'FI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='France',Region__c='Central and North Europe',ISO_Code__c='FRA', ISO_Code_2c__c = 'FR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='French Guiana',Region__c='South America',ISO_Code__c='GUF', ISO_Code_2c__c = 'GF'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='French Polynesia',Region__c='Australia/Oceania',ISO_Code__c='PYF', ISO_Code_2c__c = 'PF'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Gabon',Region__c='Africa',ISO_Code__c='GAB', ISO_Code_2c__c = 'GA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Azerbaijan',Region__c='Asia',ISO_Code__c='AZE', ISO_Code_2c__c = 'AZ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Bahamas',Region__c='Caribbean',ISO_Code__c='BHS', ISO_Code_2c__c = 'BS'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Kingdom of Bahrain',Region__c='Middle East',ISO_Code__c='BHR', ISO_Code_2c__c = 'BH'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Bangladesh',Region__c='Asia',ISO_Code__c='BGD', ISO_Code_2c__c = 'BD'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Barbados',Region__c='Caribbean',ISO_Code__c='BRB', ISO_Code_2c__c = 'BB'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Japan',Region__c='Asia',ISO_Code__c='JPN', ISO_Code_2c__c = 'JP'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Jersey',Region__c='Central and North Europe',ISO_Code__c='JEY', ISO_Code_2c__c = 'JE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Jordan',Region__c='Middle East',ISO_Code__c='JOR', ISO_Code_2c__c = 'JO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Kazakhstan',Region__c='Asia',ISO_Code__c='KAZ', ISO_Code_2c__c = 'KZ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Kenya',Region__c='Africa',ISO_Code__c='KEN', ISO_Code_2c__c = 'KE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Kiribati',Region__c='Australia/Oceania',ISO_Code__c='KIR', ISO_Code_2c__c = 'KI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Korea',Region__c='Asia',ISO_Code__c='PRK', ISO_Code_2c__c = 'KP'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Kuwait',Region__c='Middle East',ISO_Code__c='KWT', ISO_Code_2c__c = 'KW'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Kyrgyzstan',Region__c='Asia',ISO_Code__c='KGZ', ISO_Code_2c__c = 'KG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Laos',Region__c='Asia',ISO_Code__c='LAO', ISO_Code_2c__c = 'LA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Latvia',Region__c='Central and North Europe',ISO_Code__c='LVA', ISO_Code_2c__c = 'LV'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Lebanon',Region__c='Middle East',ISO_Code__c='LBN', ISO_Code_2c__c = 'LB'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Lesotho',Region__c='Africa',ISO_Code__c='LSO', ISO_Code_2c__c = 'LS'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Liberia',Region__c='Africa',ISO_Code__c='LBR', ISO_Code_2c__c = 'LR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Libya',Region__c='Africa',ISO_Code__c='LBY', ISO_Code_2c__c = 'LY'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Liechtenstein',Region__c='Central and North Europe',ISO_Code__c='LIE', ISO_Code_2c__c = 'LI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Lithuania',Region__c='Central and North Europe',ISO_Code__c='LTU', ISO_Code_2c__c = 'LT'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Luxembourg',Region__c='Central and North Europe',ISO_Code__c='LUX', ISO_Code_2c__c = 'LU'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Peninsula de Macau',Region__c='Asia',ISO_Code__c='MAC', ISO_Code_2c__c = 'MO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Macedonia',Region__c='Central and North Europe',ISO_Code__c='MKD', ISO_Code_2c__c = 'MK'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Central African Republic',Region__c='Africa',ISO_Code__c='CAF', ISO_Code_2c__c = 'CF'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Chad',Region__c='Africa',ISO_Code__c='TCD', ISO_Code_2c__c = 'TD'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Chile',Region__c='South America',ISO_Code__c='CHL', ISO_Code_2c__c = 'CL'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='China',Region__c='Asia',ISO_Code__c='CHN', ISO_Code_2c__c = 'CN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Cocos (Keeling) Islands',Region__c='Australia/Oceania',ISO_Code__c='CCK', ISO_Code_2c__c = 'CC'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Cayman Islands',Region__c='Caribbean',ISO_Code__c='CYM', ISO_Code_2c__c = 'KY'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Colombia',Region__c='South America',ISO_Code__c='COL', ISO_Code_2c__c = 'CO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Comoros',Region__c='Africa',ISO_Code__c='COM', ISO_Code_2c__c = 'KM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Republic of the Congo',Region__c='Africa',ISO_Code__c='COG', ISO_Code_2c__c = 'CG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Democratic Republic of the Congo',Region__c='Africa',ISO_Code__c='COD', ISO_Code_2c__c = 'CD'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Cook Islands',Region__c='Australia/Oceania',ISO_Code__c='COK', ISO_Code_2c__c = 'CK'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Costa Rica',Region__c='Central America',ISO_Code__c='CRI', ISO_Code_2c__c = 'CR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Cote d Ivoire',Region__c='Africa',ISO_Code__c='CIV', ISO_Code_2c__c = 'CI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Myanmar',Region__c='Asia',ISO_Code__c='MMR', ISO_Code_2c__c = 'MM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Namibia',Region__c='Africa',ISO_Code__c='NAM', ISO_Code_2c__c = 'NA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Nauru',Region__c='Australia/Oceania',ISO_Code__c='NRU', ISO_Code_2c__c = 'NR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Nepal',Region__c='Asia',ISO_Code__c='NPL', ISO_Code_2c__c = 'NP'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Netherlands',Region__c='Central and North Europe',ISO_Code__c='NLD', ISO_Code_2c__c = 'NL'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Netherland Antilles',Region__c='Caribbean',ISO_Code__c='ANT', ISO_Code_2c__c = 'AN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='New Caledonia',Region__c='Australia/Oceania',ISO_Code__c='NCL', ISO_Code_2c__c = 'NC'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='New Zealand',Region__c='Australia/Oceania',ISO_Code__c='NZL', ISO_Code_2c__c = 'NZ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Nicaragua',Region__c='Central America',ISO_Code__c='NIC', ISO_Code_2c__c = 'NI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Gambia',Region__c='Africa',ISO_Code__c='GMB', ISO_Code_2c__c = 'GM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Georgia',Region__c='Central and North Europe',ISO_Code__c='GEO', ISO_Code_2c__c = 'GE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Germany',Region__c='Central and North Europe',ISO_Code__c='DEU', ISO_Code_2c__c = 'DE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Ghana',Region__c='Africa',ISO_Code__c='GHA', ISO_Code_2c__c = 'GH'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Gibraltar',Region__c='Mediterranean',ISO_Code__c='GIB', ISO_Code_2c__c = 'GI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Greece',Region__c='Mediterranean',ISO_Code__c='GRC', ISO_Code_2c__c = 'GR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Greenland',Region__c='Central and North Europe',ISO_Code__c='GRL', ISO_Code_2c__c = 'GL'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Grenada',Region__c='Caribbean',ISO_Code__c='GRD', ISO_Code_2c__c = 'GD'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Guadaloupe',Region__c='Caribbean',ISO_Code__c='GLP', ISO_Code_2c__c = 'GP'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Guam Island',Region__c='Asia',ISO_Code__c='GUM', ISO_Code_2c__c = 'GU'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Guatemala',Region__c='Central America',ISO_Code__c='GTM', ISO_Code_2c__c = 'GT'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Guernsey',Region__c='Central and North Europe',ISO_Code__c='GGY', ISO_Code_2c__c = 'GG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Guinea',Region__c='Africa',ISO_Code__c='GIN', ISO_Code_2c__c = 'GN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Guinea-Bissau',Region__c='Africa',ISO_Code__c='GNB', ISO_Code_2c__c = 'GW'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Guyana',Region__c='South America',ISO_Code__c='GUY', ISO_Code_2c__c = 'GY'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Haiti',Region__c='Caribbean',ISO_Code__c='HTI', ISO_Code_2c__c = 'HT'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Heard And McDonald Islands',Region__c='Australia/Oceania',ISO_Code__c='HMD', ISO_Code_2c__c = 'HM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Honduras',Region__c='Central America',ISO_Code__c='HND', ISO_Code_2c__c = 'HN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Hong Kong',Region__c='Asia',ISO_Code__c='HKG', ISO_Code_2c__c = 'HK'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Hungary',Region__c='Central and North Europe',ISO_Code__c='HUN', ISO_Code_2c__c = 'HU'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Iceland',Region__c='Central and North Europe',ISO_Code__c='ISL', ISO_Code_2c__c = 'IS'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Papua New Guinea',Region__c='Australia/Oceania',ISO_Code__c='PNG', ISO_Code_2c__c = 'PG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Paraguay',Region__c='South America',ISO_Code__c='PRY', ISO_Code_2c__c = 'PY'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Peru',Region__c='South America',ISO_Code__c='PER', ISO_Code_2c__c = 'PE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Philippines',Region__c='Asia',ISO_Code__c='PHL', ISO_Code_2c__c = 'PH'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Pitcairn',Region__c='Australia/Oceania',ISO_Code__c='PCN', ISO_Code_2c__c = 'PN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Poland',Region__c='Central and North Europe',ISO_Code__c='POL', ISO_Code_2c__c = 'PL'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Portugal',Region__c='Mediterranean',ISO_Code__c='PRT', ISO_Code_2c__c = 'PT'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Puerto Rico',Region__c='Caribbean',ISO_Code__c='PRI', ISO_Code_2c__c = 'PR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Qatar',Region__c='Middle East',ISO_Code__c='QAT', ISO_Code_2c__c = 'QA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Panama',Region__c='Central America',ISO_Code__c='PAN', ISO_Code_2c__c = 'PA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Reunion Island',Region__c='Africa',ISO_Code__c='REU', ISO_Code_2c__c = 'RE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Romania',Region__c='Central and North Europe',ISO_Code__c='ROU', ISO_Code_2c__c = 'RO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Russia',Region__c='Central and North Europe',ISO_Code__c='RUS', ISO_Code_2c__c = 'RU'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Rwanda',Region__c='Africa',ISO_Code__c='RWA', ISO_Code_2c__c = 'RW'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Saint Kitts And Nevis',Region__c='Caribbean',ISO_Code__c='KNA', ISO_Code_2c__c = 'KN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='St. Lucia',Region__c='Caribbean',ISO_Code__c='LCA', ISO_Code_2c__c = 'LC'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='St. Vincent & the Grenadines',Region__c='Caribbean',ISO_Code__c='VCT', ISO_Code_2c__c = 'VC'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Samoa',Region__c='Australia/Oceania',ISO_Code__c='WSM', ISO_Code_2c__c = 'WS'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='San Marino',Region__c='Mediterranean',ISO_Code__c='SMR', ISO_Code_2c__c = 'SM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Sao Tome And Principe',Region__c='Africa',ISO_Code__c='STP', ISO_Code_2c__c = 'ST'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Saudi Arabia',Region__c='Middle East',ISO_Code__c='SAU', ISO_Code_2c__c = 'SA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Vatican City State (Holy See)',Region__c='Mediterranean',ISO_Code__c='VAT', ISO_Code_2c__c = 'VA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Venezuela',Region__c='South America',ISO_Code__c='VEN', ISO_Code_2c__c = 'VE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Vietnam',Region__c='Asia',ISO_Code__c='VNM', ISO_Code_2c__c = 'VN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='British Virgin Islands',Region__c='Caribbean',ISO_Code__c='VGB', ISO_Code_2c__c = 'VG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='U.S. Virgin Islands',Region__c='Caribbean',ISO_Code__c='VIR', ISO_Code_2c__c = 'VI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Wallis & Futuna Islands',Region__c='Australia/Oceania',ISO_Code__c='WLF', ISO_Code_2c__c = 'WF'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Western Sahara',Region__c='Africa',ISO_Code__c='ESH', ISO_Code_2c__c = 'EH'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Yemen',Region__c='Middle East',ISO_Code__c='YEM', ISO_Code_2c__c = 'YE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Zambia',Region__c='Africa',ISO_Code__c='ZMB', ISO_Code_2c__c = 'ZM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Zimbabwe',Region__c='Africa',ISO_Code__c='ZWE', ISO_Code_2c__c = 'ZW'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Seychelles',Region__c='Africa',ISO_Code__c='SYC', ISO_Code_2c__c = 'SC'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Sierra Leone',Region__c='Africa',ISO_Code__c='SLE', ISO_Code_2c__c = 'SL'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Republic of Singapore',Region__c='Asia',ISO_Code__c='SGP', ISO_Code_2c__c = 'SG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Slovakia',Region__c='Central and North Europe',ISO_Code__c='SVK', ISO_Code_2c__c = 'SK'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Slovenia',Region__c='Central and North Europe',ISO_Code__c='SVN', ISO_Code_2c__c = 'SI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Solomon Islands',Region__c='Australia/Oceania',ISO_Code__c='SLB', ISO_Code_2c__c = 'SB'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Somalia',Region__c='Africa',ISO_Code__c='SOM', ISO_Code_2c__c = 'SO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='South Africa',Region__c='Africa',ISO_Code__c='ZAF', ISO_Code_2c__c = 'ZA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='South Korea',Region__c='Asia',ISO_Code__c='KOR', ISO_Code_2c__c = 'KR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Serbia',Region__c='Central and North Europe',ISO_Code__c='SRB', ISO_Code_2c__c = 'RS'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Sri Lanka',Region__c='Asia',ISO_Code__c='LKA', ISO_Code_2c__c = 'LK'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='St Helena',Region__c='Africa',ISO_Code__c='SHN', ISO_Code_2c__c = 'SH'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='St Pierre And Miquelon',Region__c='North America',ISO_Code__c='SPM', ISO_Code_2c__c = 'PM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Sudan',Region__c='Africa',ISO_Code__c='SDN', ISO_Code_2c__c = 'SD'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Suriname',Region__c='South America',ISO_Code__c='SUR', ISO_Code_2c__c = 'SR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Svalbard And Jan Mayen Islands',Region__c='Central and North Europe',ISO_Code__c='SJM', ISO_Code_2c__c = 'SJ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Swaziland',Region__c='Africa',ISO_Code__c='SWZ', ISO_Code_2c__c = 'SZ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Sweden',Region__c='Central and North Europe',ISO_Code__c='SWE', ISO_Code_2c__c = 'SE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Palestine',Region__c='Middle East',ISO_Code__c='PSE', ISO_Code_2c__c = 'PS'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Senegal',Region__c='Africa',ISO_Code__c='SEN', ISO_Code_2c__c = 'SN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Niger',Region__c='Africa',ISO_Code__c='NER', ISO_Code_2c__c = 'NE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Nigeria',Region__c='Africa',ISO_Code__c='NGA', ISO_Code_2c__c = 'NG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Niue',Region__c='Australia/Oceania',ISO_Code__c='NIU', ISO_Code_2c__c = 'NU'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Territory of Norfolk Island',Region__c='Australia/Oceania',ISO_Code__c='NFK', ISO_Code_2c__c = 'NF'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Northern Mariana Islands',Region__c='Australia/Oceania',ISO_Code__c='MNP', ISO_Code_2c__c = 'MP'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Norway',Region__c='Central and North Europe',ISO_Code__c='NOR', ISO_Code_2c__c = 'NO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Oman',Region__c='Middle East',ISO_Code__c='OMN', ISO_Code_2c__c = 'OM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Pakistan',Region__c='Middle East',ISO_Code__c='PAK', ISO_Code_2c__c = 'PK'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Palau',Region__c='Australia/Oceania',ISO_Code__c='PLW', ISO_Code_2c__c = 'PW'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Brazil',Region__c='South America',ISO_Code__c='BRA', ISO_Code_2c__c = 'BR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Brunei Darussalam',Region__c='Asia',ISO_Code__c='BRN', ISO_Code_2c__c = 'BN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Bulgaria',Region__c='Mediterranean',ISO_Code__c='BGR', ISO_Code_2c__c = 'BG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Burkina Faso',Region__c='Africa',ISO_Code__c='BFA', ISO_Code_2c__c = 'BF'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Bouvet Island',Region__c='Central and North Europe',ISO_Code__c='BVT', ISO_Code_2c__c = 'BV'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Burundi',Region__c='Africa',ISO_Code__c='BDI', ISO_Code_2c__c = 'BI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Cambodia',Region__c='Asia',ISO_Code__c='KHM', ISO_Code_2c__c = 'KH'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Cameroon',Region__c='Africa',ISO_Code__c='CMR', ISO_Code_2c__c = 'CM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Canada',Region__c='North America',ISO_Code__c='CAN', ISO_Code_2c__c = 'CA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Cape Verde Islands',Region__c='Africa',ISO_Code__c='CPV', ISO_Code_2c__c = 'CV'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Albania',Region__c='Central and North Europe',ISO_Code__c='ALB', ISO_Code_2c__c = 'AL'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Algeria',Region__c='Africa',ISO_Code__c='DZA', ISO_Code_2c__c = 'DZ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='American Samoa',Region__c='Australia/Oceania',ISO_Code__c='ASM', ISO_Code_2c__c = 'AS'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Andorra',Region__c='Mediterranean',ISO_Code__c='AND', ISO_Code_2c__c = 'AD'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Angola',Region__c='Africa',ISO_Code__c='AGO', ISO_Code_2c__c = 'AO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Anguilla',Region__c='Caribbean',ISO_Code__c='AIA', ISO_Code_2c__c = 'AI'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Antigua & Barbuda',Region__c='Caribbean',ISO_Code__c='ATG', ISO_Code_2c__c = 'AG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Argentina',Region__c='South America',ISO_Code__c='ARG', ISO_Code_2c__c = 'AR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Armenia',Region__c='Asia',ISO_Code__c='ARM', ISO_Code_2c__c = 'AM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Aruba',Region__c='Caribbean',ISO_Code__c='ABW', ISO_Code_2c__c = 'AW'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Australia',Region__c='Australia/Oceania',ISO_Code__c='AUS', ISO_Code_2c__c = 'AU'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Austria',Region__c='Central and North Europe',ISO_Code__c='AUT', ISO_Code_2c__c = 'AT'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Belarus',Region__c='Central and North Europe',ISO_Code__c='BLR', ISO_Code_2c__c = 'BY'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Belgium',Region__c='Central and North Europe',ISO_Code__c='BEL', ISO_Code_2c__c = 'BE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Belize',Region__c='Central America',ISO_Code__c='BLZ', ISO_Code_2c__c = 'BZ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Benin',Region__c='Africa',ISO_Code__c='BEN', ISO_Code_2c__c = 'BJ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Bermuda',Region__c='Caribbean',ISO_Code__c='BMU', ISO_Code_2c__c = 'BM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Bhutan',Region__c='Asia',ISO_Code__c='BTN', ISO_Code_2c__c = 'BT'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Bolivia',Region__c='South America',ISO_Code__c='BOL', ISO_Code_2c__c = 'BO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Bosnia And Herzegovina',Region__c='Central and North Europe',ISO_Code__c='BIH', ISO_Code_2c__c = 'BA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Botswana',Region__c='Africa',ISO_Code__c='BWA', ISO_Code_2c__c = 'BW'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Indonesia',Region__c='Asia',ISO_Code__c='IDN', ISO_Code_2c__c = 'ID'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Iran',Region__c='Middle East',ISO_Code__c='IRN', ISO_Code_2c__c = 'IR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Iraq',Region__c='Middle East',ISO_Code__c='IRQ', ISO_Code_2c__c = 'IQ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Ireland',Region__c='Central and North Europe',ISO_Code__c='IRL', ISO_Code_2c__c = 'IE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='India',Region__c='Asia',ISO_Code__c='IND', ISO_Code_2c__c = 'IN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Isle of Man',Region__c='Central and North Europe',ISO_Code__c='IMN', ISO_Code_2c__c = 'IM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Israel',Region__c='Middle East',ISO_Code__c='ISR', ISO_Code_2c__c = 'IL'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Italy',Region__c='Mediterranean',ISO_Code__c='ITA', ISO_Code_2c__c = 'IT'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Jamaica',Region__c='Caribbean',ISO_Code__c='JAM', ISO_Code_2c__c = 'JM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Switzerland',Region__c='Central and North Europe',ISO_Code__c='CHE', ISO_Code_2c__c = 'CH'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Syria',Region__c='Middle East',ISO_Code__c='SYR', ISO_Code_2c__c = 'SY'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Taiwan',Region__c='Asia',ISO_Code__c='TWN', ISO_Code_2c__c = 'TW'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Tajikistan',Region__c='Asia',ISO_Code__c='TJK', ISO_Code_2c__c = 'TJ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Tanzania',Region__c='Africa',ISO_Code__c='TZA', ISO_Code_2c__c = 'TZ   '); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Thailand',Region__c='Asia',ISO_Code__c='THA', ISO_Code_2c__c = 'TH'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Togo',Region__c='Africa',ISO_Code__c='TGO', ISO_Code_2c__c = 'TG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Tokelau',Region__c='Australia/Oceania',ISO_Code__c='TKL', ISO_Code_2c__c = 'TK'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Tonga',Region__c='Australia/Oceania',ISO_Code__c='TON', ISO_Code_2c__c = 'TO'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Trinidad & Tobago',Region__c='Caribbean',ISO_Code__c='TTO', ISO_Code_2c__c = 'TT   '); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Tunisia',Region__c='Africa',ISO_Code__c='TUN', ISO_Code_2c__c = 'TN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Turkey',Region__c='Mediterranean',ISO_Code__c='TUR', ISO_Code_2c__c = 'TR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Turkmenistan',Region__c='Asia',ISO_Code__c='TKM', ISO_Code_2c__c = 'TM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Turks & Caicos',Region__c='Caribbean',ISO_Code__c='TCA', ISO_Code_2c__c = 'TC'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Tuvalu',Region__c='Australia/Oceania',ISO_Code__c='TUV', ISO_Code_2c__c = 'TV'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Uganda',Region__c='Africa',ISO_Code__c='UGA', ISO_Code_2c__c = 'UG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Ukraine',Region__c='Central and North Europe',ISO_Code__c='UKR', ISO_Code_2c__c = 'UA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='United Arab Emirates',Region__c='Middle East',ISO_Code__c='ARE', ISO_Code_2c__c = 'AE'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='United Kingdom',Region__c='Central and North Europe',ISO_Code__c='GBR', ISO_Code_2c__c = 'GB'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='United States',Region__c='North America',ISO_Code__c='USA', ISO_Code_2c__c = 'US'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Uruguay',Region__c='South America',ISO_Code__c='URY', ISO_Code_2c__c = 'UY'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Uzbekistan',Region__c='Asia',ISO_Code__c='UZB', ISO_Code_2c__c = 'UZ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Vanuatu',Region__c='Australia/Oceania',ISO_Code__c='VUT', ISO_Code_2c__c = 'VU'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Madagascar',Region__c='Africa',ISO_Code__c='MDG', ISO_Code_2c__c = 'MG'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Malawi',Region__c='Africa',ISO_Code__c='MWI', ISO_Code_2c__c = 'MW'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Malaysia',Region__c='Asia',ISO_Code__c='MYS', ISO_Code_2c__c = 'MY'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Maldives',Region__c='Asia',ISO_Code__c='MDV', ISO_Code_2c__c = 'MV'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Mali',Region__c='Africa',ISO_Code__c='MLI', ISO_Code_2c__c = 'ML'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Malta',Region__c='Mediterranean',ISO_Code__c='MLT', ISO_Code_2c__c = 'MT'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Marshall Islands',Region__c='Australia/Oceania',ISO_Code__c='MHL', ISO_Code_2c__c = 'MH'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Martinique',Region__c='Caribbean',ISO_Code__c='MTQ', ISO_Code_2c__c = 'MQ'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Mauritania',Region__c='Africa',ISO_Code__c='MRT', ISO_Code_2c__c = 'MR'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Mauritius',Region__c='Africa',ISO_Code__c='MUS', ISO_Code_2c__c = 'MU'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Mexico',Region__c='North America',ISO_Code__c='MEX', ISO_Code_2c__c = 'MX'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Federated States of Micronesia',Region__c='Australia/Oceania',ISO_Code__c='FSM', ISO_Code_2c__c = 'FM'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Moldova',Region__c='Central and North Europe',ISO_Code__c='MDA', ISO_Code_2c__c = 'MD  '); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Principality of Monaco',Region__c='Central and North Europe',ISO_Code__c='MCO', ISO_Code_2c__c = 'MC'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Mongolia',Region__c='Asia',ISO_Code__c='MNG', ISO_Code_2c__c = 'MN'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Montenegro',Region__c='Central and North Europe',ISO_Code__c='MNE', ISO_Code_2c__c = 'ME'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Montserrat',Region__c='Caribbean',ISO_Code__c='MSR', ISO_Code_2c__c = 'MS'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Morocco',Region__c='Africa',ISO_Code__c='MAR', ISO_Code_2c__c = 'MA'); lista_country.add(nuevo_country);
        nuevo_country = new Country__c(Name='Mozambique',Region__c='Africa',ISO_Code__c='MOZ', ISO_Code_2c__c = 'MZ'); lista_country.add(nuevo_country);
        
        if(query_countries != null && query_countries.size()>0)
        {
            list<Country__c> countries_to_insert = new List<Country__c>();
            for(Country__c co: lista_country)
            {
                if(map_countries.containskey(co.ISO_Code__c) == false)
                    countries_to_insert.add(co);
            }
            
            if(countries_to_insert != null && countries_to_insert.size()>0)
                insert countries_to_insert;
        }
        else
            insert lista_country;
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, string.valueof(lista_country.size())+' Countries inserted'));
    }
    
    public void insert_states()
    {
    	List<State__c> lst_new_states = new List<State__c>();
    	Map<String, List<State__c>> map_states_countries = new Map<String, List<State__c>>{
    		'United States' => new list<State__c> {
    			new State__c(Name='Alabama',ISO_Code__c='AL'),
				new State__c(Name='Alaska',ISO_Code__c='AK'),
				new State__c(Name='Arizona',ISO_Code__c='AZ'),
				new State__c(Name='Arkansas',ISO_Code__c='AR'),
				new State__c(Name='California',ISO_Code__c='CA'),
				new State__c(Name='North Carolina',ISO_Code__c='NC'),
				new State__c(Name='South Carolina',ISO_Code__c='SC'),
				new State__c(Name='Colorado',ISO_Code__c='CO'),
				new State__c(Name='Connecticut',ISO_Code__c='CT'),
				new State__c(Name='District of Columbia',ISO_Code__c='DC'),
				new State__c(Name='North Dakota',ISO_Code__c='ND'),
				new State__c(Name='South Dakota',ISO_Code__c='SD'),
				new State__c(Name='Delaware',ISO_Code__c='DE'),
				new State__c(Name='Florida',ISO_Code__c='FL'),
				new State__c(Name='Georgia',ISO_Code__c='GA'),
				new State__c(Name='Hawaii',ISO_Code__c='HI'),
				new State__c(Name='Idaho',ISO_Code__c='ID'),
				new State__c(Name='Illinois',ISO_Code__c='IL'),
				new State__c(Name='Indiana',ISO_Code__c='IN'),
				new State__c(Name='Iowa',ISO_Code__c='IA'),
				new State__c(Name='Kansas',ISO_Code__c='KS'),
				new State__c(Name='Kentucky',ISO_Code__c='KY'),
				new State__c(Name='Louisiana',ISO_Code__c='LA'),
				new State__c(Name='Maine',ISO_Code__c='ME'),
				new State__c(Name='Maryland',ISO_Code__c='MD'),
				new State__c(Name='Massachusetts',ISO_Code__c='MA'),
				new State__c(Name='Michigan',ISO_Code__c='MI'),
				new State__c(Name='Minnesota',ISO_Code__c='MN'),
				new State__c(Name='Mississippi',ISO_Code__c='MS'),
				new State__c(Name='Missouri',ISO_Code__c='MO'),
				new State__c(Name='Montana',ISO_Code__c='MT'),
				new State__c(Name='Nebraska',ISO_Code__c='NE'),
				new State__c(Name='Nevada',ISO_Code__c='NV'),
				new State__c(Name='New Jersey',ISO_Code__c='NJ'),
				new State__c(Name='New York',ISO_Code__c='NY'),
				new State__c(Name='New Hampshire',ISO_Code__c='NH'),
				new State__c(Name='New Mexico',ISO_Code__c='NM'),
				new State__c(Name='Ohio',ISO_Code__c='OH'),
				new State__c(Name='Oklahoma',ISO_Code__c='OK'),
				new State__c(Name='Oregon',ISO_Code__c='OR'),
				new State__c(Name='Pennsylvania',ISO_Code__c='PA'),
				new State__c(Name='Rhode Island',ISO_Code__c='RI'),
				new State__c(Name='Tennessee',ISO_Code__c='TN'),
				new State__c(Name='Texas',ISO_Code__c='TX'),
				new State__c(Name='Utah',ISO_Code__c='UT'),
				new State__c(Name='Vermont',ISO_Code__c='VT'),
				new State__c(Name='Virginia',ISO_Code__c='VA'),
				new State__c(Name='West Virginia',ISO_Code__c='WV'),
				new State__c(Name='Washington',ISO_Code__c='WA'),
				new State__c(Name='Wisconsin',ISO_Code__c='WI'),
				new State__c(Name='Wyoming',ISO_Code__c='WY')
    		},
    		'Mexico' => new list<State__c> {
    			new State__c(Name='Aguascalientes',ISO_Code__c='AGU'),
				new State__c(Name='Baja California',ISO_Code__c='BCN'),
				new State__c(Name='Baja California Sur',ISO_Code__c='BCS'),
				new State__c(Name='Campeche',ISO_Code__c='CAM'),
				new State__c(Name='Chiapas',ISO_Code__c='CHP'),
				new State__c(Name='Chihuahua',ISO_Code__c='CHH'),
				new State__c(Name='Ciudad de México',ISO_Code__c='DIF'),
				new State__c(Name='Coahuila de Zaragoza',ISO_Code__c='COA'),
				new State__c(Name='Colima',ISO_Code__c='COL'),
				new State__c(Name='Durango',ISO_Code__c='DUR'),
				new State__c(Name='Guanajuato',ISO_Code__c='GUA'),
				new State__c(Name='Guerrero',ISO_Code__c='GRO'),
				new State__c(Name='Hidalgo',ISO_Code__c='HID'),
				new State__c(Name='Jalisco',ISO_Code__c='JAL'),
				new State__c(Name='México',ISO_Code__c='MEX'),
				new State__c(Name='Michoacán de Ocampo',ISO_Code__c='MIC'),
				new State__c(Name='Morelos',ISO_Code__c='MOR'),
				new State__c(Name='Nayarit',ISO_Code__c='NAY'),
				new State__c(Name='Nuevo León',ISO_Code__c='NLE'),
				new State__c(Name='Oaxaca',ISO_Code__c='OAX'),
				new State__c(Name='Puebla',ISO_Code__c='PUE'),
				new State__c(Name='Querétaro de Arteaga',ISO_Code__c='QUE'),
				new State__c(Name='Quintana Roo',ISO_Code__c='ROO'),
				new State__c(Name='San Luis Potosí',ISO_Code__c='SLP'),
				new State__c(Name='Sinaloa',ISO_Code__c='SIN'),
				new State__c(Name='Sonora',ISO_Code__c='SON'),
				new State__c(Name='Tabasco',ISO_Code__c='TAB'),
				new State__c(Name='Tamaulipas',ISO_Code__c='TAM'),
				new State__c(Name='Tlaxcala',ISO_Code__c='TLA'),
				new State__c(Name='Veracruz de Ignacio de la Llave',ISO_Code__c='VER'), 	
				new State__c(Name='Yucatán',ISO_Code__c='YUC'),
				new State__c(Name='Zacatecas',ISO_Code__c='ZAC')
    		}
    	};

        List<Country__c> query_country = [select Name, Id from Country__c];
        Map<String, Id> map_country = new Map<String, Id>();
        for(Country__c co: query_country)
        {
            map_country.put(co.Name, co.Id);
        }
        
        List<State__c> query_states= [select Id, Name from State__c];
        Map<string,State__c> map_states = new Map<string,State__c>();
        for(State__c st: query_states)
        {
            map_states.put(st.Name, st);
        }
        
        for (String country : map_states_countries.keySet()) {
    		for(State__c state : map_states_countries.get(country)){
    			if(query_states != null && query_states.size()>0){
                    if(map_states.containskey(state.Name) == false){
                        state.Country__c =  map_country.get(country);
                        lst_new_states.add(state);
                    }
                }else{
                    state.Country__c =  map_country.get(country);
                    lst_new_states.add(state);
                }
    		}
		}
        
        
        
        insert lst_new_states;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, string.valueof(lst_new_states.size())+' States inserted'));
        /*Country__c nuevo_pais = new Country__c();
        nuevo_pais.Name = 'Other';
        insert nuevo_pais;
        List<State__c> listado_estados = new List<State__c>();
        List<Country__c> lista_paises = [select id, Name from Country__c ];
        for(Country__c co:lista_paises)
        {
            State__c nuevo_estado = new State__c();
            nuevo_estado.Name = 'Other';
            nuevo_estado.Country__c  = co.Id;
            listado_estados.add(nuevo_estado);
        }
        insert listado_estados;*/
    }
    
    public void insert_locations()
    {
    	List<Location__c> lst_new_locations = new List<Location__c>();
    	Map<String, Map<String, List<String>>> map_locations_states_countries = new Map<String, Map<String, List<String>>>{
    		'-' => new Map<String, List<String>>{
    			'-' => new list<String> {
    				'Ndola',
    				'Harare',
    				'Masvingo',
    				'Christmas Island',
    				'Kabul',
    				'Port Rashid'
    			}
    		},
            'Albania' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Durres', 'Tirana'
            	}
            },
            'Algeria' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Algiers',
    				'Annaba',
    				'Arzew',
    				'Bejaia',
    				'Dellys',
    				'Djen Djen',
    				'Djidjelli',
    				'Ghazaouet',
    				'Mostaganem',
    				'Oran',
    				'Skikda',
    				'Tenes'
            	}
            },
            'American Samoa' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Pago Pago'
            	}
            },
            'Angola' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Cabinda',
    				'Lobito',
    				'Luanda',
    				'Malongo',
    				'Namibe',
    				'Porto Amboim',
    				'Sonils',
    				'Soyo'
            	}
            },
            'Anguilla' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Blowing Point', 'Road Bay'
            	}
            },
            'Antigua & Barbuda' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'St. Johns'
            	}
            },
            'Argentina' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'San Pedro',
    				'Acevedo',
    				'Bahia Blanca',
    				'Buenos Aires',
    				'Campana',
    				'Comodoro Rivadavia',
    				'Cordoba',
    				'Corrientes',
    				'La Plata',
            		'Las Palmas',
    				'Mar del Plata',
    				'Mendoza',
    				'Necochea',
    				'Puerto Deseado',
    				'Puerto Madryn',
    				'Punta Quilla',
    				'Rosario',
            		'San Antonio Este',
    				'San Francisco',
    				'San Pedro',
    				'Santa Fe',
    				'Ushuaia',
    				'Zarate'
				}
            },
            'Armenia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Yerevan'
            	}
            },
            'Aruba' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Oranjestad'
            	}
            },
            'Australia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Adelaide',
    				'Bell Bay',
    				'Brisbane',
    				'Broome',
    				'Bunbury',
    				'Burnie',
    				'Dampier',
    				'Darwin',
    				'Devonport',
    				'Esperance',
    				'Fremantle',
            		'Geelong',
    				'Geraldton',
    				'Gladstone',
    				'Hay Point',
    				'Hobart',
    				'Launceston',
    				'Melbourne',
    				'Newcastle',
    				'Port Alma',
    				'Port Hedland',
            		'Port Kembla',
    				'Port Pirie',
    				'Sydney',
    				'Townsville',
    				'Westernport',
    				'Wyndham'
            	}
            },
            'Austria' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bregenz',
    				'Graz',
    				'Innsbruck',
    				'Linz',
    				'Salzburg',
    				'Vienna'
            	}
            },
            'Azerbaijan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Baku'
            	}
            },
            'Bahamas' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Andros Town',
    				'Bimini',
    				'Cat Cays',
    				'Chub Cay',
    				'Eleuthera Island',
    				'Freeport',
    				'George Town, Great Exuma',
    				'Governors Harbour',
            		'Great Exuma Island',
    				'Great Harbour Cay',
    				'Green Turtle',
    				'Harbour Island',
    				'Long Island',
    				'Marsh Harbour',
    				'Nassau',
    				'Norman Cay',
            		'Paradise Island',
    				'Spanish Wells',
    				'West End'
            	}
            },
            'Bangladesh' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Chalna',
    				'Chittagong',
    				'Dhaka',
    				'Khulna',
    				'Mongla'
            	}
            },
            'Barbados' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bridgetown',
    				'St. Michael'
            	}
            },
            'Belarus' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Grodno',
    				'Minsk',
    				'Vitebsk'
            	}
            },
            'Belgium' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Antwerp',
    				'Brussels',
    				'Eernegem',
    				'Ghent',
    				'Liege',
    				'Rixensart',
    				'Zeebrugge'
            	}
            },
            'Belize' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Belize City',
    				'Big Creek'
            	}
            },
            'Benin' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Cotonou'
            	}
            },
            'Bermuda' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Hamilton'
            	}
            },
            'Bolivia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Cochabamba',
    				'La Paz',
    				'Oruro',
    				'Santa Cruz',
    				'Sucre'
            	}
            },
            'Bosnia And Herzegovina' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Mostar',
    				'Sarajevo',
    				'Tuzla'
            	}
            },
            'Botswana' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Shakawe'
            	}
            },
            'Brazil' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Angra Dos Reis',
    				'Antonina',
    				'Aratu',
    				'Belem',
    				'Breves',
    				'Cabedelo',
    				'Curitiba',
    				'Fortaleza',
    				'Ilheus',
    				'Imbituba',
    				'Itaguai',
            		'Itajai',
    				'Itapoa',
    				'Itaqui',
    				'Macapa',
    				'Maceio',
    				'Manaus',
    				'Mucuripe',
    				'Munguba',
    				'Natal',
    				'Navegantes',
    				'Niteroi',
    				'Paranagua',
            		'Pecem',
    				'Porto Alegre',
    				'Portocel',
    				'Praia Mole',
    				'Recife',
    				'Rio de Janeiro',
    				'Rio Grande',
    				'Salvador',
    				'Santa Rosa',
    				'Santana',
            		'Santarem',
    				'Santos',
    				'Sao Francisco Do Sul',
    				'Sao Paulo',
    				'Sao Sebastiao',
    				'Sepetiba',
    				'Suape',
    				'Vila do Conde',
    				'Vitoria'
				}
            },
            'British Virgin Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Road Town',
    				'Tortola',
    				'Virgin Gorda'
            	}
            },
            'Brunei Darussalam' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Kuala Belait',
    				'Muara'
            	}
            },
            'Bulgaria' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Burgas',
    				'Sofia',
    				'Varna'
            	}
            },
            'Burkina Faso' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bobo-Dioulasso',
    				'Ouagadougou'
            	}
            },
            'Burundi' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bujumbura'
            	}
            },
            'Cambodia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Kampong Saom',
    				'Phnom Penh',
    				'Sihanoukville'
            	}
            },
            'Cameroon' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Douala',
    				'Ngaoundere',
    				'Yaounde'
            	}
            },
            'Canada' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Arctic Bay, Northwest Territories',
    				'Argentia, Newfoundland',
    				'Arviat, Nunavut',
    				'Aupauluk, Quebec',
    				'Baie Comeau, Quebec',
            		'Bay Bulls, Newfoundland',
    				'Becancour, Quebec',
    				'Blanc-Sablon, Quebec',
    				'Botwood, Newfoundland',
    				'Calgary, Alberta',
            		'Cambridge Bay, Northwest Territories',
    				'Campbell River, British Columbia',
    				'Chemainus, British Columbia',
            		'Chesterfield Inlet, Northwest Territories',
    				'Clyde River, Northwest Territories',
    				'Contrecoeur, Quebec',
            		'Coral Harbour, Northwest Territories',
    				'Corner Brook, Newfoundland',
    				'Cornwallis Island, Nunavut',
    				'Crofton, British Columbia',
            		'Dalhousie, New Brunswick',
    				'Deception Bay, Saskatchewan',
    				'Duncan Bay, British Columbia',
    				'Edmonton, Alberta',
            		'Etobicoke, Ontario',
    				'Fraser River, British Columbia',
    				'Gjoa Haven, Northwest Territories',
    				'Grise Fiord, Nunavut',
					'Gros Cacouna, Quebec',
    				'Halifax, Nova Scotia',
    				'Hall Beach, Northwest Territories',
    				'Hamilton, Ontario',
    				'Harmac, British Columbia',
					'Havre-Saint-Pierre, Quebec',
    				'Igloolik, Northwest Territories',
    				'Inukjuak, Quebec',
    				'Iqaluit, Northwest Territories',
					'Ivujivik, Quebec',
    				'Kangiqsujuaq, Quebec',
    				'Kangirsuk, Quebec',
    				'Kegaska, Quebec',
    				'Kimmirut, Nunavut',
    				'Kitimat, British Columbia',
					'Kugluktuk, Nunavut',
    				'Kuujjuaq, Quebec',
    				'La Tabatiere, Quebec',
    				'Liverpool, Nova Scotia',
    				'Magdalen Islands, Quebec',
					'Mississauga, Ontario',
    				'Montreal, Quebec',
    				'Nanaimo, British Columbia',
    				'Nanisivik, Nunavut',
    				'Natashquan, Quebec',
					'New Westminster, British Columbia',
    				'Pangnirtung, Northwest Territories',
    				'Pictou, Nova Scotia',
    				'Pointe Au Pic, Quebec',
					'Pond Inlet, Northwest Territories',
    				'Port Alice, British Columbia',
    				'Port Mellon, British Columbia',
    				'Port-Menier, Quebec',
					'Prince Edward Island, Quebec',
    				'Prince Rupert, British Columbia',
    				'Quebec, Quebec',
    				'Regina, Saskatchewan',
					'Resolute Bay, Northwest Territories',
    				'Rimouski, Quebec',
    				'Saint-Augustin, Quebec',
    				'Salluit, Quebec',
    				'Sanikiluaq, Nunavut',
					'Saskatoon, Saskatchewan',
    				'Sault Ste. Marie, Ontario',
    				'Sept-Iles, Quebec',
    				'Shelburne, Nova Scotia',
    				'Sorel, Quebec',
					'Squamish, British Columbia',
    				'St. John, New Brunswick',
    				'St. John`s, Newfoundland',
    				'Stephenville, Newfoundland',
					'Taloyoak, Nunavut',
    				'Tasiujaq, Quebec',
    				'Tete-a-la-Baleine, Quebec',
    				'Toronto, Ontario',
    				'Trois-Rivieres, Quebec',
					'Valleyfield, Quebec',
    				'Vancouver, British Columbia',
    				'Vancouver, British Columbia',
    				'Victoria, British Columbia',
					'Whale Cove, Nunavut',
    				'Whitehorse, Alberta',
    				'Windsor, Ontario',
    				'Winnipeg, Manitoba',
    				'Woodfibre, British Columbia'
				}
            },
            'Cape Verde Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Mindelo',
    				'Praia'
            	}
            },
            'Cayman Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Cayman Brac',
    				'Georgetown, Grand Cayman',
    				'Grand Cayman',
    				'Little Cayman'
            	}
            },
            'Central African Republic' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bangui'
            	}
            },
            'Chile' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Antofagasta',
    				'Arica',
    				'Caldera',
    				'Caldera',
    				'Caleta Coloso',
    				'Chacabuco',
    				'Chanaral',
    				'Concepcion',
    				'Coquimbo',
    				'Coronel',
            		'Huasco',
    				'Iquique',
    				'Isla de Pascua',
    				'La Serena',
    				'Lirquen',
    				'Mejillones',
    				'Penco',
    				'Puerto Angamos',
    				'Puerto Chacabuco',
            		'Puerto Montt',
    				'Puerto Patache',
    				'Punta Arenas',
    				'Punta Chungo',
    				'San Antonio',
    				'San Vicente',
    				'Santiago',
    				'Talcahuano',
            		'Tocopilla',
    				'Valparaiso',
    				'Ventanas'
            	}
            },
            'China' => new Map<String, List<String>>{
            	'-' => new list<String> {
					'Anqing',
    				'Baoan',
    				'Bayuquan',
    				'Bei Hai',
    				'Beijiao',
    				'Beijiao',
    				'Beijing',
    				'Caofeidian',
    				'Chang Sha',
    				'Changchun',
    				'Changshu',
					'Changzhou',
    				'Chengdu',
    				'Chiwan',
    				'Chongqing',
    				'Civet Port',
    				'Da Chan Bay',
    				'Da Feng',
    				'Dagang',
    				'Dalian',
    				'Danzhou',
    				'De Qing',
					'Dongguan',
    				'Doumen','Fangcheng','Fangcun','Foshan','Fuqing','Fuzhou','Gao Yao','Gaolan','Gaoming','Gong Yi','Guangzhou',
					'Guigang','Haikou','Haimen','Hangzhou','Hefei','Heshan','Huadu','Huadu','Huangpu','Huangshi','Huizhou','Humen','Jiangmen',
					'Jiangyin','Jiao Xin','Jiaxing','Jin Zhou','Jingtang','Jingzhou','Jiujiang','Kaiping','Kunshan','Lanshi','Lian Hua Shan',
					'Lian Yun Gang','Liudu','Liuzhou','Longkou','Lushun','Luzhou','Mafang','Maogang','Maoming','Mawan','Nan Kong','Nanchang',
					'Nanhai','Nanjing','Nanning','Nansha','Nantong','Ningbo','Pingzhou','Putian','Qingdao','Qingyuan','Qinhuangdao','Qinzhou',
					'Quanzhou','Quzhou','Rizhao','Rongqi','Sanbu','Sanrong','Sanshan','Sanshui','Shanghai','Shantou','Shatian','Shekou',
					'Shen Wan','Shenyang','Shenzhen','Shidao','Shihu','Shitan','Shouguang','Shunde','Suzhou','Taicang','Taiping','Taishan',
					'Taizhou','Tianjin','Tianjinxingang','Tongling','Waihai','Wanzai','Wanzhou','Weihai','Weitou','Wen Zhou','Wuhan','Wuhu',
					'Wuxi','Wuzhou','Xiamen','Xian','Xiaolan','Xin Tang','Xinfeng','Xingang','Xinhui','Xinsha','Yangpu','Yangzhou','Yantai',
					'Yantian','Yichang','Yingkou','Yongtai','Yueyang','Yunfu','Zhangjiagang','Zhangzhou','Zhanjiang','Zhaoqing','Zhapu',
					'Zhengzhou','Zhenjiang','Zhongshan','Zhoushan','Zhuhai'
				}
            },
            'Colombia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Barranquilla',
    				'Bogota',
    				'Buenaventura',
    				'Cali',
    				'Cartagena',
    				'Cartagena',
    				'Leticia',
    				'Medellin',
    				'San Andres Island',
            		'Santa Marta',
    				'Tolu',
    				'Turbo'
            	}
            },
            'Comoros' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Moroni'
            	}
            },
            'Cook Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Avarua',
    				'Rarotonga'
            	}
            },
			'Costa Rica' => new Map<String, List<String>>{
				'-' => new list<String> {
					'Golfito',
    				'Heredia',
    				'Moin',
    				'Puerto Limon',
    				'San Jose'
				}
			},
            'Croatia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Dubrovnik',
    				'Ploce',
    				'Rijeka',
    				'Split',
    				'Zagreb'
            	}
            },
            'Cuba' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Cienfuegos',
    				'Havana',
    				'Mariel',
    				'Moa',
    				'Nuevitas',
    				'Puerto Padre',
    				'Santiago de Cuba'
            	}
            },
            'Cyprus' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Famagusta',
    				'Larnaca',
    				'Limassol',
    				'Nicosia'
            	}
            },
            'Czech Republic' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Prague'
            	}
            },
            'Democratic Republic of the Congo' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Banana',
    				'Boma',
    				'Kinshasa',
    				'Lubumbashi',
    				'Matadi'
            	}
            },
            'Denmark' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Aabenraa',
    				'Aalborg',
    				'Aarhus',
    				'Broerup',
    				'Copenhagen',
    				'Esbjerg',
    				'Fredericia',
    				'Kalundborg',
    				'Nyborg',
    				'Odense',
    				'Padborg',
    				'Rungsted'
            	}
            },
            'Dominica' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Roseau'
            	}
            },
            'Dominican Republic' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Barahona',
    				'Boca Chica',
    				'Caucedo',
    				'Haina',
    				'La Romana',
    				'Puerto Plata',
    				'Punta Cana',
    				'Santa Barbara de Samana',
    				'Santo Domingo'
            	}
            },
            'Ecuador' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Cuenca',
    				'Esmeraldas',
    				'Guayaquil',
    				'La Libertad',
    				'Manta',
    				'Puerto Bolivar',
    				'Puerto Bolivar',
    				'Quito'
            	}
            },
            'Egypt' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Adabiya',
    				'Ain Sukhna',
    				'Alexandria',
    				'Cairo',
    				'Damietta',
    				'El Dekheila',
    				'Port Said East',
    				'Port Said',
    				'Sokhna',
    				'Suez Canal'
            	}
            },
            'El Salvador' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Acajutla',
    				'La Union',
    				'San Salvador'
            	}
            },
            'Eritrea' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Asmara',
    				'Assab',
    				'Massawa'
            	}
            },
            'Estonia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Muuga',
    				'Paldiski',
    				'Parnu',
    				'Tallinn',
    				'Tartu'
            	}
            },
            'Ethiopia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Addis Ababa'
            	}
            },
            'Faroe Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Klaksvik',
    				'Kollafjordur',
    				'Thorshavn'
            	}
            },
            'Federated States of Micronesia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Chuuk',
    				'Kosrae',
    				'Pohnpei',
    				'Yap'
            	}
            },
			'Fiji' => new Map<String, List<String>>{
				'-' => new list<String> {
					'Lautoka',
    				'Savusavu',
    				'Suva'
				}
			},
			'Finland' => new Map<String, List<String>>{
				'-' => new list<String> {
					'Hamina',
    				'Hanko',
    				'Helsinki',
    				'Inkoo',
    				'Jakobstad',
    				'Karkkila',
    				'Kemi',
    				'Kokkola',
    				'Kotka',
    				'Koverhar',
    				'Mantyluoto',
    				'Oulu',
					'Pori',
    				'Raahe',
    				'Rahja',
    				'Tampere',
    				'Tornio',
    				'Turku',
    				'Uleaborg',
    				'Valkom'
				}
			},
			'France' => new Map<String, List<String>>{
				'-' => new list<String> {
					'Ajaccio','Antibes','Bassens','Bastia','Bayonne','Bordeaux','Boulogne','Brest','Caen','Calais','Cannes','Caronte',
					'Cherbourg','Concarneau','Deauville','Dieppe','Dijon','Dunkerque','Fos Sur Mer','Grasse','Grenoble','Honfleur',
					'La Pallice','La Rochelle','Le Havre','Le Trait','Le Verdon','Lille','Lorient','Lyon','Macon','Marseille','Montoir',
					'Montpellier','Nantes','Nice','Nogaro','Paris','Port Vendres','Radicatel','Rouen','Sete','St. Barthelemy','St. Nazaire',
					'Strasbourg','Toulon','Toulouse'
				}
			},
            'French Guiana' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Cayenne',
    				'Degrad de Cannes'
            	}
            },
            'French Polynesia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bora Bora',
    				'Papeete, Tahiti'
            	}
            },
            'Gabon' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Libreville',
    				'Mayumba',
    				'Owendo',
    				'Port Gentil'
            	}
            },
            'Gambia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Banjul'
            	}
            },
            'Georgia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Batumi',
    				'Poti',
    				'Tbilisi'
            	}
            },
            'Germany' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Berlin',
    				'Bonn',
    				'Brake',
    				'Bremen',
    				'Bremerhaven',
    				'Brunsbuttel',
    				'Cuxhaven',
    				'Dresden',
    				'Duisburg',
    				'Dusseldorf',
    				'Emden',
            		'Essen',
    				'Frankfurt',
    				'Geldern',
    				'Hagen',
    				'Hamburg',
    				'Hannover',
    				'Kassel',
    				'Kiel',
    				'Koln',
    				'Leipzig',
    				'Lubeck',
    				'Mainz',
    				'Mannheim',
            		'Meinheim',
    				'Munich',
    				'Nordenham',
    				'Nurnberg',
    				'Rostock',
    				'Schleswig',
    				'Steinheim',
    				'Stolpen',
    				'Stuttgart'
				}
            },
            'Ghana' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Accra',
    				'Kumasi',
    				'Takoradi',
    				'Tema'
            	}
            },
            'Gibraltar' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Gibraltar City'
            	}
            },
            'Greece' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Astakos',
    				'Athens',
    				'Corfu',
    				'Corinth',
    				'Eleusis',
    				'Iraklion',
    				'Kalamata',
    				'Kavala',
    				'Lavrion',
    				'Piraeus',
    				'Preveza',
            		'Skaramangas',
    				'Stylis',
    				'Thessaloniki',
    				'Volos'
            	}
            },
            'Grenada' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Grenada City',
    				'St. Georges'
            	}
            },
            'Guadaloupe' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Basse-Terre',
    				'Marigot',
    				'Pointe-a-Pitre'
            	}
            },
            'Guam Island' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Apra Harbor',
    				'Guam'
            	}
            },
            'Guatemala' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Guatemala City',
    				'Puerto Barrios',
    				'Puerto Quetzal',
    				'Santo Tomas de Castilla'
            	}
            },
            'Guinea-Bissau' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bissau'
            	}
            },
            'Guine' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bata',
    				'Conakry',
    				'Luba',
    				'Malabo'
            	}
            },
            'Guyana' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Georgetown',
    				'Linden'
            	}
            },
            'Haiti' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Cap Haitien',
    				'Gonaives',
    				'Jacmel',
    				'Laffiteau',
    				'Miragoane',
    				'Port de Paix',
    				'Port-au-Prince',
    				'St. Marc'
            	}
            },
            'Honduras' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'La Ceiba',
    				'Puerto Castilla',
    				'Puerto Cortes',
    				'Roatan',
    				'San Pedro Sula',
    				'Tegucigalpa'
				}
            },
            'Hong Kong' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Hong Kong (HKHKG)'
            	}
            },
            'Hungary' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Budapest',
    				'Racalmas'
            	}
            },
            'Iceland' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Akureyri',
    				'Cork',
    				'Dalvik',
    				'Dublin',
    				'Eskifjordur',
    				'Fenit',
    				'Foynes',
    				'Grundartangi',
    				'Hafnarfjordur',
    				'Husavik',
            		'Isafjorour',
    				'Kopavogur',
    				'Limerick',
    				'Mjofjordur',
    				'Neskaupstadur',
    				'Patreksfjordur',
    				'Reydarfjordur',
    				'Reykjavik',
            		'Saudarkrokur',
    				'Shannon',
    				'Siglufjordur',
    				'Straumsvik',
    				'Thorshofn',
    				'Vestmannaeyjar',
    				'Waterford'
            	}
            },
            'India' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Ahmedabad','Bangalore','Baroda','Chennai','Cochin','Coimbatore','Dadri','Delhi','Ennore','Gangavaram','Goa','Gurgaon',
            		'Haldia','Hazira','Hyderabad','Indore','Jaipur','Jamnagar','Jawaharal Nehru','Kakinada','Kandla','Kanpur','Karwar',
            		'Kolkata','Loni','Ludhiana','Mangalore','Marmagao','Moradabad','Mulund','Mumbai','Mundra','Nagpur','Nasik','New Delhi',
            		'Paradip','Patparganj','Pipavav','Pune','Sachin','Sika','Surat','Talegoan','Triruvananthapuram','Tughlakabad','Tuticorin',
            		'Vadinar','Vapi','Visakhapatnam','Vizag','Waluj'
            	}
            },
            'Indonesia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Balikpapan','Banjarmasin','Batam Island','Batu Ampal','Belawan','Benete','Benoa','Bitung','Bontang','Buatan',
            		'Cigading','Cilacap','Jakarta','Jambi, Sumatra','Kabil','Kendari','Kuala Tanggal','Kumai','Lobam','Makassar',
            		'Maumere','Merak','Muara Djawa','Padang','Palembang','Pangkal Balam','Pangkalpinang','Panjang Lampung','Panjang',
            		'Pantoloan','Pekanbaru','Perawang','Pontianak','Samarinda','Sampit Kalimantan','Sekupang','Semarang','Surabaya',
            		'Tanjung Priok','Tarahan','Tarakan','Tebingtinggi','Tolitoli','Ujung Pandang'
            	}
            },
			'Iran' => new Map<String, List<String>>{
				'-' => new list<String> {
					'Abadan',
    				'Bandar Abbas',
    				'Bandar Assaluyeh',
    				'Bandar Khomeini',
    				'Bandar Shahid Rejaee',
    				'Bushehr',
    				'Imam Khomeini',
					'Khorramshahr',
    				'Tehran'
				}
			},
            'Iraq' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Baghdad',
    				'Basra',
    				'Khor Al Zubair',
    				'Mosul',
    				'Umm Qasr'
            	}
            },
            'Isle of Man' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Castletown',
    				'Douglas',
    				'Peel',
    				'Ramsey'
            	}
            },
            'Israel' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Ashdod',
    				'Elat',
    				'Haifa',
    				'Ramat Gan',
    				'Tel Aviv'
            	}
            },
            'Italy' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Ancona','Anzio','Augusta','Bari','Barletta','Bologna','Bolzano','Brescia','Brindisi','Cagliari','Catania',
            		'Civitavecchia','Como','Crotone','Florence','Gaeta','Genoa','Gioia Tauro','La Spezia','Livorno','Marghera',
            		'Marina di Carrara','Messina','Milan','Monfalcone','Napoli','Olbia','Ortona','Padova','Palermo','Parma','Pescate',
            		'Ravenna','Rome','Salerno','Savona','Sigonella','Taranto','Torino','Trapani','Trieste','Vado Ligure','Venice',
            		'Verona','Vibo Valentia','Voltri'
            	}
            },
            'Ivory Coast' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Abidjan'
            	}
            },
            'Jamaica' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Kingston'
            	}
            },
            'Japan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Aburatsu','Aioi','Akita','Aomori','Chiba','Chofu','Fukuoka','Fukushima Hokkaido','Fukuyama','Fushiki','Hachinohe',
            		'Hakata','Hakodate','Hamada','Hibi','Hibiki','Higashiharima','Himeji','Hiroshima','Hitachi','Hitachinaka','Honmoku',
            		'Hososhima','Imabari','Imari','Irago','Ishigaki','Ishikari','Ishikariwanshinko','Iwakuni','Iyomishima','Kakogawa',
            		'Kanazawa','Kanda','Kansai','Kashima','Kawasaki','Kinjo','Kinuura','Kitakyushu','Kobe','Kochi','Kokura','Kumamoto',
            		'Kure','Kushiro','Matsuyama','Mishima Kawanoe','Mizushima','Moji','Montego Bay','Muroran','Nagasaki','Nagoya','Naha',
            		'Nakanoseki','Naoetsu','Naoshima','Niigata','Niihama','Noshiro','Ohgishima','Oita','Okinawa','Omaezaki','Onahama',
					'Osaka','Otake','Ozuku','Saganoseki','Sakai','Sakaiminato','Sakaisenboku','Sakata','Seibu','Sendai Kagoshima',
					'Sendai Shinko','Sendai','Shibushi','Shimizu','Shimonoseki','Shinkiba','Shushi','Tagonoura','Tahara','Takamatsu',
					'Tobata','Tokachi','Tokai','Tokushima','Tokuyama','Tokyo','Tomakomai','Toyama','Toyamashinko','Toyohashi','Toyota',
					'Tsuruga','Ube','Wakayama','Wakkanai','Yamaguchi','Yatsushiro','Yawata','Yokkaichi','Yokohama','Yokosuka','Yura'
            	}
            },
            'Jersey' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Ocho Rios'
            	}
            },
            'Jordan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Amman',
    				'Aqaba',
    				'Port Esquivel'
            	}
            },
            'Kazakhstan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Aktau',
    				'Aktyubinsk',
    				'Almaty',
    				'Kokshetau',
    				'Pavlodar',
    				'Rio Bueno'
            	}
            },
            'Kenya' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Embakasi',
    				'Mombasa',
    				'Nairobi'
            	}
            },
            'Kingdom of Bahrain' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bahrain',
    				'Khalifa Bin Salman Port',
    				'Manama',
    				'Mina Sulman'
            	}
            },
            'Kiribati' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Tarawa'
            	}
            },
            'Kuwait' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Kuwait City',
    				'Safat',
    				'Shuaiba',
    				'Shuwaikh'
            	}
            },
            'Kyrgyzstan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bishkek'
            	}
            },
            'Laos' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Vientiane'
            	}
            },
            'Latvia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Liepaja',
    				'Riga',
    				'Ventspils'
            	}
            },
            'Lebanon' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Beirut',
    				'Sayda',
    				'Sur Tyre',
    				'Tripoli',
    				'Tripoli'
            	}
            },
            'Liberia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Monrovia'
            	}
            },
            'Libya' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Al Khums',
    				'Benghazi',
    				'Darnah',
    				'Marsa Al Burayqah',
    				'Marsa El Brega',
    				'Misurata',
    				'Ras Lanuf',
    				'Tobruk',
    				'Zuara'
            	}
            },
            'Lithuania' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Klaipeda',
    				'Vilnius'
            	}
            },
            'Luxembourg' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Luxembourg'
            	}
            },
            'Macedonia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Skopje'
            	}
            },
            'Madagascar' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Antsiranana Diego',
    				'Ehoala',
    				'Majunga',
    				'Nosy Be',
    				'Tamatave',
    				'Toamasina',
    				'Tulear',
    				'Vohemar'
            	}
            },
            'Malawi' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Blantyre',
    				'Lilongwe'
            	}
            },
            'Malaysia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bintulu','Ipoh','Johor Baharu','Kemaman','Kota Kinabalu','Kuala Lumpur','Kuala Selangor','Kuantan','Kuching','Labuan Sabah','Labuan',
					'Malacca','Miri','Panchang','Pasir Gudang','Penang','Port Kelang','Sandakan','Sibu','Tanjong Baran','Tanjong Mani','Tanjung Pelepas',
					'Tawau Sabah','Westport/Port Kelang'
            	}
            },
            'Maldives' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Male'
            	}
            },
            'Mali' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bamako',
    				'Segou'
            	}
            },
            'Malta' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Marsaxlokk',
    				'Valletta'
            	}
            },
            'Marshall Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Ebeye',
    				'Kwajalein',
    				'Majuro'
            	}
            },
            'Martinique' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Fort de France'
            	}
            },
            'Mauritania' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Nouadhibou',
    				'Nouakchott'
            	}
            },
            'Mauritius' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Port Louis'
            	}
            },
            'Mayotte' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Dzaoudzi',
    				'Longoni'
            	}
            },
            'Mexico' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'-'
            	},
   				'Aguascalientes' => new list<String> {
            		'Aguascalientes'
            	},
   				'Baja California' => new list<String> {
            		'Ensenada',
    				'Tijuana'
            	},
   				'Baja California Sur' => new list<String> {
            		'-'
            	},
   				'Campeche' => new list<String> {
            		'Campeche',
    				'Ciudad del Carmen'
            	},
   				'Chiapas' => new list<String> {
            		'Puerto Chiapas'
            	},
   				'Chihuahua' => new list<String> {
            		'Chihuahua'
            	},
   				'Ciudad de México' => new list<String> {
            		'Mexico City'
            	},
   				'Coahuila de Zaragoza' => new list<String> {
            		'-'
            	},
   				'Colima' => new list<String> {
            		'Manzanillo'
            	},
   				'Durango' => new list<String> {
            		'-'
            	},
   				'Guanajuato' => new list<String> {
            		'-'
            	},
   				'Guerrero' => new list<String> {
            		'Acapulco'
            	},
   				'Hidalgo' => new list<String> {
            		'-'
            	},
   				'Jalisco' => new list<String> {
            		'Guadalajara',
    				'Tuxpan'
            	},
   				'México' => new list<String> {
            		'Mexico'
            	},
   				'Michoacán de Ocampo' => new list<String> {
            		'Lazaro Cardenas'
            	},
   				'Morelos' => new list<String> {
            		'Puerto Morelos'
            	},
   				'Nayarit' => new list<String> {
            		'-'
            	},
   				'Nuevo León' => new list<String> {
            		'Monterrey',
    				'Santa Catarina'
            	},
   				'Oaxaca' => new list<String> {
            		'Salina Cruz'
            	},
   				'Puebla' => new list<String> {
            		'Puebla'
            	},
   				'Querétaro de Arteaga' => new list<String> {
            		'-'
            	},
   				'Quintana Roo' => new list<String> {
            		'Cancun',
    				'Cozumel'
            	},
   				'San Luis Potosí' => new list<String> {
            		'-'
            	},
   				'Sinaloa' => new list<String> {
            		'Mazatlan'
            	},
   				'Sonora' => new list<String> {
            		'Guaymas',
    				'Hermosillo'
            	},
   				'Tabasco' => new list<String> {
            		'Dos Bocas'
            	},
   				'Tamaulipas' => new list<String> {
            		'Altamira',
    				'Tampico'
            	},
   				'Tlaxcala' => new list<String> {
            		'-'
            	},
   				'Veracruz de Ignacio de la Llave' => new list<String> {
            		'Coatzacoalcos',
    				'Veracruz'
            	},
   				'Yucatán' => new list<String> {
            		'Merida',
    				'Progreso'
            	},
   				'Zacatecas' => new list<String> {
            		'-'
            	}
    		},
            'Moldova' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Chisinau',
    				'Tiraspol'
            	}
            },
            'Montenegro' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bar',
    				'Kotor',
    				'Podgorica',
    				'Tivat'
            	}
            },
            'Montserrat' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Plymouth'
            	}
            },
            'Morocco' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Agadir',
    				'Casablanca',
    				'Kenitra',
    				'Mohammedia',
    				'Nador',
    				'Safi',
    				'Tanger Med',
    				'Tangier'
            	}
            },
            'Mozambique' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Beira',
    				'Maputo',
    				'Nacala',
    				'Quelimane'
            	}
            },
            'Myanmar' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Ulaanbaatar'
            	}
            },
            'Namibia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Luderitz',
    				'Walvis Bay'
            	}
            },
            'Nauru' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Nauru Island'
            	}
            },
            'Netherland Antilles' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Curacao',
    				'Kralendijk, Bonaire',
    				'Philipsburg, St. Maarten',
    				'Saba',
    				'St. Eustatius',
    				'Willemstad, Curacao'
            	}
            },
            'Netherlands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Amsterdam',
    				'Delfzijl',
    				'Eemshaven',
    				'Ijmuiden',
    				'Moerdijk',
    				'Rotterdam',
    				'Schiedam',
    				'Terneuzen',
    				'Velsen',
    				'Venlo',
    				'Vlissingen'
            	}
            },
            'New Caledonia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Baie de Prony',
    				'Doniambo',
    				'Noumea',
    				'Prony',
    				'Vavouto'
            	}
            },
            'New Zealand' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Auckland','Bluff','Christchurch','Dunedin','Invercargill','Lyttelton','Marsden Point','Napier','Nelson','New Plymouth','Palmerston North',
					'Port Chalmers','Tauranga','Temuka','Timaru','Wellington','Whangarei'
            	}
            },
            'Nicaragua' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Corinto',
    				'Corn Island',
    				'El Bluff',
    				'Managua',
    				'Puerto Cabezas',
    				'Puerto Sandino',
    				'Rama'
            	}
            },
            'Niger' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Niamey'
            	}
            },
            'Nigeria' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Apapa',
    				'Calabar',
    				'Lagos',
    				'Onne',
    				'Port Harcourt',
    				'Sapele',
    				'Tin Can Island',
    				'Warri'
            	}
            },
            'Northern Mariana Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Saipan',
    				'Tinian'
            	}
            },
            'Norway' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Aalesund','Alvik','Austevoll','Bergen','Brevik','Drammen','Egersund','Floro','Fredrikstad','Fusa','Haavik','Halden','Hammerfest','Haugesund',
					'Heroya','Holla','Ikornnes','Knarrevik','Kristiansand','Kristiansund','Kvinesdal','Larvik','Lyngdal','Maloy','Mo I Rana','Molde','Mosjoen',
					'Moss','Narvik','Notos','Orkanger','Oslo','Porsgrunn','Rauma','Rauma','Salten','Sandnes','Sandnessjoen','Sauda','Skien','Stavanger','Svelgen',
					'Tananger','Trondheim','Ulsteinvik'
            	}
            },
            'Oman' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Matrah',
    				'Mina Al Fahl',
    				'Muscat',
    				'Port Qaboos',
    				'Port Sultan',
    				'Raysut',
    				'Salalah',
    				'Sohar'
            	}
            },
            'Pakistan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Faisalabad','Islamabad',
    				'Karachi',
    				'Lahore',
    				'Multan',
    				'Port Qasim',
    				'Qasim International',
    				'Sialkot'
            	}
            },
            'Palau' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Koror'
            	}
            },
            'Panama' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Almirante',
    				'Balboa',
    				'Chiriqui Grande',
    				'Chiriqui',
    				'Coco Solo',
    				'Colon',
    				'Cristobal',
    				'Cruce Canal de Panama',
    				'Las Minas',
    				'Manzanillo',
					'Panama City'
            	}
            },
            'Papua New Guinea' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Alotau',
    				'Bialla',
    				'Buka',
    				'Kavieng',
    				'Kieta',
    				'Kimbe',
    				'Lae',
    				'Lihir Island',
    				'Madang',
    				'Orobay',
    				'Port Moresby',
    				'Rabaul',
    				'Vanimo',
    				'Wewak'
            	}
            },
            'Paraguay' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Asuncion',
    				'Caacupe',
    				'Ciudad del Este',
    				'Fenix',
    				'Villeta'
            	}
            },
            'Peninsula de Macau' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Katmandu'
            	}
            },
            'Peru' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Callao',
    				'Chimbote',
    				'General San Martin',
    				'Ilo',
    				'Iquitos',
    				'Lima',
    				'Matarani',
    				'Paita',
    				'Pisco',
    				'Salaverry',
    				'San Nicolas'
            	}
            },
            'Philippines' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Batangas',
    				'Bugo','Cagayan de Oro','Cavite','Cebu','Cotabato','Davao','Diapitan','Dumaguete','General Santos','Iligan','Iloilo','Isabel',
					'Larena','Maasin','Manila North Harbour','Manila South Harbour','Manila','Palompon','Pulupandan','Sindangan','Subic','Surigao','Tagbilaran',
					'Zamboanga'
            	}
            },
            'Poland' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Gdansk',
    				'Gdynia',
    				'Katowice',
    				'Krakow',
    				'Lodz',
    				'Lublin',
    				'Poznan',
    				'Swinoujscie',
    				'Szczecin',
    				'Warsaw'
            	}
            },
            'Portugal' => new Map<String, List<String>>{
            	'-' => new list<String> {
					'Aveiro',
    				'Canical',
    				'Figueira Da Foz',
    				'Funchal, Madeira',
    				'Leixoes',
    				'Lisbon',
    				'Oporto',
    				'Ponta Delgada',
    				'Praia Da Vitoria',
    				'Setubal',
    				'Sines',
					'Viana Do Castelo'
            	}
            },
            'Principality of Monaco' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Monaco'
            	}
            },
            'Qatar' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Doha',
    				'Mesaieed',
    				'Ras Laffan',
    				'Umm Said'
            	}
            },
            'Republic of Djibouti' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Djibouti'
            	}
            },
            'Republic of Singapore' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Jurong',
    				'Singapore'
            	}
            },
            'Republic of the Congo' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Mutsamudu',
    				'Pointe Noire'
            	}
            },
            'Reunion Island' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Point des Galets',
    				'Port Reunion',
    				'St. Denis'
            	}
            },
            'Romania' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bucharest',
    				'Cluj-Napoca',
    				'Constanta',
    				'Timisoara'
            	}
            },
            'Russia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Anadyr','Archangelsk','Astrakhan','Bratsk','Chelyabinsk','Chita','De Kastri','Egvekinot','Irkutsk','Kaliningrad','Kazan','Khabarovsk',
					'Kholmsk','Komsomolsk Na Amure','Korsakov','Krasnodar','Krasnoyarsk','Kronshtadt','Magadan','Moscow','Murmansk','Nakhodka',
					'Nizhiy Novgorod','Novorossiysk','Novosibirsk','Omsk','Perm','Petropavlovsk-Kamchatskiy','Pevek','Port Beringovskiy',
					'Port Magadansky','Provideniya','Rostov Na Dona','Ryazan','Samara','Saratov','Smolensk','Sochi','St. Petersburg','Surgut',
					'Taganrog','Togliatti','Tomsk','Tver','Tyumen','Ufa','Ust Luga','Vanino','Vladivostok','Vostochny','Yaroslavl','Yekaterinburg'
            	}
            },
            'Rwanda' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Kigali'
            	}
            },
            'Saint Kitts And Nevis' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Guaynabo',
    				'Mayaguez',
    				'Ponce',
    				'San Juan'
            	}
            },
            'Samoa' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Apia Pago',
    				'Savaii'
            	}
            },
            'Sao Tome And Principe' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Sao Tome'
            	}
            },
            'Saudi Arabia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Dammam',
    				'Jeddah',
    				'Jizan',
    				'Jubail',
    				'Rabigh',
    				'Ras Tanura',
    				'Riyadh',
    				'Yanbu Al Bahr',
    				'Yanbu Industrial City'
            	}
            },
            'Senegal' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Dakar'
            	}
            },
            'Serbia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Belgrade',
    				'Pristina'
            	}
            },
            'Seychelles' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Mahe',
    				'Port Victoria',
    				'Victoria'
            	}
            },
            'Sierra Leone' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Freetown',
    				'Nitti'
            	}
            },
            'Slovakia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bratislava',
    				'Galanta'
            	}
            },
            'Slovenia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Koper',
    				'Ljubljana'
            	}
            },
            'Solomon Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Honiara',
    				'Noro'
            	}
            },
            'Somalia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Berbera',
    				'Mogadishu'
            	}
            },
            'South Africa' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bayhead','BelCon','BloemCon','Bloemfontein','Cape Town','Coega','Durban','East London','Giyani','Johannesburg',
					'KASERNE CONTAINER DEPOT','Phalaborwa','Polokwane','Port Of Ngqura','Pretoria Container Terminal','Richards Bay','Saldhana Bay','Tzaneen'
            	}
            },
            'South Korea' => new Map<String, List<String>>{
            	'-' => new list<String> {
					'Busan','Daegu','Dangjin-Gun','Donghae','Geoje','Gunsan','Gwangju','Gwangyang','Incheon','Jinhae','Kwangyang','Masan','Mokpo','Onsan',
					'Pohang','Pyeongtaek','Seoul','Ulsan','Yeosu'
            	}
            },
            'Spain' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Algeciras','Alicante','Almeria','Arrecife','Aviles','Barcelona','Bilbao','Cadiz','Campllong','Castellon','Ceuta','Ferrol','Gandia','Gijon',
					'Huelva','Ibiza','La Coruna','Las Palmas, Canary Islands','Madrid','Malaga','Marin','Melilla','Motril','Palamos','Palma de Mallorca','Pasajes',
					'Puerto de Sagunto','Puerto de Sevilla','Puerto del Rosario','Rota','Rota','Sagunto','Santa Cruz de La Palma','Santander','Sevilla',
					'Tarragona','Valencia','Vigo','Vilanova I La Geltru','Villagarcia de Arousa'
            	}
            },
            'Sri Lanka' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Colombo',
    				'Galle'
            	}
            },
            'St. Lucia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Castries',
    				'Vieux Fort'
            	}
            },
            'St. Vincent & the Grenadines' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Kingstown',
    				'Mustique',
    				'Port Elizabeth',
    				'St. Vincent'
            	}
            },
            'Sudan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Port Sudan'
            	}
            },
            'Suriname' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Paramaribo',
    				'Smalkalden'
            	}
            },
            'Sweden' => new Map<String, List<String>>{
            	'-' => new list<String> {
					'Ahus','Gavle','Gothenburg','Halmstad','Haraholmen','Helsingborg','Hisings Backa','Holmsund','Malmo','Monsteras','Norrkoping','Oskarshamn',
					'Oxelosund','Sodertalje','Stockholm','Sundsvall','Tunadal','Uddevalla','Varberg','Vasteras','Wallhamn'
            	}
            },
            'Switzerland' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Basel',
    				'Fribourg',
    				'Geneva',
    				'Lausanne',
    				'Zurich'
            	}
            },
            'Syria' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Aleppo',
    				'Damascus',
    				'Latakia',
    				'Tartus'
            	}
            },
            'Taiwan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Hsin-Chu',
    				'Kaohsiung',
    				'Keelung',
    				'Mai-Liao',
    				'Taichung',
    				'Taipei',
    				'Taoyuan'
            	}
            },
            'Tajikistan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Dushanbe'
            	}
            },
            'Tanzania' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Dar Es Salaam',
    				'Pemba',
    				'Pemba',
    				'Tanga',
    				'Zanzibar'
            	}
            },
            'Territory of Norfolk Island' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Norfolk Island'
            	}
            },
            'Thailand' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Ban Map Ta Phut',
    				'Bangkok',
    				'Bangpakong',
    				'Koh Sichang',
    				'Laem Chabang',
    				'Lat Krabang',
    				'Paknam',
    				'Phuket',
    				'Rayong',
    				'Samut Prakarn',
            		'Siam Container Terminal',
    				'Songkhla',
    				'Sri Racha'
            	}
            },
            'Timor-Leste' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Dili',
    				'Kupang'
            	}
            },
            'Togo' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Lome'
            	}
            },
            'Tonga' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Nukualofa',
    				'Vava`u'
            	}
            },
            'Trinidad & Tobago' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Chaguaramas',
    				'La Brea',
    				'Point Galeota',
    				'Point Lisas',
    				'Pointe A Pierre',
    				'Port Of Spain',
    				'Scarborough'
            	}
            },
            'Tunisia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bizerte',
    				'Gabes',
    				'La Goulette',
    				'Rades',
    				'Sfax',
    				'Sousse',
    				'Tunis',
    				'Zarzis'
            	}
            },
            'Turkey' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Aliaga','Ambarli','Antalya','Avcilar','Canakkale','Derince','Diliskelesi','Eregli','Evyapan','Gebiz','Gebze','Gemlik','Gulluk','Haydarpasa',
					'Inebolu','Iskenderun','Istanbul','Izmir','Izmit','Korfezi','Kumport','Limas','Mardas','Marmaris','Marport','Mersin','Samsun','Tekirdag',
					'Trabzon','Yenikoy','Yilport','Zonguldak'
            	}
            },
            'Turkmenistan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Ashkhabad',
    				'Turkmenbashi'
            	}
            },
            'Turks & Caicos' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Grand Turk Island',
    				'North Caicos',
    				'Providenciales',
    				'South Caicos'
            	}
            },
            'Tuvalu' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Funafuti'
            	}
            },
            'U.S. Virgin Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Charlotte Amalie','Christiansted, St. Croix','Cruz Bay, St. John','Frederiksted, St. Croix','Port Alucroix, St. Croix','St. Croix',
					'St. John, St. Croix','St. Thomas'
            	}
            },
            'Uganda' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Entebbe',
    				'Kampala',
    				'Mbarara'
            	}
            },
            'Ukraine' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Dnepropetrovsk',
    				'Ilichevsk',
    				'Kiev',
    				'Lviv',
    				'Mariupol',
    				'Nikolayev',
    				'Odessa',
    				'Sevastopol',
    				'Simferopol',
    				'Yuzhnyy'
            	}
            },
            'United Arab Emirates' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Abu Dhabi','Ajman','Al Fujayrah','Al Hamriyah','Dubai','Fujairah','Jebel Ali','Khor Fakkan','Mina Saqr','Port Rashid','Ras Al Khaimah',
					'Sharjah','Umm Al Qaiwain'
            	}
            },
            'United Kingdom' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Aberdeen, Scotland','Belfast, Northern Ireland','Birkenhead, England','Birmingham, England','Bristol, England','Cardiff, England',
					'Daventry, England','Dover, England','Dundee, England','East Grinstead, England','Edinburgh, Scotland','Ellesmere, England','Falmouth, England',
					'Felixstowe, England','Glasgow, Scotland','Goole, England','Grangemouth, Scotland','Great Yarmouth, England','Greenock, Scotland',
					'Gunness, Scotland','Hartlepool, England','Harwich, England','Hull, England','Immingham, England','Invergordon, England','Inverness, Scotland',
					'Leeds, England','Leith, Scotland','Liverpool, England','London, England','Manchester, England','Middlesbrough, England','Montrose, Scotland',
					'Newcastle, England','Newport, England','Northfleet, England','Peterhead, England','Portbury, England','Portsmouth, England',
					'Rochester, England','Sheerness, England','South Shields, England','Southampton, England','Teesport, England','Thamesport, England',
					'Tilbury, England','Warrenpoint, Northern Ireland'
            	}
            },
            'United States' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'-'
            	},
   				'Alabama' => new list<String> {
            		'Birmingham, Alabama',
    				'Huntsville, Alabama',
    				'Mobile, Alabama'
            	},
   				'Alaska' => new list<String> {
   					'Anchorage, Alaska',
    				'Cordova, Alaska',
    				'Craig, Alaska',
    				'Dutch Harbor, Alaska',
    				'Excursion Inlet, Alaska',
    				'Fairbanks, Alaska',
   					'Haines, Alaska',
    				'Hawk Inlet, Alaska',
    				'Hoonah, Alaska',
    				'Juneau, Alaska',
    				'Kake, Alaska',
    				'Kenai, Alaska',
    				'Ketchikan, Alaska',
					'Klawock, Alaska',
    				'Kodiak, Alaska',
    				'Petersburg, Alaska',
    				'Seward, Alaska',
    				'Sitka, Alaska',
    				'Skagway, Alaska',
    				'Thorne Bay, Alaska',
					'Valdez, Alaska',
    				'Whittier, Alaska',
    				'Wrangell, Alaska'
				},
   				'Arizona' => new list<String> {
            		'Phoenix, Arizona'
            	},
   				'Arkansas' => new list<String> {
            		'Fort Smith, Arkansas',
    				'Little Rock, Arkansas',
    				'Pine Bluff, Arkansas'
            	},
   				'California' => new list<String> {
   					'Benicia, California',
    				'Costa Mesa, California',
    				'Eureka, California',
    				'Long Beach, California',
    				'Los Angeles, California',
					'Oakland, California',
    				'Port Hueneme, California',
    				'Rancho Dominguez, California',
    				'Richmond, California',
    				'Sacramento, California',
					'San Diego, California',
    				'San Francisco, California',
    				'San Pedro, California',
    				'Santa Ana, California',
    				'Stockton, California'
				},
   				'Colorado' => new list<String> {
            		'Denver, Colorado'
            	},
   				'Connecticut' => new list<String> {
            		'Bridgeport, Connecticut',
    				'New Haven, Connecticut',
    				'New London, Connecticut'
            	},
   				'South Dakota' => new list<String> {
            		'-'
            	},
   				'Delaware' => new list<String> {
            		'Wilmington, Delaware'
            	},
   				'District of Columbia' => new list<String> {
            		'Washington, District Of Columbia'
            	},
   				'Florida' => new list<String> {
   					'Fernandina Beach, Florida',
    				'Fort Lauderdale, Florida',
    				'Fort Pierce, Florida',
    				'Hialeah, Florida',
    				'Jacksonville, Florida',
					'Miami River, Florida',
    				'Miami, Florida',
    				'Orlando, Florida',
    				'Palm Beach, Florida',
    				'Panama City, Florida',
    				'Pensacola, Florida',
					'Port Canaveral, Florida',
    				'Port Dania, Florida',
    				'Port Everglades, Florida',
    				'Port Manatee, Florida',
    				'St. Joe, Florida',
					'St. Petersburg, Florida',
    				'Tampa, Florida',
    				'West Palm Beach, Florida'
   				},
   				'Georgia' => new list<String> {
            		'Atlanta, Georgia',
    				'Brunswick, Georgia',
    				'Savannah, Georgia'
            	},
   				'Hawaii' => new list<String> {
   					'Hilo, Hawaii',
    				'Honolulu, Hawaii',
    				'Kahului, Hawaii',
    				'Kailua Kona, Hawaii',
    				'Kaunakakai, Hawaii',
    				'Kawaihae, Hawaii',
    				'Lanai City, Hawaii',
					'Nawiliwili, Hawaii'
				},
   				'Idaho' => new list<String> {
            		'-'
            	},
   				'Illinois' => new list<String> {
            		'Chicago, Illinois',
    				'Evansville, Illinois',
    				'Peoria, Illinois'
            	},
   				'Indiana' => new list<String> {
            		'Burns Harbor, Indiana',
    				'Fort Wayne, Indiana',
    				'Indianapolis, Indiana',
    				'South Bend, Indiana'
            	},
   				'Iowa' => new list<String> {
            		'Des Moines, Iowa'
            	},
   				'Kansas' => new list<String> {
            		'Kansas City, Kansas'
            	},
   				'Kentucky' => new list<String> {
            		'Georgetown, Kentucky',
    				'Lexington, Kentucky',
    				'Louisville, Kentucky'
            	},
   				'Louisiana' => new list<String> {
   					'Baton Rouge, Louisiana',
    				'La Place, Louisiana',
    				'Lake Charles, Louisiana',
    				'New Orleans, Louisiana',
    				'Port Allen, Louisiana',
					'Port Bienville, Louisiana',
    				'Port Fourchon, Louisiana',
    				'St. Bernard, Louisiana'
				},
   				'Maine' => new list<String> {
            		'Eastport, Maine',
    				'Portland, Maine'
            	},
   				'Maryland' => new list<String> {
            		'Baltimore, Maryland'
            	},
   				'Massachusetts' => new list<String> {
   					'Baltimore, Maryland',
    				'Ayer, Massachusetts',
    				'Boston, Massachusetts',
    				'Gloucester, Massachusetts',
    				'Quincy, Massachusetts',
   					'Worcester, Massachusetts'
   				},
   				'Michigan' => new list<String> {
            		'Detroit, Michigan',
    				'Livonia, Michigan'
            	},
   				'Minnesota' => new list<String> {
   					'Dilworth, Minnesota',
    				'Duluth, Minnesota',
    				'Minneapolis, Minnesota',
    				'Minnetonka, Minnesota',
    				'St. Paul, Minnesota'
   				},
   				'Mississippi' => new list<String> {
            		'Gulfport, Mississippi',
    				'Natchez, Mississippi',
    				'Pascagoula, Mississippi',
    				'Vicksburg, Mississippi'
            	},
   				'Missouri' => new list<String> {
            		'Kansas City, Missouri',
    				'St. Louis, Missouri'
            	},
   				'Montana' => new list<String> {
            		'-'
            	},
   				'Nebraska' => new list<String> {
            		'Omaha, Nebraska'
            	},
   				'Nevada' => new list<String> {
            		'Las Vegas, Nevada'
            	},
   				'New Jersey' => new list<String> {
					'Bayonne, New Jersey','Camden, New Jersey','Jamesburg, New Jersey','Newark, New Jersey','North Bergen, New Jersey','Pennsauken, New Jersey',
					'Port Elizabeth, New Jersey','South Kearny, New Jersey'
				},
   				'New York' => new list<String> {
   					'Albany, New York','Brooklyn, New York','Buffalo, New York','New Hyde Park, New York','New York, New York','Rochester, New York',
					'Syracuse, New York'
				},
   				'New Hampshire' => new list<String> {
            		'-'
            	},
   				'New Mexico' => new list<String> {
            		'-'
            	},
   				'North Carolina' => new list<String> {
   					'Charlotte, North Carolina',
    				'Morehead City, North Carolina',
    				'Sunny Point, North Carolina',
    				'Wilmington, North Carolina'
   				},
   				'North Dakota' => new list<String> {
            		'Fargo, North Dakota'
            	},
   				'Ohio' => new list<String> {
   					'Cincinnati, Ohio',
    				'Cleveland, Ohio','Columbus, Ohio','Dayton, Ohio','Groveport, Ohio','Independence, Ohio','Marysville, Ohio',
					'New Albany, Ohio','Toledo, Ohio'
   				},
   				'Oklahoma' => new list<String> {
            		'Tulsa, Oklahoma'
            	},
   				'Oregon' => new list<String> {
            		'Portland, Oregon',
    				'Salem, Oregon'
            	},
   				'Pennsylvania' => new list<String> {
            		'Chester, Pennsylvania',
    				'Mt. Pocono, Pennsylvania',
    				'Philadelphia, Pennsylvania',
    				'Pittsburgh, Pennsylvania'
            	},
   				'Rhode Island' => new list<String> {
            		'Newport, Rhode Island',
    				'Providence, Rhode Island',
    				'Quonset Point, Rhode Island'
            	},
   				'South Carolina' => new list<String> {
            		'Charleston, South Carolina',
    				'Georgetown, South Carolina'
            	},
   				'Tennessee' => new list<String> {
            		'Henderson, Tennessee',
    				'Memphis, Tennessee',
    				'Nashville, Tennessee'
            	},
   				'Texas' => new list<String> {
   					'Austin, Texas','Beaumont, Texas','Brownsville, Texas','Comfort, Texas','Corpus Christi, Texas','Dallas, Texas','El Paso, Texas',
					'Fort Worth, Texas','Galveston, Texas','Houston, Texas','Laredo, Texas','Orange, Texas','Port Arthur, Texas','Port Freeport, Texas',
					'Port Isabel, Texas','San Antonio, Texas','Texas City, Texas'
				},
   				'Utah' => new list<String> {
            		'Salt Lake City, Utah'
            	},
   				'Vermont' => new list<String> {
            		'-'
            	},
   				'Virginia' => new list<String> {
   					'Arlington, Virginia','Chesapeake, Virginia','Newport News, Virginia','Norfolk, Virginia','Portsmouth, Virginia','Richmond, Virginia',
					'Virginia Beach, Virginia'
				},
   				'West Virginia' => new list<String> {
            		'-'
            	},
   				'Washington' => new list<String> {
   					'Everett, Washington','Grays Harbor, Washington','Kalama, Washington','Longview, Washington','Olympia, Washington','Seattle, Washington',
					'Tacoma, Washington','Vancouver, Washington'
				},
   				'Wisconsin' => new list<String> {
            		'Milwaukee, Wisconsin'
            	},
   				'Wyoming' => new list<String> {
            		'-'
            	}
    		},
            'Uruguay' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Montevideo',
    				'Nueva Palmira',
    				'Punta del Este'
            	}
            },
            'Uzbekistan' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Tashkent'
            	}
            },
            'Vanuatu' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Espiritu Santo',
    				'Port Vila',
    				'Santo'
            	}
            },
            'Venezuela' => new Map<String, List<String>>{
            	'-' => new list<String> {
					'Barquisimeto','Caracas','Carupano','Ciudad Bolivar','El Guamache','El Tablazo','Guanta','Guaranao','Guiria','Guyana City','Jose','La Guaira',
					'Maracaibo','Matanzas','Matanzas','Orinoco','Palua','Porlamar','Puerto Cabello','Puerto Ordaz','Puerto Sucre','Punta Cardon','Punto Fijo',
					'San Felix','San Lorenzo'
            	}
            },
            'Vietnam' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Ben Nghe','Cai Lan','Cai Mep','Can Tho','Cat Lai','Da Nang','Dinh Vu Terminal','Doan Xa Port','Haiphong','Hanoi','Hiep Phuoc Port',
					'Ho Chi Minh City','Ho Chi Minh Vict','Nha Trang','Phu My','Phuoc Long','Qui Nhon','Tan Cang','Tan Thuan Dong','Transimex','Vung Tau'
            	}
            },
            'Wallis & Futuna Islands' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Futuna Island Apt',
    				'Wallis Island Apt'
            	}
            },
            'Yemen' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Aden',
    				'Hodeidah',
    				'Mokha',
    				'Mukalla',
    				'Saleef'
            	}
            },
            'Zambia' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Kitwe'
            	}
            },
            'Zimbabwe' => new Map<String, List<String>>{
            	'-' => new list<String> {
            		'Bulawayo',
    				'Lusaka'
            	}
            }
    	};


		List<Country__c> query_country = [select Name, Id from Country__c];
        Map<String, Id> map_country = new Map<String, Id>();
        for(Country__c co: query_country){
            map_country.put(co.Name, co.Id);
        }
        
        List<State__c> query_state = [select Name, Id, Country__r.Name from State__c];
        Map<String, Id> map_state = new Map<String, Id>();
        for(State__c st: query_state){
            map_state.put(st.Country__r.Name+'-'+st.Name, st.Id);
        }
        
        List<Location__c> query_locations= [select Id, Name from Location__c];
        Map<string,Location__c> map_locations = new Map<string,Location__c>();
        for(Location__c co: query_locations)
        {
            map_locations.put(co.Name, co);
        }
        
        List<Location__c> list_location = new List<Location__c>();
		for (String country : map_locations_states_countries.keySet()) {
   			for (String state : map_locations_states_countries.get(country).keySet()) {
   				for(String location : map_locations_states_countries.get(country).get(state)){
   					if(query_locations != null && query_locations.size()>0){
   						if (location != '-'){
                    		if(map_locations.containskey(location) == false){
		   						Location__c nueva_localizacion = new Location__c();
		   						nueva_localizacion.Name = location;
		   						if (country != '-'){
		   							nueva_localizacion.Country__c =  map_country.get(country);
		  							if (state != '-'){
		   								nueva_localizacion.State__c =  map_state.get(country+'-'+state);
		   							}
		   						}
		   						list_location.add(nueva_localizacion);
		   					}
                    	}
   					}else{
   						if (location != '-'){
	   						Location__c nueva_localizacion = new Location__c();
	   						nueva_localizacion.Name = location;
	   						if (country != '-'){
	   							nueva_localizacion.Country__c =  map_country.get(country);
	  							if (state != '-'){
	   								nueva_localizacion.State__c =  map_state.get(country+'-'+state);
	   							}
	   						}
	   						list_location.add(nueva_localizacion);
	   					}
   					}
   				}
   			}
		}

        /*List<Location__c> list_location = new List<Location__c>();
        List<Country__c> query_country = [select Name, Id from Country__c];
        Map<String, Id> map_country = new Map<String, Id>();
        for(Country__c co: query_country)
        {
            map_country.put(co.Name, co.Id);
        }
        
        List<Location__c> query_locations= [select Id, Name from Location__c];
        Map<string,Location__c> map_locations = new Map<string,Location__c>();
        for(Location__c co: query_locations)
        {
            map_locations.put(co.Name, co);
        }
        
        for(integer counter = 0; counter<names.size(); counter++)
        {
            if(map_country.get(countries[counter]) != null)
            {
                if(query_locations != null && query_locations.size()>0)
                {
                    if(map_locations.containskey(names[counter]) == false)
                    {
                        Location__c nueva_localizacion = new Location__c();
                        nueva_localizacion.Name = names[counter];
                        nueva_localizacion.Country__c =  map_country.get(countries[counter]);
                        list_location.add(nueva_localizacion);
                    }
                }
                else
                {
                    Location__c nueva_localizacion = new Location__c();
                    nueva_localizacion.Name = names[counter];
                    nueva_localizacion.Country__c =  map_country.get(countries[counter]);
                    list_location.add(nueva_localizacion);
                }
            }
        }*/
        
        insert list_location;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, string.valueof(list_location.size())+' Locations inserted'));
        /*List<Location__c> listado_localizaciones = new List<Location__c>();
        List<Country__c> lista_paises = [select id, Name from Country__c ];
        for(Country__c co:lista_paises)
        {
        	if (co.Name != 'United States' && co.Name != 'Mexico'){
        		Location__c nueva_localizacion = new Location__c();
            	nueva_localizacion.Name = 'Other';
            	nueva_localizacion.Country__c  = co.Id;
            	listado_localizaciones.add(nueva_localizacion);
        	}
        }
        List<State__c> lista_estados = [select id, Name, Country__r.Id from State__c ];
        for(State__c co:lista_estados)
        {
       		Location__c nueva_localizacion = new Location__c();
           	nueva_localizacion.Name = 'Other';
           	nueva_localizacion.Country__c  = co.Country__r.Id;
           	nueva_localizacion.State__c  = co.Id;
           	listado_localizaciones.add(nueva_localizacion);
        }
        
        insert listado_localizaciones;*/
    }
}