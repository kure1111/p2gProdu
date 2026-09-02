# Punto de retorno - Lote 1 depuracion (Cifid + triggers vacios)

Respaldo recuperado de PRODUCCION (org Produ, pak2gologistics) el 2026-09-02,
inmediatamente antes del borrado destructivo del lote 1.

Contenido: 22 clases Apex (familia Cifid completa + sus tests) y 13 triggers
con cuerpo vacio/comentado. Verificado: identicos a la version del repo en
ese momento (commit padre de este).

Para restaurar: desplegar el contenido de unpackaged/unpackaged con
`sf project deploy start --metadata-dir` o copiar los archivos de vuelta a
force-app y desplegar. El tag git `punto-retorno-lote1` marca este estado.
