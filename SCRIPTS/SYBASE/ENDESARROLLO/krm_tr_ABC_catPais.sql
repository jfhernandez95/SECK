IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatPais') THEN
    DROP TRIGGER krm_tr_ABC_CatPais
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatPais BEFORE INSERT, UPDATE, DELETE
ON Paises
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        IF NOT EXISTS(select * from catPais where id = new_row.pais) THEN
            INSERT INTO catPais(descripcion, id, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES(new_row.desc_pais, new_row.pais, now(), NULL, 0);
        ELSEIF EXISTS(select * from catPais where id = new_row.pais) THEN
            UPDATE  catPais
            SET     descripcion = new_row.desc_pais,
                    ultimaActualizacion = now()
            WHERE   id = new_row.pais;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  catPais
        SET     eliminar = 1,
	ultimaActualizacion = now()
        WHERE   id = old_row.pais;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  catPais
        SET     descripcion = new_row.desc_pais,
                ultimaActualizacion = now()
        WHERE   id = new_row.pais;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;