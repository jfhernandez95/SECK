
IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatTmInteres') THEN
    DROP TRIGGER krm_tr_ABC_CatTmInteres
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatTmInteres BEFORE INSERT, UPDATE, DELETE
ON sm_cptopago
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    DECLARE @descripcion varchar(30);
    DECLARE @tm numeric(3);
    SET msg = 'This trigger was fired by an ';

    SELECT  descripcion
    INTO    @descripcion
    FROM    sx_tm
    WHERE   tm = new_row.tm_interes;
    
    SELECT  COUNT(*)
    INTO    @tm
    FROM    sm_cptopago
    WHERE   tm_interes = new_row.tm_interes;   

    IF INSERTING THEN

        IF @descripcion = Null THEN
            return 'Relacion TM Ciente/TM Interes No Existe';
        END IF;
        IF NOT EXISTS(select * from CatTmInteres where id = new_row.tm_interes) THEN
            INSERT INTO CatTmInteres (id, descripcion, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.tm_interes, @descripcion, now(), null, 0)
        ELSEIF EXISTS(select * from CatTmInteres where id = new_row.tm_interes) THEN
            UPDATE  CatTmInteres
            SET     descripcion = @descripcion,
                    ultimaActualizacion = now()
            WHERE   id = new_row.tm_interes;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        IF @tm = 1 THEN
            UPDATE  CatTmInteres
            SET     eliminar = 1,
            ultimaActualizacion = now()
            WHERE   id = old_row.tm_interes;
        END IF;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        IF @tm = 0 THEN
            IF NOT EXISTS(select * from CatTmInteres where id = new_row.tm_interes) THEN
                INSERT INTO CatTmInteres (id, descripcion, ultimaActualizacion, ultimaSincronizacion, eliminar)
                VALUES (new_row.tm_interes, @descripcion, now(), null, 0)
            END IF;
        ELSE
            UPDATE  CatTmInteres
            SET     descripcion = @descripcion,
                    ultimaActualizacion = now()
            WHERE   id = new_row.tm_interes;
        END IF;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;