package com.web.Lmj;

import java.sql.*;
import java.util.ArrayList;

public class DAO {
	private static MySQLPool pool = MySQLPool.getInstance();

	/************************************* 账户相关 ***************************************************/
	public static User login(String username, String password) {
		User user = null;
		Connection conn = pool.getConnection();
		try {
			Statement stmt = conn.createStatement(); // 建立语句
			String sql = "select * from Users where username='" + username
					+ "' and password='" + password + "';";
			ResultSet rs = stmt.executeQuery(sql);
			if (rs.next()) {
				user = new User(rs);
				return user;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return user;
	}
	public static User getUser(int user_id){
		User user = null;
		Connection conn = pool.getConnection();
		try {
			Statement stmt = conn.createStatement(); // 建立语句
			String sql = "select * from Users where user_id='" + user_id
					+ "';";
			ResultSet rs = stmt.executeQuery(sql);
			if (rs.next()) {
				user = new User(rs);
				return user;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return user;
	}
	public static User getUser(String username) {
		User user = null;
		Connection conn = pool.getConnection();
		try {
			Statement stmt = conn.createStatement(); // 建立语句
			String sql = "select * from Users where username='" + username
					+ "';";
			ResultSet rs = stmt.executeQuery(sql);
			if (rs.next()) {
				user = new User(rs);
				return user;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return user;
	}
	public static boolean shieldUser(int user_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "update Users set restriction=1 where user_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean unShieldUser(int user_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "update Users set restriction=0 where user_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean changeShowMode(int show_id, int mode) {
		Connection conn = pool.getConnection();
		try {
			String sql = "update Shows set mode=? where show_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, mode);
			pStatement.setInt(2, show_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static Integer getRestriction(int user_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select restriction from Users where user_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt("restriction");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Integer getSheildNum(int user_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select count(*) from Shows where user_id=? and restriction=1 limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	/************************************* Session相关 ***************************************************/
	// 判断是否存在session_id
	public static boolean existsSessionId(String session_id) {
		Connection conn = pool.getConnection();
		try {
			Statement stmt = conn.createStatement(); // 建立语句
			String sql = "select * from Sessions where session_id='"
					+ session_id + "';";
			ResultSet rs = stmt.executeQuery(sql);
			return rs.next();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	// 判断session是否有效
	public static boolean isValidSession(String session_id, int user_id) {
		deleteInvalidSession();
		Connection conn = pool.getConnection();
		try {
			String sql = "select * from Sessions where session_id=? and user_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setString(1, session_id);
			pStatement.setInt(2, user_id);
			ResultSet rs = pStatement.executeQuery();
			return rs.next();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	//删除过期session
	public static int deleteInvalidSession(){
		Connection conn = pool.getConnection();
		try {
			String sql = "delete from Sessions where valid_time<?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setLong(1, new java.util.Date().getTime());
			int rows = pStatement.executeUpdate();
			return rows;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return 0;
	}
	//通过user_id删除session
	public static int deleteSessionByUserId( int user_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "delete from Sessions where user_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			int rows = pStatement.executeUpdate();
			return rows;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return 0;
	}
	//插入7天session
	public static String insertSession(String session_id, int user_id, int days){
		session_id = Utils.shuffleString(session_id);
		while(existsSessionId(session_id)){
			session_id = Utils.shuffleString(session_id);
		}
		
		deleteSessionByUserId(user_id);
		System.out.println(session_id);
		Connection conn = pool.getConnection();
		try {
			String sql = "insert into Sessions(session_id, user_id, valid_time) values(?, ?, ?);";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setString(1, session_id);
			pStatement.setInt(2, user_id);
			pStatement.setTimestamp(3, new Timestamp(new java.util.Date().getTime()+days*24*60*60*1000));
			pStatement.executeUpdate();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return session_id;
	}
	/************************************* User相关 ***************************************************/
	// 通过username判断是否存在用户
	public static boolean existsUser(String username) {
		Connection conn = pool.getConnection();
		try {
			Statement stmt = conn.createStatement(); // 建立语句
			String sql = "select user_id from Users where username='"
					+ username + "';";
			ResultSet rs = stmt.executeQuery(sql);
			return rs.next();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}

	// 通过user_id判断是否存在用户
	public static boolean existsUser(int user_id) {
		Connection conn = pool.getConnection();
		try {
			Statement stmt = conn.createStatement(); // 建立语句
			String sql = "select username from Users where user_id='" + user_id
					+ "';";
			ResultSet rs = stmt.executeQuery(sql);
			return rs.next();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}

	// 通过user_id查找username
	public static String getUsernameByUserId(Integer user_id) {
		Connection conn = pool.getConnection();
		try {
			Statement stmt = conn.createStatement(); // 建立语句
			String sql = "select username from Users where user_id='" + user_id
					+ "';";
			ResultSet rs = stmt.executeQuery(sql);
			if (rs.next()) {
				return rs.getString("username");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Integer getPermissionByUserId(Integer user_id) {
		Connection conn = pool.getConnection();
		try {
			Statement stmt = conn.createStatement(); // 建立语句
			String sql = "select permission from Users where user_id='" + user_id
					+ "';";
			ResultSet rs = stmt.executeQuery(sql);
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return 1;
	}
	// 通过username查找user_id
	public static Integer getUserIdByUsername(String username) {
		Connection conn = pool.getConnection();
		try {
			Statement stmt = conn.createStatement(); // 建立语句
			String sql = "select user_id from Users where username='"
					+ username + "';";
			ResultSet rs = stmt.executeQuery(sql);
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}

	// 插入一个用户
	public static Integer insertUser(String username, String password, String email, int sex) {
		Connection conn = pool.getConnection();
		try {
			String sql = "insert into Users(username, password, email, sex) values(?, ?, ?, ?);";
			PreparedStatement pStatement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			pStatement.setString(1, username);
			pStatement.setString(2, password);
			pStatement.setString(3, email);
			pStatement.setInt(4, sex);
			pStatement.executeUpdate();
			ResultSet rs = pStatement.getGeneratedKeys();  
			if (rs.next()){
				return rs.getInt(1);
			}else{
				return null;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	//修改密码
	public static boolean resetPassword(String username, String password, String email) {
		Connection conn = pool.getConnection();
		try {
			String sql = "update Users set password=? where username=? and email=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setString(1, password);
			pStatement.setString(2, username);
			pStatement.setString(3, email);
			int cnt = pStatement.executeUpdate();
			return cnt>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	//修改密码
	public static boolean resetPassword(int user_id, String oldPassword, String newPassword) {
		Connection conn = pool.getConnection();
		try {
			String sql = "update Users set password=? where user_id=? and password=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setString(1, newPassword);
			pStatement.setInt(2, user_id);
			pStatement.setString(3, oldPassword);
			int cnt = pStatement.executeUpdate();
			return cnt>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	//更新用户信息
	public static boolean updateUserInfo(int user_id, String username, String signature, String head_pic, String music, int age, int sex, String email) {
		Connection conn = pool.getConnection();
		try {
			String sql = "update Users set username=?, signature=?, head_pic=?, music=?, age=?, sex=?, email=? where user_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setString(1, username);
			pStatement.setString(2, signature);
			pStatement.setString(3, head_pic);
			pStatement.setString(4, music);
			pStatement.setInt(5, age);
			pStatement.setInt(6, sex);
			pStatement.setString(7, email);
			pStatement.setInt(8, user_id);
			int cnt = pStatement.executeUpdate();
			return cnt>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	/************************************* Show相关 ***************************************************/
	// 插入一个show
	public static Integer insertShow(int user_id, String content, int mode) {
		Connection conn = pool.getConnection();
		try {
			String sql = "insert into Shows(user_id, content, mode) values(?, ?, ?);";
			PreparedStatement pStatement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			pStatement.setInt(1, user_id);
			pStatement.setString(2, content);
			pStatement.setInt(3, mode);
			pStatement.executeUpdate();
			ResultSet rs = pStatement.getGeneratedKeys();  
			if (rs.next()){
				return rs.getInt(1);
			}else{
				return null;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Integer getUserIdByShowId(int show_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select user_id from Shows where show_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt("user_id");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static String getContentByShowId(int show_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select content from Shows where show_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static String getContentByCommentId(int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select content from Comments where comment_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Show getPublicShow(int show_id) {
		Show show = null;
		Connection conn = pool.getConnection();
		try {
			String sql = "select * from Shows where show_id=? and restriction=0 and mode!=2;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				show = new Show(rs); 
				return show;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return show;
	}
	public static Show getPersonalShow(int show_id, int user_id) {
		Show show = null;
		Connection conn = pool.getConnection();
		try {
			String sql = "select * from Shows where show_id=? and user_id=? and restriction=0;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			pStatement.setInt(2, user_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				show = new Show(rs); 
				return show;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return show;
	}
	public static ArrayList<Show> getLastPublicShows(int show_id, int n) {
		ArrayList<Show> shows = new ArrayList<Show>();
		//last_show_id -= n;
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Shows where show_id>? and restriction=0 and mode!=2 order by show_time desc limit ?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			pStatement.setInt(2, n);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Show show = new Show(rs); 
				shows.add(show);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return shows;
	}
	public static ArrayList<Show> getNextPublicShows(int show_id, int n) {
		ArrayList<Show> shows = new ArrayList<Show>();
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Shows where show_id<? and restriction=0 and mode!=2 order by show_time desc limit ?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			pStatement.setInt(2, n);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Show show = new Show(rs); 
				shows.add(show);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return shows;
	}
	public static ArrayList<Show> getNewPublicShows(int n) {
		ArrayList<Show> shows = new ArrayList<Show>();
		//last_show_id -= n;
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Shows where restriction=0 and mode!=2 order by show_time desc limit ?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, n);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Show show = new Show(rs); 
				shows.add(show);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return shows;
	}
	public static ArrayList<Show> getLastPersonalShows(int show_id, int n, int user_id) {
		ArrayList<Show> shows = new ArrayList<Show>();
		//last_show_id -= n;
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Shows where show_id>? and user_id=? and restriction=0 order by show_time desc limit ?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			pStatement.setInt(2, user_id);
			pStatement.setInt(3, n);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Show show = new Show(rs); 
				shows.add(show);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return shows;
	}
	public static ArrayList<Show> getNextPersonalShows(int show_id, int n, int user_id) {
		ArrayList<Show> shows = new ArrayList<Show>();
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Shows where show_id<?  and user_id=? and restriction=0 order by show_time desc limit ?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			pStatement.setInt(2, user_id);
			pStatement.setInt(3, n);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Show show = new Show(rs); 
				shows.add(show);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return shows;
	}
	public static ArrayList<Show> getNewPersonalShows(int n, int user_id) {
		ArrayList<Show> shows = new ArrayList<Show>();
		//last_show_id -= n;
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Shows where restriction=0  and user_id=?  order by show_time desc limit ?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			pStatement.setInt(2, n);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Show show = new Show(rs); 
				shows.add(show);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return shows;
	}
	public static int getLikeShowNum(int show_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select count(*) from LikeShows where to_show_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return 0;
	}
	public static boolean hasLikedShow(int user_id, int show_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select * from LikeShows where from_user_id=? and to_show_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			pStatement.setInt(2, show_id);
			ResultSet rs = pStatement.executeQuery();
			return rs.next();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean insertLikeShow(int user_id, int show_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "insert into LikeShows(from_user_id, to_show_id) values(?, ?);";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			pStatement.setInt(2, show_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean deleteLikeShow(int user_id, int show_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "delete from LikeShows where from_user_id=? and to_show_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			pStatement.setInt(2, show_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean deleteShow(int show_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "delete from Shows where show_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean shieldShow(int show_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "update Shows set restriction=1 where show_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	

	
	//评论相关
	public static Integer insertComment(String content, int to_show_id, int type) {
		Connection conn = pool.getConnection();
		try {
			String sql = "insert into Comments(content, belong_show, type) values(?, ?, ?);";
			PreparedStatement pStatement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			pStatement.setString(1, content);
			pStatement.setInt(2, to_show_id);
			pStatement.setInt(3, type);
			pStatement.executeUpdate();
			ResultSet rs = pStatement.getGeneratedKeys();  
			if (rs.next()){
				return rs.getInt(1);
			}else{
				return null;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static boolean insertCommentShow(int from_user_id, int to_show_id, int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "insert into CommentShows(from_user_id, to_show_id, comment_id) values(?, ?, ?);";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, from_user_id);
			pStatement.setInt(2, to_show_id);
			pStatement.setInt(3, comment_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	
	public static Comment getPublicShowComment(int comment_id) {
		Comment comment = null;
		Connection conn = pool.getConnection();
		try {
//			String sql = "select * from Comments, CommentShows, Shows where Comments.comment_id=CommentShows.comment_id and CommentShows.to_show_id=Shows.show_id and Comments.comment_id=? limit 1;";
			String sql = "select * from Comments where comment_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				comment = new Comment(rs); 
				return comment;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return comment;
	}
	public static int getLikeCommentNum(int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select count(*) from LikeComments where to_comment_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return 0;
	}
	public static boolean hasLikedComment(int user_id, int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select * from LikeComments where from_user_id=? and to_comment_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			pStatement.setInt(2, comment_id);
			ResultSet rs = pStatement.executeQuery();
			return rs.next();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static ArrayList<Comment> getNewShowComments(int show_id, int n) {
		ArrayList<Comment> comments = new ArrayList<Comment>();
		Connection conn = pool.getConnection();
		try { 
			//String sql = "select * from Comments, CommentShows, Shows where Comments.belong_show=? and Comments.comment_id=CommentShows.comment_id and CommentShows.to_show_id=Shows.show_id order by Comments.comment_id desc limit ?;";
			String sql = "select * from Comments where belong_show=? order by comment_id desc limit ?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			pStatement.setInt(2, n);
			ResultSet rs = pStatement.executeQuery();
			
			while (rs.next()) {
				Comment comment = new Comment(rs); 
				comments.add(comment);
			}
			
		} catch (Exception e) {
			System.out.println(e.getMessage()+"11");
		} finally {
			pool.releaseConnection(conn);
		}
		return comments;
	}
	
	public static ArrayList<Comment> getNextShowComments(int show_id, int comment_id, int n) {
		ArrayList<Comment> comments = new ArrayList<Comment>();
		Connection conn = pool.getConnection();
		try { 
			//String sql = "select * from Comments, CommentShows, Shows where Comments.belong_show=? and Comments.comment_id<? and Comments.comment_id=CommentShows.comment_id and CommentShows.to_show_id=Shows.show_id order by Comments.comment_id desc limit ?;";
			String sql = "select * from Comments where comment_id<? order by comment_time desc limit ?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			pStatement.setInt(2, n);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Comment comment = new Comment(rs); 
				comments.add(comment);
			}
		} catch (Exception e) {
			//System.out.println(comments.size());
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return comments;
	}
	public static boolean incShowCommentNum(int show_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "update Shows set comment_num=comment_num+1 where show_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean decShowCommentNum(int show_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "update Shows set comment_num=comment_num-1 where show_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static Integer getShowUserIdByCommentId(int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select user_id from Shows, Comments where Comments.comment_id=? and Shows.show_id=Comments.belong_show limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt("user_id");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Integer getFromUserIdByCommentId(int comment_id) {
		Connection conn = pool.getConnection();
		try {
			int type = getCommentType(comment_id);
			String sql = "";
			//System.out.println("type:"+type);
			if (type == 0){
				sql = "select from_user_id from Comments, CommentShows where Comments.comment_id=? and CommentShows.comment_id=Comments.comment_id limit 1;";
			}else{
				sql = "select from_user_id from Comments, ReplyComments where Comments.comment_id=? and ReplyComments.comment_id=Comments.comment_id limit 1;";
			}
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt("from_user_id");
			}
			//System.out.println("comment_id:"+comment_id);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Integer getToUserIdByCommentId(int comment_id) {
		Connection conn = pool.getConnection();
		try {
			int type = getCommentType(comment_id);
			String sql = "";
			if (type == 0){
				sql = "select to_show_id as id from Comments, CommentShows where Comments.comment_id=? and CommentShows.comment_id=Comments.comment_id limit 1;";
			}else{
				sql = "select to_comment_id as id from Comments, ReplyComments where Comments.comment_id=? and ReplyComments.comment_id=Comments.comment_id limit 1;";
			}
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				int id = rs.getInt("id");
				if (type == 0){
					return getUserIdByShowId(id);
				}else{
					return getFromUserIdByCommentId(id);
				}
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Integer getShowIdByCommentId(int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select belong_show from Comments where Comments.comment_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt("belong_show");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static ArrayList<Integer> getSubCommentIds(int comment_id){
		Connection conn = pool.getConnection();
		ArrayList<Integer> ids = new ArrayList<Integer>();
		try {
			String sql = "select ReplyComments.comment_id from Comments, ReplyComments where ReplyComments.to_comment_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			ResultSet rs = pStatement.executeQuery();
			while(rs.next()){
				Integer id = rs.getInt(1);
				ids.add(id);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return ids;
	}
	public static boolean deleteComment(int comment_id){
		Connection conn = pool.getConnection();
		ArrayList<Integer> ids = getSubCommentIds(comment_id);
		System.out.println("ids:"+ids.size());
		for (Integer id:ids){
			deleteComment(id);
		}
		try {
			int show_id = getShowIdByCommentId(comment_id);
			String sql = "delete from Comments where comment_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			int rows = pStatement.executeUpdate();
			if (rows>0){
				decShowCommentNum(show_id);
				return true;
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean insertLikeComment(int user_id, int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "insert into LikeComments(from_user_id, to_comment_id) values(?, ?);";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			pStatement.setInt(2, comment_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean deleteLikeComment(int user_id, int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "delete from LikeComments where from_user_id=? and to_Comment_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			pStatement.setInt(2, comment_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	
	public static boolean insertReplyComment(int from_user_id, int to_comment_id, int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "insert into ReplyComments(from_user_id, to_comment_id, comment_id) values(?, ?, ?);";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, from_user_id);
			pStatement.setInt(2, to_comment_id);
			pStatement.setInt(3, comment_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean incCommentCommentNum(int comment_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "update Comments set comment_num=comment_num+1 where comment_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean decCommentCommentNum(int comment_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "update Comments set comment_num=comment_num-1 where comment_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static Integer getCommentType(int comment_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select type from Comments where comment_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, comment_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt("type");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return 0;
	}
	
	
	//Msg相关
	public static boolean insertMessage(int from_user_id, int to_user_id, String content, int rid, int msg_type) {
		if (getPermissionByUserId(to_user_id) == 0){ 
			return true;
		}
		Connection conn = pool.getConnection();
		try {
			String sql = "insert into Messages(from_user_id, to_user_id, content, rid, msg_type) values(?, ?, ?, ?, ?);";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, from_user_id);
			pStatement.setInt(2, to_user_id);
			pStatement.setString(3, content);
			pStatement.setInt(4, rid);
			pStatement.setInt(5, msg_type);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean deleteMsg(int message_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "delete from Messages where message_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, message_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static boolean setMsgHasRead(int message_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "update Messages set has_read=1 where message_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, message_id);
			int rows = pStatement.executeUpdate();
			return rows>0;
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return false;
	}
	public static Integer getMsgHasRead(int message_id){
		Connection conn = pool.getConnection();
		try {
			String sql = "select has_read from Messages where message_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, message_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()){
				rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return 0;
	}
	public static ArrayList<Message> getAllMessages(int to_user_id) {
		ArrayList<Message> messages = new ArrayList<Message>();
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Messages where to_user_id=? order by create_time desc;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, to_user_id);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Message message = new Message(rs); 
				messages.add(message);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return messages;
	}
	public static ArrayList<Message> getUnreadMessages(int to_user_id) {
		ArrayList<Message> messages = new ArrayList<Message>();
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Messages where to_user_id=? and has_read=0 order by create_time desc;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, to_user_id);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Message message = new Message(rs); 
				messages.add(message);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return messages;
	}
	public static ArrayList<Message> getNextMessages(int to_user_id, int message_id, int n) {
		ArrayList<Message> messages = new ArrayList<Message>();
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Messages where to_user_id=? and has_read=1 and message_id<? order by create_time desc limit ?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, to_user_id);
			pStatement.setInt(2, message_id);
			pStatement.setInt(3, n);
			ResultSet rs = pStatement.executeQuery();
			while (rs.next()) {
				Message message = new Message(rs); 
				messages.add(message);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return messages;
	}
	public static Message getMessage(int message_id) {
		Connection conn = pool.getConnection();
		try { 
			String sql = "select * from Messages where message_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, message_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				Message message = new Message(rs);
				return message;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Show getShow(int show_id) {
		Show show = null;
		Connection conn = pool.getConnection();
		try {
			String sql = "select * from Shows where show_id=? limit 1;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, show_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				show = new Show(rs); 
				return show;
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return show;
	}
	public static Integer getFromUserIdByMessageId(int message_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select from_user_id from Messages where message_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, message_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Integer getToUserIdByMessageId(int message_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select to_user_id from Messages where message_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, message_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Integer getMsgTypeByMessageId(int message_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select msg_type from Messages where message_id=?;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, message_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
	public static Integer getUnreadMsgNum(int user_id) {
		Connection conn = pool.getConnection();
		try {
			String sql = "select count(*) from Messages where to_user_id=? and has_read = 0;";
			PreparedStatement pStatement = conn.prepareStatement(sql);
			pStatement.setInt(1, user_id);
			ResultSet rs = pStatement.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			pool.releaseConnection(conn);
		}
		return null;
	}
}
