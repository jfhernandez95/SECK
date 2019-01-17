IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatEstado') THEN
    DROP TRIGGER krm_tr_ABC_CatEstado
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatEstado BEFORE INSERT, UPDATE, DELETE
ON estados
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        IF NOT EXISTS(select * from catEstado where id = new_row.estado) THEN
            INSERT INTO CatEstado (descripcion, pais, id, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.descripcion_larga, new_row.pais, new_row.estado, now(), null, 0)
        ELSEIF EXISTS(select * from catEstado where id = new_row.estado) THEN
            UPDATE  CatEstado
            SET     descripcion = new_row.descripcion_larga,
                    pais = new_row.pais,
                    ultimaActualizacion = now()
            WHERE   id = new_row.estado;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  catEstado
        SET     eliminar = 1,
	ultimaActualizacion = now()
        WHERE   id = old_row.estado;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  catEstado
        SET     descripcion = new_row.descripcion_larga,
                pais = new_row.pais,
                ultimaActualizacion = now()
        WHERE   id = new_row.estado;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;