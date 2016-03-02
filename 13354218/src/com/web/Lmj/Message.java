package com.web.Lmj;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Message {
	private int message_id;
	private int from_user_id;
	private int to_user_id;
	private String content;
	private int rid;
	private int msg_type;
	private int has_read;
	private Timestamp create_time;
	
	
	public Message(){};
	public Message(ResultSet rs) throws SQLException{
		message_id = rs.getInt("message_id");
		content = rs.getString("content");
		to_user_id = rs.getInt("to_user_id");
		from_user_id = rs.getInt("from_user_id");
		create_time = rs.getTimestamp("create_time");
		rid = rs.getInt("rid");
		msg_type = rs.getInt("msg_type");
		has_read = rs.getInt("has_read");
	}
	

	public String getLocalCreateTime(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (create_time != null){
			return sdf.format(create_time);
		}
		return null;
	}
	public int getMessage_id() {
		return message_id;
	}
	public void setMessage_id(int message_id) {
		this.message_id = message_id;
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
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getRid() {
		return rid;
	}
	public void setRid(int rid) {
		this.rid = rid;
	}
	public int getMsg_type() {
		return msg_type;
	}
	public void setMsg_type(int msg_type) {
		this.msg_type = msg_type;
	}
	public int getHas_read() {
		return has_read;
	}
	public void setHas_read(int has_read) {
		this.has_read = has_read;
	}
	public Timestamp getCreate_time() {
		return create_time;
	}
	public void setCreate_time(Timestamp create_time) {
		this.create_time = create_time;
	}
}
