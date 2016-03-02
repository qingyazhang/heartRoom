
function addPublicChildToHead(data){
    var div = document.createElement('div');
    div.innerHTML = data;
    div = div.children;
    var parent = $('#div_public_show');
    var children = parent.children;
    for (var i=div.length-1; i>=0; --i){
        if (children.length==0){
            parent.appendChild(div[i]);
        }else{
            parent.insertBefore(div[i], children[0]);
        }
    }
}
function updatePublic(){
    getPublicShow(0, 10, '', true);
}
function getPublicShow(show_id, n, turn, clear){
    ajax({
        'url': 'getShow.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'n':n, 'turn':turn, 'from':'public'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.trim().length);
            if (data.trim().length > 500){
                var before_id = -1;
                if ($('#div_public_show').children.length!=0){
                    before_id = $('#div_public_show').children[0].children[0].innerHTML.trim();
                }
                if(clear){
                    clearPublicShow();
                }
                addPublicChildToHead(data.trim());
                var now_id = $('#div_public_show').children[0].children[0].innerHTML.trim();
                if (turn=='last' && before_id!=-1 && before_id == now_id){
                    Toast('已经是第一页了');
                }else{
                    returnTop();
                }
                if (turn == 'next'){
                    returnTop();
                }
            }else if (data.trim().length == 0){
                if(turn == 'last'){
                    Toast('已经是第一页了');
                }else if (turn!=''){
                    Toast('没有更多可以展示的了');
                }
            }else{
                if(turn == 'last'){
                    Toast('已经是第一页了');
                }else if (turn!=''){
                    Toast('没有更多可以展示的了');
                }
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function clearPublicShow(){
    var parent = $('#div_public_show');
    parent.innerHTML = '';
    return;
}
function turnLastPublicShow(){
    var parent = $('#div_public_show');
    if (parent.children.length==0){
        updatePublic();
        return;
    }
    var show_id = parent.children[0].children[0].innerHTML.trim();
    getPublicShow(show_id, 10, 'last', true);
    //returnTop();
}

function turnNextPublicShow(){
    var parent = $('#div_public_show');
    if (parent.children.length==0){
        updatePublic();
        return;
    }
    var show_id = parent.lastChild.children[0].innerHTML.trim();
    show_id = parseInt(show_id);
    getPublicShow(show_id, 10, 'next', true);
    //returnTop();
}
function keyPushPublicShow(){
    if(window.event.keyCode == 13){
        pushPublicShow();
    }
}
function pushPublicShow(){
    if ($('#has_logined').innerHTML.trim()==0){
        Toast('还没登录呢...');
        return;
    }
    var content = $('#public_form_textarea').value;
    if (content == ''){
        Toast('好像空着也是挺好玩的...');
        return;
    }
    var obj = $('#public_form_mode');
    var mode = obj.options[obj.selectedIndex].value; // 选中值

    ajax({
        'url': 'pushShow.jsp',
        'type': 'POST',
        'data': {'content':content, 'mode':mode, 'from':'public'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.trim().length);
            if (data.trim().length > 500){
                addPublicChildToHead(data.trim());
                $('#public_form_textarea').value = '';
                Toast('发表成功', 1000);
            }else{
                Toast(data);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}

function deletePublicShow(now){
    var show_id = now.parentNode.children[0].innerHTML.trim();
    ajax({
        'url': 'deleteShow.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'from':'public'},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                $('#div_public_show').removeChild(now.parentNode);
                Toast(xmler.getDirectNodeValue('msg'), 500);
            }else{
                Toast(xmler.getDirectNodeValue('msg'), 500);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}

function pushPublicShowLike(now){
    var show_id = now.parentNode.parentNode.children[0].innerHTML.trim();
    ajax({
        'url': 'pushShowLike.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'from':'public'},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                var n = xmler.getDirectNodeValue('n');
                now.parentNode.children[1].firstChild.innerHTML = n+' 个人赞了！';
                var nodes = now.parentNode.getElementsByClassName('public_show_like_left');
                nodes[0].setAttribute('class', 'public_show_like_left public_show_like_has');
                nodes = now.parentNode.getElementsByClassName('public_show_like_right');
                nodes[0].setAttribute('class', 'public_show_like_right public_show_like_has');
            }else if (xmler.getDirectNodeValue('code') == 2){
                var n = xmler.getDirectNodeValue('n');
                now.parentNode.children[1].firstChild.innerHTML = n+' 个人赞了！';
                var nodes = now.parentNode.getElementsByClassName('public_show_like_left');
                nodes[0].setAttribute('class', 'public_show_like_left');
                nodes = now.parentNode.getElementsByClassName('public_show_like_right');
                nodes[0].setAttribute('class', 'public_show_like_right');
            }else{
                Toast(xmler.getDirectNodeValue('msg'));
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
/*评论*/
function addPublicShowCommentToHead(showDiv, data){
    var div = document.createElement('div');
    div.innerHTML = data;
    div = div.children;
    var children = showDiv.children;
    for (var i=div.length-1; i>=0; --i){
        if (children.length==0){
            showDiv.appendChild(div[i]);
        }else{
            showDiv.insertBefore(div[i], children[0]);
        }
    }
}
function addPublicShowCommentToTail(showDiv, data){
    var div = document.createElement('div');
    div.innerHTML = data;
    div = div.children;
    var children = showDiv.children;
    for (var i=0; i<div.length; ++i){
        showDiv.appendChild(div[i]);
    }
}
function incBtnPublicShowNum(btn){
    var text = btn.innerHTML.trim();
    var n = text.charAt(text.length-1);
    n = parseInt(n);
    n = n+1;
    btn.innerHTML = text.substr(0, text.length-1)+n;
}
function decBtnPublicShowNum(btn){
    var text = btn.innerHTML.trim();
    var n = text.charAt(text.length-1);
    n = parseInt(n);
    n = n-1;
    btn.innerHTML = text.substr(0, text.length-1)+n;
}
function pushPublicShowComment(now){
    var content = now.parentNode.querySelector('.public_show_comment_content').value.trim();
    if (content == ''){
        Toast('别玩，评论是空的...');
        return;
    }
    var show_id = now.parentNode.parentNode.parentNode.querySelector('.show_id').innerHTML.trim();
    ajax({
        'url': 'pushShowComment.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'content':content, 'from':'public'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length)
            if (data.length > 500){
                addPublicShowCommentToHead(now.parentNode.parentNode.querySelector('.div_public_show_subcomment'), data);
                Toast('评论成功！');
                incBtnPublicShowNum(now.parentNode.parentNode.parentNode.querySelector('.btn_public_show_comment'));
                now.parentNode.querySelector('.public_show_comment_content').value = '';
            }else if (data.length==0){
                Toast('评论失败！');
            }else{
                Toast(data);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function clearPublicShowComments(subCommentDiv){
    subCommentDiv.innerHTML = '';
}
function updatePublicShowComments(subCommentDiv){
    var show_id = subCommentDiv.parentNode.parentNode.querySelector('.show_id').innerHTML.trim();;
    ajax({
        'url': 'getShowComment.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'n':10, 'from':'public'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length)
            if (data.length > 500){
                addPublicShowCommentToHead(subCommentDiv, data);
            }else if (data.trim().length == 0){
                Toast('没有评论哦...');
            }else{
                Toast('获取失败！');
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function showPublicCommentDiv(now){
    var commentDiv = now.parentNode.parentNode.querySelector('.div_public_show_subcomment');
    var moreComment = now.parentNode.parentNode.querySelector('.btn_public_show_more_subcomment');
    var text = now.innerHTML.trim();
    if (text.startWith('查看')){
        commentDiv.style.display = '';
        moreComment.style.display = '';
        now.innerHTML = '隐藏'+text.substr(2);
        clearPublicShowComments(commentDiv);
        updatePublicShowComments(commentDiv);

    }else if (text.startWith('隐藏')){
        commentDiv.style.display = 'none';
        moreComment.style.display = 'none';
        now.innerHTML = '查看'+text.substr(2);
    }
}
function loadMoreComment(now){
    var subCommentDiv = now.parentNode.querySelector('.div_public_show_subcomment');
    var show_id = subCommentDiv.parentNode.parentNode.querySelector('.show_id').innerHTML.trim();
    if (subCommentDiv.lastChild == null){
        Toast('没有评论哦...');
        return;
    }
    var comment_id = subCommentDiv.lastChild.querySelector('.comment_id').innerHTML.trim();
    ajax({
        'url': 'getShowComment.jsp',
        'type': 'POST',
        'data': {'show_id':show_id, 'n':10, 'comment_id':comment_id, 'from':'public'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length)
            if (data.length > 500){
                addPublicShowCommentToTail(subCommentDiv, data);
            }else{
                Toast('没有了，不要再点了哦');
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function deletePublicShowComment(now){
    var comment_id = now.parentNode.querySelector('.comment_id').innerHTML.trim();
    ajax({
        'url': 'deleteComment.jsp',
        'type': 'POST',
        'data': {'comment_id':comment_id},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                decBtnPublicShowNum(now.parentNode.parentNode.parentNode.parentNode.querySelector('.btn_public_show_comment'));
                now.parentNode.parentNode.removeChild(now.parentNode);
                Toast(xmler.getDirectNodeValue('msg'));
            }else{
                Toast(xmler.getDirectNodeValue('msg'));
            }
        },
        'error':function(){
            decBtnPublicShowNum(now.parentNode.parentNode.parentNode.parentNode.querySelector('.btn_public_show_comment'));
            now.parentNode.parentNode.removeChild(now.parentNode);
            //Toast('嘘...好像网络开小差了...');
        }
    });
}
function replyPublicShowComment(now){
    var content = now.parentNode.querySelector('.public_show_subcomment_reply_content').value.trim();
    if (content == ''){
        Toast('别玩，回复是空的...');
        return;
    }
    var comment_id = now.parentNode.parentNode.parentNode.querySelector('.comment_id').innerHTML.trim();
    ajax({
        'url': 'pushReplyComment.jsp',
        'type': 'POST',
        'data': {'comment_id':comment_id, 'content':content, 'from':'public'},
        'dataType': 'text',
        'success':function(data){
            console.log(data.length)
            if (data.length > 500){
                incBtnPublicShowNum(now.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.querySelector('.btn_public_show_comment'));
                Toast('回复成功！');
                now.parentNode.querySelector('.public_show_subcomment_reply_content').value = '';

                var subComment = now.parentNode.parentNode.parentNode;
                if (subComment.nextSibling == null){
                    addPublicShowCommentToTail(subComment.parentNode, data);
                }else{
                    var div = document.createElement('div');
                    div.innerHTML = data;
                    div = div.children[0];
                    subComment.parentNode.insertBefore(div,subComment.nextSibling);
                }
            }else if (data.length==0){
                Toast('回复失败！');
            }else{
                Toast(data);
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}
function likePublicShowComment(now){
    var comment_id = now.parentNode.parentNode.parentNode.querySelector('.comment_id').innerHTML.trim();
    ajax({
        'url': 'pushCommentLike.jsp',
        'type': 'POST',
        'data': {'comment_id':comment_id, 'from':'public'},
        'dataType': 'xml',
        'success':function(data){
            var xmler = new Xmler(data);
            if (xmler.getDirectNodeValue('code') == 1){
                var n = xmler.getDirectNodeValue('n');
                now.parentNode.querySelector('.public_show_subcomment_like_num').innerHTML = n;
                now.setAttribute('class', 'public_show_subcomment_like public_show_like_has');
            }else if (xmler.getDirectNodeValue('code') == 2){
                var n = xmler.getDirectNodeValue('n');
                now.parentNode.querySelector('.public_show_subcomment_like_num').innerHTML = n;
                now.setAttribute('class', 'public_show_subcomment_like');
            }else{
                Toast(xmler.getDirectNodeValue('msg'));
            }
        },
        'error':function(){
            Toast('嘘...好像网络开小差了...');
        }
    });
}

function showPublicShowUserInfo(now){
    var user_id = now.parentNode.parentNode.querySelector('.show_user_id').innerHTML.trim();
    showUserInfo(user_id);
}
function showPublicShowCommentUserInfo(now){
    var user_id = now.parentNode.parentNode.querySelector('.comment_user_id').innerHTML.trim();
    showUserInfo(user_id);
}