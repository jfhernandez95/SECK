
IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatEtapa') THEN
    DROP TRIGGER krm_tr_ABC_CatEtapa
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatEtapa BEFORE INSERT, UPDATE, DELETE
ON sm_etapa
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';

    IF INSERTING THEN
        IF NOT EXISTS(select * from CatEtapa where id = new_row.id_num_etapa) THEN
            INSERT INTO CatEtapa (id, abrev_etapa, abrev_etapa, estatus_lote, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.id_num_etapa, new_row.abrev_etapa, new_row.estatus_lote, now(), null, 0)
        ELSEIF EXISTS(select * from CatEtapa where id = new_row.id_num_etapa) THEN
            UPDATE  CatEtapa
            SET     abrev_etapa = new_row.abrev_etapa,
                    estatus_lote = new_row.estatus_lote,
                    ultimaActualizacion = now()
            WHERE   id = new_row.id_num_etapa;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  CatEtapa
        SET     eliminar = 1,
	ultimaActualizacion = now()
        WHERE   id = old_row.id_num_etapa;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  CatEtapa
        SET     abrev_etapa = new_row.abrev_etapa,
                estatus_lote = new_row.estatus_lote,
                ultimaActualizacion = now()
        WHERE   id = new_row.id_num_etapa;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;