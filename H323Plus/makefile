LIBS := -lpt -lopenh323
INCLUDE := -I/usr/local/include/ptlib -I/usr/local/include/openh323 -I/usr/include/python2.7 -I. -I../PTLib

MODULES := H323EndPoint H323Connection H323AudioCodec H323ListenerTCP H323SignalPDU H323TransportAddress H323Channel

CYTHON_FILES = $(addprefix Cython/, $(addsuffix .pyx, $(MODULES)))
CPP_FILES = $(addprefix CPP/, $(addsuffix .cpp, $(MODULES)))
O_FILES = $(addprefix CPP/, $(addsuffix .o, $(MODULES)))
SO_FILES = $(addprefix Build/, $(addsuffix .so, $(MODULES)))

WRAPPER_MODULES := WrapperH323EndPoint
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
	g++ -shared -o "$@" "$<" $(WRAPPER_O_FILES) $(LIBS)

CPP/%.o: CPP/%.cpp
	g++ $(INCLUDE) -fno-strict-aliasing -O3 -Wall -c -o "$@" "$<"

CPP/%.cpp: Cython/%.pyx Cython/%.pxd Cython/c_%.pxd
	mkdir -p CPP
	cython --cplus -I../PTLib/Cython -o "$@" "$<"

Wrappers/%.o: Wrappers/%.cpp
	g++ $(INCLUDE) -O3 -Wall -c -o "$@" "$<"
