package com.web.Lmj;


import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.sun.org.apache.bcel.internal.generic.NEW;

public class User {
	private int user_id = 0;
	private String username = "暂无名氏";
	private int permission = 1;
	private String email = "user@user.com";
	private int sex = 0; 
	private int age = 21;
	private String head_pic = "head_user.gif";
	private String signature = "下面这两个按钮长得好好玩呀...";
	private String music = "InThere.mp3";
	private Timestamp reg_time = new Timestamp(new Date().getTime());
	private int restriction = 0;
	
	public User(){};
	public User(ResultSet rs) throws SQLException{
		user_id = rs.getInt("user_id");
		username = rs.getString("username");
		permission = rs.getInt("permission");
		email = rs.getString("email");
		sex = rs.getInt("sex");
		age = rs.getInt("age");
		head_pic = rs.getString("head_pic");
		signature = rs.getString("signature");
		music = rs.getString("music");
		reg_time = rs.getTimestamp("reg_time");
		restriction = rs.getInt("restriction");
		
		head_pic = head_pic==null? "head_user.gif" : head_pic;
		signature = signature==null? "天好冷，人更冷，手已经没感觉..." : signature;
		music = music==null? "往日时光.mp3" : music;
	}
	
	public String getLocalSex(){
		return sex==0? "男" : "女";
	}
	public String getLocalRegTime(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (reg_time != null){
			return sdf.format(reg_time);
		}else{
			sdf.format(new Date());
		}
		return null;
	}
	
	
	public int getUser_id() {
		return user_id;
	}
	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public int getPermission() {
		return permission;
	}
	public void setPermission(int permission) {
		this.permission = permission;
	}
	public int getSex() {
		return sex;
	}
	public void setSex(int sex) {
		this.sex = sex;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public String getHead_pic() {
		try {
			return URLEncoder.encode(head_pic, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "head_benbaobao5.jpg";
	}
	public void setHead_pic(String head_pic) {
		this.head_pic = head_pic;
	}
	public String getSignature() {
		return signature;
	}
	public void setSignature(String signature) {
		this.signature = signature;
	}
	public String getMusic() {
		try {
			//return URLEncoder.encode(music, "UTF-8");
			return music;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "head_benbaobao5.jpg";
	}
	public void setMusic(String music) {
		this.music = music;
	}
	public Timestamp getReg_time() {
		return reg_time;
	}
	public void setReg_time(Timestamp reg_time) {
		this.reg_time = reg_time;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getRestriction() {
		return restriction;
	}
	public void setRestriction(int restriction) {
		this.restriction = restriction;
	}
	
	
}
