FILES = ./build/main.o ./build/draw.o
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

clean:
	rm build/*.o
	rm build/*.lst
	rm bin/pong