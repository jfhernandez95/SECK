IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'admusuarios') THEN
    CREATE TABLE "dba"."AdmUsuarios" (
    "id_agente" numeric(7,0) NOT NULL DEFAULT NULL, 
    "id_ek010ab" numeric(7,0) NOT NULL DEFAULT NULL, 
    "nombre" varchar(30) NOT NULL DEFAULT NULL, 
    "apellido_paterno" varchar(30) NOT NULL DEFAULT NULL, 
    "apellido_materno" varchar(30) NOT NULL DEFAULT NULL, 
    "password" varchar(10) NOT NULL DEFAULT NULL, 
    "correo" varchar(100) NOT NULL DEFAULT NULL, 
    "empleado" numeric(7,0) NOT NULL DEFAULT NULL, 
    "id_categoria" numeric(3,0) NOT NULL DEFAULT NULL, 
    "id_nivelagente" numeric(2,0) NOT NULL DEFAULT NULL, 
    "usuario" varchar(7) NOT NULL DEFAULT NULL, 
    "nivelcc" numeric(3,0) NOT NULL DEFAULT NULL, 
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id_agente", "id_ek010ab"))
END IF;

GO

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catperfiles') THEN
    CREATE TABLE "dba"."CatPerfiles" (
    "descripcion" varchar(40) NOT NULL, 
    "id" varchar(20) NOT NULL, 
    "irol" varchar(1) NOT NULL,
    "ultimaactualizacion" timestamp NOT NULL DEFAULT current timestamp,
    "ultimasincronizacion" timestamp DEFAULT NULL,
    "eliminar" bit NOT NULL DEFAULT 0, 
    PRIMARY KEY ("id"))
END IF;

GO

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catmediopublicidad') THEN
    CREATE TABLE "dba"."CatMedioPublicidad" (
    "descripcion" varchar(40) NOT NULL, 
    "id" numeric(3) NOT NULL, 
    "clave_compania" varchar(2) NOT NULL,
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

GO

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catcampaniapublicidad') THEN
    CREATE TABLE "dba"."CatCampaniaPublicidad" (
    "descripcion" varchar(100) NOT NULL, 
    "fecha_inicial" date NOT NULL, 
    "fecha_final" date NOT NULL, 
    "id_canal" numeric(5) NOT NULL, 
    "id_medio" numeric(3) NOT NULL,
    "clave_compania" varchar(2) NOT NULL,
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id_canal"))
END IF;

GO

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catpais') THEN
    CREATE TABLE "dba"."CatPais" (
    "descripcion" varchar(15) NOT NULL, 
    "id" varchar(15) NOT NULL, 
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

GO

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catestado') THEN
   CREATE TABLE "dba"."CatEstado" (
    "descripcion" varchar(70) NOT NULL, 
    "pais" varchar(15) NOT NULL, 
    "id" varchar(5) NOT NULL,
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

GO

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catmunicipio') THEN
   CREATE TABLE "dba"."CatMunicipio" (
    "descripcion" varchar(76) NOT NULL, 
    "estado" varchar(5) NOT NULL, 
    "id" varchar(25) NOT NULL,
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

GO

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catdesarrollointeres') THEN
   CREATE TABLE "dba"."CatDesarrolloInteres" (
    "id" varchar(3) NOT NULL, 
    "descripcion" varchar(104) NOT NULL, 
    "estado" varchar(5) NOT NULL,
    "mCliente" numeric(6) NOT NULL,
    "representante" varchar(92) NOT NULL,
    "sector" numeric(1) NOT NULL,
    "moneda" varchar(20) NOT NULL,
    "telefono" varchar(60) NOT NULL,
    "calle" varchar(100) NOT NULL,
    "colonia" varchar(50) NOT NULL,
    "estatus" varchar(11) NOT NULL,
    "pais" varchar(15) NOT NULL,
    "CP" varchar(6) NOT NULL,
    "clave_compania" varchar(2) NOT NULL,
    "id_identificador" varchar(8) NOT NULL,
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

GO

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catgradointeres') THEN
   CREATE TABLE "dba"."CatGradoInteres" (
    "id" numeric(1) NOT NULL, 
    "descripcion" varchar(30) NOT NULL, 
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

GO

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catrangoingresos') THEN
   CREATE TABLE "dba"."CatRangoIngresos" (
    "id" numeric(2) NOT NULL, 
    "descripcion" varchar(5) NOT NULL, 
    "rango_inicial" numeric(12,2) NOT NULL,
    "rango_final" numeric(12,2) NOT NULL,
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'opepermisodesarrollo') THEN
   CREATE TABLE "dba"."opePermisoDesarrollo" (
    "id" numeric(3) NOT NULL, 
    "descripcion" varchar(20) NOT NULL, 
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'opeidentificadordesarrollo') THEN
   CREATE TABLE "dba"."OpeIdentificadorDesarrollo" (
    "id" varchar(8) NOT NULL, 
    "descripcion" varchar(60) NOT NULL, 
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catesquemafinanciamiento') THEN
    CREATE TABLE "dba"."CatEsquemaFinanciamiento" (
    "id_esquemafinanciamiento" numeric(3) IDENTITY NOT NULL, 
    "id_financiamiento" numeric(3) NOT NULL, 
    "id_institucionCredito" numeric(3) NOT NULL, 
    "id_relacion" numeric(3) NOT NULL, 
    "descripcion_institucionCredito" varchar(50) NOT NULL, 
    "descripcion_financiamiento" varchar(50) NOT NULL,
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id_esquemafinanciamiento"))
END IF;

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catpuntoprospeccion') THEN
   CREATE TABLE "dba"."CatPuntoProspeccion" (
    "id" numeric(3) NOT NULL, 
    "descripcion" varchar(30) NOT NULL, 
    "clave_compania" varchar(2) NOT NULL, 
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catrangoingresos') THEN
   CREATE TABLE "dba"."CatRangoIngresos" (
    "id" numeric(3) NOT NULL, 
    "descripcion" varchar(30) NOT NULL, 
    "rango_inicial" numeric(12,2) NOT NULL,
    "rango_final" numeric(12,2) NOT NULL, 
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'admplaza') THEN
   CREATE TABLE "dba"."AdmPlaza" (
    "id" varchar(8) NOT NULL, 
    "descripcion" varchar(50) NOT NULL, 
    "nivel" numeric(3) NOT NULL,
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'catetapa') THEN
   CREATE TABLE "dba"."CatEtapa" (
    "id" numeric(3) NOT NULL, 
    "abrev_etapa" varchar(15) NOT NULL, 
    "estatus_lote" varchar(1) NOT NULL,
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;

IF NOT EXISTS(select table_name from systable WHERE ucase(table_name) = 'cattminteres') THEN
   CREATE TABLE "dba"."CatTmInteres" (
    "id" numeric(3) NOT NULL, 
    "descripcion" varchar(30) NOT NULL, 
    "ultimaActualizacion" timestamp NOT NULL DEFAULT current timestamp, 
    "ultimaSincronizacion" timestamp DEFAULT NULL, 
    "eliminar" bit NOT NULL DEFAULT 0 , 
    PRIMARY KEY ("id"))
END IF;