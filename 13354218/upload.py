#coding:utf-8

# 上传文件

import requests
import os
folderRoot = r'13354218'

#----------------------------------------------------------------------
def getFilepaths(root):
    filepaths = []
    for root, dirs, files in os.walk(root):  
        for name in files:  
            filepaths.append(os.path.join(root, name)) 
    return filepaths
    
#----------------------------------------------------------------------
def upload(cookies, foldername, filepath):
    filename = filepath.split('\\')[-1]
    url = 'http://202.116.76.22:50080/netdisk/ShowFolderContent.aspx?vm=13mo&foldername='+foldername+'&rootindex=0&rootname=webapps'
    r = requests.get(url, cookies=cookies)
    url = 'http://202.116.76.22:50080/netdisk/uploadfile.aspx'
    try:
        fh = open(filepath, 'rb')
    except Exception, e:
        print filepath, ' ', '打开失败'
        return;
    files = {'FileUpload1': (filename, fh)
             }
    payload ={'__EVENTVALIDATION':'/wEdAASE8yqBjKRXsAVvukUrugy65vhDofrSSRcWtmHPtJVt4OZ/ps16smWapsh60U1606q6h/7n4xHPHfuPN0Utkq2m0MYcWcgjABCyv03l74Gt5hyuo9GXd1DnTj0x3tXBr9g=',
              '__VIEWSTATE':'/wEPDwUJLTI0MDUwNzIwD2QWAgIDDxYCHgdlbmN0eXBlBRNtdWx0aXBhcnQvZm9ybS1kYXRhZGSkbnBnXkB644QKZ/FLq5Qb5MdEus/mt+eWq1odYtyVdw==',
              '__VIEWSTATEGENERATOR':'9DF2453C',
              'btnUpload':u'上传',
              'txtFolder':''}
    #r = requests.get(url)
    r = requests.post(url, files=files, cookies=cookies, data=payload)
    print filepath, ' ', u'上传成功!!' in r.text and u'成功' or u'失败'

if __name__ == '__main__':
    r = requests.get('http://202.116.76.22:50080/netdisk/default.aspx?vm=13mo')
    cookies = {'ASP.NET_SessionId':r.cookies.get('ASP.NET_SessionId')} 
    
    #上传 src
    foldnameRoot = '\\'+folderRoot+'\\'
    root = r'.\src'
    filepaths = getFilepaths(root)
    for filepath in filepaths:
        foldername = foldnameRoot+'\\'.join(filepath.split('\\')[1:-1])
        #print foldername
        upload(cookies, foldername, filepath)
    
    #上传 classes
    foldnameRoot = '\\'+folderRoot+'\\'
    root = r'.\build\classes'
    filepaths = getFilepaths(root)
    for filepath in filepaths:
        foldername = foldnameRoot+'WEB-INF\\'+'\\'.join(filepath.split('\\')[2:-1])
        #print foldername
        #print filepath
        upload(cookies, foldername, filepath)
    
    
    #上传 WebContent
    foldnameRoot = '\\'+folderRoot+'\\'
    root = r'.\WebContent'
    filepaths = getFilepaths(root)
    for filepath in filepaths:
        filepath = filepath.decode('gbk').encode('utf-8')
        foldername = foldnameRoot+'\\'.join(filepath.split('\\')[2:-1])
        #print filepath.decode('gbk').encode('utf-8')
        upload(cookies, foldername, filepath)
 
'''  
    r = requests.get('http://202.116.76.22:50080/netdisk/default.aspx?vm=13mo')
    cookies = {'ASP.NET_SessionId':r.cookies.get('ASP.NET_SessionId')}
    upload(cookies, r'\13354218\pages\img', r'.\WebContent\pages\img\like_left.png')
''' 
