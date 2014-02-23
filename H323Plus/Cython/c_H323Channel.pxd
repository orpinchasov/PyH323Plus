include "ptlib.pxi"

cdef extern from "channels.h":
    cdef cppclass c_H323Channel "H323Channel":
        pass