global class PAK_TotFacMes {
    global class status{
        webservice String code {get;set;}
        webservice String message {get;set;}
    }
    
    global class Plaza{
        webservice String plazaYear {get;set;}
        webservice String totalEne {get;set;}
        webservice String totalFeb {get;set;}
        webservice String totalMar {get;set;}
        webservice String totalAbr {get;set;}
        webservice String totalMay {get;set;}
        webservice String totalJun {get;set;}
        webservice String totalJul {get;set;}
        webservice String totalAgo {get;set;}
        webservice String totalSep {get;set;}
        webservice String totalOct {get;set;}
        webservice String totalNov {get;set;}
        webservice String totalDic {get;set;}
    }
    
    webservice static List<status> updateTotalFacturadoMes(List<Plaza> plazas){
        System.debug('PAK_TotFacMes *** Cuentas: ' + plazas);
        List<status> results = new List<status>();
        Set<String> plazasYear = new Set<String>();
        Map<String, Sales_Target__c> mapExistPy = new Map<String, Sales_Target__c>(); 
        for(Plaza c : plazas){
            if(!plazasYear.contains(c.plazaYear)){
                plazasYear.add(c.plazaYear);
            }
        }
        System.debug('PAK_TotFacMes *** SetPlazas: ' + plazasYear);
        List<Sales_Target__c> targets = [SELECT Id, Name, Year__c, INV_Ene__c, INV_Feb__c, INV_Mar__c, INV_Abr__c, INV_May__c, INV_Jun__c, INV_Jul__c, INV_Ago__c, INV_Sep__c, INV_Oct__c, INV_Nov__c, INV_Dic__c 
                                         FROM Sales_Target__c 
                                         WHERE Name IN:plazasYear];
        System.debug('PAK_TotFacMes *** TargetsQuery: ' + targets);
        for(Sales_Target__c t : targets){
            mapExistPy.put(t.Name, t);
        }  
        System.debug('PAK_TotFacMes *** MapPlazaTarget: ' + mapExistPy);
        for(Plaza c : plazas){
            try{
                if(mapExistPy.containsKey(c.plazaYear)){
                    Sales_Target__c target = mapExistPy.get(c.plazaYear);
                    if(c.totalEne != null && c.totalEne != ''){target.INV_Ene__c = decimal.valueOf(c.totalEne);}
                    if(c.totalFeb != null && c.totalFeb != ''){target.INV_Feb__c = decimal.valueOf(c.totalFeb);}
                    if(c.totalMar != null && c.totalMar != ''){target.INV_Mar__c = decimal.valueOf(c.totalMar);}
                    if(c.totalAbr != null && c.totalAbr != ''){target.INV_Abr__c = decimal.valueOf(c.totalAbr);}
                    if(c.totalMay != null && c.totalMay != ''){target.INV_May__c = decimal.valueOf(c.totalMay);}
                    if(c.totalJun != null && c.totalJun != ''){target.INV_Jun__c = decimal.valueOf(c.totalJun);}
                    if(c.totalJul != null && c.totalJul != ''){target.INV_Jul__c = decimal.valueOf(c.totalJul);}
                    if(c.totalAgo != null && c.totalAgo != ''){target.INV_Ago__c = decimal.valueOf(c.totalAgo);}
                    if(c.totalSep != null && c.totalSep != ''){target.INV_Sep__c = decimal.valueOf(c.totalSep);}
                    if(c.totalOct != null && c.totalOct != ''){target.INV_Oct__c = decimal.valueOf(c.totalOct);}
                    if(c.totalNov != null && c.totalNov != ''){target.INV_Nov__c = decimal.valueOf(c.totalNov);}
                    if(c.totalDic != null && c.totalDic != ''){target.INV_Dic__c = decimal.valueOf(c.totalDic);}
                    update target;
                    status st = new status(); st.code = '1'; st.message = c.plazaYear + ' actualizado correctamente';	
                    results.add(st);
                }else{
                    Sales_Target__c target = new Sales_Target__c();
                    target.Name = c.plazaYear;
                    target.Year__c = c.plazaYear.substringAfter('-');
                    if(c.totalEne != null && c.totalEne != ''){target.INV_Ene__c = decimal.valueOf(c.totalEne);}
                    if(c.totalFeb != null && c.totalFeb != ''){target.INV_Feb__c = decimal.valueOf(c.totalFeb);}
                    if(c.totalMar != null && c.totalMar != ''){target.INV_Mar__c = decimal.valueOf(c.totalMar);}
                    if(c.totalAbr != null && c.totalAbr != ''){target.INV_Abr__c = decimal.valueOf(c.totalAbr);}
                    if(c.totalMay != null && c.totalMay != ''){target.INV_May__c = decimal.valueOf(c.totalMay);}
                    if(c.totalJun != null && c.totalJun != ''){target.INV_Jun__c = decimal.valueOf(c.totalJun);}
                    if(c.totalJul != null && c.totalJul != ''){target.INV_Jul__c = decimal.valueOf(c.totalJul);}
                    if(c.totalAgo != null && c.totalAgo != ''){target.INV_Ago__c = decimal.valueOf(c.totalAgo);}
                    if(c.totalSep != null && c.totalSep != ''){target.INV_Sep__c = decimal.valueOf(c.totalSep);}
                    if(c.totalOct != null && c.totalOct != ''){target.INV_Oct__c = decimal.valueOf(c.totalOct);}
                    if(c.totalNov != null && c.totalNov != ''){target.INV_Nov__c = decimal.valueOf(c.totalNov);}
                    if(c.totalDic != null && c.totalDic != ''){target.INV_Dic__c = decimal.valueOf(c.totalDic);}
                    insert target;
                    status st = new status(); st.code = '1'; st.message = c.plazaYear + ' insertado correctamente';	
                    results.add(st);
                }
            }catch(Exception e){status st = new status(); st.code = '0'; st.message = c.plazaYear + '- Error: ' + e.getCause() +' '+ e.getMessage() +' '+ e.getLineNumber();results.add(st);}
        }
        System.debug('PAK_TotFacMes *** Results: ' + results);
        return results;
    }
}