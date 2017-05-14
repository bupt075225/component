#!/usr/bin/env
# -*- coding:utf-8 -*-

import os
import re
import json
import io
import pycurl
from StringIO import StringIO
from urllib import urlencode


class HttpRequest(object):
    '''
    提供HTTP的GET和POST方法,文件上传和下载
    '''
    def __init__(self, ip, port='8081'):
        self.ip = ip
        self.port = port
        self.buffer = StringIO()
        self.rsp_headers = {}

    def _header_check(self, header_line):
        # 响应头部每一行是key:value的格式,但第一行状态码除外
        if ':' not in header_line:
            return

        name, value = header_line.split(':', 1)
        # 删除首尾空格字符
        name = name.strip()
        value = value.strip()
        # 大小写不敏感
        name = name.lower()
        self.rsp_headers[name] = value

    def get_data(self, uri):
        '''
        返回GET请求响应的头部,body和状态码
        '''
        self.rsp_headers = {}

        c = pycurl.Curl()
        c.setopt(c.URL, 'http://%s:%s%s' %(self.ip, self.port, uri))
        c.setopt(c.WRITEFUNCTION, self.buffer.write)
        c.setopt(c.HEADERFUNCTION, self._header_check)
        #c.setopt(c.FOLLOWLOCATION, True)
        c.perform()
        status_code = c.getinfo(c.RESPONSE_CODE)
        c.close()

        response = {}
        response['header'] = self.rsp_headers
        response['status_code'] = status_code
        if self.rsp_headers['content-type'] == 'application/json':
            response['body'] = json.loads(self.buffer.getvalue())
        else:
            response['body'] = self.buffer.getvalue()
        return response

    def post_data(self, uri, **kw):
        '''
        POST提交表单数据
        '''
        self.rsp_headers = {}

        c = pycurl.Curl()
        c.setopt(c.URL, 'http://%s:%s%s' %(self.ip, self.port, uri))
        post_fields = urlencode(kw)
        # 设置请求方法为POST,头部Content-Type为
        # application/x-www.form-urlencoded
        c.setopt(c.POSTFIELDS, post_fields)
        c.setopt(c.WRITEFUNCTION, self.buffer.write)
        c.setopt(c.HEADERFUNCTION, self._header_check)
        #c.setopt(c.FOLLOWLOCATION, True)
        c.perform()
        status_code = c.getinfo(c.RESPONSE_CODE)
        c.close()

        response = {}
        response['header'] = self.rsp_headers
        response['status_code'] = status_code
        if self.rsp_headers['content-type'] == 'application/json':
            response['body'] = json.loads(self.buffer.getvalue())
        else:
            response['body'] = self.buffer.getvalue()
        return response

    def upload_file(self, uri, filename):
        c = pycurl.Curl()
        c.setopt(c.URL, 'http://%s:%s%s' %(self.ip, self.port, uri))
        c.setopt(c.WRITEFUNCTION, self.buffer.write)
        c.setopt(c.HTTPPOST, [
            ('configFile', (
              c.FORM_FILE, filename,
            )),
        ])
        c.setopt(c.FOLLOWLOCATION, True)
        c.perform()
        status_code = c.getinfo(c.RESPONSE_CODE)
        c.close()

        response = {}
        response['status_code'] = status_code
        return response

    def download_file(self, uri):
        self.rsp_headers = {}

        buffer = io.BytesIO()
        c = pycurl.Curl()
        c.setopt(c.URL, 'http://%s:%s%s' %(self.ip, self.port, uri))
        c.setopt(c.WRITEFUNCTION, buffer.write)
        c.setopt(c.HEADERFUNCTION, self._header_check)
        c.perform()
        status_code = c.getinfo(c.RESPONSE_CODE)
        c.close

        response = {}
        response['status_code'] = status_code

        ret = re.findall("filename=(.*)", self.rsp_headers['content-disposition'])
        if len(ret) != 0:
            with open(ret[0], 'wb') as f:
                f.write(buffer.getvalue())
            response['file'] = os.getcwd() + '/' + ret[0]
        else:
            response['file'] = None

        return response

if __name__=='__main__':
    request = HttpRequest('10.10.10.113')

    # Login
    params = {'username':'super', 'pasword':'Abc123456'}
    #response = request.post_data('/static/ui/index.html',**params)
    #print response['status_code']

    # GET
    response = request.get_data('/api/iscsi_array/1')

    # POST
    params = {'type':'iSCSI', 'mark':'testArray', 'ip':'10.10.10.23', 'port':'3260', 'initiator':'myinit'}
    #response = request.post_data('/api/iscsi_array', **params)

    # upload
    #response = request.upload_file('/api/system_config', 'systemConfig.zip')

    # download
    #response = request.download_file('/api/system_config')

    print response
    #response = request.get_data('/logout')
    #print response['status_code']
