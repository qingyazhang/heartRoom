<%@page import="com.web.Lmj.Utils"%>
<%@page import="com.web.Lmj.User"%>
<%@page import="com.web.Lmj.DAO"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>
<%@ page session="true" %>
<%
request.setCharacterEncoding("UTF-8");

int code = 0;
String msg = "登录失败！用户名或密码错误！";
String username = "暂无名氏";
String signature = "你不觉得下面两个按钮很好玩吗？";
String head_pic = "head_user.gif";
String music = "InThere.mp3";

boolean post = request.getMethod().equalsIgnoreCase("post");
String type = request.getParameter("type");
if (type==null || !type.equalsIgnoreCase("auto")){
	
	username = request.getParameter("username");
	String password = request.getParameter("password");
	if (username!=null && password!=null){
		User user = DAO.login(username, password);
		if (user!=null){
			code = 1;
			username = user.getUsername();
			if (user.getPermission() == 0){
				msg = "管理员"+username+", 欢迎你再次回来！";
			}else if (user.getRestriction() == 1){
				msg = username+", 欢迎你再次回来！但是你到底干了什么坏事，居然被管理员屏蔽了？";
			}else{
				msg = username+", 欢迎你再次回来！";
			}
			signature = user.getSignature();
			head_pic = user.getHead_pic();
			music = user.getMusic();
			
			//Session处理
			String remember = request.getParameter("remember");
			if (remember.equalsIgnoreCase("yes")){
				String session_id = DAO.insertSession(session.getId(), user.getUser_id(), 7);
				Cookie cookie1 = new Cookie("session_id", session_id);
				cookie1.setMaxAge(7*24*60*60);
				response.addCookie(cookie1);
				Cookie cookie2 = new Cookie("user_id", user.getUser_id()+"");
				cookie2.setMaxAge(7*24*60*60);
				response.addCookie(cookie2);
			}
			session.setAttribute("user_id", user.getUser_id());
			session.setAttribute("username", user.getUsername());
			session.setAttribute("permission", user.getPermission());
			session.setAttribute("restriction", user.getRestriction());
			//System.out.println("new session");
		}else{
			msg = "登录失败！用户名或密码错误！";
			username = "暂无名氏";
		}
	}else{
		username = "暂无名氏";
	}
}else{
	Cookie[] cookies = request.getCookies();
	System.out.println("auto login " + cookies.length);
	msg = "自动登录失败！";
	if( cookies != null ){
		String session_id = null;
		for (int i = 0; i < cookies.length; i++){
		   Cookie cookie = cookies[i];
		   //System.out.println(cookie.getName()+": "+cookie.getValue());
		   if (cookie.getName().equals("session_id")){
			   //System.out.println(cookie.getValue());
		  	 session_id = cookie.getValue();
		   }else if (cookie.getName().equals("user_id")){
			 Integer user_id = Utils.getInt(cookie.getValue());
			 //System.out.println(user_id);
		  	 username = DAO.getUsernameByUserId(user_id);
		   }
		}
		//System.out.println(session_id);
		//System.out.println(username);
		if (session_id!=null && username!=null){
			Integer user_id = DAO.getUserIdByUsername(username);
			//System.out.println(user_id);
			if (user_id != null && DAO.isValidSession(session_id, user_id)){
				User user = DAO.getUser(username);
				if (user!=null){
					code = 1;
					username = user.getUsername();
					if (user.getPermission() == 0){
						msg = "管理员"+username+", 欢迎你再次回来！";
					}else{
						msg = username+", 欢迎你再次回来！";
					}
					signature = user.getSignature();
					head_pic = user.getHead_pic();
					music = user.getMusic();
					
					//Session处理
					session.setAttribute("user_id", user.getUser_id());
					session.setAttribute("username", user.getUsername());
					session.setAttribute("permission", user.getPermission());
					session.setAttribute("restriction", user.getRestriction());
					//System.out.println("new session");
				}
			}else{
				System.out.println("无效session");
				username = "暂无名氏";
			}
		}else{
			System.out.println("没有session");
			username = "暂无名氏";
		}
	  }else{
	  }
}
%>
<user>
<code><%=code%></code>
<msg><%=msg%></msg>
<username><%=username%></username>
<signature><%=signature%></signature>
<head_pic><%=head_pic%></head_pic>
<music><%=music%></music>
</user>