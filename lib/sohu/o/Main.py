# -*- coding: utf-8 -*-
# Main.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# Main: sohu, .

# import

from urllib.parse import quote
import time
import random

from .PlayerConfig import PlayerConfig

# class

class Main(object):
    
    def __init__(self):
        self.domainProperty = 0
        # may be 0, 1, 2, 3
        # 0 default sohu domain
        # 1 unknow
        # 2 other
        # 3 56.com domain
        self.currentPageUrl = ''
        # self.flag_isTransition = False
    
    def fetchVideoInfo(self, _vid):
        param1 = _vid
        # reserved
        # _loc20_ = None
        # _loc21_ = None
        # _loc22_ = 0
        # _loc23_ = None
        # _loc24_ = None
        # _loc2_ = PlayerConfig.isPreview ? PlayerConfig.FETCH_VINFO_PATH_PREVIEW:PlayerConfig.isTransition ? PlayerConfig.FETCH_VINFO_PATH_TRANSITION : PlayerConfig.isMyTvVideo ? PlayerConfig.FETCH_VINFO_PATH_MYTV : PlayerConfig.liveType != '' ? PlayerConfig.FETCH_LIVE_PATH : PlayerConfig.FETCH_VINFO_PATH
        _loc2_ = PlayerConfig.FETCH_VINFO_PATH
        _loc3_ = param1
        # reserved
        # if self.flag_isTransition:
        #     # _loc20_ = param1.split("|")
        #     _loc21_ = ''
        #     _loc22_ = 0
        #     while _loc22_ < len(_loc20_)
        #         _loc23_ = _loc20_[_loc22_].split("/")
        #         _loc24_ = _loc23_[len(_loc23_) - 1]
        #         _loc21_ = _loc21_ + (_loc24_ + (_loc22_ == len(_loc20_) - 1 ? '' : '|'))
        #         _loc22_ += 1
        #     if (not (_loc21_ == '') and (not (_loc21_ == None):
        #         _loc3_ = _loc21_
        # TODO reserved
        # if this._tvSohuMpb != None:
        #     this._tvSohuMpb.core.stop("noevent");
        # if(!(this._ads == null) && (this._isPlayStartAd)) {
        # this._ads.destroy();
        # this._isShowPlayedAd = false;
        # }
        # PlayerConfig.vid = param1;
        # this._mpbSoftInitSuc = false;
        # NOTE reserved
        # _loc4_ = ''
        # if this._isPlayStartAd:
        #     _loc4_ = this.getParams("co") != ""?"&co=" + this.getParams("co"):"";
        
        # reserved
        # _loc5_ = this._version != '' ? '&ver=' + this._version : ''
        # _loc6_ = this._autoFix == '1' ? '&af=1' : ''
        # _loc7_ = this.getParams("fkey")
        # _loc8_ = _loc7_ != '' ? '&fkey=' + _loc7_ : ''
        # _loc9_ = PlayerConfig.apiKey != '' ? '&api_key=' + PlayerConfig.apiKey : ''
        # _loc10_ = PlayerConfig.liveType != '' ? '&type=' + PlayerConfig.liveType : ''
        # _loc11_ = PlayerConfig.needP2PLive ? '&quick=1' : ''
        # NOTE reserved
        # _loc5_ = ''
        # _loc6_ = ''
        # _loc7_ = ''
        # _loc8_ = ''
        # _loc9_ = ''
        # _loc10_ = ''
        # _loc11_ = ''
        
        # _loc12_ = '&referer=' + (PlayerConfig.currentPageUrl == '' ? escape(PlayerConfig.outReferer) : escape(PlayerConfig.currentPageUrl))
        # NOTE javascript escape() to urllib.parse.quote()
        _loc12_ = '&referer=' + quote(self.currentPageUrl)
        
        # PlayerConfig.needP2PLive = false
        # _loc13_ = PlayerConfig.plid != '' ? '&plid=' + PlayerConfig.plid : ''
        # _loc14_ = this._bandwidth != 0 ? '&bw=' + this._bandwidth : ''
        # _loc15_ = this._isPwd ? '&passwd=' + (this._tvSohuErrorMsg != null ? this._tvSohuErrorMsg.pwdStr : '') : ''
        # _loc16_ = P2PExplorer.getInstance().hasP2P ? '&hasIfox=1' : ''
        # _loc17_ = PlayerConfig.userId != '' ? '&uid=' + PlayerConfig.userId : ''
        # _loc18_ = PlayerConfig.cooperator != '' ? '&cooperator=' + PlayerConfig.cooperator : ''
        # _loc19_ = !(PlayerConfig.authorId == '') && !(PlayerConfig.authorId == null) ? '&authorId=' + PlayerConfig.authorId : ''
        # _loc13_ = ''
        # _loc14_ = ''
        # _loc15_ = ''
        # _loc16_ = ''
        # _loc17_ = ''
        # _loc18_ = ''
        # _loc19_ = ''
        
        # this._model.fetchVideoInfo(_loc2_ + _loc3_ + _loc5_ + _loc6_ + _loc14_ + _loc4_ + _loc8_ + _loc9_ + _loc16_ + _loc10_ + _loc11_ + _loc13_ + _loc17_ + _loc19_ + _loc18_ + "&out=" + PlayerConfig.domainProperty + _loc15_ + "&g=" + Math.abs(new Date().getTimezoneOffset() / 60) + _loc12_);
        # this._autoFix = this._version = ''
        # return (_loc2_ + _loc3_ + _loc5_ + _loc6_ + _loc14_ + _loc4_ + _loc8_ + _loc9_ + _loc16_ + _loc10_ + _loc11_ + _loc13_ + _loc17_ + _loc19_ + _loc18_ + '&out=' + PlayerConfig.domainProperty + _loc15_ + '&g=' + Math.abs(new Date().getTimezoneOffset() / 60) + _loc12_)	# TODO
        # delete _loc4_, _loc5_, _loc6_, _loc7_, _loc8_, _loc9_, _loc10_, _loc11_, _loc13_, _loc14_, _loc15_, _loc16_, _loc17_, _loc18_, _loc19_
        # NOTE new Date().getTimezoneOffset() to time.timezone / 60
        _g = int(round(abs(time.timezone / 60 / 60)))
        url_to = _loc2_ + _loc3_ + '&out=' + str(self.domainProperty) + '&g=' + str(_g) + _loc12_
        # add tn
        url_to += '&t=' + str(random.random())
        # done
        return url_to
    pass

# end Main.py


