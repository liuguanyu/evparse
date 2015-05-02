# -*- coding: utf-8 -*-
# get_vid.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_vid: evparse/lib/iqiyi 
# version 0.0.1.0 test201504291500
# author sceext <sceext@foxmail.com> 2009EisF2015, 2015.04. 
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

from .. import base

# global vars
RE_VID = 'data-(player|drama)-videoid="([^"]+)"'
RE_TVID = 'data-(player|drama)-tvid="([^"]+)"'

# functions

def get_vid(url):
    # get html text
    html_text = base.get_html_content(url)
    # use re to get vid and tvid
    vids = re.findall(RE_VID, html_text)
    tvids = re.findall(RE_TVID, html_text)
    vid = vids[0][1]
    tvid = tvids[0][1]
    # done
    vid_info = {}
    vid_info['vid'] = vid
    vid_info['tvid'] = tvid
    return vid_info

# end get_vid.py


