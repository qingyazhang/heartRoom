//返回对应的元素
function $(flag) {
    if (flag.startWith('#')) { // # 开头的为id
        var id = flag.substr(1);
        return document.getElementById(id);
    } else if (flag.startWith('.')) { // . 开头的为class
        var _class = flag.substr(1);
        return document.getElementsByClassName(_class);
    } else { //默认为name 或 *
        return document.getElementsByName(flag);
    }
}
//采用正则表达式实现字符串的startWith,endWith,trim函数
String.prototype.startWith = function(str) {
    var reg = new RegExp("^" + str);
    return reg.test(this);
}
String.prototype.endWith = function(str) {
    var reg = new RegExp(str + "$");
    return reg.test(this);
}
String.prototype.trim=function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
    //return this.replace(/^s+|s+$/g,'');
}
String.prototype.ltrim=function(){
    return this.replace(/(^\s*)/g,"");
}
String.prototype.rtrim=function(){
    return this.replace(/(\s*$)/g,"");
}
//自定义Toast弹框
function Toast(msg, duration){
    duration = isNaN(duration)? 1000 : duration;
    var m = document.createElement('div');
    m.innerHTML = msg;
    m.style.cssText="color:#2690FE; text-align:center; font-size:20px; position:fixed; padding-left:10px; padding-right:10px; max-width:50%; overflow: auto; margin: auto; top: 200px; left: 0; bottom: 0; right: 0;  min-width:100px;opacity:0.5; height:40px; line-height:40px; text-align:center; border-radius:10px; z-index:999999; font-weight:bold; filter: alpha(opacity=50); background:black;";
    document.body.appendChild(m);
    setTimeout(function() {
        var d = 0.5;
        m.style.webkitTransition = '-webkit-transform ' + d + 's ease-in, opacity ' + d + 's ease-in';
        m.style.opacity = '0';
        setTimeout(function() { document.body.removeChild(m) }, d * 1000);
    }, duration);
}
 function isEmail(email){
    var reg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
    return reg.test(email);
}

/*
仿Jquery的ajax实现,和jquery参数含义一致
url 请求地址
type 请求类型,GET或者POST
timeout 超时时间
async 是否异步
complete 请求完成后执行
error 请求失败后执行
success 请求成功后执行
dataType 请求的数据类型,xml/text/json/jsonp
data 参数
jsonp 回调函数参数名 跨域用
jsonpCallback 回调函数名 跨域用
 */
function ajax(params) {
    params = params || {}; //参数未定义则初始化，如果已定义则不变
    if (!params.url) { //没填url参数
        throw new Error('url参数缺失！');
    }
    var options = {
        url: params.url || window.location.href, //请求地址
        type: (params.type || 'GET').toUpperCase(), //请求类型 转大写 默认GET
        timeout: params.timeout || 5000, //超时时间 ms
        async: true, //是否异步 固定true
        complete: params.complete || function() {}, //请求完成后执行
        error: params.error || function() {}, //请求失败后执行
        success: params.success || function(data) {}, //请求成功后执行
        //ontimeout: params.ontimeout || function() {}, //请求超时执行
        dataType: (params.dataType || 'text').toLowerCase(), //请求的数据类型, 转小写 xml/text/json/jsonp
        data: params.data || {}, //参数
        jsonp: 'callback', //回调函数参数名 跨域用
        jsonpCallback: ('jsonp_' + Math.random()).replace('.', '') //回调函数名 跨域用
    };
    //格式化json参数
    var formatParams = function(json) {
        var arr = [];
        for (var i in json) {
            arr.push(encodeURIComponent(i) + '=' + encodeURIComponent(json[i]));
        }
        return arr.join("&");
    };
    if (options.dataType == 'jsonp') { // 跨域请求
        //插入动态脚本及回调函数
        var $head = document.getElementsByTagName('head')[0];
        var $script = document.createElement('script');
        $head.appendChild($script);
        window[options.jsonpCallback] = function(json) {
            $head.removeChild($script);
            window[options.jsonpCallback] = null;
            hander && clearTimeout(hander);
            options.success(json);
            options.complete();
        };
        //发送请求
        options.data[options.jsonp] = options.jsonpCallback;
        $script.src = options.url + '?' + formatParams(options.data);
        //超时处理
        var hander = setTimeout(function() {
            $head.removeChild($script);
            window[options.jsonpCallback] = null;
            options.error();
            options.complete();
        }, options.timeout);
    } else { //同域请求
        //创建xhr对象 兼容浏览器
        var xhr = new(self.XMLHttpRequest || ActiveXObject)("Microsoft.XMLHTTP");
        if (!xhr) {
            return false;
        }
        //格式化参数
        options.data = formatParams(options.data);
        //发送请求
        if (options.type == 'POST') {
            xhr.open(options.type, options.url, options.async);
            xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
            xhr.send(options.data);
        } else {
            xhr.open(options.type, options.url + '?' + options.data, options.async);
            xhr.send(null);
        }
        //超时处理
        var requestDone = false;
        setTimeout(function() {
            requestDone = true;
            if (xhr.readyState != 4) {
                xhr.abort();
            }
        }, options.timeout);
        //xhr.timeout = options.timeout;
        //xhr.ontimeout = options.ontimeout;
            //状态处理
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && !requestDone) {
                if (xhr.status >= 200 && xhr.status < 300) {
                    var data = options.dataType == "xml" ? xhr.responseXML : xhr.responseText;
                    if (options.dataType == "json") { //转为JSON格式
                        try {
                            data = JSON.parse(data);
                        } catch (e) {
                            data = eval('(' + data + ')');
                        }
                    }
                    console.log(data);
                    options.success(data); //请求成功
                } else {
                    options.error(); //请求失败
                }
                options.complete(); //请求完成
            }
        };
    }
}
//文件上传 http://itindex.net/blog/2012/04/14/1334367483953.html
function ajaxFileUpload(params) {
    params = params || {}; //参数未定义则初始化，如果已定义则不变
    if (!params.url) { //没填url参数
        throw new Error('url参数缺失！');
    }
    var options = {
        url: params.url || window.location.href, //请求地址
        type: 'POST', //请求类型 转大写
        async: true, //是否异步 固定true
        error: params.error || function() {}, //请求失败后执行
        success: params.success || function(data) {}, //请求成功后执行
        abort: params.abort || function() {}, //请求中止后执行
        progress: params.progress || function(event) {}, //更新进度
        dataType: (params.dataType || 'text').toLowerCase(), //请求的数据类型, 转小写 xml/text/json/jsonp
        formData: params.formData  || {} //文件参数
    };

    //创建xhr对象 兼容浏览器
    var xhr = new(self.XMLHttpRequest || ActiveXObject)("Microsoft.XMLHTTP");
    if (!xhr) {
        return false;
    }
    function success(event){
        var data = options.dataType == "xml" ? event.target.responseXML : event.target.responseText;
        if (options.dataType == "json") { //转为JSON格式
            try {
                data = JSON.parse(data);
            } catch (e) {
                data = eval('(' + data + ')');
            }
        }
        console.log(data);
        options.success(data); //请求成功
    }
    //发送请求
    xhr.open(options.type, options.url, options.async);
    /*xhr.setRequestHeader('Content-type', 'multipart/form-data; boundary=AaB03x');*/
    xhr.send(options.formData);
    //监听
    xhr.upload.addEventListener("progress", options.progress, false);
    xhr.addEventListener("error", options.error, false);
    xhr.addEventListener("abort", options.abort, false);
    xhr.addEventListener("load", success, false);
}

//序列化表单数据
function serializeForm(formId) {
    var elements = getElements(formId);
    var queryComponents = new Array();
    for (var i = 0; i < elements.length; i++) {
      var queryComponent = serializeElement(elements[i]);
      if (queryComponent)
        queryComponents.push(queryComponent);
    }
    return queryComponents.join('&');
}
//获取指定form中的所有的<input>对象
function getElements(formId) {
    var form = document.getElementById(formId);
    var elements = new Array();
    var tagElements = form.getElementsByTagName('input');
    for (var j = 0; j < tagElements.length; j++){
         elements.push(tagElements[j]);
    }
    return elements;
}
//获取单个input中的【name,value】数组
function inputSelector(element) {
  if (element.checked)
     return [element.name, element.value];
}
function input(element) {
    switch (element.type.toLowerCase()) {
      case 'submit':
      case 'hidden':
      case 'password':
      case 'text':
        return [element.name, element.value];
      case 'checkbox':
      case 'radio':
        return inputSelector(element);
    }
    return false;
}
//组合URL
function serializeElement(element) {
    var method = element.tagName.toLowerCase();
    var parameter = input(element);
    if (parameter) {
      var key = encodeURIComponent(parameter[0]);
      if (key.length == 0) return;

      if (parameter[1].constructor != Array)
        parameter[1] = [parameter[1]];

      var values = parameter[1];
      var results = [];
      for (var i=0; i<values.length; i++) {
        results.push(key + '=' + encodeURIComponent(values[i]));
      }
      return results.join('&');
    }
 }


/*XML解析*/
function Xmler(xmlDoc){
    this.xmlDoc = xmlDoc;
    this.getDirectNodeValue = function(nodeName){
        return xmlDoc.getElementsByTagName(nodeName)[0].childNodes[0].nodeValue;
    }
}

var sdelay=0;
function returnTop() {
 window.scrollBy(0,-100);//Only for y vertical-axis
 if(document.body.scrollTop>300) {
  sdelay= setTimeout('returnTop()',50);
 }
}


// 拖动
var myDrag = {
    o: null,
    init: function(o) {
      o.onmousedown = this.start;
    },
    start: function(e) {
      var o;
      e = rDrag.fixEvent(e);
      e.preventDefault && e.preventDefault();
      rDrag.o = o = this;
      o.x = e.clientX - rDrag.o.offsetLeft;
      o.y = e.clientY - rDrag.o.offsetTop;
      document.onmousemove = rDrag.move;
      document.onmouseup = rDrag.end;
    },
    move: function(e) {
      e = rDrag.fixEvent(e);
      var oLeft, oTop;
      oLeft = e.clientX - rDrag.o.x;
      oTop = e.clientY - rDrag.o.y;
      rDrag.o.style.left = oLeft + 'px';
      rDrag.o.style.top = oTop + 'px';
    },
    end: function(e) {
      e = rDrag.fixEvent(e);
      rDrag.o = document.onmousemove = document.onmouseup = null;
    },
    fixEvent: function(e) {
      if (!e) {
        e = window.event;
        e.target = e.srcElement;
        e.layerX = e.offsetX;
        e.layerY = e.offsetY;
      }
      return e;
    }
  }