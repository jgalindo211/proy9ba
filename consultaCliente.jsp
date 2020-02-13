<!DOCTYPE html>
<%@taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<jsp:useBean id="utilidad" class="bandesal.gob.sv.consulta.cliente.util.Util" scope="session"/>
<%@ page import="java.util.*"%>
<%@ page import="bandesal.gob.sv.consulta.cliente.dto.DetalleCliente"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.apache.commons.collections.EnumerationUtils"%>
<%
boolean found=false;
DetalleCliente det = new DetalleCliente();
List<String> cr=new ArrayList<String>();
List<String> sgc=new ArrayList<String>();
List<String> res=new ArrayList<String>();
List<String> ccf=new ArrayList<String>();
List<String> fac=new ArrayList<String>();
List<String> com=new ArrayList<String>();
List<String> cva=new ArrayList<String>();
List<String> ln = new ArrayList<String>();

StringBuffer sb=new StringBuffer("Clientes : <select id='losNombres' name='losNombres' class='x25'>");
sb.append("<option value=''>Seleccione</option></select>");

String losNombres=sb.toString();
String vNombre="";
String vTipoDoc="";
String vNumDoc="";
String nitFound="";
String duiFound="";


String[] a;
Enumeration c = request.getAttributeNames();
List l = EnumerationUtils.toList(c);

if (l.contains("tipoDocumento")) {
    vTipoDoc=(String) request.getAttribute("tipoDocumento");
}

if (l.contains("numeroDocumento")) {
    vNumDoc=(String) request.getAttribute("numeroDocumento");
}

if (l.contains("elNombre")) {
    vNombre=(String) request.getAttribute("elNombre");
}

String tipoDocumentoSelected=utilidad.getTiposDocumentoSelected(vTipoDoc);
if (l.contains("detalleCliente")){
    found=true;
    det = (DetalleCliente) request.getAttribute("detalleCliente");
    duiFound=det.getDui();
    nitFound=det.getNit();
    cr=det.getCreditos();
    sgc=det.getSgc();
    res=det.getRes();
    ccf=det.getCcf();
    fac=det.getFac();
    com=det.getCom();
    cva=det.getCva();    

}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>

        <link href="pages/styles/bmi.css" rel="stylesheet" type="text/css"/>
        <link href="pages/styles/bmi2.css" rel="stylesheet" type="text/css"/>
    <link href="styles/jquery-ui-1.9.2.custom.min.css" rel="stylesheet" type="text/css">
    <link href="styles/bootstrap.min.css" rel="stylesheet" type="text/css">

        <script type="text/javascript" src="javascript/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="javascript/jquery.smartWizard-2.0.min.js"></script>
        <script type="text/javascript" src="javascript/jquery-ui-1.9.2.custom.min.js"></script>
        <script type="text/javascript" src="javascript/bootstrap.min.js"></script>
        <script type="text/javascript" src="javascript/bootbox.min.js"></script>

<style>
* {
  box-sizing: border-box;
}


.element {
 border-right: 3px solid #F0F4FA;

 width: 400px;
 height: 200px;
 float:left;
 margin: 3px;
 margin-right: 3px;

}
 

.element {
 width: 400px;
 height: 200px;
 float:left;
 margin: 1px;
 margin-right: 1px;

}
 

.my-custom-scrollbar {
    width: 100%;
    height: 150px;
    overflow-y:auto;
}
.table-wrapper-scroll-y {

  display: block;
  width: 21%;
  float: left;
  height: 148px;
  margin: 3px;
  margin-right: 3px;
  font-size: 10px;
  border: 4px solid white;

}

.table-wrapper-scroll-y2 {

  display: block;
  width: 21%;
  float: left;
  height: 148px;
  margin: 3px;
  margin-right: 3px;
  font-size: 10px;
  border: 4px solid white;
  overflow-y:auto;

}

.table-wrapper-scroll-y2 thead>tr:nth-child(1) th {
    position: sticky;
    top: 0;
    z-index: 999;
}

.table-wrapper-scroll-y2 thead>tr:nth-child(2) th {
    position: sticky;
    top: 25px;
    z-index: 999;
}

.table-datos-cliente {

  display: block;
  width: 60%;
  margin-left: 3px;
  font-size: 10px;
  border: 1px solid white;
}

.table-custv {
  display: block;
  width: 33%;
  float: left;
  height: 148px;
  margin: 3px;
  margin-right: 3px;
  font-size: 10px;
  border: 4px solid white;
  overflow-y:auto;
}

.table-custv thead>tr:nth-child(1) th {
    position: sticky;
    top: 0;
    z-index: 999;
}

.table-custv thead>tr:nth-child(2) th {
    position: sticky;
    top: 25px;
    z-index: 999;
}


.table-reser {

  display: block;
  width: 32%;
  float: left;
  height: 148px;
  margin: 3px;
  margin-right: 3px;
  font-size: 10px;
  border: 1px solid white;
  overflow-y:auto;
}

.table-reser thead>tr:nth-child(1) th {
    position: sticky;
    top: 0px;
    z-index: 999;
}

.table-reser thead>tr:nth-child(2) th {
    position: sticky;
    top: 25px;
    z-index: 999;
}

.fila1 {

  width: 100%;
  height: 150px;
  margin-bottom: 3px;
  font-size: 10px;
  font-weight: normal;
}
.fila2 {

  width: 100%;
  height: 150px;
  margin-bottom: 3px;
  font-size: 10px;
  font-weight: normal;
}

.fila1 div{
    border: 0px black solid;
}

.fila2 div{
    border: 0px black solid;
}


.container-img {
  width: 100%;
  border: 0px solid black;
  background-color: #FFFFFF;
  margin-left: 3px;
}

.titulo_panel_busqueda {
    display: inline;
    margin: 0px;
    white-space: nowrap;
    font-size: 12px;
    font-weight: bold;
    color: #003D58;
    margin-left: 3px;
}

.xzt {
    display: inline;
    margin: 0px;
    white-space: nowrap;
    font-size: 14px;
    font-weight: bold;
    color: #003D58;
    margin-left: 3px;
}

.xlcd_no_border {
    font-size: 11px;
    color: #4F4F4F;
    padding: 0px 0px 0px 0px;
    font-weight: normal;
    text-align: right;
    white-space: nowrap;
    border: 0px;
}

.x25 {
    font-weight: normal;
    font-size: 11px;
    border-color: #DEE4E7;
    border-style: solid;
    border-width: 1px;
    box-sizing: border-box;
    border-radius: 3px;
    background-color: #FAFDFF;
    color: #333333;
    border: 1px solid #DEE4E7;
    padding: 1px 2px 1px 3px;
    margin: 1px;
    text-align: left;
}

.x25_no_border{
    font-weight: normal;
    font-size: 11px;
    border-color: #DEE4E7;
    border-style: solid;
    border-width: 1px;
    box-sizing: border-box;
    border-radius: 3px;
    background-color: #FAFDFF;
    color: #333333;
    border: 0px;
    padding: 1px 2px 1px 3px;
    margin: 1px;
    text-align: left;
    
}

input {
    -webkit-writing-mode: horizontal-tb;
    text-rendering: auto;
    letter-spacing: normal;
    word-spacing: normal;
    text-transform: none;
    text-indent: 0px;
    text-shadow: none;
    display: inline-block;
    text-align: start;
    -webkit-appearance: field;
    -webkit-rtl-ordering: logical;
    cursor: text;
    font: 400 13.3333px Arial;
}

.xfk, .xfl {
    display: inline-block;
    padding: 0px;
    cursor: default;
    white-space: nowrap;
    vertical-align: bottom;
    min-height: 19px;
    border-top: 1px solid #95B6D4;
    border-right: 1px solid #95B6D4;
    border-bottom: 1px solid #92B3D1;
    border-left: 1px solid #95B6D4;
    border-radius: 3px;
    background-image: -webkit-linear-gradient(top, #CCE2F6 0%, #B1D2F2 100%);
    font-weight: normal;
    font-size: 11px;
    color: #333333;
}


.x17c:hover {
    background-color: #F1CD7E;
}

element.style {
    width: 50px;
}

.xfk:hover, .xfl:hover,
.AFNoteWindowAllButton:hover,
.AFNoteWindowAllButton:focus:hover
{
    font-weight: normal;
    font-size: 11px;
    color: #333333;
    border-top: 1px solid #E2CB98;
    border-right: 1px solid #E2CB98;
    border-bottom: 1px solid #D4BB87;
    border-left: 1px solid #E2CB98;
    background-image: -webkit-linear-gradient(top, #FFE4A8 0%, #FFD475 100%);
}

header, .xcv, .portlet-table-subheader, .xcz,
.x150 {
    font-weight: normal;
    font-size: 11px;
    border-right: 1px solid #D6DFE6;
    border-bottom: 1px solid #D6DFE6;
    border-top-width: 0px;
    border-left: 1px solid #E2CB98;
    background-color: #F0F4FA;
    padding-top: 0px;
    padding-bottom: 0px;
    padding-left: 2px;
    padding-right: 2px;
    overflow: hidden;
    text-overflow: ellipsis;
    color: #000000;
    
}

.x15f .xia, .x15f .xib {
    display: inline-block;
    padding-right: 2px;
    border-right: 1px solid #EEEEEE;
    border-bottom: 1px solid #EEEEEE;
}

.portlet-table-body,
.portlet-table-selected,
.portlet-table-footer, .portlet-table-
text, .xia {
    font-weight: bold;
    font-size: 8px;
    padding-top: 0px;
    padding-bottom: 0px;
    padding-left: 0px;
    overflow: hidden;
    background-color: #FFFFFF;
    color: #333333;
    border-color: #EEEEEE;
    text-align:left;
    cursor: auto;
}

.tr_title_sizing {
  line-height: 4px;
   min-height: 4px;
   height: 4px;
}
.tr_sizing {
    line-height: 8px;
   min-height: 8px;
   height: 8px;
}

</style>
</head>



<body style="font-family:Tahoma, Verdana, Helvetica, sans-serif; background-color: #FFFFFF;">


<div class="container-img">
    <h1 class="xzt">Consulta de Productos por Cliente</h1>
    <br>
    <h2 class="titulo_panel_busqueda">Panel de B&uacute;squeda</h2>
</div>
<html:form action='/consultaclienteAction' method='post' styleId='idForm' autocomplete="off">
<input type='hidden' id='tipoConsulta' name='tipoConsulta'/>
<input type='hidden' id='elNumeroDocumento' name='elNumeroDocumento'/>
<input type='hidden' id='elTipoDocumento' name='elTipoDocumento'/>
<!-- en la busqueda por nombre puede o no tener documentos. Este campo dirá al action y al form para validarlo o no-->
<!-- si no lleva documento es porque fue encontrado en lista negra solo por el nombre -->
<input type='hidden' id='llevaDocumento' name='llevaDocumento'/>
<table cellpadding="0" cellspacing="0" border="" width="100%">
    <tr>
        <td width="100%">
            <div id="dlgMsj" title="Mensaje">
                <div id="divTxtMsjError"></div>
            </div>
        </td>
    </tr>
                                                            <tr>
                                                            <td width="20%">
                                                            </td>
                                                            <td width="80%">
                                                            <html:messages id="fallo">
                                                                <script type="text/javascript">
                                                                var txt = '';
                                                                txt += '${fallo}';
                                                                var dialog = bootbox.dialog({
                                                                    message: txt,
                                                                    closeButton: true
                                                                });

                                                                dialog.modal('hide');
                                                                </script>
                                                            </html:messages>
                                                            </td>
                                                        </tr>
    <tr>
        <td class="xlcd_no_border" width="20%">
        <table class="xlcd_no_border" width="20%">
        <tr>
            <td class="x1cd_no_border">
            <label class="x1cd">Tipo Documento</label>
            </td>
            <td class="x25_no_border"><%=tipoDocumentoSelected%></td>
        </tr>
        <tr>
            <td class="x1cd_no_border">N&uacute;mero Documento</td>
            <td class="x25_no_border">
                <input type="text" id="numeroDocumento" name="numeroDocumento" style="width:auto" class="x25" onfocus="leyenda();" value="<%=vNumDoc%>"> </input>
            </td>
        </tr>
        <tr>
            <td class="x1cd_no_border">Nombre</td>
            
            <td class="x1cd_no_border">
            <input type="text" id="elNombre" name="elNombre" style="width:auto" value="<%=vNombre%>" class="x25"> </input>
            </td>
            <td>
            <div id="selNom">
                Clientes : <select id='losNombres' name='losNombres' class='x25'><option value="<%=vTipoDoc%>">Seleccione...</option></select>
            </div>
            </td>
            <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td class="xlcd_no_border">
            <input name="env" class="xfk xfl x17c" type="button" onclick="llamaCierre();" value="Buscar"> </input>
        </td>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        <td class="xlcd_no_border">
            <input name="limp" class="xfk xfl x17c" type="button" onclick="nombre_limpieza_tablas();" value="Limpiar"> </input>
        </td>
            
        </tr>
        </table>
        </td>
    </tr>
</table>
</html:form>

<div id="grancontenedor">

    <div class="table-datos-cliente" >
    <table class="table table-sm">
    <thead>
    <tr>
    <th></th>
    <th style="text-align:center;font-size: 12px;font-style: italic;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;">Datos del Cliente</th>
    </tr>    
    </thead>
    <tbody>
        <tr>
            <td style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;">Nombre Cliente</td>
            <td id="td_nomcli" style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;"><%=StringUtils.trimToEmpty(det.getNombre())%></td>
            <td style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;">C&oacute;digo Cliente</td>
            <td id="td_codigocliente" style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;"><%=StringUtils.trimToEmpty(det.getCodigoCliente())%></td>
        </tr>
        <tr>
            <td style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;">Cod. Cliente</td>
            <td id="td_codcliente" style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;"><%=StringUtils.trimToEmpty(det.getCodCliente())%></td>
            <td style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;">Registro Fiscal</td>
            <td id="td_regfiscal" style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;"><%=StringUtils.trimToEmpty(det.getRegistroFiscal())%></td>
        </tr>
        <tr>
            <td style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;">Lista Negra</td>
            <%
                String lNegra=StringUtils.trimToEmpty(det.getListaNegra());
                if (StringUtils.isNotEmpty(lNegra)){
                    if (lNegra.indexOf("buena")>0) {//color verde
                    %>
                    <td id="td_lisnegra" style="font-size: 11px;font-style: italic; color: #00A800;padding: 0px 0px 0px 0px;font-weight: bold;"><%=StringUtils.trimToEmpty(det.getListaNegra())%></td>
                    <%
                    } else if (lNegra.indexOf("criterio")>0) {//color gris SIN SUFICIENTE CRITERIO
                    %>
                    <td id="td_lisnegra" style="font-size: 11px;font-style: italic; color: #9C9C9C;padding: 0px 0px 0px 0px;font-weight: bold;"><%=StringUtils.trimToEmpty(det.getListaNegra())%></td>
                    <%
                    } else {//color rojo
                    %>
                    <td id="td_lisnegra" style="font-size: 11px;font-style: italic; color: #FF0099;padding: 0px 0px 0px 0px;font-weight: bold;"><%=StringUtils.trimToEmpty(det.getListaNegra())%></td>
                    <%
                    }//else
                } else {//si viene vacio 
                %>
                <td id="td_lisnegra" style="font-size: 11px;font-style: italic; color: #FF0099;padding: 0px 0px 0px 0px;font-weight: bold;"></td>
                <%
                }
                %>
                
            <td style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;">Dui</td>
            <td id="td_dui" style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;"><%=StringUtils.trimToEmpty(det.getDui())%></td>
        </tr>
        <tr>
            <td style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;">Mensaje</td>
            <td id="td_mensaje" style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;"><%=StringUtils.trimToEmpty(det.getMensaje())%></td>
            <td style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;">Nit</td>
            <td id="td_nit" style="font-size: 10px;color: #4F4F4F;padding: 0px 0px 0px 0px;font-weight: normal;"><%=StringUtils.trimToEmpty(det.getNit())%></td>
      </tr>
        <tr>
            <td></td><td></td>
            <td></td><td></td>
        </tr>
    </tbody>
    </table>
  </div>


  <%
    if (found)
    {
  %>

  <div class="fila1">
	<div id="show_fact" class="table-wrapper-scroll-y2" >
		<table class="table table-bordered">
    <thead>
      <tr class="tr_title_sizing">
        <th colspan="3" scope="col" style="border:0px;text-align:center;" class="x150">Facturas</th>
      </tr>
      <tr class="tr_title_sizing">
        <th scope="col" class="x150">Fecha</th>
        <th scope="col" class="x150">No.Comp.</th>
        <th scope="col" class="x150">Monto</th>
      </tr>
    </thead>
    <tbody>
     <%
                    for (String s:fac){
                        a=StringUtils.split(s,"|");
                    %>
                    <tr class="tr_sizing">
                        <td class="xia"><%=a[0]%></td>
                        <td class="xia"><%=a[1]%></td>
                        <td class="xia"><%=a[2]%></td>
                    </tr>
                <%
                    }//for 
                %>
                </tbody>
                </table>
            </div>
            
	<div id="show_fisc" class="table-wrapper-scroll-y2" >
    <table class="table table-bordered">
    <thead>
      <tr class="tr_title_sizing">
        <th colspan="3" scope="col" style="border:0px;text-align:center;" class="x150">CC Fiscales</th>
      </tr>
      <tr class="tr_title_sizing">
        <th scope="col" class="x150">Fecha</th>
        <th scope="col" class="x150">No.Comp.</th>
        <th scope="col" class="x150">Monto</th>
      </tr>
    </thead>
    <tbody>
     <%
                    for (String s:ccf){
                        a=StringUtils.split(s,"|");
                    %>
                    <tr class="tr_sizing">
                        <td class="xia"><%=a[0]%></td>
                        <td class="xia"><%=a[1]%></td>
                        <td class="xia"><%=a[2]%></td>
                    </tr>
                <%
                    }//for 
                %>
                </tbody>
                </table>
            </div>
	<div id="show_comp" class="table-wrapper-scroll-y2" >
		<table class="table table-bordered">
    <thead>
      <tr class="tr_title_sizing">
        <th colspan="3" scope="col" style="border:0px;text-align:center;" class="x150">Compras</th>
      </tr>
      <tr class="tr_title_sizing">
        <th scope="col" class="x150">Fecha</th>
        <th scope="col" class="x150">No.Comp.</th>
        <th scope="col" class="x150">Monto</th>
      </tr>
    </thead>
    <tbody>
     <%
                    for (String s:com){
                        a=StringUtils.split(s,"|");
                    %>
                    <tr class="tr_sizing">
                        <td class="xia"><%=a[0]%></td>
                        <td class="xia"><%=a[1]%></td>
                        <td class="xia"><%=a[2]%></td>
                    </tr>
                <%
                    }//for 
                %>
                </tbody>
                </table>
            </div>
        
<div id="show_cust" class="table-custv">
  <table class="table table-bordered">
    <thead>
      <tr class="tr_title_sizing">
        <th colspan="4" scope="col" style="border:0px;text-align:center;" class="x150">Custodia de valores</th>
      </tr>
      <tr class="tr_title_sizing">
        <th scope="col" class="x150">No.Dcto.</th>
        <th scope="col" class="x150">Tipo Dcto.</th>
        <th scope="col" class="x150">Monto</th>
        <th scope="col" class="x150">Estado</th>
      </tr>
    </thead>
    <tbody>
                <%
                    for (String s:cva){
                        a=StringUtils.split(s,"|");
                        //System.out.println(s);
                %>
                    <tr class="tr_sizing">
                        <td class="xia"><%=a[0]%></td>
                        <td class="xia"><%=a[3]%></td>
                        <td class="xia"><%=a[4]%></td>
                        <td class="xia"><%=a[5]%></td>
                    </tr>
                <%
                    }//for 
                %>
                </tbody>
                </table>
        </div>
  </div>

  <div class="fila2">
<div id="show_cred" class="table-reser">
  <table class="table table-bordered">
    <thead>
      <tr class="tr_title_sizing">
        <th colspan="4" scope="col" style="border:0px;text-align:center;" class="x150">CREDITOS</th>
      </tr>
      <tr class="tr_title_sizing">
        <th scope="col" class="x150">N&uacute;mero</th>
        <th scope="col" class="x150">Estado</th>
        <th scope="col" class="x150">Monto</th>
        <th scope="col" class="x150">Empresa</th>
      </tr>
    </thead>
    <tbody>
                <%
                    for (String s:cr){
                        a=StringUtils.split(s,"|");
                    %>
                    <tr class="tr_sizing">
                        <td class="xia"><%=a[0]%></td>
                        <td class="xia"><%=a[1]%></td>
                        <td class="xia"><%=a[2]%></td>
                        <td class="xia"><%=a[3]%></td>
                    </tr>
                <%
                    }//for 
                %>
                </tbody>
                </table>
        </div>

<div id="show_gara" class="table-reser">
  <table class="table table-bordered">
    <thead>
      <tr class="tr_title_sizing">
        <th colspan="4" scope="col" style="border:0px;text-align:center;" class="x150">GARANTIAS DE CREDITO</th>
      </tr>
      <tr class="tr_title_sizing">
        <th scope="col" class="x150">N&uacute;mero</th>
        <th scope="col" class="x150">Estado</th>
        <th scope="col" class="x150">Monto</th>
        <th scope="col" class="x150">Empresa</th>
      </tr>
    </thead>
    <tbody>
                <%
                    for (String s:sgc){
                        a=StringUtils.split(s,"|");
                    %>
                    <tr class="tr_sizing">
                        <td class="xia"><%=a[0]%></td>
                        <td class="xia"><%=a[1]%></td>
                        <td class="xia"><%=a[2]%></td>
                        <td class="xia"><%=a[3]%></td>
                    </tr>
                <%
                    }//for 
                %>
                </tbody>
                </table>
        </div>
        
<div id="show_reser" class="table-reser">
  <table class="table table-bordered">
    <thead>
      <tr class="tr_title_sizing">
        <th colspan="4" scope="col" style="border:0px;text-align:center;" class="x150">GARANTIAS - FSG</th>
      </tr>
      <tr class="tr_title_sizing">
        <th scope="col" class="x150">N&uacute;mero</th>
        <th scope="col" class="x150">Estado</th>
        <th scope="col" class="x150">Monto</th>
        <th scope="col" class="x150">Empresa</th>
      </tr>
    </thead>
    <tbody>
    <%
                    for (String s:res){
                        a=StringUtils.split(s,"|");
                    %>
                    <tr class="tr_sizing">
                        <td class="xia"><%=a[0]%></td>
                        <td class="xia"><%=a[1]%></td>
                        <td class="xia"><%=a[2]%></td>
                        <td class="xia"><%=a[3]%></td>
                    </tr>
                <%
                    }//for 
                %>
                </tbody>
                </table>
        </div>

  </div>

</div>
  <%
    }//if found
  %>

    <script type="text/javascript">
    
        $('#idForm').on('keyup keypress', function(e) {
  var keyCode = e.keyCode || e.which;
  if (keyCode === 13) { 
    e.preventDefault();
    return false;
  }
});
    
            function llamaCierre(){  
            var valor=document.getElementById('elNombre').value;
            var numeroElementos = $('#losNombres option').length;
            
            if (valor.length>0 && numeroElementos<=1){
                myFunction();
            } else {
                var elemento = document.getElementById("losNombres");
                var el1 = document.getElementById("elTipoDocumento");
                var el2 = document.getElementById("numeroDocumento");
                var el3 = document.getElementById("elNumeroDocumento");
                var el4 = document.getElementById("tipoDocumento");
                var d=elemento.value;
                if (numeroElementos>1)
                {
                    if (isEmpty(d)) {
                            var mue = bootbox.dialog({
                                message: 'Seleccione un Nombre de la lista por favor',
                                closeButton: true
                            });
                            mue.modal('hide');
                            $("#modalDialog").empty();
                            $("#modalDialog").html('Seleccione un Nombre de la lista por favor');
                            $("#modalDialog").modal('show');
                        return false;
                    }
                    var arrayTdocu=d.split("/");
                    if (arrayTdocu.length>=1){
                        el1.value=arrayTdocu[0];
                        el3.value=arrayTdocu[1];
                        document.getElementById('llevaDocumento').value='SI';
                    } else {
                        document.getElementById('llevaDocumento').value='NO';
                    }
                    document.getElementById("tipoConsulta").value='POR_NOMBRE';
                }
                if (el2.value.length>0 && el4.value.length>0) {
                    document.getElementById("tipoConsulta").value='POR_DOCUMENTO';
                    document.getElementById('llevaDocumento').value='SI';
                    el1.value='';
                    el3.value='';
                }
                //ahora puede llevar o no documento, porque en la lista de nombres
                //se va incluir la lista negra que puede tener o no documentos
                
                var form = document.getElementById('idForm');
                form.submit();
            }
        }


      function nombre_limpieza_tablas() {
         $("#grancontenedor").empty();   
         $('input[type=text]').each(function(){
             $(this).val('');
          });
        var y="Clientes : <select id='losNombres' name='losNombres' class='x25'><option value=''>Seleccione...</option></select>";
        $("#selNom").empty();
        $("#selNom").append(y);

        
        $('tipoDocumento').first().focus();
    };

      function myFunction() {

      var valor=document.getElementById('elNombre').value;
      if (valor.length>0)
      {
        var reemplazo = valor.replace(/[&]/g,'|');
        $.ajax({
           url : 'consultaNombreAction.do',
           type : 'POST',
           data: "elNombre=" + reemplazo,
           cache: false,
           success: function(data) {
                var error = data.split("@")[0].split("|")[1];
                        var n = error.indexOf("error:");
                        if (n>=0){
                            var muestra = bootbox.dialog({
                                message: 'No encontramos coincidencias con ese nombre',
                                closeButton: true
                            });
                            muestra.modal('hide');
                            $("#modalDialog").empty();
                            $("#modalDialog").html('No encontramos coincidencias con ese nombre');
                            $("#modalDialog").modal('show');
                            var y=error.replace("error:","");
                            $("#selNom").empty();
                            $("#selNom").append(y);
                        } else {
                            $("#selNom").empty();
                            $("#selNom").append(error);
                        }
                    
                    
           },
           error: function(e) {
            }
    })
    }
    };
    
    function leyenda(){
        var tipo=document.getElementById('tipoDocumento').value;
        var leyenda='';

        if (tipo=='2'){
            leyenda='NIT sin guiones.Long. 14';
        } else if (tipo=='3'){
            leyenda='Reg.Fiscal sin guiones.Long. 8';
        } else if (tipo=='4'){
            leyenda='Nit Ext. sin guiones.Long. 14';
        } else if (tipo=='9'){
            leyenda='Pasap. sin guiones.Hasta 15';
        } else if (tipo=='16'){
            leyenda='DUI sin guiones.Long. 9';
        } else if (tipo=='99'){
            leyenda='No.Cli. sin guiones.Hasta 7';
        }
        document.getElementById('numeroDocumento').placeholder=leyenda;
    }
    
    //valida si un string es nulo, vacio o undefined
        function isEmpty(str) {
            return (!str || 0 === str.length);
        }
    </script>

  
</body>
</html>
