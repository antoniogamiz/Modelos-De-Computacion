PROYECTO = practica.l
OUT = exe
IN = entrada.txt

all: ejecucion

# Ejecutamos el fichero con la entrada predefinida
ejecucion: $(OUT)
	./$(OUT) $(IN)

# Limpieza
clean:
	rm exe
	rm lex.yy.c

# ************ Compilación ************
# Invocamos la herramienta Lex
lex.yy.c:
	lex $(PROYECTO)

# Compilamos el lex.yy.c
$(OUT): lex.yy.c
	gcc lex.yy.c -o $(OUT) -ll
	rm lex.yy.c
