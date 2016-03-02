<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "注册失败！";
String username = "无名氏";
boolean post = request.getMethod().equalsIgnoreCase("POST");
if (post){
	username = request.getParameter("username");
	String password = request.getParameter("password");
	String email = request.getParameter("email");
	int sex = Utils.getInt(request.getParameter("sex"));
	
	if(username==null || username.isEmpty()){
		msg = "注册失败，用户名不能为空！";
	}else if (DAO.existsUser(username)){
		code = -1;
		msg = "注册失败，用户名已存在!";
	}else if (password == null || password.isEmpty() || password.length()!=32){
		code = -2;
		msg = "注册失败，密码不合规范！";
	}else if (email == null || email.isEmpty()){
		msg = "注册失败，邮箱不能为空!";
	}else if (!Utils.isEmail(email)){
		code = -3;
		msg = "注册失败，邮箱格式错误!";
	}else{
		Integer user_id = DAO.insertUser(username, password, email, sex);
		if (user_id!=null){
			code = 1;
			DAO.insertMessage(1, user_id, "欢迎你的入住，这里将会因你的加入而更精彩！", 0, 0);
			msg = "注册成功，请登录！";
		}else{
			msg = "注册失败，未知错误！";
		}
	}
	
}
%>

<register>
	<code><%=code%></code>
	<msg><%=msg%></msg>
	<username><%=username%></username>
</register>