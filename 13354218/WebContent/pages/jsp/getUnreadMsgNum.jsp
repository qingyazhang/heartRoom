<%@page import="com.web.Lmj.SessionCounter"%>
<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "获取失败";
Integer n = 0;



Integer user_id = (Integer)session.getAttribute("user_id");
if (user_id !=null){
	n = DAO.getUnreadMsgNum(user_id);
	if (n!=null){
		code = 1; 
		msg = "获取成功";
	}else{
		n = 0;
		msg = "获取失败";
	}
}



%>
    
<getUnreadMsgNum>
	<code><%=code%></code>
	<msg><%=msg%></msg>
	<n><%=n %></n>
	<alive><%=SessionCounter.getActiveSessions()%></alive>
</getUnreadMsgNum>