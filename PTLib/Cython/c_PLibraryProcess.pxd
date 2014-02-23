include "ptlib.pxi"

cdef extern from "ptlib/pprocess.h":
    cdef enum c_CodeStatus "PLibraryProcess::CodeStatus":
        c_AlphaCode "PLibraryProcess::AlphaCode"
        c_BetaCode "PLibraryProcess::BetaCode"
        c_ReleaseCode "PLibraryProcess::ReleaseCode"

    cdef cppclass c_PLibraryProcess "PLibraryProcess":
        c_PLibraryProcess(const char * manuf, const char * name, WORD majorVersion, WORD minorVersion, c_CodeStatus status, WORD buildNum)