package bandesal.gob.sv.consulta.cliente.action;

import bandesal.gob.sv.consulta.cliente.connection.ConnectionManager;
import bandesal.gob.sv.consulta.cliente.form.ConsultaClienteForm;
import bandesal.gob.sv.consulta.cliente.dto.DetalleCliente;
import bandesal.gob.sv.consulta.cliente.util.Util;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import oracle.jdbc.driver.OracleTypes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMessages;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionMessage;

public class ConsultaClienteAction extends Action {
    final static Logger logger = Logger.getLogger(ConsultaClienteAction.class);
    private final static String separador = "|";
    private final static String SUCCESS = "successConsulta";
    

    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) throws Exception {
        ConsultaClienteForm cliForm = (ConsultaClienteForm) form;
        ActionMessages mensajes = new ActionMessages();
        String tipoDocumento = cliForm.getTipoDocumento();
        String numeroDocumento = cliForm.getNumeroDocumento();
        String elNombre = cliForm.getElNombre();
        String tipoConsulta = cliForm.getTipoConsulta();
        String elNumeroDocumento = StringUtils.trimToEmpty(cliForm.getElNumeroDocumento());//solo es para quitar un display en la interfaz
        if (elNumeroDocumento.length()>0){
            numeroDocumento = elNumeroDocumento;
        }
        
        String elTipoDocumento = StringUtils.trimToEmpty(cliForm.getElTipoDocumento());//solo es para quitar un display en la interfaz
        if (elTipoDocumento.length()>0){
            tipoDocumento = elTipoDocumento;
        }
        DetalleCliente det = new DetalleCliente();
        List<String> cr=new ArrayList<String>();
        List<String> sgc=new ArrayList<String>();
        List<String> res=new ArrayList<String>();
        List<String> ccf=new ArrayList<String>();
        List<String> fac=new ArrayList<String>();
        List<String> com=new ArrayList<String>();
        List<String> cva=new ArrayList<String>();

        StringBuffer sb = null;

        String a3= "";
        String error= "";
        String cod_cliente="";
        String codigo_cliente="";
        String registro_fiscal="";
        String listaNegra="";
        String nombre="";
        String dui="";
        String nit="";
        String formN="";
        String patt="#,##0.00";
        Connection con = null;
        CallableStatement stmt = null;
        ResultSet rsCREDITOS = null;//CREDITOS
        ResultSet rsSGC = null;//GARANTIAS
        ResultSet rsRES = null;//RESERVAS
        ResultSet rsCCF = null;//CREDITO FISCAL
        ResultSet rsFAC = null;//FACTURAS POR COD_CLIENTE
        ResultSet rsFAC2 = null;//FACTURAS POR CODIGO CLIENTE
        ResultSet rsCOM = null;//COMPRAS
        ResultSet rsCVA = null;//CUSTODIA DE VALORES
        boolean tieneFac=false;
        try {
            con = ConnectionManager.getConnection();
            mensajes.add("exito", new ActionMessage("mensaje.exitoso"));
            saveMessages(request, mensajes);
            stmt = con.prepareCall("{call P_CONSULTA_CLIENTE.consulta_cliente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? )}");
            stmt.setString(1, tipoDocumento);
            stmt.setString(2, numeroDocumento);
            stmt.registerOutParameter(3,java.sql.Types.VARCHAR);
            stmt.registerOutParameter(4,java.sql.Types.VARCHAR);
            stmt.registerOutParameter(5, java.sql.Types.VARCHAR );
            stmt.registerOutParameter(6, java.sql.Types.VARCHAR );
            stmt.registerOutParameter(7, java.sql.Types.VARCHAR );
            stmt.registerOutParameter(8, java.sql.Types.VARCHAR );
            stmt.registerOutParameter(9, java.sql.Types.VARCHAR );
            stmt.registerOutParameter(10, java.sql.Types.VARCHAR );
            stmt.registerOutParameter(11, OracleTypes.CURSOR);
            stmt.registerOutParameter(12, OracleTypes.CURSOR);
            stmt.registerOutParameter(13, OracleTypes.CURSOR);
            stmt.registerOutParameter(14, OracleTypes.CURSOR);
            stmt.registerOutParameter(15, OracleTypes.CURSOR);
            stmt.registerOutParameter(16, OracleTypes.CURSOR);
            stmt.registerOutParameter(17, OracleTypes.CURSOR);
            stmt.registerOutParameter(18, OracleTypes.CURSOR);
            
            stmt.execute();
            cod_cliente = StringUtils.trimToEmpty(stmt.getString(3));
            codigo_cliente = StringUtils.trimToEmpty(stmt.getString(4));
            registro_fiscal = StringUtils.trimToEmpty(stmt.getString(5));
            listaNegra = StringUtils.trimToEmpty(stmt.getString(6));
            nombre = StringUtils.trimToEmpty(stmt.getString(7));
            dui = StringUtils.trimToEmpty(stmt.getString(8));
            nit = StringUtils.trimToEmpty(stmt.getString(9));
            error = StringUtils.trimToEmpty(stmt.getString(10));
            det.setCodCliente(cod_cliente);
            det.setCodigoCliente(codigo_cliente);
            det.setRegistroFiscal(registro_fiscal);
            det.setListaNegra(listaNegra);
            det.setNombre(nombre);
            det.setDui(dui);
            det.setNit(nit);
            det.setMensaje(error);
            //cuando el cursor definido como OUT no viene con datos
            //marca una exception, INVALID SYS REF CURSOR
            //controlando esa exception
            //VIENE EL CURSOR P_CREDITOS
            try {
                    rsCREDITOS = (ResultSet) stmt.getObject(11);
                    if (rsCREDITOS!=null){
                        while(rsCREDITOS.next()){
                            sb = new StringBuffer();
                            a3=(StringUtils.trimToEmpty(rsCREDITOS.getString("no_credito").length()==0?" ":StringUtils.trimToEmpty(rsCREDITOS.getString("no_credito"))));
                            sb.append(a3);
                            sb.append(separador);
                            a3=(StringUtils.trimToEmpty(rsCREDITOS.getString("estado").length()==0?" ":StringUtils.trimToEmpty(rsCREDITOS.getString("estado"))));
                            sb.append(a3);
                            sb.append(separador);
                            formN=Util.formatNumbers(StringUtils.trimToEmpty(rsCREDITOS.getString("monto_credito")), patt);
                            sb.append(formN);
                            sb.append(separador);
                            a3=(StringUtils.trimToEmpty(rsCREDITOS.getString("empresa").length()==0?" ":StringUtils.trimToEmpty(rsCREDITOS.getString("empresa"))));
                            sb.append(a3);
                            cr.add(sb.toString());
                            /*
                            System.out.println("no_credito="+rsCREDITOS.getString("no_credito")+
                            " |  estado="+rsCREDITOS.getString("estado")+
                            " |  monto_credito="+formN+
                            " |  empresa="+rsCREDITOS.getString("empresa"));*/
                        }
                        det.setCreditos(cr);
                    }
                } catch (SQLException exsql) {
                    System.out.println("Pasando p_crcursor vacio");
                }

                //VIENE EL CURSOR P_CCFCURSOR
                try {
                        rsCCF = (ResultSet) stmt.getObject(12);
                        if (rsCCF!=null) {
                            while(rsCCF.next()){
                                sb = new StringBuffer();
                                a3=(StringUtils.trimToEmpty(rsCCF.getString("fecha").length()==0?" ":StringUtils.trimToEmpty(rsCCF.getString("fecha"))));
                                sb.append(a3);
                                sb.append(separador);
                                a3=(StringUtils.trimToEmpty(rsCCF.getString("comprobante").length()==0?" ":StringUtils.trimToEmpty(rsCCF.getString("comprobante"))));
                                sb.append(a3);
                                sb.append(separador);
                                formN=Util.formatNumbers(StringUtils.trimToEmpty(rsCCF.getString("venta_total")), patt);
                                sb.append(formN);
                                ccf.add(sb.toString());
                                /*
                                System.out.println("fecha="+rsCCF.getString("fecha")+
                                " | comprobante="+rsCCF.getString("comprobante")
                                +" | venta_total=" + formN);*/
                            }
                            det.setCcf(ccf);
                        }
                    } catch (SQLException exsql) {
                        System.out.println("Pasando p_ccfcursor vacio");
                    }

                //VIENE EL CURSOR P_FACCURSOR
                try {
                        rsFAC = (ResultSet) stmt.getObject(13);
                        if (rsFAC!=null) {
                            while(rsFAC.next()){
                                tieneFac=true;
                                sb = new StringBuffer();
                                a3=(StringUtils.trimToEmpty(rsFAC.getString("fecha_ingreso").length()==0?" ":StringUtils.trimToEmpty(rsFAC.getString("fecha_ingreso"))));
                                sb.append(a3);
                                sb.append(separador);
                                a3=(StringUtils.trimToEmpty(rsFAC.getString("comprobante").length()==0?" ":StringUtils.trimToEmpty(rsFAC.getString("comprobante"))));
                                sb.append(a3);
                                sb.append(separador);
                                formN=Util.formatNumbers(StringUtils.trimToEmpty(rsFAC.getString("venta_total")), patt);
                                sb.append(formN);
                                fac.add(sb.toString());
                                /*
                                System.out.println("fecha_ingreso="+rsFAC.getString("fecha_ingreso")+
                                " | comprobante="+rsFAC.getString("comprobante")
                                +" | venta_total=" + formN);*/
                            }
                            det.setFac(fac);
                        }
                    } catch (SQLException exsql) {
                        System.out.println("Pasando p_faccursor vacio");
                    }

                //VIENE EL CURSOR P_FAC2CURSOR. Fac2 viene solo si buscó en el plsql por cod_cliente y no encontro datos
                //Si no encontro datos por cod_cliente busca en la misma tabla por codigo_cliente para formar FAC2
                try {
                        rsFAC2 = (ResultSet) stmt.getObject(14);
                        if (rsFAC2!=null && !tieneFac) {
                            while(rsFAC2.next()){
                                sb = new StringBuffer();
                                a3=(StringUtils.trimToEmpty(rsFAC2.getString("fecha_ingreso").length()==0?" ":StringUtils.trimToEmpty(rsFAC2.getString("fecha_ingreso"))));
                                sb.append(a3);
                                sb.append(separador);
                                a3=(StringUtils.trimToEmpty(rsFAC2.getString("comprobante").length()==0?" ":StringUtils.trimToEmpty(rsFAC2.getString("comprobante"))));
                                sb.append(a3);
                                sb.append(separador);
                                formN=Util.formatNumbers(StringUtils.trimToEmpty(rsFAC2.getString("venta_total")), patt);
                                sb.append(formN);
                                fac.add(sb.toString());
                                /*
                                System.out.println("fecha_ingreso="+rsFAC2.getString("fecha_ingreso")+
                                " | comprobante="+rsFAC2.getString("comprobante")
                                +" | venta_total=" + formN);*/
                            }
                            det.setFac(fac);
                        }
                    } catch (SQLException exsql) {
                        System.out.println("Pasando p_fac2cursor vacio");
                    }

                //VIENE EL CURSOR P_COMCURSOR
                try {
                        rsCOM = (ResultSet) stmt.getObject(15);
                        if (rsCOM!=null) {
                            while(rsCOM.next()){
                                sb = new StringBuffer();
                                a3=(StringUtils.trimToEmpty(rsCOM.getString("fecha").length()==0?" ":StringUtils.trimToEmpty(rsCOM.getString("fecha"))));
                                sb.append(a3);
                                sb.append(separador);
                                a3=(StringUtils.trimToEmpty(rsCOM.getString("comprobante").length()==0?" ":StringUtils.trimToEmpty(rsCOM.getString("comprobante"))));
                                sb.append(a3);
                                sb.append(separador);
                                formN=Util.formatNumbers(StringUtils.trimToEmpty(rsCOM.getString("monto_total")), patt);
                                sb.append(formN);
                                com.add(sb.toString());
                                /*
                                System.out.println("fecha="+rsCOM.getString("fecha")+
                                " | comprobante="+rsCOM.getString("comprobante")
                                +" | monto_total=" + formN);*/
                            }
                            det.setCom(com);
                        }
                    } catch (SQLException exsql) {
                        System.out.println("Pasando p_comcursor vacio");
                    }

                //VIENE EL CURSOR P_CUSVCURSOR
                try {
                        rsCVA = (ResultSet) stmt.getObject(16);
                        if (rsCVA!=null) {
                            while(rsCVA.next()){
                                sb = new StringBuffer();
                                a3=(StringUtils.trimToEmpty(rsCVA.getString("numero_documento").length()==0?" ":StringUtils.trimToEmpty(rsCVA.getString("numero_documento"))));
                                sb.append(a3);
                                sb.append(separador);
                                a3=(StringUtils.trimToEmpty(rsCVA.getString("sub_aplicacion").length()==0?" ":StringUtils.trimToEmpty(rsCVA.getString("sub_aplicacion"))));
                                sb.append(a3);
                                sb.append(separador);
                                a3=(StringUtils.trimToEmpty(rsCVA.getString("tipo_documento").length()==0?" ":StringUtils.trimToEmpty(rsCVA.getString("tipo_documento"))));
                                sb.append(a3);
                                sb.append(separador);
                                a3=(StringUtils.trimToEmpty(rsCVA.getString("descripcion").length()==0?" ":StringUtils.trimToEmpty(rsCVA.getString("descripcion"))));
                                sb.append(a3);
                                sb.append(separador);
                                formN=Util.formatNumbers(StringUtils.trimToEmpty(rsCVA.getString("valor_mercado")), patt);
                                sb.append(formN);
                                sb.append(separador);
                                a3=(StringUtils.trimToEmpty(rsCVA.getString("estado").length()==0?" ":StringUtils.trimToEmpty(rsCVA.getString("estado"))));
                                sb.append(a3);
                                cva.add(sb.toString());
                                /*System.out.println("numero_documento="+rsCVA.getString("numero_documento")+
                                " | sub_aplicacion="+rsCVA.getString("sub_aplicacion")
                                +" | tipo_documento=" + rsCVA.getString("tipo_documento")
                                +" | descripcion=" + rsCVA.getString("descripcion")
                                +" | valor_mercado=" + formN
                                +" | estado=" + rsCVA.getString("estado"));*/
                            }
                            det.setCva(cva);
                        }
                    } catch (SQLException exsql) {
                        System.out.println("Pasando p_cvacursor vacio");
                    }
            
            

            //VIENE EL CURSOR P_SGCCURSOR
            try {
                    rsSGC = (ResultSet) stmt.getObject(17);
                    if (rsSGC!=null) {
                        while(rsSGC.next()){
                            sb = new StringBuffer();
                            a3=(StringUtils.trimToEmpty(rsSGC.getString("cre_num_garantia").length()==0?" ":StringUtils.trimToEmpty(rsSGC.getString("cre_num_garantia"))));
                            sb.append(a3);
                            sb.append(separador);
                            a3=(StringUtils.trimToEmpty(rsSGC.getString("cre_estado").length()==0?" ":StringUtils.trimToEmpty(rsSGC.getString("cre_estado"))));
                            sb.append(a3);
                            sb.append(separador);
                            formN=Util.formatNumbers(StringUtils.trimToEmpty(rsSGC.getString("cre_monto_credito")), patt);
                            sb.append(formN);
                            sb.append(separador);
                            a3=(StringUtils.trimToEmpty(rsSGC.getString("empresa").length()==0?" ":StringUtils.trimToEmpty(rsSGC.getString("empresa"))));
                            sb.append(a3);
                            sgc.add(sb.toString());
                            /*System.out.println("cre_num_garantia="+rsSGC.getString("cre_num_garantia")
                            + "| cre_estado="+rsSGC.getString("cre_estado")
                            + "| cre_monto_credito="+formN
                            + "| empresa="+rsSGC.getString("empresa"));*/
                        }
                        det.setSgc(sgc);
                    }
                } catch (SQLException exsql) {
                    System.out.println("Pasando p_sgccursor vacio");
                }

            //VIENE EL CURSOR P_RESCURSOR
            try {
                    rsRES = (ResultSet) stmt.getObject(18);
                    if (rsRES!=null) {
                        while(rsRES.next()){
                            sb = new StringBuffer();
                            a3=(StringUtils.trimToEmpty(rsRES.getString("res_comprobante").length()==0?" ":StringUtils.trimToEmpty(rsRES.getString("res_comprobante"))));
                            sb.append(a3);
                            sb.append(separador);
                            a3=(StringUtils.trimToEmpty(rsRES.getString("res_estado").length()==0?" ":StringUtils.trimToEmpty(rsRES.getString("res_estado"))));
                            sb.append(a3);
                            sb.append(separador);
                            formN=Util.formatNumbers(StringUtils.trimToEmpty(rsRES.getString("res_monto")), patt);
                            sb.append(formN);
                            sb.append(separador);
                            a3=(StringUtils.trimToEmpty(rsRES.getString("empresa").length()==0?" ":StringUtils.trimToEmpty(rsRES.getString("empresa"))));
                            sb.append(a3);
                            res.add(sb.toString());
                            /*System.out.println("res_comprobante="+rsRES.getString("res_comprobante")+
                            " | empresa="+rsRES.getString("empresa")
                            +" | res_monto=" + formN);*/
                        }
                        det.setRes(res);
                    }
                } catch (SQLException exsql) {
                    System.out.println("Pasando p_rescursor vacio");
                }

            }catch(Exception e){
               e.printStackTrace();
            }finally{
            try {
                request.setAttribute("detalleCliente", det);
                if (tipoConsulta.equals("POR_DOCUMENTO")){
                    request.setAttribute("tipoDocumento", tipoDocumento);
                    request.setAttribute("numeroDocumento", numeroDocumento);
                }
                if (tipoConsulta.equals("POR_NOMBRE")){
                    request.setAttribute("elNombre", elNombre);
                    request.setAttribute("tipoDocumento", "2");
                    request.setAttribute("numeroDocumento", "");
                }

            } catch (Exception ex) {
                ex.printStackTrace();
            }
            try {
                if (rsCREDITOS!=null)
                   rsCREDITOS.close();
                if (rsSGC!=null)
                   rsSGC.close();
                if (rsRES!=null)
                   rsRES.close();
                if (rsCCF!=null)
                   rsCCF.close();
                if (rsFAC!=null)
                   rsFAC.close();
                if (rsFAC2!=null)
                   rsFAC2.close();
                if (rsCOM!=null)
                   rsCOM.close();
                if (rsCVA!=null)
                   rsCVA.close();
               if (stmt!=null)
                  stmt.close();
               if (con!=null)
                  con.close();
            } catch (SQLException e) {
                 e.printStackTrace();
            }
        }        
        return mapping.findForward(SUCCESS);
    }
    
}
