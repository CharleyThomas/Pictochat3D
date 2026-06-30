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
	@printf "BM:\000\000\000\000\000\000\0006\000\000\000(\000\000\000\001\000\000\000\001\000\000\000\001\000\030\000\000\000\000\000\004\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\377\377\377\000" > temp_icon.bmp
	@bannertool makebanner -o banner.bin -i temp_icon.bmp -a "PictoChat3D Team" -d "PictoChat 3D"
	@bannertool makeicon -o icon.bin -i temp_icon.bmp -s "PictoChat 3D" -l "PictoChat3D" -p "Team"
	@makerom -f cia -o $@ -elf $< -rsf $(DEVKITPRO)/devkitARM/3ds/3dsx.rsf -banner banner.bin -icon icon.bin
	@rm -f banner.bin icon.bin temp_icon.bmp

$(TARGET).elf: $(OFILES)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(SOURCES)/*.o *.elf *.3dsx *.cia *.map temp_icon.bmp
