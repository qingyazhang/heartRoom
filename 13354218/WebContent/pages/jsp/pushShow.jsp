<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/text; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

    
<%
request.setCharacterEncoding("UTF-8");

boolean post = request.getMethod().equalsIgnoreCase("post");
Integer user_id = (Integer)session.getAttribute("user_id");
if (post && user_id!=null){
	String content = request.getParameter("content");
	int mode = Utils.getInt(request.getParameter("mode"));
	Integer show_id = null;
	if (DAO.getRestriction(user_id)==1){
		out.println("你已经被屏蔽了哦...");
	}else{
		show_id = DAO.insertShow(user_id, content, mode);
	}
	
	if (show_id!=null){
		String from = request.getParameter("from");
		if (from==null){
			out.println("发表成功!");
		}else{
			%>
			<jsp:forward page="getShow.jsp">
				<jsp:param value="<%=show_id%>" name="show_id"/>
				<jsp:param value="<%=from%>" name="from"/>
			</jsp:forward>
			<%
		}
	}
}
%>

