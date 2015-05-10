# -*- coding: utf-8 -*-
# get_base_info.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# evparse: lib/letv/get_base_info
# version 0.0.1.0 test201505102205
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

# FIXME import for debug
import json

from .o import exports
from .. import base

transfer = exports.transfer

# global vars

# functions

def get_info(vid_info, flag_debug=False):
    # create transfer
    idt = transfer.IDTransfer()
    
    # try to one get info
    info = try_one_get_info(idt, vid_info['vid'])
    
    # FIXME debug here
    print('DEBUG: letv, base_info')
    print(json.dumps(info, indent=4, sort_keys=True, ensure_ascii=False))
    # TODO
    pass

def try_one_get_info(id_transfer, vid):
    # try one time to get info
    
    # get url
    info_url = id_transfer.getURL(vid)
    # FIXME debug here
    print('DEBUG: letv, got info_url \"' + info_url + '\" ')
    # load json
    info = base.get_json_info(info_url)
    # done
    return info

# end get_base_info.py


