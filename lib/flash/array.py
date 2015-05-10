# -*- coding: utf-8 -*-
# array.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# evparse: lib/flash/array, support flash Array class (action script 3) in python3. 
# version 0.0.5.0 test2015050102225
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

# class

class Array(object):
    
    def __init__(self):
        self._data = []
    
    def __len__(self):
        return len(self._data)
    
    def __str__(self):
        return str(self._data)
    
    def __repr__(self):
        return repr(self._data)
    
    def __getitem__(self, n):
        # check slice
        if isinstance(n, slice):
            return self._data[n.start:n.step:n.stop]
        # check len
        if n > len(self._data) - 1:
            return None
        return self._data[n]
    
    def __setitem__(self, n, item):
        # check max length
        if isinstance(n, slice):
            max_i = n.stop
        else:
            max_i = n + 1
        # check array length
        while len(self._data) < max_i:
            self._data.append(None)
        # check slice
        if isinstance(n, slice):
            self._data[n.start:n.step:n.stop] = item
        else:
            # set it
            self._data[n] = item
    
    def append(self, item):
        self._data.append(item)
    # end Array

# end array.py


