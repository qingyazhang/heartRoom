package com.web.Lmj;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Comment {
	private int comment_id;
	private String content;
	private int comment_num;
	private int belong_show;
	private Timestamp comment_time;
	private int type;
	
	private int from_user_id;
	private int to_user_id;
	
	public Comment(){};
	public Comment(ResultSet rs) throws SQLException {
		comment_id = rs.getInt("comment_id");
		content = rs.getString("content");
		comment_num = rs.getInt("comment_num");
		comment_time = rs.getTimestamp("comment_time");
		belong_show = rs.getInt("belong_show");
		type = rs.getInt("type");
		//System.out.println("test");
		//System.out.println(comment_id);
		from_user_id = DAO.getFromUserIdByCommentId(comment_id);
		//System.out.println("test1");
		to_user_id = DAO.getToUserIdByCommentId(comment_id);
		//System.out.println("test2");
	}
	public String getLocalCommentTime(){
		return RelativeDateFormat.format(comment_time);
/*		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (comment_time != null){
			return sdf.format(comment_time);
		}
		return null;*/
	}
	
	public int getComment_id() {
		return comment_id;
	}
	public void setComment_id(int comment_id) {
		this.comment_id = comment_id;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getComment_num() {
		return comment_num;
	}
	public void setComment_num(int comment_num) {
		this.comment_num = comment_num;
	}
	public int getBelong_show() {
		return belong_show;
	}
	public void setBelong_show(int belong_show) {
		this.belong_show = belong_show;
	}
	public Timestamp getComment_time() {
		return comment_time;
	}
	public void setComment_time(Timestamp comment_time) {
		this.comment_time = comment_time;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getFrom_user_id() {
		return from_user_id;
	}
	public void setFrom_user_id(int from_user_id) {
		this.from_user_id = from_user_id;
	}
	public int getTo_user_id() {
		return to_user_id;
	}
	public void setTo_user_id(int to_user_id) {
		this.to_user_id = to_user_id;
	}
	
	
	
}
