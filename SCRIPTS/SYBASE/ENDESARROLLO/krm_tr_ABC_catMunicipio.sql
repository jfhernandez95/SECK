IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatMunicipio') THEN
    DROP TRIGGER krm_tr_ABC_CatMunicipio
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatMunicipio BEFORE INSERT, UPDATE, DELETE
ON ciudades
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        IF NOT EXISTS(select * from CatMunicipio where id = new_row.ciudad) THEN
            INSERT INTO CatMunicipio (descripcion, estado, id, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.desc_ciudad, new_row.estado, new_row.ciudad, now(), null, 0)
        ELSEIF EXISTS(select * from catEstado where id = new_row.estado) THEN
            UPDATE  CatMunicipio
            SET     descripcion = new_row.desc_ciudad,
                    estado = new_row.estado,
                    ultimaActualizacion = now()
            WHERE   id = new_row.ciudad;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  CatMunicipio
        SET     eliminar = 1,
	ultimaActualizacion = now()
        WHERE   id = old_row.ciudad;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  CatMunicipio
        SET     descripcion = new_row.desc_ciudad,
                estado = new_row.estado,
                ultimaActualizacion = now()
        WHERE   id = new_row.ciudad;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;