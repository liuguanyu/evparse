# -*- coding: utf-8 -*-
# get_video_info.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_video_info: evparse/lib/pptv
# version 0.0.2.1 test201505172208
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

from .o import exports

# global vars

VIDEO_FT_TO_HD = {	# translate pptv video ft to evparse hd number
    0 : 0, 	# NOTE may be not right
    1 : 1, 	# NOTE reserved
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

# get real file download url
def get_file_url(info, raw):
    # get info
    file_name = info['item'].attrib['rid']
    file_key = info['dt'].find('key').text
    file_id = info['dt'].find('id').text
    file_no = raw['no']
    # make info obj
    to = {}
    to['dt_id'] = file_id
    to['dt_key'] = file_key
    to['file_item_rid'] = file_name
    to['no'] = file_no
    # just get url
    file_url = exports.get_cdn_url(to)
    # done
    return file_url

def get_file_info(info, flist):
    finfo = []	# file info
    # get each file info
    for one in flist:
        item = {}
        raw = one.attrib
        item['size'] = number(raw['fs'])
        item['time_s'] = number(raw['dur'])
        # get file real download url
        file_url = get_file_url(info, raw)
        item['url'] = file_url
        # get one file done
        finfo.append(item)
    # done
    return finfo

# get one video info
def get_one_info(info):
    # get info
    dragdata = info['dragdata'].attrib
    # add some info
    vinfo = {}
    vinfo['hd'] = info['hd']
    vinfo['format'] = 'mp4'	# the format of video file is mp4 now
    vinfo['size_px'] = [dragdata['vw'], dragdata['vh']]
    vinfo['file'] = []
    # add size_byte and time_s
    vinfo['size_byte'] = number(dragdata['fs'])
    vinfo['time_s'] = number(dragdata['du'])
    # check flag, and get file info
    if info['flag_get_file']:
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
    # add channel>file>item to list
    items = root.find('channel').find('file').findall('item')
    for one in items:
        ft = one.attrib['ft']
        info_list[int(ft)]['item'] = one
    # sort list by ft
    info_list.sort(key=lambda x:x['ft'], reverse=True)
    # add hd
    for one in info_list:
        hd = VIDEO_FT_TO_HD[int(one['ft'])]
        one['hd'] = hd
    # set flag_get_file
    for one in info_list:
        one['flag_get_file'] = False
        hd = one['hd']
        if hd >= hd_min and hd <= hd_max:
            one['flag_get_file'] = True
    # get each info, just use for
    vinfo = []
    for one in info_list:
        item = get_one_info(one)
        vinfo.append(item)
    # done
    return vinfo

# end get_video_info.py


