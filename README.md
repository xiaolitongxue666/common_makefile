# Scenes
## 01 Simple make exec file or static lib or share lib

**Input** :

*.c *.h

**Output** :	

*.elf *.a *.so

### Make a module exec file

```shell
cd Scen_01/

# Clean
make clean

# Build
make executable_file

# Run
./obj/executable_file
```

# Dependent
```
-include *.d # Dependent
%.o : %.c
	$(ECHO) $@ Compiling $(notdir $<)...
	$(CC) -c $(INCLUDES) $(CFLAGS) $< -MMD -pg -o $@ # Use -MMD 
else

```




