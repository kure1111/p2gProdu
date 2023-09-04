public class P2G_convertCsv {
    @AuraEnabled
    public static List<P2G_CreacionFoliosWrapper.folioMasivo> fileProcess(Blob csvFileBody) {
        List<P2G_CreacionFoliosWrapper.folioMasivo> listFolioCargo = new List<P2G_CreacionFoliosWrapper.folioMasivo>();
        try{
            String csvAsString = csvFileBody.toString();
            List<String> csvRows = csvAsString.split('\n');
            List<String> headers = csvRows[0].split(',');
            for (Integer i = 1; i < csvRows.size(); i++) {
                String[] csvValues = csvRows[i].split(',');
                P2G_CreacionFoliosWrapper.folioMasivo auxFolio= new P2G_CreacionFoliosWrapper.folioMasivo();
                auxFolio.folio = new P2G_CreacionFoliosWrapper.folio();
                auxFolio.folio.comercioExterior = 'No';
                auxFolio.folio.freighMode = 'Road';
                auxFolio.folio.serviceMode = 'NATIONAL';
                auxFolio.folio.servicetype = 'FTL';
                auxFolio.folio.quotationStatus = 'Quote being prepared';
                auxFolio.folio.CommunityStatus = 'CUSTOMER CREATED';
                auxFolio.cargo = new P2G_CreacionFoliosWrapper.cargoLine();
                for (Integer j = 0; j < headers.size(); j++) {
                    String fieldName = headers[j].trim();
                    String fieldValue = csvValues[j].trim();
                    switch on fieldName {
                        when 'Accountfor'{
                            auxFolio.folio.idAccount= fieldValue;
                        }
                        when 'Team'{
                            auxFolio.folio.team = fieldValue;
                        }
                        when 'CustomerReference'{
                            auxFolio.folio.reference= fieldValue;
                        }
                        when 'ReferenceForm'{
                            auxFolio.folio.idReferenceForm= fieldValue;
                        }
                        when 'SiteofLoad'{
                            auxFolio.folio.idSideLoad = fieldValue;
                        }
                        when 'SiteofDischarge'{
                            auxFolio.folio.idSideDischarged= fieldValue;
                        }
                        when 'SapServiceType'{
                            auxFolio.cargo.idSST = fieldValue;
                        }
                        when 'ETD'{
                            auxFolio.folio.etd = fieldValue;
                        }
                        when 'ETA'{
                            auxFolio.folio.eta= fieldValue;
                        }
                        when 'AwaitingLoadtime'{
                            auxFolio.folio.Awaitingloadtime = fieldValue;
                        }
                        when 'AwaitingUnloadtime'{
                            auxFolio.folio.Awaitingunloadtime= fieldValue;
                        }
                        when 'ContainerType'{
                            auxFolio.cargo.idConteinerType = fieldValue;
                        }
                        when 'ClaveProducto'{
                            auxFolio.cargo.idItem= fieldValue;
                            auxFolio.cargo.extencionItemName =fieldValue;
                        }
                        when 'DescripcionProducto'{
                            auxFolio.cargo.description= fieldValue;
                        }
                        when 'Material'{
                            auxFolio.cargo.MaterialPeligroso = fieldValue;
                        }
                        when 'Embalaje'{
                            auxFolio.cargo.Embalaje= fieldValue;
                        }
                        when 'Units'{
                            auxFolio.cargo.units = fieldValue;
                        }
                        when 'PesoBruto'{
                            auxFolio.cargo.pesoBruto= fieldValue;
                        }
                        when 'PesoNeto'{
                            auxFolio.cargo.pesoNeto = fieldValue;
                        }
                        when 'Currency'{
                            auxFolio.cargo.currencyIsoCode= fieldValue;
                			auxFolio.folio.rurrencyIsoCode = fieldValue;
                        }
                        when 'TotalVolume(m3)'{
                            auxFolio.cargo.totalShipping = fieldValue;
                        }
                        when 'Precio'{
                            auxFolio.cargo.itemPrice = fieldValue;
                        }
                    }
                }
                listFolioCargo.add(auxFolio);
            }
            P2G_CreacionFoliosWrapper.folioM cas = P2G_CargaMasivaMetodos.cambioId(listFolioCargo);
            P2G_cargaMasivaFolios batch = new P2G_cargaMasivaFolios(cas.folio,cas.cargo);
            Database.executeBatch(batch,5);
            //insert cas.folio;
            //List<Quote_Item_Line__c> pr = P2G_CargaMasivaMetodos.creaCargo(cas.folio,cas.cargo);
            //System.debug('Folios Creados: '+cas.folio);
        }catch(Exception e){
            System.debug('Error P2G_convertCsv:  '+e.getMessage()+e.getLineNumber());    
        } 
        return listFolioCargo;
    } 
}