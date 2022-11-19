FILES = ./build/main.o ./build/draw.o ./build/keyboard.o ./build/sound.o
ASM_FLAGS = -g dwarf2 -f elf64 
CC_FLAGS = -g

run: all
	bin/pong

debug: all
	gdb bin/pong

all: $(FILES)
	gcc $(CC_FLAGS) $(FILES) -o ./bin/pong

./build/main.o: src/main.asm
	yasm $(ASM_FLAGS) src/main.asm -o ./build/main.o -l ./build/main.lst

./build/draw.o: src/draw.asm
	yasm $(ASM_FLAGS) src/draw.asm -o ./build/draw.o -l ./build/draw.lst

./build/keyboard.o: src/keyboard.asm
	yasm $(ASM_FLAGS) src/keyboard.asm -o ./build/keyboard.o -l ./build/keyboard.lst

./build/sound.o: src/sound.asm
	yasm $(ASM_FLAGS) src/sound.asm -o ./build/sound.o -l ./build/sound.lst

clean:
	rm build/*.o
	rm build/*.lst
	rm bin/pong