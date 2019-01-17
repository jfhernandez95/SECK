IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatMedioPublicidad') THEN
    DROP TRIGGER krm_tr_ABC_CatMedioPublicidad
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatMedioPublicidad BEFORE INSERT, UPDATE, DELETE
ON sm_mediopublicidad
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        IF NOT EXISTS(select * from CatMedioPublicidad where id = new_row.id_num_mediopublicidad) THEN
            INSERT INTO CatMedioPublicidad (descripcion, id, clave_compania, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.desc_mediopublicidad, new_row.id_num_mediopublicidad, (select clave_compania from datos_compania), now(), null, 0)
        ELSEIF EXISTS(select * from CatMedioPublicidad where id = new_row.id_num_mediopublicidad) THEN
            UPDATE  CatMedioPublicidad
            SET     descripcion = new_row.desc_mediopublicidad,
                    clave_compania = (select clave_compania from datos_compania),
                    ultimaActualizacion = now()
            WHERE   id = new_row.id_num_mediopublicidad;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  CatMedioPublicidad
        SET     eliminar = 1,
	ultimaActualizacion = now()
        WHERE   id = old_row.id_num_mediopublicidad;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  CatMedioPublicidad
        SET     descripcion = new_row.desc_mediopublicidad,
                clave_compania = (select clave_compania from datos_compania),
                ultimaActualizacion = now()
        WHERE   id = new_row.id_num_mediopublicidad;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;