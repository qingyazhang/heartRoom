<%@page import="sun.applet.resources.MsgAppletViewer"%>
<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Message"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
Integer user_id = (Integer)session.getAttribute("user_id");
String type = request.getParameter("type");
if (user_id != null && type!=null){
	ArrayList<Message> messages = null;
	if (type.equalsIgnoreCase("new")){
		messages = DAO.getUnreadMessages(user_id);
	}else if (type.equalsIgnoreCase("old")){
		int message_id = Utils.getInt(request.getParameter("message_id"));
		int n = Utils.getInt(request.getParameter("n"));
		if (message_id == 0){
			message_id = 0x3f3f3f3f;
		}
		messages = DAO.getNextMessages(user_id, message_id, n);
	}
	System.out.println("message size:"+messages.size());
	for (Message message : messages){
		String fromName = DAO.getUsernameByUserId(message.getFrom_user_id());
		String detail = (message.getMsg_type()==0 || message.getMsg_type()==5)? "none" : "";
		String content = message.getContent();
		boolean flag = false;
		String tmp;
		switch(message.getMsg_type()){
		case 1:
		case 6:
			Integer show_id = message.getRid();
			tmp = DAO.getContentByShowId(show_id);
			if (tmp==null){
				flag = true;
				break;
			}
			content += ": "+tmp;
			break;
		case 2:
		case 3:
		case 4:
			Integer comment_id = message.getRid();
			tmp = DAO.getContentByCommentId(comment_id);
			if (tmp == null){
				flag = true;
				break;
			}
			content += ": "+tmp;
			break;
		case 5:
			
			break;
		}
		if (flag){
			DAO.deleteMsg(message.getMessage_id());
			continue;
		}
		%>
        <!-- one news begin -->
        <div class="div_me_news_subcontainer">
            <span class="message_id" style="display:none;"><%=message.getMessage_id() %></span>
            <span class="msg_type" style="display:none;"><%= message.getMsg_type()%></span>
            <span class="from_user_id" style="display:none;"><%= message.getFrom_user_id()%></span>
            <span class="btn_news_delete" onclick="deleteNews(this);">X</span>
            <span class="<%=message.getHas_read()==0?"btn_news_has_unread":"btn_news_has_read" %>" onclick="<%= message.getHas_read()==0?"setHasRead(this);":""%>"><%=message.getHas_read()==0?"标记为已读":"已读" %></span>
            <p class="news_title">于 <span class="news_time"><%=message.getLocalCreateTime() %></span> from <span class="news_from_user" onclick="showNewsFromUser(this);"><%=fromName %></span></p>
            <p class="news_content"><%= content%></p>
            <a class="btn_news_detail" style="display:<%=detail %>;" onclick="jumpNewsDetail(this);">查看详细</a>
        </div>
        <!-- one news end -->
		<%
	}
}


%>