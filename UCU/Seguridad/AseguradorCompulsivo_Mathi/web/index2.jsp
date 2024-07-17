<%-- 
    Document   : index2.jsp
    Created on : Jun 11, 2019, 7:14:45 PM
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Encriptacion y firma digital</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha512/0.8.0/sha512.min.js"></script>
    </head>
        <script>
            
            $(document).on("ready", function () {
                $.ajax({
                    type: "GET",
                    url: "ServletOutSession",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg, ret) {
                        if (msg.res == "nok"){
                            window.location="http://localhost:8084/AseguradorCompulsivo_Mathi/index.jsp";
                        }
                        else if (msg.res == "ok") {
                            //alert("Hay usuario logueado! :D");
                        }
                        else {
                            alert(msg.res);
                        }
                    },
                    error: function (xhr, status, error) {
                        alert(error);
                        console.log(xhr);
                        alert(status);
                    }
                });
            });
            
        </script>
        
        <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="#">Encriptacion y firma digital</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>
    <body>
        <h1>Encriptacion y firma digital</h1>
        <form action="ServletOutSession" method="post" enctype="multipart/form-data">
            <input type="submit" name="btnSalir" value="Salir..." />
        </form>
        
        <form action="SegundoServlet" method="post" enctype="multipart/form-data">
            <table>
                <tr>
                    <td>
                        Encriptar:
                    </td>
                    <td>
                        <input type="file" name="fsEncriptar" />
                    </td>
                    <td>
                        Clave:
                    </td>
                    <td>
                        <input type="text" name="txtPassEnc" />
                    </td>
                    <td>
                        <input type="submit" name="btnEncriptar" value="Encriptar" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Desencriptar:
                    </td>
                    <td>
                        <input type="file" name="fsDesencriptar" />
                    </td>
                    <td>
                        Clave:
                    </td>
                    <td>
                        <input type="text" name="txtPassDec" />
                    </td>
                    <td>
                        <input type="submit" name="btnDesencriptar" value="Desencriptar" />
                    </td>
                </tr>
            </table>
            
        </form>
        
        <br />
        
        <form action="FirmarServlet" method="post" enctype="multipart/form-data">
            <table>
                <tr>
                    <td>
                        Archivo:
                    </td>
                    <td>
                        <input type="file" name="fsFirmar" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Clave Privada:
                    </td>
                    <td>
                        <input type="file" name="fsPrivada" />
                    </td>
                </tr>
                 <tr>
                    <td>
                        Firmar:
                    </td>
                    <td>
                        <input type="submit" name="btnFirmar" value="Firmar" />
                    </td>
                </tr>
            </table>
        </form>
        
        <br />
        
        <form action="VerificarServlet" method="post" enctype="multipart/form-data">
            <table>
                <tr>
                    <td>
                        Archivo:
                    </td>
                    <td>
                        <input type="file" name="fsArchivo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Firma:
                    </td>
                    <td>
                        <input type="file" name="fsFirma" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Clave Pública:
                    </td>
                    <td>
                        <input type="file" name="fsPublica" />
                    </td>
                </tr>
                <tr>
                    <td>
                        
                    </td>
                    <td>
                        <input type="submit" name="btnVerificar" value="Verificar" />
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
