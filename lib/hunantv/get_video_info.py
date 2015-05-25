# -*- coding: utf-8 -*-
# get_video_info.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_video_info: evparse/lib/hunantv 
# version 0.0.4.0 test201505251455
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

from .. import base

# global vars

FIX_REFERER = 'http://i1.hunantv.com/ui/swf/player/v0415/main.swf'
FIX_USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:37.0) Gecko/20100101 Firefox/37.0'

VIDEO_NAME_TO_HD = {	# translate hunantv video name to evparse hd number
    '标清' : 0, 	# TODO, may be not right
    '高清' : 1, 	# TODO
    '超清' : 2, 	# TODO
}

# functions

def get_one_real_url(final_url):	# get the url of the video file to download
    info = base.get_json_info(final_url)
    return info['info']

def get_file_info(item, vinfo):
    finfo = []
    one = {}
    # add base info, now it is always one file per video
    one['size'] = vinfo['size_byte']
    one['time_s'] = vinfo['time_s']
    # get real url
    one['url'] = get_one_real_url(item['url'])
    # add user_agent and referer for it
    one['user_agent'] = FIX_USER_AGENT
    one['referer'] = FIX_REFERER
    # done
    finfo.append(one)
    return finfo

def get_one_info(item, info):	# item, todo_item
    # add some info
    vinfo = {}
    vinfo['hd'] = item['hd']
    vinfo['format'] = 'fhv'	# the format of video file is fhv now
    vinfo['size_px'] = [-1, -1]	# TODO not support this now
    vinfo['count'] = 1	# NOTE hunantv, only 1 file
    vinfo['file'] = []
    # add size_byte and time_s
    vinfo['size_byte'] = -1	# TODO not support this now
    vinfo['time_s'] = int(info['data']['info']['duration'])
    # check flag, and get file info
    if item['flag_get_file']:
        vinfo['file'] = get_file_info(item, vinfo)
        # clear size_byte and time_s
        del vinfo['size_byte']
        del vinfo['time_s']
    # done
    return vinfo

def get_info(info, hd_min=0, hd_max=0, flag_debug=False):
    # get raw video list
    raw_list = info['data']['stream']
    # make video list
    vlist = []
    for one in raw_list:
        item = {}
        item['url'] = one['url']
        item['hd'] = VIDEO_NAME_TO_HD[one['name']]
        vlist.append(item)
    # set flag_get_file
    for i in vlist:
        hd = i['hd']
        i['flag_get_file'] = False
        if (hd >= hd_min) and (hd <= hd_max):
            i['flag_get_file'] = True
    # sort video by hd
    vlist.sort(key=lambda item:item['hd'], reverse=False)
    # get each info
    vinfo = []
    for one in vlist:
        vinfo.append(get_one_info(one, info))
    # done
    return vinfo

# end get_video_info.py


