<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "修改失败";
String t = request.getParameter("show_id");
String tn = request.getParameter("mode");
Integer user_id = (Integer)session.getAttribute("user_id");
if (t!=null && tn!=null && user_id!=null){
	int show_id = Utils.getInt(t);
	int mode = Utils.getInt(tn);
	int permission = Utils.getInt(session.getAttribute("permission").toString());
	if (permission == 0 || user_id == DAO.getUserIdByShowId(show_id)){
		boolean flag = DAO.changeShowMode(show_id, mode);
		if (flag){
			code = 1;
			msg = "修改成功！"; 
		}else{
			msg = "修改失败！";
		}
	}
}
%>
    
<changeShowMode>
	<code><%=code%></code>
	<msg><%=msg%></msg>
</changeShowMode>