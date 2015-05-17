# -*- coding: utf-8 -*-
# VodCommon.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# VodCommon: pptv, player4player2: cn.pplive.player.common.VodCommon

# import

# global static data

# important data

# priplay :String
priplay = None	# TODO
# playStr :String
playStr = None	# NOTE can be None
# pid :String
pid = None	# NOTE should be set
# smart :String
smart = None	# NOTE can be None

playType = 'web.fpp'	# NOTE can be ''web.fpp''

version = '3.4.0.12'

# may be important

liveVS = '1.1.0.31'

# clid :String
# title :String
# link :String
# swf :String
clid = None
title = None
link = None
swf = None

# pl :String
# puid :String
# mkey :String
# currRid :String
pl = None
puid = None
mkey = None
currRid = None

# TODO start
barrageDisplay = False
isMetadata = False
isPatch = False
aheadCount = 0
isHttpRequest = True
# isSVavailable :Boolean = None
# isSV :Boolean = None
isTheatre = False
isPPAP = False
# TODO end

# other data

# playerWidth :Number = None
# playerHeight :Number = None
# isEmpty = True
# isSkipPrelude = True
# cookie :AS3Cookie = None
# row :Number = 10
# column :Number = 10
# preSnapshot :Vector.<Object>
# volume :Number = 50
# hardwareDecoding :Boolean = None
# hardwareEncoding :Boolean = None
# snapshotHeight = 720
# snapshotVersion :Number = None
# playstate = 'paused'
# allowInteractive = 'always'
# allowScreenClick = 'all'

callCode = {
    'config' : [
        '1000', 
        '1001-error', 
        '1002-security', 
        '1003-timeout', 
    ], 
    'play' : [
        '2000', 
        '2001-error', 
        '2002-security', 
        '2003-timeout', 
        '2004-nodt', 
        '2005', 
        '2006-nochannel', 
        '2007', 
        '2008-rb', 
    ], 
    'video' : [
        '3000', 
        '3001-error', 
        '3002-security', 
        '3003-timeout', 
        '3004-mandatory ppap', 
        '3005-switch stream ppap', 
        '3006', 
        '3007', 
        '3008', 
    ], 
}

# purl = 'http://download.pplive.com/config/pplite/superplugin.exe'
# cline_add = 'http://download.pplive.com/pptv/self/PPTV(pplive)_guide_forqd1_pause.exe'
# initErrorText = '播放器初始化数据错误，请刷新后重试'
# playErrorText = '非常抱歉，我们暂无此视频资源<br>【%code%】'
# playSkipStartText = '已经为您跳过片头'
# playSkipEndText = '已经为您设置了跳过片尾，视频即将结束'
# playVipTipTexT = '请 <a href=\"event:vip\">开通VIP会员</a> 播放此视频'
# playPayText = '<a href=\"http://pay.ddp.vip.pptv.com/?id=[CID]&type=0&aid=vod_detail_play\" target=\"_self\">立即购买</a>观看完整版'
# playSmoothText = '当前播放不流畅，可选择下载<a href=\"' + cline_add + '\"> 客户端 </a>观看'
# playPayFreeText = '当前正在播放免费试看，' + playPayText
# playPayNoFreeText = '当前付费节目，请' + playPayText
# playPayFreeEndText = '当前免费试看已经结束，请' + playPayText
# installPPAPText = '请安装 <a href=\"' + purl + '\">PP插件</a> 观看更清晰节目'
# VersionText = '您当前的Flash播放器版本过低，请下载Flash Player10.2及其以上版本。<br>下载完毕后请重新刷新页面播放。<br>下载地址：<a href=\"https://get.adobe.com/flashplayer/\" target=\"_blank\"><b>https://get.adobe.com/flashplayer/</b></a>'

# end VodCommon.py


