<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "修改失败";
String t = request.getParameter("message_id");
Integer user_id = (Integer)session.getAttribute("user_id");
if (t!=null && user_id!=null){
	int message_id = Utils.getInt(t);
	if (user_id == DAO.getToUserIdByMessageId(message_id)){
		boolean flag = DAO.setMsgHasRead(message_id);
		if (flag){
			code = 1;
			msg = "修改成功！"; 
		}else{
			msg = "修改失败！";
		}
	}
}
%>
    
<user>
	<code><%=code%></code>
	<msg><%=msg%></msg>
</user>