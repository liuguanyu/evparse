# -*- coding: utf-8 -*-
# utils_md5.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# utils_md5: iqiyi, com.qiyi.player.base.utils 

# import
import hashlib

# functions
def md5_hash(string):
    return hashlib.md5(bytes(string, 'utf-8')).hexdigest()

# end utils_md5.py


