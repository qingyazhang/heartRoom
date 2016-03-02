<%@page import="com.web.Lmj.Log"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isErrorPage="true"%>

	<%
	request.setCharacterEncoding("UTF-8");
	Log log = new Log(getServletContext().getRealPath("/"));
	String text = "";
	text += "toString(): "+exception.toString()+"\n";
	text += "getMessage(): "+exception.getMessage()+"\n";
	text += "getMessage(): "+exception.getMessage()+"\n";
	text += "getStackTrace(): "+exception.getStackTrace().toString()+"\n";
	log.e(text);
	//log.e(exception.getMessage());
/* 	log.e(exception.getLocalizedMessage());
	log.e(exception.getStackTrace().toString()); */
	%>
    <div style="text-align: center;">
    服务器发生了错误，错误提示为：<%=exception.getMessage() %>
    </div>