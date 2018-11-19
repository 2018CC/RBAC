/** 
 *
 * @author 
 * @datetime 2018年11月7日 上午11:27:54
 * 
 */
package com.keystone.atcrowdfunding.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


/** 
 *
 * @author 
 * @datetime 2018年11月7日 上午11:27:54
 * @editnote 
 *	
 */
/** 
 *
 * @datetime 2018年11月7日 上午11:27:54
 * @editnote 
 *
 */
public class LoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		String requestType = request.getHeader("X-Requested-With"); 
        
        if(request.getSession() != null && request.getSession().getAttribute("loginUser") != null) {
            return true;
        }
        if("XMLHttpRequest".equals(requestType)){
        	response.getWriter().write("{\"status\":\"301\", \"msg\":\"会话超时，请重新登录！\"}");
        	PrintWriter pw = response.getWriter();
        	pw.print("timeout");
        	pw.flush();
        } else{
        	response.getWriter().print("<script type='text/javascript'>window.top.location='" + request.getContextPath() + "/login/toLogin.do';</script>");
        }
        return false;
	}
	

	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}

	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
	}

}
