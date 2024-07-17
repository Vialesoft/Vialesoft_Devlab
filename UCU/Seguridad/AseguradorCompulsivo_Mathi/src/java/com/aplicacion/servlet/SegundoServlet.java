/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.aplicacion.servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.nio.file.Paths;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

import static org.apache.tomcat.util.codec.binary.Base64.decodeBase64;

/**
 *
 * @author user
 */
@WebServlet("/upload")
@MultipartConfig
public class SegundoServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SegundoServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SegundoServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String base64 = request.getParameter("base64");
        String nombre = request.getParameter("nombre");
        String tipo = request.getParameter("tipo");
        String tamano = request.getParameter("tamano");
        
        File root = new File(".");
        String path = root.getAbsolutePath();
        
        byte[] enc = decodeBase64(base64);
        try (OutputStream stream = new FileOutputStream(path + "//" + nombre)) {
            stream.write(enc);
        }
        
        String var = "{\"res\": \"LALA\"}";
        response.getWriter().write(var);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String btnEncriptar = request.getParameter("btnEncriptar");
        String btnDesencriptar = request.getParameter("btnDesencriptar");
        
        Boolean encriptar = false;
        Part archivo = null;
        InputStream contenido = null;
        String pass = null;
        
        if(!(btnEncriptar == null)) { //El pibito está encriptando
            encriptar = true;
            try {
                pass = EncriptacionYHasheo.EncriptacionYHasheo.md5(request.getParameter("txtPassEnc"));
            } catch (NoSuchAlgorithmException ex) {
                Logger.getLogger(SegundoServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            archivo = request.getPart("fsEncriptar"); // Retrieves <input type="file" name="uploadedFile">
            
        } else {
            try {
                pass = EncriptacionYHasheo.EncriptacionYHasheo.md5(request.getParameter("txtPassDec"));
            } catch (NoSuchAlgorithmException ex) {
                Logger.getLogger(SegundoServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            archivo = request.getPart("fsDesencriptar"); // Retrieves <input type="file" name="uploadedFile">
            
        }
        
        pass = pass.substring(0, 16);
        
        contenido = archivo.getInputStream();
        String nombreArchivo = Paths.get(archivo.getSubmittedFileName()).getFileName().toString();
        
            int read = 0;
            byte[] bytes = new byte[1024];
            byte[] bytesProcesados = new byte[1024];
            
            File root = new File(".");
            String rutaFinalArchivo = root.getAbsolutePath() + "//Archivos//" + nombreArchivo;
            //String nombreArchivoTemp = "Prueba" + System.currentTimeMillis();

            bytes = org.apache.commons.io.IOUtils.toByteArray(contenido);
            
            if(encriptar) {
                rutaFinalArchivo += ".enc";
            }
            else {
                rutaFinalArchivo = rutaFinalArchivo.split(".enc")[0];
            }
            
            OutputStream out = new FileOutputStream(new File(rutaFinalArchivo));
            
            /*while ((read = contenido.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }*/
            
            try {
                if (encriptar) {
                    //String unString = new String(encodeBase64(bytes));
                    //String enc = EncriptacionYHasheo.EncriptacionYHasheo.encrypt("0123456789ABCDEF", "92AE31A79FEEB2A3", unString);

                    bytesProcesados = EncriptacionYHasheo.EncriptacionYHasheo.encrypt(pass, bytes);
                    
                    //bytesProcesados = new byte[(int) enc.length()];
                } else {
                    //String unString = new String(encodeBase64(bytes));
                    //String enc = EncriptacionYHasheo.EncriptacionYHasheo.decrypt("0123456789ABCDEF", "92AE31A79FEEB2A3", unString);
                    
                    
                    bytesProcesados = EncriptacionYHasheo.EncriptacionYHasheo.decrypt(pass, bytes);

                    //bytesProcesados = new byte[(int) enc.length()];
                }
            }
            catch (Exception ex) {
                String hola = "LA CONCHA DWE TU HERMANA";
            }
            
            out.write(bytesProcesados);
            out.close();
            
            response.sendRedirect("index2.jsp");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
