IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_AdmUsuarios_ek010ab') THEN
    DROP TRIGGER krm_tr_ABC_AdmUsuarios_ek010ab
END IF;
GO
CREATE TRIGGER krm_tr_ABC_AdmUsuarios_ek010ab BEFORE INSERT, UPDATE, DELETE
ON ek010ab
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    DECLARE @empleado numeric(7);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        SELECT  empleado
        INTO    @empleado
        FROM    sm_agente
        WHERE   id_usuario = new_row.num
        if @@sqlstatus = 2 then
            return 'Relacion Usuario/Agente No Existe';
        end if;
        IF NOT EXISTS(select * from AdmUsuarios where id_agente = @empleado) THEN
            return 'Registro AdmUsuario No existe';
        ELSEIF EXISTS(select * from AdmUsuarios where id_agente = new_row.empleado) THEN
            UPDATE  AdmUsuarios
            SET     correo = new_row.email, 
                    usuario = new_row.num, 
                    nivelcc = new_row.nivelcc,
                    ultimaActualizacion = now()
            WHERE   id_agente = @empleado;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        SELECT  empleado
        INTO    @empleado
        FROM    sm_agente
        WHERE   id_usuario = old_row.num
        if @@sqlstatus = 2 then
            return 'Relacion Usuario/Agente No Existe';
        end if;
        UPDATE  AdmUsuarios
        SET     eliminar = 1,
                ultimaActualizacion = now()
        WHERE   id_agente = @empleado;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        SELECT  empleado
        INTO    @empleado
        FROM    sm_agente
        WHERE   id_usuario = new_row.num
        if @@sqlstatus = 2 then
            return 'Relacion Usuario/Agente No Existe';
        end if;

            UPDATE  AdmUsuarios
            SET     correo = new_row.email, 
                    usuario = new_row.num, 
                    nivelcc = new_row.nivelcc,
                    ultimaActualizacion = now()
            WHERE   id_agente = @empleado;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;