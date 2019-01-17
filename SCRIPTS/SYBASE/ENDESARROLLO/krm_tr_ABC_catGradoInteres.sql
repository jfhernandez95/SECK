IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABD_CatGradoInteres') THEN
    DROP TRIGGER krm_tr_ABD_CatGradoInteres
END IF;
GO
CREATE TRIGGER krm_tr_ABD_CatGradoInteres BEFORE INSERT, UPDATE, DELETE
ON sm_gradointeres
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        IF NOT EXISTS(select * from CatGradoInteres where id = new_row.id_gradointeres) THEN
            INSERT INTO CatGradoInteres (id, descripcion, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.id_gradointeres, new_row.descripcion, now(), null, 0)
        ELSEIF EXISTS(select * from CatGradoInteres where id = new_row.id_gradointeres) THEN
            UPDATE  CatGradoInteres
            SET     descripcion = new_row.descripcion,
                    ultimaActualizacion = now()
            WHERE   id = new_row.id_gradointeres;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  CatGradoInteres
        SET     eliminar = 1,
                ultimaActualizacion = now()
        WHERE   id = old_row.id_gradointeres;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  CatGradoInteres
        SET     descripcion = new_row.descripcion,
                ultimaActualizacion = now()
        WHERE   id = new_row.id_gradointeres;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;