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
import javax.servlet.RequestDispatcher;

import static org.apache.tomcat.util.codec.binary.Base64.decodeBase64;

/**
 *
 * @author user
 */
@WebServlet(name = "FirmarServlet", urlPatterns = {"/FirmarServlet"})
@MultipartConfig
public class FirmarServlet extends HttpServlet {

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
            out.println("<title>Servlet FirmarServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FirmarServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
            try {
                //String publicoooo = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCp1A+5l73eTM2mo11r+2jT1OlCDlok9j4lYUyHvK3nM8N9guiKlNuMiU91nnzXyyL3O7U72Yxf+DUmHqaFuMLigkOAJXBawMV/cjmTsPpqbUesM/j6MkAWizv5X7mW8/TUjJzAnwi4ms7yXcBxE4utQIIGrzf8WridT1pMIC/vnwIDAQAB";
                String privadoooo = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKnUD7mXvd5MzaajXWv7aNPU6UIOWiT2PiVhTIe8reczw32C6IqU24yJT3WefNfLIvc7tTvZjF/4NSYepoW4wuKCQ4AlcFrAxX9yOZOw+mptR6wz+PoyQBaLO/lfuZbz9NSMnMCfCLiazvJdwHETi61AggavN/xauJ1PWkwgL++fAgMBAAECgYBadVYa6TR9IDO6OvIb/kIL8zB7uuFRJshbaMQ22M1YhT3vsLbkef2nkcv9PnoJB26MegVC59HZnH/S2iiguZUz56u9Evuv3oxU9hU8PwfA5QXlJpkZ1DC1Nz5c2uzXFEg0/qoCjnd2XBSEQhOkWRdWH4Pb+B5A+jzwHy8SnrXGQQJBAPmbLA/9AfskZTR6RnQ9YZQ2t6eIpOHIOyh9ujil+YPKwnfoBXvgHBSn7U5HLszD6Hq4eGNkZGkrSknyABolACkCQQCuLbwzTqh07ec2Ey46oFihoiTUQwm9ZaFN47wx8ntfcvT10wY6wgYDavwYL8nEGTxRbuMwjwgGsCByrvMvuUqHAkAFWtzhIu5t8uPw8kacq8xyH5JlF7th1KfgQIJEQNtPhoQRinrDo5U2pDulGEXawsE0EM0UZMz6rKEVYQm7hduxAkEAklzuO/MKDY/obYE6pJsfP1uANTnMEnI3VLtc5l/Lmk6AV52nK3LlGLQq+KwXkQhfrlJO6PwYE36nFZe71MuQOwJAHREXFvlFW46sYjlvo8hAIq8z8Kn1ZP8hWJJsXqPd7xTWPet6zrEo71mGqH5cubKqEyXylptrDkj9Jn5P/Fhh4Q==";

                Part archivo = request.getPart("fsFirmar"); // Retrieves <input type="file" name="uploadedFile">
                InputStream contenido = archivo.getInputStream();
                
                Part clavePrivada = request.getPart("fsPrivada"); // Retrieves <input type="file" name="uploadedFile">
                InputStream contenidoClavePrivada = clavePrivada.getInputStream();
                
                String nombreArchivo = Paths.get(archivo.getSubmittedFileName()).getFileName().toString();
        
                int read = 0;
                byte[] bytes = new byte[1024];
                byte[] bytesFirmados = new byte[1024];
                byte[] bytesClavePrivada = new byte[1024];

                File root = new File(".");
                String rutaFinalArchivo = root.getAbsolutePath() + "//Archivos//" + nombreArchivo;
                bytes = org.apache.commons.io.IOUtils.toByteArray(contenido);
                bytesClavePrivada = org.apache.commons.io.IOUtils.toByteArray(contenidoClavePrivada);
                
                OutputStream outOriginal = new FileOutputStream(new File(rutaFinalArchivo));
                OutputStream outFirma = new FileOutputStream(new File(rutaFinalArchivo + "_FIRMA_"));
                
                bytesFirmados = EncriptacionYHasheo.EncriptacionYHasheo.signFile(bytes, bytesClavePrivada);

                outFirma.write(bytesFirmados);
                outFirma.close();

                outOriginal.write(bytes);
                outOriginal.close();
                
                PrintWriter pw = response.getWriter();
                pw.println("<script type=\"text/javascript\">");
                pw.println("alert('Firma correcta!');");
                pw.println("</script>");
                RequestDispatcher rd = request.getRequestDispatcher("index2.jsp");
                rd.include(request, response);

                //response.sendRedirect("index2.jsp");
            }
            catch (Exception ex) {
                String lala = "";
            }
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
