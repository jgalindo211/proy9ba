set define off;
CREATE OR REPLACE PACKAGE PA.P_CONSULTA_NOMBRES
AS
  PROCEDURE consulta_nombres(
	P_NOMBRE VARCHAR2,
	P_ERROR 		 OUT VARCHAR2,
	P_NOMBRECURSOR   OUT SYS_REFCURSOR,
	P_CTCCURSOR   OUT SYS_REFCURSOR
  );
END P_CONSULTA_NOMBRES;
/

CREATE OR REPLACE PACKAGE BODY PA.P_CONSULTA_NOMBRES
AS
  PROCEDURE consulta_nombres(
	P_NOMBRE VARCHAR2,
	P_ERROR 		 OUT VARCHAR2,
	P_NOMBRECURSOR   OUT SYS_REFCURSOR,
	P_CTCCURSOR   OUT SYS_REFCURSOR
  )
  IS
	vcod_cliente VARCHAR2(30) := '';
	vcodigo_cliente NUMBER(7,0);
	vnombre_cliente VARCHAR2(120) := '';
	vregistro_fiscal VARCHAR2(30) := '';
	vcust_codigo_cliente NUMBER(8,0);
	vtipo_documento VARCHAR2(2) := '';
	vnumero_documento VARCHAR2(30):='';
	vcondicion VARCHAR2(250):='';
	
	vauxi NUMBER(7,0);--Temporal para asignar codigo cliente cuando no es tipo 99
	conteo  number;


BEGIN
	conteo:=0;
			select count(*) 
			into conteo
		  	from CLIENTES_B2000 
		   where  TRIM(UPPER(REPLACE(nombre_completo,'&','|'))) like TRIM(UPPER('%' || P_NOMBRE || '%'));

		if conteo>0 then 
			begin
        OPEN P_NOMBRECURSOR FOR 
        select cod_cliente, codigo_cliente, (nombre_completo||' ') as nombre_completo, '99' as tipo_id, 
          nvl((Select ListAgg(num_id, ' , ') Within Group (Order by num_id) from id_personas where cod_persona=cod_cliente),' ') doc
          from CLIENTES_B2000 
          where  TRIM(UPPER(REPLACE(nombre_completo,'&','|'))) like TRIM(UPPER('%' || P_NOMBRE || '%'))
        order by nombre_completo;
         
      exception
          when others then
            P_ERROR := 'Se ha generado el siguiente error al buscar por nombre: '||SQLCODE||', '||sqlerrm;
      end;
	else 

		select count(*) into conteo 	from CTC_PERSONAS 
		    where  TRIM(UPPER(REPLACE(ctc_per_nombre,'&','|'))) like TRIM(UPPER('%' || P_NOMBRE || '%'));
			
		 if conteo>0 then
          begin
            OPEN P_CTCCURSOR FOR 
            select nvl2(CTC_PER_NIT, '2','') AS tipo_nit,
            nvl2(CTC_PER_NIT, REPLACE(CTC_PER_NIT,'-',''),'') AS numero_nit, 
            nvl2(CTC_PER_DUI, '16','') AS tipo_dui, 
            nvl2(CTC_PER_DUI, REPLACE(CTC_PER_DUI,'-',''),'') AS numero_dui, 
            nvl2(CTC_PER_OTR_TIPDOC, CTC_PER_OTR_TIPDOC,'') AS tipo_otro, 
            nvl2(CTC_PER_NUMERO, REPLACE(CTC_PER_NUMERO,'-',''),'') AS numero_otro,
			ctc_per_nombre
            from CTC_PERSONAS 
            where  TRIM(UPPER(REPLACE(ctc_per_nombre,'&','|'))) like TRIM(UPPER('%' || P_NOMBRE || '%'))
            order by ctc_per_nombre;
         
          exception
            when others then
              P_ERROR := 'Se ha generado el siguiente error al buscar por nombre: '||SQLCODE||', '||sqlerrm;
          end;
        end if;
        
      end if;
	  if conteo=0 then
		P_ERROR := 'No hay coincidencias para el nombre';
	  end if;
	
  END;
END P_CONSULTA_NOMBRES;
/


GRANT DEBUG ON PA.P_CONSULTA_NOMBRES TO CONSULTA;
/
