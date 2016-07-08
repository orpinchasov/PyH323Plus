LIBS := -lpt
INCLUDE := -I/usr/local/include/ptlib -I/usr/include/python2.7 -I.

MODULES := PIndirectChannel PLibraryProcess PProcess PTrace PString Address

CYTHON_FILES = $(addprefix Cython/, $(addsuffix .pyx, $(MODULES)))
CPP_FILES = $(addprefix CPP/, $(addsuffix .cpp, $(MODULES)))
O_FILES = $(addprefix CPP/, $(addsuffix .o, $(MODULES)))
SO_FILES = $(addprefix Build/, $(addsuffix .so, $(MODULES)))

WRAPPER_MODULES := WrapperPIndirectChannel
WRAPPER_FILES = $(addprefix Wrappers/, $(addsuffix .cpp, $(WRAPPER_MODULES)))
WRAPPER_O_FILES = $(addprefix Wrappers/, $(addsuffix .o, $(WRAPPER_MODULES)))

all: $(SO_FILES)

clean:
	rm -fr CPP Build $(WRAPPER_O_FILES)

echo:
	@echo $(CYTHON_FILES)
	@echo $(CPP_FILES)
	@echo $(O_FILES)
	@echo $(WRAPPER_FILES)
	@echo $(WRAPPER_O_FILES)
	@echo $(SO_FILES)

.PHONY: all clean echo

.SECONDARY:

# Rules
Build/%.so: CPP/%.o $(WRAPPER_O_FILES)
	mkdir -p Build
	g++ -shared -fPIC -o "$@" "$<" $(WRAPPER_O_FILES) $(LIBS)

CPP/%.o: CPP/%.cpp
	g++ $(INCLUDE) -fPIC -fno-strict-aliasing -O3 -Wall -c -o "$@" "$<"

CPP/%.cpp: Cython/%.pyx Cython/%.pxd Cython/c_%.pxd
	mkdir -p CPP
	cython --cplus -o "$@" "$<"

Wrappers/%.o: Wrappers/%.cpp
	g++ $(INCLUDE) -fPIC -O3 -Wall -c -o "$@" "$<"
