<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@page import="com.web.Lmj.User"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "获取用户信息失败";
User user = new User();

int sheild = 0;
int hasSheild = 0;
int admin = 0;
String t = request.getParameter("user_id");
Integer user_id = 0;
if (t==null || !Utils.isNumeric(t)){
	user_id = (Integer)session.getAttribute("user_id");
}else{
	user_id = Utils.getInt(t);
}
//System.out.println(user_id);
if (user_id == null){
	user = new User();
	user.setSignature("登录是什么意思呢？");
}else{
	user = DAO.getUser(user_id);
}

Integer permission = (Integer)session.getAttribute("permission");
if (permission!=null && permission == 0){
	admin = 1;
	sheild = DAO.getSheildNum(user_id);
	hasSheild = DAO.getRestriction(user_id);
}

code = 1;
msg = "获取用户信息成功！";


%>

<getUserInfo>
	<code><%=code%></code>
	<msg><%=msg%></msg>
	<user_id><%=user.getUser_id()%></user_id>
	<username><%=user.getUsername()%></username>
	<signature><%=user.getSignature()%></signature>
	<sex><%=user.getSex()%></sex>
	<age><%=user.getAge()%></age>
	<permission><%=user.getPermission()%></permission>
	<email><%=user.getEmail()%></email>
	<head_pic><%=user.getHead_pic()%></head_pic>
	<music><%=user.getMusic()%></music>
	<reg_time><%=user.getLocalRegTime()%></reg_time>
	
	<sheild><%=sheild%></sheild>
	<hasSheild><%=hasSheild%></hasSheild>
	<admin><%=admin%></admin>
</getUserInfo>