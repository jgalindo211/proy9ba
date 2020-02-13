package bandesal.gob.sv.consulta.cliente.action;

import bandesal.gob.sv.consulta.cliente.form.ConsultaNombresForm;
import bandesal.gob.sv.consulta.cliente.util.Util;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.log4j.Logger;

public class ConsultaNombresAction  extends Action {
    final static Logger logger = Logger.getLogger(ConsultaNombresAction.class);
    public static final String DEFAULT_ENCODING = "UTF-8";
    public static final String CONTENT_TEXT_PLAIN = "text/plain";
    private final static String SUCCESS = "successNombre";

    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) throws Exception {
        ConsultaNombresForm cliForm = (ConsultaNombresForm) form;
        String nombre=StringUtils.trimToEmpty(cliForm.getElNombre()).toUpperCase();
        
        
        String error= "";
        try {
            String lNombres = Util.getListaNombres(nombre);
            //System.out.println("lnombres " + lNombres);
            enviarRespuestaNavegador(response, lNombres);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return mapping.findForward(null);
    }

    /**
     * Envia una respuesta en texto plano al navegador.
     * @param response Respueta.
     * @param contenidoRespuesta Contenido de la respuesta.
     * @throws IOException Si se produce un error al obtener el writer para la 
     * respuesta.
     */
    protected void enviarRespuestaNavegador(HttpServletResponse response,
                                            String contenidoRespuesta) {
        try {
            response.setContentType(CONTENT_TEXT_PLAIN);
            response.setCharacterEncoding(DEFAULT_ENCODING);
            response.getWriter().write(contenidoRespuesta);
        } catch(IOException ex) {
            ex.printStackTrace();
        }
    }
    
}


