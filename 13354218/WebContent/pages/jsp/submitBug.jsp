
<%@page import="com.web.Lmj.Log"%>
<%@page import="com.web.Lmj.Utils"%>
<%@page import="com.web.Lmj.DAO"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "提交失败，此可谓bug无限大！";
String bug = request.getParameter("bug");
String contact = request.getParameter("contact");
String username = request.getParameter("username");
Integer user_id = (Integer)session.getAttribute("user_id");
String  sessionUsername = "未登录用户";
if (user_id != null){
	sessionUsername = DAO.getUsernameByUserId(user_id);
}
if (msg == null || msg.isEmpty()){
	msg = "空bug是什么意思？";
}else{
	Log log = new Log(getServletContext().getRealPath("/"), "bug.txt");
	String recordText = "username: "+username+"\n";
	recordText += "sessionUsername: "+sessionUsername+"\n";
	recordText += "contact: "+contact+"\n";
	recordText += "bug: " + bug+"\n";
	recordText += "\n";
	log.b(recordText);
	code = 1; 
	msg = "请静候佳音，先让我司全体成员恭祝你新年快乐！~^o^~ | ∩__∩y 耶~~^^";
}
%>

<submitBug>
	<code><%=code%></code>
	<msg><%=msg%></msg>
</submitBug>