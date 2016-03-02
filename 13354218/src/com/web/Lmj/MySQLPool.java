package com.web.Lmj;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;
import java.util.Map.Entry;
 
import java.util.concurrent.ConcurrentHashMap;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

//�ο���http://www.oschina.net/code/snippet_932414_47697?p=1#comments
/*�÷���
MySQLPool pool = MySQLPool.getInstance();
Connection conn = pool.getConnection();
...
pool.releaseConnection(conn);
*/
//MySQL���ݿ����ӳ�
public class MySQLPool {
	//MySQL���Ӳ���
    private final String dbname = "13354218";
    
    //private final String username = "root";
    //private final String password = "toor";
    //private final String url = "jdbc:mysql://localhost:3306/"+dbname;
    
    private final String username = "user";
    private final String password = "123456";
    //private final String url = "jdbc:mysql://202.116.76.22:53306/"+dbname;//������
    private final String url = "jdbc:mysql://localhost:3306/"+dbname;//���ص���
    //���ӳز���
    private int initPoolSize = 10;//��ʼ������
    private int maxPoolSize = 200;//���������
    private int waitTime = 100;//
    
    private static volatile MySQLPool pool;//��̬��ʵ��
    
    private MysqlDataSource ds;//
    private Map<Connection, Boolean> map;//
    
    //���캯����ʼ��
    private MySQLPool() {
        init();
    }
    //��ȡ���ӳص�ʵ��
    public static MySQLPool getInstance() {
        if (pool == null) {
            synchronized (MySQLPool.class) {
                if(pool == null) {
                    pool = new MySQLPool();
                }
            }
        }
        return pool;
    }
    //��ʼ�����ӳ�
    private void init() {
        try {
            ds = new MysqlDataSource();
            ds.setUrl(url);
            ds.setUser(username);
            ds.setPassword(password);
            ds.setCacheCallableStmts(true);
            ds.setConnectTimeout(1000);
            ds.setLoginTimeout(2000);
            ds.setUseUnicode(true);
            ds.setEncoding("UTF-8");
            ds.setZeroDateTimeBehavior("convertToNull");
            ds.setMaxReconnects(5);
            ds.setAutoReconnect(true);
            map = new ConcurrentHashMap<Connection, Boolean>(initPoolSize);
            //map = new HashMap<Connection, Boolean>();//HashMap�����̰߳�ȫ��
            for (int i = 0; i < initPoolSize; i++) {
                map.put(getNewConnection(), true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //����һ��������
    public Connection getNewConnection() {
        try {
            return ds.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    //��ȡһ������
    public synchronized Connection getConnection() {
        Connection conn = null;
        try {
            for (Entry<Connection, Boolean> entry : map.entrySet()) {
                if (entry.getValue()) {//��û��ʹ�õ�
                    conn = entry.getKey();
                    map.put(conn, false);//�޸�Ϊ����
                    break;
                }
            }
            if (conn == null) {//���ӳ�����
                if (map.size() < maxPoolSize) {//����������
                    conn = getNewConnection();
                    map.put(conn, false);
                } else {//�Ѵﵽ������ӳ������ȴ�һ��ʱ����ٻ�ȡ
                    wait(waitTime);
                    conn = getConnection();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
    //�ͷ�����
    public void releaseConnection(Connection conn) {
        if (conn == null) {
            return;
        }
        try {
            if(map.containsKey(conn)) {
                if (conn.isClosed()) {
                    map.remove(conn);
                } else {
                    if(!conn.getAutoCommit()) {
                        conn.setAutoCommit(true);
                    }
                    map.put(conn, true);//������������Ϊδ��
                }
            } else {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
 
