SRC_ROOT_DIR=$(shell pwd)
INSTALL_DIR=$(SRC_ROOT_DIR)/BUILD
INSTALL_LIB_DIR=$(SRC_ROOT_DIR)/lib
PY_DIR=$(SRC_ROOT_DIR)/python

MODULEHW=$(SRC_ROOT_DIR)/python/_hw.so
INCLUDE_DIR=../include
LIB_DIR=$(INSTALL_DIR)/lib
INCFILES=$(wildcard ../include/*.h)
OBJECTS_DIR=$(SRC_ROOT_DIR)/BUILD

HW_FM_LIBRARY_NAME=$(INSTALL_LIB_DIR)/libhw_fm.a
HW_TDA7419_LIBRARY_NAME=$(INSTALL_LIB_DIR)/libhw_tda7419.a
HW_LCD_LIBRARY_NAME=$(INSTALL_LIB_DIR)/libhw_lcd.a
WIRINGPI_LIBRARY_NAME=$(INSTALL_LIB_DIR)/libwiringpi.a

GLOBAL_CXX_FLAGS=-fPIC

export

SWIG ?= /usr/bin/swig
PYTHON_DIR ?= /usr/local/include/python2.7

all: libhw $(MODULEHW)

libhw:
	@ mkdir -p $(INSTALL_LIB_DIR)
	@ mkdir -p $(OBJECTS_DIR)
	@ mkdir -p $(PY_DIR)
	@$(MAKE) -C hardware all

%.c: %.i
	@echo "Swig generation $<"
	$(SWIG) -python -c++ -o $@ $<

$(MODULEHW): hw.c $(HW_TDA7419_LIBRARY_NAME) $(HW_FM_LIBRARY_NAME) $(HW_LCD_LIBRARY_NAME)
	@echo "Compiling HW Python module $@"
	@cp hw.py $(SRC_ROOT_DIR)/python
	@$(CXX) -shared -fPIC -Ihardware/include -I$(PYTHON_DIR) -I. -L$(INSTALL_LIB_DIR) hw.c -o $(MODULEHW) -lhw_fm -lhw_tda7419 -lhw_lcd -lwiringpi
	
clean:
	@rm -rf BUILD lib python
	@rm hw.py hw.c
	
