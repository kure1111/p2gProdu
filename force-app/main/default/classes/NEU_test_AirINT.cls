@isTest
private class NEU_test_AirINT 
{
	
    static testMethod void NEU_AirINTError() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
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
        ll.IATA_Code__c='123';
        insert ll;   
        Location__c ll1 = new Location__c();
        ll1.Name='San Antonio';
        ll1.Country__c=CountryD.Id;
        ll.IATA_Code__c='123';
        insert ll1;   
        Location__c ld = new Location__c();
        ld.Name='Barcelona';
        ld.Country__c=CountryD.Id;
        ld.IATA_Code__c='987';
        insert ld;                
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  
        NEU_AirINT u4=new NEU_AirINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMjYiIHVuaXF1ZUNvdW50PSIxOCI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIENPTVBSQTwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgVkVOVEE8L3Q+PC9zaT48c2k+PHQ+T0JTRVJWQUNJT05FUzwvdD48L3NpPjxzaT48dD5USVBPIERFIENPTlRSQVRPPC90Pjwvc2k+PHNpPjx0PkZSRUNVRU5DSUE8L3Q+PC9zaT48c2k+PHQ+QUVST0xJTkVBPC90Pjwvc2k+PHNpPjx0PkFHRU5URTwvdD48L3NpPjxzaT48dD5JQVRBIENPREUgT1JJR0VOPC90Pjwvc2k+PHNpPjx0PklBVEEgQ09ERSBERVNUSU5PPC90Pjwvc2k+PHNpPjx0PlRSQU5TSElQTUVOVDwvdD48L3NpPjxzaT48dD5USUVNUE8gREUgVFJBTlNJVE88L3Q+PC9zaT48c2k+PHQ+TcOBWElNTyBLR1MvTTM8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIE3DjU5JTU88L3Q+PC9zaT48c2k+PHQ+UGVyIE0zPC90Pjwvc2k+PHNpPjx0PmhqazwvdD48L3NpPjwvc3N0Pg==';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:P6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="K2" sqref="K2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="2" max="3" width="16.7109375" style="12" customWidth="1"/><col min="5" max="5" width="7.42578125" style="12" customWidth="1"/><col min="8" max="8" width="11.28515625" style="12" customWidth="1"/><col min="9" max="10" width="11.85546875" style="12" customWidth="1"/><col min="11" max="13" width="10.85546875" style="12"/><col min="16" max="16" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:16" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>6</v></c><c r="C1" s="1" t="s"><v>7</v></c><c r="D1" s="1" t="s"><v>8</v></c><c r="E1" s="1" t="s"><v>9</v></c><c r="F1" s="1" t="s"><v>1</v></c><c r="G1" s="1" t="s"><v>2</v></c><c r="H1" s="1" t="s"><v>10</v></c><c r="I1" s="1" t="s"><v>11</v></c><c r="J1" s="1" t="s"><v>12</v></c><c r="K1" s="1" t="s"><v>13</v></c><c r="L1" s="1" t="s"><v>14</v></c><c r="M1" s="1" t="s"><v>15</v></c><c r="N1" s="1" t="s"><v>3</v></c><c r="O1" s="2" t="s"><v>4</v></c><c r="P1" s="2" t="s"><v>5</v></c></row><row r="2" spans="1:16" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>16</v></c><c r="B2" s="10"/><c r="C2" s="10"/><c r="D2" s="5" t="s"><v>17</v></c><c r="E2" s="14"/><c r="F2" s="6" t="s"><v>17</v></c><c r="G2" s="6" t="s"><v>17</v></c><c r="H2" s="14" t="s"><v>17</v></c><c r="I2" s="14" t="s"><v>17</v></c><c r="J2" s="14"/><c r="K2" s="14"/><c r="L2" s="14" t="s"><v>17</v></c><c r="M2" s="14" t="s"><v>17</v></c><c r="N2" s="4" t="s"><v>17</v></c><c r="O2" s="7" t="s"><v>17</v></c><c r="P2" s="8"/></row><row r="3" spans="1:16" x14ac:dyDescent="0.25"><c r="B3" s="11"/><c r="C3" s="11"/></row><row r="4" spans="1:16" x14ac:dyDescent="0.25"><c r="B4" s="11"/><c r="C4" s="11"/></row><row r="5" spans="1:16" x14ac:dyDescent="0.25"><c r="E5" s="16"/><c r="F5" s="3"/><c r="H5" s="18"/><c r="I5" s="18"/><c r="J5" s="17"/><c r="M5" s="15"/></row><row r="6" spans="1:16" x14ac:dyDescent="0.25"><c r="B6" s="13"/></row></sheetData><mergeCells count="1"><mergeCell ref="H5:I5"/></mergeCells><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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
    
    static testMethod void NEU_AirINTError1() 
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
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
        ll.IATA_Code__c='123';
        insert ll;   
        Location__c ll1 = new Location__c();
        ll1.Name='San Antonio';
        ll1.Country__c=CountryD.Id;
        ll.IATA_Code__c='123';
        insert ll1;   
        Location__c ld = new Location__c();
        ld.Name='Barcelona';
        ld.Country__c=CountryD.Id;
        ld.IATA_Code__c='987';
        insert ld;                
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  
        NEU_AirINT u4=new NEU_AirINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMjUiIHVuaXF1ZUNvdW50PSIxOSI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIENPTVBSQTwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgVkVOVEE8L3Q+PC9zaT48c2k+PHQ+T0JTRVJWQUNJT05FUzwvdD48L3NpPjxzaT48dD5USVBPIERFIENPTlRSQVRPPC90Pjwvc2k+PHNpPjx0PkZSRUNVRU5DSUE8L3Q+PC9zaT48c2k+PHQ+QUVST0xJTkVBPC90Pjwvc2k+PHNpPjx0PkFHRU5URTwvdD48L3NpPjxzaT48dD5JQVRBIENPREUgT1JJR0VOPC90Pjwvc2k+PHNpPjx0PklBVEEgQ09ERSBERVNUSU5PPC90Pjwvc2k+PHNpPjx0PlRSQU5TSElQTUVOVDwvdD48L3NpPjxzaT48dD5USUVNUE8gREUgVFJBTlNJVE88L3Q+PC9zaT48c2k+PHQ+TcOBWElNTyBLR1MvTTM8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIE3DjU5JTU88L3Q+PC9zaT48c2k+PHQ+aGprPC90Pjwvc2k+PHNpPjx0PmdoZmg8L3Q+PC9zaT48c2k+PHQ+UGVyIEtnPC90Pjwvc2k+PC9zc3Q+';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:P6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="A2" sqref="A2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="2" max="3" width="16.7109375" style="12" customWidth="1"/><col min="5" max="5" width="7.42578125" style="12" customWidth="1"/><col min="8" max="8" width="11.28515625" style="12" customWidth="1"/><col min="9" max="10" width="11.85546875" style="12" customWidth="1"/><col min="11" max="13" width="10.85546875" style="12"/><col min="16" max="16" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:16" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>6</v></c><c r="C1" s="1" t="s"><v>7</v></c><c r="D1" s="1" t="s"><v>8</v></c><c r="E1" s="1" t="s"><v>9</v></c><c r="F1" s="1" t="s"><v>1</v></c><c r="G1" s="1" t="s"><v>2</v></c><c r="H1" s="1" t="s"><v>10</v></c><c r="I1" s="1" t="s"><v>11</v></c><c r="J1" s="1" t="s"><v>12</v></c><c r="K1" s="1" t="s"><v>13</v></c><c r="L1" s="1" t="s"><v>14</v></c><c r="M1" s="1" t="s"><v>15</v></c><c r="N1" s="1" t="s"><v>3</v></c><c r="O1" s="2" t="s"><v>4</v></c><c r="P1" s="2" t="s"><v>5</v></c></row><row r="2" spans="1:16" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>18</v></c><c r="B2" s="10"/><c r="C2" s="10"/><c r="D2" s="5" t="s"><v>16</v></c><c r="E2" s="14" t="s"><v>17</v></c><c r="F2" s="6" t="s"><v>16</v></c><c r="G2" s="6" t="s"><v>16</v></c><c r="H2" s="14"><v>123</v></c><c r="I2" s="14"><v>123</v></c><c r="J2" s="14"/><c r="K2" s="14"/><c r="L2" s="14" t="s"><v>16</v></c><c r="M2" s="14" t="s"><v>16</v></c><c r="N2" s="4" t="s"><v>16</v></c><c r="O2" s="7" t="s"><v>16</v></c><c r="P2" s="8"/></row><row r="3" spans="1:16" x14ac:dyDescent="0.25"><c r="B3" s="11"/><c r="C3" s="11"/></row><row r="4" spans="1:16" x14ac:dyDescent="0.25"><c r="B4" s="11"/><c r="C4" s="11"/></row><row r="5" spans="1:16" x14ac:dyDescent="0.25"><c r="E5" s="16"/><c r="F5" s="3"/><c r="H5" s="18"/><c r="I5" s="18"/><c r="J5" s="17"/><c r="M5" s="15"/></row><row r="6" spans="1:16" x14ac:dyDescent="0.25"><c r="B6" s="13"/></row></sheetData><mergeCells count="1"><mergeCell ref="H5:I5"/></mergeCells><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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
    
    static testMethod void NEU_AirINTEmpty() 
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
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
        ll.IATA_Code__c='123';
        insert ll;   
        Location__c ll1 = new Location__c();
        ll1.Name='San Antonio';
        ll1.Country__c=CountryD.Id;
        ll.IATA_Code__c='123';
        insert ll1;   
        Location__c ld = new Location__c();
        ld.Name='Barcelona';
        ld.Country__c=CountryD.Id;
        ld.IATA_Code__c='987';
        insert ld;                
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  
        NEU_AirINT u4=new NEU_AirINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTciIHVuaXF1ZUNvdW50PSIxNyI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIENPTVBSQTwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgVkVOVEE8L3Q+PC9zaT48c2k+PHQ+T0JTRVJWQUNJT05FUzwvdD48L3NpPjxzaT48dD5USVBPIERFIENPTlRSQVRPPC90Pjwvc2k+PHNpPjx0PkZSRUNVRU5DSUE8L3Q+PC9zaT48c2k+PHQ+QUVST0xJTkVBPC90Pjwvc2k+PHNpPjx0PkFHRU5URTwvdD48L3NpPjxzaT48dD5JQVRBIENPREUgT1JJR0VOPC90Pjwvc2k+PHNpPjx0PklBVEEgQ09ERSBERVNUSU5PPC90Pjwvc2k+PHNpPjx0PlRSQU5TSElQTUVOVDwvdD48L3NpPjxzaT48dD5USUVNUE8gREUgVFJBTlNJVE88L3Q+PC9zaT48c2k+PHQ+TcOBWElNTyBLR1MvTTM8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIE3DjU5JTU88L3Q+PC9zaT48c2k+PHQ+UGVyPC90Pjwvc2k+PC9zc3Q+';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:P6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="A4" sqref="A4"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="2" max="3" width="16.7109375" style="12" customWidth="1"/><col min="5" max="5" width="7.42578125" style="12" customWidth="1"/><col min="8" max="8" width="11.28515625" style="12" customWidth="1"/><col min="9" max="10" width="11.85546875" style="12" customWidth="1"/><col min="11" max="13" width="10.85546875" style="12"/><col min="16" max="16" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:16" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>6</v></c><c r="C1" s="1" t="s"><v>7</v></c><c r="D1" s="1" t="s"><v>8</v></c><c r="E1" s="1" t="s"><v>9</v></c><c r="F1" s="1" t="s"><v>1</v></c><c r="G1" s="1" t="s"><v>2</v></c><c r="H1" s="1" t="s"><v>10</v></c><c r="I1" s="1" t="s"><v>11</v></c><c r="J1" s="1" t="s"><v>12</v></c><c r="K1" s="1" t="s"><v>13</v></c><c r="L1" s="1" t="s"><v>14</v></c><c r="M1" s="1" t="s"><v>15</v></c><c r="N1" s="1" t="s"><v>3</v></c><c r="O1" s="2" t="s"><v>4</v></c><c r="P1" s="2" t="s"><v>5</v></c></row><row r="2" spans="1:16" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>16</v></c><c r="B2" s="10"/><c r="C2" s="10"/><c r="D2" s="5"/><c r="E2" s="14"/><c r="F2" s="6"/><c r="G2" s="6"/><c r="H2" s="14"/><c r="I2" s="14"/><c r="J2" s="14"/><c r="K2" s="14"/><c r="L2" s="14"/><c r="M2" s="14"/><c r="N2" s="4"/><c r="O2" s="7"/><c r="P2" s="8"/></row><row r="3" spans="1:16" x14ac:dyDescent="0.25"><c r="B3" s="11"/><c r="C3" s="11"/></row><row r="4" spans="1:16" x14ac:dyDescent="0.25"><c r="B4" s="11"/><c r="C4" s="11"/></row><row r="5" spans="1:16" x14ac:dyDescent="0.25"><c r="E5" s="16"/><c r="F5" s="3"/><c r="H5" s="18"/><c r="I5" s="18"/><c r="J5" s="17"/><c r="M5" s="15"/></row><row r="6" spans="1:16" x14ac:dyDescent="0.25"><c r="B6" s="13"/></row></sheetData><mergeCells count="1"><mergeCell ref="H5:I5"/></mergeCells><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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
    
    static testMethod void NEU_AirINTFilter()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
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
        ll.IATA_Code__c='123';
        insert ll;     
        Location__c ld = new Location__c();
        ld.Name='Barcelona';
        ld.Country__c=CountryD.Id;
        ld.IATA_Code__c='987';
        insert ld;          
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  
        NEU_AirINT u4=new NEU_AirINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTciIHVuaXF1ZUNvdW50PSIxNyI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIENPTVBSQTwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgVkVOVEE8L3Q+PC9zaT48c2k+PHQ+T0JTRVJWQUNJT05FUzwvdD48L3NpPjxzaT48dD5USVBPIERFIENPTlRSQVRPPC90Pjwvc2k+PHNpPjx0PkZSRUNVRU5DSUE8L3Q+PC9zaT48c2k+PHQ+QUVST0xJTkVBPC90Pjwvc2k+PHNpPjx0PkFHRU5URTwvdD48L3NpPjxzaT48dD5JQVRBIENPREUgT1JJR0VOPC90Pjwvc2k+PHNpPjx0PklBVEEgQ09ERSBERVNUSU5PPC90Pjwvc2k+PHNpPjx0PlRSQU5TSElQTUVOVDwvdD48L3NpPjxzaT48dD5USUVNUE8gREUgVFJBTlNJVE88L3Q+PC9zaT48c2k+PHQ+TcOBWElNTyBLR1MvTTM8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIE3DjU5JTU88L3Q+PC9zaT48c2k+PHQ+UGVyIE0zPC90Pjwvc2k+PC9zc3Q+';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:P6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="I2" sqref="I2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="2" max="3" width="16.7109375" style="12" customWidth="1"/><col min="5" max="5" width="7.42578125" style="12" customWidth="1"/><col min="8" max="8" width="11.28515625" style="12" customWidth="1"/><col min="9" max="10" width="11.85546875" style="12" customWidth="1"/><col min="11" max="13" width="10.85546875" style="12"/><col min="16" max="16" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:16" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>6</v></c><c r="C1" s="1" t="s"><v>7</v></c><c r="D1" s="1" t="s"><v>8</v></c><c r="E1" s="1" t="s"><v>9</v></c><c r="F1" s="1" t="s"><v>1</v></c><c r="G1" s="1" t="s"><v>2</v></c><c r="H1" s="1" t="s"><v>10</v></c><c r="I1" s="1" t="s"><v>11</v></c><c r="J1" s="1" t="s"><v>12</v></c><c r="K1" s="1" t="s"><v>13</v></c><c r="L1" s="1" t="s"><v>14</v></c><c r="M1" s="1" t="s"><v>15</v></c><c r="N1" s="1" t="s"><v>3</v></c><c r="O1" s="2" t="s"><v>4</v></c><c r="P1" s="2" t="s"><v>5</v></c></row><row r="2" spans="1:16" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>16</v></c><c r="B2" s="10"/><c r="C2" s="10"/><c r="D2" s="5"/><c r="E2" s="14"/><c r="F2" s="6"/><c r="G2" s="6"/><c r="H2" s="14"/><c r="I2" s="14"/><c r="J2" s="14"/><c r="K2" s="14"/><c r="L2" s="14"/><c r="M2" s="14"/><c r="N2" s="4"/><c r="O2" s="7"/><c r="P2" s="8"/></row><row r="3" spans="1:16" x14ac:dyDescent="0.25"><c r="B3" s="11"/><c r="C3" s="11"/></row><row r="4" spans="1:16" x14ac:dyDescent="0.25"><c r="B4" s="11"/><c r="C4" s="11"/></row><row r="5" spans="1:16" x14ac:dyDescent="0.25"><c r="E5" s="16"/><c r="F5" s="3"/><c r="H5" s="18"/><c r="I5" s="18"/><c r="J5" s="17"/><c r="M5" s="15"/></row><row r="6" spans="1:16" x14ac:dyDescent="0.25"><c r="B6" s="13"/></row></sheetData><mergeCells count="1"><mergeCell ref="H5:I5"/></mergeCells><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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
    
    static testMethod void NEU_AirINTGood() 
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
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
        ll.IATA_Code__c='123';
        insert ll;     
        Location__c ld = new Location__c();
        ld.Name='Barcelona';
        ld.Country__c=CountryD.Id;
        ld.IATA_Code__c='987';
        insert ld;        
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        /*Fee__c fee = new Fee__c(Name = 'Service Rate 3', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Kg', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee; */
        NEU_AirINT u5=new NEU_AirINT();        
        //call all methods
        u5.documento1Name='test.xlsx';
        u5.documento1=Blob.valueOf('test');
        u5.upload();
        u5.processData();
        //create a data example very good, simulating an excel uploaded
        u5.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMjMiIHVuaXF1ZUNvdW50PSIyMiI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIENPTVBSQTwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgVkVOVEE8L3Q+PC9zaT48c2k+PHQ+T0JTRVJWQUNJT05FUzwvdD48L3NpPjxzaT48dD5vYnNlcnZhY2lvbmVzPC90Pjwvc2k+PHNpPjx0PlRFU1Q8L3Q+PC9zaT48c2k+PHQ+VElQTyBERSBDT05UUkFUTzwvdD48L3NpPjxzaT48dD5TUE9UPC90Pjwvc2k+PHNpPjx0PkZSRUNVRU5DSUE8L3Q+PC9zaT48c2k+PHQ+TCxNLFgsSixWLFMsRDwvdD48L3NpPjxzaT48dD5BRVJPTElORUE8L3Q+PC9zaT48c2k+PHQ+QUdFTlRFPC90Pjwvc2k+PHNpPjx0PklBVEEgQ09ERSBPUklHRU48L3Q+PC9zaT48c2k+PHQ+SUFUQSBDT0RFIERFU1RJTk88L3Q+PC9zaT48c2k+PHQ+VFJBTlNISVBNRU5UPC90Pjwvc2k+PHNpPjx0PlRJRU1QTyBERSBUUkFOU0lUTzwvdD48L3NpPjxzaT48dD5Nw4FYSU1PIEtHUy9NMzwvdD48L3NpPjxzaT48dD5QUkVDSU8gTcONTklNTzwvdD48L3NpPjxzaT48dD5oazwvdD48L3NpPjxzaT48dD5QZXIgTTM8L3Q+PC9zaT48L3NzdD4=';
        u5.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:P6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="D2" sqref="D2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="2" max="3" width="16.7109375" style="12" customWidth="1"/><col min="5" max="5" width="7.42578125" style="12" customWidth="1"/><col min="8" max="8" width="11.28515625" style="12" customWidth="1"/><col min="9" max="10" width="11.85546875" style="12" customWidth="1"/><col min="11" max="13" width="10.85546875" style="12"/><col min="16" max="16" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:16" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>8</v></c><c r="C1" s="1" t="s"><v>10</v></c><c r="D1" s="1" t="s"><v>12</v></c><c r="E1" s="1" t="s"><v>13</v></c><c r="F1" s="1" t="s"><v>1</v></c><c r="G1" s="1" t="s"><v>2</v></c><c r="H1" s="1" t="s"><v>14</v></c><c r="I1" s="1" t="s"><v>15</v></c><c r="J1" s="1" t="s"><v>16</v></c><c r="K1" s="1" t="s"><v>17</v></c><c r="L1" s="1" t="s"><v>18</v></c><c r="M1" s="1" t="s"><v>19</v></c><c r="N1" s="1" t="s"><v>3</v></c><c r="O1" s="2" t="s"><v>4</v></c><c r="P1" s="2" t="s"><v>5</v></c></row><row r="2" spans="1:16" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>21</v></c><c r="B2" s="10" t="s"><v>9</v></c><c r="C2" s="10" t="s"><v>11</v></c><c r="D2" s="5" t="s"><v>7</v></c><c r="E2" s="14" t="s"><v>7</v></c><c r="F2" s="6"><v>42856</v></c><c r="G2" s="6"><v>43069</v></c><c r="H2" s="14"><v>123</v></c><c r="I2" s="14"><v>987</v></c><c r="J2" s="14" t="s"><v>20</v></c><c r="K2" s="14"><v>12</v></c><c r="L2" s="14"><v>105</v></c><c r="M2" s="14"><v>49.99</v></c><c r="N2" s="4"><v>11.5</v></c><c r="O2" s="7"><v>50</v></c><c r="P2" s="8" t="s"><v>6</v></c></row><row r="3" spans="1:16" x14ac:dyDescent="0.25"><c r="B3" s="11"/><c r="C3" s="11"/></row><row r="4" spans="1:16" x14ac:dyDescent="0.25"><c r="B4" s="11"/><c r="C4" s="11"/></row><row r="5" spans="1:16" x14ac:dyDescent="0.25"><c r="E5" s="16"/><c r="F5" s="3"/><c r="H5" s="18"/><c r="I5" s="18"/><c r="J5" s="17"/><c r="M5" s="15"/></row><row r="6" spans="1:16" x14ac:dyDescent="0.25"><c r="B6" s="13"/></row></sheetData><mergeCells count="1"><mergeCell ref="H5:I5"/></mergeCells><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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
    
	static testMethod void NEU_AirINTGood1() 
	{
        NEU_StaticVariableHelper.setBoolean1(true);
        
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
        ll.IATA_Code__c='123';
        insert ll;     
        Location__c ld = new Location__c();
        ld.Name='Barcelona';
        ld.Country__c=CountryD.Id;
        ld.IATA_Code__c='987';
        insert ld;        
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;              
        Fee__c fee = new Fee__c(Name = 'Per Kg - 40 HC - San Antonio - Barcelona - TEST', Fee_Category__c = 'Air Freights', Rate_Type__c = 'Per Kg', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, RecordTypeId=Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId());     
        insert fee;
        NEU_AirINT u5=new NEU_AirINT();        
        //call all methods
        u5.documento1Name='test.xlsx';
        u5.documento1=Blob.valueOf('test');
        u5.upload();
        u5.processData();
        //create a data example very good, simulating an excel uploaded
        u5.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMjMiIHVuaXF1ZUNvdW50PSIyMiI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIENPTVBSQTwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgVkVOVEE8L3Q+PC9zaT48c2k+PHQ+T0JTRVJWQUNJT05FUzwvdD48L3NpPjxzaT48dD5vYnNlcnZhY2lvbmVzPC90Pjwvc2k+PHNpPjx0PlRFU1Q8L3Q+PC9zaT48c2k+PHQ+VElQTyBERSBDT05UUkFUTzwvdD48L3NpPjxzaT48dD5TUE9UPC90Pjwvc2k+PHNpPjx0PkZSRUNVRU5DSUE8L3Q+PC9zaT48c2k+PHQ+TCxNLFgsSixWLFMsRDwvdD48L3NpPjxzaT48dD5BRVJPTElORUE8L3Q+PC9zaT48c2k+PHQ+QUdFTlRFPC90Pjwvc2k+PHNpPjx0PklBVEEgQ09ERSBPUklHRU48L3Q+PC9zaT48c2k+PHQ+SUFUQSBDT0RFIERFU1RJTk88L3Q+PC9zaT48c2k+PHQ+VFJBTlNISVBNRU5UPC90Pjwvc2k+PHNpPjx0PlRJRU1QTyBERSBUUkFOU0lUTzwvdD48L3NpPjxzaT48dD5Nw4FYSU1PIEtHUy9NMzwvdD48L3NpPjxzaT48dD5QUkVDSU8gTcONTklNTzwvdD48L3NpPjxzaT48dD5oazwvdD48L3NpPjxzaT48dD5QZXIgS2c8L3Q+PC9zaT48L3NzdD4=';
        u5.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:P6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="M2" sqref="M2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="2" max="3" width="16.7109375" style="12" customWidth="1"/><col min="5" max="5" width="7.42578125" style="12" customWidth="1"/><col min="8" max="8" width="11.28515625" style="12" customWidth="1"/><col min="9" max="10" width="11.85546875" style="12" customWidth="1"/><col min="11" max="13" width="10.85546875" style="12"/><col min="16" max="16" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:16" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>8</v></c><c r="C1" s="1" t="s"><v>10</v></c><c r="D1" s="1" t="s"><v>12</v></c><c r="E1" s="1" t="s"><v>13</v></c><c r="F1" s="1" t="s"><v>1</v></c><c r="G1" s="1" t="s"><v>2</v></c><c r="H1" s="1" t="s"><v>14</v></c><c r="I1" s="1" t="s"><v>15</v></c><c r="J1" s="1" t="s"><v>16</v></c><c r="K1" s="1" t="s"><v>17</v></c><c r="L1" s="1" t="s"><v>18</v></c><c r="M1" s="1" t="s"><v>19</v></c><c r="N1" s="1" t="s"><v>3</v></c><c r="O1" s="2" t="s"><v>4</v></c><c r="P1" s="2" t="s"><v>5</v></c></row><row r="2" spans="1:16" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>21</v></c><c r="B2" s="10" t="s"><v>9</v></c><c r="C2" s="10" t="s"><v>11</v></c><c r="D2" s="5" t="s"><v>7</v></c><c r="E2" s="14" t="s"><v>7</v></c><c r="F2" s="6"><v>43018</v></c><c r="G2" s="6"><v>43050</v></c><c r="H2" s="14"><v>123</v></c><c r="I2" s="14"><v>987</v></c><c r="J2" s="14" t="s"><v>20</v></c><c r="K2" s="14"><v>12</v></c><c r="L2" s="14"><v>105</v></c><c r="M2" s="14"><v>49.99</v></c><c r="N2" s="4"><v>12</v></c><c r="O2" s="7"><v>23</v></c><c r="P2" s="8" t="s"><v>6</v></c></row><row r="3" spans="1:16" x14ac:dyDescent="0.25"><c r="B3" s="11"/><c r="C3" s="11"/></row><row r="4" spans="1:16" x14ac:dyDescent="0.25"><c r="B4" s="11"/><c r="C4" s="11"/></row><row r="5" spans="1:16" x14ac:dyDescent="0.25"><c r="E5" s="16"/><c r="F5" s="3"/><c r="H5" s="18"/><c r="I5" s="18"/><c r="J5" s="17"/><c r="M5" s="15"/></row><row r="6" spans="1:16" x14ac:dyDescent="0.25"><c r="B6" s="13"/></row></sheetData><mergeCells count="1"><mergeCell ref="H5:I5"/></mergeCells><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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