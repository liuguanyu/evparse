# -*- coding: utf-8 -*-
# get_vid.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_vid: evparse/lib/pptv
# version 0.0.1.0 test201505162049
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
import json

from .. import base

# global vars

# eg. <script src="http://player.aplus.pptv.com/jsplayer/pid/5701.js"></script>
# pid is 5701 here
RE_PID = 'http://player\.aplus\.pptv\.com/jsplayer/pid/([0-9]+)\.js'
# eg. var webcfg = { /* reserved here */ };
# get webcfg json text
RE_WEBCFG = 'var webcfg = ({.+});'

# functions

def get_vid(url_to):
    # get html text
    html_text = base.get_html_content(url_to)
    # use re to get info from html
    # get pid
    pids = re.findall(RE_PID, html_text)
    pid = pids[0]
    # get webcfg
    webcfgs = re.findall(RE_WEBCFG, html_text)
    webcfg = webcfgs[0]
    # done
    vid_info = {}
    vid_info['pid'] = pid
    vid_info['webcfg'] = json.loads(webcfg)	# decode by json format
    return vid_info

# end get_vid.py


