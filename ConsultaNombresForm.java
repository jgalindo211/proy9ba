package bandesal.gob.sv.consulta.cliente.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.ValidatorForm;

public class ConsultaNombresForm  extends ValidatorForm {
    @SuppressWarnings("compatibility:-5395720774889034237")
    private static final long serialVersionUID = -6732812781128423280L;
     private String elNombre;

     public String getElNombre() {
         return elNombre;
     }

    public void setElNombre(String elNombre) {
        this.elNombre = elNombre;
    }

    public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
        ActionErrors errors = new ActionErrors();
        return errors;
    }
    
    
 }
