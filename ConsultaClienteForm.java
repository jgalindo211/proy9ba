package bandesal.gob.sv.consulta.cliente.form;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.ValidatorForm;

import org.apache.struts.action.ActionMessage;

public class ConsultaClienteForm extends ValidatorForm {
    @SuppressWarnings("compatibility:-5395720774889034237")
    private static final long serialVersionUID = -6732812781128423280L;
    private String tipoDocumento;
    private String numeroDocumento;
    private String elNombre;
    private String tipoConsulta;
    private String elNumeroDocumento;
    private String elTipoDocumento;
    //ahora se incluye en el combo por nombre que no traiga documento
    //se puede dar cuando el nombre proviene de la CTC_PERSONAS
    private String llevaDocumento;

    public void setTipoDocumento(String tipoDocumento) {
        this.tipoDocumento = tipoDocumento;
    }

    public String getTipoDocumento() {
        return tipoDocumento;
    }

    public void setNumeroDocumento(String numeroDocumento) {
        this.numeroDocumento = numeroDocumento;
    }

    public String getNumeroDocumento() {
        return numeroDocumento;
    }

    public String getElNombre() {
        return elNombre;
    }

    public void setElNombre(String elNombre) {
       this.elNombre = elNombre;
    }

    public void setTipoConsulta(String tipoConsulta) {
        this.tipoConsulta = tipoConsulta;
    }

    public String getTipoConsulta() {
        return tipoConsulta;
    }

    public void setElNumeroDocumento(String elNumeroDocumento) {
        this.elNumeroDocumento = elNumeroDocumento;
    }

    public String getElNumeroDocumento() {
        return elNumeroDocumento;
    }

    public void setElTipoDocumento(String elTipoDocumento) {
        this.elTipoDocumento = elTipoDocumento;
    }

    public String getElTipoDocumento() {
        return elTipoDocumento;
    }

    public void setLlevaDocumento(String llevaDocumento) {
        this.llevaDocumento = llevaDocumento;
    }

    public String getLlevaDocumento() {
        return llevaDocumento;
    }

    public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
        ActionErrors errors = new ActionErrors();
        boolean val=false;
        //System.out.println("elTipoDocumento "+elTipoDocumento + " elNumeroDocumento " + elNumeroDocumento);
        if (elNumeroDocumento.length()>0 && StringUtils.isNotBlank(elNumeroDocumento)){
            numeroDocumento = elNumeroDocumento;
        }

        if (elTipoDocumento.length()>0 && StringUtils.isNotBlank(elTipoDocumento)){
            tipoDocumento = elTipoDocumento;
        }
        if (StringUtils.isBlank(tipoDocumento) && "SI".equals(llevaDocumento)) {
            errors.add("fallo", new ActionMessage("mensaje.valida.tipo.documento"));
        } else if (StringUtils.isBlank(numeroDocumento) && "SI".equals(llevaDocumento)) {
            errors.add("fallo", new ActionMessage("mensaje.valida.documento"));
        } else {
            if ("2".equals(tipoDocumento)) { //NIT
                val=validaFormato(numeroDocumento,"nit");
                if (!val) {
                    errors.add("fallo", new ActionMessage("mensaje.valida.nit"));
                }
            } else if ("3".equals(tipoDocumento)) { //NREGF
                val=validaFormato(numeroDocumento,"nregf");
                if (!val) {
                    errors.add("fallo", new ActionMessage("mensaje.valida.registro.fiscal"));
                }
            } else if ("4".equals(tipoDocumento)) { //nite
                val=validaFormato(numeroDocumento,"nite");
                if (!val) {
                    errors.add("fallo", new ActionMessage("mensaje.valida.nite"));
                }
            } else if ("9".equals(tipoDocumento)) { //pasp
                val=validaFormato(numeroDocumento,"pasp");
                if (!val) {
                    errors.add("fallo", new ActionMessage("mensaje.valida.pasp"));
                }
            } else if ("16".equals(tipoDocumento)) { //DUI
                val=validaFormato(numeroDocumento,"dui");
                if (!val) {
                    errors.add("fallo", new ActionMessage("mensaje.valida.dui"));
                }
            } else if ("99".equals(tipoDocumento)) { //NUMERO UNICO
                val=validaFormato(numeroDocumento,"nuu");
                if (!val) {
                    errors.add("fallo", new ActionMessage("mensaje.valida.nuu"));
                }
            }
        }
        return errors;
    }
    
    private boolean validaFormato(String input, String tipo){
        boolean v=false;
        HashMap<String, String> hmFormatos = new HashMap<String, String>();
        hmFormatos.put("nit", "[0-9]{14}");
        hmFormatos.put("dui", "[0-9]{9}");
        hmFormatos.put("nregf", "[0-9]{8}");
        hmFormatos.put("pasp", "^[a-zA-Z0-9]{1,15}$");
        hmFormatos.put("nite", "[a-zA-Z0-9]{14}");
        hmFormatos.put("nuu", "[0-9]{2,7}");

        try{
            v=input.matches(hmFormatos.get(tipo));
        } catch (Exception ex){
            ex.printStackTrace();
        }
        return v;
    }
    
}
