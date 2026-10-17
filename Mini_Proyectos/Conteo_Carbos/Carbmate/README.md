# App Conteo Carbos

Aplicación personal para registrar alimentos y calcular carbohidratos. V1 está
orientada a Android y funciona localmente, sin requerir conexión a Internet.

## Objetivo de V1

- Registrar alimentos con una o más medidas y sus carbohidratos asociados.
- Importar alimentos desde CSV.
- Calcular carbohidratos a partir de varias líneas de alimentos y cantidades.
- No guardar comidas calculadas en esta versión.

El modelo definitivo de datos todavía está en diseño. Por eso el proyecto aún
no define tablas ni implementa alimentos, importación o calculadora.

## Estado actual

El proyecto contiene el scaffold Flutter para Android, una pantalla inicial sin
funcionalidad de producto, análisis estático, un test de widget y la apertura
preparada de SQLite con soporte de migraciones. No crea tablas de negocio.

## Stack

- Flutter y Dart.
- Android como plataforma inicial.
- SQLite local mediante `sqlite_async`, con SQL explícito.
- `path_provider` para ubicar los archivos locales de la aplicación.
- `flutter_lints` para análisis estático.

No hay backend ni sincronización remota. iOS podrá añadirse más adelante; Windows
y escritorio no son objetivos de V1.

## Arquitectura

La dirección prevista de dependencias es:

```text
UI (lib/app y futuras features)
	-> aplicación/dominio y contratos de repositorio
	-> implementaciones de repositorio
	-> SQLite (sqlite_async)
```

La UI y las reglas de negocio no deben depender de SQLite ni de mapas de filas.
Los contratos y modelos de alimentos se crearán cuando se defina el modelo de
datos; no se agregan repositorios genéricos ni capas vacías por anticipado.

La estructura actual es intencionalmente pequeña:

```text
lib/
├── app/                 # Aplicación Flutter y composición de la UI
├── core/persistence/    # Apertura de SQLite y migraciones compartidas
└── main.dart            # Punto de entrada
test/                    # Tests de Flutter
android/                 # Proyecto nativo Android generado por Flutter
```

`AppDatabase` resuelve la ubicación local, abre una instancia de SQLite y aplica
las migraciones declaradas. La lista de migraciones está vacía por ahora; el
paquete crea únicamente su tabla interna de control de versiones. No se ha
decidido ni implementado el esquema de alimentos.

## Persistencia

La base se guarda en el directorio de soporte de la aplicación, aislado por
Android para esta app. `sqlite_async` permite ejecutar SQL directamente y
gestionar migraciones sin ORM ni generación de código. El helper vive en la capa
de persistencia; las capas superiores recibirán contratos y modelos de dominio,
no objetos propios de SQLite.

## Decisiones arquitectónicas (ADR)

### ADR-001: Flutter y Dart

Se eligen Flutter y Dart frente a React Native o Ionic para construir la app
móvil con un único toolkit y lenguaje, usando los widgets y herramientas de
desarrollo integrados de Flutter. La decisión mantiene abierta la incorporación
de iOS sin hacer de escritorio un requisito.

### ADR-002: Android-first

V1 se genera para Android. iOS queda como posible plataforma futura; no se
incluyen targets de escritorio ni se agregan ahora configuraciones que V1 no
necesita.

### ADR-003: SQLite local, sin backend

La app debe funcionar offline y los datos son personales. SQLite local cubre esa
necesidad sin introducir servidores, cuentas, sincronización ni infraestructura
remota en V1.

### ADR-004: SQL explícito, sin ORM

Se adopta `sqlite_async` para acceso asíncrono a SQLite con SQL explícito y
migraciones. No se incorpora Drift ni otro ORM mientras no exista una necesidad
técnica concreta que justifique cambiar esta decisión.

### ADR-005: Repositorios y separación de persistencia

Las funcionalidades dependerán de contratos de repositorio y modelos de
dominio; las implementaciones de datos traducirán esos modelos a SQL. Esto
permite cambiar la persistencia sin acoplar la lógica de negocio a SQLite, sin
añadir repositorios genéricos ni capas que no tengan responsabilidad real.

### ADR-006: Modelo de datos pendiente

Las tablas y entidades de alimentos se definirán aparte antes de implementarlas.
Hasta entonces solo se prepara la apertura y el mecanismo de migraciones, sin
adelantar un esquema provisional que pueda condicionar el diseño.

## Requisitos previos

- Flutter SDK estable y Dart (incluido en Flutter).
- Android Studio con Android SDK, Command-line Tools y un emulador configurado,
	o un dispositivo Android conectado.
- Visual Studio Code con la extensión Flutter, o un editor compatible.

El identificador Android actual es `com.Vialesoft.carbmate`. Puede cambiarse
antes de publicar la aplicación.

## Ejecutar

Desde esta carpeta del proyecto, `Carbmate/`:

```powershell
flutter pub get
flutter emulators
flutter emulators --launch Medium_Phone_API_37.0
flutter run -d Medium_Phone_API_37.0
```

El emulador solo hace falta para probar la app visualmente. También se puede
seleccionar un dispositivo Android conectado. Mientras `flutter run` está activo,
pulsá `r` en esa terminal para aplicar cambios con hot reload; `R` hace hot
restart y `q` detiene la ejecución.

## Calidad y tests

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

El test actual verifica que la pantalla inicial se renderice. El build Android
comprueba la compatibilidad de compilación de los plugins; el uso de SQLite en
una funcionalidad real se validará al integrar el primer caso de uso.

## Roadmap

- **V1:** catálogo de alimentos, importación CSV y calculadora; las comidas
	calculadas no se guardan.
- **V2:** recetas, comidas guardadas e historial.
- **V3:** exportación.
- **V4+:** importación de datos de FreeStyle Libre, análisis de glucosa y
	carbohidratos, estadísticas y visualizaciones.

Insulina no forma parte del alcance actual; cualquier funcionalidad relacionada
queda sujeta a una decisión futura.
