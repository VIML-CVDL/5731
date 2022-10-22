CXX=g++
CFLAGS=-fPIC
INC=-Igco_source -Igco
SHELL= make.exe
all: libcgco.dll test_wrapper

libcgco.dll: \
    gco_source\LinkedBlockList.obj gco_source\graph.obj gco_source\maxflow.obj \
        gco_source\GCoptimization.obj cgco.obj
	$(CXX) -shared $(CFLAGS) \
	    gco_source\LinkedBlockList.obj \
	    gco_source\graph.obj \
	    gco_source\maxflow.obj \
	    gco_source\GCoptimization.obj \
	    cgco.obj \
	    -o libcgco.dll

gco.dll: \
    gco_source\LinkedBlockList.obj gco_source\graph.obj gco_source\maxflow.obj \
        gco_source\GCoptimization.obj
	$(CXX) -shared $(CFLAGS) gco_source\LinkedBlockList.obj \
	    gco_source\graph.obj \
	    gco_source\maxflow.obj \
	    gco_source\GCoptimization.obj -o gco.dll

gco_source\LinkedBlockList.obj: \
    gco_source\LinkedBlockList.cpp \
        gco_source\LinkedBlockList.h
	$(CXX) $(CFLAGS) $(INC) \
	    -c gco_source\LinkedBlockList.cpp \
	    -o gco_source\LinkedBlockList.obj

gco_source\graph.obj: \
    gco_source\graph.cpp gco_source\graph.h gco_source\block.h
	$(CXX) $(CFLAGS) $(INC) \
	    -c -x c++ gco_source\graph.cpp \
	    -o gco_source\graph.obj

gco_source\maxflow.obj: \
    gco_source\block.h gco_source\graph.h gco_source\maxflow.cpp
	$(CXX) $(CFLAGS) $(INC) \
	    -c -x c++ gco_source\maxflow.cpp \
	    -o gco_source\maxflow.obj

gco_source\GCoptimization.obj: \
    gco_source\GCoptimization.cpp gco_source\GCoptimization.h \
        gco_source\LinkedBlockList.h gco_source\energy.h gco_source\graph.h \
        gco_source\graph.obj gco_source\maxflow.obj
	$(CXX) $(CFLAGS) $(INC) \
	    -c gco_source\GCoptimization.cpp \
	    -o gco_source\GCoptimization.obj

cgco.obj: \
    gco\cgco.cpp gco_source\GCoptimization.h
	$(CXX) $(CFLAGS) $(INC) \
	    -c gco\cgco.cpp \
	    -o cgco.obj

test_wrapper: \
    test_wrapper.cpp
	$(CXX) $(INC) -L. test_wrapper.cpp \
	    -o test_wrapper -Wl,-rpath,. -lcgco

clean:
	del /s "*.obj" "gco_source\*.obj" test_wrapper

rm:
	rd *.obj *.dll gco_source\*.obj *.zip test_wrapper

download:
	wget -N -O gco-v3.0.zip http:\\vision.csd.uwo.ca\code\gco-v3.0.zip
	unzip -o gco-v3.0.zip -d  .\gco_source