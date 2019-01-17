IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_opePermisoDesarrollo') THEN
    DROP TRIGGER krm_tr_ABC_opePermisoDesarrollo
END IF;
GO
CREATE TRIGGER krm_tr_ABC_opePermisoDesarrollo BEFORE INSERT, UPDATE, DELETE
ON ek090ab
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        IF NOT EXISTS(select * from opePermisoDesarrollo where id = new_row.nivel) THEN
            INSERT INTO opePermisoDesarrollo (id, descripcion, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.nivel, new_row.descripcion, now(), null, 0)
        ELSEIF EXISTS(select * from opePermisoDesarrollo where id = new_row.nivel) THEN
            UPDATE  opePermisoDesarrollo
            SET     descripcion = new_row.descripcion,
                    ultimaActualizacion = now()
            WHERE   id = new_row.nivel;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  opePermisoDesarrollo
        SET     eliminar = 1,
                ultimaActualizacion = now()
        WHERE   id = old_row.nivel;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  opePermisoDesarrollo
        SET     descripcion = new_row.descripcion,
                ultimaActualizacion = now()
        WHERE   id = new_row.nivel;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;