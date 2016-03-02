package com.web.Lmj;

import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;


/*
 * 日志类
 */
public class Log {
	private final static String filename = "log.txt";
	private PrintWriter out;
	
	public Log(String path) {
		try {
			out = new PrintWriter(new FileOutputStream(path+filename, true));
			System.out.println("日志保存在: " + path);
		} catch (Exception e) {
			e.printStackTrace();
			
		}
	}
	public Log(String path, String file) {
		try {
			out = new PrintWriter(new FileOutputStream(path+file, true));
			System.out.println("日志保存在: " + path);
		} catch (Exception e) {
			e.printStackTrace();
			
		}
	}
	public void b(String msg){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		out.println("bug log: " + sdf.format(new Date()));
		out.println("--\n"+msg);
		out.flush();
	}
	public void e(String msg){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		out.println("error log: " + sdf.format(new Date()));
		out.println("--\n"+msg);
		out.flush();
	}
	public void d(String msg){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		out.println("debug log: " + sdf.format(new Date()));
		out.println("--\n"+msg);
		out.flush();
	}
}
