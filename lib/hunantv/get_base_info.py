# -*- coding: utf-8 -*-
# get_base_info.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# evparse: lib/hunantv/get_base_info
# version 0.0.2.0 test201505151703
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

def get_info(vid_info, flag_debug=False):
    # create parmParse
    pp = exports.parmParse.parmParse()
    
    # set vid
    pp.vid = vid_info['vid']
    # get api url
    api_url = pp.Init()
    # debug info
    print('evparse: lib.hunantv: DEBUG: got api_url \"' + api_url + '\" ')
    
    # load it
    info = base.get_json_info(api_url)
    # get more info
    more = get_more_info(info)
    # done
    return info, more

def get_more_info(info):
    more = {}	# more info
    data = info['data']['info']
    # TODO
    more['title'] = data['title']
    more['sub_title'] = data['sub_title']
    more['short_title'] = ''
    if 'collection_name' in data:
        more['short_title'] = data['collection_name']
    more['no'] = 0	# TODO not supported yet
    # done
    return more

# end get_base_info.py


