from c_PIndirectChannel cimport c_PIndirectChannel

cdef class PIndirectChannel:
    cdef c_PIndirectChannel *thisptr
