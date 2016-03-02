package com.web.Lmj;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/*
 * ��������ͳ��
 * ��Ҫ��web.xml�Ӹ�listener
 */
public class SessionCounter implements HttpSessionListener {

	private static int activeSessions = 0;

	//������������
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
