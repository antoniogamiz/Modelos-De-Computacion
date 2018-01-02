  /*----- Sección de Declaraciones --------------*/

pieza         [RNBKQ]
fila          [1-8]
columna       [a-h]
posicion      {columna}{fila}
enroque       (O\-O(\-O)?)|(0\-0(\-0)?)
movimiento    {enroque}|({pieza}?({fila}|{columna})?x?{posicion})
jaque         {movimiento}\+
jaquemate     {movimiento}(\+\+|#)
jugada        {movimiento}|{jaque}|{jaquemate}

%{
//#include <stdio.h>
//#include <cstdio>

int num_plays;
char * salida = "out/salida.tex";
FILE * Fsalida;

void makeHeader ();
void makePlay (char * play, int play_length);
void makeEnding ();
%}

%%
  /*----- Sección de Reglas ----------------*/

{jugada}    { makePlay(yytext, yyleng); }

%%
  /*----- Sección de Procedimientos --------*/

int main (int argc, char *argv[]) {
  if (argc != 2) {
    printf("Error en los argumentos: \n\t %s <fichero de entrada> \n", argv[0]);
    exit(-1);
  }

  yyin = fopen (argv[1], "r");
  if (yyin == NULL) {
    printf ("Error: el fichero %s, no se puede abrir\n", argv[1]);
    exit (-1);
  }
  // Abrimos la salida
  Fsalida = fopen(salida, "w+");
  if ( Fsalida == NULL) {
	  printf("Error al abrir el fichero de salida\n");
  	exit(-1);
  }

  // Creamos el inicio del doumento .tex
  makeHeader();

  // Analizamos el archivo de entrada
  num_plays = 2;
  yylex ();

  // Creamos el final del documento
  makeEnding();

  // Cerramos el archivo de salida
  fclose (Fsalida);
  return 0;
}

void makeHeader () {
  fputs ("\\documentclass{article}\n", Fsalida);
  fputs ("\\usepackage[utf8]{inputenc}\n", Fsalida);
  fputs ("\\usepackage[english]{babel}\n", Fsalida);
  fputs ("\\usepackage{skak}\n", Fsalida);
  fputs ("\n\\begin{document}\n", Fsalida);
  fputs ("\\newgame\n\n", Fsalida);
  fputs ("\\showboard \\\\\n", Fsalida);

}

void makePlay (char * play, int play_length) {
  char * str;
  // size("\mainline{n.} \\\\\n") == 20
  int tam = 15 + play_length;
  if (num_plays % 2 == 1)
    tam += 2;

  str = (char *) malloc (tam);
  if ( num_plays % 2 ==  1) {
    sprintf(str, "\\mainline{%d...%s} \\\\\n", num_plays/2, play);
  } else {
    sprintf(str, "\\mainline{%d.%s} \\\\\n", num_plays/2, play);
  }
  fputs (str, Fsalida);
  fputs ("\\showboard \\\\\n", Fsalida);
  num_plays++;

  free (str);
}

void makeEnding() {
  fputs ("\n\\end{document}", Fsalida);
}
