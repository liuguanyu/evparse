# -*- coding: utf-8 -*-
# get_vid.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_vid: evparse/lib/sohu 
# version 0.1.0.0 test201505032157
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

from .. import base

# global vars
RE_VID = 'var vid="([0-9]+)";'

# functions

def get_vid(url):
    # get html text
    html_text = base.get_html_content(url)
    # use re to get vid and tvid
    vids = re.findall(RE_VID, html_text)
    vid = vids[0]
    # done
    vid_info = {}
    vid_info['vid'] = vid
    return vid_info

# end get_vid.py


