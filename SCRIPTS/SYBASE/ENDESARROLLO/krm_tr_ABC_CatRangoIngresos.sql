
IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatRangoIngresos') THEN
    DROP TRIGGER krm_tr_ABC_CatRangoIngresos
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatRangoIngresos BEFORE INSERT, UPDATE, DELETE
ON sm_rango_ingresos
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';

    IF INSERTING THEN
        IF NOT EXISTS(select * from CatRangoIngresos where id = new_row.id_rango) THEN
            INSERT INTO CatRangoIngresos (id, descripcion, rango_inicial, rango_final, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.id_rango, ('ID' + ' ' + cast(new_row.id_rango as varchar(2))), new_row.rango_inicial, new_row.rango_final, now(), null, 0)
        ELSEIF EXISTS(select * from CatRangoIngresos where id = new_row.id_rango) THEN
            UPDATE  CatRangoIngresos
            SET     descripcion = ('ID' + ' ' + cast(new_row.id_rango as varchar(2))),
                    rango_inicial = new_row.rango_inicial,
                    rango_final = new_row.rango_final,
                    ultimaActualizacion = now()
            WHERE   id = new_row.id_rango;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  CatRangoIngresos
        SET     eliminar = 1,
	ultimaActualizacion = now()
        WHERE   id = old_row.id_rango;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  CatRangoIngresos
        SET     descripcion = ('ID' + ' ' + cast(new_row.id_rango as varchar(2))),
                rango_inicial = new_row.rango_inicial,
                rango_final = new_row.rango_final,
                ultimaActualizacion = now()
        WHERE   id = new_row.id_rango;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;