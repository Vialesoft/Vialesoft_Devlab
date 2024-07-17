<%-- 
    Document   : index3
    Created on : Jun 18, 2019, 8:18:33 PM
    Author     : ecozz
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro de Usuario</title>
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
        
        body {
            background-image: url("wp3621404.jpg");
            background-color: #cccccc;
            background-repeat: no-repeat;
            background-size: cover; 
           }
    </style>
        
        
        <script>
            $(document).on("ready", function(){
                $("#buttonreg").on("click", function() { // 
                    var usuario = $("#txtNombreR").val();
                    var pass = $("#txtPassR").val();
                    var hasheado = sha512(pass);
                    
                    var comp = sha512(hasheado + usuario);

                    $.ajax({
                        type: "GET",
                        url: "ServletReg",
                        data: {userR:usuario, passR:hasheado, comp:comp},
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (msg, ret) {

                            if(msg.res == "ok"){
                                window.location="http://localhost:8084/AseguradorCompulsivo/index.jsp";
                            }
                            else if(msg.res == "nok") {
                                alert("Usuario ya existente");
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
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="#">Registro de Usuario</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>
          </nav>
        
        <div class="container login-container">
            <div class="row justify-content-md-center">
                <div class="col-md-6 col-offset-3 login-form-1" style=''>
                    <h3>Ingresar</h3>
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="Usuario" value="" name="txtNombreR" id="txtNombreR" />
                        </div>
                        <div class="form-group">
                            <input type="password" class="form-control" placeholder="Password" value=""  name="txtPassR" id="txtPassR" />
                        </div>
                        <div class="form-group">
                            <input type="submit" class="btnSubmit" value="Registro" id='buttonreg' />
                        </div>
                </div>
                
            </div>
        </div>
    </body>
</html>
