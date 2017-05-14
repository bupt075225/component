#!/usr/bin/env python
# -*- coding:utf-8 -*-

'''
Web Service接口单元测试
Usage:python -m unittest -v test
'''

import unittest
import json
from http_api import HttpRequest
from config import configs


class TestSystemInfo(unittest.TestCase):
    '''
    查询系统信息
    '''
    '''
    def test_query_system_info(self):
        request = HttpRequest(configs['dev_manage_ip'])
        response = request.get_data('/api/system_info')
        self.assertEquals(response['status_code'], 200)
        self.assertIsInstance(response['body'], dict)
        self.assertEquals(len(response['body']), 9)
    '''
    pass

class TestSystemTime(unittest.TestCase):
    '''
    设置系统时间
    '''
    pass

class TestMapping(unittest.TestCase):
    '''
    增,删,查,改映射关系
    '''
    pass

class TestEncrypt(unittest.TestCase):
    '''
    查询LUN详细信息,设置加密策略,条件查询加密策略
    '''
    pass

class TestPortConfig(unittest.TestCase):
    '''
    管理网口,桥接口查询与配置,连通性测试
    '''
    pass

class TestSystemReset(unittest.TestCase):
    '''
    恢复出厂设置测试用例
    '''
    pass

class TestUpgrade(unittest.TestCase):
    '''
    系统升级测试用例
    '''
    pass

class TestSystemBackup(unittest.TestCase):
    '''
    系统配置导入与导出测试用例
    '''
    pass

class TestBackupKey(unittest.TestCase):
    '''
    备份系统密钥测试用例
    '''
    def test_backup_key(self):
        request = HttpRequest(configs['dev_manage_ip'])
        params = {'pin':configs['usb_key_pin']}
        response = request.post_data('/api/system_key', **params)
        print response
        body = json.loads(response['body'])
        self.assertEquals(response['status_code'], 200)
        self.assertTrue(int(body['encrypt_key_count'])>=0)

class TestRecoverEncryptKey(unittest.TestCase):
    '''
    恢复数据密钥测试用例
    '''
    def test_recover_encrypt_key(self):
        request = HttpRequest(configs['dev_manage_ip'])
        params = {'pin':configs['usb_key_pin']}
        response = request.post_data('/api/encrypt_key', **params)
        print response
        body = json.loads(response['body'])
        self.assertEquals(response['status_code'], 200)
        self.assertTrue(len(body['detail']) >= 0)
