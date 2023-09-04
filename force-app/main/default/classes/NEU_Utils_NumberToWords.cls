public with sharing class NEU_Utils_NumberToWords {

    public static String english_currency(Decimal val){
        if(val<0)
            val=-1*val;
        Integer parteEntera = val.intValue();
        Integer parteDecimal = ((val - val.intValue())*100).intValue();
        return english_number(parteEntera) + ' with ' + english_number(parteDecimal);
    }

    public static String spanish_currency(Decimal val){
        Integer parteEntera = val.intValue();
        Integer parteDecimal = ((val - val.intValue())*100).intValue();
        return spanish_number(parteEntera) + ' con ' + spanish_number(parteDecimal);
    }


    // Métodos privados

    /* INGLÉS-ENGLISH */

    static String[] to_19 = new string[]{'zero','One','Two','Three','Four','Five','Six','Seven','Eight',
            'Nine','Ten','Eleven','Twelve','Thirteen','Fourteen', 'Fifteen',
            'Sixteen','Seventeen','Eighteen','Nineteen'};

    static String[] tens = new string[]{'Twenty','Thirty','Forty','Fifty','Sixty','Seventy','Eighty','Ninety'};

    static string[] denom = new string[]{'','Thousand','Million','Billion','trillion','quadrillion',
            'quintillion', 'sixtillion','septillion','octillion','nonillion',
            'decillion','undecillion','duodecillion','tredecillion',
            'quattuordecillion','sixdecillion','septendecillion','octodecillion',
            'novemdecillion','vigintillion'};

    private static string convert_nn(integer val) {
        if (val < 20)
            return to_19[val];
        if (val == 100)
            return 'One Hundred';
        for (integer v = 0; v < tens.size(); v++) {
            String dcap = tens[v];
            integer dval = 20 + 10 * v;
            if (dval + 10 > val) {
                if (Math.Mod(val,10) != 0)
                    return dcap + ' ' + to_19[Math.Mod(val,10)];
                return dcap;
            }
        }
        return 'Should never get here, less than 100 failure';
    }

    private static String convert_nnn(integer val) {
        string word = '';
        integer rem = val / 100;
        integer mod = Math.mod(val,100);
        if (rem > 0) {
            word = to_19[rem] + ' Hundred and';
            if (mod > 0) {
                word += ' ';
            }
        }
        if (mod > 0) {
            word += convert_nn(mod);
        }
        return word;
    }

    private static String english_number(long val) {
        if (val < 100) {
            return convert_nn(val.intValue());
        }
        if (val < 1000) {
            return convert_nnn(val.intValue());
        }
        for (integer v = 0; v < denom.size(); v++) {
            integer didx = v - 1;
            integer dval = (integer)Math.pow(1000, v);
            if (dval > val) {
                integer mod = (integer)Math.pow(1000, didx);
                integer l = (integer) val / mod;
                integer r = (integer) val - (l * mod);
                String ret = convert_nnn(l) + ' ' + denom[didx];
                if (r > 0) {
                    ret += ', ' + english_number(r);
                }
                return ret;
            }
        }
        return 'Should never get here, bottomed out in english_number';
    }



    /* ESPAÑOL-SPANISH */

    // En desarrollo...
    // https://es.wikipedia.org/wiki/Anexo:Nombres_de_los_n%C3%BAmeros_en_espa%C3%B1ol

    static String[] hasta_29 = new string[]{'Cero','Uno','Dos','Tres','Cuatro','Cinco','Seis','Siete',
            'Ocho','Nueve','Diez','Once','Doce','Trece','Catorce',
            'Quince','Dieciséis','Diecisiete','Dieciocho','Diecinueve',
            'Veinte','Veintiuno','Veintidós','Veintitrés','Veinticuatro',
            'Veinticinco','Veintiséis','Veintisiete','Veintiocho',
            'Veintinueve','Treinta','Cuarenta','Cincuenta','Sesenta','Setenta','Ochenta',
            'Noventa'};

    static String[] decenas = new string[]{'Treinta','Cuarenta','Cincuenta','Sesenta','Setenta','Ochenta',
            'Noventa'};

    static String[] centenas = new string[]{'','Ciento','Doscientos','Trescientos','Cuatrocientos','Quinientos',
            'Seiscientos','Setecientos','Ochocientos','Novecientos'};


    static string[] denominadores = new string[]{'','Mil','Millones','Billones','Trillones'};


    private static string convertir_nn(integer val) {
        if (val < 30)
            return hasta_29[val];
        if (val == 100)
            return 'Cien';
        for (integer v = 0; v < decenas.size(); v++) {
            String dcap = decenas[v];
            integer dval = 30 + 10 * v;
            if (dval + 10 > val) {
                if (Math.Mod(val,10) != 0)
                    return dcap + ' y ' + hasta_29[Math.Mod(val,10)];
                return dcap;
            }
        }
        return 'Error en número menor de 100';
    }

    private static String convertir_nnn(integer val) {
        string word = '';
        integer rem = val / 100;
        integer mod = Math.mod(val,100);
        if (rem > 0) {
            word = centenas[rem];
            if (mod > 0) {
                word += ' ';
            }
        }
        if (mod > 0) {
            word += convertir_nn(mod);
        }
        return word;
    }

    private static String spanish_number(long val) {
        if (val < 100) {
            return convertir_nn(val.intValue());
        }
        if (val < 1000) {
            return convertir_nnn(val.intValue());
        }
        for (integer v = 0; v < denominadores.size(); v++) {
            integer didx = v - 1;
            integer dval = (integer)Math.pow(1000, v);
            if (dval > val) {
                integer mod = (integer)Math.pow(1000, didx);
                integer l = (integer) val / mod;
                integer r = (integer) val - (l * mod);
                String ret;
                if(l>1){
                    ret = convertir_nnn(l) + ' ' + denominadores[didx];
                }else{
                    if(didx==2){
                        ret = 'Un millón';
                    }else if(didx==3){
                        ret = 'Un billón';
                    }else{
                        ret = denominadores[didx];
                    }
                }
                if (r > 0) {
                    ret += ' ' + spanish_number(r);
                }
                return ret;
            }
        }
        return 'Error en spanish_number';
    }
}