TARGET = cudaTemplate
DESTDIR = .

CONFIG += c++11

SOURCES += $$PWD/src/main.cpp
#HEADERS +=

INCLUDEPATH += $$PWD/include

OBJECTS_DIR = obj
MOC_DIR = moc

OTHER_FILES += README.md \
               LICENSE

# ------------
# Cuda related
# ------------

# Project specific
CUDA_SOURCES += $$PWD/cuda/src/vectorfill.cu
CUDA_HEADERS += $$PWD/cuda/include/vectorfill.cuh
CUDA_OBJECTS_DIR = $$PWD/cuda/obj

INCLUDEPATH += $$PWD/cuda/include

# Cuda specific
CUDA_PATH = "/usr"
NVCC_CXXFLAGS += -ccbin g++
NVCC = $(CUDA_PATH)/bin/nvcc

# Extra NVCC options
NVCC_OPTIONS = ''

# System type
OS_SIZE = 64
# Compute capabilities that you want the project to be compiled for
SMS = 20 30 32 35 37 50

# Generate gencode flags from the cc list
for(sm, SMS) {
  GENCODE_FLAGS += -gencode arch=compute_$$sm,code=sm_$$sm
}

# Location of cuda headers
INCLUDEPATH += /usr/include/cuda

# Compiler instruction, add -I in front of each include path
CUDA_INCLUDES = $$join(INCLUDEPATH, ' -I', '-I', '')

QMAKE_LIBDIR += $$CUDA_PATH/lib/
LIBS += -lcudart

OTHER_FILES += $$CUDA_SOURCES $$CUDA_HEADERS

# Specify the location to your cuda headers here

# As cuda needs to be compiled by a separate compiler, we'll add instructions for qmake to use the separate
# compiler to compile cuda files and finally compile the object files together
cuda.input = CUDA_SOURCES
cuda.output = $$CUDA_OBJECTS_DIR/${QMAKE_FILE_BASE}_cuda.o
cuda.commands = $$NVCC $$NVCC_CXXFLAGS -m$$OS_SIZE $$GENCODE_FLAGS -c -o ${QMAKE_FILE_OUT} ${QMAKE_FILE_NAME} $$NVCC_OPTIONS $$CUDA_INCLUDES
cuda.dependency_type = TYPE_C

# Add the generated compiler instructions to qmake
QMAKE_EXTRA_COMPILERS += cuda
