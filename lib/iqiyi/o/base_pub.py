# -*- coding: utf-8 -*-
# base_pub.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# base_pub: iqiyi, com.qiyi.player.base.pub 
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

class EnumItem(object):
    
    def __init__(self, param1, param2, param3):
        self.id = param1
        self.name = param2
        param3.append(self)
    
    def __str__(self):
        return self.name

# end base_pub.py


