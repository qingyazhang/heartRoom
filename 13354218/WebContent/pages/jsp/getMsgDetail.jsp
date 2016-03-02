<%@page import="com.web.Lmj.User"%>
<%@page import="com.web.Lmj.Show"%>
<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Message"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
String t = request.getParameter("message_id");
Integer user_id = (Integer)session.getAttribute("user_id");
if (t!=null && user_id!=null){
	int message_id = Utils.getInt(t);
	Message message = DAO.getMessage(message_id);
	Integer show_id = null;
	System.out.println(message_id);
	switch(message.getMsg_type()){
	case 1:
	case 6:
		show_id = message.getRid();
		break;
	case 2:
	case 3:
	case 4:
		Integer comment_id = message.getRid();
		show_id = DAO.getShowIdByCommentId(comment_id);
		break;
	case 5:
		
		break;
	}
	System.out.println(message.getRid());
	if (show_id!=null){
		Show show = DAO.getShow(show_id);
		
		User user = DAO.getUser(user_id);
		User showUser = DAO.getUser(show.getUser_id());
		int likeNum = DAO.getLikeShowNum(show.getShow_id()); 
		boolean hasLiked = DAO.hasLikedShow(user.getUser_id(), show.getShow_id());
		boolean hasPermission = user.getPermission()==0 || user.getUser_id()==show.getUser_id();
		String headPic = show.getMode()==0? showUser.getHead_pic() : "head_cat.jpg";
		String username = show.getMode()==0? showUser.getUsername() :"匿名";
		int showUserId = show.getMode()==0? showUser.getUser_id():0;
		%> 
		<div class="public_show_container"> 
		    <span class="show_id" style="display:none;"><%=show.getShow_id()%></span>
		    <span class="show_user_id" style="display:none;"><%=showUserId%></span>
		    <%=hasPermission? "<a class=\"public_show_delete\" onclick=\"deletePublicShow(this);\">X</a>":""%>
		    <div class="public_show_left">
		        <img src="../img/<%=headPic%>" class="public_show_head_pic" />
		        <a class="public_show_username" onclick="showPublicShowUserInfo(this);"><%=username%></a>
		    </div>
		   <div class="public_show_right">
		        <p class="public_show_text"><%=show.getContent()%></p>
		        <div style="width:100%;"><span class="publie_show_like_text"><%=likeNum%> 个人赞了！</span><span class="public_show_time"><%=show.getLocalShowTime()%></span></div>
		        <img src="../img/like_left.png" class="public_show_like_left <%=hasLiked?"public_show_like_has":""%>" onclick="pushPublicShowLike(this);">
		        <a class="btn_public_show_comment" onclick="showPublicCommentDiv(this);">查看评论 <%=show.getComment_num()%></a>
		        <img src="../img/like_right.png" class="public_show_like_right <%=hasLiked?"public_show_like_has":""%>" onclick="pushPublicShowLike(this);">
		    </div>
		    <div class="public_show_bottom">
		    	<div class="div_public_show_comment">
                   	<input type="text" class="public_show_comment_content" name="content" />
                   	<a class="btn_public_show_push_comment" onclick="pushPublicShowComment(this);">评论</a>
                </div>
                <!-- 子评论 -->
                <div class="div_public_show_subcomment" style="display:none;"></div>
                <a class="btn_public_show_more_subcomment" onclick="loadMoreComment(this);" style="display:none;">查看更多...</a>
		    </div>
		</div>
		<%
	}
}

%>