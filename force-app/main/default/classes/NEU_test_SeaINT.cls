@isTest
private class NEU_test_SeaINT {
//Test apex class NEU_UploadCustomers and NEU_UploadLots called to all methods
    static testMethod void NEU_SeaINTError() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;        
        Country__c CountryL = new Country__c(Name='United States',  ISO_Code__c='EUR');
        insert CountryL; 
        Country__c CountryD = new Country__c(Name='Spain',  ISO_Code__c='EUR');
        insert CountryD;    
        State__c StateL = new State__c();
        StateL.Name='Texas';
        StateL.Country__c=CountryL.Id;
        insert StateL;          
        Location__c ll = new Location__c();
        ll.Name='San Antonio';
        ll.Country__c=CountryL.Id;
        ll.State__c=StateL.Id;
        insert ll;   
        Location__c ll1 = new Location__c();
        ll1.Name='San Antonio';
        ll1.Country__c=CountryD.Id;
        insert ll1;  
        Location__c ld = new Location__c();
        ld.Name='Barcelona';
        ld.Country__c=CountryD.Id;
        insert ld;        
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  
        NEU_SeaINT u4=new NEU_SeaINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMjYiIHVuaXF1ZUNvdW50PSIyMyI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5QQUlTIE9SSUdFTjwvdD48L3NpPjxzaT48dD5QQUlTIERFU1RJTk88L3Q+PC9zaT48c2k+PHQ+VElFTVBPIERFIFRSQU5TSVRPPC90Pjwvc2k+PHNpPjx0PlRJUE8gREUgQ09OVEVORURPUjwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgQ09NUFJBPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBWRU5UQTwvdD48L3NpPjxzaT48dD5PQlNFUlZBQ0lPTkVTPC90Pjwvc2k+PHNpPjx0PkxPQ0FUSU9OIE9SSUdFTjwvdD48L3NpPjxzaT48dD5MT0NBVElPTiBERVNUSU5PPC90Pjwvc2k+PHNpPjx0PlNhbiBBbnRvbmlvPC90Pjwvc2k+PHNpPjx0PkFHRU5URTwvdD48L3NpPjxzaT48dD5URVNUPC90Pjwvc2k+PHNpPjx0PkVTVEFETyBPUklHRU48L3Q+PC9zaT48c2k+PHQ+RVNUQURPIERFU1RJTk88L3Q+PC9zaT48c2k+PHQ+UGVyPC90Pjwvc2k+PHNpPjx0PmdmaDwvdD48L3NpPjxzaT48dD5maDwvdD48L3NpPjxzaT48dD5hczwvdD48L3NpPjxzaT48dD5kc2ZzPC90Pjwvc2k+PC9zc3Q+';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:P12"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="E2" sqref="E2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="2" max="2" width="20.7109375" style="10" customWidth="1"/><col min="6" max="6" width="12.85546875" bestFit="1" customWidth="1"/><col min="16" max="16" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:16" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>14</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>3</v></c><c r="F1" s="1" t="s"><v>4</v></c><c r="G1" s="1" t="s"><v>16</v></c><c r="H1" s="1" t="s"><v>11</v></c><c r="I1" s="1" t="s"><v>5</v></c><c r="J1" s="1" t="s"><v>17</v></c><c r="K1" s="1" t="s"><v>12</v></c><c r="L1" s="1" t="s"><v>6</v></c><c r="M1" s="1" t="s"><v>7</v></c><c r="N1" s="1" t="s"><v>8</v></c><c r="O1" s="2" t="s"><v>9</v></c><c r="P1" s="2" t="s"><v>10</v></c></row><row r="2" spans="1:16" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>18</v></c><c r="B2" s="5" t="s"><v>15</v></c><c r="C2" s="5" t="s"><v>19</v></c><c r="D2" s="6" t="s"><v>21</v></c><c r="E2" s="6" t="s"><v>22</v></c><c r="F2" s="5"/><c r="G2" s="5"/><c r="H2" s="5" t="s"><v>13</v></c><c r="I2" s="5"/><c r="J2" s="5"/><c r="K2" s="5" t="s"><v>13</v></c><c r="L2" s="5"/><c r="M2" s="5" t="s"><v>19</v></c><c r="N2" s="4" t="s"><v>19</v></c><c r="O2" s="7" t="s"><v>20</v></c><c r="P2" s="8"/></row><row r="5" spans="1:16" x14ac:dyDescent="0.25"><c r="B5"/><c r="D5" s="3"/></row><row r="6" spans="1:16" x14ac:dyDescent="0.25"><c r="B6"/></row><row r="7" spans="1:16" x14ac:dyDescent="0.25"><c r="B7"/></row><row r="8" spans="1:16" x14ac:dyDescent="0.25"><c r="B8"/></row><row r="9" spans="1:16" x14ac:dyDescent="0.25"><c r="B9"/></row><row r="10" spans="1:16" x14ac:dyDescent="0.25"><c r="B10"/></row><row r="11" spans="1:16" x14ac:dyDescent="0.25"><c r="B11"/></row><row r="12" spans="1:16" x14ac:dyDescent="0.25"><c r="B12"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
        u4.filter.Route__r.Country_of_Load__c=ll.Country__c;
        u4.filter.Route__r.State_of_Load__c=ll.State__c;
        u4.filter.Route__r.Country_of_Discharge__c=ld.Country__c;
        u4.filter.Route__r.State_of_Discharge__c=ll.State__c;
        u4.upload();
        u4.processData();
        u4.getratesDataNumber();
        u4.getshowColumn();
        u4.getcolumns();
        u4.getratesData();
        u4.saveLines();
    }
    static testMethod void NEU_SeaINTFilter() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;        
        Country__c CountryL = new Country__c(Name='United States',  ISO_Code__c='EUR');
        insert CountryL; 
        Country__c CountryD = new Country__c(Name='Spain',  ISO_Code__c='EUR');
        insert CountryD;    
        State__c StateL = new State__c();
        StateL.Name='Texas';
        StateL.Country__c=CountryL.Id;
        insert StateL;          
        Location__c ll = new Location__c();
        ll.Name='San Antonio';
        ll.Country__c=CountryL.Id;
        ll.State__c=StateL.Id;
        insert ll;     
        Location__c ld = new Location__c();
        ld.Name='Barcelona';
        ld.Country__c=CountryD.Id;
        insert ld;        
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  
        NEU_SeaINT u4=new NEU_SeaINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTgiIHVuaXF1ZUNvdW50PSIxOCI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5QQUlTIE9SSUdFTjwvdD48L3NpPjxzaT48dD5QQUlTIERFU1RJTk88L3Q+PC9zaT48c2k+PHQ+VElFTVBPIERFIFRSQU5TSVRPPC90Pjwvc2k+PHNpPjx0PlRJUE8gREUgQ09OVEVORURPUjwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgQ09NUFJBPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBWRU5UQTwvdD48L3NpPjxzaT48dD5PQlNFUlZBQ0lPTkVTPC90Pjwvc2k+PHNpPjx0PkxPQ0FUSU9OIE9SSUdFTjwvdD48L3NpPjxzaT48dD5MT0NBVElPTiBERVNUSU5PPC90Pjwvc2k+PHNpPjx0PlBlciBDb250YWluZXI8L3Q+PC9zaT48c2k+PHQ+QUdFTlRFPC90Pjwvc2k+PHNpPjx0PlRFU1Q8L3Q+PC9zaT48c2k+PHQ+RVNUQURPIE9SSUdFTjwvdD48L3NpPjxzaT48dD5FU1RBRE8gREVTVElOTzwvdD48L3NpPjwvc3N0Pg==';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:P12"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="P2" sqref="P2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="2" max="2" width="20.7109375" style="10" customWidth="1"/><col min="6" max="6" width="12.85546875" bestFit="1" customWidth="1"/><col min="16" max="16" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:16" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>14</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>3</v></c><c r="F1" s="1" t="s"><v>4</v></c><c r="G1" s="1" t="s"><v>16</v></c><c r="H1" s="1" t="s"><v>11</v></c><c r="I1" s="1" t="s"><v>5</v></c><c r="J1" s="1" t="s"><v>17</v></c><c r="K1" s="1" t="s"><v>12</v></c><c r="L1" s="1" t="s"><v>6</v></c><c r="M1" s="1" t="s"><v>7</v></c><c r="N1" s="1" t="s"><v>8</v></c><c r="O1" s="2" t="s"><v>9</v></c><c r="P1" s="2" t="s"><v>10</v></c></row><row r="2" spans="1:16" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>13</v></c><c r="B2" s="5" t="s"><v>15</v></c><c r="C2" s="5"/><c r="D2" s="6"/><c r="E2" s="6"/><c r="F2" s="5"/><c r="G2" s="5"/><c r="H2" s="5"/><c r="I2" s="5"/><c r="J2" s="5"/><c r="K2" s="5"/><c r="L2" s="5"/><c r="M2" s="5"/><c r="N2" s="4"/><c r="O2" s="7"/><c r="P2" s="8"/></row><row r="5" spans="1:16" x14ac:dyDescent="0.25"><c r="B5"/><c r="D5" s="3"/></row><row r="6" spans="1:16" x14ac:dyDescent="0.25"><c r="B6"/></row><row r="7" spans="1:16" x14ac:dyDescent="0.25"><c r="B7"/></row><row r="8" spans="1:16" x14ac:dyDescent="0.25"><c r="B8"/></row><row r="9" spans="1:16" x14ac:dyDescent="0.25"><c r="B9"/></row><row r="10" spans="1:16" x14ac:dyDescent="0.25"><c r="B10"/></row><row r="11" spans="1:16" x14ac:dyDescent="0.25"><c r="B11"/></row><row r="12" spans="1:16" x14ac:dyDescent="0.25"><c r="B12"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
        u4.filter.Carrier_Account__c=a.Id;
        u4.filter.Valid_From__c=Date.newInstance(2017,10,10);
        u4.filter.Valid_Until__c=Date.newInstance(2017,11,11);
        //loadFilter.Region__c=
        u4.filter.Route__r.Country_of_Load__c=ll.Country__c;
        u4.filter.Route__r.State_of_Load__c=ll.State__c;
        u4.filter.Route__r.Port_Airport_of_Load__c=ll.Id;
        //dischargeFilter.Region__c
        u4.filter.Route__r.Country_of_Discharge__c=ld.Country__c;
        u4.filter.Route__r.Port_Airport_of_Discharge__c=ld.Id;
        u4.upload();
        u4.processData();
        u4.getratesDataNumber();
        u4.getshowColumn();
        u4.getcolumns();
        u4.getratesData();
        u4.saveLines();
    }
    static testMethod void NEU_SeaINTGood() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;        
        Country__c CountryL = new Country__c(Name='United States',  ISO_Code__c='EUR');
        insert CountryL; 
        Country__c CountryD = new Country__c(Name='Spain',  ISO_Code__c='EUR');
        insert CountryD;    
        State__c StateL = new State__c();
        StateL.Name='Texas';
        StateL.Country__c=CountryL.Id;
        insert StateL;          
        Location__c ll = new Location__c();
        ll.Name='San Antonio';
        ll.Country__c=CountryL.Id;
        ll.State__c=StateL.Id;
        insert ll;     
        Location__c ld = new Location__c();
        ld.Name='Barcelona';
        ld.Country__c=CountryD.Id;
        insert ld;        
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;              
        /*Fee__c fee = new Fee__c(Name = 'Service Rate 3', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Kg', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee; */
        NEU_SeaINT u5=new NEU_SeaINT();        
        //call all methods
        u5.documento1Name='test.xlsx';
        u5.documento1=Blob.valueOf('test');
        u5.upload();
        u5.processData();
        //create a data example very good, simulating an excel uploaded
        u5.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMjYiIHVuaXF1ZUNvdW50PSIyNSI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5QQUlTIE9SSUdFTjwvdD48L3NpPjxzaT48dD5QQUlTIERFU1RJTk88L3Q+PC9zaT48c2k+PHQ+VElFTVBPIERFIFRSQU5TSVRPPC90Pjwvc2k+PHNpPjx0PlRJUE8gREUgQ09OVEVORURPUjwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgQ09NUFJBPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBWRU5UQTwvdD48L3NpPjxzaT48dD5PQlNFUlZBQ0lPTkVTPC90Pjwvc2k+PHNpPjx0PjQwIEhDPC90Pjwvc2k+PHNpPjx0Pm9ic2VydmFjaW9uZXM8L3Q+PC9zaT48c2k+PHQ+TE9DQVRJT04gT1JJR0VOPC90Pjwvc2k+PHNpPjx0PkxPQ0FUSU9OIERFU1RJTk88L3Q+PC9zaT48c2k+PHQ+QkFSQ0VMT05BPC90Pjwvc2k+PHNpPjx0PlBlciBDb250YWluZXI8L3Q+PC9zaT48c2k+PHQ+U2FuIEFudG9uaW88L3Q+PC9zaT48c2k+PHQ+QUdFTlRFPC90Pjwvc2k+PHNpPjx0PlRFU1Q8L3Q+PC9zaT48c2k+PHQ+RVNUQURPIE9SSUdFTjwvdD48L3NpPjxzaT48dD5FU1RBRE8gREVTVElOTzwvdD48L3NpPjxzaT48dD5Vbml0ZWQgU3RhdGVzPC90Pjwvc2k+PHNpPjx0PlRleGFzPC90Pjwvc2k+PHNpPjx0PlNwYWluPC90Pjwvc2k+PC9zc3Q+';
        u5.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:P12"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="I3" sqref="I3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="2" max="2" width="20.7109375" style="10" customWidth="1"/><col min="6" max="6" width="12.85546875" bestFit="1" customWidth="1"/><col min="16" max="16" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:16" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>18</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>3</v></c><c r="F1" s="1" t="s"><v>4</v></c><c r="G1" s="1" t="s"><v>20</v></c><c r="H1" s="1" t="s"><v>13</v></c><c r="I1" s="1" t="s"><v>5</v></c><c r="J1" s="1" t="s"><v>21</v></c><c r="K1" s="1" t="s"><v>14</v></c><c r="L1" s="1" t="s"><v>6</v></c><c r="M1" s="1" t="s"><v>7</v></c><c r="N1" s="1" t="s"><v>8</v></c><c r="O1" s="2" t="s"><v>9</v></c><c r="P1" s="2" t="s"><v>10</v></c></row><row r="2" spans="1:16" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>16</v></c><c r="B2" s="5" t="s"><v>19</v></c><c r="C2" s="5" t="s"><v>19</v></c><c r="D2" s="6"><v>42856</v></c><c r="E2" s="6"><v>43069</v></c><c r="F2" s="5" t="s"><v>22</v></c><c r="G2" s="5" t="s"><v>23</v></c><c r="H2" s="5" t="s"><v>17</v></c><c r="I2" s="5" t="s"><v>24</v></c><c r="J2" s="5"/><c r="K2" s="5" t="s"><v>15</v></c><c r="L2" s="5"><v>11</v></c><c r="M2" s="5" t="s"><v>11</v></c><c r="N2" s="4"><v>11.5</v></c><c r="O2" s="7"><v>20</v></c><c r="P2" s="8" t="s"><v>12</v></c></row><row r="5" spans="1:16" x14ac:dyDescent="0.25"><c r="B5"/><c r="D5" s="3"/></row><row r="6" spans="1:16" x14ac:dyDescent="0.25"><c r="B6"/></row><row r="7" spans="1:16" x14ac:dyDescent="0.25"><c r="B7"/></row><row r="8" spans="1:16" x14ac:dyDescent="0.25"><c r="B8"/></row><row r="9" spans="1:16" x14ac:dyDescent="0.25"><c r="B9"/></row><row r="10" spans="1:16" x14ac:dyDescent="0.25"><c r="B10"/></row><row r="11" spans="1:16" x14ac:dyDescent="0.25"><c r="B11"/></row><row r="12" spans="1:16" x14ac:dyDescent="0.25"><c r="B12"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
        u5.upload();
        u5.processData();
        u5.getratesDataNumber();
        u5.getshowColumn();
        u5.getCategory();
        u5.getcolumns();
        u5.getratesData();      
        u5.saveLines();
        u5.cleanPage();
    }
}