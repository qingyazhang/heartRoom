<%@page import="com.web.Lmj.SessionCounter"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" errorPage="error.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>测试</title>
</head>
<body>
	That's OK!
	<p>在线人数：<%=SessionCounter.getActiveSessions()%></p>
</body>
</html>