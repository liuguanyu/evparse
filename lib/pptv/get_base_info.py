# -*- coding: utf-8 -*-
# get_base_info.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# evparse: lib/pptv/get_base_info
# version 0.0.3.0 test201505171924
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
from .. import base

# base funciton

# TODO reserved
def get_first_int_from_string(text):
    t2 = ''
    flag = False
    for c in text:
        try:
            if 0 <= int(c) and 9 >= int(c):
                flag = True
                t2 += c
        except ValueError:
            if flag:
                break
    # done
    return int(t2)

# functions

def get_info(vid_info, flag_debug=False):
    # set vid_info to exports
    exports.set_info(vid_info)
    # get first url
    first_url = exports.get_first_url()
    # debug info
    print('evparse: lib.pptv: DEBUG: got first_url \"' + first_url + '\" ')
    # load it as text
    raw_text = base.get_http_text(first_url)
    # get more info
    more = get_more_info(raw_text)
    # done
    return raw_text, more

def get_more_info(raw_text):
    more = {}	# more info
    # parse it as xml
    root = ET.fromstring(raw_text)
    # get info data
    channel = root.find('channel')
    data = channel.attrib
    # get more
    more['title'] = data['nm']
    more['sub_title'] = ''	# TODO not support this
    more['short_title'] = ''
    if 'hjnm' in data:
        more['short_title'] = data['hjnm']
    more['no'] = -1	# TODO not support this now
    # done
    return more

# end get_base_info.py


