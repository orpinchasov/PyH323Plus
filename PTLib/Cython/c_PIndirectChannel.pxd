include "ptlib.pxi"

from cpython.ref cimport PyObject

cdef extern from "Wrappers/WrapperPIndirectChannel.h":
    cdef cppclass c_PIndirectChannel "WrapperPIndirectChannel":
        c_PIndirectChannel(PyObject *obj)

cdef extern from "stdlib.h":
     void *memcpy(void *dst, void *src, long n)