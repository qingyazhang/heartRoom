<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
int code = 0;
String msg = "没有权限";
String t = request.getParameter("user_id");
int user_id = Utils.getInt(t);
if (t!=null){
	int permission = Utils.getInt(session.getAttribute("permission").toString());
	if (DAO.getPermissionByUserId(user_id)==0){
		msg = "你不能屏蔽管理员！";
	}else if (permission == 0){
		int hasSheild = DAO.getRestriction(user_id);
		if (hasSheild==0){
			boolean flag = DAO.shieldUser(user_id);
			if (flag){
				code = 1;
				msg = "屏蔽成功！"; 
				DAO.insertMessage(1, user_id, "不幸的你被管理员屏蔽了哦...", 0, 5);
			}else{
				msg = "屏蔽失败！";
			}
		}else{
			boolean flag = DAO.unShieldUser(user_id);
			if (flag){
				code = 1;
				DAO.insertMessage(1, user_id, "幸运的你被管理员解除屏蔽了哦...", 0, 5);
				msg = "取消屏蔽成功！";
			}else{
				msg = "取消屏蔽失败！";
			}
		}
	}
}
%>
    
<user>
	<code><%=code%></code>
	<msg><%=msg%></msg>
</user>