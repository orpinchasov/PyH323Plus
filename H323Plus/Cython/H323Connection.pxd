include "ptlib.pxi"

from c_H323Connection cimport c_H323Connection

cdef class H323Connection:
    cdef c_H323Connection *thisptr
    cdef bool _is_cast

cdef H323Connection cast_to_H323Connection(c_H323Connection *c)