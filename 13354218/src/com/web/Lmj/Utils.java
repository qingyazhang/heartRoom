package com.web.Lmj;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Utils {
	// 判断是否为数字 正则
	public static boolean isNumeric(String str) {
		if (str == null || str.isEmpty()) {
			return false;
		}
		Pattern pattern = Pattern.compile("[0-9]*");
		return pattern.matcher(str).matches();
	}

	// 把字符串转为数字
	public static int getInt(String str) {
		int res;
		try {
			res = Integer.parseInt(str);
		} catch (Exception e) {
			res = 0;
		}
		return res;
	}

	// 打乱字符串
	public static String shuffleString(String s) {
		char[] c = s.toCharArray();
		List<Character> lst = new ArrayList<Character>();
		for (int i = 0; i < c.length; i++) {
			lst.add(c[i]);
		}
		Collections.shuffle(lst);
		String resultStr = "";
		for (int i = 0; i < lst.size(); i++) {
			resultStr += lst.get(i);
		}
		return resultStr;
	}

	//检测邮箱
	public static boolean isEmail(String email) {
		String str = "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
		Pattern p = Pattern.compile(str);
		Matcher m = p.matcher(email);
		return m.matches();
	}
}
