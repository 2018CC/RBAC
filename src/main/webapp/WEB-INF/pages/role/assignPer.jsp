<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="GB18030">
  <head>
  <!--角色分配许可  -->
    <base href="<%=basePath%>">
    <meta charset="GB18030">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

	<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="css/font-awesome.min.css">
	<link rel="stylesheet" href="css/main.css">
	<link rel="stylesheet" href="ztree/zTreeStyle.css">
	<style>
	.tree li {
        list-style-type: none;
		cursor:pointer;
	}
	table tbody tr:nth-child(odd){background:#F4F4F4;}
	table tbody td:nth-child(even){color:#C00;}
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
			<div class="panel panel-default">
			   <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 权限分配列表<div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
			  <div class="panel-body">
					<button class="btn btn-success" onclick="assignPer()">分配许可</button>
		                  <br><br>
					<ul id="permissionTree" class="ztree"></ul>

			  </div>
			</div>
        </div>
      </div>
    </div>

    <script src="jquery/jquery-2.1.1.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <script src="layer/layer.js" ></script>
    <script src="ztree/jquery.ztree.all-3.5.min.js" ></script>
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
            var setting = {
            		async:{
            			enable:true,
            			url:"permission/loadAssginPer.do?role_id=${param.id}",
            			outoParam:["id","name=n","level=lv"]
            		},
            		check:{
            			enable:true
            		},
            		view: {
						selectedMulti: false,
						addDiyDom: function(treeId, treeNode){
							var icoObj = $("#" + treeNode.tId + "_ico"); // tId = permissionTree_1, $("#permissionTree_1_ico")
							if ( treeNode.icon ) {
								icoObj.removeClass("button ico_docu ico_open").addClass(treeNode.icon).css("background","");
							}
						},
					},
					callback: {
						onClick : function(event, treeId, json) {

						}
					}
            		
            };

    		
        	$(document).ready(function(){
    			$.fn.zTree.init($("#permissionTree"), setting);
    		});
        	
        	function assignPer(){
        		var treeObj=$.fn.zTree.getZTreeObj("permissionTree");
        		var nodes = treeObj.getCheckedNodes(true);
        		if(nodes.length==0){
        			layer.msg("请选择需要分配的许可信息",{time:1000,icon:5,shift:6});
        		}else{
       				var d="role_id=${param.id}";
       				$.each(nodes,function(i,node){
       					d +="&permissionIds="+node.id;
       				});
        			$.ajax({
        				type:"POST",
        				url:"role/doAssignPer.do",
        				data:d,
        				success:function(data){
        					if(data.status=='200'){
     	           				layer.msg(data.msg,{time:1000,icon:6},function(){
     	           				window.location.href="role/index.do";
     	           				});
     	           			}else{
     	           				layer.msg(data.msg,{time:1000,icon:5});
     	           			}
        				}
        			});
        				
        		}
        	}
        	
        	
        	
        	
        </script>
  </body>
</html>
