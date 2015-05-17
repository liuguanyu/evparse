# -*- coding: utf-8 -*-
# PlayInfo.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# PlayInfo: pptv, VodCore: com.pplive.play.PlayInfo

# import

from . import Version

# global static data

# class

class PlayInfo(object):
    
    def __init__(self):
        # important data
        self.key = ''		# NOTE should be set
        self.k = ''		# NOTE should be set
        self.fileName = ''	# NOTE should be set
        
        self.type = 'type=web.fpp'	# default value is 'type=web.fpp'
        self.variables = ''	# NOTE can be ''
        
        self.host = 'ccf.pptv.com'	# NOTE can be 'ccf.pptv.com'
        
        # other data
        self.isVip = False	# default value is False
        self.ft = '0'		# default value is '0'
        # self.bwType :uint
        # self.segments :Vector.<SegmentInfo>
        # self.backupHostVector :Vector.<String>
        # self.duration = -1
        # self.draghost = ''
        # init done
    
    # def constructCdnURL(param1 :uint, param2 :String = null, param3 :uint = 0, param4 :uint = 0): String
    def constructCdnURL(self, param1, param2=None, param3=0, param4=0):
        _loc5 = None
        if param2 == None:
            param2 = self.host
        # NOTE fix it, param3 == 0 and param4 == 0
        # FIX start
        # if param3 == 0 and param4 == 0:
        #     _loc5 = 'http://' + param2 + '/' + param1 + '/' + self.fileName
        # else:
        # FIX, just add /0/0/ to url
        _loc5 = 'http://' + param2 + '/' + param1 + '/' + param3 + '/' + param4 + '/' + self.fileName
        # FIX end
        _loc5 += '?fpp.ver=' + Version.version
        return self.addVariables(_loc5)
    
    # def addVariables(param1: String): String
    def addVariables(self, param1):
        if self.key != '':
            param1 += '&key=' + self.key
        if self.k != '':
            param1 += '&k=' + self.k
        if self.type != '':
            param1 += '&' + self.type
        else:
            param1 += '&type=web.fpp'
        if self.variables != '':
            param1 += '&' + self.variables
        return param1
    
    # end PlayInfo class

# end PlayInfo.py


