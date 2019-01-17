IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_delete_admusuarios') THEN
    DROP TRIGGER krm_tr_delete_admusuarios
END IF;

CREATE TRIGGER "krm_tr_delete_admusuarios" AFTER DELETE ON sm_agente
REFERENCING OLD AS old_registro
FOR EACH STATEMENT
BEGIN
    UPDATE  admusuarios
    SET     eliminar = 1
    FROM    admusuarios, old_registro
    WHERE   id_agente = old_registro.empleado
END;

GO

IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_delete_CatPerfiles') THEN
    DROP TRIGGER krm_tr_delete_CatPerfiles
END IF;

GO

CREATE TRIGGER "krm_tr_delete_CatPerfiles" AFTER DELETE ON sm_categorias
REFERENCING OLD AS old_registro
FOR EACH STATEMENT
BEGIN
    UPDATE  CatPerfiles
    SET     eliminar = 1
    FROM    CatPerfiles, old_registro
    WHERE   id = cast(old_registro.id_categoria as varchar(20))
END;

GO

IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_insertupdate_CatPerfiles') THEN
    DROP TRIGGER krm_tr_insertupdate_CatPerfiles
END IF;

GO

CREATE TRIGGER "krm_tr_InsertUpdate_CatPerfiles"
    //////////////////////////////////////////////////////////////////////////////////
    //      DESCRIPCIÓN: ACTUALIZA LA TABLA CATPERFILES SI LAS LLAVES COINCIDEN
    //                      
    //////////////////////////////////////////////////////////////////////////////////
    //      AUTOR:          FECHA:          MODIFICACION:
    //      -------------------------------------------------------------------------
    //      XIGM            2018/12/06     	CREACION
    // 
    //////////////////////////////////////////////////////////////////////////////////
AFTER INSERT, UPDATE ON sm_categorias
REFERENCING NEW AS new_registro
FOR EACH ROW
BEGIN
    IF EXISTS(select * from CatPerfiles where id = cast(new_registro.id_categoria as varchar(20))) THEN
        UPDATE  CatPerfiles
        set     descripcion = new_registro.descripcion,
                iRol = if new_registro.rel_cliente = 'S' then '2' else '3' endif, 
                eliminar = 0
        WHERE   id = cast(new_registro.id_categoria as varchar(20))
    END IF
END;

GO

IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_InsertUpdate_CatMedioPublicidad') THEN
    DROP TRIGGER krm_tr_InsertUpdate_CatMedioPublicidad
END IF;

GO

CREATE TRIGGER "krm_tr_InsertUpdate_CatMedioPublicidad"
    //////////////////////////////////////////////////////////////////////////////////
    //      DESCRIPCIÓN: ACTUALIZA LA TABLA CatMedioPublicidad SI LAS LLAVES COINCIDEN
    //                      
    //////////////////////////////////////////////////////////////////////////////////
    //      AUTOR:          FECHA:          MODIFICACION:
    //      -------------------------------------------------------------------------
    //      XIGM            2018/12/06     	CREACION
    // 
    //////////////////////////////////////////////////////////////////////////////////
AFTER INSERT, UPDATE ON sm_mediopublicidad
REFERENCING NEW AS new_registro
FOR EACH ROW
BEGIN
    IF EXISTS(select * from CatMedioPublicidad where id = new_registro.id_num_mediopublicidad) THEN
        UPDATE  CatMedioPublicidad
        set     descripcion = new_registro.desc_mediopublicidad,
                clave_compania = (select clave_compania from datos_compania),
                eliminar = 0
        WHERE   id = new_registro.id_num_mediopublicidad
    END IF
END;

GO

IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_delete_CatMedioPublicidad') THEN
    DROP TRIGGER krm_tr_delete_CatMedioPublicidad
END IF;

GO

CREATE TRIGGER "krm_tr_delete_CatMedioPublicidad" AFTER DELETE ON sm_mediopublicidad
REFERENCING OLD AS old_registro
FOR EACH STATEMENT
BEGIN
    UPDATE  CatMedioPublicidad
    SET     eliminar = 1
    FROM    CatMedioPublicidad, old_registro
    WHERE   id = old_registro.id_num_mediopublicidad
END;

IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_InsertUpdate_CatCampaniaPublicidad') THEN
    DROP TRIGGER krm_tr_InsertUpdate_CatCampaniaPublicidad
END IF;

GO

CREATE TRIGGER "krm_tr_InsertUpdate_CatCampaniaPublicidad"
    //////////////////////////////////////////////////////////////////////////////////
    //      DESCRIPCIÓN: ACTUALIZA LA TABLA CatMedioPublicidad SI LAS LLAVES COINCIDEN
    //                      
    //////////////////////////////////////////////////////////////////////////////////
    //      AUTOR:          FECHA:          MODIFICACION:
    //      -------------------------------------------------------------------------
    //      XIGM            2018/12/06     	CREACION
    // 
    //////////////////////////////////////////////////////////////////////////////////
AFTER INSERT, UPDATE ON sm_mediopublicidad_canal
REFERENCING NEW AS new_registro
FOR EACH ROW
BEGIN
    IF EXISTS(select * from CatCampaniaPublicidad where id_canal = new_registro.id_num_canal) THEN
        UPDATE  CatCampaniaPublicidad
        set     descripcion = new_registro.nom_canal,
                clave_compania = (select clave_compania from datos_compania),
                fecha_inicial = new_registro.fec_ini,
                fecha_final = new_registro.fec_fin,
                eliminar = 0
        WHERE   id_canal = new_registro.id_num_canal
    END IF
END;

GO

IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_delete_CatCampaniaPublicidad') THEN
    DROP TRIGGER krm_tr_delete_CatCampaniaPublicidad
END IF;

GO

CREATE TRIGGER "krm_tr_delete_CatCampaniaPublicidad" AFTER DELETE ON sm_mediopublicidad_canal
REFERENCING OLD AS old_registro
FOR EACH STATEMENT
BEGIN
    UPDATE  CatCampaniaPublicidad
    SET     eliminar = 1
    FROM    CatCampaniaPublicidad, old_registro
    WHERE   id_canal = old_registro.id_num_canal
END;

GO

IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_delete_catpais') THEN
    DROP TRIGGER krm_tr_delete_catpais
END IF;

GO

CREATE TRIGGER "krm_tr_delete_CatPais" AFTER DELETE ON paises
REFERENCING OLD AS old_registro
FOR EACH STATEMENT
BEGIN
    UPDATE  CatPais
    SET     eliminar = 1
    FROM    CatPais, old_registro
    WHERE   id = old_registro.pais
END;

IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_InsertUpdate_CatPais') THEN
    DROP TRIGGER krm_tr_InsertUpdate_CatPais
END IF;

GO

CREATE TRIGGER "krm_tr_InsertUpdate_CatPais"
    //////////////////////////////////////////////////////////////////////////////////
    //      DESCRIPCIÓN: ACTUALIZA LA TABLA CatMedioPublicidad SI LAS LLAVES COINCIDEN
    //                      
    //////////////////////////////////////////////////////////////////////////////////
    //      AUTOR:          FECHA:          MODIFICACION:
    //      -------------------------------------------------------------------------
    //      XIGM            2018/12/06     	CREACION
    // 
    //////////////////////////////////////////////////////////////////////////////////
AFTER INSERT, UPDATE ON paises
REFERENCING NEW AS new_registro
FOR EACH ROW
BEGIN
    IF EXISTS(select * from CatPais where id = new_registro.pais) THEN
        UPDATE  CatPais
        set     descripcion = new_registro.desc_pais,
                eliminar = 0
        WHERE   id = new_registro.pais
    ELSE
        INSERT INTO CatPais VALUES(new_registro.desc_pais, new_registro.pais, now(), null, 0)
    END IF
END;
