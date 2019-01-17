IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_OpeIdentificadorDesarrollo') THEN
    DROP TRIGGER krm_tr_ABC_OpeIdentificadorDesarrollo
END IF;
GO
CREATE TRIGGER krm_tr_ABC_OpeIdentificadorDesarrollo BEFORE INSERT, UPDATE, DELETE
ON so_identificador_cc
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        IF NOT EXISTS(select * from OpeIdentificadorDesarrollo where id = new_row.id_identificador) THEN
            INSERT INTO OpeIdentificadorDesarrollo (id, descripcion, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.id_identificador, new_row.descripcion, now(), null, 0)
        ELSEIF EXISTS(select * from OpeIdentificadorDesarrollo where id = new_row.id_identificador) THEN
            UPDATE  OpeIdentificadorDesarrollo
            SET     descripcion = new_row.descripcion,
                    ultimaActualizacion = now()
            WHERE   id = new_row.id_identificador;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  OpeIdentificadorDesarrollo
        SET     eliminar = 1,
                ultimaActualizacion = now()
        WHERE   id = old_row.id_identificador;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  OpeIdentificadorDesarrollo
        SET     descripcion = new_row.descripcion,
                ultimaActualizacion = now()
        WHERE   id = new_row.id_identificador;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;