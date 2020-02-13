package bandesal.gob.sv.consulta.cliente.connection;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ConnectionManager 
{
private static DataSource ds = null;

/**
   * Maneja la conexion utilizando JNDI 
   * @throws java.sql.SQLException
   * @return DataSource
   */
public static Connection getConnection() throws SQLException
  {      
          try{
              InitialContext contextjndi = new InitialContext();
              if(ds==null)
                ds = (DataSource) contextjndi.lookup("jdbc/consultaClienteDS");   
              return ds.getConnection();   
          }catch(javax.naming.NamingException ne){
              throw new SQLException(ne.getMessage()+ne.getExplanation());
          }
  }

 
}