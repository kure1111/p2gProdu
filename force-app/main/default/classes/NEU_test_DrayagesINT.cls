@isTest
private class NEU_test_DrayagesINT {
//Test apex class NEU_UploadCustomers and NEU_UploadLots called to all methods
    static testMethod void NEU_DrayagesINTError() {
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
        Delivery_Zone__c Zone = new Delivery_Zone__c(Name='08080',  Port_Airport__c=ll.Id);
        insert Zone; 
        Delivery_Zone__c Zone1 = new Delivery_Zone__c(Name='08085',  Port_Airport__c=ll1.Id);
        insert Zone1; 
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  
        NEU_DrayagesINT u4=new NEU_DrayagesINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTYiIHVuaXF1ZUNvdW50PSIxNiI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+VElQTyBERSBDT05URU5FRE9SPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBDT01QUkE8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIFZFTlRBPC90Pjwvc2k+PHNpPjx0Pk9CU0VSVkFDSU9ORVM8L3Q+PC9zaT48c2k+PHQ+UGVyIENvbnRhaW5lcjwvdD48L3NpPjxzaT48dD5OQVZJRVJBPC90Pjwvc2k+PHNpPjx0PlBBSVMgUFVFUlRPPC90Pjwvc2k+PHNpPjx0PkVTVEFETyBQVUVSVE88L3Q+PC9zaT48c2k+PHQ+UFVFUlRPIERFIENBUkdBL0RFU0NBUkdBPC90Pjwvc2k+PHNpPjx0PlBJQ0tVUCBaT05FIChDUCk8L3Q+PC9zaT48c2k+PHQ+TU9EQUxJREFEPC90Pjwvc2k+PHNpPjx0PlJFQ0FSR088L3Q+PC9zaT48c2k+PHQ+MDgwODA8L3Q+PC9zaT48L3NzdD4=';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:N6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="G3" sqref="G3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="7" max="7" width="16.28515625" customWidth="1"/><col min="14" max="14" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:14" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>8</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>9</v></c><c r="F1" s="1" t="s"><v>10</v></c><c r="G1" s="1" t="s"><v>11</v></c><c r="H1" s="1" t="s"><v>12</v></c><c r="I1" s="1" t="s"><v>3</v></c><c r="J1" s="2" t="s"><v>13</v></c><c r="K1" s="1" t="s"><v>4</v></c><c r="L1" s="2" t="s"><v>5</v></c><c r="M1" s="1" t="s"><v>14</v></c><c r="N1" s="2" t="s"><v>6</v></c></row><row r="2" spans="1:14" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>7</v></c><c r="B2" s="5" t="s"><v>15</v></c><c r="C2" s="6" t="s"><v>16</v></c><c r="D2" s="6" t="s"><v>16</v></c><c r="E2" s="11" t="s"><v>16</v></c><c r="F2" s="5" t="s"><v>16</v></c><c r="G2" s="5" t="s"><v>16</v></c><c r="H2" s="16" t="s"><v>15</v></c><c r="I2" s="5" t="s"><v>16</v></c><c r="J2" s="12"/><c r="K2" s="4" t="s"><v>16</v></c><c r="L2" s="7" t="s"><v>16</v></c><c r="M2" s="14"/><c r="N2" s="8"/></row><row r="3" spans="1:14" s="9" customFormat="1" ht="16.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A3" s="4"/><c r="B3" s="5"/><c r="C3" s="10"/><c r="D3" s="6"/><c r="F3" s="5"/><c r="G3" s="5"/><c r="H3" s="5"/><c r="I3" s="5"/><c r="J3" s="13"/><c r="K3" s="4"/><c r="L3" s="7"/><c r="M3" s="15"/><c r="N3" s="8"/></row><row r="6" spans="1:14" x14ac:dyDescent="0.25"><c r="C6" s="3"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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
    static testMethod void NEU_DrayagesINTEmpty() {
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
        Delivery_Zone__c Zone = new Delivery_Zone__c(Name='08080',  Port_Airport__c=ll.Id);
        insert Zone;  
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  
        NEU_DrayagesINT u4=new NEU_DrayagesINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pgo8c3N0IHhtbG5zPSJodHRwOi8vc2NoZW1hcy5vcGVueG1sZm9ybWF0cy5vcmcvc3ByZWFkc2hlZXRtbC8yMDA2L21haW4iIGNvdW50PSIyMiIgdW5pcXVlQ291bnQ9IjE4Ij48c2k+PHQ+VElQTyBERSBUQVJJRkE8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5USVBPIERFIENPTlRFTkVET1I8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIENPTVBSQTwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgVkVOVEE8L3Q+PC9zaT48c2k+PHQ+T0JTRVJWQUNJT05FUzwvdD48L3NpPjxzaT48dD5OQVZJRVJBPC90Pjwvc2k+PHNpPjx0PlBBSVMgUFVFUlRPPC90Pjwvc2k+PHNpPjx0PkVTVEFETyBQVUVSVE88L3Q+PC9zaT48c2k+PHQ+UFVFUlRPIERFIENBUkdBL0RFU0NBUkdBPC90Pjwvc2k+PHNpPjx0PlBJQ0tVUCBaT05FIChDUCk8L3Q+PC9zaT48c2k+PHQ+TU9EQUxJREFEPC90Pjwvc2k+PHNpPjx0PlJFQ0FSR088L3Q+PC9zaT48c2k+PHQ+ZmdoPC90Pjwvc2k+PHNpPjx0PlBlcjwvdD48L3NpPjxzaT48dD5TYW4gQW50b25pbzwvdD48L3NpPjxzaT48dD4wODA4MDwvdD48L3NpPjwvc3N0Pg==';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:N6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="G3" sqref="G3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="7" max="7" width="16.28515625" customWidth="1"/><col min="14" max="14" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:14" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>7</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>8</v></c><c r="F1" s="1" t="s"><v>9</v></c><c r="G1" s="1" t="s"><v>10</v></c><c r="H1" s="1" t="s"><v>11</v></c><c r="I1" s="1" t="s"><v>3</v></c><c r="J1" s="2" t="s"><v>12</v></c><c r="K1" s="1" t="s"><v>4</v></c><c r="L1" s="2" t="s"><v>5</v></c><c r="M1" s="1" t="s"><v>13</v></c><c r="N1" s="2" t="s"><v>6</v></c></row><row r="2" spans="1:14" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>15</v></c><c r="B2" s="5"/><c r="C2" s="17" t="s"><v>14</v></c><c r="D2" s="17" t="s"><v>14</v></c><c r="E2" s="11"/><c r="F2" s="5"/><c r="G2" s="5" t="s"><v>16</v></c><c r="H2" s="16" t="s"><v>17</v></c><c r="I2" s="5" t="s"><v>14</v></c><c r="J2" s="12"/><c r="K2" s="4" t="s"><v>14</v></c><c r="L2" s="7" t="s"><v>14</v></c><c r="M2" s="14"/><c r="N2" s="8"/></row><row r="3" spans="1:14" s="9" customFormat="1" ht="16.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A3" s="4"/><c r="B3" s="5"/><c r="C3" s="10"/><c r="D3" s="6"/><c r="F3" s="5"/><c r="G3" s="5"/><c r="H3" s="5"/><c r="I3" s="5"/><c r="J3" s="13"/><c r="K3" s="4"/><c r="L3" s="7"/><c r="M3" s="15"/><c r="N3" s="8"/></row><row r="6" spans="1:14" x14ac:dyDescent="0.25"><c r="C6" s="3"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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
    static testMethod void NEU_DrayagesINTFilter() {
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
        Delivery_Zone__c Zone = new Delivery_Zone__c(Name='08080',  Port_Airport__c=ll.Id);
        insert Zone;       
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;       
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name='San Antonio - Barcelona',  State_of_Load__c=StateL.Id, Country_of_Discharge__c=CountryD.Id, Country_of_Load__c=CountryL.Id, Port_Airport_of_Discharge__c=ld.Id, Port_Airport_of_Load__c=ll.Id);
        insert route;        
        Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  
        NEU_DrayagesINT u4=new NEU_DrayagesINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTYiIHVuaXF1ZUNvdW50PSIxNiI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+VElQTyBERSBDT05URU5FRE9SPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBDT01QUkE8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIFZFTlRBPC90Pjwvc2k+PHNpPjx0Pk9CU0VSVkFDSU9ORVM8L3Q+PC9zaT48c2k+PHQ+UGVyIENvbnRhaW5lcjwvdD48L3NpPjxzaT48dD5OQVZJRVJBPC90Pjwvc2k+PHNpPjx0PlBBSVMgUFVFUlRPPC90Pjwvc2k+PHNpPjx0PkVTVEFETyBQVUVSVE88L3Q+PC9zaT48c2k+PHQ+UFVFUlRPIERFIENBUkdBL0RFU0NBUkdBPC90Pjwvc2k+PHNpPjx0PlBJQ0tVUCBaT05FIChDUCk8L3Q+PC9zaT48c2k+PHQ+TU9EQUxJREFEPC90Pjwvc2k+PHNpPjx0PlJFQ0FSR088L3Q+PC9zaT48c2k+PHQ+MDgwODA8L3Q+PC9zaT48L3NzdD4=';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:N6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="H2" sqref="H2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="7" max="7" width="16.28515625" customWidth="1"/><col min="14" max="14" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:14" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>8</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>9</v></c><c r="F1" s="1" t="s"><v>10</v></c><c r="G1" s="1" t="s"><v>11</v></c><c r="H1" s="1" t="s"><v>12</v></c><c r="I1" s="1" t="s"><v>3</v></c><c r="J1" s="2" t="s"><v>13</v></c><c r="K1" s="1" t="s"><v>4</v></c><c r="L1" s="2" t="s"><v>5</v></c><c r="M1" s="1" t="s"><v>14</v></c><c r="N1" s="2" t="s"><v>6</v></c></row><row r="2" spans="1:14" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>7</v></c><c r="B2" s="5"/><c r="C2" s="6"/><c r="D2" s="6"/><c r="E2" s="11"/><c r="F2" s="5"/><c r="G2" s="5"/><c r="H2" s="16" t="s"><v>15</v></c><c r="I2" s="5"/><c r="J2" s="12"/><c r="K2" s="4"/><c r="L2" s="7"/><c r="M2" s="14"/><c r="N2" s="8"/></row><row r="3" spans="1:14" s="9" customFormat="1" ht="16.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A3" s="4"/><c r="B3" s="5"/><c r="C3" s="10"/><c r="D3" s="6"/><c r="F3" s="5"/><c r="G3" s="5"/><c r="H3" s="5"/><c r="I3" s="5"/><c r="J3" s="13"/><c r="K3" s="4"/><c r="L3" s="7"/><c r="M3" s="15"/><c r="N3" s="8"/></row><row r="6" spans="1:14" x14ac:dyDescent="0.25"><c r="C6" s="3"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
        u4.filter.Carrier_Account__c=a.Id;
        u4.filter.Valid_From__c=Date.newInstance(2017,10,10);
        u4.filter.Valid_Until__c=Date.newInstance(2017,11,11);
        //loadFilter.Region__c=
        u4.filter.Route__r.Country_of_Load__c=ll.Country__c;
        u4.filter.Route__r.State_of_Load__c=ll.State__c;
        u4.filter.Route__r.Port_Airport_of_Load__c=ll.Id;
        u4.upload();
        u4.processData();
        u4.getratesDataNumber();
        u4.getshowColumn();
        u4.getcolumns();
        u4.getratesData();
        u4.saveLines();
    }
    static testMethod void NEU_DrayagesINTGood() {
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
        Delivery_Zone__c Zone = new Delivery_Zone__c(Name='08080',  Port_Airport__c=ll.Id);
        insert Zone;  
        Container_Type__c ct = new Container_Type__c();
        ct.Name='40 HC';
        insert ct;              
        /*Fee__c fee = new Fee__c(Name = 'Service Rate 3', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Kg', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee; */
        NEU_DrayagesINT u5=new NEU_DrayagesINT();        
        //call all methods
        u5.documento1Name='test.xlsx';
        u5.documento1=Blob.valueOf('test');
        u5.upload();
        u5.processData();
        //create a data example very good, simulating an excel uploaded
        u5.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMjMiIHVuaXF1ZUNvdW50PSIyMyI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+VElQTyBERSBDT05URU5FRE9SPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBDT01QUkE8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIFZFTlRBPC90Pjwvc2k+PHNpPjx0Pk9CU0VSVkFDSU9ORVM8L3Q+PC9zaT48c2k+PHQ+NDAgSEM8L3Q+PC9zaT48c2k+PHQ+b2JzZXJ2YWNpb25lczwvdD48L3NpPjxzaT48dD5QZXIgQ29udGFpbmVyPC90Pjwvc2k+PHNpPjx0PlRFU1Q8L3Q+PC9zaT48c2k+PHQ+TkFWSUVSQTwvdD48L3NpPjxzaT48dD5QQUlTIFBVRVJUTzwvdD48L3NpPjxzaT48dD5FU1RBRE8gUFVFUlRPPC90Pjwvc2k+PHNpPjx0PlBVRVJUTyBERSBDQVJHQS9ERVNDQVJHQTwvdD48L3NpPjxzaT48dD5QSUNLVVAgWk9ORSAoQ1ApPC90Pjwvc2k+PHNpPjx0PkFMTCBUUlVDSzwvdD48L3NpPjxzaT48dD5TRU5DSUxMTzwvdD48L3NpPjxzaT48dD5NT0RBTElEQUQ8L3Q+PC9zaT48c2k+PHQ+UkVDQVJHTzwvdD48L3NpPjxzaT48dD4wODA4MDwvdD48L3NpPjxzaT48dD5CYXJjZWxvbmE8L3Q+PC9zaT48c2k+PHQ+U3BhaW48L3Q+PC9zaT48L3NzdD4=';
        u5.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:N6"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="L3" sqref="L3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="14" customWidth="1"/><col min="7" max="7" width="16.28515625" customWidth="1"/><col min="14" max="14" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:14" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>11</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>12</v></c><c r="F1" s="1" t="s"><v>13</v></c><c r="G1" s="1" t="s"><v>14</v></c><c r="H1" s="1" t="s"><v>15</v></c><c r="I1" s="1" t="s"><v>3</v></c><c r="J1" s="2" t="s"><v>18</v></c><c r="K1" s="1" t="s"><v>4</v></c><c r="L1" s="2" t="s"><v>5</v></c><c r="M1" s="1" t="s"><v>19</v></c><c r="N1" s="2" t="s"><v>6</v></c></row><row r="2" spans="1:14" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="4" t="s"><v>9</v></c><c r="B2" s="5" t="s"><v>10</v></c><c r="C2" s="6"><v>42856</v></c><c r="D2" s="6"><v>43069</v></c><c r="E2" s="11" t="s"><v>22</v></c><c r="F2" s="5"/><c r="G2" s="5" t="s"><v>21</v></c><c r="H2" s="16" t="s"><v>20</v></c><c r="I2" s="5" t="s"><v>7</v></c><c r="J2" s="12" t="s"><v>16</v></c><c r="K2" s="4"><v>11.5</v></c><c r="L2" s="7"><v>20</v></c><c r="M2" s="14" t="s"><v>17</v></c><c r="N2" s="8" t="s"><v>8</v></c></row><row r="3" spans="1:14" s="9" customFormat="1" ht="16.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A3" s="4"/><c r="B3" s="5"/><c r="C3" s="10"/><c r="D3" s="6"/><c r="F3" s="5"/><c r="G3" s="5"/><c r="H3" s="5"/><c r="I3" s="5"/><c r="J3" s="13"/><c r="K3" s="4"/><c r="L3" s="7"/><c r="M3" s="15"/><c r="N3" s="8"/></row><row r="6" spans="1:14" x14ac:dyDescent="0.25"><c r="C6" s="3"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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