include "ptlib.pxi"

from c_H323SignalPDU cimport c_H323SignalPDU

cdef class H323SignalPDU:
    """Wrapper class for the H323 signalling channel."""

    def __init__(self):
        """Create a new H.323 signalling channel (H.225/Q.931) PDU."""

        self.thisptr = new c_H323SignalPDU()
        self._is_cast = False

    def __dealloc__(self):
        """Delete the PDU."""

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