<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "没有权限";
String t = request.getParameter("comment_id");
if (t!=null){
	int comment_id = Utils.getInt(t);
	int permission = Utils.getInt(session.getAttribute("permission").toString());
	String username = session.getAttribute("username").toString();
	int commentUserId = DAO.getFromUserIdByCommentId(comment_id);
	int show_id = DAO.getShowIdByCommentId(comment_id);
	String showUsername = DAO.getUsernameByUserId(commentUserId);
	if (permission==0 || username.equals(showUsername)){
		boolean flag = DAO.deleteComment(comment_id);
		if (flag){
			if (DAO.getCommentType(comment_id)==1){
				DAO.decCommentCommentNum(comment_id);
			}
			code = 1;
			msg = "删除成功";
		}else{
			msg = "删除失败";
		}
	}
}
%>
    
<deleteShow>
	<code><%=code%></code>
	<msg><%=msg%></msg>
</deleteShow>