# -*- coding: utf-8 -*-
# config.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# config: iqiyi, com.qiyi.player.core 

class Config(object):
    
    CHECK_LIMIT_URL = 'http://cache.vip.qiyi.com/ip/'
    CHECK_V_INFO_URL = 'http://data.video.qiyi.com/v.f4v'
    VIP_AUTH_URL = 'http://api.vip.iqiyi.com/services/ck.action'
    MIXER_VX_URL = 'http://cache.video.qiyi.com/vms'
    MIXER_VX_VIP_URL = 'http://cache.vip.qiyi.com/vms'
    
    FIRST_DISPATCH_URL = 'http://data.video.qiyi.com/t'
    
    MIXER_TIMEOUT = 10000
    MIXER_MAX_RETRY = 2
    
    VRS_INFO_TIMEOUT = 10000
    VRS_INFO_MAX_RETRY = 2
    META_TIMEOUT = 10000
    DISPATCH_TIMEOUT = 10000
    DISPATCH_MAX_RETRY = 2
    
    def __init__(self):
        pass
        # done

# end config.py


