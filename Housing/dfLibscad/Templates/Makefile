
# Name of scad file without the extension:
TARGETNAME=NAME_OF_MAIN_SCAD_FILE_WITHOUT_EXTENSION

# scad files that are included (include or use)
DEPS =
# DEPS+=RfModules.scad
# DEPS+=EspModules.scad
DEPS+=dfLibscad/Revision.scad
DEPS+=dfLibscad/Screws.scad
DEPS+=dfLibscad/RoundCornersCube.scad
DEPS+=dfLibscad/Enclosure.scad
DEPS+=dfLibscad/SlottedHole.scad

# Results
OUTPUTDIR=STL
IMAGEDIR =PNG

OPENSCAD ?= openscad-nightly --enable=fast-csg --enable=fast-csg-trust-corefinement --enable=lazy-union
#OPENSCAD ?= openscad

# Hopefully there is no need to change something below
###########################################################
# openscad options
#Options=-D "WhatToPrint=\"$(WhatToPrint)\""

SHOW_MODULES=-D "ShowModules=1"
IMAGE_SIZE=--imgsize 1024,1024 --viewall
CAMERA=--camera=0,0,0,45,0,130,500
AUTOCENTER=--autocenter
VIEW=--view axes

PNG_CMDS  =$(SHOW_MODULES)
PNG_CMDS += $(IMAGE_SIZE)
PNG_CMDS += $(CAMERA)
PNG_CMDS += $(AUTOCENTER)
#PNG_CMDS += $(VIEW)

###########################################################
# internal variables
REV =svn_rev
###########################################################
# do we have dfLibscad and do we use automatic versioning?
AUTO_REF:= $(wildcard $(REV).tmpl)
USE_LIB := $(findstring dfLibscad,$(DEPS))
# Using my super customizer?
SUPER_CUSTOMIZER:= $(wildcard customizer/*.yaml)
###########################################################
ifeq ($(strip $(AUTO_REF)),)
else
DEPS+=$(REV).scad
endif

TARGETS_STL = $(addprefix $(OUTPUTDIR)/, $(addprefix $(TARGETNAME)_,$(addsuffix .stl, $(PARTS_STL))))
TARGETS_PNG = $(addprefix $(IMAGEDIR)/, $(addprefix $(TARGETNAME)_,$(addsuffix .png, $(PARTS_PNG))))
JSON        = $(TARGETNAME).json
#DEP         = -d $(TARGETNAME).d # for now turned off

ifeq ($(strip $(SUPER_CUSTOMIZER)),)
###########################################################
# retrive the parts list from the json file
# Note: The trick with OPENBRACE is to avoid issues with syntax coloring in vs-code
OPENBRACE={
RAW_PARTS_PNG = $(shell grep ': $(OPENBRACE)' $(JSON) | grep -v parameterSets | grep -v 'design default values')
RAW_PARTS_STL = $(shell grep ': $(OPENBRACE)' $(JSON) | grep -v parameterSets | grep -v 'design default values' | grep -v PNG)
# remove unwanted characters
PARTS_PNG = $(subst ",, $(subst : $(OPENBRACE),,$(RAW_PARTS_PNG)))
PARTS_STL = $(subst ",, $(subst : $(OPENBRACE),,$(RAW_PARTS_STL)))
###########################################################
else
PARTS_PNG = $(shell openscadcustomizer.py --directory customizer --list)
PARTS_STL = $(filter-out %PNG, $(PARTS_PNG))
endif

all: png stl

stl : $(TARGETS_STL)

png : $(TARGETS_PNG)

$(TARGETS_STL) : $(DEPS) $(JSON) Makefile | version dir_build

$(TARGETS_PNG) : $(DEPS) $(JSON) Makefile | version dir_build

%.stl: $(TARGETNAME).scad
	$(OPENSCAD) $(DEP) -p "$(JSON)" -P $(subst $(OUTPUTDIR)/$(TARGETNAME)_,,$(@:.stl=)) $(Options) $< -o $(subst $(TARGETNAME)_,,$(@))

%.png: $(TARGETNAME).scad
	$(OPENSCAD) $(DEP) -p "$(JSON)" -P $(subst $(IMAGEDIR)/$(TARGETNAME)_,,$(@:.png=)) $(PNG_CMDS) -D "png=true" $(Options) $< -o $(subst $(TARGETNAME)_,,$(@))

dir_build:
	@mkdir -p $(OUTPUTDIR)
	@mkdir -p $(IMAGEDIR)
	
.PHONY:
%.scad: %.tmpl
	SubWCRev . $< $@

ifeq ($(strip $(AUTO_REF)),)
version: | libversion
	@echo "no automatic version generated"
else
.PHONY:
.ONESHELL:
version $(REV).scad: $(REV).tmpl | libversion
		SubWCRev . $(REV).tmpl $(REV).scad
endif

ifeq ($(strip $(USE_LIB)),)
libversion: 
#	echo nothing to do
else
libversion: 
	cd dfLibscad && bash UpdateRevision.sh
endif

# Super customizer
ifeq ($(strip $(SUPER_CUSTOMIZER)),)
customizer:
#	echo nothing to do
else
$(JSON): $(SUPER_CUSTOMIZER) | Makefile
	openscadcustomizer.py --directory customizer -o $@
endif

clean:
	-rm -rf $(OUTPUTDIR)
	-rm -rf $(IMAGEDIR)
	-rm $(REV).scad

debug:
	@echo TARGETNAME=$(TARGETNAME)
	@echo DEPS=$(DEPS)
	@echo RAW_PARTS_PNG=$(RAW_PARTS_PNG)
	@echo PARTS_PNG=$(PARTS_PNG)
	@echo RAW_PARTS_STL=$(RAW_PARTS_STL)
	@echo PARTS_STL=$(PARTS_STL)	
	@echo AUTO_REF=$(AUTO_REF)
	@echo USE_LIB=$(USE_LIB)
	@echo SUPER_CUSTOMIZER=$(SUPER_CUSTOMIZER)
	@echo JSON=$(JSON)

# Copyright (C) 2021 Dieter Fauth
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
# Contact: dieter.fauth at web.de
