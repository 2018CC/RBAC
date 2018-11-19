<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="GB18030">
  <head>
  <!--用户列表页面  -->
    <base href="<%=basePath%>">
    <meta charset="GB18030">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

	<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="css/font-awesome.min.css">
	<link rel="stylesheet" href="css/main.css">
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
			  <div class="panel-heading">
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
			  </div>
			  <div class="panel-body">
<form class="form-inline" role="form" style="float:left;">
  <div class="form-group has-feedback">
    <div class="input-group">
      <div class="input-group-addon">查询条件</div>
      <input class="form-control has-success" type="text" id="querytext" placeholder="请输入查询条件">
    </div>
  </div>
  <button type="button" id="searchbtn" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
</form>
<button type="button" class="btn btn-danger" style="float:right;margin-left:10px;"onclick="delUsers()"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
<button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='user/toAdd.do'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
<br>
 <hr style="clear:both;">
          <div class="table-responsive">
            <form id="userForm">
	            <table class="table  table-bordered">
	              <thead>
	                <tr >
	                  <th width="30">#</th>
					  <th width="30"><input type="checkbox" id="checkAll"></th>
	                  <th>账号</th>
	                  <th>名称</th>
	                  <th>邮箱地址</th>
	                  <th width="100">操作</th>
	                </tr>
	              </thead>
		              <tbody id="userdata"></tbody>
				  <tfoot>
				     <tr>
					     <td colspan="6" align="center">
							<ul class="pagination">
							</ul>
						 </td>
					 </tr>
				  </tfoot>
	            </table>
            </form>
          </div>
			  </div>
			</div>
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
            pageQuery(1);
            $("tbody .btn-success").click(function(){
                window.location.href = "assignRole.html";
            });
            $("tbody .btn-primary").click(function(){
                window.location.href = "edit.html";
            });
            
            $("#searchbtn").click(function(){
            	pageQuery(1);
            });
            //异步查询分页
           function  pageQuery(pageno){
           	var loadingIndex=null;
           	var querytext =$("#querytext").val();
           	$.ajax({
           		type:"POST",
           		url:"user/pagequery.do",
           		data:{
           			"pageno":pageno,
           			"pagesize":5,
           			"querytext":querytext
           		},
           		beforeSend:function(){
           			loadingIndex=layer.msg("响应中",{icon:16})
           		},
           		success:function(data){
           			layer.close(loadingIndex);
           			if(data.status=='200'){
           				//局部刷新页面
           				var tableContent="";
           				var pageContent= "";
           				
           				var userpage = data.model;
           				var users =userpage.datas;
           				
           				$.each(users,function(i,user){
            				tableContent+='<tr>';
          	                tableContent+='<td>'+(i+1)+'</td>';
          					tableContent+='<td><input type="checkbox" name="userId" value="'+user.id+'"></td>';
          	                tableContent+='<td>'+user.loginAcc +'</td>';
          	                tableContent+='<td>'+user.user_name+'</td>';
          	                tableContent+='<td>'+ user.email +'</td>';
          	                tableContent+='<td>';
          					tableContent+='<button type="button" onclick="toAssignPage('+user.id+')"class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
          					tableContent+='<button type="button" onclick="updateAcc('+user.id+')" class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
          					tableContent+='<button type="button" onclick="delUser('+user.id+',\''+user.loginAcc+'\')"class="btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
          					tableContent+='</td>';
          	                tableContent+='</tr>';
           				});
           				
           				if(userpage.pageno>1){
           					pageContent+='<li><a href="javascript:" onclick="pageQuery('+userpage.beforePage+')">上一页</a></li>';
           				}
           				for(var i=1;i<=userpage.maxPageSize;i++){
           					if(i==userpage.pageno){
           					pageContent+='<li class="active"><a href="javascript:">'+i+'<span class="sr-only">(current)</span></a></li>';
           					}else{
           					pageContent+='<li><a onclick="pageQuery('+i+')">'+i+'</a></li>';
           					}
           				}
           				if(userpage.pageno<userpage.maxPageSize){
           					pageContent+='<li><a href="javascript:" onclick="pageQuery('+userpage.nextPage+')">下一页</a></li>';
           				}
           				$("#userdata").html(tableContent);
           				$(".pagination").html(pageContent);
           			}else{
           				layer.msg(data.msg,{time:1000,icon:5});
           			}
           		}
           		
           	});
           };
           function updateAcc(id){
        	   window.location.href="user/toUpdate.do?id="+id;
           }
           function toAssignPage(id){
        	   window.location.href="user/toAssignPage.do?id="+id;
           }
           function delUser(id,loginAcc){
        	   layer.confirm('确定删除用户【'+loginAcc+'】?', {icon: 3, title:'提示'}, function(index){
        		   $.ajax({
   	            	type : "POST",
   	            	url : "user/delUser.do",
   	            	data : {
   	            		"id":id
   	            	},
   	            	beforeSend:function(){
   	           			loadingIndex=layer.msg("提交中",{icon:16})
   	           		},
   	           		success:function(data){
   	           			layer.close(loadingIndex);
   	           			if(data.status=='200'){
   	           				layer.msg(data.msg,{time:1000,icon:6},function(){
   	           				pageQuery(1);
   	           				});
   	           			}else{
   	           				layer.msg(data.msg,{time:1000,icon:5});
   	           			}
   	           		}
        		  });
        		   layer.close(index);
        		 },function(index){
        		   layer.close(index);
        		 });
           }
           /* 批量删除 */
           function delUsers(){
        	 var boxs = $("#userdata :checkbox");
        	 if(boxs.length==0){
        		 layer.msg("请选择要删除的用户",{time:1000,icon:5,shift:6});
        	 }else{
        		 layer.confirm('确定删除?', {icon: 3, title:'提示'}, function(index){
        			 alert($("#userForm").serialize());
        			 $.ajax({
        	            	type : "POST",
        	            	url : "user/delUsers.do",
        	            	data :$("#userForm").serialize(),
        	            	beforeSend:function(){
        	           			loadingIndex=layer.msg("提交中",{icon:16})
        	           		},
        	           		success:function(data){
        	           			layer.close(loadingIndex);
        	           			if(data.status=='200'){
        	           				layer.msg(data.msg,{time:1000,icon:6},function(){
        	           				pageQuery(1);
        	           				});
        	           			}else{
        	           				layer.msg(data.msg,{time:1000,icon:5});
        	           			}
        	           		}
             		  });
        			 layer.close(index);
       			 },function(index){
             		layer.close(index);
           		 });
        	 }
           }
           $("#checkAll").click(function(){
        	   var flg=this.checked;
        	   if(flg){
        		   $("#userdata :checkbox").each(function(){
        			   this.checked=flg;
        		   });
        	   }else{
        		   $("#userdata :checkbox").each(function(){
        			   this.checked=flg;
        		   });
        	   }
           });
        </script>
  </body>
</html>
