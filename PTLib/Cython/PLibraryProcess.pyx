# We use a library process rather than a normal process
# since our code is loaded while the Python interpreter
# is running and does not contain the "main" function by itself

from c_PLibraryProcess cimport c_PLibraryProcess, c_ReleaseCode

cdef class PLibraryProcess:
    """Class for a process that is a dynamically loaded library."""

    def __init__(self, manuf = "", name = "", majorVersion = 1, minorVersion = 0, status = c_ReleaseCode, buildNum = 1):
        """Create a new process instance."""

        self.thisptr =  new c_PLibraryProcess(manuf, name, majorVersion, minorVersion, status, buildNum)

    def __dealloc__(self):
        """Delete the process object."""

        if self.thisptr:
            del self.thisptr