package com.keystone.atcrowdfunding.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.keystone.atcrowdfunding.pojo.User;

/** 
 *
 * @author 
 * @datetime 2018年10月29日 下午6:47:10
 * @editnote 
 *	
 */
@Controller
public class TestController {
	
	
	@RequestMapping("hello.do")
	@ResponseBody
	public User m(){
		return new User();
	}
	
	@RequestMapping("login.do")
	public String toLogin(){
		return "login";
		
	}
}
