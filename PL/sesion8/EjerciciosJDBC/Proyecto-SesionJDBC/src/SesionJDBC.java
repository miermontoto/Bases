
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class SesionJDBC {

	private static String USUARIO = "JuanMier";
	private static String PASSWORD = "test";  
	private static String NOMBRE_BASEDATOS = "universidad";
	private static String STRING_CONEXION = "jdbc:postgresql://localhost:5432/" + NOMBRE_BASEDATOS;
	
	public static void main(String[] args) {
		try {
			ejemplo1();
			ejemplo2();
		} catch (SQLException e) {e.printStackTrace();}
	}


	/**
	 * Ejemplo 1. 
	 * Realizar un metodo en Java que presente por pantalla toda la informacion de los grados.
	 */
	public static void ejemplo1() throws SQLException {
		System.out.println("################### EJEMPLO 1 ###################");
		Connection con = getConnection();
		
		// Crear la consulta SQL
		StringBuilder query = new StringBuilder();
		query.append("SELECT * ");
		query.append("FROM grado ");
		String testQuery = "select * from grado";
		
		// Objeto de tipo Statement para enviar la consulta a la base de datos
		Statement st = con.createStatement();
		// executeQuery retornara un resultSet
		ResultSet rs = st.executeQuery(testQuery);
		presentaResultados(rs);
		
		// Muy importante, liberar todos los objetos relacionados con la base de datos
		rs.close();
		st.close();
		con.close();
	}

	/**
	 * Ejemplo 2. 
	 * Realizar un metodo en Java que presente por pantalla 
	 * toda la informacion de un profesor, se pedirá su nombre por entrada estandar.
	 */
	public static void ejemplo2() throws SQLException {
		System.out.println("################### EJEMPLO 2 ###################");
		Connection con = getConnection();
		
		//Creacion de la consulta SQL
		StringBuilder query = new StringBuilder();
		
		// ? sera reemplazado por el valor introducido por entrada estandard
		query.append("SELECT * ");
		query.append("FROM profesor WHERE profesor_nombre = ?"); 
		
		//Crear el objeto Statement para realizar las sentencias de la base de datos
		PreparedStatement st = con.prepareStatement(query.toString());
		
		System.out.println("Introduce el nombre del profesor: ");
	    String nombre = readString();
	    st.setString(1, nombre);
		//executeQuery retornara un resultSet
		ResultSet rs = st.executeQuery();
		presentaResultados(rs);
		
		//Muy importante, liberar todos los objetos relacionados con la base de datos
		rs.close();
		st.close();
		con.close();
	}
	
	private static Connection getConnection() throws SQLException{
		return  DriverManager.getConnection(STRING_CONEXION,USUARIO,PASSWORD);
	}
	
	/**
	 * Método para procesar el resultado de ResultSet
	 * @throws SQLException
	 */
	private static void presentaResultados(ResultSet rs) throws SQLException {
		int numeroColumnas = rs.getMetaData().getColumnCount();
		StringBuilder headers = new StringBuilder();
     
		for(int i = 1; i < numeroColumnas; i++)
			headers.append(rs.getMetaData().getColumnName(i) + "\t");
		headers.append(rs.getMetaData().getColumnName(numeroColumnas));
     
		System.out.println(headers.toString());
		StringBuilder result = null;
     
		while (rs.next()) {
			result = new StringBuilder();	
			for(int i = 1; i < numeroColumnas ; i++)
				result.append(rs.getObject(i) + "\t");
			result.append(rs.getObject(numeroColumnas));
			System.out.println(result.toString());
		}
     
		if(result == null) System.out.println("No hay datos");
	}
	
	@SuppressWarnings("resource")
	private static String readString(){
		return new Scanner(System.in).nextLine();		
	}
	
	@SuppressWarnings("resource")
	private static int readInt(){
		return new Scanner(System.in).nextInt();			
	}
}
