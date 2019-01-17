IF EXISTS(SELECT proc_name FROM sysprocedure WHERE proc_name = 'sp_KRMCatalogo_AdmUsuarios') THEN
     DROP PROCEDURE dba.sp_KRMCatalogo_AdmUsuarios;
END IF;

GO

CREATE PROCEDURE "DBA"."sp_KRMCatalogo_AdmUsuarios"()
AS
BEGIN
    INSERT INTO admusuarios
    SELECT	DISTINCT
            a.empleado,
            ek.num,
            nombre = nom_empleado,
            apellido_paterno = a.ap_paterno_empleado,
            apellido_materno = a.ap_materno_empleado,
            password = a.password, 
            correo = ek.email, 
            empleado = a.empleado, 
            id_categoria = 
            if c.rel_cliente = 'S' then 
                -1
            else
                a.id_categoria
            endif,
            id_nivelagente = id_num_nivelagente, 
            usuario = cast(ek.num as varchar(7)), 
            ek.nivelcc,
            now(),
            NULL,
            0
    FROM    sm_agente a
    JOIN    ek010ab ek 
    ON      ek.num = a.id_usuario
    JOIN    sm_categorias c 
    ON      c.id_categoria = a.id_categoria
    WHERE   ek.email is not null
    AND     a.password is not null
    AND     NOT EXISTS(
    SELECT  *
    FROM    admusuarios
    WHERE   id_agente = a.empleado
    AND     id_ek010ab = ek.num)
    group by a.ap_materno_empleado, a.ap_paterno_empleado, a.password, ek.email, a.empleado, a.id_categoria, id_num_nivelagente, nom_empleado, usuario, c.rel_cliente, ek.nivelcc, ek.num
    IF EXISTS(SELECT * FROM admusuarios)
    BEGIN
        select  *
        from    admusuarios
    END
END;

GO

IF EXISTS(SELECT proc_name FROM sysprocedure WHERE proc_name = 'sp_KRMCatalogo_CatPerfiles') THEN
     DROP PROCEDURE dba.sp_KRMCatalogo_CatPerfiles;
END IF;

GO 

CREATE PROCEDURE sp_KRMCatalogo_CatPerfiles()
AS
BEGIN
    INSERT INTO CatPerfiles
    SELECT  
            descripcion = ct.descripcion, 
            id = cast(ct.id_categoria as varchar(20)), 
            iRol = if ct.rel_cliente = 'S' then '2' else '3' endif,
            now(),
            null,
            0
    FROM    sm_categorias ct
    WHERE   id NOT IN(
    SELECT  CatPerfiles.id
    FROM    CatPerfiles)
    order by ct.id_categoria
    IF EXISTS(select * from CatPerfiles)
    BEGIN
        SELECT  *
        FROM    CatPerfiles
    END
END;

IF EXISTS(SELECT proc_name FROM sysprocedure WHERE proc_name = 'sp_KRMCatalogo_CatMedioPublicidad') THEN
     DROP PROCEDURE dba.sp_KRMCatalogo_CatMedioPublicidad;
END IF;

GO

CREATE PROCEDURE "DBA"."sp_KRMCatalogo_CatMedioPublicidad"()
AS
BEGIN
    INSERT INTO CatMedioPublicidad
    SELECT  
        descripcion = desc_mediopublicidad, 
        id = id_num_mediopublicidad,
        clave_compania = (select clave_compania from datos_compania),
        now(),
        null,
        0
	FROM    sm_mediopublicidad
    WHERE   id NOT IN (
        select  id
        from    CatMedioPublicidad)
        order by id
        IF EXISTS(select * from CatMedioPublicidad)
        BEGIN
            select  *
            from    CatMedioPublicidad
        END   
END;

GO

IF EXISTS(SELECT proc_name FROM sysprocedure WHERE proc_name = 'sp_KRMCatalogo_CatCampaniaPublicidad') THEN
     DROP PROCEDURE dba.sp_KRMCatalogo_CatCampaniaPublicidad;
END IF;

GO

CREATE PROCEDURE sp_KRMCatalogo_CatCampaniaPublicidad()
AS
BEGIN
    INSERT INTO CatCampaniaPublicidad
    SELECT 
                descripcion = if length(nom_canal) > 50 then substring(nom_canal, 0, 50) else nom_canal endif, 
                fecha_inicial = fec_ini,
                fecha_final = fec_fin, 
                id_canal = id_num_canal, 
                id_medio = id_num_medio, 
				clave_compania = (select clave_Compania from datos_compania),
                now(),
                null,
                0
        FROM    sm_mediopublicidad_canal
        WHERE    fecha_inicial<=getdate() AND  fecha_final>= getdate()
        AND      id_canal NOT IN (
        SELECT  id_canal
        FROM    CatCampaniaPublicidad)
        IF EXISTS(SELECT * FROM CatCampaniaPublicidad)
        BEGIN
            SELECT  *
            FROM    CatCampaniaPublicidad
        END
END;

IF EXISTS(SELECT proc_name FROM sysprocedure WHERE proc_name = 'sp_KRMCatalogo_CatPais') THEN
     DROP PROCEDURE dba.sp_KRMCatalogo_CatPais;
END IF;

GO

CREATE PROCEDURE sp_KRMCatalogo_CatPais()
AS
BEGIN
    INSERT INTO CatPais
    SELECT
            descripcion = desc_pais, 
            id = pais, 
            now(),
            null,
            0
    FROM    paises
    WHERE   id not in (
    SELECT  pais
    FROM    CatPais)
    IF EXISTS(select * from CatPais)
    BEGIN
        SELECT  *
        FROM    CatPais
    END
END;