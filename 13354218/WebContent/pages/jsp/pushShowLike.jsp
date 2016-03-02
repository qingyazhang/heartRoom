<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "点赞失败";
int n = 0;
String t = request.getParameter("show_id");
Integer user_id = (Integer)session.getAttribute("user_id");
if (t!=null && user_id!=null){
	int show_id = Utils.getInt(t);
	boolean hasLiked = DAO.hasLikedShow(user_id, show_id);
	if (hasLiked){
		code = 2;
		DAO.deleteLikeShow(user_id, show_id);
		msg = "减赞成功";
	}else{
		code = 1; 
		DAO.insertLikeShow(user_id, show_id);
		msg = "加赞成功";
		if (user_id!=DAO.getUserIdByShowId(show_id)){
			DAO.insertMessage(user_id, DAO.getUserIdByShowId(show_id), "赞了你的动态", show_id, 1);
		}
			
	}
	n = DAO.getLikeShowNum(show_id);
}
%>

<pushLike>
	<code><%=code%></code>
	<msg><%=msg%></msg>
	<n><%=n%></n>
</pushLike>