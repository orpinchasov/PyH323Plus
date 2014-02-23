include "ptlib.pxi"

from c_PString cimport c_PString

cdef class PString:
    cdef c_PString *thisptr
    cdef bool _is_cast

cdef PString cast_to_PString(c_PString *c)