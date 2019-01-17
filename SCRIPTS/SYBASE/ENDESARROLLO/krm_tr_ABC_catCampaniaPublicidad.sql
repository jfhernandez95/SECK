IF exists(SELECT trigname FROM systriggers WHERE trigname = 'krm_tr_ABC_CatCampaniaPublicidad') THEN
    DROP TRIGGER krm_tr_ABC_CatCampaniaPublicidad
END IF;
GO
CREATE TRIGGER krm_tr_ABC_CatCampaniaPublicidad BEFORE INSERT, UPDATE, DELETE
ON sm_mediopublicidad_canal
REFERENCING OLD AS old_row NEW AS new_row
FOR EACH ROW
BEGIN
    DECLARE msg varchar(255);
    SET msg = 'This trigger was fired by an ';
    IF INSERTING THEN
        IF NOT EXISTS(select * from CatCampaniaPublicidad where id_canal = new_row.id_num_canal) THEN
            INSERT INTO CatCampaniaPublicidad (descripcion, fecha_inicial, fecha_final, id_canal, id_medio, clave_compania, ultimaActualizacion, ultimaSincronizacion, eliminar)
            VALUES ((if length(new_row.nom_canal) > 50 then substring(new_row.nom_canal, 0, 50) else new_row.nom_canal endif), new_row.fec_ini, new_row.fec_fin,
            new_row.id_num_canal, new_row.id_num_medio, (select clave_compania from datos_compania), now(), null, 0)
        ELSEIF EXISTS(select * from CatCampaniaPublicidad where id = new_row.id_num_canal) THEN
            UPDATE  CatCampaniaPublicidad
            SET     descripcion = if length(new_row.nom_canal) > 50 then substring(new_row.nom_canal, 0, 50) else new_row.nom_canal endif,
                    fecha_inicial = new_row.fec_ini,
                    fecha_final = new_row.fec_fin,
                    id_medio = new_row.id_num_medio,
                    clave_compania = (select clave_compania from datos_compania),
                    ultimaActualizacion = now()
            WHERE   id_canal = new_row.id_num_canal;
        END IF;
        SET msg = msg || 'insert';
    ELSEIF DELETING THEN
        UPDATE  CatCampaniaPublicidad
        SET     eliminar = 1,
                ultimaActualizacion = now()
        WHERE   id_canal = old_row.id_num_canal;
        set msg = msg || 'delete';
    ELSEIF UPDATING THEN
        UPDATE  CatCampaniaPublicidad
        SET     descripcion = if length(new_row.nom_canal) > 50 then substring(new_row.nom_canal, 0, 50) else new_row.nom_canal endif,
                fecha_inicial = new_row.fec_ini,
                fecha_final = new_row.fec_fin,
                id_medio = new_row.id_num_medio,
                clave_compania = (select clave_compania from datos_compania),
                ultimaActualizacion = now()
        WHERE   id_canal = new_row.id_num_canal;
        set msg = msg || 'update';
    END IF;
    MESSAGE msg TO CLIENT;
END;