<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="zh-CN">
  <head>
    <base href="<%=basePath%>">
    <meta charset="GB18030">
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

      <form class="form-signin" role="form" id="regForm">
        <h2 class="form-signin-heading"><i class="glyphicon glyphicon-log-in"></i> 用户注册</h2>
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="loginAcc"  name="loginAcc"  placeholder="请输入登录账号" autofocus>
			<span class="glyphicon glyphicon-user form-control-feedback"></span>
		  </div>
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="user_name"  name="user_name" placeholder="请输入用户名" autofocus>
			<span class="glyphicon glyphicon-user form-control-feedback"></span>
		  </div>
		  <div class="form-group has-success has-feedback">
			<input type="password" class="form-control" id="password"  name="password" placeholder="请输入登录密码" style="margin-top:10px;">
			<span class="glyphicon glyphicon-lock form-control-feedback"></span>
		  </div>
		  <div class="form-group has-success has-feedback">
			<input type="text" class="form-control" id="email"  name="email" placeholder="请输入邮箱地址" style="margin-top:10px;">
			<span class="glyphicon glyphicon glyphicon-envelope form-control-feedback"></span>
		  </div>
		  <div class="form-group has-success has-feedback">
			<select class="form-control" >
                <option>会员</option>
                <option>管理</option>
            </select>
		  </div>
        <div class="checkbox">
          <label>
            忘记密码
          </label>
          <label style="float:right">
            <a href="login/toLogin.do">我有账号</a>
          </label>
        </div>
        <a class="btn btn-lg btn-success btn-block" onclick="reg()" > 注册</a>
      </form>
    </div>
    <script src="jquery/jquery-2.1.1.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <script src="layer/layer.js" ></script>
    <script>
    	function reg(){
    		var loginAcc = $("#loginAcc").val();
    		if(loginAcc == ""){
        		layer.msg("用户名不能为空！",{time:1000,icon: 5,shift:6});
        		return;
        	}
    		var user_name = $("#user_name").val();
    		if(user_name == ""){
        		layer.msg("密码不能为空!",{time:1000,icon: 5,shift:6});
        		return;
        	}
    		var password = $("#password").val();
    		if(password == ""){
        		layer.msg("密码不能为空!",{time:1000,icon: 5,shift:6});
        		return;
        	}
    		var email = $("#email").val();
        	if(email == ""){
        		layer.msg("请输入正确的邮箱地址!",{time:1000,icon: 5,shift:6});
        		return;
        	}
        	alert($("#regForm").serialize());
        	var loadingIndex=null;
	        $.ajax({
	        	type:"POST",
	        	url:"login/reg.do",
	        	data:$("#regForm").serialize(),
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
        	
    	}
    </script>
  </body>
</html>