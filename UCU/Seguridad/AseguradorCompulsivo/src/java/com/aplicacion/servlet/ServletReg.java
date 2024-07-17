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
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ecozz
 */
@WebServlet(name = "ServletReg", urlPatterns = {"/ServletReg"})
public class ServletReg extends HttpServlet {

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
            out.println("<title>Servlet ServletReg</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ServletReg at " + request.getContextPath() + "</h1>");
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
        try {
            //processRequest(request, response);
            Boolean booleano = true;

            String usuario = request.getParameter("userR");
            String pass = request.getParameter("passR");
            String hashPass2 = EncriptacionYHasheo.hashing(pass);
            String comparador = request.getParameter("comp");
            
            String comprobacion = EncriptacionYHasheo.hashing(pass + usuario);
            
            if(!(comprobacion.equals(comparador))) {
                String var = "{\"res\": \"Datos Alterados!\"}";
                response.getWriter().write(var);
            }

            File root = new File(".");
            String otroAlgo = root.getAbsolutePath() + "//Archivos//archivo.txt";
            ArrayList<String> listaUsuarios = ManejadorArchivos.readFile(otroAlgo, false);

            if (listaUsuarios != null){
                for (int i = 0; i < listaUsuarios.size(); i++){
                    String[] user = listaUsuarios.get(i).split(",");

                    if(user[0].equals(usuario)){
                        booleano=false;
                        break;
                    }
                }
            }

            if (booleano) {
                String[] str = new String[1];
                String par = "\n" + usuario + "," + hashPass2;
                str[0] = par;
                ManejadorArchivos.writeFile(otroAlgo, str, true);
                String var = "{\"res\": \"ok\"}";
                response.getWriter().write(var);
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
        try {
            //processRequest(request, response);
            Boolean booleano = true;

            String usuario = request.getParameter("userR");
            String pass = request.getParameter("passR");

            String text = "some text";

            File root = new File(".");
            String otroAlgo = root.getAbsolutePath() + "//Archivos//archivo.txt";
            ArrayList<String> listaUsuarios = ManejadorArchivos.readFile(otroAlgo, false);

            if (listaUsuarios != null){
                for (int i = 0; i < listaUsuarios.size(); i++){
                    String[] user = listaUsuarios.get(i).split(",");

                    if(user[0].equals(usuario)){
                        booleano=false;
                        break;
                    }
                }
            }

            if (booleano) {
                String[] str = new String[1];
                String par = "\n" + usuario + "," + pass;
                str[0] = par;
                ManejadorArchivos.writeFile(otroAlgo, str, true);
                String var = "{\"res\": \"ok\"}";
                response.getWriter().write(var);
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
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
