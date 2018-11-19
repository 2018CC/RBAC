<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<html lang="zh-CN">
  <head>
	<base href="<%=basePath%>">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="keys" content="">
    <meta name="author" content="">
	<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="css/font-awesome.min.css">
	<link rel="stylesheet" href="css/login.css">
	<style>

	</style>
  </head>
  <body>
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <div><a class="navbar-brand" href="index.html" style="font-size:32px;">尚筹网-创意产品众筹平台</a></div>
        </div>
      </div>
    </nav>

    <div class="container">

      <form class="form-signin" role="form" id="loginForm">
        <p style="color: red">${param.errorMsg}</p>
        <h2 class="form-signin-heading"><i class="glyphicon glyphicon-user"></i> 用户登录</h2>
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="loginAcc" name="loginAcc" placeholder="请输入登录账号" autofocus>
			<span class="glyphicon glyphicon-user form-control-feedback"></span>
		  </div>
		  <div class="form-group has-success has-feedback">
			<input type="password" class="form-control" id="password" name="password" placeholder="请输入登录密码" style="margin-top:10px;">
			<span class="glyphicon glyphicon-lock form-control-feedback"></span>
		  </div>
		  <div class="form-group has-success has-feedback">
			<select class="form-control" name="type">
                <option value="member">会员</option>
                <option value="user">管理</option>
            </select>
		  </div>
        <div class="checkbox">
          <label>
            <input type="checkbox" value="remember-me"> 记住我
          </label>
          <br>
          <label>
            忘记密码
          </label>
          <label style="float:right">
            <a href="login/toReg.do">我要注册</a>
          </label>
        </div>
        <a class="btn btn-lg btn-success btn-block" onclick="dologin()">登录</a>
        
      </form>
    </div>
    <script src="jquery/jquery-2.1.1.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
 	<script src="layer/layer.js" ></script>
    <script>
    function dologin(){
    	var loginAcc = $("#loginAcc").val();
    	if(loginAcc == ""){
    		layer.msg("用户名不能为空！",{time:1000,icon: 5,shift:6});
    		return;
    	}
    	var userpswd = $("#password").val();
    	if(userpswd == ""){
    		layer.msg("密码不能为空!",{time:1000,icon: 5,shift:6});
    		return;
    	}
    	var loadingIndex=null;
    	$.ajax({
    		type:"POST",
    		url:"login/doLogin.do",
    		data:{"loginAcc":loginAcc,"password":userpswd},
    		beforeSend:function(){
    			loadingIndex=layer.msg("响应中",{icon:16})
    		},
    		success:function(data){
    			layer.close(loadingIndex);
    			if(data.status=='200'){
    				layer.msg(data.msg,{time:1000,icon:6});
    				window.location.href="login/main.do";
    			}else{
    				layer.msg(data.msg,{time:1000,icon:5});
    			}
    		}
    		
    	}); 
       // var type = $(":selected").val();
       
    }
    </script>
    
  </body>
</html>