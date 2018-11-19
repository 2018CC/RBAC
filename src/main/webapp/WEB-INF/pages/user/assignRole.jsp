<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="zh-CN">
  <head>
  <!--设置角色页面  -->
    <base href="<%=basePath%>">
    <meta charset="GB18030">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

	<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="css/font-awesome.min.css">
	<link rel="stylesheet" href="css/main.css">
	<link rel="stylesheet" href="css/doc.min.css">
	<style>
	.tree li {
        list-style-type: none;
		cursor:pointer;
	}
	</style>
  </head>

  <body>

    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <%@ include file="/WEB-INF/pages/common/top.jsp"%>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
			<div class="tree">
				<%@ include file="/WEB-INF/pages/common/menu.jsp"%>
			</div>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<ol class="breadcrumb">
				  <li><a href="#">首页</a></li>
				  <li><a href="#">数据列表</a></li>
				  <li class="active">分配角色</li>
				</ol>
			<div class="panel panel-default">
			  <div class="panel-body">
				<form role="form" id="roleForm" class="form-inline">
					<input type="hidden"  name="userId" value="${userId }">
				  <div class="form-group">
					<label for="exampleInputPassword1">未分配角色列表</label><br>
					<select id="leftRole" name="unAssginRoelIds" class="form-control" multiple size="10" style="width:200px;overflow-y:auto;">
                        <c:forEach items="${unassginRoles }" var="role">
                        	 <option value="${role.id }">${role.role_name }</option>
                        </c:forEach>
                    </select>
				  </div>
				  <div class="form-group">
                        <ul>
                            <li id="left2rightBtn" class="btn btn-default glyphicon glyphicon-chevron-right"></li>
                            <br>
                            <li id="right2leftBtn" class="btn btn-default glyphicon glyphicon-chevron-left" style="margin-top:20px;"></li>
                        </ul>
				  </div>
				  <div class="form-group" style="margin-left:40px;">
					<label for="exampleInputPassword1">已分配角色列表</label><br>
					<select id="rightRole" name="assginRoels" class="form-control" multiple size="10" style="width:200px;overflow-y:auto;">
                       <c:forEach items="${assginRoles }" var="role">
                        	 <option value="${role.id }">${role.role_name }</option>
                        </c:forEach>
                    </select>
				  </div>
				</form>
			  </div>
			</div>
        </div>
      </div>
    </div>
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
		<div class="modal-content">
		  <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
			<h4 class="modal-title" id="myModalLabel">帮助</h4>
		  </div>
		  <div class="modal-body">
			<div class="bs-callout bs-callout-info">
				<h4>测试标题1</h4>
				<p>测试内容1，测试内容1，测试内容1，测试内容1，测试内容1，测试内容1</p>
			  </div>
			<div class="bs-callout bs-callout-info">
				<h4>测试标题2</h4>
				<p>测试内容2，测试内容2，测试内容2，测试内容2，测试内容2，测试内容2</p>
			  </div>
		  </div>
		  <!--
		  <div class="modal-footer">
			<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			<button type="button" class="btn btn-primary">Save changes</button>
		  </div>
		  -->
		</div>
	  </div>
	</div>
    <script src="jquery/jquery-2.1.1.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <script src="layer/layer.js" ></script>
	<script src="script/docs.min.js"></script>
        <script type="text/javascript">
            $(function () {
			    $(".list-group-item").click(function(){
				    if ( $(this).find("ul") ) {
						$(this).toggleClass("tree-closed");
						if ( $(this).hasClass("tree-closed") ) {
							$("ul", this).hide("fast");
						} else {
							$("ul", this).show("fast");
						}
					}
				});
            });
            $("#left2rightBtn").click(function(){
            	var ops = $("#leftRole :selected");
            	if(ops.length==0){
            		layer.msg("请选择需要分配的角色",{time:1000,icon:5,shift:6});
            		return;
            	}else{
            		$.ajax({
            			type:"POST",
            			url:"user/assignRole.do",
            			data:$("#roleForm").serialize(),
            			success:function(data){
    	           			if(data.status=='200'){
    	           				$("#rightRole").append(ops);
    	           				layer.msg(data.msg,{time:1000,icon:6});
    	           				window.location.href="user/index.do";
    	           			}else{
    	           				layer.msg(data.msg,{time:1000,icon:5});
    	           			}
    	           		}
            		});
            	}
            });
 			$("#right2leftBtn").click(function(){
 				var ops = $("#rightRole :selected");
 				if(ops.length==0){
            		layer.msg("请选择需要取消的角色",{time:1000,icon:5,shift:6});
            		return;
            	}else{
            		$.ajax({
            			type:"POST",
            			url:"user/unAssignRole.do",
            			data:$("#roleForm").serialize(),
            			success:function(data){
    	           			if(data.status=='200'){
    	           				$("#leftRole").append(ops);
    	           				layer.msg(data.msg,{time:1000,icon:6});
    	           				window.location.href="user/index.do";
    	           			}else{
    	           				layer.msg(data.msg,{time:1000,icon:5});
    	           			}
    	           		}
            		});
            		
            	}
            });
        </script>
  </body>
</html>

