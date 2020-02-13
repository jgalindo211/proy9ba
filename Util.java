package bandesal.gob.sv.consulta.cliente.util;


import bandesal.gob.sv.consulta.cliente.connection.ConnectionManager;
import bandesal.gob.sv.consulta.cliente.dto.UserListaNegra;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.sql.CallableStatement;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;


import java.util.Locale;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import net.sf.json.JSONObject;

import oracle.jdbc.driver.OracleTypes;

import org.apache.log4j.Logger;
import org.apache.commons.lang.StringUtils;


public class Util {
    final static Logger logger = Logger.getLogger(Util.class);
    final static String FILE_PROPERTIES = "ApplicationResource.properties";
    final static String OUTPUT_NAME="/Consu/logs/salidaFormasRoles.txt";
    
    public static String getProperty(String llave) {
    Properties prop = new Properties();
    String result = "";
    try {
            InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream(FILE_PROPERTIES);
            prop.load(inputStream);
            result = prop.getProperty(llave);

        } catch (IOException e) {
            logger.error("Util. Error de lectura propiedades", e);
        }
        return result;
    }

    public static String getPathFile(String nombreArchivo) {
    String result = "";
        File file = new File(Util.class.getClassLoader().getResource(nombreArchivo).getFile());
        result = file.getPath();
        return result;
    }

    public static String safeDouble(Double d){
        String safe=null;
        try {
            safe=String.valueOf(d);
        } catch (Exception ex){
            safe="0.00";
        }
        return safe;
    }
    
    public static String formatNumbers(String n, String patt){
        String f;
        try{
            //DecimalFormat df = (DecimalFormat)DecimalFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat df = new DecimalFormat(patt, new DecimalFormatSymbols(Locale.ENGLISH));

            f=df.format(Double.parseDouble(n));
        } catch (Exception ex){
            f=n;
        }
        return f;
    }
    
    public static String getFechaAsString(Date fecha, String formato) {
        String fec="";
        SimpleDateFormat sdf = new SimpleDateFormat(formato);
        fec=sdf.format(fecha);
        return fec;
    }
    
    public static java.sql.Date getFechaSql(Date fecha, String formato) {
        java.sql.Date fec=null;
        try{
            SimpleDateFormat sdf = new SimpleDateFormat(formato);
            fec=new java.sql.Date(sdf.parse(sdf.format(fecha)).getTime());
        } catch (Exception pa){
            logger.error(pa);
        }
        return fec;
    }
    
    public static String getUser(HttpServletRequest request) {
        String l_user = null;
        try {
            
            //logger.info("Previo Usuario logueado: " + request.getHeader("Proxy-Remote-User"));
            //l_user=StringUtils.trimToEmpty(cleanEntrada(request.getHeader("Proxy-Remote-User")));
            l_user=StringUtils.trimToEmpty(request.getHeader("Proxy-Remote-User"));
            //logger.info("After Usuario logueado: " + l_user);
            logger.debug("usuario remoto: " + l_user);
            l_user="JGALINDO";
        } catch (Exception e) {
            logger.error(e);
            l_user = null;
        }

        if ((l_user == null) || (l_user.length() <= 0)) {
            l_user = null; //no es valido
        }

        //request.getSession().setAttribute("usuarioSession" + getSistema(), l_user);
        return l_user;
    }
    
    /**
         * consultarClientes
         * @param idRequerimiento.
         * @param usuario.
         * @param estado.
         * @param sistema.
         * @return String que lleva el resultado del proceso
         * @throws SQLException Si se produce un error al guardar los datos.
         * CONSULTA_CLIENTE
         */
        public static String consultarClientes(Integer idRequerimiento, 
                                                             String usuario,String estado, String sistema) throws SQLException {
            Connection conexion = null;
            CallableStatement instruccion = null;
            String mensaje="";
            try {
                conexion = ConnectionManager.getConnection();
                String call = " {call CONSULTA_CLIENTE(?,?,?,?,?)} ";
                instruccion = conexion.prepareCall(call);
                instruccion.setInt(1, idRequerimiento);
                instruccion.setString(2, usuario);
                instruccion.setString(3, estado);
                instruccion.setString(4, sistema);
                instruccion.setString(5, mensaje);
                instruccion.registerOutParameter(5, Types.VARCHAR);
                instruccion.execute();
                mensaje = instruccion.getString(5);
                if (StringUtils.isNotEmpty(mensaje)) {
                    throw new Exception(mensaje);
                }
            } catch (Exception ex) {
                logger.error(ex);
            } finally {
                cerrarObjetoDb(instruccion);
                cerrarObjetoDb(conexion);
            }
            
            return mensaje;
        }


    public static String getRoles(){
      Connection conn = null;
      PreparedStatement pstmt = null;
      List<String> lds = new ArrayList<String>();
      ResultSet rs = null;
      String queryRoles = "";
      StringBuffer sb=new StringBuffer("Roles : <select id='rol' name='rol' class='select'>");
      
      queryRoles = "SELECT " 
        + " DISTINCT COD_ROL AS rol"
        + " FROM PA.ROLES"
        + " ORDER BY COD_ROL";
      try{
            conn = ConnectionManager.getConnection() ;
            pstmt = conn.prepareStatement(queryRoles);
            rs = pstmt.executeQuery();
            sb.append("<option value=''>Seleccione...</option>");
            while(rs.next())
            {
                sb.append("<option value='");
                sb.append(rs.getString("rol"));
                sb.append("'>");
                sb.append(rs.getString("rol"));
                sb.append("</option>");
            }
            sb.append("</select>");

          }      catch(SQLException ex) {
              logger.error(ex);
          }
      finally {
          cerrarObjetoDb(rs);
          cerrarObjetoDb(pstmt);
          cerrarObjetoDb(conn);
      }
      return sb.toString();
    }

    
    public static String getListaNombres(String nombre){
        Connection con = null;
        CallableStatement stmt = null;
        ResultSet rsNombres = null;
        ResultSet rsCtc = null;
        StringBuilder lNombres=new StringBuilder();
        String error="";
        int numRegistros=0;
        try {
            con = ConnectionManager.getConnection();
            stmt = con.prepareCall("{call P_CONSULTA_NOMBRES.consulta_nombres(?,?,?,? )}");
            stmt.setString(1, nombre);
            stmt.registerOutParameter(2,java.sql.Types.VARCHAR);
            stmt.registerOutParameter(3, OracleTypes.CURSOR);
            stmt.registerOutParameter(4, OracleTypes.CURSOR);
            
            stmt.execute();
            error = StringUtils.trimToEmpty(stmt.getString(2));
            if (StringUtils.isBlank(error)) {

                //VIENE EL CURSOR P_NOMBRES
                try {
                    rsNombres = (ResultSet) stmt.getObject(3);
                    if (rsNombres!=null){
                        while(rsNombres.next()){
                            if (numRegistros==0){
                                lNombres.append("exito|");
                                lNombres.append("<select id='losNombres" + "' name='losNombres" + "' class='x25'>");
                                lNombres.append("<option value=''>Seleccione...</option>");
                            }
                            numRegistros++;
                            lNombres.append("<option value='");
                            lNombres.append(StringUtils.trimToEmpty(rsNombres.getString("tipo_id")));
                            lNombres.append("/");
                            lNombres.append(StringUtils.trimToEmpty(rsNombres.getString("codigo_cliente")));
                            lNombres.append("'>");
                            lNombres.append(StringUtils.trimToEmpty(rsNombres.getString("nombre_completo")));
                            lNombres.append(" ");
                            lNombres.append(rsNombres.getString("doc"));
                            lNombres.append("</option>");
                        }
                        if (numRegistros>0){
                            lNombres.append("</select>");
                        }
                        
                    } 

                } catch (SQLException exsql) {
                    System.out.println("Pasando p_nombres vacio");
                }
                
                if (numRegistros==0) {
                    //VIENE EL CURSOR P_CTCCURSOR
                    try {
                        String valorTipo="";
                        String valorNum="";
                        boolean conDocumento;
                        rsCtc = (ResultSet) stmt.getObject(4);
                        if (rsCtc!=null){
                            while(rsCtc.next()){
                                conDocumento=false;
                                if (numRegistros==0){
                                    lNombres.append("exito|");
                                    lNombres.append("<select id='losNombres" + "' name='losNombres" + "' class='x25'>");
                                    lNombres.append("<option value=''>Seleccione...</option>");
                                }
                                numRegistros++;
                                
                                valorTipo = StringUtils.trimToEmpty(rsCtc.getString("tipo_nit"));
                                valorNum = StringUtils.trimToEmpty(rsCtc.getString("numero_nit"));
                                
                                if (StringUtils.isNotBlank(valorTipo) && StringUtils.isNotBlank(valorNum) ){
                                    conDocumento=true;
                                    lNombres.append("<option value='");
                                    lNombres.append(valorTipo);
                                    lNombres.append("/");
                                    lNombres.append(valorNum);
                                    lNombres.append("'>");
                                    lNombres.append(StringUtils.trimToEmpty(rsCtc.getString("ctc_per_nombre")));
                                    lNombres.append(" ");
                                    lNombres.append(valorNum);
                                    lNombres.append("</option>");
                                }
                                valorTipo = StringUtils.trimToEmpty(rsCtc.getString("tipo_dui"));
                                valorNum = StringUtils.trimToEmpty(rsCtc.getString("numero_dui"));
                                
                                if (StringUtils.isNotBlank(valorTipo) && StringUtils.isNotBlank(valorNum) && !conDocumento){
                                    conDocumento=true;
                                    lNombres.append("<option value='");
                                    lNombres.append(valorTipo);
                                    lNombres.append("/");
                                    lNombres.append(valorNum);
                                    lNombres.append("'>");
                                    lNombres.append(StringUtils.trimToEmpty(rsCtc.getString("ctc_per_nombre")));
                                    lNombres.append(" ");
                                    lNombres.append(valorNum);
                                    lNombres.append("</option>");
                                }

                                valorTipo = StringUtils.trimToEmpty(rsCtc.getString("tipo_otro"));
                                valorNum = StringUtils.trimToEmpty(rsCtc.getString("numero_otro"));
                                
                                if (StringUtils.isNotBlank(valorTipo) && StringUtils.isNotBlank(valorNum) && !conDocumento){
                                    conDocumento=true;
                                    lNombres.append("<option value='");
                                    lNombres.append(valorTipo);
                                    lNombres.append("/");
                                    lNombres.append(valorNum);
                                    lNombres.append("'>");
                                    lNombres.append(StringUtils.trimToEmpty(rsCtc.getString("ctc_per_nombre")));
                                    lNombres.append(" ");
                                    lNombres.append(valorNum);
                                    lNombres.append("</option>");
                                }
                                if (!conDocumento) {
                                    //tipo 45 significara que no tiene documento
                                    lNombres.append("<option value='45");
                                    lNombres.append("/");
                                    lNombres.append(String.valueOf(numRegistros));
                                    lNombres.append("'>");
                                    lNombres.append(StringUtils.trimToEmpty(rsCtc.getString("ctc_per_nombre")));
                                    lNombres.append("</option>");
                                }
                            }
                            if (numRegistros>0){
                                lNombres.append("</select>");
                            }
                            
                        } 

                    } catch (SQLException exsql) {
                        System.out.println("Pasando p_ctccursor vacio");
                    }
                }
            }
            if (numRegistros==0) {
                lNombres.append("exito|error:");
                lNombres.append("<select id='losNombres" + "' name='losNombres" + "' class='x25'>");
                lNombres.append("<option value=''>Seleccione...</option>");
                lNombres.append("</select>");
            }
            
            
            }catch(Exception e){
               e.printStackTrace();
            }finally{
            try {
               if (rsNombres!=null)
                  rsNombres.close();
                if (rsCtc!=null)
                   rsCtc.close();
               if (stmt!=null)
                  stmt.close();
               if (con!=null)
                  con.close();
            } catch (SQLException e) {
                 e.printStackTrace();
            }
        }
      return lNombres.toString();
    }


    
    public static String getListaNegra(String nombre, String conocidoPor){
        Connection con = null;
        CallableStatement stmt = null;
        ResultSet rsListaNegraNombres = null;
        ResultSet rsListaNegraConocPor = null;
        String json="vacio";
        String error="";
        String nombre1="";
        String nombre2="";
        String conocidoPor1="";
        String conocidoPor2="";
        try {
            String[] ar=StringUtils.split(nombre);
            if (ar!=null && ar.length>0){
                nombre1=ar[0];
                if (ar.length>1){
                    nombre2=ar[1];
                }
            }
           
            ar=StringUtils.split(conocidoPor);
            if (ar!=null && ar.length>0){
               conocidoPor1=ar[0];
               if (ar.length>1){
                  conocidoPor2=ar[1];
                }
            }
                
            con = ConnectionManager.getConnection();
            stmt = con.prepareCall("{call P_CONS_LISTA_NEGRA_CLIENTE.obt_nombres_lista_negra(?,?,?,?,?,?,? )}");
            stmt.setString(1, nombre1);
            stmt.setString(2, nombre2);
            stmt.setString(3, conocidoPor1);
            stmt.setString(4, conocidoPor2);
            stmt.registerOutParameter(5,java.sql.Types.VARCHAR);
            stmt.registerOutParameter(6, OracleTypes.CURSOR);
            stmt.registerOutParameter(7, OracleTypes.CURSOR);
            stmt.execute();
            error = StringUtils.trimToEmpty(stmt.getString(5));
            if (StringUtils.isBlank(error)) {

                //VIENE EL CURSOR P_NOMBRES
                try {
                    rsListaNegraNombres = (ResultSet) stmt.getObject(6);
                    UserListaNegra ul;
                    List<UserListaNegra> li= new ArrayList<UserListaNegra>();
                    if (rsListaNegraNombres!=null){
                        while(rsListaNegraNombres.next()){
                            ul=new UserListaNegra();
                            ul.setConocidoPor(StringUtils.trimToEmpty(rsListaNegraNombres.getString("per_conocido_por")));
                            ul.setDui(StringUtils.trimToEmpty(rsListaNegraNombres.getString("per_dui")));
                            ul.setNit(StringUtils.trimToEmpty(rsListaNegraNombres.getString("per_nit")));
                            ul.setOtroTipoDoc(StringUtils.trimToEmpty(rsListaNegraNombres.getString("per_tipo_doc")));
                            ul.setNumeroDoc(rsListaNegraNombres.getString("per_numero"));
                            ul.setNombrePersona(rsListaNegraNombres.getString("per_nombre"));
                            li.add(ul);
                        }
                        JSONArray jsonArray=JSONArray.fromObject(li);
                        json=jsonArray.toString();
                        System.out.println(json);
                    }//si rs no es nulo
                } catch (SQLException exsql) {
                    System.out.println("Pasando cursor vacio lista negra por nombre");
                }
            }//si error es vacio

            }catch(Exception e){
               e.printStackTrace();
            }finally{
            try {
               if (rsListaNegraNombres!=null)
                  rsListaNegraNombres.close();
               if (rsListaNegraConocPor!=null)
                   rsListaNegraConocPor.close();
               if (stmt!=null)
                  stmt.close();
               if (con!=null)
                  con.close();
            } catch (SQLException e) {
                 e.printStackTrace();
            }
        }        
      return json;
    }


    /**
     * Intenta cerrar un objeto ResultSet siempre y cuando sea posible.
     * @param resultado ResultSet a cerrar.
     */
    public static void cerrarObjetoDb(ResultSet resultado) {
        if (resultado != null) {
            try {
                resultado.close();
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
    }

    /**
    * Intenta cerrar un objeto Statement siempre y cuando sea posible.
    * @param instruccion PreparedStatement a cerrar.
    */
    public static void cerrarObjetoDb(PreparedStatement instruccion) {
        if (instruccion != null) {
            try {
                instruccion.close();
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
    }

    /**
    * Intenta cerrar un objeto Connection siempre y cuando sea posible.
    * @param conexion Statement a cerrar.
    */
    public static void cerrarObjetoDb(Connection conexion) {
        if (conexion != null) {
            try {
                conexion.close();
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
    }
    
    
    /**
     * Efectua el rollback de una conexion.
     * @param conexion Conexion a efectuar rollback.
     */
    public static void rollbackConnection(Connection conexion) {
        if (conexion != null) {
            try {
                conexion.rollback();
            } catch(Exception ex) {
                logger.error(ex);
            }
        }
    }
    
    
    /**
     * Devuelve una fecha en forma de String con el formato que recibe. 
     * @param fecha Fecha a formatear.
     * @param formato Formato a proporcionar a la fecha.
     * @return La fecha formateada.
     */
    public static String formatearFecha(Date fecha, String formato) {
        if (fecha == null) return null;
        SimpleDateFormat sdf = new SimpleDateFormat(formato);
        return sdf.format(fecha);
    }
    
    
  
    /**
     * Esta funcion crea de forma dinámica la lista de valores 
     * para el campo reporte
     * @return String
     */
     public static String getTiposDocumentoSelected(String elegido)
    {
        StringBuffer sb = new StringBuffer();
        String defa="2";//nit
        if (StringUtils.isNotBlank(elegido)) {
            defa=elegido;
        }
        int v=Integer.parseInt(defa);
          sb = new StringBuffer("<select id='tipoDocumento' name='tipoDocumento' class='x25'>");
          switch(v){
          case 2://nit
                sb.append("<option value='2' selected>NIT</option>");
                sb.append("<option value='16'>DUI</option>");
                sb.append("<option value='99'>Codigo Cliente</option>");
                sb.append("<option value='3'>Registro Fiscal</option>");
                sb.append("<option value='4'>Nit Extranjero</option>");
                sb.append("<option value='9'>Pasaporte</option>");
                break;
            case 16://dui
                sb.append("<option value='2'>NIT</option>");
                sb.append("<option value='16' selected>DUI</option>");
                sb.append("<option value='99'>Codigo Cliente</option>");
                sb.append("<option value='3'>Registro Fiscal</option>");
                sb.append("<option value='4'>Nit Extranjero</option>");
                sb.append("<option value='9'>Pasaporte</option>");
                break;
            case 99://nuu
                  sb.append("<option value='2'>NIT</option>");
                  sb.append("<option value='16'>DUI</option>");
                  sb.append("<option value='99' selected>Codigo Cliente</option>");
                  sb.append("<option value='3'>Registro Fiscal</option>");
                  sb.append("<option value='4'>Nit Extranjero</option>");
                  sb.append("<option value='9'>Pasaporte</option>");
               break;
            case 3://nrc
                    sb.append("<option value='2'>NIT</option>");
                    sb.append("<option value='16'>DUI</option>");
                    sb.append("<option value='99'>Codigo Cliente</option>");
                    sb.append("<option value='3' selected>Registro Fiscal</option>");
                    sb.append("<option value='4'>Nit Extranjero</option>");
                    sb.append("<option value='9'>Pasaporte</option>");
               break; 
             case 4://nite
                    sb.append("<option value='2'>NIT</option>");
                    sb.append("<option value='16'>DUI</option>");
                    sb.append("<option value='99'>Codigo Cliente</option>");
                    sb.append("<option value='3'>Registro Fiscal</option>");
                    sb.append("<option value='4' selected>Nit Extranjero</option>");
                    sb.append("<option value='9'>Pasaporte</option>");
               break; 
             case 9://pass
                    sb.append("<option value='2'>NIT</option>");
                    sb.append("<option value='16'>DUI</option>");
                    sb.append("<option value='99'>Codigo Cliente</option>");
                    sb.append("<option value='3'>Registro Fiscal</option>");
                    sb.append("<option value='4'>Nit Extranjero</option>");
                    sb.append("<option value='9' selected>Pasaporte</option>");
              break; 
          }
          sb.append("</select>");

      return sb.toString();
    }

}