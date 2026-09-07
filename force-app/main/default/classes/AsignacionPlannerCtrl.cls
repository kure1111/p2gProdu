/**
 * Controlador de la pantalla "Carga Base Planner": descarga y carga masiva
 * de la base Asignacion_Planner__c (ruta -> planner) sin intervencion de sistemas.
 * La carga hace upsert por Ruta__c (llave externa) y resuelve el planner por
 * nombre completo, email o nombre de pila (si es unico entre usuarios activos).
 */
public with sharing class AsignacionPlannerCtrl {

    public class Fila {
        @AuraEnabled public String ruta { get; set; }
        @AuraEnabled public String consolidada { get; set; }
        @AuraEnabled public String planner { get; set; }
        @AuraEnabled public String activa { get; set; }
    }

    public class Resultado {
        @AuraEnabled public Integer creados = 0;
        @AuraEnabled public Integer actualizados = 0;
        @AuraEnabled public Integer desactivados = 0;
        @AuraEnabled public Integer conError = 0;
        @AuraEnabled public List<String> errores = new List<String>();
        @AuraEnabled public List<String> avisos = new List<String>();
    }

    @AuraEnabled(cacheable=false)
    public static List<Map<String, String>> descargarBase() {
        List<Map<String, String>> filas = new List<Map<String, String>>();
        for (Asignacion_Planner__c a : [
            SELECT Ruta__c, Ruta_Consolidada__c, Planner__r.Name, Activa__c
            FROM Asignacion_Planner__c
            ORDER BY Ruta__c
            LIMIT 10000
        ]) {
            filas.add(new Map<String, String>{
                'ruta' => a.Ruta__c,
                'consolidada' => a.Ruta_Consolidada__c,
                'planner' => a.Planner__r.Name,
                'activa' => a.Activa__c ? 'SI' : 'NO'
            });
        }
        return filas;
    }

    @AuraEnabled
    public static Resultado subirBase(String jsonFilas, Boolean reemplazarTodo) {
        Resultado res = new Resultado();
        List<Fila> filas = (List<Fila>) JSON.deserialize(jsonFilas, List<Fila>.class);

        // 1. limpiar y deduplicar por ruta (la primera aparicion gana)
        Map<String, Fila> porRuta = new Map<String, Fila>();
        Integer numLinea = 1;
        Set<String> tokensPlanner = new Set<String>();
        for (Fila f : filas) {
            numLinea++;
            String ruta = f.ruta == null ? '' : f.ruta.trim();
            String planner = f.planner == null ? '' : f.planner.trim();
            if (ruta == '') {
                res.errores.add('Linea ' + numLinea + ': sin ruta, se omite');
                continue;
            }
            String llave = ruta.toLowerCase();
            if (porRuta.containsKey(llave)) {
                res.avisos.add('Linea ' + numLinea + ': ruta repetida "' + ruta + '", se usa la primera');
                continue;
            }
            if (planner == '') {
                res.errores.add('Linea ' + numLinea + ': la ruta "' + ruta + '" no tiene planner, se omite');
                continue;
            }
            porRuta.put(llave, f);
            tokensPlanner.add(planner.toLowerCase());
        }

        // 2. resolver planners contra usuarios ACTIVOS (nombre completo, email o nombre de pila unico)
        Map<String, Id> resolverPlanner = new Map<String, Id>();
        Map<String, List<Id>> porNombrePila = new Map<String, List<Id>>();
        for (User u : [
            SELECT Id, Name, Email, FirstName
            FROM User
            WHERE IsActive = true AND UserType = 'Standard'
        ]) {
            if (u.Name != null) { resolverPlanner.put(u.Name.toLowerCase(), u.Id); }
            if (u.Email != null && !resolverPlanner.containsKey(u.Email.toLowerCase())) {
                resolverPlanner.put(u.Email.toLowerCase(), u.Id);
            }
            if (u.FirstName != null) {
                String fn = u.FirstName.toLowerCase();
                if (!porNombrePila.containsKey(fn)) { porNombrePila.put(fn, new List<Id>()); }
                porNombrePila.get(fn).add(u.Id);
            }
        }

        // 3. construir registros a upsertar
        List<Asignacion_Planner__c> aUpsertar = new List<Asignacion_Planner__c>();
        Set<String> rutasEnArchivo = new Set<String>();
        for (Fila f : porRuta.values()) {
            String ruta = f.ruta.trim();
            String tokenPlanner = f.planner.trim().toLowerCase();
            Id plannerId = resolverPlanner.get(tokenPlanner);
            if (plannerId == null && porNombrePila.containsKey(tokenPlanner)) {
                List<Id> candidatos = porNombrePila.get(tokenPlanner);
                if (candidatos.size() == 1) {
                    plannerId = candidatos[0];
                } else {
                    res.errores.add('Ruta "' + ruta + '": el planner "' + f.planner.trim()
                        + '" es ambiguo (' + candidatos.size() + ' usuarios con ese nombre de pila); usa nombre completo o email');
                    continue;
                }
            }
            if (plannerId == null) {
                res.errores.add('Ruta "' + ruta + '": no existe usuario ACTIVO llamado "' + f.planner.trim() + '"');
                continue;
            }
            Boolean activa = true;
            if (f.activa != null) {
                String a = f.activa.trim().toLowerCase();
                if (a == 'no' || a == 'false' || a == '0') { activa = false; }
            }
            Asignacion_Planner__c reg = new Asignacion_Planner__c();
            reg.Ruta__c = ruta;
            reg.Name = ruta.length() > 80 ? ruta.substring(0, 80) : ruta;
            reg.Ruta_Consolidada__c = f.consolidada == null ? null : f.consolidada.trim();
            reg.Planner__c = plannerId;
            reg.Activa__c = activa;
            aUpsertar.add(reg);
            rutasEnArchivo.add(ruta.toLowerCase());
        }

        // 4. upsert por la llave externa Ruta__c
        if (!aUpsertar.isEmpty()) {
            Database.UpsertResult[] resultados = Database.upsert(aUpsertar, Asignacion_Planner__c.Ruta__c, false);
            for (Integer i = 0; i < resultados.size(); i++) {
                if (resultados[i].isSuccess()) {
                    if (resultados[i].isCreated()) { res.creados++; } else { res.actualizados++; }
                } else {
                    res.errores.add('Ruta "' + aUpsertar[i].Ruta__c + '": ' + resultados[i].getErrors()[0].getMessage());
                }
            }
        }

        // 5. modo reemplazo: desactivar rutas activas que no vienen en el archivo
        if (reemplazarTodo == true) {
            List<Asignacion_Planner__c> aDesactivar = new List<Asignacion_Planner__c>();
            for (Asignacion_Planner__c existente : [
                SELECT Id, Ruta__c FROM Asignacion_Planner__c WHERE Activa__c = true LIMIT 10000
            ]) {
                if (!rutasEnArchivo.contains(existente.Ruta__c.toLowerCase())) {
                    existente.Activa__c = false;
                    aDesactivar.add(existente);
                }
            }
            if (!aDesactivar.isEmpty()) {
                update aDesactivar;
                res.desactivados = aDesactivar.size();
            }
        }

        res.conError = res.errores.size();
        return res;
    }
}
