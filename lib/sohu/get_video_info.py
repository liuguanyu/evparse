# -*- coding: utf-8 -*-
# get_video_info.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_video_info: evparse/lib/sohu 
# version 0.1.0.0 test201505032158
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

POOL_SIZE_GET_VINFO = 4
POOL_SIZE_GET_REAL_URL = 8

# functions

def get_info_obj(info_url):
    return base.get_json_info(info_url)

def get_one_real_url(final_url):	# get the url of the video file to download
    info = get_info_obj(final_url)
    return info['url']

def get_final_url(info):
    # create NetStream
    ns = exports.NetStream()
    # set info
    ns.update_info(info)
    # get video file list length
    list_length = len(ns)
    # get each url
    urls = []
    i = 0
    while i < list_length:
        urls.append(ns.loadLocationAndPlay(i))
        i += 1
    # done
    return urls

def get_file_info(info):
    # get info
    file_size = info['data']['clipsBytes']
    file_time = info['data']['clipsDuration']
    # get urls
    raw_urls = get_final_url(info)
    # create file info struct
    finfo = []
    for i in range(len(raw_urls)):
        one = {}
        one['time_s'] = file_time[i]
        one['size'] = file_size[i]
        one['url'] = raw_urls[i]
        finfo.append(one)
    # done
    return finfo

def get_one_info(item):	# item, todo_item
    url = item['url']
    info = get_info_obj(url)
    # add some info
    vinfo = {}
    vinfo['hd'] = item['hd']
    if 'quality' in item:
        vinfo['quality'] = item['quality']
    vinfo['format'] = 'mp4'	# the format of video file is mp4 now
    vinfo['size_px'] = [info['data']['width'], info['data']['height']]	# size of video in px
    vinfo['file'] = []
    # add size_byte and time_s
    vinfo['size_byte'] = info['data']['totalBytes']
    vinfo['time_s'] = info['data']['totalDuration']
    # check flag, and get file info
    if item['flag_get_file']:
        vinfo['file'] = get_file_info(info)
        # clear size_byte and time_s
        del vinfo['size_byte']
        del vinfo['time_s']
    # done
    return vinfo

def get_info(info_list, hd_max=0, hd_min=0, flag_debug=False):
    # make to_do list
    todo_list = []
    for i in info_list:
        # set flag_get_file
        hd = i['hd']
        i['flag_get_file'] = False
        if (hd >= hd_min) and (hd <= hd_max):
            i['flag_get_file'] = True
        todo_list.append(i)
    # sort video by hd
    todo_list.sort(key=lambda item:item['hd'], reverse=False)
    # use map_do
    vinfo = base.map_do(todo_list, get_one_info, pool_size=POOL_SIZE_GET_VINFO)
    # get urls to get real urls
    todo_url = []
    for j in vinfo:
        for i in j['file']:
            todo_url.append(i['url'])
    # use map_do to get real_urls
    real_urls = base.map_do(todo_url, get_one_real_url, pool_size=POOL_SIZE_GET_REAL_URL)
    # update real_urls
    url_i = 0
    for j in vinfo:
        for i in j['file']:
            i['url'] = real_urls[url_i]
            url_i += 1
    # done
    return vinfo

# end get_video_info.py


