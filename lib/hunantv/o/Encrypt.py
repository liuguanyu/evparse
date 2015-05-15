# -*- coding: utf-8 -*-
# Encrypt.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# Encrypt: hunantv, com.utl.Encrypt

# import

import random
import datetime

# class

class Encrypt(object):
    
    # def creatRandomCode(param1:Number): String
    def creatRandomCode(param1):
        _loc3_ = str(random.random())
        
        # _loc2_ = new Date()
        # _loc3_ += _loc2_.getMinutes().toString()
        # _loc3_ += _loc2_.getSeconds().toString()
        # _loc3_ += _loc2_.getMilliseconds().toString()
        _loc2_ = datetime.datetime.now()
        _loc3_ += str(_loc2_.minute)
        _loc3_ += str(_loc2_.second)
        _loc3_ += str(round(_loc2_.microsecond * 1e-3))
        
        _loc3_ = _loc3_.replace('.', '')
        if len(_loc3_) > param1 + 1:
            _loc3_ = _loc3_[1:param1]
        else:
            _loc3_ = _loc3_[1:len(_loc3_) - 1]
        return _loc3_
    
    # end Encrypt class

# end Encrypt.py


