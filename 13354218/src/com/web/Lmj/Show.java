package com.web.Lmj;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Show {
	private int show_id;
	private int user_id;
	private String content;
	private int mode;
	private int comment_num;
	private Timestamp show_time;
	private int restriction;
	
	public Show(){};
	public Show(ResultSet rs) throws SQLException {
		user_id = rs.getInt("user_id");
		show_id = rs.getInt("show_id");
		content = rs.getString("content");
		mode = rs.getInt("mode");
		comment_num = rs.getInt("comment_num");
		show_time = rs.getTimestamp("show_time");
		restriction = rs.getInt("restriction");
	}

	public String getLocalShowTime(){
		return RelativeDateFormat.format(show_time);
		/*SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (show_time != null){
			return sdf.format(show_time);
		}
		return null;*/
	}
	
	public int getShow_id() {
		return show_id;
	}
	public void setShow_id(int show_id) {
		this.show_id = show_id;
	}
	public int getUser_id() {
		return user_id;
	}
	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getMode() {
		return mode;
	}
	public void setMode(int mode) {
		this.mode = mode;
	}
	public int getComment_num() {
		return comment_num;
	}
	public void setComment_num(int comment_num) {
		this.comment_num = comment_num;
	}
	public Timestamp getShow_time() {
		return show_time;
	}
	public void setShow_time(Timestamp show_time) {
		this.show_time = show_time;
	}
	public int getRestriction() {
		return restriction;
	}
	public void setRestriction(int restriction) {
		this.restriction = restriction;
	}
	
	
}
