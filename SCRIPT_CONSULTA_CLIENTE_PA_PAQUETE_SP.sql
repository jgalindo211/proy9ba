set define off;
create or replace PACKAGE    PA.P_CONSULTA_CLIENTE
AS
  PROCEDURE consulta_cliente(
	P_TIPO_DOCUMENTO VARCHAR2,
	P_NUMERO_DOCUMENTO VARCHAR2,
	P_COD_CLIENTE  	 OUT VARCHAR2,
	P_CODIGO_CLIENTE OUT VARCHAR2,
	P_REG_FISCAL   	 OUT VARCHAR2,
	P_LISTA_NEGRA	 OUT VARCHAR2,
	P_NOMBRE		 OUT VARCHAR2,
	P_DUI			 OUT VARCHAR2,
	P_NIT			 OUT VARCHAR2,
	P_ERROR 		 OUT VARCHAR2,
	P_CRCURSOR  	 OUT SYS_REFCURSOR,
	P_CCFCURSOR		 OUT SYS_REFCURSOR,
	P_FACCURSOR		 OUT SYS_REFCURSOR,
	P_FAC2CURSOR	 OUT SYS_REFCURSOR,
	P_COMCURSOR		 OUT SYS_REFCURSOR,
	P_CUSVCURSOR	 OUT SYS_REFCURSOR,
	P_SGCCURSOR		 OUT SYS_REFCURSOR,
	P_RESCURSOR		 OUT SYS_REFCURSOR
  );
END P_CONSULTA_CLIENTE;
/

create or replace PACKAGE BODY    PA.P_CONSULTA_CLIENTE
AS
  PROCEDURE consulta_cliente(
	P_TIPO_DOCUMENTO VARCHAR2,
	P_NUMERO_DOCUMENTO VARCHAR2,
	P_COD_CLIENTE  	 OUT VARCHAR2,
	P_CODIGO_CLIENTE OUT VARCHAR2,
	P_REG_FISCAL   	 OUT VARCHAR2,
	P_LISTA_NEGRA	 OUT VARCHAR2,
	P_NOMBRE		 OUT VARCHAR2,
	P_DUI			 OUT VARCHAR2,
	P_NIT			 OUT VARCHAR2,
	P_ERROR 		 OUT VARCHAR2,
	P_CRCURSOR  	 OUT SYS_REFCURSOR,
	P_CCFCURSOR		 OUT SYS_REFCURSOR,
	P_FACCURSOR		 OUT SYS_REFCURSOR,
	P_FAC2CURSOR	 OUT SYS_REFCURSOR,
	P_COMCURSOR		 OUT SYS_REFCURSOR,
	P_CUSVCURSOR	 OUT SYS_REFCURSOR,
	P_SGCCURSOR		 OUT SYS_REFCURSOR,
	P_RESCURSOR		 OUT SYS_REFCURSOR
  )
  IS
	vcod_cliente VARCHAR2(30) := '';
	vcodigo_cliente NUMBER(7,0);
	vnombre_cliente VARCHAR2(120) := '';
	vregistro_fiscal VARCHAR2(30) := '';
	vcust_codigo_cliente NUMBER(8,0);
	vauxi NUMBER(7,0);--Temporal para asignar codigo cliente cuando no es tipo 99
	vnit VARCHAR2(30) := '';--para hacer busqueda de reserva y lista negra si el codigo de cliente tiene asociado nit
	vdui VARCHAR2(30) := '';--para hacer busqueda de lista negra por dui
	listaNegraNit VARCHAR2(30) := '';
	listaNegraDui VARCHAR2(30) := '';
	
	--cuando no existe en clientes_b2000 la leyenda del nombre retornará CLIENTE NO EXISTE EN EL SISTEMA
	--pero la nueva variable de retorno P_DUI, P_NIT puede ser que retorne el DUI o NIT encontrado en la CTC_PERSONAS
	--siempre y cuando no exista como cliente de BANDESAL
	vctc_nit VARCHAR2(30) := '';
	vctc_dui VARCHAR2(30) := '';
	vexiste_cli VARCHAR2(2) := 'SI';

	vcedula VARCHAR2(30) := '';--para hacer busqueda de lista negra por cedula
	vpasap VARCHAR2(30) := '';--para hacer busqueda de lista negra por pasaporte
	vnitext VARCHAR2(30) := '';--para hacer busqueda de lista negra por nit extranjero
	vnitnodom VARCHAR2(30) := '';--para hacer busqueda de lista negra por nit persona no domiciliada
	

	conteo1			number;
	conteo2			number;
	conteo4			number;
	conteo5			number;
	conteo6			number;
	conteo7			number;
	conteo8			number;
	
	vNoCredito	number;
	
	conteotot			number;

BEGIN

	conteo6:=0.00;--solo por un if de lista negra
	conteo1:=0.00;--para controlar las facturas de consumidor
   if P_TIPO_DOCUMENTO!='45' then	
	if P_TIPO_DOCUMENTO='2' then
		vnit := P_NUMERO_DOCUMENTO;
		listaNegraNit:= P_NUMERO_DOCUMENTO;
	end if;
	if P_TIPO_DOCUMENTO='16' then
		vdui := P_NUMERO_DOCUMENTO;
		listaNegraDui:= P_NUMERO_DOCUMENTO;
	end if;
    
	--Revision si no hay error en la busqueda del cliente
    if P_TIPO_DOCUMENTO='99' then
		begin
		  select cod_cliente
		    into vcod_cliente
		  	from CLIENTES_B2000 
		   where codigo_cliente = P_NUMERO_DOCUMENTO;
		exception
			when no_data_found then
				vcod_cliente := null;
			when too_many_rows then
				P_ERROR := 'Se ha encontrado más de un código de cliente para el codigo';
			when others then
				P_ERROR := 'Se ha generado el siguiente error al buscar cod_cliente: '||SQLCODE||', '||sqlerrm;
		end;

	
	else
		begin
			select cod_persona 
			  into vcod_cliente
				from ID_PERSONAS 
			 where cod_tipo_id = P_TIPO_DOCUMENTO
			   and replace(NUM_ID,'-','') = replace(P_NUMERO_DOCUMENTO,'-','');
			exception
			when no_data_found then
				vcod_cliente := null;
			when too_many_rows then
				P_ERROR := 'Se ha encontrado más de un código de cliente para ese documento.';
			when others then
				P_ERROR := 'Se ha generado el siguiente error al buscar cod_persona: '||SQLCODE||', '||sqlerrm;
		end;	

		
	end if;--si tipo es '99'
	P_COD_CLIENTE := vcod_cliente;
	
	--VIENE LA BUSQUEDA DE REGISTRO FISCAL EN TABLA ID_PERSONAS
	begin
	  select num_id 
	    into vregistro_fiscal
	  	from ID_PERSONAS 
	   where cod_persona = vcod_cliente
	     and cod_tipo_id = 3;
	exception
		when no_data_found then
			vregistro_fiscal := null;
		when too_many_rows then
			P_ERROR := 'Se ha encontrado más de un registro fiscal para este cliente.';
		when others then
			P_ERROR := 'Se ha generado el siguiente error al buscar el registro fiscal: '||SQLCODE||', '||sqlerrm;
	end;

	--VIENE LA BUSQUEDA DE NOMBRE Y CODIGO CLIENTE EN LA TABLA CLIENTES_B2000
	begin
		select codigo_cliente,nombre_completo
		  into vcodigo_cliente,P_NOMBRE
			from clientes_b2000 
		 where cod_cliente = vcod_cliente;
	exception
		when no_data_found then
			P_NOMBRE := 'CLIENTE NO EXISTE EN EL SISTEMA';
			vexiste_cli := 'NO';
			vdui := '';
			vnit := '';
		when too_many_rows then
			P_ERROR := 'Se ha encontrado más de un registro para el codigo de cliente '||vcod_cliente||', '||vnombre_cliente;
			vdui := '';
			vnit := '';
		when others then
			P_ERROR := 'Se ha generado el siguiente error al buscar cliente: '||SQLCODE||', '||sqlerrm;
			vdui := '';
			vnit := '';
	end;

	if vcodigo_cliente is not null then
		P_CODIGO_CLIENTE:=to_char(vcodigo_cliente);
	end if;
	
	P_REG_FISCAL := vregistro_fiscal;
	vcust_codigo_cliente := vcodigo_cliente;

	--VIENE LA BUSQUEDA DE NIT SI TIPO DOCUMENTO ES DIFERENTE A 2
	if P_TIPO_DOCUMENTO != '2' and vexiste_cli='SI' then
	begin
	  select num_id 
	    into vnit
	  	from ID_PERSONAS 
	   where cod_persona = vcod_cliente
	     and cod_tipo_id = 2;
	exception
		when no_data_found then
			vnit := null;
		when too_many_rows then
			vnit := null;
		when others then
			vnit := null;
	end;
	end if;


	--VIENE LA BUSQUEDA DE DUI SI TIPO DOCUMENTO ES DIFERENTE A 16
	if P_TIPO_DOCUMENTO != '16' and vexiste_cli='SI' then
	begin
	  select num_id 
	    into vdui
	  	from ID_PERSONAS 
	   where cod_persona = vcod_cliente
	     and cod_tipo_id = 16;
	exception
		when no_data_found then
			vdui := null;
		when too_many_rows then
			vdui := null;
		when others then
			vdui := null;
	end;
	end if;

	--para la lista negra buscamos en caso que exista los otros documentos
	--cedula - tipo documento 1
	begin
	  select num_id 
	    into vcedula
	  	from ID_PERSONAS 
	   where cod_persona = vcod_cliente
	     and cod_tipo_id = 1;
	exception
		when no_data_found then
			vcedula := null;
		when too_many_rows then
			vcedula := null;
		when others then
			vcedula := null;
	end;

	--nit extranjero - tipo documento 4
	begin
	  select num_id 
	    into vnitext
	  	from ID_PERSONAS 
	   where cod_persona = vcod_cliente
	     and cod_tipo_id = 4;
	exception
		when no_data_found then
			vnitext := null;
		when too_many_rows then
			vnitext := null;
		when others then
			vnitext := null;
	end;

	--pasaporte - tipo documento 9
	begin
	  select num_id 
	    into vpasap
	  	from ID_PERSONAS 
	   where cod_persona = vcod_cliente
	     and cod_tipo_id = 9;
	exception
		when no_data_found then
			vpasap := null;
		when too_many_rows then
			vpasap := null;
		when others then
			vpasap := null;
	end;

	--nit persona no domiciliada - tipo documento 17
	begin
	  select num_id 
	    into vnitnodom
	  	from ID_PERSONAS 
	   where cod_persona = vcod_cliente
	     and cod_tipo_id = 17;
	exception
		when no_data_found then
			vnitnodom := null;
		when too_many_rows then
			vnitnodom := null;
		when others then
			vnitnodom := null;
	end;


	-- Ahora vamos a la parte de formar cursor para PR y CR
	select count(no_credito)
	  into conteo2
	  from pr_creditos 
	 where estado != 'A'
	   and codigo_cliente = vcodigo_cliente;
		
	
		select count(no_credito)
	  into conteo7
	  from cr_creditos 
	 where estado != 'A'
	   and codigo_cliente = vcod_cliente;
		
		conteotot := nvl(conteo2,0) + nvl(conteo7,0);

	if conteotot >= 1 then
		
		--formar cursor P_CRCURSOR a partir de la CR Y PR CREDITOS
		
		begin
			OPEN P_CRCURSOR FOR
				select a.no_credito, b.abrev_estado as estado, nvl(a.monto_credito,0.00) as monto_credito, c.abreviatura as empresa,
				TO_CHAR(a.F_APERTURA,'yyyymmdd') as fape
				from cr_creditos A 
				inner join cr_estados_credito B ON (A.estado = B.codigo_estado)
				inner join empresas C ON (A.codigo_empresa = C.codigo_empresa)
				where a.codigo_cliente = vcod_cliente
				and a.estado != 'A'
			union
				select to_char(a.no_credito) as no_credito, b.abrev_estado as estado, nvl(a.monto_credito,0.00) as monto_credito,c.abreviatura as empresa,
				TO_CHAR(a.F_APERTURA,'yyyymmdd') as fape
				from pr_creditos A
				inner join pr_estados_credito B ON (A.estado = B.codigo_estado)
				inner join empresas C ON (A.codigo_empresa = C.codigo_empresa)
				where codigo_cliente=vcodigo_cliente
				and a.estado!='A'				
			order by 5 DESC;
		exception
			when others then
				P_ERROR := 'Se ha generado el siguiente error en creditos al buscar codigo_cliente: '||SQLCODE||', '||sqlerrm;
		end;
		
  end if;-- de conteotot
  
  --VIENE LA PARTE DE GARANTIAS SOBRE LA SGC_CRE_CREDITOS
  --ya ampliado a tomar en cuenta las otras tablas relacionadas a garantias y no solo la sgc_cre_creditos
  --27/01/2020 se va a quitar el join porque ahora en la parte de reservas se van a mostrar los registros de la sgc_cre_creditos
  -- la sgc_cre_creditos va quedar unida a los registros de reservas
  
	select count(*)
	  into conteo4
	  from sgc_cre_creditos
	 where cre_cod_cliente = vcodigo_cliente;
	 
    select count(*) into conteo8
           from cr_garantias x,cr_garantias_x_credito y, cr_creditos z
           where x.numero_garantia=y.numero_garantia
           and x.codigo_cliente=vcod_cliente
           and y.codigo_empresa=z.codigo_empresa
           and y.no_credito=z.no_credito;


	select count(*)
		INTO CONTEO7
		  FROM CLIENTES C,
		       ID_PERSONAS IP,
		       SGC.SGC_CHO_CODEUDOR_HONRA,
		       SGC.SGC_CRE_CREDITOS
		 WHERE                                                                      --
		      IP.COD_PERSONA = C.COD_CLIENTE
		       --
		       AND CHO_NIT = NUM_ID
		       --
		       AND CRE_COD_EMPRESA = CHO_COD_EMPRESA
		       AND CRE_COD_PROGRAMA = CHO_COD_PROGRAMA
		       AND CRE_NUM_GARANTIA = CHO_NUM_GARANTIA
		       --
		       AND CODIGO_CLIENTE = vcodigo_cliente
		       AND COD_TIPO_ID = 2;

			   
		--conteotot := nvl(conteo4,0) + nvl(conteo7,0) + nvl(conteo8,0);
		  --27/01/2020 se va a quitar el join porque ahora en la parte de reservas se van a mostrar los registros de la sgc_cre_creditos
		  -- la sgc_cre_creditos va quedar unida a los registros de reservas
		  -- el conteo4 es el que toma los registros de la sgc_cre_creditos y por eso se retira de este total
		  
		conteotot := nvl(conteo7,0) + nvl(conteo8,0);


	if conteotot >= 1 then
		  --27/01/2020 se va a quitar el join porque ahora en la parte de reservas se van a mostrar los registros de la sgc_cre_creditos
		  -- la sgc_cre_creditos va quedar unida a los registros de reservas
		
		begin
			OPEN P_SGCCURSOR FOR
--	  select cre_num_garantia,est_descripcion as cre_estado,nvl(cre_monto_credito,0.00) as cre_monto_credito,c.abreviatura as empresa
--	    from sgc_cre_creditos A  inner join sgc_est_estado B ON (A.cre_estado = B.est_codigo)
--				inner join empresas C ON (A.cre_cod_empresa = C.codigo_empresa)
--	    where cre_cod_cliente = vcodigo_cliente
--		and B.est_ver='G'
-- 		union  
		SELECT cre_num_garantia,
		       est_descripcion as cre_estado,
		       nvl(cre_monto_credito,0.00) as cre_monto_credito,
		       emp.abreviatura as empresa
		  FROM CLIENTES C,
		       ID_PERSONAS IP,
		       SGC.SGC_CHO_CODEUDOR_HONRA,
		       SGC.SGC_CRE_CREDITOS A  inner join sgc_est_estado B ON (A.cre_estado = B.est_codigo)
				inner join empresas EMP ON (A.cre_cod_empresa = EMP.codigo_empresa)
		 WHERE                                                                      --
		      IP.COD_PERSONA = C.COD_CLIENTE
		       --
		       AND CHO_NIT = NUM_ID
		       --
		       AND A.CRE_COD_EMPRESA = CHO_COD_EMPRESA
		       AND A.CRE_COD_PROGRAMA = CHO_COD_PROGRAMA
		       AND A.CRE_NUM_GARANTIA = CHO_NUM_GARANTIA
		       --
		       AND CODIGO_CLIENTE = vcodigo_cliente
		       AND COD_TIPO_ID = 2
			   AND B.EST_VER='G'
		UNION
    select x.numero_garantia as cre_num_garantia,
		   decode(x.estado_garantia,'B','Bloqueada','C','Cancelada','E','En Espera de ser Presentada',
                                      'G','Garantia','I','Inscrita','J','Cobro Judicial','P','Presentada',
                                      'R','Registrada','T','En transito') as cre_estado,
		   nvl(z.monto_credito,0.00) as cre_monto_credito,
		   emp.abreviatura as empresa
           from cr_garantias x,cr_garantias_x_credito y, 
		   cr_creditos z inner join empresas emp ON (z.codigo_empresa = emp.codigo_empresa)
           where x.numero_garantia=y.numero_garantia
           and x.codigo_cliente=vcod_cliente
           and y.codigo_empresa=z.codigo_empresa
           and y.no_credito=z.no_credito;
			

		exception
			when others then
				P_ERROR := 'Se ha generado el siguiente error en garantias al buscar codigo_cliente: '||SQLCODE||', '||sqlerrm;
		end;
  end if;--de (conteo7 + conteo8)

  --VIENE BUSQUEDA DE RESERVAS SOBRE LA SGC_RES_RESERVA
  --27/01/2020 se va a quitar el join porque ahora en la parte de reservas se van a mostrar los registros de la sgc_cre_creditos
  -- la sgc_cre_creditos va quedar unida a los registros de reservas
  

  if vnit is not null or vcodigo_cliente is not null then
		if vnit is not null then
			select count(*)
			into conteo5
			from SGC_RES_RESERVA
			where replace(res_nit,'-','') = replace(vnit,'-','');
		end if;
		if conteo5 >= 1 or conteo4>=1 then
		  begin
			OPEN P_RESCURSOR FOR
			select cre_num_garantia as res_comprobante,est_descripcion as res_estado,nvl(cre_monto_credito,0.00) as res_monto,c.abreviatura as empresa,
				TO_CHAR(CRE_FECHA_ADICION, 'yyyymmdd') AS FECHA_CREACION 
				from sgc_cre_creditos A  inner join sgc_est_estado B ON (A.cre_estado = B.est_codigo)
				inner join empresas C ON (A.cre_cod_empresa = C.codigo_empresa)
			where cre_cod_cliente = vcodigo_cliente
			and B.est_ver='G'
 		union  
			select res_comprobante,est_descripcion as res_estado,nvl(res_monto,0.00) as res_monto,c.abreviatura as empresa,
			to_char(RES_FECHA_CREACION,'yyyymmdd') AS FECHA_CREACION
			--res_cod_empresa 
			from   SGC_RES_RESERVA A
			inner join empresas C ON (A.res_cod_empresa = C.codigo_empresa)
			inner join sgc_est_estado B ON (A.res_estado = B.est_codigo)
			where  replace(res_nit,'-','') = replace(vnit,'-','')
			AND B.EST_VER='R'
			AND A.RES_ESTADO IN ('B','E','P')  --MODIFICACION SOLICITADA EL 28/01/2020
			ORDER BY 5 DESC;
		   exception
			when others then
				P_ERROR := 'Se ha generado el siguiente error en reservas al buscar codigo_cliente: '||SQLCODE||', '||sqlerrm;
		  end;
	    else
			if P_ERROR is not null then
				P_ERROR := P_ERROR||', Cliente no tiene reservas asociadas.';
			else
				P_ERROR := 'Cliente no tiene reservas asociadas.';
			end if;	
		end if;--de conteo5
	else
		if P_ERROR is not null then
			P_ERROR := P_ERROR||', Reservas se buscan por número de NIT.';
		else
			P_ERROR := 'Reservas se buscan por número de NIT.';
		end if;
	end if; --de vnit y vcodigo_cliente no nulo

	  --VIENE BUSQUEDA DE CREDITO FISCAL SOBRE LA va_ventas_contri
	   begin
		OPEN P_CCFCURSOR FOR
		select TO_CHAR(a.fecha,'dd/mm/yyyy') as fecha,   a.comprobante,   nvl(a.venta_total,0) as venta_total,
		TO_CHAR(a.fecha,'yyyymmdd') as fecha_order
		from   id_personas b, va_ventas_contri a, clientes_b2000 c
		where  b.num_id(+)      = a.no_registro
		and    c.cod_cliente(+) = b.cod_persona
		and    a.no_registro    = vregistro_fiscal
		order by fecha_order desc;
	  exception
			when others then
				P_ERROR := 'Se ha generado el siguiente error en credito fiscal al buscar codigo_cliente: '||SQLCODE||', '||sqlerrm;
	  end;

	  --VIENE BUSQUEDA DE FACTURAS SOBRE LA va_ventas_consum
	  select count(comprobante)
	  into conteo1
	  from va_ventas_consum
	  where cod_persona  = vcod_cliente;
	
	  if conteo1>0 then
	   begin
		OPEN P_FACCURSOR FOR
		select to_char(a.fecha_ingreso,'dd/mm/yyyy') as fecha_ingreso,a.comprobante,nvl(a.venta_total,0) venta_total,
		to_char(a.fecha_ingreso,'yyyymmdd') as fecha_order
		from   va_ventas_consum a
		where  cod_persona  = vcod_cliente
		order  by fecha_order desc,a.comprobante;
	  exception
			when others then
				P_ERROR := 'Se ha generado el siguiente error en factura al buscar codigo_cliente: '||SQLCODE||', '||sqlerrm;
	  end;
	 end if;

	  --VIENE BUSQUEDA DE FACTURAS SOBRE LA va_ventas_consum, pero utilizando el vcodigo_cliente
	  -- en caso no lo encuentra por cod_cliente
	  if conteo1=0 then
	   begin
		OPEN P_FAC2CURSOR FOR
		select to_char(a.fecha_ingreso,'dd/mm/yyyy') as fecha_ingreso,a.comprobante,nvl(a.venta_total,0) venta_total,
		to_char(a.fecha_ingreso,'yyyymmdd') as fecha_order
		from   va_ventas_consum a
		where  cod_persona  = to_char(vcodigo_cliente)
		order  by fecha_order desc,a.comprobante;
	  exception
			when others then
				P_ERROR := 'Se ha generado el siguiente error en factura al buscar codigo_cliente: '||SQLCODE||', '||sqlerrm;
	  end;
	 end if;

	  --VIENE BUSQUEDA DE COMPRAS SOBRE LA va_compras
	   begin
		OPEN P_COMCURSOR FOR
		select to_char(a.fecha,'dd/mm/yyyy') as fecha,   a.comprobante,   nvl(a.monto_total,0.00) as monto_total,
		to_char(a.fecha,'yyyymmdd') as fecha_order
		from   id_personas b, va_compras a, clientes_b2000 c
		where  b.num_id      = a.no_registro
		and    c.cod_cliente = b.cod_persona
		and    a.no_registro    = vregistro_fiscal
		order by fecha_order desc;
	  exception
			when others then
				P_ERROR := 'Se ha generado el siguiente error en compras al buscar codigo_cliente: '||SQLCODE||', '||sqlerrm;
	  end;

	  --VIENE BUSQUEDA DE LISTA NEGRA EN LAS TABLAS SGC_CLI_CLIENTE_HONRADO POR NIT
	if vnit is not null then
		select count(*)
		  into conteo6
		  from sgc_cli_cliente_honrado 
		 where replace(cli_nit,'-','') = replace(vnit,'-','')
		 and cli_estado_mora='S';
		if conteo6 > 0 then
		 	P_LISTA_NEGRA := 'El cliente se encuentra en "Lista Negra".';
		else
			P_LISTA_NEGRA := 'Cliente con buena categoría, no se encuentra en lista negra.';
		end if;
	end if; --BUSQUEDA POR NIT EN SGC_CLI_CLIENTE_HONRADO
	  
	  --VIENE BUSQUEDA DE LISTA NEGRA EN LA TABLA CTC_PERSONAS POR NIT
	  --esta busqueda se hara independientemente sea cliente o no de BANDESAL
	  
	if listaNegraNit is null and vnit is not null then
		listaNegraNit:=vnit;
	end if;
	
	if listaNegraDui is null and vdui is not null then
		listaNegraDui:=vdui;
	end if;
	
	if listaNegraNit is not null then
		select count(*)
		  into conteo6
		  from ctc_personas
		 where replace(ctc_per_nit,'-','') = replace(listaNegraNit,'-','');
		if conteo6 > 0 then
		 	P_LISTA_NEGRA := 'El cliente se encuentra en "Lista Negra".';
		else
			P_LISTA_NEGRA := 'Cliente con buena categoría, no se encuentra en lista negra.';
		end if;
	end if; --BUSQUEDA POR NIT EN CTC_PERSONAS
	  
	  --VIENE BUSQUEDA DE LISTA NEGRA EN LA TABLA CTC_PERSONAS POR DUI
	if listaNegraDui is not null and P_LISTA_NEGRA is null then
		select count(*)
		  into conteo6
		  from ctc_personas
		 where replace(ctc_per_dui,'-','') = replace(listaNegraDui,'-','');
		if conteo6 > 0 then
		 	P_LISTA_NEGRA := 'El cliente se encuentra en "Lista Negra".';
		else
			P_LISTA_NEGRA := 'Cliente con buena categoría, no se encuentra en lista negra.';
		end if;
	end if; --BUSQUEDA POR DUI EN CTC_PERSONAS
	

	--importante no se debe poner en el where como filtro el tipo documento. Hay casos en que va nulo en la ctc_personas

	if ((conteo6=0)) and 
	((P_TIPO_DOCUMENTO='3'  --REG. FISCAL
	or P_TIPO_DOCUMENTO='4'  --NIT EXTRANJERA
	or P_TIPO_DOCUMENTO='9'  --PASAPORTE
	)) then
		select count(*)
		  into conteo6
		  from ctc_personas
		 where 
			trim(replace(CTC_PER_NUMERO,'-','')) = trim(replace(P_NUMERO_DOCUMENTO,'-',''));
		if conteo6 > 0 then
		 	P_LISTA_NEGRA := 'El cliente se encuentra en "Lista Negra".';
		else
			P_LISTA_NEGRA := 'Cliente con buena categoría, no se encuentra en lista negra.';
		end if;

	end if;


	
	if conteo6=0 then
		if vcedula is not null or vnit is not null or vregistro_fiscal is not null or 
		vnitext is not null or vpasap is not null or vdui is not null or vnitnodom is not null
		then
			select count(*)
			into conteo6
			from ctc_personas
			where 
				trim(replace(CTC_PER_NUMERO,'-','')) = trim(replace(vcedula,'-','')) or
				trim(replace(CTC_PER_NUMERO,'-','')) = trim(replace(vnit,'-','')) or
				trim(replace(CTC_PER_NUMERO,'-','')) = trim(replace(vregistro_fiscal,'-','')) or
				trim(replace(CTC_PER_NUMERO,'-','')) = trim(replace(vnitext,'-','')) or
				trim(replace(CTC_PER_NUMERO,'-','')) = trim(replace(vpasap,'-','')) or
				trim(replace(CTC_PER_NUMERO,'-','')) = trim(replace(vdui,'-','')) or
				trim(replace(CTC_PER_NUMERO,'-','')) = trim(replace(vnitnodom,'-',''));
			if conteo6 > 0 then
				P_LISTA_NEGRA := 'El cliente se encuentra en "Lista Negra".';
			else
				P_LISTA_NEGRA := 'Cliente con buena categoría, no se encuentra en lista negra.';
			end if;
		end if;

	end if;


	--En caso no tenga DUI, NIT ni otros documentos para buscar en la lista negra 
	--se hace nueva logica ya que la busqueda por nombre ahora incluye nombres de la ctc_personas
	--que no necesariamente existen en clientes_b2000. Ejemplo GELBI MORALES (dui 008340967)
	--está en ctc_personas y no existe en clientes_b2000 (ambiente desarrollo - al  - 20200210)
	
	if P_LISTA_NEGRA is null and listaNegraDui is null and listaNegraNit is null and conteo6=0 then
		
	
		P_LISTA_NEGRA := 'Sin suficiente criterio para buscar en lista negra.';
	end if;

	  --VIENE BUSQUEDA DE CUSTODIA DE VALORES
	   begin
		
		OPEN P_CUSVCURSOR FOR
		select    a.numero_documento, c.DESCRIPCION sub_aplicacion, 
           		a.tipo_documento,b.descripcion, nvl(a.valor_mercado,0.00) as valor_mercado, 
           		decode(a.estatus,1,'INGRESO DE DOCUMENTO',2,'SALIDA DE DOCUMENTO',3,'TRANSFERENCIA ENTRE CUSTODIO',4,'AJUSTE A DOCUMENTO') estado
		from      BCV_DOCUMENTOS a, BCV_TIPOS_DE_DOCUMENTOS b, SUBAPLIC_B2000 c
		where     a.codigo_empresa      = b.codigo_empresa
		  and     a.tipo_documento      = b.tipo_documento
		  and     a.subtipo_documento   = b.subtipo_documento
		  and     a.codigo_sub_aplicacion = c.codigo_sub_aplicacion
		  and     c.codigo_aplicacion = 'BCV'
		  and     c.estado = 'A'
		  --and     a.codigo_empresa      = 32  --HAY OTRAS EMPRESAS Y NO SOLAMENTE BANDESAL
		  and     a.codigo_cliente      = vcust_codigo_cliente
		  order by TO_CHAR(a.fecha_emision,'yyyymmdd') desc;
	  exception
			when others then
				P_ERROR := 'Se ha generado el siguiente error en cust. valores al buscar cod_cliente: '||SQLCODE||', '||sqlerrm;
	  end;

	if vdui is not null then
		P_DUI:=vdui;
	end if;
	
	if P_DUI is null and listaNegraDui is not null then 
		P_DUI:=listaNegraDui;
	end if;

	if vnit is not null then
		P_NIT:=vnit;
	end if;

	if P_NIT is null and listaNegraNit is not null then 
		P_NIT:=listaNegraNit;
	end if;
  else 
	P_NOMBRE := 'CLIENTE NO EXISTE EN EL SISTEMA';
	P_LISTA_NEGRA := 'El cliente se encuentra en "Lista Negra".';
  end if;	

 END;
END P_CONSULTA_CLIENTE;
/

GRANT DEBUG ON PA.P_CONSULTA_CLIENTE TO CONSULTA;
/
