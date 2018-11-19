package com.keystone.atcrowdfunding.controller;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.keystone.atcrowdfunding.pojo.Permission;
import com.keystone.atcrowdfunding.service.PermissionService;

/** 
 *
 * @author 
 * @datetime 2018年11月12日 上午9:59:57
 * @editnote 
 *	
 */
@SuppressWarnings("unchecked")
public class AuthInterceptor extends HandlerInterceptorAdapter {
	
	@Resource
	PermissionService permissionService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		String uri = request.getRequestURI();	
		
		List<Permission> Permissions = permissionService.queryAll();
		Set<String> uriSet =new HashSet<>();
		for (Permission permission : Permissions) {
			if(permission.getUrl()!=null && !("".equals(permission.getUrl())) ){
				uriSet.add(request.getContextPath()+"/"+permission.getUrl());
			}
		}
		//权限验证
		if(uriSet.contains(uri)){
			Set<String> AuthUriSet = (Set<String>) request.getSession().getAttribute("AuthUriSet");
			if(AuthUriSet.contains(uri)){
				return true;
			}else{
				response.sendRedirect(request.getContextPath()+"/login/error.do");
				return false;
			}
		}else{
			return true;
		}
	}
}
