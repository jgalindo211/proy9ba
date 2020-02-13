package bandesal.gob.sv.consulta.cliente.util;

import bandesal.gob.sv.consulta.cliente.dto.UserListaNegra;

import java.io.BufferedReader;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;

import java.io.FileReader;
import java.io.IOException;

import org.apache.commons.lang.StringUtils;

public class Pruebe {
    public static void main(String[] args) {
        Pruebe pruebe = new Pruebe();
        pruebe.operacion();
        UserListaNegra ul;
        List<UserListaNegra> li = new ArrayList<UserListaNegra>();
        ul = new UserListaNegra();
        ul.setConocidoPor("cpor1");
        ul.setDui("");
        ul.setNit("07092102640015");
        ul.setOtroTipoDoc("");
        ul.setNumeroDoc("");
        ul.setNombrePersona("juan");
        li.add(ul);
        ul = new UserListaNegra();
        ul.setConocidoPor("cpor2");
        ul.setDui("");
        ul.setNit("08092102640015");
        ul.setOtroTipoDoc("4");
        ul.setNumeroDoc("457894");
        ul.setNombrePersona("jose");
        li.add(ul);
        JSONArray jsonArray = JSONArray.fromObject(li);
        System.out.println(jsonArray);

    }

    private void operacion() {
        FileReader fr = null;
        BufferedReader reader=null;
        try {
            fr = new FileReader("D:\\Documentos\\xml_Mensual\\202001\\validacion.txt");
            reader = new BufferedReader(fr);
            String[] a;
            double d=0.00;
            double total=0.00;
            int conteo=0;
            String line = reader.readLine();
            while (line != null) {
                System.out.println(line);
                a=StringUtils.split(line);
                d=Double.parseDouble(a[1]);
                total+=d;
                if (d>0){
                    conteo++;
                }
                // read next line
                line = reader.readLine();
            }
            System.out.println("total " + total + " conteo transacciones " + conteo);
            
        } catch (IOException e) {
            e.printStackTrace();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        finally{
            try{
                reader.close();
            } catch (IOException ioe){
                
            }
        }
    }
}

