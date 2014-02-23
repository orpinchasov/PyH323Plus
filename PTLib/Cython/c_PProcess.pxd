include "ptlib.pxi"

from c_PString cimport c_PString

cdef extern from "ptlib/pprocess.h":
    c_PString c_PProcess_GetOSName "PProcess::GetOSName"()