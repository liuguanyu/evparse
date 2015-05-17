# -*- coding: utf-8 -*-
# get_video_info.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_video_info: evparse/lib/pptv
# version 0.0.1.0 test201505171427
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

import xml.etree.ElementTree as ET

# TODO reserved
from .. import base

# global vars

VIDEO_FT_TO_HD = {	# translate pptv video ft to evparse hd number
    0 : 0, 	# TODO reserved
    1 : 1, 	# TODO
    2 : 2, 	# 720p
    3 : 4, 	# 1080p
    4 : 5, 	# high bitrate 1080p
}

# base functions
def number(text):
    n = float(text)
    i = int(n)
    if n == i:
        return i
    return n

# functions

# TODO get file real download url

# TODO reserved
def get_file_info(info, flist):
    finfo = []	# file info
    # get each file info
    for one in flist:
        item = {}
        raw = one.attrib
        item['size'] = raw['fs']
        item['time_s'] = raw['dur']
        item['url'] = ''	# TODO no support this now
        # get one file done
        finfo.push(item)
    # done
    return finfo

# get one video info
def get_one_info(info):
    # get info
    dragdata = info['dragdata'].attrib
    # add some info
    vinfo = {}
    vinfo['hd'] = item['hd']
    vinfo['format'] = 'mp4'	# the format of video file is mp4 now
    vinfo['size_px'] = [dragdata['vw'], dragdata['vh']]
    vinfo['file'] = []
    # add size_byte and time_s
    vinfo['size_byte'] = number(dragdata['fs'])
    vinfo['time_s'] = number(dragdata['du'])
    # check flag, and get file info
    if item['flag_get_file']:
        flist = info['dragdata'].findall('sgm')
        vinfo['file'] = get_file_info(info, flist)
        # clear size_byte and time_s
        del vinfo['size_byte']
        del vinfo['time_s']
    # done
    return vinfo

# get video info
def get_info(info, hd_min=0, hd_max=0, flag_debug=False):
    # parse raw_text as xml
    root = ET.fromstring(info['raw_text'])
    # get video list info
    dt = root.findall('dt')
    dragdata = root.findall('dragdata')
    info_list = []
    for i in range(len(dt)):
        info_list.append(None)
    # add info to list
    for one in dt:
        ft = one.attrib['ft']
        item = {}
        item['dt'] = one
        item['ft'] = ft
        info_list[int(ft)] = item
    for one in dragdata:
        ft = one.attrib['ft']
        info_list[int(ft)]['dragdata'] = one
    # sort list by ft
    info_list.sort(reverse=True)
    # add hd
    for one in info_list:
        hd = VIDEO_FT_TO_HD[one['ft']]
        one['hd'] = hd
    # set flag_get_file
    for one in info_list:
        one['flag_get_file'] = False
        hd = one['hd']
        if hd >= hd_min and hd <= hd_max:
            one['flag_get_file'] = True
    # get each info, TODO use base.map_do()
    vinfo = []
    for one in raw_list:
        item = get_one_info(one)
        vinfo.append(item)
    # done
    return vinfo

# end get_video_info.py


