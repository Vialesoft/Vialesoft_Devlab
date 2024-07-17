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
        <title>Asegurador</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha512/0.8.0/sha512.min.js"></script>
        
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
        
        <script>
            $(document).on("ready", function () {
                $.ajax({
                    type: "GET",
                    url: "ServletOutSession",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg, ret) {
                        if (msg.res == "nok"){
                            window.location="http://localhost:8084/AseguradorCompulsivo/index.jsp";
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
                
                $("#btnGenerarClaves").on("click", function() {
                    $.ajax({
                    type: "GET",
                    url: "ServletGenerarClaves",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg, ret) {
                        if (msg.res == "nok") {
                            window.location="http://localhost:8084/AseguradorCompulsivo/index.jsp";
                        }
                        else if (msg.res == "ok") {
                            alert("Claves generadas con éxito!");
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
            });
        </script>
        
        <style>
            .login-container{
                margin-top: 5%;
                margin-bottom: 5%;
            }
            .login-logo{
                position: relative;
                margin-left: -41.5%;
            }
            .login-logo img{
                position: absolute;
                width: 20%;
                margin-top: 19%;
                background: #282726;
                border-radius: 4.5rem;
                padding: 5%;
            }
            .login-form-1{
                padding: 9%;
                background:#282726;
                box-shadow: 0 5px 8px 0 rgba(0, 0, 0, 0.2), 0 9px 26px 0 rgba(0, 0, 0, 0.19);
                opacity: 0.8;
            }
            .login-form-1 h3{
                text-align: center;
                margin-bottom:12%;
                color:#fff;
            }
            .login-form-2{
                padding: 9%;
                background: #f05837;
                box-shadow: 0 5px 8px 0 rgba(0, 0, 0, 0.2), 0 9px 26px 0 rgba(0, 0, 0, 0.19);
            }
            .login-form-2 h3{
                text-align: center;
                margin-bottom:12%;
                color: #fff;
            }
            .btnSubmit{
                font-weight: 600;
                width: 50%;
                color: #282726;
                background-color: #fff;
                border: none;
                border-radius: 1.5rem;
                padding:2%;
            }
            .btnForgetPwd{
                color: #fff;
                font-weight: 600;
                text-decoration: none;
            }
            .btnForgetPwd:hover{
                text-decoration:none;
                color:#fff;
            }

            body {
                background-image: url("1366_2000.jpeg");
                background-color: #cccccc;
                background-repeat: no-repeat;
                background-size: cover; 
               }
        </style>
        
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="#">Asegurador Compulsivo</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                  <a class="nav-link" href="index4.jsp">Calculadora <span class="sr-only">(current)</span></a>
                </li>
              </ul>
                
                <form action="ServletGenerarClaves" method="post" enctype="multipart/form-data" class="form-inline my-2 my-lg-0">
                    <input class="btn btn-outline-success my-2 my-sm-0" id="btnGenerarClaves" value="Generar Par de Claves" />
                </form>
                <form action="ServletOutSession" method="post" enctype="multipart/form-data" class="form-inline my-2 my-lg-0">
                    <input class="btn btn-outline-success my-2 my-sm-0" type="submit" value="Salir..." />
                </form>
            </div>
          </nav>
        <br />
        <div class="container">
            <form action="SegundoServlet" method="post" enctype="multipart/form-data">
                <div class="row justify-content-md-center">
                    <div class="col-md-10">
                        <div class="jumbotron" style="opacity: 0.8;">
                          <h1 class="display-4">Cifrado</h1>
                          <hr class="my-4">
                          <div class="row">
                              <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text">Cifrar</span>
                                </div>
                                <div class="custom-file">
                                  <input type="file" class="custom-file-input" name="fsEncriptar" id="fsEncriptar">
                                  <label class="custom-file-label" for="inputGroupFile01">Elegir Archivo...</label>
                                </div>
                              </div>
                              
                              <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text" id="basic-addon3">Clave</span>
                                </div>
                                <input type="text" class="form-control" id="basic-url" name="txtPassEnc" aria-describedby="basic-addon3">
                              </div>
                              
                              <input type="submit" class="btn btn-primary btn-lg btn-block" name="btnEncriptar" value="Cifrar" />
                              
                          </div>
                          
                          <hr />
                          
                          <div class="row">
                              <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text">Descifrar</span>
                                </div>
                                <div class="custom-file">
                                  <input type="file" class="custom-file-input" name="fsDesencriptar" id="fsEncriptar">
                                  <label class="custom-file-label" for="inputGroupFile01">Elegir Archivo...</label>
                                </div>
                              </div>
                              
                              <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text" id="basic-addon3">Clave</span>
                                </div>
                                <input type="text" class="form-control" id="basic-url" name="txtPassDec" aria-describedby="basic-addon3">
                              </div>
                              
                              <input type="submit" class="btn btn-primary btn-lg btn-block" name="btnDesencriptar" value="Descifrar" />
                          </div>
                        </div>
                        
                    </div>
                </div>
            </form>
            
            <hr />
            
            <form action="FirmarServlet" method="post" enctype="multipart/form-data">
                <div class="row justify-content-md-center">
                    <div class="col-md-10">
                        <div class="jumbotron" style="opacity: 0.8;">
                          <h1 class="display-4">Firma</h1>
                          <hr class="my-4">
                          <div class="row">
                              <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text">Firmar</span>
                                </div>
                                <div class="custom-file">
                                  <input type="file" class="custom-file-input" name="fsFirmar" id="fsFirmar">
                                  <label class="custom-file-label" for="inputGroupFile01">Elegir Archivo...</label>
                                </div>
                              </div>
                              
                              <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text">Clave Privada</span>
                                </div>
                                <div class="custom-file">
                                  <input type="file" class="custom-file-input" name="fsPrivada" accept=".priv" id="fsPrivada">
                                  <label class="custom-file-label" for="inputGroupFile01">Elegir Archivo...</label>
                                </div>
                              </div>
                              
                              <input type="submit" class="btn btn-primary btn-lg btn-block" name="btnFirmar" value="Firmar" />
                              
                          </div>    
                        </div>
                        
                    </div>
                </div>
            </form>
            
            <form action="VerificarServlet" method="post" enctype="multipart/form-data">
                <div class="row justify-content-md-center">
                    <div class="col-md-10">
                        <div class="jumbotron" style="opacity: 0.8;">
                          <h1 class="display-4">Verificar Firma</h1>
                          <hr class="my-4">
                          <div class="row">
                              <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text">Archivo firmado</span>
                                </div>
                                <div class="custom-file">
                                  <input type="file" class="custom-file-input" name="fsArchivo" id="fsArchivo">
                                  <label class="custom-file-label" for="inputGroupFile01">Elegir Archivo...</label>
                                </div>
                              </div>
                              
                              <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text">Firma</span>
                                </div>
                                <div class="custom-file">
                                  <input type="file" class="custom-file-input" name="fsFirma" id="fsFirma">
                                  <label class="custom-file-label" for="inputGroupFile01">Elegir Archivo...</label>
                                </div>
                              </div>
                              
                              <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                  <span class="input-group-text">Clave Pública</span>
                                </div>
                                <div class="custom-file">
                                  <input type="file" class="custom-file-input" accept=".pub" name="fsPublica" id="fsPublica">
                                  <label class="custom-file-label" for="inputGroupFile01">Elegir Archivo...</label>
                                </div>
                              </div>
                              
                              <input type="submit" class="btn btn-primary btn-lg btn-block" name="btnVerificar" value="Verificar" />
                              
                          </div>
                        </div>
                        
                    </div>
                </div>
            </form>
        </div>
        
        <br />
        
        <!--
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
        </form> -->
    </body>
</html>
