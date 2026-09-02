# Punto de retorno - Lote 2a depuracion (clases muertas sueltas)

Respaldo de PRODUCCION (org Produ) del 2026-09-02, antes del borrado del lote 2a.
14 clases (7 parejas clase+test). Pre-verificado en Produ: los 7 tests PASAN y
cada clase tiene cobertura >=75% por su propio test (75%-100%), garantizando
que la restauracion con RunSpecifiedTests es posible.

Hashes SHA256 pre-borrado en hashes-sha256.txt.
Restaurar: sf project deploy start --metadata-dir unpackaged/unpackaged -o Produ
  --test-level RunSpecifiedTests --tests <los 7 tests>
Tag git: punto-retorno-lote2

Ademas este lote elimina del REPO (no existen en Produ):
P2G_synchronizationSFSAP y RamkiSoft__ProfileRelatedHelper.

Excluidas del lote tras el pre-chequeo:
- S3 y AWS_XMLDom: VIVAS (S3 la usan NEU_CartaPorteSavePDF, APX_UploadFiles,
  NEU_MD_Associated_Documents, NEU_Upload_Associated_Photos; el analisis previo
  las marco muertas por un bug con nombres de 2 caracteres).
- NEU_Data_Generator, SurveyTestingUtil, PK2_Utils_2, NEU_Pass_test/2/3:
  referenciadas por tests de clases vivas; requieren editar esos tests primero.
- superSort, NEU_Import_Export_Comparison_save_pdf, P2G_LockSellPrice,
  P2G_AssociatedDocumentsHandler: sin test = sin camino de regreso facil;
  pendientes de decision.
