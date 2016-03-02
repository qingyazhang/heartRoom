package com.web.Lmj;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/*
 * 在线人数统计
 * 需要在web.xml加个listener
 */
public class SessionCounter implements HttpSessionListener {

	private static int activeSessions = 0;

	//返回在线人数
	public static int getActiveSessions() {
		return activeSessions;
	}

	@Override
	public void sessionCreated(HttpSessionEvent arg0) {
		activeSessions++;
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent arg0) {
		if (activeSessions > 0){
			activeSessions--;
		}
	}

}
