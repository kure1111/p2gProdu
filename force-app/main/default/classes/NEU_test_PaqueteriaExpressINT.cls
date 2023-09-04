@isTest
private class NEU_test_PaqueteriaExpressINT {
//Test apex class NEU_UploadCustomers and NEU_UploadLots called to all methods
    static testMethod void NEU_PaqueteriaExpressINTError() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;               
        NEU_PaqueteriaExpressINT u4=new NEU_PaqueteriaExpressINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTgiIHVuaXF1ZUNvdW50PSIxNCI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5ESVNUQU5DSUE8L3Q+PC9zaT48c2k+PHQ+Vk9MVU1FTjwvdD48L3NpPjxzaT48dD5QRVNPPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBDT01QUkE8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIFZFTlRBPC90Pjwvc2k+PHNpPjx0PlBBUVVFVEVSSUEgRVhQUkVTUyBMVEw8L3Q+PC9zaT48c2k+PHQ+MCBBIDEsMjAwIEtNUzwvdD48L3NpPjxzaT48dD42MCBLR1MtOTAgS0dTPC90Pjwvc2k+PHNpPjx0PjYwIE0zLTkwIE0zPC90Pjwvc2k+PHNpPjx0PmFzZDwvdD48L3NpPjwvc3N0Pg==';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:I2"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="G3" sqref="G3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="23.5703125" bestFit="1" customWidth="1"/><col min="2" max="2" width="7.28515625" bestFit="1" customWidth="1"/><col min="3" max="3" width="13.42578125" bestFit="1" customWidth="1"/><col min="4" max="4" width="17.140625" bestFit="1" customWidth="1"/><col min="5" max="5" width="13.140625" bestFit="1" customWidth="1"/><col min="6" max="7" width="14.42578125" bestFit="1" customWidth="1"/><col min="8" max="8" width="15.42578125" bestFit="1" customWidth="1"/><col min="9" max="9" width="14" bestFit="1" customWidth="1"/></cols><sheetData><row r="1" spans="1:9" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>1</v></c><c r="C1" s="1" t="s"><v>2</v></c><c r="D1" s="1" t="s"><v>3</v></c><c r="E1" s="1" t="s"><v>4</v></c><c r="F1" s="1" t="s"><v>5</v></c><c r="G1" s="1" t="s"><v>6</v></c><c r="H1" s="1" t="s"><v>7</v></c><c r="I1" s="1" t="s"><v>8</v></c></row><row r="2" spans="1:9" x14ac:dyDescent="0.25"><c r="A2" s="2" t="s"><v>9</v></c><c r="B2" s="2" t="s"><v>13</v></c><c r="C2" s="3" t="s"><v>13</v></c><c r="D2" s="3" t="s"><v>13</v></c><c r="E2" s="3" t="s"><v>10</v></c><c r="F2" s="3" t="s"><v>12</v></c><c r="G2" s="3" t="s"><v>11</v></c><c r="H2" s="2" t="s"><v>13</v></c><c r="I2" s="4" t="s"><v>13</v></c></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/></worksheet>';
        u4.upload();
        u4.processData();
        u4.getratesDataNumber();
        u4.getshowColumn();
        u4.getcolumns();
        u4.getratesData();
        u4.saveLines();
    }
    static testMethod void NEU_PaqueteriaExpressINTFilter() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;               
        NEU_PaqueteriaExpressINT u4=new NEU_PaqueteriaExpressINT();
        //create a data example 5, simulating an excel uploaded
        u4.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTMiIHVuaXF1ZUNvdW50PSIxMyI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5ESVNUQU5DSUE8L3Q+PC9zaT48c2k+PHQ+Vk9MVU1FTjwvdD48L3NpPjxzaT48dD5QRVNPPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBDT01QUkE8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIFZFTlRBPC90Pjwvc2k+PHNpPjx0PlBBUVVFVEVSSUEgRVhQUkVTUyBMVEw8L3Q+PC9zaT48c2k+PHQ+MCBBIDEsMjAwIEtNUzwvdD48L3NpPjxzaT48dD42MCBLR1MtOTAgS0dTPC90Pjwvc2k+PHNpPjx0PjYwIE0zLTkwIE0zPC90Pjwvc2k+PC9zc3Q+';
        u4.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:I2"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="D3" sqref="D3"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="23.5703125" bestFit="1" customWidth="1"/><col min="2" max="2" width="7.28515625" bestFit="1" customWidth="1"/><col min="3" max="3" width="13.42578125" bestFit="1" customWidth="1"/><col min="4" max="4" width="17.140625" bestFit="1" customWidth="1"/><col min="5" max="5" width="13.140625" bestFit="1" customWidth="1"/><col min="6" max="7" width="14.42578125" bestFit="1" customWidth="1"/><col min="8" max="8" width="15.42578125" bestFit="1" customWidth="1"/><col min="9" max="9" width="14" bestFit="1" customWidth="1"/></cols><sheetData><row r="1" spans="1:9" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>1</v></c><c r="C1" s="1" t="s"><v>2</v></c><c r="D1" s="1" t="s"><v>3</v></c><c r="E1" s="1" t="s"><v>4</v></c><c r="F1" s="1" t="s"><v>5</v></c><c r="G1" s="1" t="s"><v>6</v></c><c r="H1" s="1" t="s"><v>7</v></c><c r="I1" s="1" t="s"><v>8</v></c></row><row r="2" spans="1:9" x14ac:dyDescent="0.25"><c r="A2" s="2" t="s"><v>9</v></c><c r="B2" s="2"/><c r="C2" s="3"/><c r="D2" s="3"/><c r="E2" s="3" t="s"><v>10</v></c><c r="F2" s="3" t="s"><v>12</v></c><c r="G2" s="3" t="s"><v>11</v></c><c r="H2" s="2"/><c r="I2" s="4"/></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/></worksheet>';
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
    static testMethod void NEU_PaqueteriaExpressINTGood() {
    	NEU_StaticVariableHelper.setBoolean1(true);
        //create record test necessaries
        Account a=new Account();
        a.Name='TEST';
        insert a;                    
        NEU_PaqueteriaExpressINT u5=new NEU_PaqueteriaExpressINT();        
        //call all methods
        u5.documento1Name='test.xlsx';
        u5.documento1=Blob.valueOf('test');
        u5.upload();
        u5.processData();
        //create a data example very good, simulating an excel uploaded
        u5.sharedStrings='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KPHNzdCB4bWxucz0iaHR0cDovL3NjaGVtYXMub3BlbnhtbGZvcm1hdHMub3JnL3NwcmVhZHNoZWV0bWwvMjAwNi9tYWluIiBjb3VudD0iMTQiIHVuaXF1ZUNvdW50PSIxNCI+PHNpPjx0PlRJUE8gREUgVEFSSUZBPC90Pjwvc2k+PHNpPjx0PkNBUlJJRVI8L3Q+PC9zaT48c2k+PHQ+RkVDSEEgREUgSU5JQ0lPPC90Pjwvc2k+PHNpPjx0IHhtbDpzcGFjZT0icHJlc2VydmUiPkZFQ0hBIFZFTkNJTUlFTlRPIDwvdD48L3NpPjxzaT48dD5ESVNUQU5DSUE8L3Q+PC9zaT48c2k+PHQ+Vk9MVU1FTjwvdD48L3NpPjxzaT48dD5QRVNPPC90Pjwvc2k+PHNpPjx0PlBSRUNJTyBERSBDT01QUkE8L3Q+PC9zaT48c2k+PHQ+UFJFQ0lPIERFIFZFTlRBPC90Pjwvc2k+PHNpPjx0PlBBUVVFVEVSSUEgRVhQUkVTUyBMVEw8L3Q+PC9zaT48c2k+PHQ+MCBBIDEsMjAwIEtNUzwvdD48L3NpPjxzaT48dD42MCBLR1MtOTAgS0dTPC90Pjwvc2k+PHNpPjx0PlRFU1Q8L3Q+PC9zaT48c2k+PHQ+NjAgTTMtOTAgTTM8L3Q+PC9zaT48L3NzdD4=';
        u5.worksheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac"><dimension ref="A1:I2"/><sheetViews><sheetView tabSelected="1" workbookViewId="0"><selection activeCell="I2" sqref="I2"/></sheetView></sheetViews><sheetFormatPr baseColWidth="10" defaultRowHeight="15" x14ac:dyDescent="0.25"/><cols><col min="1" max="1" width="23.5703125" bestFit="1" customWidth="1"/><col min="2" max="2" width="7.28515625" bestFit="1" customWidth="1"/><col min="3" max="3" width="13.42578125" bestFit="1" customWidth="1"/><col min="4" max="4" width="17.140625" bestFit="1" customWidth="1"/><col min="5" max="5" width="13.140625" bestFit="1" customWidth="1"/><col min="6" max="7" width="14.42578125" bestFit="1" customWidth="1"/><col min="8" max="8" width="15.42578125" bestFit="1" customWidth="1"/><col min="9" max="9" width="14" bestFit="1" customWidth="1"/></cols><sheetData><row r="1" spans="1:9" x14ac:dyDescent="0.25"><c r="A1" s="1" t="s"><v>0</v></c><c r="B1" s="1" t="s"><v>1</v></c><c r="C1" s="1" t="s"><v>2</v></c><c r="D1" s="1" t="s"><v>3</v></c><c r="E1" s="1" t="s"><v>4</v></c><c r="F1" s="1" t="s"><v>5</v></c><c r="G1" s="1" t="s"><v>6</v></c><c r="H1" s="1" t="s"><v>7</v></c><c r="I1" s="1" t="s"><v>8</v></c></row><row r="2" spans="1:9" x14ac:dyDescent="0.25"><c r="A2" s="2" t="s"><v>9</v></c><c r="B2" s="2" t="s"><v>12</v></c><c r="C2" s="3"><v>42736</v></c><c r="D2" s="3"><v>43039</v></c><c r="E2" s="3" t="s"><v>10</v></c><c r="F2" s="3" t="s"><v>13</v></c><c r="G2" s="3" t="s"><v>11</v></c><c r="H2" s="2"><v>45.35</v></c><c r="I2" s="4"><v>69.989999999999995</v></c></row></sheetData><pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/></worksheet>';
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