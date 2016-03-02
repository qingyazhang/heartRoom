<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "重置密码失败！";
String username = "无名氏";
boolean post = request.getMethod().equalsIgnoreCase("POST");
if (post){
	username = request.getParameter("username").trim();
	String password = request.getParameter("password").trim();
	String email = request.getParameter("email");

	if(username==null || username.isEmpty()){
		msg = "重置密码失败，用户名不能为空！";
	}else if (password == null || password.isEmpty() || password.length()!=32){
		msg = "重置密码失败，密码不合规范！";
	}else if (email == null || email.isEmpty()){
		msg = "重置密码失败，邮箱不能为空!";
	}else if (!DAO.existsUser(username)){
		msg = "重置密码失败，用户名不存在!";
	}else{ 
		boolean flag = DAO.resetPassword(username, password, email);
		if (flag){
			code = 1;
			msg = "重置密码成功，请登录！";
			DAO.deleteSessionByUserId(DAO.getUserIdByUsername(username));
		}else{
			msg = "重置密码失败，信息不匹配！";
		}
	}
	
}
%>

<register>
	<code><%=code%></code>
	<msg><%=msg%></msg>
	<username><%=username%></username>
</register>