# -*- coding: utf-8 -*-
# entry.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# entry: evparse/lib/sohu 
# version 0.0.0.1 test201505011728
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

from . import get_vid
from . import get_info_json

# global vars

# functions

def parse(url):	# this site entry main entry function
    
    # frist re-check url, if supported by this
    # TODO
    # get vid
    vid_info = get_vid.get_vid(url)
    # FIXME debug here
    print('DEBUG: got vid \"' + vid_info['vid'] + '\" ')
    # get info_json
    info = get_info_json.get_info(vid_info, url)
    # TODO
    pass

# class

# end entry.py


