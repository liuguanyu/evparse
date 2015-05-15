# -*- coding: utf-8 -*-
# entry.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# entry: evparse/lib/hunantv
# version 0.0.1.0 test201505151656
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

import re

from .. import error

from . import get_base_info
from . import get_video_info

# global vars

# version of this extractor
THIS_EXTRACTOR_VERSION = 'evparse lib/hunantv version 0.0.1.0 test201505151654'

# http://www.hunantv.com/v/2/150668/f/1518250.html#
# http://www.hunantv.com/v/2/51717/f/692063.html#
# http://www.hunantv.com/v/2/107768/f/1517224.html#
RE_SUPPORT_URL = '^http://www\.hunantv\.com/v/2/[0-9]+/f/[0-9]+\.html'

RE_VID = 'http://www\.hunantv\.com/v/2/[0-9]+/f/([0-9]+)\.html'

# global config obj
etc = {}	# NOTE should be set
etc['flag_debug'] = False
etc['hd_max'] = 0
etc['hd_min'] = 0

# functions

def set_config(config):
    # just copy it
    etc['flag_debug'] = config['flag_debug']
    etc['hd_max'] = config['hd_max']
    etc['hd_min'] = config['hd_min']

# get vid
def get_vid(url_to):
    vid_info = {}
    vid_info['url'] = url_to
    # get vid
    vids = re.findall(RE_VID, url_to)
    vid_info['vid'] = vids[0]
    # done
    return vid_info

def parse(url_to):	# this site entry main entry function
    # frist re-check url, if supported by this
    if not re.match(RE_SUPPORT_URL, url_to):
        raise error.NotSupportURLError('not support this url', url_to)
    # create evinfo
    evinfo = {}
    evinfo['info'] = {}
    evinfo['video'] = []
    # add some base info
    evinfo['info']['url'] = url_to
    evinfo['info']['site'] = 'hunantv'
    # get vid
    vid_info = get_vid(url_to)
    # DEBUG info
    if etc['flag_debug']:
        print('lib.hunantv: DEBUG: got vid \"' + vid_info['vid'] + '\" ')
    # get base, more info
    info, more = get_base_info.get_info(vid_info, flag_debug=etc['flag_debug'])
    
    # add more info
    evinfo['info']['title'] = more['title']
    evinfo['info']['title_sub'] = more['sub_title']
    evinfo['info']['title_short'] = more['short_title']
    evinfo['info']['title_no'] = more['no']
    # TODO FIXME reserved
    # get video info
    # evinfo['video'] = get_video_info.get_info(info, hd_max=etc['hd_max'], hd_min=etc['hd_min'], flag_debug=etc['flag_debug'])
    # done
    return evinfo

# end entry.py


