
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;
import static java.lang.System.out;

public class SesionJDBC {

	private static String USUARIO = "JuanMier";
	private static String PASSWORD = "test";  
	private static String NOMBRE_BASEDATOS = "universidad";
	private static String STRING_CONEXION = "jdbc:postgresql://localhost:5432/" + NOMBRE_BASEDATOS;
	
	public static void main(String[] args) {
		try {
			ejemplo31();
			//ejemplo32();
			ejemplo33();
			//ejemplo34();
			prueba();
		} catch (SQLException e) {e.printStackTrace();}
	}

	private static void prueba() throws SQLException {
		out.println("Prueba");
		out.print("Introduzca el ID de estudiante: ");
		Connection con = getConnection();
		Statement st = con.createStatement();
		int rs = st.executeUpdate(
			"update estudiante set estudiante_apellidos='Palacio Gomez'" +
			"where estudiante_id = " + readInt()
		);
		out.printf("Se han actaulizado %d tuplas%n", rs);
		st.close();
		con.close();
	}

	/**
	 * Método que presenta el nombre de aquellos grados que no impartan la asignatura introducida. <p>
	 * Case-insensitive.
	 * @param modulo Asignatura a examinar.
	 * @throws SQLException
	 */
	private static void genericFirstAndSecond(final String modulo) throws SQLException {
		Connection con = getConnection();
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(
			"select g1.grado_nombre from grado g1 " +
			"where not exists " +
			"(select distinct g2.grado_nombre from grado g2 " +
			"inner join grado_modulo gm using(grado_id) " +
			"inner join modulo m using(modulo_id) " +
			"where lower(m.modulo_nombre) = '" + modulo.toLowerCase() + "' " +
			"and g1.grado_id = g2.grado_id)"
		);
		presentaResultados(rs);
		rs.close();
		st.close();
		con.close();
	}

	/**
	 * Ejercicio 3.1.
	 * Presentar el nombre de aquellos grados que no impartan la asignatura de 'Fundamentos de Informática'.
	 * @throws SQLException
	 */
	private static void ejemplo31() throws SQLException {
		out.println("Ejercicio 3.1");
		genericFirstAndSecond("Fundamentos de Informatica");
	}

	/**
	 * Ejercicio 3.2.
	 * Realizar el ejercicio 3.1, pero el nombre del módulo debe ser introducido por entrada
	 * estándar.
	 * @throws SQLException
	 */
	private static void ejemplo32() throws SQLException {
		out.println("Ejercicio 3.2");
		out.print("Introduzca el nombre del módulo: ");
		genericFirstAndSecond(readString());
	}

	/**
	 * Ejercicio 3.3
	 * Presentar los nombres y apellidos de aquellos estudiantes matriculados en el grado
	 * 'Ingenieria Informatica de tecnologias de la informacion' pero que no estén cursando
	 * 'Estructuras de Datos'.
	 * @throws SQLException
	 */
	private static void ejemplo33() throws SQLException {
		out.println("Ejercicio 3.3");
		genericThridAndFourth("Ingenieria Informatica en Tecnologias de la Informacion", "Estructuras de Datos");
	}

	/**
	 * Ejercicio 3.4
	 * Igual que el ejercicio anterior, pero obteniendo el grado y el módulo por entrada estándar.
	 * @throws SQLException
	 */
	private static void ejemplo34() throws SQLException {
		out.println("Ejercicio 3.4");
		out.print("Introduzca el nombre del grado: ");
		String grado = readString();
		out.print("Introduzca el nombre del módulo: ");
		String modulo = readString();
		genericThridAndFourth(grado, modulo);
	}

	/**
	 * Método genérico que presenta los nombres y apellidos de aquellos estudiantes matriculados
	 * en el grado introducido que no estén cursando el módulo introducido. <p>
	 * Case-insensitive.
	 * @param grado Grado a examinar.
	 * @param modulo Módulo a examinar.
	 * @throws SQLException
	 */
	private static void genericThridAndFourth(final String grado, final String modulo) throws SQLException {
		Connection con = getConnection();
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(
			"select distinct estudiante_nombre, estudiante_apellidos from estudiante est " + 
			"inner join estudiante_grado_modulo egm using(estudiante_id) " +
			"inner join grado g using (grado_id) " +
			"where lower(g.grado_nombre) = '"+ grado.toLowerCase() + "' " +
			"and estudiante_id not in " +
			"(select estudiante_id from estudiante est " +
			"inner join estudiante_grado_modulo egm using(estudiante_id) " +
			"inner join modulo m using(modulo_id) " +
			"where lower(modulo_nombre) = '"+ modulo.toLowerCase() + "')"
		);
		presentaResultados(rs);
		rs.close();
		st.close();
		con.close();
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
	
	private static String readString() {
		try(Scanner sc = new Scanner(System.in)) {
			return sc.nextLine();
		}
	}
	
	private static int readInt(){
		try(Scanner sc = new Scanner(System.in)) {
			return sc.nextInt();
		}
	}
}
