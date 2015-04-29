# -*- coding: utf-8 -*-
# utils_key.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# utils_key: iqiyi, com.qiyi.player.base.utils 

# import
import hashlib
import math

from .utils_md5 import md5_hash

# base functions

def rotateRight(param1, param2):
    _loc3_ = 0
    _loc4_ = param1
    _loc5_ = 0
    while _loc5_ < param2:
        _loc3_ = _loc4_ & 1
        _loc4_ = _loc4_ >>> 1
        _loc3_ = _loc3_ << 31
        _loc4_ = _loc4_ + _loc3_
        _loc5_++
    return _loc4_

def getVRSXORCode(param1, param2):
    _loc3_ = param2 % 3
    if _loc3_ == 1:
        return param1 ^ 121
    if _loc3_ == 2:
        return param1 ^ 72
    return param1 ^ 103

# class

class KeyUtils(object):
    
    def getVrsEncodeCode(param1):
        _loc6_ = 0
        _loc2_ = ''
        _loc3_ = param1.split('-')
        _loc4_ = len(_loc3_)
        _loc5_ = _loc4_ - 1
        while _loc5_ >= 0:
            _loc6_ = getVRSXORCode(int(_loc3_[_loc4_ - _loc5_ - 1], 16), _loc5_)
            # NOTE covert javascript String.fromCharCode() to python3 chr()
            _loc2_ = chr(_loc6_) + _loc2_
            _loc5_ -= 1
        return _loc2_
    
    def getDispatchKey(param1, param2):
        _loc3_ = ')(*&^flash@#$%a'
        _loc4_ = math.floor(float(param1) / (10 * 60))
        return md5_hash(str(_loc4_) + _loc3_ + param2)
    
    def getPassportKey(param1):
        _loc2_ = param1
        _loc3_ = 2.391461978E9
        _loc4_ = _loc3_ % 17
        _loc2_ = rotateRight(_loc2_, _loc4_)
        _loc5_ = _loc2_ ^ _loc3_
        return str(_loc5_)
    # end class KeyUtils

# end utils_key.py


