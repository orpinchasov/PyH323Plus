from c_PLibraryProcess cimport c_PLibraryProcess

cdef class PLibraryProcess:
    cdef c_PLibraryProcess *thisptr

