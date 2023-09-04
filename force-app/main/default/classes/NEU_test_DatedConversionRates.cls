/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class NEU_test_DatedConversionRates 
{
    static testMethod void test_DatedConversionRates() 
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        //Mock
        /*Test.startTest();
        HttpClassMock mock = new HttpClassMock();
        Test.setMock(HttpCalloutMock.class , mock);
        mock.tipo = 'banxico';*/

        CSL_Credentials__c new_credentials = new CSL_Credentials__c();
        new_credentials.Name = 'Conversion Rates';
        new_credentials.Login__c = '';
        new_credentials.Password__c = '';
        insert new_credentials;

        NEU_DatedConversionRates.update_data();
        NEU_DatedConversionRates.enviarNotificacion('','');
    }

    static testMethod void test_DatedConversionRates2()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        NEU_DatedConversionRates.update_data();
    }

    //HTTPCLASSMOCK
    public class HttpClassMock implements HttpCalloutMock
    {
        public string tipo;

        public System.HttpResponse respond(System.HttpRequest request)
        {
            //BANXICO
            if(tipo == 'banxico')
            {
                string response_banxico = '';
                response_banxico += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
                response_banxico += '<soapenv:Body>';
                response_banxico += '<ns1:tiposDeCambioBanxicoResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://ws.dgie.banxico.org.mx">';
                response_banxico += '<result xsi:type="xsd:string"><![CDATA[<?xml version="1.0" encoding="ISO-8859-1"?>';
                response_banxico += '<CompactData xmlns="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" xmlns:bm="http://www.banxico.org.mx/structure/key_families/dgie/sie/series/compact" xmlns:compact="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message SDMXMessage.xsd http://www.banxico.org.mx/structure/key_families/dgie/sie/series/compact BANXICO_DGIE_SIE_Compact.xsd http://www.SDMX.org/resources/SDMXML/schemas/v1_0/compact SDMXCompactData.xsd" >';
                response_banxico += '<Header>';
                response_banxico += '<ID>TIPOSDECAMBIO</ID>';
                response_banxico += '<Test>false</Test>';
                response_banxico += '<Truncated>false</Truncated>';
                response_banxico += '<Name xml:lang="sp">Tipos de Cambio</Name>';
                response_banxico += '<Prepared>2019-06-13 00:00:07.196</Prepared>';
                response_banxico += '<Sender id="BANXICO">';
                response_banxico += '<Name xml:lang="sp">Banco de México</Name>';
                response_banxico += '<Contact>';
                response_banxico += '<Name xml:lang="sp">Subgerencia de Desarrollo de Sistemas</Name>';
                response_banxico += '<Telephone>(01 55)52372678</Telephone>';
                response_banxico += '</Contact>';
                response_banxico += '</Sender>';
                response_banxico += '<DataSetAction>Update</DataSetAction>';
                response_banxico += '<Extracted>2019-06-13 00:00:07.196</Extracted>';
                response_banxico += '</Header>';
                response_banxico += '<bm:DataSet>';
                response_banxico += '<bm:SiblingGroup BANXICO_FREQ="Dia" TIME_FORMAT="P1D"/>';
                response_banxico += '<bm:Series TITULO="Cotización de las divisas que conforman la canasta del DEG Respecto al peso mexicano Euro" IDSERIE="SF46410" BANXICO_FREQ="Dia" BANXICO_FIGURE_TYPE="" BANXICO_UNIT_TYPE="Peso">';
                response_banxico += '<bm:Obs TIME_PERIOD="2019-06-12" OBS_VALUE="21.6617"/>';
                response_banxico += '</bm:Series>';
                response_banxico += '<bm:Series TITULO="Cotización de la divisa Respecto al peso mexicano Dólar Canadiense" IDSERIE="SF60632" BANXICO_FREQ="Dia" BANXICO_FIGURE_TYPE="" BANXICO_UNIT_TYPE="Peso">';
                response_banxico += '<bm:Obs TIME_PERIOD="2019-06-12" OBS_VALUE="14.403"/>';
                response_banxico += '</bm:Series>';
                response_banxico += '<bm:Series TITULO="Tipo de cambio                                          Pesos por dólar E.U.A. Tipo de cambio para solventar obligaciones denominadas en moneda extranjera Fecha de determinación (FIX)" IDSERIE="SF43718" BANXICO_FREQ="Dia" BANXICO_FIGURE_TYPE="" BANXICO_UNIT_TYPE="PesoxDoll">';
                response_banxico += '<bm:Obs TIME_PERIOD="2019-06-12" OBS_VALUE="19.1383"/>';
                response_banxico += '</bm:Series>';
                response_banxico += '<bm:Series TITULO="Cotización de las divisas que conforman la canasta del DEG Respecto al peso mexicano Libra esterlina" IDSERIE="SF46407" BANXICO_FREQ="Dia" BANXICO_FIGURE_TYPE="" BANXICO_UNIT_TYPE="Peso">';
                response_banxico += '<bm:Obs TIME_PERIOD="2019-06-12" OBS_VALUE="24.3707"/>';
                response_banxico += '</bm:Series>';
                response_banxico += '<bm:Series TITULO="Cotización de las divisas que conforman la canasta del DEG Respecto al peso mexicano Yen japonés" IDSERIE="SF46406" BANXICO_FREQ="Dia" BANXICO_FIGURE_TYPE="" BANXICO_UNIT_TYPE="Peso">';
                response_banxico += '<bm:Obs TIME_PERIOD="2019-06-12" OBS_VALUE="0.1766"/>';
                response_banxico += '</bm:Series>';
                response_banxico += '<bm:Series TITULO="Tipo de cambio pesos por dólar E.U.A. Tipo de cambio para solventar obligaciones denominadas en moneda extranjera Fecha de liquidación" IDSERIE="SF60653" BANXICO_FREQ="Dia" BANXICO_FIGURE_TYPE="" BANXICO_UNIT_TYPE="PesoxDoll">';
                response_banxico += '<bm:Obs TIME_PERIOD="2019-06-13" OBS_VALUE="19.1222"/>';
                response_banxico += '</bm:Series>';
                response_banxico += '    </bm:DataSet>';
                response_banxico += '    </CompactData>]]></result>';
                response_banxico += '</ns1:tiposDeCambioBanxicoResponse>';
                response_banxico += '</soapenv:Body>';
                response_banxico += '</soapenv:Envelope>';

                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
                res.setBody(response_banxico);
                res.setStatusCode(200);
                return res;
            }
            else
                return null;
        }
    }
}