# -*- coding: utf-8 -*-
# VodPlayProxy.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# VodPlayProxy: pptv, cn.pplive.player.model.VodPlayProxy

# import

from ..common import VodParser, VodCommon

# global static data

# class

class VodPlayProxy(object):
    
    def __init__(self):
        self.count = 0
        self.isVip = '0'	# NOTE can be '0'
        self.vvid = ''	# TODO
    
    # def get_playUrl(self): String
    def get_playUrl(self):
        if VodCommon.priplay:
            return VodCommon.priplay
        
        _loc1_ = VodParser.ph[self.count]
        # TODO reserved
        # _loc2_ = CommonUtils.addHttp(_loc1_)
        _loc2_ = _loc1_
        # if _loc2_.lastIndexOf('/') != len(_loc2_) - 1:
        if _loc2_[-1] != '/':
            _loc2_ += '/'
        
        if VodCommon.playStr:
            pass	# TODO reserved
            # _loc2_ += '?playStr=' + VodCommon.playStr
            # if Global.getInstance()['userInfo']:
            #     _loc2_ = _loc2_ + ('&token=' + Global.getInstance()['userInfo']['ppToken'])
        else:
            if VodParser.lm:
                _loc2_ += 'webplay3'
            else:
                _loc2_ += 'webplay4'
            _loc2_ += '-0-' + VodParser.cid + '.xml'
            _loc2_ += '?zone=' + -(new Date().getTimezoneOffset() / 60)	# TODO
            _loc2_ += '&pid=' + VodCommon.pid
            _loc2_ += '&vvid=' + self.vvid
            _loc2_ += '&version=4'
            if VodCommon.smart:
                _loc2_ += '&open=1'
        # if end
        # TODO encodeURL ...
        _loc2_ += '&username=' + encodeURIComponent(VodParser.un)
        # TODO encodeURIComponent
        _loc2_ += '&param=' + encodeURIComponent('type=' + VodCommon.playType + '&userType=' + self.isVip + '&o=' + VodParser.os)
        # _loc2_ += (CTXQuery.pctx != '' ? '&' : '') + CTXQuery.pctx
        if CTXQuery.pctx != '':	# TODO
            _loc2_ += '&' + CTXQuery.pctx	# TODO
        _loc2_ += '&' + VodParser.ctx
        _loc2_ += '&r=' + new Date().valueOf()	# TODO
        # done
        return _loc2_
        # TODO end
    
    # end VodPlayProxy class

# end VodPlayProxy.py


