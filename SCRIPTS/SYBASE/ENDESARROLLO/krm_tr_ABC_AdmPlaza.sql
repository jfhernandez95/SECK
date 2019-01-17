IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_AdmPlaza') THEN
    DROP TRIGGER krm_tr_ABC_AdmPlaza
END IF;
GO
CREATE TRIGGER krm_tr_ABC_AdmPlaza BEFORE INSERT, UPDATE, DELETE
ON ek091ab
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';

    IF INSERTING THEN
        IF NOT EXISTS(select * from AdmPlaza where id = new_row.id_identificador) THEN
            INSERT INTO AdmPlaza (id, descripcion, nivel, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.id_identificador, new_row.descripcion, new_row.nivel, now(), null, 0)
        ELSEIF EXISTS(select * from AdmPlaza where id = new_row.id_identificador) THEN
            UPDATE  AdmPlaza
            SET     descripcion = new_row.descripcion,
                    nivel = new_row.nivel,
                    ultimaActualizacion = now()
            WHERE   id = new_row.id_identificador;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  AdmPlaza
        SET     eliminar = 1,
	ultimaActualizacion = now()
        WHERE   id = old_row.id_identificador;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  AdmPlaza
        SET     descripcion = new_row.descripcion,
                nivel = new_row.nivel,
                ultimaActualizacion = now()
        WHERE   id = new_row.id_identificador;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;
