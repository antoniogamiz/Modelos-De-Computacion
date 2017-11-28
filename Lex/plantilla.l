  /*----- Sección de Declaraciones --------------*/

pieza         [RDTCA]?
fila          [1-8]
columna       [a-h]
posicion      {fila}{columna}
enroque       (O\-O(\-O)?)|(0\-0(\-0)?)
movimiento    {enroque}|({pieza}({fila}|{columna})?x?{posicion})
jaque         {movimiento}\+
jaquemate     {movimiento}(\+\+|#)
jugada        {movimiento}|{jaque}|{jaquemate}

%{
//#include <stdio.h>
//#include <cstdio>

int num_plays;
char * salida = "tex/salida.txt";
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
  fputs ("\\documentclass{article}", Fsalida);
  fputs ("\\usepackage[utf8]{inputenc}", Fsalida);
  fputs ("\\usepackage[english]{babel}", Fsalida);
  fputs ("\\usepackage{skak}", Fsalida);
  fputs ("\\begin{document}", Fsalida);
  fputs ("\\newgame", Fsalida);
}

void makePlay (char * play, int play_length) {
  char * str;
  // size("\makeline{n.}") == 13
  int tam = 13 + play_length;
  bool impar = num_plays % 2 == 1;
  if (impar)
    tam += 2;

  str = char [tam];
  if (impar) {
    sprintf(str, "\\makeline{%d...%s}", num_plays/2, play);
  } else {
    sprintf(str, "\\makeline{%d.%s}", num_plays/2, play);
  }
  fputs (str, Fsalida);
  num_plays++;
}

void makeEnding() {
  fputs ("\n\\end{document}", Fsalida);
}
