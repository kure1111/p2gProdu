@isTest
private class NEU_test_OtherINT {
//Test apex class NEU_UploadCustomers and NEU_UploadLots called to all methods
    static testMethod void NEU_OtherINTError() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;               
        /*Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;  */
        NEU_OtherINT u4=new NEU_OtherINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTUiIHVuaXF1ZUNvdW50PSIxMSI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgQ09NUFJBPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBWRU5UQTwvdD48L3NpPjxzaT48dD5PQlNFUlZBQ0lPTkVTPC90Pjwvc2k+PHNpPjx0Pk5PTUJSRSBERSBMQSBUQVJJRkE8L3Q+PC9zaT48c2k+PHQ+VEhDPC90Pjwvc2k+PHNpPjx0PlBlcjwvdD48L3NpPjxzaT48dD5oams8L3Q+PC9zaT48L3NzdD4=';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:H5"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="H3" sqref="H3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="12" bestFit="1" customWidth="1"/><col min="2" max="2" width="14" customWidth="1"/><col min="8" max="8" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:8" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>7</v></c><c r="B1" s="1" t="s"><v>0</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>3</v></c><c r="F1" s="1" t="s"><v>4</v></c><c r="G1" s="2" t="s"><v>5</v></c><c r="H1" s="2" t="s"><v>6</v></c></row><row r="2" spans="1:8" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="10" t="s"><v>8</v></c><c r="B2" s="4" t="s"><v>9</v></c><c r="C2" s="5" t="s"><v>10</v></c><c r="D2" s="6" t="s"><v>10</v></c><c r="E2" s="6" t="s"><v>10</v></c><c r="F2" s="4" t="s"><v>10</v></c><c r="G2" s="7" t="s"><v>10</v></c><c r="H2" s="8"/></row><row r="5" spans="1:8" x14ac:dyDescent="0.25"><c r="D5" s="3"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
        u4.upload();
        u4.processData();
        u4.getratesDataNumber();
        u4.getshowColumn();
        u4.getcolumns();
        u4.getratesData();
        u4.saveLines();
    }
    static testMethod void NEU_OtherINTFilter() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;               
        /*Fee__c fee = new Fee__c(Name = 'Standard-Per Container-40 HC-San Antonio-Barcelona-TEST', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Container', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee;*/  
        NEU_OtherINT u4=new NEU_OtherINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iOSIgdW5pcXVlQ291bnQ9IjkiPjxzaT48dD5USVBPIERFIFRBUklGQTwvdD48L3NpPjxzaT48dD5DQVJSSUVSPC90Pjwvc2k+PHNpPjx0PkZFQ0hBIERFIElOSUNJTzwvdD48L3NpPjxzaT48dCB4bWw6c3BhY2U9InByZXNlcnZlIj5GRUNIQSBWRU5DSU1JRU5UTyA8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIENPTVBSQTwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgVkVOVEE8L3Q+PC9zaT48c2k+PHQ+T0JTRVJWQUNJT05FUzwvdD48L3NpPjxzaT48dD5OT01CUkUgREUgTEEgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PlRIQzwvdD48L3NpPjwvc3N0Pg==';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:H5"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="B2" sqref="B2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="12" bestFit="1" customWidth="1"/><col min="2" max="2" width="14" customWidth="1"/><col min="8" max="8" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:8" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>7</v></c><c r="B1" s="1" t="s"><v>0</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>3</v></c><c r="F1" s="1" t="s"><v>4</v></c><c r="G1" s="2" t="s"><v>5</v></c><c r="H1" s="2" t="s"><v>6</v></c></row><row r="2" spans="1:8" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="10" t="s"><v>8</v></c><c r="B2" s="4"/><c r="C2" s="5"/><c r="D2" s="6"/><c r="E2" s="6"/><c r="F2" s="4"/><c r="G2" s="7"/><c r="H2" s="8"/></row><row r="5" spans="1:8" x14ac:dyDescent="0.25"><c r="D5" s="3"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
        u4.filter.Carrier_Account__c=a.Id;
        u4.filter.Valid_From__c=Date.newInstance(2017,10,10);
        u4.filter.Valid_Until__c=Date.newInstance(2017,11,11);
        u4.filter.Rate_Type__c='Per Container';
        u4.upload();
        u4.processData();
        u4.getratesDataNumber();
        u4.getshowColumn();
        u4.getcolumns();
        u4.getratesData();
        u4.saveLines();
    }
    static testMethod void NEU_OtherINTGood() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;                    
        /*Fee__c fee = new Fee__c(Name = 'Service Rate 3', Fee_Category__c = 'Road Freights', Rate_Type__c = 'Per Kg', Account_for__c=a.Id, Valid_Until__c=Date.newInstance(2017,11,11), Valid_from__c=Date.newInstance(2017,10,10), Buy_Rate__c=12, Fee_Rate__c=23, Container_Type__c=ct.Id);     
        insert fee; */
        NEU_OtherINT u5=new NEU_OtherINT();        
        //call all methods
        u5.documento1Name='test.xlsx';
        u5.documento1=Blob.valueOf('test');
        u5.upload();
        u5.processData();
        //create a data example very good, simulating an excel uploaded
        u5.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTIiIHVuaXF1ZUNvdW50PSIxMiI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5QUkVDSU8gREUgQ09NUFJBPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBWRU5UQTwvdD48L3NpPjxzaT48dD5PQlNFUlZBQ0lPTkVTPC90Pjwvc2k+PHNpPjx0Pm9ic2VydmFjaW9uZXM8L3Q+PC9zaT48c2k+PHQ+VEVTVDwvdD48L3NpPjxzaT48dD5OT01CUkUgREUgTEEgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PlRIQzwvdD48L3NpPjxzaT48dD5QZXIgQ29udGFpbmVyPC90Pjwvc2k+PC9zc3Q+';
        u5.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:H5"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="A3" sqref="A3:XFD3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="12" bestFit="1" customWidth="1"/><col min="2" max="2" width="14" customWidth="1"/><col min="8" max="8" width="14" customWidth="1"/></cols><sheetData><row r="1" spans="1:8" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>9</v></c><c r="B1" s="1" t="s"><v>0</v></c><c r="C1" s="1" t="s"><v>1</v></c><c r="D1" s="1" t="s"><v>2</v></c><c r="E1" s="1" t="s"><v>3</v></c><c r="F1" s="1" t="s"><v>4</v></c><c r="G1" s="2" t="s"><v>5</v></c><c r="H1" s="2" t="s"><v>6</v></c></row><row r="2" spans="1:8" s="9" customFormat="1" ht="19.5" customHeight="1" x14ac:dyDescent="0.25"><c r="A2" s="10" t="s"><v>10</v></c><c r="B2" s="4" t="s"><v>11</v></c><c r="C2" s="5" t="s"><v>8</v></c><c r="D2" s="6"><v>42856</v></c><c r="E2" s="6"><v>43069</v></c><c r="F2" s="4"><v>11.5</v></c><c r="G2" s="7"><v>30</v></c><c r="H2" s="8" t="s"><v>7</v></c></row><row r="5" spans="1:8" x14ac:dyDescent="0.25"><c r="D5" s="3"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/><pageSetup paperSize="9" orientation="portrait" r:id="rId1"/></worksheet>';
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