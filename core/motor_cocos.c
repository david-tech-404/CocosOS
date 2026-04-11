#include "motor_cocos.h"
#include <stdio.h>
#include <stdlib.h>

void inicializarMotor() {
    printf("[motorCocos] motor inicializado.\n");
} 

void dibujarPanel(int x, int y, int ancho, int alto, const char* color, float alpha) {
    printf("[motorCocos] Dibujar panel en (%d, %d) tamaño %dx%d color %s alpha %f\n", x, y, ancho, alto, color, alpha);
}

void dibujar_texto(int x, int y, const char* texto, const char* color) {
    printf("[motorCocos] Dibujar texto '%s' en (%d, %d) color %s\n", texto, x, y, color);
}
