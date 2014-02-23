include "ptlib.pxi"

from c_H323SignalPDU cimport c_H323SignalPDU

cdef class H323SignalPDU:
    cdef c_H323SignalPDU *thisptr
    cdef bool _is_cast

cdef H323SignalPDU cast_to_H323SignalPDU(c_H323SignalPDU *c)