# -*- coding: utf-8 -*-
# PlayerConfig.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# PlayerConfig: sohu, com.sohu.tv.mediaplayer

class PlayerConfig(object):
    
    FETCH_VINFO_PATH = 'http://hot.vrs.sohu.com/vrs_flash.action?vid='
    # FETCH_VINFO_PATH_TRANSITION = 'http://hot.vrs.sohu.com/vrs_vms.action?p=flash&old='
    # FETCH_VINFO_PATH_MYTV = 'http://my.tv.sohu.com/play/videonew.do?vid='
    # FETCH_LIVE_PATH = 'http://live.tv.sohu.com/live/player_json.jhtml?encoding=utf-8&lid='
    
    FETCH_VINFO_SUB_IP = ['220.181.118.25','220.181.118.181','123.126.48.47','123.126.48.48']
    
    # STAT_IP = ['qf1.hd.sohu.com.cn','qf2.hd.sohu.com.cn']
    # STAT_IP_QFCLIPS = ['qf3.hd.sohu.com.cn','qf4.hd.sohu.com.cn','qf5.hd.sohu.com.cn']
    
    VERSION = '201504291040'
    
    # static config, useful
    # clientWidth = 1920
    # clientHeight = 1080
    # for debug
    clientWidth = 1005
    clientHeight = 531
    
    # cdnMd for this clientWidth 1005, clientHeight 531 and VERSION '201504291040'
    cdnMd = 'ENf8NUCIbC0pBUaXlEtROwyOwvq5S+w+tFaG9g==101'
    
    def __init__(self):
        
        # self.hashId = []
        # self.key = []
        # self.fileSize = []
        
        # self.clientIp = ''
        # self.cdnIp = ''
        # self.cdnId = ''
        
        # self.filePrimaryReferer = ''
        # self.currentPageUrl = ''
        # self.outReferer = ''
        
        # self.vid = ''
        self.norVid = ''	# 标清
        self.hdVid = ''		# 高清
        self.superVid = ''	# 超清
        self.oriVid = ''	# 原画
        self.h2644kVid = ''	# 4K, h264
        self.h2654kVid = ''	# 4K, h265
        # norVid	标清
        # highVid	高清
        # superVid	超清
        # oriVid	原画
        # h2644kVid	4K, h264
        # h265norVid	标清, h265
        # h265highVid	高清, h265
        # h265superVid	超清, h265
        # h265oriVid	原画, h265
        # h2654mVid	(未知)
        # h2654kVid	4K, h265
        self.relativeId = ''
        self.currentVid = ''
        self.tvid = ''
        # self.cid = ''
        # self.userId = ''
        # self.myTvUid = ''
        # self.myTvUserId = ''
        # self.uuid = ''
        # self.isLive = False
        
        # done

# end PlayerConfig.py


