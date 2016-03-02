<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "点赞失败";
int n = 0;
String t = request.getParameter("comment_id");
Integer user_id = (Integer)session.getAttribute("user_id");
if (t!=null && user_id!=null){
	int comment_id = Utils.getInt(t);
	boolean hasLiked = DAO.hasLikedComment(user_id, comment_id);
	if (hasLiked){
		code = 2;
		DAO.deleteLikeComment(user_id, comment_id);
		msg = "减赞成功";
	}else{
		code = 1; 
		DAO.insertLikeComment(user_id, comment_id);
		msg = "加赞成功";
		if (user_id != DAO.getFromUserIdByCommentId(comment_id)){
			DAO.insertMessage(user_id, DAO.getFromUserIdByCommentId(comment_id), "赞了你的评论", comment_id, 2);
		}
	}
	n = DAO.getLikeCommentNum(comment_id);
} 
%>

<pushLike>
	<code><%=code%></code>
	<msg><%=msg%></msg>
	<n><%=n%></n>
</pushLike>