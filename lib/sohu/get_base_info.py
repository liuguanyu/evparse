# -*- coding: utf-8 -*-
# get_base_info.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_base_info: evparse/lib/sohu 
# version 0.0.5.1 test201505031917
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

VID_TO_HD = {	# vid to hd translate
    'nor' 	: -1, 
    'nor_h265' 	: -1, 
    'high' 	: 0, 
    'high_h265' : 0, 
    'super' 	: 2, 
    'super_h265': 2, 
    'ori' 	: 4, 
    'ori_h265' 	: 4, 
    '4k_h264' 	: 7, 
    '4k_h265' 	: 8, 
    '4m_h265' 	: 8, 
}

VID_MORE_QUALITY = {	# more quality info for vid
    'nor_h265' : 'h265', 
    'high_h265' : 'h265', 
    'super_h265' : 'h265', 
    'ori_h265' : 'h265', 
    '4k_h265' : 'h265', 
    '4m_h265' : 'h265_4m', 
}

# functions

def get_vids(info):
    data = info['data']
    vid = {}
    # vid['relative']	= data['relativeId']	# 未知
    
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

def get_info(vid_info, raw_url, flag_debug=False):
    # create Main
    m = exports.Main()
    # set data
    m.currentPageUrl = raw_url
    # get request url
    url_to = m.fetchVideoInfo(vid_info['vid'])
    # DEBUG info
    if flag_debug:
        print('lib.sohu: DEBUG: frist url \"' + url_to + '\"')
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
    # get more info
    out = {}	# output info obj
    out['title'] = info['data']['tvName']
    out['sub_title'] = info['data']['subName']
    out['short_title'] = info['keyword'].split(';')[0]	# TODO this method may not be stable
    out['no'] = info['data']['num']
    # process urls
    vid_info = []
    for t in urls:
        ov = {}	# one_vid
        ov['url'] = urls[t]
        ov['hd'] = VID_TO_HD[t]
        if t in VID_MORE_QUALITY:
            ov['quailty'] = VID_MORE_QUALITY[t]
        # add one
        vid_info.append(ov)
    # done
    return vid_info, out

# end get_base_info.py


