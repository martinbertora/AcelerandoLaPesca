#include <stdio.h>
#include "mpu6050.h"
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <math.h>
#include <stdlib.h>  // Necesario para malloc y free

#define N 512  // Tamaño de la ventana gaussiana
#define SIGMA 3.0  // Parámetro de dispersión de la gaussiana

// Estructura para el buffer circular
typedef struct {
    double *data;  // Usamos asignación dinámica de memoria para la ventana
    int index;
} CircularBuffer;

// Inicializa el buffer circular
void initCircularBuffer(CircularBuffer* buffer) {
    buffer->data = (double *)malloc(N * sizeof(double));
    buffer->index = 0;
}

// Libera la memoria del buffer circular
void freeCircularBuffer(CircularBuffer* buffer) {
    free(buffer->data);
}

// Añade un nuevo dato al buffer y descarta el dato más antiguo
void addToCircularBuffer(CircularBuffer* buffer, double newData) {
    buffer->data[buffer->index] = newData;
    buffer->index = (buffer->index + 1) % N;
}

// Función que aplica el filtro gaussiano a la señal
double applyGaussianFilter(CircularBuffer* buffer, double window[]) {
    int i;
    double filteredValue = 0.0;

    for (i = 0; i < N; i++) {
        int j = (buffer->index - i + N) % N;  // Índice relativo al buffer circular
        filteredValue += window[i] * buffer->data[j];
    }

    return filteredValue;
}


void app_main(void)
{

    mpuBegin(MPU6050_ACCEL_RANGE_8G , MPU6050_GYRO_RANGE_500DPS, 1);
    vTaskDelay(1000/portTICK_PERIOD_MS);
    mpuSetFilterBandwidth(MPU6050_BAND_5_HZ);
    vTaskDelay(1000/portTICK_PERIOD_MS);
    
    double acx=0,acy=0,acz=0;
    double sumacuadratica=0;
    double *window = (double *)malloc(N * sizeof(double));  // Ventana gaussiana
    double filteredValue;  // Valor filtrado

    CircularBuffer circularBuffer;
    initCircularBuffer(&circularBuffer);

    // Calcula la ventana gaussiana
    for (int i = 0; i < N; i++) {
        double t = i - (N - 1) / 2.0;
        window[i] = exp(-0.5 * (t / SIGMA) * (t / SIGMA));
    }

    while(1)
    {
        mpuReadSensors();
        acx= mpuGetAccelerationX()*9.8;
        acy= mpuGetAccelerationY()*9.8;
        acz= mpuGetAccelerationZ()*9.8;
        // Calcula la suma cuadrática
        sumacuadratica = sqrt(acx * acx + acy * acy + acz * acz);
        
        
        // Muestra los resultados
        //printf("Aceleraciones: %f, %f, %f\n",acx,acy,acz);
        //printf("Suma Cuadrática: %f\n", sumacuadratica);

        // Añade la suma cuadrática al buffer circular
        addToCircularBuffer(&circularBuffer, sumacuadratica);

        // Aplica el filtro gaussiano
        filteredValue = applyGaussianFilter(&circularBuffer, window);
        filteredValue=filteredValue/5;
        printf("%lf,%lf,%lf,%lf,%lf\n",acx,acy,acz,sumacuadratica,filteredValue);
        
        vTaskDelay(10/portTICK_PERIOD_MS);
    }
    
    vTaskDelete(NULL);
}
