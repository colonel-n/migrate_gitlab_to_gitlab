#!/usr/bin/env ruby
# example
# PRIVATE_TOKEN = '�ܹԸ���private token'
# SOURCE_URL= '�ܹԸ�gitlab��url'
# TARGET_URL= '�ܹ���gitlab��url'
PRIVATE_TOKEN = ''
SOURCE_URL= ''
TARGET_URL= ''

PER_PAGE = 500

# ������ɳ�դ�
# �桼��ID�����ܸ����������ɳ�դ�
# gitlab��api��author������Ǥ��ʤ����ᡢ�ܹ����token�򤽤줾��������뤳�Ȥ��б�
# �ܹԸ��®�䤫��token�ν������ɬ��
# example
# TARO = 1
# JIRO = 2
# SABURO = 3
# SIRO = 4
# UEDA = 5
# ALTER_NOT_FOUND_TOKEN = '�����Υ桼������Ԥǻ��Ѥ���private token'
# �ܹԸ��Υ桼��ID=>{id:�ܹ���Υ桼��ID,'private_token'=>�ܹ����private_token}
# USER_IDS = {
# 	TARO => {id: 11,token: 'private_token_1'},
# 	SABURO=>{id: 12,token: 'private_token_2'},
# 	JIRO=>{id: 13,token: 'private_token_3'},
# 	SIRO=>{id: 14,token: ALTER_NOT_FOUND_TOKEN},
# }
# ALTER_NOT_FOUND_USER = USER_IDS[TARO]
# TARGET_PROJECTS = [�ܹԤ���ץ������Ȥ�ID]
# TARGET_NAMESPACE = �ܹ���Τ֤鲼����namespace��id ���ʹ߸��ǤϤʤ�
ALTER_NOT_FOUND_TOKEN = ''
USER_IDS = {}
ALTER_NOT_FOUND_USER = USER_IDS['']
TARGET_PROJECTS = []
TARGET_NAMESPACE = 0