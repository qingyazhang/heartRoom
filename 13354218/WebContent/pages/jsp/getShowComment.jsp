<%@page import="java.util.ArrayList"%>
<%@page import="com.web.Lmj.User"%>
<%@page import="com.web.Lmj.Utils"%>
<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Comment"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");

String tn = request.getParameter("n");
String from = request.getParameter("from");
Integer user_id = (Integer)session.getAttribute("user_id");
if (tn == null && user_id!=null) {//单条comment
	int comment_id = Utils.getInt(request.getParameter("comment_id"));
	Comment comment = DAO.getPublicShowComment(comment_id);
	if (from.equalsIgnoreCase("public")){
		if (comment == null){
			out.println("回复失败");
			return;
		}
		User user = DAO.getUser(user_id); 
		User fromUser = DAO.getUser(comment.getFrom_user_id());
		User toUser = DAO.getUser(comment.getTo_user_id());
		int likeNum = DAO.getLikeCommentNum(comment.getComment_id()); 
		String toUsername = comment.getType()==0? "":toUser.getUsername();
		boolean hasLiked = DAO.hasLikedComment(user.getUser_id(), comment.getComment_id());
		boolean hasPermission = user.getPermission()==0 || user.getUser_id()==comment.getFrom_user_id();
		%>
    	<!-- 一条评论 -->
        <div class="div_public_show_subcomment_container">
            <span class="comment_id" style="display:none;"><%=comment.getComment_id()%></span>
            <span class="comment_user_id" style="display:none;"><%=comment.getFrom_user_id()%></span>
            <%=hasPermission? "<a class=\"public_show_comment_delete\" style=\"display:;\" onclick=\"deletePublicShowComment(this);\">X</a>":"" %>
            <img class="public_show_subcomment_head_pic" src="../img/<%=fromUser.getHead_pic()%>">
            <div class="public_show_subcomment_detail">
                <a class="public_show_subcomment_from" onclick="showPublicShowCommentUserInfo(this);"><%=fromUser.getUsername()%></a>
                <span class="public_show_subcomment_text"><%=comment.getType()==0? "评论":"回复"%></span>
                <a class="public_show_subcomment_to" onclick="showPublicShowCommentUserInfo(this);"><%=toUsername%></a>
                <span class="public_show_subcomment_text">：</span>
                <p class="public_show_subcomment_content"><%=comment.getContent()%></p>
                <p>
                    <span class="public_show_subcomment_time"><%=comment.getLocalCommentTime()%></span>
                    <input type="text" class="public_show_subcomment_reply_content" placeholder="......" >
                    <a class="btn_public_show_subcomment_reply" onclick="replyPublicShowComment(this);">回复</a>
                    <span class="public_show_subcomment_like_num"><%=likeNum%></span>
                    <img class="public_show_subcomment_like <%=hasLiked?"public_show_like_has":""%>"  onclick="likePublicShowComment(this);" src="../img/like_left.png">
                </p>
            </div>
        </div>
        <!-- 一条comment end -->
		<%
	}else{//persional
		if (comment == null){
			out.println("回复失败");
			return;
		}
		User user = DAO.getUser(user_id); 
		User fromUser = DAO.getUser(comment.getFrom_user_id());
		User toUser = DAO.getUser(comment.getTo_user_id());
		int likeNum = DAO.getLikeCommentNum(comment.getComment_id()); 
		String toUsername = comment.getType()==0? "":toUser.getUsername();
		boolean hasLiked = DAO.hasLikedComment(user.getUser_id(), comment.getComment_id());
		boolean hasPermission = user.getPermission()==0 || user.getUser_id()==comment.getFrom_user_id();
		%>
    	<!-- 一条评论 -->
        <div class="div_personal_show_subcomment_container">
            <span class="comment_id" style="display:none;"><%=comment.getComment_id()%></span>
            <span class="comment_user_id" style="display:none;"><%=comment.getFrom_user_id()%></span>
            <%=hasPermission? "<a class=\"personal_show_comment_delete\" style=\"display:;\" onclick=\"deletePersonalShowComment(this);\">X</a>":"" %>
            <img class="personal_show_subcomment_head_pic" src="../img/<%=fromUser.getHead_pic()%>">
            <div class="personal_show_subcomment_detail">
                <a class="personal_show_subcomment_from" onclick="showPersonalShowCommentUserInfo(this);"><%=fromUser.getUsername()%></a>
                <span class="personal_show_subcomment_text"><%=comment.getType()==0? "评论":"回复"%></span>
                <a class="personal_show_subcomment_to" onclick="showPersonalShowCommentUserInfo(this);"><%=toUsername%></a>
                <span class="personal_show_subcomment_text">：</span>
                <p class="personal_show_subcomment_content"><%=comment.getContent()%></p>
                <p>
                    <span class="personal_show_subcomment_time"><%=comment.getLocalCommentTime()%></span>
                    <input type="text" class="personal_show_subcomment_reply_content" placeholder="......">
                    <a class="btn_personal_show_subcomment_reply" onclick="replyPersonalShowComment(this);">回复</a>
                    <span class="personal_show_subcomment_like_num"><%=likeNum%></span>
                    <img class="personal_show_subcomment_like <%=hasLiked?"personal_show_like_has":""%>"  onclick="likePersonalShowComment(this);" src="../img/like_left.png">
                </p>
            </div>
        </div>
        <!-- 一条comment end -->
		<%
	}
}else if (user_id!=null){//多条
	int n = Utils.getInt(tn);
	//System.out.println(n);
	String ts = request.getParameter("show_id");
	int show_id = Utils.getInt(ts);
	if (from.equals("public")){
		ArrayList<Comment> comments;
		String tc = request.getParameter("comment_id");
		//System.out.println(tc);
		if (tc==null){
			
			comments = DAO.getNewShowComments(show_id, n);
			System.out.println("comments size: "+comments.size());
		}else{
			int comment_id = Utils.getInt(tc);
			//System.out.println(comment_id);
			comments = DAO.getNextShowComments(show_id, comment_id, n); 
		}
		User user = DAO.getUser(user_id); 
		/* System.out.println(comments.size()); */
		for (Comment comment : comments){
			User fromUser = DAO.getUser(comment.getFrom_user_id());
			User toUser = DAO.getUser(comment.getTo_user_id());
			int likeNum = DAO.getLikeCommentNum(comment.getComment_id()); 
			String toUsername = comment.getType()==0? "":toUser.getUsername();
			boolean hasLiked = DAO.hasLikedComment(user.getUser_id(), comment.getComment_id());
			boolean hasPermission = user.getPermission()==0 || user.getUser_id()==comment.getFrom_user_id();
			%>
	    	<!-- 一条评论 -->
	        <div class="div_public_show_subcomment_container">
	            <span class="comment_id" style="display:none;"><%=comment.getComment_id()%></span>
	            <span class="comment_user_id" style="display:none;"><%=comment.getFrom_user_id()%></span>
	            <%=hasPermission? "<a class=\"public_show_comment_delete\" style=\"display:;\" onclick=\"deletePublicShowComment(this);\">X</a>":"" %>
	            <img class="public_show_subcomment_head_pic" src="../img/<%=fromUser.getHead_pic()%>">
	            <div class="public_show_subcomment_detail">
	                <a class="public_show_subcomment_from" onclick="showPublicShowCommentUserInfo(this);"><%=fromUser.getUsername()%></a>
	                <span class="public_show_subcomment_text"><%=comment.getType()==0? "评论":"回复"%></span>
	                <a class="public_show_subcomment_to" onclick="showPublicShowCommentUserInfo(this);"><%=toUsername%></a>
	                <span class="public_show_subcomment_text">：</span>
	                <p class="public_show_subcomment_content"><%=comment.getContent()%></p>
	                <p>
	                    <span class="public_show_subcomment_time"><%=comment.getLocalCommentTime()%></span>
	                    <input type="text" class="public_show_subcomment_reply_content" placeholder="......">
	                    <a class="btn_public_show_subcomment_reply" onclick="replyPublicShowComment(this);">回复</a>
	                    <span class="public_show_subcomment_like_num"><%=likeNum%></span>
	                    <img class="public_show_subcomment_like <%=hasLiked?"public_show_like_has":""%>"  onclick="likePublicShowComment(this);" src="../img/like_left.png">
	                </p>
	            </div>
	        </div>
	        <!-- 一条comment end -->
			<%
		}
	}else{//personal
		ArrayList<Comment> comments;
		String tc = request.getParameter("comment_id");
		//System.out.println(tc);
		if (tc==null){
			comments = DAO.getNewShowComments(show_id, n);
			System.out.println("comments size: "+comments.size());
		}else{
			int comment_id = Utils.getInt(tc);
			//System.out.println(comment_id);
			comments = DAO.getNextShowComments(show_id, comment_id, n); 
		}
		User user = DAO.getUser(user_id); 
		/* System.out.println(comments.size()); */
		for (Comment comment : comments){
			User fromUser = DAO.getUser(comment.getFrom_user_id());
			User toUser = DAO.getUser(comment.getTo_user_id());
			int likeNum = DAO.getLikeCommentNum(comment.getComment_id()); 
			String toUsername = comment.getType()==0? "":toUser.getUsername();
			boolean hasLiked = DAO.hasLikedComment(user.getUser_id(), comment.getComment_id());
			boolean hasPermission = user.getPermission()==0 || user.getUser_id()==comment.getFrom_user_id();
			%>
	    	<!-- 一条评论 -->
	        <div class="div_personal_show_subcomment_container">
	            <span class="comment_id" style="display:none;"><%=comment.getComment_id()%></span>
	            <span class="comment_user_id" style="display:none;"><%=comment.getFrom_user_id()%></span>
	            <%=hasPermission? "<a class=\"personal_show_comment_delete\" style=\"display:;\" onclick=\"deletePersonalShowComment(this);\">X</a>":"" %>
	            <img class="personal_show_subcomment_head_pic" src="../img/<%=fromUser.getHead_pic()%>">
	            <div class="personal_show_subcomment_detail">
	                <a class="personal_show_subcomment_from" onclick="showPersonalShowCommentUserInfo(this);"><%=fromUser.getUsername()%></a>
	                <span class="personal_show_subcomment_text"><%=comment.getType()==0? "评论":"回复"%></span>
	                <a class="personal_show_subcomment_to" onclick="showPersonalShowCommentUserInfo(this);"><%=toUsername%></a>
	                <span class="personal_show_subcomment_text">：</span>
	                <p class="personal_show_subcomment_content"><%=comment.getContent()%></p>
	                <p>
	                    <span class="personal_show_subcomment_time"><%=comment.getLocalCommentTime()%></span>
	                    <input type="text" class="personal_show_subcomment_reply_content" placeholder="......">
	                    <a class="btn_personal_show_subcomment_reply" onclick="replyPersonalShowComment(this);">回复</a>
	                    <span class="personal_show_subcomment_like_num"><%=likeNum%></span>
	                    <img class="personal_show_subcomment_like <%=hasLiked?"personal_show_like_has":""%>"  onclick="likePersonalShowComment(this);" src="../img/like_left.png">
	                </p>
	            </div>
	        </div>
	        <!-- 一条comment end -->
			<%
		}
	}
}
%>