#ifndef MOTORCOCOS_H
#define MOTORCOCOS_H
#include <stdint.h>
void  inicializar_Motor();
void dibujarPanel(int x, int y, int ancho, int alto, const char* color, float alpha);
void dibujar_texto(int x, int y, const char* texto, const char* color);
#endif