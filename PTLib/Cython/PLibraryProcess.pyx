from c_PLibraryProcess cimport c_PLibraryProcess, c_ReleaseCode

cdef class PLibraryProcess:
    def __init__(self, manuf = "", name = "", majorVersion = 1, minorVersion = 0, status = c_ReleaseCode, buildNum = 1):
        self.thisptr =  new c_PLibraryProcess(manuf, name, majorVersion, minorVersion, status, buildNum)

    def __dealloc__(self):
       if self.thisptr:
           del self.thisptr