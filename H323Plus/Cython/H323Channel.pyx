include "ptlib.pxi"

from c_H323Channel cimport c_H323Channel

cdef class H323Channel:
    def __dealloc__(self):
       if self.thisptr and not self._is_cast:
           del self.thisptr

cdef class cast_H323Channel(H323Channel):
    def __init__(self):
        self.thisptr = NULL
        self._is_cast = True

cdef H323Channel cast_to_H323Channel(c_H323Channel *c):
    result = cast_H323Channel()
    result.thisptr = c
    return result

