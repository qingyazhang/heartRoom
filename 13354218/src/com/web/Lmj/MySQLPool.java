package com.web.Lmj;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;
import java.util.Map.Entry;
 
import java.util.concurrent.ConcurrentHashMap;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

//参考：http://www.oschina.net/code/snippet_932414_47697?p=1#comments
/*用法：
MySQLPool pool = MySQLPool.getInstance();
Connection conn = pool.getConnection();
...
pool.releaseConnection(conn);
*/
//MySQL数据库连接池
public class MySQLPool {
	//MySQL连接参数
    private final String dbname = "13354218";
    
    //private final String username = "root";
    //private final String password = "toor";
    //private final String url = "jdbc:mysql://localhost:3306/"+dbname;
    
    private final String username = "user";
    private final String password = "123456";
    //private final String url = "jdbc:mysql://202.116.76.22:53306/"+dbname;//服务器
    private final String url = "jdbc:mysql://localhost:3306/"+dbname;//本地调试
    //连接池参数
    private int initPoolSize = 10;//初始连接数
    private int maxPoolSize = 200;//最大连接数
    private int waitTime = 100;//
    
    private static volatile MySQLPool pool;//静态单实例
    
    private MysqlDataSource ds;//
    private Map<Connection, Boolean> map;//
    
    //构造函数初始化
    private MySQLPool() {
        init();
    }
    //获取连接池单实例
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
    //初始化连接池
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
            //map = new HashMap<Connection, Boolean>();//HashMap不是线程安全的
            for (int i = 0; i < initPoolSize; i++) {
                map.put(getNewConnection(), true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //生成一个新连接
    public Connection getNewConnection() {
        try {
            return ds.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    //获取一个连接
    public synchronized Connection getConnection() {
        Connection conn = null;
        try {
            for (Entry<Connection, Boolean> entry : map.entrySet()) {
                if (entry.getValue()) {//还没被使用的
                    conn = entry.getKey();
                    map.put(conn, false);//修改为已用
                    break;
                }
            }
            if (conn == null) {//连接池已满
                if (map.size() < maxPoolSize) {//创建新连接
                    conn = getNewConnection();
                    map.put(conn, false);
                } else {//已达到最大连接池数，等待一段时间后再获取
                    wait(waitTime);
                    conn = getConnection();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
    //释放连接
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
                    map.put(conn, true);//重新设置连接为未用
                }
            } else {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
 
