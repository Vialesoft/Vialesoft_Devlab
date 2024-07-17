/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.aplicacion.servlet;

import EncriptacionYHasheo.EncriptacionYHasheo;
import Manejador.Archivos.ManejadorArchivos;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author user
 */
@WebServlet(name = "ServletOperaciones", urlPatterns = {"/ServletOperaciones"})
public class MiServlet extends HttpServlet {

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
            out.println("<title>Servlet MiServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MiServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            out.close();
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
        try {
            //processRequest(request, response);
            Boolean booleano = false;
            String dobleHash = request.getParameter("comp");

            String usuario = request.getParameter("user");
            String pass = request.getParameter("pass");

            String comprobacion = EncriptacionYHasheo.hashing(pass + usuario);
            String hashPass2 = EncriptacionYHasheo.hashing(pass);
            
            if(!(comprobacion.equals(dobleHash))) {
                String var = "{\"res\": \"No Válido\"}";
                response.getWriter().write(var);
                
                return;
            }

            String text = "some text";

            File root = new File(".");
            String otroAlgo = root.getAbsolutePath() + "//Archivos//archivo.txt";
            ArrayList<String> listaUsuarios = ManejadorArchivos.readFile(otroAlgo, false);

            if (listaUsuarios != null){
                for (int i = 0; i < listaUsuarios.size(); i++){
                    String[] user = listaUsuarios.get(i).split(",");

                    if(user[0].equals(usuario)){
                        if(user[1].equals(hashPass2)){
                            booleano = true;
                        }

                        break;
                    }
                }
            }

            if (booleano) {
                String var = "{\"res\": \"ok\"}";
                response.getWriter().write(var);
                
                HttpSession misession = request.getSession(true);
                misession.setAttribute("usuario", usuario);
            }
            else {
                String var = "{\"res\": \"nok\"}";
                response.getWriter().write(var);
            }
        }
        catch (Exception ex){
            String var = "{\"res\": \"Roto\"}";
            response.getWriter().write(var);
        }
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
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MiServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            
            
            EncriptacionYHasheo.generarParDeClaves();
            
            String num1 = request.getParameter("txtNum1"); //Atributo Name
            String num2 = request.getParameter("txtNum2"); //Atributo Name
            String btnSuma = request.getParameter("btnSumar");
            String btnResta = request.getParameter("btnRestar");

            int resultado = 0;
            
            if(btnSuma != null){
                resultado = Integer.parseInt(num1) + Integer.parseInt(num2);
            }
            
            if(btnResta != null){
                resultado = Integer.parseInt(num1) - Integer.parseInt(num2);
            }
            
            out.println("El resultado es: " + resultado);
            
            out.println("<h1>Servlet MiServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            out.close();
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
