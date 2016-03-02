<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/text; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

    
<%
request.setCharacterEncoding("UTF-8");

boolean post = request.getMethod().equalsIgnoreCase("post");
Integer from_user_id = (Integer)session.getAttribute("user_id");
if (post && from_user_id!=null){
	if (DAO.getRestriction(from_user_id)==1){
		out.println("你已经被屏蔽了哦...");
	}else{
		String content = request.getParameter("content");
		int to_show_id = Utils.getInt(request.getParameter("show_id"));
		Integer comment_id = DAO.insertComment(content, to_show_id, 0);
		boolean flag = DAO.insertCommentShow(from_user_id, to_show_id, comment_id);
		DAO.incShowCommentNum(to_show_id);
		if (flag){ 
			if (from_user_id != DAO.getUserIdByShowId(to_show_id)){
				DAO.insertMessage(from_user_id, DAO.getUserIdByShowId(to_show_id), "评论了你的动态", comment_id, 3);
			}
			String from = request.getParameter("from");
			if (from==null){
				out.println("评论成功!");
			}else{
				%>
				<jsp:forward page="getShowComment.jsp">
					<jsp:param value="<%=comment_id%>" name="comment_id"/>
					<jsp:param value="<%=from%>" name="from"/>
				</jsp:forward>
				<%
			}
		}
	}
}
%>
