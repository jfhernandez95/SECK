IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_AdmUsuarios_sm_agente') THEN
    DROP TRIGGER krm_tr_ABC_AdmUsuarios_sm_agente
END IF;
GO
CREATE TRIGGER krm_tr_ABC_AdmUsuarios_sm_agente BEFORE INSERT, UPDATE, DELETE
ON sm_agente
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    DECLARE @id_categoria numeric(3);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        SELECT  
                if sm_categorias.rel_cliente = 'S' then 
                    '-1'
                else
                    new_row.id_categoria
                endif
        INTO    @id_categoria
        FROM    sm_categorias
        WHERE   sm_categorias.id_categoria = new_row.id_categoria;
        IF NOT EXISTS(select * from AdmUsuarios where id_agente = new_row.empleado) THEN
            INSERT INTO AdmUsuarios (id_agente, nombre, apellido_paterno, apellido_materno, password, empleado, id_categoria, id_nivelagente, usuario, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES (new_row.empleado, new_row.nom_empleado, new_row.ap_paterno_empleado, new_row.ap_materno_empleado, new_row.password, new_row.empleado, @id_categoria,
            new_row.id_num_nivelagente, new_row.id_usuario, now(), null, 0)
        ELSEIF EXISTS(select * from AdmUsuarios where id_agente = new_row.empleado) THEN
            UPDATE  AdmUsuarios
            SET     nombre = new_row.nom_empleado, 
                    apellido_paterno = new_row.ap_paterno_empleado, 
                    apellido_materno = new_row.ap_materno_empleado, 
                    password = new_row.password, 
                    usuario = new_row.id_usuario, 
                    id_categoria = @id_categoria,
                    id_nivelagente = new_row.id_num_nivelagente, 
                    ultimaActualizacion = now()
            WHERE   id_agente = new_row.empleado;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  AdmUsuarios
        SET     eliminar = 1,
                ultimaActualizacion = now()
        WHERE   id_agente = old_row.empleado;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        SELECT  
                if sm_categorias.rel_cliente = 'S' then 
                    -1
                else
                    new_row.id_categoria
                endif
        INTO    @id_categoria
        FROM    sm_categorias
        WHERE   sm_categorias.id_categoria = new_row.id_categoria;

        UPDATE  AdmUsuarios
        SET     nombre = new_row.nom_empleado, 
                apellido_paterno = new_row.ap_paterno_empleado, 
                apellido_materno = new_row.ap_materno_empleado, 
                password = new_row.password, 
                usuario = new_row.id_usuario,
                id_categoria = @id_categoria,
                id_nivelagente = new_row.id_num_nivelagente, 
                ultimaActualizacion = now()
        WHERE   id_agente = new_row.empleado;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;