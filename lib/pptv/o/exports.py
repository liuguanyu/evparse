# -*- coding: utf-8 -*-
# exports.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# exports: exports and imports for lib/pptv/o. 

# import

# import out

# import in

from .player.view import CTXQuery as CTXQuery0
from .player.common import VodCommon as VodCommon0
from .player.common import VodParser as VodParser0
from .player.model import VodPlayProxy as VodPlayProxy0
from . import VodFacade as VodFacade0

from .vodcore import PlayInfo as PlayInfo0

# set in

# functions

# set in status
def set_info(vid_info):
    # get info from vid_info
    page_url = vid_info['url']
    pid = vid_info['pid']
    webcfg = vid_info['webcfg']
    # set info to in
    VodFacade0.page_url = page_url
    # set CTXQuery
    VodFacade0.ergodic()
    # get info from webcfg
    cid = webcfg['id']
    ctx = webcfg['player']['ctx']
    # set to in
    VodCommon0.pid = pid
    VodParser0.cid = cid
    # set ctx to CTXQuery
    CTXQuery0.setCTX(ctx)
    # update VodParser.ctx
    VodParser0.ctx = CTXQuery0.cctx()
    # done

# get url of first stage xml info
def get_first_url():
    # create VodPlayProxy object
    vpp = VodPlayProxy0.VodPlayProxy()
    # just get it
    url = vpp.get_playUrl()
    # done
    return url

# get file download cdn url
def get_cdn_url(info):
    # create PlayInfo obj
    pi = PlayInfo0.PlayInfo()
    # set pi
    pi.key = info['dt_id']
    pi.k = info['dt_key']
    pi.fileName = info['file_item_rid']
    # get url
    cdn_url = pi.constructCdnURL(info['no'])
    # done
    return cdn_url

# exports

CTXQuery = CTXQuery0
VodCommon = VodCommon0
VodParser = VodParser0
VodPlayProxy = VodPlayProxy0
VodFacade = VodFacade0
PlayInfo = PlayInfo0

# end exports.py


