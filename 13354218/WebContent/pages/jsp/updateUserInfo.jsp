<%@page import="java.net.URLEncoder"%>
<%@page import="com.web.Lmj.User"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItem"%>
<%@page import="com.web.Lmj.DAO"%>
<%@page import="com.web.Lmj.Utils"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.awt.ItemSelectable"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.*"%>
<%@ page language="java" contentType="text/xml; charset=utf-8"
	pageEncoding="utf-8" errorPage="error.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
	int code = 0;
	String msg = "修改失败！";
	String username = "暂无名氏";
	String signature = "你不觉得下面两个按钮很好玩吗？";
	String head_pic = "head_user.gif";
	String music = "InThere.mp3";
	int sex = 0;
	int age = 20;
	String email = "";
	int cp = 0;
	String oldPassword = "";
	String newPassword = "";
	Integer user_id = (Integer)session.getAttribute("user_id");
	User user = DAO.getUser(user_id);
	
	//head_pic = URLDecoder.decode(user.getHead_pic(), "UTF-8");
	//music = URLDecoder.decode(user.getMusic(), "UTF-8");
	head_pic = user.getHead_pic();
	music = user.getMusic();
	//request.setCharacterEncoding("GB2312");
	boolean post = request.getMethod().equalsIgnoreCase("post");
	if (post && user_id!=null) {
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);//检查表单中是否包含文件
		if (isMultipart) {
			 
			 FileItemFactory factory = new DiskFileItemFactory();
			//factory.setSizeThreshold(yourMaxMemorySize); 此处可设置使用的内存最大值
			//factory.setRepository(yourTempDirectory); 文件临时目录
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setHeaderEncoding("UTF-8");//解决http报头乱码，即中文文件名乱码
			//upload.setSizeMax(yourMaxRequestSize);允许的最大文件尺寸
			
			try{
				@SuppressWarnings("unchecked")
				List<FileItem> items = (ArrayList<FileItem>)upload.parseRequest(request);
				//List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
				
				for (FileItem item : items) {
					if (item.isFormField()) {
						String name = item.getFieldName();
						String value = item.getString("UTF-8");
						System.out.println(name+" "+value);
						if (name.equals("username")){
							username = value;
							if(username==null || username.isEmpty()){
								msg = "修改失败，用户名不能为空！";
								break;
							}
						}else if (name.equals("signature")){
							signature = value;
						}else if (name.equals("sex")){
							sex = Utils.getInt(value);
						}else if (name.equals("age")){
							age = Utils.getInt(value);
						}else if (name.equals("email")){
							email = value;
							if (email == null || email.isEmpty()){
								msg = "修改失败，邮箱不能为空!";
								break;
							}else if (!Utils.isEmail(email)){
								msg = "修改失败，邮箱格式错误!";
								break;
							}
						}else if (name.equals("cp")){
							cp = Utils.getInt(value);
							System.out.println("cp");
						}else if (name.equals("old_password")){
							oldPassword = value;
						}else if (name.equals("new_password")){
							newPassword = value;
							if (newPassword == null || newPassword.isEmpty() || newPassword.length()!=32){
								msg = "修改失败，新密码不合规范！";
								break;
							}
						}
					} else {
						String fileName = item.getName();
						if (fileName.isEmpty()){
							continue;
						}
						//fileName = user_id+"_"+fileName;
						fileName = user_id+"_"+fileName;
						DiskFileItem dfi = (DiskFileItem)item;
	 					String path = new File(application.getRealPath("/pages/img")
								+System.getProperty("file.separator")
								+FilenameUtils.getName(fileName)).getAbsolutePath(); 
	 					//System.out.println(path);
	 					//System.out.println(fileName);
						if (item.getContentType().startsWith("image")){
							String filePath = application.getRealPath("/pages/img")
									+ System.getProperty("file.separator")
									+ FilenameUtils.getName(fileName);
							File file = new File(filePath);
							dfi.write(file); 
							head_pic = fileName;
							
						}else{
							String filePath = application.getRealPath("/pages/music")
							+ System.getProperty("file.separator")
							+ FilenameUtils.getName(fileName);
							File file = new File(filePath);
							dfi.write(file); 
							music = fileName;
						}
	 					
					}
				}
			}catch(Exception e){
				msg = "修改失败！文件上传错误！";
			}
			//
			boolean flag = DAO.updateUserInfo(user_id, username, signature, head_pic, music, age, sex, email);
			if (!flag){
				msg = "修改用户信息失败！";
			}else if (cp==1){
				session.setAttribute("username", username);
				flag = DAO.resetPassword(user_id, oldPassword, newPassword);
				if (!flag){
					code = -1;
					msg = "修改用户信息成功，但修改密码失败！";
				}else{
					code = 1;
					msg = "修改用户信息和密码成功！";
				}
			}else{
				code = 1;
				msg = "修改成功！";
			}
		}else{
			System.out.println("不是文件");
		}

	}
%>
<updateUserInfo>
	<code><%=code%></code>
	<msg><%=msg%></msg>
	<username><%=username%></username>
	<signature><%=signature%></signature>
	<head_pic><%=URLEncoder.encode(head_pic, "UTF-8")%></head_pic>
	<music><%=music%></music>
</updateUserInfo>