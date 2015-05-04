# -*- coding: utf-8 -*-
# impls.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# impls: iqiyi, com.qiyi.player.core.model.impls 

# import

# class
class Segment(object):
    
    # def __init__(self, param1:ICorePlayer, param2:String, param3:int, param4:Number, param5:Number, param6:String, param7:Number, param8:Number):
    def __init__(self, param1, param2, param3, param4, param5, param6, param7, param8):
        # _loc9_:Array
        # _loc10_:String
        # _loc11_:String
        _loc9_ = None
        _loc10_ = None
        _loc11_ = None
        # super()
        # self._holder = param1
        # self._vid = param2
        # self._index = param3
        # self._startTime = param4
        # self._startPosition = param5
        self._url = param6
        if not(self._url == '') and not(self._url == None):
            # TODO next line
            # if self._holder and (not(self._holder.runtimeData.cacheServerIP == '')) and not(self._holder.runtimeData.cacheServerIP == None):
            #     _loc10_ = 'http://' + this._holder.runtimeData.cacheServerIP + '/'
            #     # TODO next line
            #     self._url = self._url.replace(new RegExp("http:\\/\\/(\\w|\\.)*\\/"),_loc10_)
            _loc9_ = self._url.split('/')
            if _loc9_ and len(_loc9_) > 0:
                _loc11_ = _loc9_[len(_loc9_) - 1]
                _loc9_ = _loc11_.split('.')
                if _loc9_ and len(_loc9_) > 0:
                    self._rid = _loc9_[0]
        # self._totalBytes = param7
        # self._totalTime = param8
        # self._endTime = self._startTime + self._totalTime
    
    @property
    def url(self):
        return self._url
    # end Segment class

# end impls.py


