# -*- coding: utf-8 -*-
# ButtonUi.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# ButtonUi: sohu, com.adobe.images

# import

# import from out
ByteArray = None
Array = None
uint = None
# NOTE should be set by exports
def set_import(flash):
    # just set ByteArray
    global ByteArray
    global Array
    global uint
    ByteArray = flash.ByteArray
    Array = flash.Array
    uint = flash.uint

# functions
_Xtime_Sbox_CDN = [99,100,110,48,49,48,49,48,53,48,48,48,51,52,98,97]

# def K1(param1:ByteArray, param2:Boolean): Array
def K1(param1, param2 = False):
    # _loc6_:uint
    # _loc3_:Array
    # _loc4_:uint
    # _loc5_:*
    _loc6_ = 0
    _loc3_ = Array()
    _loc4_ = len(param1)
    _loc5_ = 0
    while _loc5_ < _loc4_:
        _tmp1 = uint(_loc5_) >> 2
        _tmp2 = uint(_loc5_) >> 2
        _tmp3 = _loc3_[_tmp2]
        if _tmp3 == None:
            _tmp3 = 0
            # print('DEBUG: got here 1')
        _tmp4 = uint(param1[_loc5_])
        _tmp5 = _loc5_ & 3
        _loc3_[_tmp1] = uint(_tmp3 | _tmp4 << _tmp5 << 3)
        _loc5_ += 1
    if param2:
        _loc3_.append(_loc4_)
        _loc6_ = len(param1) - 1
        _tmp10 = uint(_loc6_) >> 2
        _tmp11 = uint(_loc6_) >> 2
        _tmp12 = _loc3_[_tmp11]
        _tmp13 = uint(param1[_loc6_])
        _tmp14 = _loc6_ & 3
        _loc3_[_tmp10] = uint(_tmp12 | _tmp13 << _tmp14 << 3)
    return _loc3_

# def K2(param1:Array, param2:Array): Array
def K2(param1, param2):
    # _loc12_:Array
    # _loc3_:int
    _loc12_ = None
    _loc3_ = len(param1) - 1
    if _loc3_ < 1:
        return param1
    if len(param2) < 4:
        _loc12_ = param2[:]
        # param2:Array
        param2 = _loc12_
    while len(param2) < 4:
        param2.append(0)
    # _loc4_:uint
    # _loc5_:uint
    # _loc6_:uint
    # _loc7_:uint
    # _loc8_:uint
    # _loc9_:*
    # _loc10_:int
    _loc4_ = param1[_loc3_]
    _loc5_ = param1[0]
    _loc6_ = 2.654435769E9
    _loc7_ = 0
    _loc8_ = 0
    _loc9_ = 0
    _loc10_ = 6 + 52 / (_loc3_ + 1)
    while _loc10_ > 0:
        _loc10_ -= 1	# TODO reserved
        _loc7_ = uint(_loc7_ + _loc6_)
        _loc8_ = uint(_loc7_) >> 2 & 3
        _loc9_ = 0
        while _loc9_ < _loc3_:
            _loc5_ = param1[_loc9_ + 1]
            _tmp1 = param1[_loc9_] = param1[_loc9_] + ((uint(_loc4_) >> 5 ^ _loc5_ << 2) + (uint(_loc5_) >> 3 ^ _loc4_ << 4) ^ (_loc7_ ^ _loc5_) + (param2[_loc9_ & 3 ^ _loc8_] ^ _loc4_))
            _loc4_ = uint(_tmp1)
            _loc9_ += 1
        _loc5_ = param1[0]
        _tmp2 = param1[_loc3_] = param1[_loc3_] + ((uint(_loc4_) >> 5 ^ _loc5_ << 2) + (uint(_loc5_) >> 3 ^ _loc4_ << 4) ^ (_loc7_ ^ _loc5_) + (param2[_loc9_ & 3 ^ _loc8_] ^ _loc4_))
        _loc4_ = uint(_tmp2)
    # _loc11_:uint
    _loc11_ = 0
    while _loc11_ < len(param1):
        param1[_loc11_] = uint(param1[_loc11_])
        _loc11_ += 1
    return param1

# def K4(param1:Array, param2:Boolean): Array
def K4(param1, param2 = False):
    # _loc3_:*
    # _loc6_:uint
    _loc3_ = 0
    _loc6_ = 0
    if param2:
        _loc3_ = int(param1[len(param1) - 1])
    else:
        _loc3_ = len(param1) << 2
    # _loc4_:Array
    # _loc5_:uint
    _loc4_ = Array()
    _loc5_ = 0
    while _loc5_ < _loc3_:
        _loc6_ = uint(param1[uint(_loc5_) >> 2]) >> (_loc5_ & 3) << 3 & uint(255)
        _loc4_.append(_loc6_)
        _loc5_ += 1
    return _loc4_

# def K5(param1:String): ByteArray
def K5(param1):
    # _loc2_:ByteArray
    _loc2_ = ByteArray()
    _loc2_.writeUTFBytes(param1)
    _loc2_.position = 0
    return _loc2_

# def K6(param1:Array): String
def K6(param1):
    # _loc2_:ByteArray
    # _loc3_:uint
    _loc2_ = ByteArray()
    _loc3_ = 0
    while _loc3_ < len(param1):
        _loc2_.writeByte(param1[_loc3_])
        _loc3_ += 1
    _loc2_.position = 0
    if _loc2_.bytesAvailable > 0:
        return _loc2_.encode_base64()
    return ''

# def K9(param1:Array, param2:int): ByteArray
def K9(param1, param2):
    # _loc3_:ByteArray
    # _loc4_:ByteArray
    # _loc5_:Array
    # _loc6_:uint
    _loc3_ = ByteArray()
    _loc4_ = ByteArray()
    _loc5_ = param1
    _loc6_ = 0
    while _loc6_ < len(_loc5_):
        _loc4_.writeByte(_loc5_[_loc6_])
        _loc6_ += 1
    _loc4_.position = 0
    # _loc7_:*
    _loc7_ = 0
    while _loc7_ < len(_loc4_):
        _loc3_.writeByte(_loc4_.readByte() ^ param2)
        _loc7_ += 1
    _loc3_.position = 0
    return _loc3_

# class

class ButtonUi(object):
    
    # def drawBtnCDN(... rest): String
    def drawBtnCDN(*rest):
        # _loc2_:String
        # _loc3_:*
        _loc2_ = rest[0]
        _loc3_ = 1
        if len(rest) == 1:
            _loc3_ = 1
        elif len(rest) == 2:
            _loc3_ = int(float(rest[1]) % 127)
        elif len(rest) == 3:
            _loc3_ = int(int(float(rest[1]) % 127) * int(float(rest[2]) % 127) % 127)
        # _loc4_:ByteArray
        # _loc5_:ByteArray
        _loc4_ = K5(_loc2_)
        _loc5_ = K9(_Xtime_Sbox_CDN, _loc3_)
        if len(_loc4_) == 0:
            return _loc2_
        _tmp1 = K1(_loc4_, True)
        _tmp2 = K1(_loc5_, False)
        _tmp3 = K2(_tmp1, _tmp2)
        _tmp4 = K4(_tmp3, False)
        _tmp5 = K6(_tmp4)
        return _tmp5.decode('utf-8')
    # end ButtonUi

# end ButtonUi.py


