# -*- coding: utf-8 -*-
# CTXQuery.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# CTXQuery: pptv, cn.pplive.player.view.source.CTXQuery

# import

import re
from urllib import parse as parse0

# global static data

ctx = {}

flag_isVip = False

# reg :RegExp = RegExp('{[p|d|a|v|s]+}', 'g')
reg_text = '({[p|d|a|v|s]+})'
reg = re.compile(reg_text)

# base function
def get_var_from_url(text):
    items = parse0.parse_qsl(text)
    out = {}
    for i, j in items:
        out[i] = j
    # done
    return out

# functions

# def setCTX(param1 :String): void
def setCTX(param1):
    # _loc3_ :String
    # _loc4_ :String
    # _loc5_ :Array
    # _loc6_ :*
    # _loc2_ :URLVariables
    _loc3_ = None
    _loc4_ = None
    _loc5_ = None
    _loc6_ = 0
    # _loc2_ = new URLVariables(parse0.unquote(param1))
    _loc2_ = get_var_from_url(parse0.unquote(param1))
    for _loc3_ in _loc2_:
        if type(_loc2_[_loc3_]) == type(''):
            _loc4_ = _loc2_[_loc3_]
        # if typeof _loc2_[_loc3_] == 'object' && (_loc2_[_loc3_].hasOwnProperty('length')):
        if type(_loc2_[_loc3_]) == type({}):
            try:
                _loc4_ = _loc2_[_loc3_][len(_loc2_[_loc3_]) - 1]
            except Exception:
                pass
        if reg.match(_loc4_):
            _loc5_ = (reg.findall(_loc4_)[0]).replace('{', '').replace('}', '').split('|')
            _loc6_ = 0
            while _loc6_ < len(_loc5_):
                if not _loc5_[_loc6_] in ctx:
                    ctx[_loc5_[_loc6_]] = {}
                ctx[_loc5_[_loc6_]][_loc3_] = reg.sub('', _loc4_)
                _loc6_ += 1
        else:
            if not 'c' in ctx:
                ctx['c'] = {}
            ctx['c'][_loc3_] = _loc4_
    # end setCTX()

# def getCTX(param1 :Object, param2 :String): String
def getCTX(param2, param1=ctx):
    # _loc4_ :String
    # _loc3_ :*
    _loc4_ = None
    _loc3_ = ''
    if param1[param2]:
        for _loc4_ in param1[param2]:
            if _loc4_ != 'isVip':
                if _loc3_ != '':
                    _loc3_ += '&'
                _loc3_ += + _loc4_ + '=' + parse0.quote(param1[param2][_loc4_])
                if _loc4_ == 'type' and flag_isVip and (not 'vip' in param1[param2][_loc4_]):
                    _loc3_ += '.vip'
    return _loc3_
    # end getCTX()

def pctx():
    pass

def cctx():
    pass

# end CTXQuery.py


