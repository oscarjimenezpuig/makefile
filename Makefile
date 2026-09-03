# ============================================================
# PROYECTO
# ============================================================

TARGET = 
SRCS   =  

# Archivo que almacena el tipo de compilación
# N = normal
# R = release
# D = debug
COMPILATION_FILE = compilation


# ============================================================
# COMPILADOR
# ============================================================

CC = gcc

CFLAGS = -Wall -Wextra

LDFLAGS =
LDLIBS =

# Ejemplos:
# LDLIBS += -lm
# LDLIBS += -lX11


# ============================================================
# LIBRERIA ESTATICA
# ============================================================

AR      = ar
ARFLAGS = rcs


# ============================================================
# OBJETOS
# ============================================================

OBJS = $(SRCS:.c=.o)


# ============================================================
# TARGETS
# ============================================================

.PHONY: all debug release package clean clear_screen


# ============================================================
# FUNCION: COMPROBAR TIPO DE COMPILACION
# ============================================================

define CHECK_COMPILATION
	@if [ ! -f $(COMPILATION_FILE) ] || [ "$$(cat $(COMPILATION_FILE))" != "$(1)" ]; then \
		$(MAKE) clean; \
	fi
endef


# ============================================================
# COMPILACION NORMAL
# ============================================================

all: clear_screen
	$(call CHECK_COMPILATION,N)
	$(MAKE) $(TARGET)
	@echo "N" > $(COMPILATION_FILE)
	@echo "Normal compilation"


# ============================================================
# EJECUTABLE
# ============================================================

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)


# ============================================================
# OBJETOS
# ============================================================

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@


# ============================================================
# LIBRERIA ESTATICA
# ============================================================

package: $(OBJS)
	$(AR) $(ARFLAGS) lib$(TARGET).a $(OBJS)


# ============================================================
# LIMPIAR PANTALLA
# ============================================================

clear_screen:
	clear


# ============================================================
# LIMPIEZA
# ============================================================

clean:
	rm -f $(OBJS) $(TARGET) lib$(TARGET).a


# ============================================================
# RELEASE
# ============================================================

release: CFLAGS += -O3

release:
	$(call CHECK_COMPILATION,R)
	$(MAKE) $(TARGET)
	@echo "R" > $(COMPILATION_FILE)
	@echo "Release compilation"


# ============================================================
# DEBUG
# ============================================================

debug: CFLAGS += -g -fsanitize=address,undefined
debug: LDFLAGS += -fsanitize=address,undefined

debug:
	$(call CHECK_COMPILATION,D)
	$(MAKE) $(TARGET)
	@echo "D" > $(COMPILATION_FILE)
	@echo "Debug compilation"
