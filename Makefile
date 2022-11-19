FILES = ./build/main.o ./build/graphics.o ./build/keyboard.o ./build/sound.o ./build/game.o
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

./build/graphics.o: src/graphics.asm
	yasm $(ASM_FLAGS) src/graphics.asm -o ./build/graphics.o -l ./build/graphics.lst

./build/keyboard.o: src/keyboard.asm
	yasm $(ASM_FLAGS) src/keyboard.asm -o ./build/keyboard.o -l ./build/keyboard.lst

./build/sound.o: src/sound.asm
	yasm $(ASM_FLAGS) src/sound.asm -o ./build/sound.o -l ./build/sound.lst

./build/game.o: src/game.asm
	yasm $(ASM_FLAGS) src/game.asm -o ./build/game.o -l ./build/game.lst

clean:
	rm build/*.o
	rm build/*.lst
	rm bin/pong