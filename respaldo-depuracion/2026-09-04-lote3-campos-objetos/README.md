# Punto de retorno - Lote 3 (campos y objetos sin uso)

Respaldo previo al borrado del 2026-09-04 en Produ:
- 300 campos custom (ver campos-eliminados.csv): 107 sin ningun dato,
  190 formula/rollup/autonumber (valor calculado, sin perdida), y 3 lookups
  entrantes a objetos eliminados (Inventory_Exit__c.Material_Request__c,
  Item_Program__c.Workcell__c, Workorder__c.Workcell__c).
- 6 objetos: CSL_Shipment_Ratio__c, CSL_Shipment_RatioNA__c, Cred_Cifid__c,
  Material_Request__c, Workcell__c, Cuotas__c (3 registros de 2020).

La carpeta objects/ contiene la definicion COMPLETA (.object) de los 58
objetos afectados tal como estaban en Produ ese dia: cualquier campo se
puede recrear desde ahi (tipo, formula, picklist values, etc.).

Ademas: los campos borrados quedan 15 dias en la papelera de campos de
Setup y se restauran con un clic (datos incluidos). Tag git: punto-retorno-lote3.

Verificado antes de borrar: cero referencias en Apex, VF, LWC, Aura,
layouts, flexipages, flows, workflows, formulas, validation rules y list
views (metadata fresca de Produ del 2026-09-03).
