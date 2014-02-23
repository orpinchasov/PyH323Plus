include "ptlib.pxi"

from c_H323SignalPDU cimport c_H323SignalPDU

cdef class H323SignalPDU:
    def __init__(self):
        self.thisptr = new c_H323SignalPDU()
        self._is_cast = False

    def __dealloc__(self):
       if self.thisptr and not self._is_cast:
           del self.thisptr

cdef class cast_H323SignalPDU(H323SignalPDU):
    def __init__(self):
        self.thisptr = NULL
        self._is_cast = True

cdef H323SignalPDU cast_to_H323SignalPDU(c_H323SignalPDU *c):
    result = cast_H323SignalPDU()
    result.thisptr = c
    return result