package co.edu.umb.erp;

import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;
import java.io.IOException;
import java.io.OutputStream;

public class App {
    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);

        server.createContext("/", exchange -> {
            String respuesta = "Microservicio de Inventario corriendo en Docker";
            exchange.sendResponseHeaders(200, respuesta.getBytes().length);
            OutputStream os = exchange.getResponseBody();
            os.write(respuesta.getBytes());
            os.close();
        });

        server.setExecutor(null);
        server.start();
        System.out.println("Microservicio de Inventario escuchando en el puerto 8080...");
    }
}