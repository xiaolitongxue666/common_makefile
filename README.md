```shell
-include *.d # Dependent
%.o : %.c
	$(ECHO) $@ Compiling $(notdir $<)...
	$(CC) -c $(INCLUDES) $(CFLAGS) $< -MMD -pg -o $@ # Use -MMD 
```

静态模式规则
```shell
objects = foo.o bar.o all.o

all: $(objects)

# These files compile via implicit rules
# Syntax - targets ...: target-pattern: prereq-patterns ...
# In the case of the first target, foo.o, the target-pattern matches foo.o and sets the "stem" to be "foo".
# It then replaces the '%' in prereq-patterns with that stem
$(objects): %.o: %.c
```

```shell
#bar.o: bar.c
#foo.o: foo.c
#
#bar.o lose.o: %o: %c
#
$(filter %o,%(obj_files)): %o: %c
	echo "target: $@ prereq: $<"

#foo.result: foo.raw
#
#foo.result: %.result: %raw
#
$(filter %.result,%(obj_files)): %.result: %raw
	echo "target: $@ prereq: $<"
```

```shell
all:
	cd ..
	# The cd above does not affect this line, because each command is effectively run in a new shell
	echo `pwd`

	# This cd command affects the next because they are on the same line
	cd ..;echo `pwd`
	# or like
	cd subdir && $(MAKE)

	# Same as above
	cd ..; \
	echo `pwd`
```

模式规则
- 定义您自己的隐式规则的方法
- 静态模式规则的更简单形式
```shell
# Define a pattern rule that compiles every .c file into a .o file 
%.o : %.c 
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@
```

Makefile 变量和 Shell 变量之间的差异
```shell
make_var = I am a make variable
all:
	# Same as running "sh_var='I am a shell variable'; echo $sh_var" in the shell
	sh_var='I am a shell variable'; echo $$sh_var

	# Same as running "echo I am a make variable" in the shell
	echo $(make_var)
```

**递归使用make**
要递归调用 makefile，请使用特殊的 $(MAKE) 而不是 make，
因为它会为您传递 make 标志，并且本身不会受到它们的影响。
```shell
new_contents = "hello:\n\ttouch inside_file"

all:
	mkdir -p subdir
	printf $(new_contents) | sed -e 's/^ //' > subdir/makefile
	cd subdir && $(MAKE)
clean:
	rm -rf subdir
```
```shell
mkdir -p subdir
printf "hello:\n\ttouch inside_file" | sed -e 's/^ //' > subdir/makefile
cd subdir && make
make[1]: Entering directory '/home/leonli/Code/my_code/Make/common_makefile/Test/subdir'
touch inside_file
make[1]: Leaving directory '/home/leonli/Code/my_code/Make/common_makefile/Test/subdir'
```

在 make 内部运行 make 命令时，可以使用导出指令使其可供子 make 命令访问
在此示例中，cooly 被导出，以便 subdir 中的 makefile 可以使用它
需要导出变量才能让它们在 shell 中运行
```shell
new_contents = "hello:\n\techo \$$(cooly)"

all:
	mkdir -p subdir
	printf $(new_contents) | sed -e 's/^ //' > subdir/makefile
	@echo "---MAKEFILE CONTENTS---"
	@cd subdir && cat makefile
	@echo "---END MAKEFILE CONTENTS---"
	cd subdir && $(MAKE)

# Note that variables and exports. They are set/affected globally.
cooly = "The subdirectory can see me!"
export cooly
# This would nullify the line above: unexport cooly
clean:
	rm -rf subdir
```
```shell
mkdir -p subdir
printf "hello:\n\techo \$(cooly)" | sed -e 's/^ //' > subdir/makefile
---MAKEFILE CONTENTS---
hello:
        echo $(cooly)---END MAKEFILE CONTENTS---
cd subdir && make
make[1]: Entering directory '/home/leonli/Code/my_code/Make/common_makefile/Test/subdir'
echo "The subdirectory can see me!"
The subdirectory can see me!
make[1]: Leaving directory '/home/leonli/Code/my_code/Make/common_makefile/Test/subdir'
```

.EXPORT_ALL_VARIABLES 导出所有变量
[.EXPORT_ALL_VARIABLES](https://www.gnu.org/software/make/manual/make.html#index-_002eEXPORT_005fALL_005fVARIABLES)
```shell
.EXPORT_ALL_VARIABLES:
new_contents = "hello:\n\techo \$$(cooly)"
cooly = "The subdirectory can see me!"
# This would nullify the line above: unexport cooly
all:
	mkdir -p subdir
	printf $(new_contents) | sed -e 's/^ //' > subdir/makefile
	@echo "---MAKEFILE CONTENTS---"
	@cd subdir && cat makefile
	@echo "---END MAKEFILE CONTENTS---"
	cd subdir && $(MAKE)
clean:
	rm -rf subdir
```
