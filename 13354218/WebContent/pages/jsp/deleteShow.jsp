<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "没有权限";
String t = request.getParameter("show_id");
Integer user_id = (Integer)session.getAttribute("user_id");
if (t!=null && user_id!=null){
	int show_id = Utils.getInt(t);
	int permission = Utils.getInt(session.getAttribute("permission").toString());
	String username = session.getAttribute("username").toString();
	int showUserId = DAO.getUserIdByShowId(show_id);
	String showUsername = DAO.getUsernameByUserId(showUserId);
	if (username.equals(showUsername)){
		boolean flag = DAO.deleteShow(show_id);
		if (flag){
			code = 1;
			msg = "删除成功";
		}else{
			msg = "删除失败";
		}
	}else if (permission==0){
		boolean flag = DAO.shieldShow(show_id); 
		if (flag){
			code = 1;
			msg = "屏蔽成功"; 
			DAO.insertMessage(user_id, showUserId, "很不幸告诉的你，你发表的动态被管理员屏蔽了哦。", show_id, 6);
		}else{
			msg = "屏蔽失败";
		}
	}
}
%>
    
<deleteShow>
	<code><%=code%></code>
	<msg><%=msg%></msg>
</deleteShow>