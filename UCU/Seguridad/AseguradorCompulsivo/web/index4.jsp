<%-- 
    Document   : index4
    Created on : Jun 29, 2019, 9:49:01 AM
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        
        
        
        
        <h1>El propio asegurador</h1>
        
        <form method="POST" action="ServletOperaciones">
            Número 1: <input type="text" name="txtNum1" id="idNum1" /> <br />
            Número 2: <input type="text" name="txtNum2" id="idNum2" /> <br />
            <input type="submit" name="btnSumar" value="Sumar" />
            <input type="submit" name="btnRestar" value="Restar" />
        </form>
    </body>
</html>
