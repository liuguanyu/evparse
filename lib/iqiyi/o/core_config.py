# -*- coding: utf-8 -*-
# core_config.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# core_config: iqiyi, com.qiyi.player.core 

class Config(object):
    
    def __init__(self):
        
        self.CHECK_LIMIT_URL = 'http://cache.vip.qiyi.com/ip/'
        self.CHECK_V_INFO_URL = 'http://data.video.qiyi.com/v.f4v'
        self.VIP_AUTH_URL = 'http://api.vip.iqiyi.com/services/ck.action'
        self.MIXER_VX_URL = 'http://cache.video.qiyi.com/vms'
        self.MIXER_VX_VIP_URL = 'http://cache.vip.qiyi.com/vms'
        
        self.FIRST_DISPATCH_URL = 'http://data.video.qiyi.com/t'
        
        self.MIXER_TIMEOUT = 10000
        self.MIXER_MAX_RETRY = 2
        
        self.VRS_INFO_TIMEOUT = 10000
        self.VRS_INFO_MAX_RETRY = 2
        self.META_TIMEOUT = 10000
        self.DISPATCH_TIMEOUT = 10000
        self.DISPATCH_MAX_RETRY = 2
        
        # done

# end core_config.py


