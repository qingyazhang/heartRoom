<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.web.Lmj.User"%>
<%@page import="com.web.Lmj.Show"%>
<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/text; charset=utf-8"
	pageEncoding="utf-8" errorPage="error.jsp"%>

<%
	request.setCharacterEncoding("UTF-8");
	String ts = request.getParameter("show_id");
	String tn = request.getParameter("n");
	String from = request.getParameter("from");
	Integer user_id = (Integer)session.getAttribute("user_id");
	if (tn == null && user_id!=null) {
		int show_id = Utils.getInt(ts);
		if (from.equalsIgnoreCase("public")){
			Show show = DAO.getPublicShow(show_id); 
			if (show==null){
				out.println("发表失败");
				return;
			}
			User user = DAO.getUser(user_id);
			User showUser = DAO.getUser(show.getUser_id());
			int likeNum = DAO.getLikeShowNum(show.getShow_id()); 
			boolean hasLiked = DAO.hasLikedShow(user.getUser_id(), show.getShow_id());
			boolean hasPermission = user.getPermission()==0 || user.getUser_id()==show.getUser_id();
			String headPic = user.getPermission()==0||show.getMode()==0? showUser.getHead_pic() : "head_cat.jpg";
			String username = user.getPermission()==0||show.getMode()==0? showUser.getUsername() :"匿名";
			int showUserId = user.getPermission()==0||show.getMode()==0? showUser.getUser_id():0;
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
                       	<input type="text" class="public_show_comment_content" placeholder="有什么想说的？" name="content" />
                       	<a class="btn_public_show_push_comment" onclick="pushPublicShowComment(this);">评论</a>
                    </div>
                    <!-- 子评论 -->
                    <div class="div_public_show_subcomment" style="display:none;"></div>
                    <a class="btn_public_show_more_subcomment" onclick="loadMoreComment(this);" style="display:none;">查看更多...</a>
			    </div>
			</div>
			<%
		}else{//personal
			
			Show show = DAO.getPersonalShow(show_id, user_id); 
			if (show==null){
				out.println("发表失败"); 
				return;
			}
			
			User user = DAO.getUser(user_id);
			User showUser = DAO.getUser(show.getUser_id());
			int likeNum = DAO.getLikeShowNum(show.getShow_id()); 
			boolean hasLiked = DAO.hasLikedShow(user.getUser_id(), show.getShow_id());
			String headPic = show.getMode()==0? showUser.getHead_pic() : "head_cat.jpg";
			String username = show.getMode()==0? showUser.getUsername() :"匿名";
			%> 
            <div class="personal_show_container">
                <span class="show_id" style="display:none;"><%=show.getShow_id()%></span>
                <span class="show_user_id" style="display:none;"><%=show.getUser_id()%></span>
                <a class="personal_show_delete" style="display:;" onclick="deletePersonalShow(this);">X</a>
                <div class="personal_show_left">
                    <img src="../img/<%=user.getHead_pic()%>" class="personal_show_head_pic" />
                    <a class="personal_show_username" onclick="showPersonalShowUserInfo(this);"><%=user.getUsername()%></a>
                </div>
               <div class="personal_show_right">
                    <p class="personal_show_text"><%=show.getContent()%></p>
                    <div style="width:100%;"><span class="personal_show_like_text"><%=likeNum%> 个人赞了！
                    <select name="mode" class="personal_show_mode" onchange="personal_show_mode_change(this);">
                        <option value="0" <%=show.getMode()==0? "selected":""%>>公开</option>
                        <option value="1" <%=show.getMode()==1? "selected":""%>>公开匿名</option>
                        <option value="2" <%=show.getMode()==2? "selected":""%>>不公开</option>
                    </select>
                    </span><span class="personal_show_time"><%=show.getLocalShowTime()%></span></div>
                    <div style="clear:both;">
                        <img src="../img/like_left.png" class="personal_show_like_left <%=hasLiked?"public_show_like_has":""%>" onclick="pushPersonalShowLike(this);">
                        <a class="btn_personal_show_comment" onclick="showPersonalCommentDiv(this);">查看评论 <%=show.getComment_num()%></a>
                        <img src="../img/like_right.png" class="personal_show_like_right <%=hasLiked?"public_show_like_has":""%>" onclick="pushPersonalShowLike(this);">
                    </div>
                </div>
                <!-- 评论 -->
                <div class="personal_show_bottom">
                    <div class="div_personal_show_comment">
                        <input type="text" class="personal_show_comment_content"  placeholder="有什么想说的？" name="content" />
                        <a class="btn_personal_show_push_comment" onclick="pushPersonalShowComment(this);">评论</a>
                    </div>
                    <!-- 子评论 -->
                    <div class="div_personal_show_subcomment" style="display:none;"></div>
                    <a class="btn_personal_show_more_subcomment" onclick="loadMorePersonalComment(this);" style="display:none;">查看更多...</a>
			    </div>
			</div>
			<%
		}
	}else if (tn!=null && user_id!=null){//n
			int n = Utils.getInt(tn);
			if (from.equals("public")){
				String tld = request.getParameter("show_id");
				String turn = request.getParameter("turn");
				int show_id = 0;
				ArrayList<Show> shows;
				if (tld!=null && Utils.getInt(tld)!=0){
					show_id = Utils.getInt(tld);
					//System.out.println(show_id);
					if (turn.equalsIgnoreCase("next")){
						shows = DAO.getNextPublicShows(show_id, n);
					}else if (turn.equalsIgnoreCase("last")){
						shows = DAO.getLastPublicShows(show_id, n);
					}else{
						shows = DAO.getNewPublicShows(n);
					}
				}else{
					shows = DAO.getNewPublicShows(n);
				}
				for (Show show : shows){
					User user = DAO.getUser(user_id);
					User showUser = DAO.getUser(show.getUser_id());
					int likeNum = DAO.getLikeShowNum(show.getShow_id()); 
					boolean hasLiked = DAO.hasLikedShow(user_id, show.getShow_id());
					boolean hasPermission = user.getPermission()==0 || user.getUser_id()==show.getUser_id();
					String headPic = user.getPermission()==0||show.getMode()==0? showUser.getHead_pic() : "head_cat.jpg";
					String username = user.getPermission()==0||show.getMode()==0? showUser.getUsername() :"匿名";
					int showUserId = user.getPermission()==0||show.getMode()==0? showUser.getUser_id():0;
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
	                        	<input type="text" class="public_show_comment_content" placeholder="有什么想说的？"  name="content" />
	                        	<a class="btn_public_show_push_comment" onclick="pushPublicShowComment(this);">评论</a>
		                    </div>
		                    <!-- 子评论 -->
		                    <div class="div_public_show_subcomment" style="display:none;"></div>
		                    <a class="btn_public_show_more_subcomment" onclick="loadMoreComment(this);" style="display:none;">查看更多...</a>
					    </div>
					</div>
					<%
				}
			}else{//personal
				String tld = request.getParameter("show_id");
				String turn = request.getParameter("turn");
				int show_id = 0;
				ArrayList<Show> shows;
				if (tld!=null && Utils.getInt(tld)!=0){
					show_id = Utils.getInt(tld);
					//System.out.println(show_id);
					if (turn.equalsIgnoreCase("next")){
						shows = DAO.getNextPersonalShows(show_id, n, user_id);
					}else if (turn.equalsIgnoreCase("last")){
						shows = DAO.getLastPersonalShows(show_id, n, user_id);
					}else{
						shows = DAO.getNewPersonalShows(n, user_id);
					}
				}else{
					shows = DAO.getNewPersonalShows(n, user_id);
				}
				for (Show show : shows){
					User user = DAO.getUser(user_id);
					User showUser = DAO.getUser(show.getUser_id());
					int likeNum = DAO.getLikeShowNum(show.getShow_id()); 
					boolean hasLiked = DAO.hasLikedShow(user_id, show.getShow_id()); 
					%> 
					 <div class="personal_show_container">
	                <span class="show_id" style="display:none;"><%=show.getShow_id()%></span>
	                <span class="show_user_id" style="display:none;"><%=show.getUser_id()%></span>
	                <a class="personal_show_delete" style="display:;" onclick="deletePersonalShow(this);">X</a>
	                <div class="personal_show_left">
	                    <img src="../img/<%=user.getHead_pic()%>" class="personal_show_head_pic" />
	                    <a class="personal_show_username" onclick="showPersonalShowUserInfo(this);"><%=user.getUsername()%></a>
	                </div>
	               <div class="personal_show_right">
	                    <p class="personal_show_text"><%=show.getContent()%></p>
	                    <div style="width:100%;"><span class="personal_show_like_text"><%=likeNum%> 个人赞了！
	                    <select name="mode" class="personal_show_mode" onchange="personal_show_mode_change(this);">
	                        <option value="0" <%=show.getMode()==0? "selected":""%>>公开</option>
	                        <option value="1" <%=show.getMode()==1? "selected":""%>>公开匿名</option>
	                        <option value="2" <%=show.getMode()==2? "selected":""%>>不公开</option>
	                    </select>
	                    </span><span class="personal_show_time"><%=show.getLocalShowTime()%></span></div>
	                    <div style="clear:both;">
	                        <img src="../img/like_left.png" class="personal_show_like_left <%=hasLiked?"public_show_like_has":""%>" onclick="pushPersonalShowLike(this);">
	                        <a class="btn_personal_show_comment" onclick="showPersonalCommentDiv(this);">查看评论 <%=show.getComment_num()%></a>
	                        <img src="../img/like_right.png" class="personal_show_like_right <%=hasLiked?"public_show_like_has":""%>" onclick="pushPersonalShowLike(this);">
	                    </div>
	                </div>
	                <!-- 评论 -->
	                <div class="personal_show_bottom">
	                    <div class="div_personal_show_comment">
	                        <input type="text" class="personal_show_comment_content" placeholder="有什么想说的？"  name="content" />
	                        <a class="btn_personal_show_push_comment" onclick="pushPersonalShowComment(this);">评论</a>
	                    </div>
	                    <!-- 子评论 -->
	                    <div class="div_personal_show_subcomment" style="display:none;"></div>
	                    <a class="btn_personal_show_more_subcomment" onclick="loadMorePersonalComment(this);" style="display:none;">查看更多...</a>
				    </div>
				</div>
					<%
				}	
		}
	}
%>