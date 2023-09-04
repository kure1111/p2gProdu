@isTest
private class NEU_test_TarimasINT {
//Test apex class NEU_UploadCustomers and NEU_UploadLots called to all methods
    static testMethod void NEU_TarimasINTError() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;        
        Country__c Country = new Country__c(Name='Mexico',  ISO_Code__c='EUR');
        insert Country;    
        Country__c CountryD = new Country__c(Name='Spain',  ISO_Code__c='EUR');
        insert CountryD; 
        State__c StateL = new State__c();
        StateL.Name='Baja California';
        StateL.Country__c=Country.Id;
        insert StateL; 
        State__c StateD = new State__c();
        StateD.Name='Guerrero';
        StateD.Country__c=Country.Id;
        insert StateD;          
        Location__c ll = new Location__c();
        ll.Name='Tijuana';
        ll.Country__c=Country.Id;
        ll.State__c=StateL.Id;
        insert ll;  
        Location__c ll1 = new Location__c();
        ll1.Name='Tijuana';
        ll1.Country__c=CountryD.Id;
        insert ll1;     
        Location__c ld = new Location__c();
        ld.Name='Acapulco';
        ld.Country__c=Country.Id;
        ld.State__c=StateD.Id;
        insert ld;              
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='Tijuana - Acapulco',  State_of_Load__c=StateL.Id, State_of_Discharge__c=StateD.Id, Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route; 
        NEU_TarimasINT u4=new NEU_TarimasINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMjMiIHVuaXF1ZUNvdW50PSIxOSI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5ESU1FTlNJT05FUyBNQVg8L3Q+PC9zaT48c2k+PHQ+UEVTTzwvdD48L3NpPjxzaT48dD5Mb2NhdGlvbiBPcmlnZW48L3Q+PC9zaT48c2k+PHQ+RXN0YWRvIE9yaWdlbjwvdD48L3NpPjxzaT48dD5Mb2NhdGlvbiBEZXN0aW5vPC90Pjwvc2k+PHNpPjx0PkVzdGFkbyBEZXN0aW5vPC90Pjwvc2k+PHNpPjx0PlpPTkE8L3Q+PC9zaT48c2k+PHQ+Q09NUFJBPC90Pjwvc2k+PHNpPjx0PlByZWNpbyBCYXNlPC90Pjwvc2k+PHNpPjx0PkFMTUVYPC90Pjwvc2k+PHNpPjx0PjcxIEEgMSwxMDAgS0c8L3Q+PC9zaT48c2k+PHQ+MS4yMCBYIDEuMDUgWCAxLjkwPC90Pjwvc2k+PHNpPjx0PmhqazwvdD48L3NpPjxzaT48dD5oazwvdD48L3NpPjxzaT48dD5UaWp1YW5hPC90Pjwvc2k+PC9zc3Q+';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:M2"/><sheetViews><sheetView tabSelected="1" topLeftCell="B1" workbookViewId="0"><selection activeCell="J3" sqref="J3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="12.28515625" bestFit="1" customWidth="1"/><col min="2" max="2" width="10.140625" bestFit="1" customWidth="1"/><col min="3" max="3" width="13" bestFit="1" customWidth="1"/><col min="4" max="4" width="16.85546875" bestFit="1" customWidth="1"/><col min="5" max="5" width="39.140625" bestFit="1" customWidth="1"/><col min="6" max="6" width="15.42578125" bestFit="1" customWidth="1"/><col min="7" max="7" width="13.7109375" bestFit="1" customWidth="1"/><col min="8" max="8" width="12" bestFit="1" customWidth="1"/><col min="9" max="9" width="11.5703125" bestFit="1" customWidth="1"/><col min="10" max="10" width="12.7109375" bestFit="1" customWidth="1"/><col min="11" max="11" width="5.140625" bestFit="1" customWidth="1"/><col min="12" max="12" width="7.28515625" bestFit="1" customWidth="1"/></cols><sheetData><row r="1" spans="1:13" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>1</v></c><c r="C1" s="1" t="s"><v>2</v></c><c r="D1" s="1" t="s"><v>3</v></c><c r="E1" s="2" t="s"><v>4</v></c><c r="F1" s="2" t="s"><v>5</v></c><c r="G1" s="3" t="s"><v>7</v></c><c r="H1" s="2" t="s"><v>6</v></c><c r="I1" s="2" t="s"><v>9</v></c><c r="J1" s="2" t="s"><v>8</v></c><c r="K1" s="2" t="s"><v>10</v></c><c r="L1" s="2" t="s"><v>11</v></c><c r="M1" s="2" t="s"><v>12</v></c></row><row r="2" spans="1:13" s="8" customFormat="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>13</v></c><c r="B2" s="5" t="s"><v>16</v></c><c r="C2" s="6" t="s"><v>17</v></c><c r="D2" s="6" t="s"><v>16</v></c><c r="E2" s="6" t="s"><v>15</v></c><c r="F2" s="6" t="s"><v>14</v></c><c r="G2" s="7"/><c r="H2" s="8" t="s"><v>18</v></c><c r="I2" s="6"/><c r="J2" s="8" t="s"><v>18</v></c><c r="K2" s="9"><v>5</v></c><c r="L2" s="8" t="s"><v>16</v></c><c r="M2" s="10" t="s"><v>17</v></c></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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
    static testMethod void NEU_TarimasINTFilter() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;        
        Country__c Country = new Country__c(Name='Mexico',  ISO_Code__c='EUR');
        insert Country;    
        State__c StateL = new State__c();
        StateL.Name='Baja California';
        StateL.Country__c=Country.Id;
        insert StateL; 
        State__c StateD = new State__c();
        StateD.Name='Guerrero';
        StateD.Country__c=Country.Id;
        insert StateD;          
        Location__c ll = new Location__c();
        ll.Name='Tijuana';
        ll.Country__c=Country.Id;
        ll.State__c=StateL.Id;
        insert ll;     
        Location__c ld = new Location__c();
        ld.Name='Acapulco';
        ld.Country__c=Country.Id;
        ld.State__c=StateD.Id;
        insert ld;              
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='Tijuana - Acapulco',  State_of_Load__c=StateL.Id, State_of_Discharge__c=StateD.Id, Country_of_Discharge__c=Country.Id, Country_of_Load__c=Country.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route; 
        NEU_TarimasINT u4=new NEU_TarimasINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTYiIHVuaXF1ZUNvdW50PSIxNiI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5ESU1FTlNJT05FUyBNQVg8L3Q+PC9zaT48c2k+PHQ+UEVTTzwvdD48L3NpPjxzaT48dD5Mb2NhdGlvbiBPcmlnZW48L3Q+PC9zaT48c2k+PHQ+RXN0YWRvIE9yaWdlbjwvdD48L3NpPjxzaT48dD5Mb2NhdGlvbiBEZXN0aW5vPC90Pjwvc2k+PHNpPjx0PkVzdGFkbyBEZXN0aW5vPC90Pjwvc2k+PHNpPjx0PlpPTkE8L3Q+PC9zaT48c2k+PHQ+Q09NUFJBPC90Pjwvc2k+PHNpPjx0PlByZWNpbyBCYXNlPC90Pjwvc2k+PHNpPjx0PkFMTUVYPC90Pjwvc2k+PHNpPjx0PjcxIEEgMSwxMDAgS0c8L3Q+PC9zaT48c2k+PHQ+MS4yMCBYIDEuMDUgWCAxLjkwPC90Pjwvc2k+PC9zc3Q+';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:M2"/><sheetViews><sheetView tabSelected="1" topLeftCell="B1" workbookViewId="0"><selection activeCell="M2" sqref="M2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="12.28515625" bestFit="1" customWidth="1"/><col min="2" max="2" width="10.140625" bestFit="1" customWidth="1"/><col min="3" max="3" width="13" bestFit="1" customWidth="1"/><col min="4" max="4" width="16.85546875" bestFit="1" customWidth="1"/><col min="5" max="5" width="39.140625" bestFit="1" customWidth="1"/><col min="6" max="6" width="15.42578125" bestFit="1" customWidth="1"/><col min="7" max="7" width="13.7109375" bestFit="1" customWidth="1"/><col min="8" max="8" width="12" bestFit="1" customWidth="1"/><col min="9" max="9" width="11.5703125" bestFit="1" customWidth="1"/><col min="10" max="10" width="12.7109375" bestFit="1" customWidth="1"/><col min="11" max="11" width="5.140625" bestFit="1" customWidth="1"/><col min="12" max="12" width="7.28515625" bestFit="1" customWidth="1"/></cols><sheetData><row r="1" spans="1:13" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>1</v></c><c r="C1" s="1" t="s"><v>2</v></c><c r="D1" s="1" t="s"><v>3</v></c><c r="E1" s="2" t="s"><v>4</v></c><c r="F1" s="2" t="s"><v>5</v></c><c r="G1" s="3" t="s"><v>7</v></c><c r="H1" s="2" t="s"><v>6</v></c><c r="I1" s="2" t="s"><v>9</v></c><c r="J1" s="2" t="s"><v>8</v></c><c r="K1" s="2" t="s"><v>10</v></c><c r="L1" s="2" t="s"><v>11</v></c><c r="M1" s="2" t="s"><v>12</v></c></row><row r="2" spans="1:13" s="8" customFormat="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>13</v></c><c r="B2" s="5"/><c r="C2" s="6"/><c r="D2" s="6"/><c r="E2" s="6" t="s"><v>15</v></c><c r="F2" s="6" t="s"><v>14</v></c><c r="G2" s="7"/><c r="I2" s="6"/><c r="K2" s="9"><v>5</v></c><c r="M2" s="10"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
        u4.filter.Carrier_Account__c=a.Id;
        u4.filter.Valid_From__c=Date.newInstance(2017,10,10);
        u4.filter.Valid_Until__c=Date.newInstance(2017,11,11);
        //loadFilter.Region__c=
        u4.filter.Route__r.Country_of_Load__c=ll.Country__c;
        u4.filter.Route__r.State_of_Load__c=ll.State__c;
        u4.filter.Route__r.Port_Airport_of_Load__c=ll.Id;
        //dischargeFilter.Region__c
        u4.filter.Route__r.Country_of_Discharge__c=ld.Country__c;
        u4.filter.Route__r.State_of_Discharge__c=ld.State__c;
        u4.filter.Route__r.Port_Airport_of_Discharge__c=ld.Id;
        u4.upload();
        u4.processData();
        u4.getratesDataNumber();
        u4.getshowColumn();
        u4.getcolumns();
        u4.getratesData();
        u4.saveLines();
    }
    static testMethod void NEU_TarimasINTGood() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;        
        Country__c Country = new Country__c(Name='Mexico',  ISO_Code__c='EUR');
        insert Country;    
        State__c StateL = new State__c();
        StateL.Name='Baja California';
        StateL.Country__c=Country.Id;
        insert StateL; 
        State__c StateD = new State__c();
        StateD.Name='Guerrero';
        StateD.Country__c=Country.Id;
        insert StateD;          
        Location__c ll = new Location__c();
        ll.Name='Tijuana';
        ll.Country__c=Country.Id;
        ll.State__c=StateL.Id;
        insert ll;     
        Location__c ld = new Location__c();
        ld.Name='Acapulco';
        ld.Country__c=Country.Id;
        ld.State__c=StateD.Id;
        insert ld;                      
        NEU_TarimasINT u5=new NEU_TarimasINT();        
        //call all methods
        u5.documento1Name='test.xlsx';
        u5.documento1=Blob.valueOf('test');
        u5.upload();
        u5.processData();
        //create a data example very good, simulating an excel uploaded
        u5.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMjEiIHVuaXF1ZUNvdW50PSIyMSI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5ESU1FTlNJT05FUyBNQVg8L3Q+PC9zaT48c2k+PHQ+UEVTTzwvdD48L3NpPjxzaT48dD5Mb2NhdGlvbiBPcmlnZW48L3Q+PC9zaT48c2k+PHQ+RXN0YWRvIE9yaWdlbjwvdD48L3NpPjxzaT48dD5Mb2NhdGlvbiBEZXN0aW5vPC90Pjwvc2k+PHNpPjx0PkVzdGFkbyBEZXN0aW5vPC90Pjwvc2k+PHNpPjx0PlpPTkE8L3Q+PC9zaT48c2k+PHQ+Q09NUFJBPC90Pjwvc2k+PHNpPjx0PlByZWNpbyBCYXNlPC90Pjwvc2k+PHNpPjx0PkFDQVBVTENPPC90Pjwvc2k+PHNpPjx0PkFMTUVYPC90Pjwvc2k+PHNpPjx0Pkd1ZXJyZXJvPC90Pjwvc2k+PHNpPjx0PlRFU1Q8L3Q+PC9zaT48c2k+PHQ+NzEgQSAxLDEwMCBLRzwvdD48L3NpPjxzaT48dD4xLjIwIFggMS4wNSBYIDEuOTA8L3Q+PC9zaT48c2k+PHQ+VGlqdWFuYTwvdD48L3NpPjxzaT48dD5CYWphIENhbGlmb3JuaWE8L3Q+PC9zaT48L3NzdD4=';
        u5.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:M2"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="G3" sqref="G3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="12.28515625" bestFit="1" customWidth="1"/><col min="2" max="2" width="10.140625" bestFit="1" customWidth="1"/><col min="3" max="3" width="13" bestFit="1" customWidth="1"/><col min="4" max="4" width="16.85546875" bestFit="1" customWidth="1"/><col min="5" max="5" width="39.140625" bestFit="1" customWidth="1"/><col min="6" max="6" width="15.42578125" bestFit="1" customWidth="1"/><col min="7" max="7" width="13.7109375" bestFit="1" customWidth="1"/><col min="8" max="8" width="12" bestFit="1" customWidth="1"/><col min="9" max="9" width="11.5703125" bestFit="1" customWidth="1"/><col min="10" max="10" width="12.7109375" bestFit="1" customWidth="1"/><col min="11" max="11" width="5.140625" bestFit="1" customWidth="1"/><col min="12" max="12" width="7.28515625" bestFit="1" customWidth="1"/></cols><sheetData><row r="1" spans="1:13" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>1</v></c><c r="C1" s="1" t="s"><v>2</v></c><c r="D1" s="1" t="s"><v>3</v></c><c r="E1" s="2" t="s"><v>4</v></c><c r="F1" s="2" t="s"><v>5</v></c><c r="G1" s="3" t="s"><v>7</v></c><c r="H1" s="2" t="s"><v>6</v></c><c r="I1" s="2" t="s"><v>9</v></c><c r="J1" s="2" t="s"><v>8</v></c><c r="K1" s="2" t="s"><v>10</v></c><c r="L1" s="2" t="s"><v>11</v></c><c r="M1" s="2" t="s"><v>12</v></c></row><row r="2" spans="1:13" s="8" customFormat="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>14</v></c><c r="B2" s="5" t="s"><v>16</v></c><c r="C2" s="6"><v>43009</v></c><c r="D2" s="6"><v>43100</v></c><c r="E2" s="6" t="s"><v>18</v></c><c r="F2" s="6" t="s"><v>17</v></c><c r="G2" s="7" t="s"><v>20</v></c><c r="H2" s="8" t="s"><v>19</v></c><c r="I2" s="6" t="s"><v>15</v></c><c r="J2" s="8" t="s"><v>13</v></c><c r="K2" s="9"><v>5</v></c><c r="L2" s="8"><v>2169.5</v></c><c r="M2" s="10"><v>2735.0544000000004</v></c></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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