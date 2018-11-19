<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<ul style="padding-left:0px;" class="list-group">
	<c:forEach items="${rootPermission.children }" var="permission">
		<c:if test="${empty permission.children }">
			<li class="list-group-item tree-closed" >
				<a href="${permission.url }"><i class="glyphicon glyphicon-dashboard"></i> ${permission.name }</a> 
			</li>
		</c:if>
		<c:if test="${not empty permission.children }">
			<li class="list-group-item tree-closed">
				<span><i class="${permission.icon }"></i> ${permission.name } <span class="badge" style="float:right">${permission.children.size() }</span></span> 
				<ul style="margin-top:10px;display:none;">
					<c:forEach items="${permission.children  }" var="children">
						<li style="height:30px;">
							<a href="${children.url }"><i class="${children.icon }"></i> ${children.name }</a> 
						</li>
					</c:forEach>
				</ul>
			</li>
		</c:if>
	</c:forEach>