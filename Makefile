TARGET   := PictoChat3D
SOURCES  := source
DATA     := data
INCLUDES := include

export DEVKITARM  := /opt/devkitpro/devkitARM
export DEVKITPRO  := /opt/devkitpro
export PATH       := $(DEVKITARM)/bin:$(PATH)

include $(DEVKITPRO)/devkitARM/3ds_rules

CFLAGS   := -g -Wall -O2 -mword-relocations -fomit-frame-pointer -ffunction-sections -march=armv6k -mtune=mpcore -mfloat-abi=hard -mfpu=vfpv2 -DARM11 -D_3DS
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions -std=gnu++11
LDFLAGS  := -specs=3dsx.specs -g -march=armv6k -mtune=mpcore -mfloat-abi=hard -mfpu=vfpv2 -Wl,-Map,$(TARGET).map --gc-sections
LIBS     := -lcitro2d -lcitro3d -lctru -lm

CFILES   := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c))
CPPFILES := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.cpp))
OFILES   := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o)

all: $(TARGET).3dsx $(TARGET).cia

$(TARGET).3dsx: $(TARGET).elf

$(TARGET).cia: $(TARGET).elf
	@bannertool makebanner -o banner.bin -i images/logo.png -a "PictoChat3D Team" -d "PictoChat 3D"
	@bannertool makeicon -o icon.bin -i images/logo.png -s "PictoChat 3D" -l "PictoChat3D" -p "Team"
	@makerom -f cia -o $@ -elf $< -rsf $(DEVKITPRO)/devkitARM/3ds/3dsx.rsf -banner banner.bin -icon icon.bin
	@rm -f banner.bin icon.bin

$(TARGET).elf: $(OFILES)
	$(CXX) $(LDFLAGS) $^ $(LIBS) -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(SOURCES)/*.o *.elf *.3dsx *.cia *.map
