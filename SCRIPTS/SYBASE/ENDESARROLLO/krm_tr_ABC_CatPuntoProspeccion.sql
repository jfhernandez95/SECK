IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatPuntoProspeccion') THEN
    DROP TRIGGER krm_tr_ABC_CatPuntoProspeccion
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatPuntoProspeccion BEFORE INSERT, UPDATE, DELETE
ON sm_punto_venta
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    DECLARE @compania varchar(2);
    SET msg = 'This trigger was fired by an ';

    SELECT  clave_compania
    INTO    @compania
    FROM    datos_compania;

    IF INSERTING THEN
        IF NOT EXISTS(select * from CatPuntoProspeccion where id = new_row.id_punto_venta) THEN
            INSERT INTO CatPuntoProspeccion (id, descripcion, clave_compania, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.id_punto_venta, new_row.descripcion_pv, @compania, now(), null, 0)
        ELSEIF EXISTS(select * from CatPuntoProspeccion where id = new_row.id_punto_venta) THEN
            UPDATE  CatPuntoProspeccion
            SET     descripcion = new_row.descripcion_pv,
                    clave_compania = @compania,
                    ultimaActualizacion = now()
            WHERE   id = new_row.id_punto_venta;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  CatPuntoProspeccion
        SET     eliminar = 1,
	ultimaActualizacion = now()
        WHERE   id = old_row.id_punto_venta;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  CatPuntoProspeccion
        SET     descripcion = new_row.descripcion_pv,
                clave_compania = @compania,
                ultimaActualizacion = now()
        WHERE   id = new_row.id_punto_venta;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;