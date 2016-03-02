<%@page import="com.web.Lmj.DAO"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
int code = 1;
String msg = "退出登录成功!";
DAO.deleteSessionByUserId((Integer)session.getAttribute("user_id"));
session.invalidate();
%>
<logout>
	<code><%=code%></code>
	<msg><%=msg%></msg>
</logout>