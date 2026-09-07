@isTest
private class AsignacionPlannerCtrlTest {

    static User crearPlanner(String nombre, String apellido, String alias) {
        Profile p = [SELECT Id FROM Profile WHERE Name IN ('Standard User','Usuario estándar') LIMIT 1];
        User u = new User(
            FirstName = nombre,
            LastName = apellido,
            Alias = alias,
            Email = alias + '@prueba-planner.test',
            Username = alias + System.currentTimeMillis() + '@prueba-planner.test',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es_MX',
            TimeZoneSidKey = 'America/Mexico_City',
            ProfileId = p.Id,
            IsActive = true
        );
        insert u;
        return u;
    }

    @isTest
    static void cargaCompletaYReemplazo() {
        User planner1 = crearPlanner('Zulema', 'PruebaUno', 'zpu1');
        User planner2 = crearPlanner('Zacarias', 'PruebaDos', 'zpd2');

        // registro preexistente que NO viene en el archivo (debe desactivarse en modo reemplazo)
        Asignacion_Planner__c previa = new Asignacion_Planner__c(
            Name = 'Ruta Vieja - Destino', Ruta__c = 'Ruta Vieja - Destino',
            Planner__c = planner1.Id, Activa__c = true);
        insert previa;

        List<AsignacionPlannerCtrl.Fila> filas = new List<AsignacionPlannerCtrl.Fila>();
        AsignacionPlannerCtrl.Fila f1 = new AsignacionPlannerCtrl.Fila();
        f1.ruta = 'Origen A - Destino A'; f1.consolidada = 'A - A';
        f1.planner = planner1.FirstName + ' ' + planner1.LastName; f1.activa = 'SI';
        filas.add(f1);
        AsignacionPlannerCtrl.Fila f2 = new AsignacionPlannerCtrl.Fila();
        f2.ruta = 'Origen B - Destino B'; f2.consolidada = 'B - B';
        f2.planner = planner2.Email; f2.activa = null; // por email, activa default
        filas.add(f2);
        AsignacionPlannerCtrl.Fila f3 = new AsignacionPlannerCtrl.Fila();
        f3.ruta = 'Origen C - Destino C'; f3.planner = 'Zulema'; f3.activa = 'NO'; // nombre de pila unico
        filas.add(f3);
        AsignacionPlannerCtrl.Fila f4 = new AsignacionPlannerCtrl.Fila();
        f4.ruta = 'Origen A - Destino A'; f4.planner = 'quien sea'; // duplicada -> aviso
        filas.add(f4);
        AsignacionPlannerCtrl.Fila f5 = new AsignacionPlannerCtrl.Fila();
        f5.ruta = 'Origen D - Destino D'; f5.planner = 'Usuario Inexistente XYZ'; // error
        filas.add(f5);
        AsignacionPlannerCtrl.Fila f6 = new AsignacionPlannerCtrl.Fila();
        f6.ruta = ''; f6.planner = 'x'; // sin ruta -> error
        filas.add(f6);
        AsignacionPlannerCtrl.Fila f7 = new AsignacionPlannerCtrl.Fila();
        f7.ruta = 'Origen E - Destino E'; f7.planner = ''; // sin planner -> error
        filas.add(f7);

        Test.startTest();
        AsignacionPlannerCtrl.Resultado res =
            AsignacionPlannerCtrl.subirBase(JSON.serialize(filas), true);
        Test.stopTest();

        System.assertEquals(3, res.creados, 'A, B y C creadas');
        System.assertEquals(3, res.errores.size(), 'inexistente + sin ruta + sin planner');
        System.assertEquals(1, res.avisos.size(), 'duplicada avisada');
        System.assertEquals(1, res.desactivados, 'la ruta vieja se desactiva en modo reemplazo');

        Asignacion_Planner__c c = [SELECT Activa__c, Planner__c FROM Asignacion_Planner__c WHERE Ruta__c = 'Origen C - Destino C'];
        System.assertEquals(false, c.Activa__c, 'activa NO respetada');
        System.assertEquals(planner1.Id, c.Planner__c, 'nombre de pila unico resuelto');

        Asignacion_Planner__c vieja = [SELECT Activa__c FROM Asignacion_Planner__c WHERE Id = :previa.Id];
        System.assertEquals(false, vieja.Activa__c);

        // segunda carga: actualiza en vez de crear, sin reemplazo
        f1.consolidada = 'A - A v2';
        AsignacionPlannerCtrl.Resultado res2 =
            AsignacionPlannerCtrl.subirBase(JSON.serialize(new List<AsignacionPlannerCtrl.Fila>{ f1 }), false);
        System.assertEquals(0, res2.creados);
        System.assertEquals(1, res2.actualizados);
        System.assertEquals(0, res2.desactivados, 'sin modo reemplazo no desactiva nada');

        // descarga
        List<Map<String, String>> filasDescarga = AsignacionPlannerCtrl.descargarBase();
        System.assert(filasDescarga.size() >= 4, 'descarga trae la base');
    }
}
