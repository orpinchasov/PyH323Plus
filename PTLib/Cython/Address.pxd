from c_Address cimport c_Address

cdef class Address:
    cdef c_Address *thisptr
