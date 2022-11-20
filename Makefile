FILES = ./build/main.o ./build/graphics.o ./build/keyboard.o ./build/sound.o ./build/game.o ./build/paddle.o ./build/font.o
ASM_FLAGS = -g -F dwarf -f elf64
CC_FLAGS = -g

run: all
	bin/pong

debug: all
	gdb bin/pong

all: $(FILES)
	gcc $(CC_FLAGS) $(FILES) -o ./bin/pong

./build/main.o: src/main.asm
	nasm $(ASM_FLAGS) src/main.asm -o ./build/main.o -l ./build/main.lst

./build/graphics.o: src/graphics.asm
	nasm $(ASM_FLAGS) src/graphics.asm -o ./build/graphics.o -l ./build/graphics.lst

./build/keyboard.o: src/keyboard.asm
	nasm $(ASM_FLAGS) src/keyboard.asm -o ./build/keyboard.o -l ./build/keyboard.lst

./build/sound.o: src/sound.asm
	nasm $(ASM_FLAGS) src/sound.asm -o ./build/sound.o -l ./build/sound.lst

./build/game.o: src/game.asm
	nasm $(ASM_FLAGS) src/game.asm -o ./build/game.o -l ./build/game.lst

./build/paddle.o: src/paddle.asm
	nasm $(ASM_FLAGS) src/paddle.asm -o ./build/paddle.o -l ./build/paddle.lst

./build/font.o: src/font.asm
	nasm $(ASM_FLAGS) src/font.asm -o ./build/font.o -l ./build/font.lst

clean:
	rm build/*.o
	rm build/*.lst
	rm bin/pong