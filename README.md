Yea basically its the doom fire in x86-64 assembly. i coded this as 14 year old freshman for fun, it was not fun.

to run this you must install raylib, and the NASM assembler.

nasm -f elf64 logic.asm -o logic.o
nasm -f elf64 raylib.asm -o raylib.o
gcc -no-pie logic.o raylib.o -o doom-fire $(pkg-config --cflags --libs raylib) -lm -lX11
LD_LIBRARY_PATH=/usr/local/lib64 
./doom-fire

this was a learning experience, i did use AI, before you come and rip my head off about it, it was only for syntax, i knew what i wanted the assembly to do and i wrote a good amount of it
but somtimes i needed some help and AI worked the best. i feel very good about where im at in the assembly langauge after this project and i happy its over

thank you for checking it out.
