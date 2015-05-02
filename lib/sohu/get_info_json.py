# -*- coding: utf-8 -*-
# get_info_json.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_info_json: evparse/lib/sohu 
# version 0.0.2.0 test201505021720
# author sceext <sceext@foxmail.com> 2009EisF2015, 2015.05. 
# copyright 2015 sceext
#
# This is FREE SOFTWARE, released under GNU GPLv3+ 
# please see README.md and LICENSE for more information. 
#
#    evparse : EisF Video Parse, evdh Video Parse. 
#    Copyright (C) 2015 sceext <sceext@foxmail.com> 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# import

from .o import exports
from .. import base

# global vars

# functions

def get_vids(info):
    data = info['data']
    vid = {}
    vid['relative']	= data['relativeId']	# 未知
    
    vid['nor']		= data['norVid']	# 标清
    vid['nor_h265']	= data['h265norVid']	# 标清 h265
    vid['high']		= data['highVid']	# 高清
    vid['high_h265']	= data['h265highVid']	# 高清 h265
    vid['super']	= data['superVid']	# 超清
    vid['super_h265']	= data['h265superVid']	# 超清 h265
    vid['ori']		= data['oriVid']	# 原画
    vid['ori_h265']	= data['h265oriVid']	# 原画 h265
    
    vid['4k_h264']	= data['h2644kVid']	# 4K h264
    vid['4k_h265']	= data['h2654kVid']	# 4K h265
    
    vid['4m_h265']	= data['h2654mVid']	# 4M h265, 未知
    # done
    return vid

def get_info(vid_info, raw_url):
    # create Main
    m = exports.Main()
    # set data
    m.currentPageUrl = raw_url
    # get request url
    url_to = m.fetchVideoInfo(vid_info['vid'])
    # FIXME debug here
    print('DEBUG: frist url \"' + url_to + '\"')
    # load it as json
    info = base.get_json_info(url_to)
    # get vids from it
    vids = get_vids(info)
    # create urls for vids
    urls = {}
    for t in vids:
        vid = vids[t]
        if vid != 0:
            one = m.fetchVideoInfo(vid)
            urls[t] = one
    # FIXME debug here
    return urls
    # TODO

# end get_info_json.py


