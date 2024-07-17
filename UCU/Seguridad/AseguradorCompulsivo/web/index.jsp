<%-- 
    Document   : index
    Created on : Jun 4, 2019, 8:25:33 PM
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Asegurador Compulsivo</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha512/0.8.0/sha512.min.js"></script>
    </head>
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

        <script>
            $(document).on("ready", function(){
                $("#somebutton").on("click", function() { // 
                    var usuario = $("#txtNombre").val();
                    var pass = $("#txtPass").val();
                    var hasheado = sha512(pass);
                    
                    var comp = sha512(hasheado + usuario);

                    $.ajax({
                        type: "GET",
                        url: "ServletOperaciones",
                        data: {user:usuario, pass:hasheado, comp:comp},
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (msg, ret) {

                            if (msg.res == "ok"){
                                window.location="http://localhost:8084/AseguradorCompulsivo/index2.jsp";
                            }
                            else if (msg.res == "nok") {
                                alert("Pass o usuario incorrectos");
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
                $("#buttonr").on("click", function() {
                    window.location="http://localhost:8084/AseguradorCompulsivo/index3.jsp"
                });
            });
            
        </script>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="#">Asegurador Compulsivo</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <!--<input type="submit" class="btnSubmit" value="Registrate" id='buttonr' />-->
                  <a class="nav-link" href="index3.jsp">Registro <span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item active">
                  <a class="nav-link" href="index4.jsp">Calculadora <span class="sr-only">(current)</span></a>
                </li>
              </ul>
                <!--
                <li class="nav-item dropdown">
                  <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Dropdown
                  </a>
                  <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="#">Action</a>
                    <a class="dropdown-item" href="#">Another action</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="#">Something else here</a>
                  </div>
                </li>
                <li class="nav-item">
                  <a class="nav-link disabled" href="#">Disabled</a>
                </li>
              </ul>
              <form class="form-inline my-2 my-lg-0">
                <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
              </form>-->
            </div>
          </nav>
        
        <div class="container login-container">
            <div class="row justify-content-md-center">
                <div class="col-md-6 col-offset-3 login-form-1" style=''>
                    <h3>Ingresar</h3>
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="Usuario" value="" name="txtNombre" id="txtNombre" />
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-control" placeholder="Password" value=""  name="txtPass" id="txtPass" />
                        </div>
                        <div class="form-group">
                            <input type="submit" class="btnSubmit" value="Login" id='somebutton' />
                        </div>
                </div>
                
                <!--
                Usuario: <input type="text" name="txtNombre" id="txtNombre" /> <br />
            Password (Negro Version): <input type="text" name="txtPass" id="txtPass" /> <br />
                
            
            <button id="somebutton">HOLA, soy un botón</button> <br />
            <button id="buttonr">Registrate</button>
            <div id="somediv"></div>
                -->
                
            </div>
        </div>
    </body>
</html>
