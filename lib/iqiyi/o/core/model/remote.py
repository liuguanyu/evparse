# -*- coding: utf-8 -*-
# remote.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# remote: iqiyi, com.qiyi.player.core.model.remote 

# import
from ..config import Config
from ...base.utils import Utility

getTimer = None
# NOTE should be set
def set_import(flash):
    global getTimer
    getTimer = flash.getTimer

# class
class FirstDispatchRemote(object):
    pass

class SecondDispatchRemote(object):
    
    def __init__(self, p_segment, p_runtimeData, p_uuid):
        # TODO
        self.segment = p_segment
        # TODO
        self.runtimeData = p_runtimeData
        # TODO
        self.uuid = p_uuid
    
    def getRequest(self):
        # _loc1_:String
        _loc1_ = Utility.getUrl(self.segment.url, self.runtimeData.key)
        # TODO just reserved
        # if this._startPos == -1:
        #     if (this._segment.currentKeyframe) && !(this._segment.currentKeyframe.index == 0):
        #         _loc1_ = _loc1_ + ("?start=" + this._segment.currentKeyframe.position.toString())
        # elif this._startPos != 0:
        #     _loc1_ = _loc1_ + ("?start=" + this._startPos.toString())
        if '?' in _loc1_:
            _loc1_ += '&'
        else:
            _loc1_ += '?'
        # TODO next line
        _loc1_ += 'su=' + self.uuid
        # TODO reserved
        # if this._holder.runtimeData.retryCount > 0:
        #     _loc1_ += '&retry=' + str(self._holder.runtimeData.retryCount)
        _loc1_ += '&client=' + self.runtimeData.currentUserIP
        _loc1_ += '&z=' + self.runtimeData.preDispatchArea
        _loc1_ += '&mi=' + self.runtimeData.movieInfo
        _loc1_ += '&bt=' + self.runtimeData.preDefinition
        _loc1_ += '&ct=' + self.runtimeData.currentDefinition
        # TODO reserved
        # if this._holder.runtimeData.preAverageSpeed > 0:
        #     _loc1_ += '&s=' + str(self._holder.runtimeData.preAverageSpeed)
        _loc1_ += '&e=' + self.runtimeData.preErrorCode
        _loc1_ += '&qyid=' + self.uuid
        _loc1_ += '&tn=' + str(getTimer())
        # just return url
        return _loc1_
    # end SecondDispatchRemote class

# end remote.py


