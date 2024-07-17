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
import java.nio.file.Paths;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author user
 */
@WebServlet(name = "VerificarServlet", urlPatterns = {"/VerificarServlet"})
@MultipartConfig
public class VerificarServlet extends HttpServlet {

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
            out.println("<title>Servlet VerificarServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VerificarServlet at " + request.getContextPath() + "</h1>");
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
                String publicoooo = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCp1A+5l73eTM2mo11r+2jT1OlCDlok9j4lYUyHvK3nM8N9guiKlNuMiU91nnzXyyL3O7U72Yxf+DUmHqaFuMLigkOAJXBawMV/cjmTsPpqbUesM/j6MkAWizv5X7mW8/TUjJzAnwi4ms7yXcBxE4utQIIGrzf8WridT1pMIC/vnwIDAQAB";

                Part archivo = request.getPart("fsArchivo");
                Part firmita = request.getPart("fsFirma");
                Part clavePublica = request.getPart("fsPublica");
                InputStream contenidoClavePublica = clavePublica.getInputStream();
                
                InputStream contenido = archivo.getInputStream();
                InputStream contFirmita = firmita.getInputStream();

                String nombreArchivo = Paths.get(archivo.getSubmittedFileName()).getFileName().toString();
                String nombreFirma = Paths.get(firmita.getSubmittedFileName()).getFileName().toString();
        
                byte[] bytes = new byte[1024];
                byte[] bytesFirmita = new byte[1024];
                byte[] bytesClavePublica = new byte[1024];
                
                bytes = org.apache.commons.io.IOUtils.toByteArray(contenido);
                bytesFirmita = org.apache.commons.io.IOUtils.toByteArray(contFirmita);
                bytesClavePublica = org.apache.commons.io.IOUtils.toByteArray(contenidoClavePublica);
                
                boolean validaFirma = EncriptacionYHasheo.EncriptacionYHasheo.verificarFirma(bytesFirmita, bytesClavePublica, bytes);
                
                PrintWriter pw = response.getWriter();
                pw.println("<script type=\"text/javascript\">");
                
                if(validaFirma){
                    pw.println("alert('Firma correcta!');");
                } else {
                    pw.println("alert('Atención: ¡¡Firma incorrecta!!');");
                }
                
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
