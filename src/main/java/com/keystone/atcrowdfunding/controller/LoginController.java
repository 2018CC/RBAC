package com.keystone.atcrowdfunding.controller;


import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.keystone.atcrowdfunding.pojo.AjaxDone;
import com.keystone.atcrowdfunding.pojo.Permission;
import com.keystone.atcrowdfunding.pojo.User;
import com.keystone.atcrowdfunding.service.LoginService;
import com.keystone.atcrowdfunding.service.PermissionService;
import com.keystone.atcrowdfunding.service.UserService;

/** 
 *
 * @author 
 * @datetime 2018年10月30日 上午9:47:19
 * @editnote 
 *	
 */
@Controller
@RequestMapping("login")
public class LoginController {
	
	@Resource
	LoginService service;
	@Resource
	PermissionService permissionService;
	@Resource
	UserService userService;
	/**
	 * 跳转到登录页面
	 */
	@RequestMapping("toLogin.do")
	public String tologin(){
		return "login";
	}
	/**
	 * 登录实现
	 */
	@RequestMapping("doLogin.do")
	@ResponseBody
	public AjaxDone doLogin(User user,HttpServletRequest request){
		User loginUser = service.query4Login(user);
		
		if(loginUser != null){
			request.getSession().setAttribute("loginUser", loginUser);
			
			//获取用户权限信息
			List<Permission> permissions=permissionService.queryPersByUser(loginUser);
			Set<String> uriSet= new HashSet<>();
			Map<Integer,Permission> permissionMap= new HashMap<>();
			for (Permission permission : permissions) {
				permissionMap.put(permission.getId(), permission);
				if(!(permission.getUrl()==null) && !("".equals(permission.getUrl())) ){
					uriSet.add(request.getSession().getServletContext().getContextPath()+"/"+ permission.getUrl());
				}
			}
			request.getSession().setAttribute("AuthUriSet", uriSet);
			Permission root =null;
			for (Permission p : permissions) {
				//子节点
				Permission child = p;
				if(p.getP_id()==0){
					root=child;
				}else{
					//父节点
					Permission parent = permissionMap.get(child.getP_id());
					parent.getChildren().add(child);
				}
			}
			request.getSession().setAttribute("rootPermission", root);
			return new AjaxDone("200","登录成功");
		}else{
			return new AjaxDone("300","用户名或密码错误！");
		}
		
		
	}
	//跳转到主页面
	@RequestMapping("main.do")
	public String main(){
		return "main";
		
	}
	/**
	 * 退出登录
	 *
	 * @param request
	 * @param response
	 * @return
	 * @author CC
	 * @datetime 2018年11月5日 下午2:00:42
	 * @editnote 
	 *
	 */
	@RequestMapping("exit.do")
	public String exit(HttpServletRequest request,HttpServletResponse response){
		//request.getSession().removeAttribute("loginUser");
		request.getSession().invalidate();
		return "login";
		
	}
	/**
	 * 跳转到错误页面
	 */
	@RequestMapping("error.do")
	public String toError(){
		return "error";
	}
	
	/**
	 * 跳转到注册页面
	 */
	@RequestMapping("toReg.do")
	public String toReg(){
		return "reg";
		
	}
	/**
	 * 注册用户
	 */
	@RequestMapping("reg.do")
	@ResponseBody
	public AjaxDone doReg(HttpServletRequest request){
		Map<String,Object> map = new HashMap<>();
		SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		try{
		String loginAcc= request.getParameter("loginAcc");
		String user_name= request.getParameter("user_name");
		String password= request.getParameter("password");
		String email= request.getParameter("email");
			map.put("loginAcc",loginAcc);
			map.put("user_name",user_name);
			map.put("password",password);
			map.put("email",email);
			map.put("createtime",sdf.format(new Date()));
			Integer i = service.regAcc(map);
			if(i<=0){
				return new AjaxDone("300","注册失败");
			}
			User user = new User();
			user.setLoginAcc(loginAcc);
			user.setPassword(password);
			User reguser = service.query4Login(user);
			Map<String,Object> regRole = new HashMap<>();
			regRole.put("user_id", reguser.getId());
			regRole.put("role_id",2);
			userService.doUserRole(regRole);
			return new AjaxDone("200","注册成功");
			
		}catch(Exception e){
			e.printStackTrace();
			return new AjaxDone("300","系统繁忙，稍后再试！");
		}
	}
}
