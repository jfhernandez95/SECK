IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatPerfiles') THEN
    DROP TRIGGER krm_tr_ABC_CatPerfiles
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatPerfiles BEFORE INSERT, UPDATE, DELETE
ON sm_categorias
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        IF NOT EXISTS(select * from CatPerfiles where id = cast(new_row.id_categoria as varchar(20))) THEN
            INSERT INTO CatPerfiles (descripcion, id, irol, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.descripcion, cast(new_row.id_categoria as varchar(20)), (if new_row.rel_cliente = 'S' then '2' else '3' endif), now(), null, 0)
        ELSEIF EXISTS(select * from CatPerfiles where id = cast(new_row.id_categoria as varchar(20))) THEN
            UPDATE  CatPerfiles
            SET     descripcion = new_row.descripcion,
                    irol = if new_row.rel_cliente = 'S' then '2' else '3' endif,
                    ultimaActualizacion = now()
            WHERE   id = cast(new_row.id_categoria as varchar(20));
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  CatPerfiles
        SET     eliminar = 1,
	ultimaActualizacion = now()
        WHERE   id = cast(old_row.id_categoria as varchar(20));
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  CatPerfiles
        SET     descripcion = new_row.descripcion,
                irol = if new_row.rel_cliente = 'S' then '2' else '3' endif,
                ultimaActualizacion = now()
        WHERE   id = cast(new_row.id_categoria as varchar(20));
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;