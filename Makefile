TARGET   := PictoChat3D
SOURCES  := source
DATA     := data
INCLUDES := include

export DEVKITARM  := /opt/devkitpro/devkitARM
export DEVKITPRO  := /opt/devkitpro
export PATH       := $(DEVKITARM)/bin:$(PATH)

include $(DEVKITPRO)/devkitARM/3ds_rules

CFLAGS   := -g -Wall -O2 -mword-relocations -fomit-frame-pointer -ffunction-sections -march=armv6k -mtune=mpcore -mfloat-abi=hard -mfpu=vfpv2 -D__3DS__ -I$(DEVKITPRO)/libctru/include
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions -std=gnu++11
LDFLAGS  := -specs=3dsx.specs -g -march=armv6k -mtune=mpcore -mfloat-abi=hard -mfpu=vfpv2 -Wl,-Map,$(TARGET).map -Wl,--gc-sections -L$(DEVKITPRO)/libctru/lib
LIBS     := -lcitro2d -lcitro3d -lctru -lm

CFILES   := $(wildcard $(SOURCES)/*.c)
CPPFILES := $(wildcard $(SOURCES)/*.cpp)
OFILES   := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o)

all: $(TARGET).3dsx $(TARGET).cia

$(TARGET).3dsx: $(TARGET).elf

$(TARGET).cia: $(TARGET).elf
	@makerom -f cia -o $@ -elf $< -rsf $(DEVKITPRO)/devkitARM/3ds/3dsx.rsf

$(TARGET).elf: $(OFILES)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(SOURCES)/*.o *.elf *.3dsx *.cia *.map
