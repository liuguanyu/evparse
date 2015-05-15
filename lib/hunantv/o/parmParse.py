# -*- coding: utf-8 -*-
# parmParse.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# parmParse: hunantv, com.parmParse

# import

from .Encrypt import Encrypt

# global static data
mServerAddress = 'http://v.api.hunantv.com/player/video?video_id='

# class

class parmParse(object):
    
    def __init__(self):
        self.vid = ''	# NOTE should be set
    
    def GetServerAddress(self):
        return mServerAddress + self.vid
    
    def GetMovieInfo(self, param1);
        url_to = param1 + '&random=' + Encrypt.creatRandomCode(8)
        return url_to
    
    def Init(self):
        return self.GetMovieInfo(self.GetServerAddress())
    
    # end parmParse class

# end parmParse.py


