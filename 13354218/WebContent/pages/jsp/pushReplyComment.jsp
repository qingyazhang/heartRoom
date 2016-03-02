<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/text; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

    
<%
request.setCharacterEncoding("UTF-8");

boolean post = request.getMethod().equalsIgnoreCase("post");
Integer from_user_id = (Integer)session.getAttribute("user_id");
if (post&& from_user_id!=null){
	if (DAO.getRestriction(from_user_id)==1){
		out.println("你已经被屏蔽了哦...");
	}else{
		String content = request.getParameter("content");
		int to_comment_id = Utils.getInt(request.getParameter("comment_id"));
		int belong_show = DAO.getShowIdByCommentId(to_comment_id);
		Integer comment_id = DAO.insertComment(content, belong_show, 1);
		boolean flag = DAO.insertReplyComment(from_user_id, to_comment_id, comment_id);
		DAO.incShowCommentNum(belong_show); 
		DAO.incCommentCommentNum(to_comment_id); 
		if (flag){ 
			int to_user_id = DAO.getToUserIdByCommentId(comment_id);
			//System.out.println(belong_show+" "+to_user_id+" "+comment_id);
			if (from_user_id != to_user_id){
				DAO.insertMessage(from_user_id, to_user_id, "回复了你的评论", comment_id, 4);
			}
			if (from_user_id != belong_show && from_user_id!=to_user_id && DAO.getUserIdByShowId(belong_show)!=to_user_id){
				DAO.insertMessage(from_user_id, DAO.getShowUserIdByCommentId(comment_id), "回复了你的动态", comment_id, 3);
			}
			String from = request.getParameter("from");
			if (from==null){ 
				out.println("回复成功!");
			}else{
				//System.out.println(comment_id);
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
