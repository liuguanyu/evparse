# -*- coding: utf-8 -*-
# utils.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# utils: iqiyi, com.qiyi.player.base.utils 

# import

# class
class Utility(object):
    # def getUrl(param1:String, param2:String): String
    def getUrl(param1, param2):
        _loc4_ =0
        _loc5_ = 0
        while _loc5_ < len(param1):
            if param1[_loc5_] == '/':
                _loc4_ += 1
            if _loc4_ == 3:
                break
            _loc5_ += 1
        _loc3_ = param1[:_loc5_ + 1] + param2 + param1[_loc5_:]
        return _loc3_
    # def getItemById(param1:Array, param2:int): EnumItem
    def getItemById(param1, param2):
        for _loc3_ in param1:
            if _loc3_.id == param2:
                return _loc3_
        return None
    # def getItemByName(param1:Array, param2:String): EnumItem
    def getItemByName(param1, param2):
        for _loc3_ in param1:
            if _loc3_.name == param2:
                return _loc3_
        return None
    # end Utility class

# end utils.py


