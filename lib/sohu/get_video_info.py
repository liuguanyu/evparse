# -*- coding: utf-8 -*-
# get_video_info.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_video_info: evparse/lib/sohu 
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

def get_info_obj(info_url):
    return base.get_json_info(info_url)

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

def get_video_urls(info_url):
    info = get_info_obj(info_url)
    urls = get_final_url(info)
    return urls

# end get_video_info.py


