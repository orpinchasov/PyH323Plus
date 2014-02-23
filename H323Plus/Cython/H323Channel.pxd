include "ptlib.pxi"

from c_H323Channel cimport c_H323Channel

cdef class H323Channel:
    cdef c_H323Channel *thisptr
    cdef bool _is_cast

cdef H323Channel cast_to_H323Channel(c_H323Channel *c)