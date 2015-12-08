#!/usr/bin/env ruby
# example
# PRIVATE_TOKEN = '移行元のprivate token'
# SOURCE_URL= '移行元gitlabのurl'
# TARGET_URL= '移行先gitlabのurl'
PRIVATE_TOKEN = ''
SOURCE_URL= ''
TARGET_URL= ''

PER_PAGE = 500

# キーの紐付け
# ユーザIDの遷移元と遷移先の紐付け
# gitlabのapiでauthorが指定できないため、移行先のtokenをそれぞれ定義することで対応
# 移行後は速やかにtokenの初期化が必要
# example
# TARO = 1
# JIRO = 2
# SABURO = 3
# SIRO = 4
# UEDA = 5
# ALTER_NOT_FOUND_TOKEN = '不明のユーザの代行で使用するprivate token'
# 移行元のユーザID=>{id:移行先のユーザID,'private_token'=>移行先のprivate_token}
# USER_IDS = {
# 	TARO => {id: 11,token: 'private_token_1'},
# 	SABURO=>{id: 12,token: 'private_token_2'},
# 	JIRO=>{id: 13,token: 'private_token_3'},
# 	SIRO=>{id: 14,token: ALTER_NOT_FOUND_TOKEN},
# }
# ALTER_NOT_FOUND_USER = USER_IDS[TARO]
# TARGET_PROJECTS = [移行するプロジェクトのID]
# TARGET_NAMESPACE = 移行先のぶら下げるnamespaceのid ※以降元ではない
ALTER_NOT_FOUND_TOKEN = ''
USER_IDS = {}
ALTER_NOT_FOUND_USER = USER_IDS['']
TARGET_PROJECTS = []
TARGET_NAMESPACE = 0