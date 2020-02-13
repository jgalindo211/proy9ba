package bandesal.gob.sv.consulta.cliente.dto;

import java.util.ArrayList;
import java.util.List;

public class DetalleCliente {
    private String codCliente;
    private String codigoCliente;
    private String mensaje;
    private String registroFiscal;
    private String listaNegra;
    private String nombre;
    private String dui;
    private String nit;
    private List<String> creditos;
    private List<String> sgc;
    private List<String> res;
    private List<String> ccf;
    private List<String> fac;
    private List<String> com;
    private List<String> cva;
    
    public DetalleCliente() {
        creditos=new ArrayList<String>();
        sgc=new ArrayList<String>();
        res=new ArrayList<String>();
        ccf=new ArrayList<String>();
        fac=new ArrayList<String>();
        com=new ArrayList<String>();
        cva=new ArrayList<String>();
    }


    public void setCodCliente(String codCliente) {
        this.codCliente = codCliente;
    }

    public String getCodCliente() {
        return codCliente;
    }

    public void setCodigoCliente(String codigoCliente) {
        this.codigoCliente = codigoCliente;
    }

    public String getCodigoCliente() {
        return codigoCliente;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setRegistroFiscal(String registroFiscal) {
        this.registroFiscal = registroFiscal;
    }

    public String getRegistroFiscal() {
        return registroFiscal;
    }

    public void setListaNegra(String listaNegra) {
        this.listaNegra = listaNegra;
    }

    public String getListaNegra() {
        return listaNegra;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getNombre() {
        return nombre;
    }

    public void setDui(String dui) {
        this.dui = dui;
    }

    public String getDui() {
        return dui;
    }

    public void setNit(String nit) {
        this.nit = nit;
    }

    public String getNit() {
        return nit;
    }

    public void setCreditos(List<String> creditos) {
        this.creditos = creditos;
    }

    public List<String> getCreditos() {
        return creditos;
    }

    public void setSgc(List<String> sgc) {
        this.sgc = sgc;
    }

    public List<String> getSgc() {
        return sgc;
    }

    public void setRes(List<String> res) {
        this.res = res;
    }

    public List<String> getRes() {
        return res;
    }

    public void setCcf(List<String> ccf) {
        this.ccf = ccf;
    }

    public List<String> getCcf() {
        return ccf;
    }

    public void setFac(List<String> fac) {
        this.fac = fac;
    }

    public List<String> getFac() {
        return fac;
    }

    public void setCom(List<String> com) {
        this.com = com;
    }

    public List<String> getCom() {
        return com;
    }

    public void setCva(List<String> cva) {
        this.cva = cva;
    }

    public List<String> getCva() {
        return cva;
    }

}
