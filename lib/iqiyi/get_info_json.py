# -*- coding: utf-8 -*-
# get_info_json.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# get_info_json: evparse/lib/iqiyi 
# version 0.0.0.2 test201504291505
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

from .o import exports

from .. import base

# global vars

# functions

def get_info(vid_info):
    # create MixerRemote
    mixer = exports.MixerRemote()
    # set data
    mixer.vid = vid_info['vid']
    mixer.tvid = vid_info['tvid']
    # get request url
    url_to = mixer.getRequest()
    # TODO
    pass

# end get_info_json.py


