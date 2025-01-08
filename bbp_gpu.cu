#include <stdio.h>
#include <math.h>
#include <time.h>
#include <cuda_runtime.h>

#define NDEC 16
#define BLOCK_SIZE 256  // Размер блока для CUDA

// Функция для вычисления десятичных цифр числа Pi
__device__ double expm_cuda(double p, double ak)
{
    int i, j;
    double p1, pt, r;
#define ntp 25
    static double tp[ntp];
    static int tp1 = 0;

    if (tp1 == 0) {
        tp1 = 1;
        tp[0] = 1.;

        for (i = 1; i < ntp; i++) tp[i] = 2. * tp[i - 1];
    }

    if (ak == 1.) return 0.;

    for (i = 0; i < ntp; i++) if (tp[i] > p) break;

    pt = tp[i - 1];
    p1 = p;
    r = 1.;

    for (j = 1; j <= i; j++) {
        if (p1 >= pt) {
            r = 16. * r;
            r = r - (int)(r / ak) * ak;
            p1 = p1 - pt;
        }
        pt = 0.5 * pt;
        if (pt >= 1.) {
            r = r * r;
            r = r - (int)(r / ak) * ak;
        }
    }

    return r;
}

// Функция для вычисления членов BBP-суммы для конкретного m
__global__ void compute_series(int m, int id, double* results)
{
    int k = blockIdx.x * blockDim.x + threadIdx.x;
    double ak, p, s, t;
    if (k < id) {
        ak = 8 * k + m;
        p = id - k;
        t = expm_cuda(p, ak);
        s = t / ak;
        results[k] = s;
    }
}

// Функция для вычисления Pi на основе суммы BBP
double series(int m, int id, double* d_results)
{
    double* h_results = (double*)malloc(id * sizeof(double));
    double s = 0.0;
    int num_blocks = (id + BLOCK_SIZE - 1) / BLOCK_SIZE;

    // Копируем данные на GPU
    cudaMemcpy(d_results, h_results, id * sizeof(double), cudaMemcpyHostToDevice);

    // Запускаем CUDA kernel для вычисления членов серии
    compute_series << <num_blocks, BLOCK_SIZE >> > (m, id, d_results);

    // Копируем результаты с GPU на CPU
    cudaMemcpy(h_results, d_results, id * sizeof(double), cudaMemcpyDeviceToHost);

    // Складываем результаты
    for (int k = 0; k < id; k++) {
        s += h_results[k];
        s -= (int)s;  // Оставляем только дробную часть
    }

    free(h_results);
    return s;
}

// Функция для преобразования числа Pi в десятичные цифры
void idec(double x, int ndec, char cdec[])
{
    int i;
    double y;

    y = fabs(x);

    for (i = 0; i < ndec; i++) {
        y = 10. * (y - floor(y));
        cdec[i] = '0' + (int)y;
    }
    cdec[ndec - 1] = '\0';
}

int main()
{
    double pid, s1, s2, s3, s4;
    double* d_results;
    int id = 100000000;
    char cdec[NDEC];

    // Выделение памяти для хранения результатов на GPU
    cudaMalloc((void**)&d_results, id * sizeof(double));

    // Замер времени
    clock_t start_time, end_time;
    double time_taken;
    start_time = clock();

    // Вычисляем части формулы BBP с использованием CUDA
    s1 = series(1, id, d_results);
    s2 = series(4, id, d_results);
    s3 = series(5, id, d_results);
    s4 = series(6, id, d_results);
    pid = 4. * s1 - 2. * s2 - s3 - s4;
    pid = pid - (int)pid + 1.;

    // Преобразуем в десятичные цифры
    idec(pid, NDEC, cdec);

    // Выводим результат
    printf("Position: %i Decimal digits: %s\n", id, cdec);

    // Конец замера времени
    end_time = clock();
    time_taken = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;
    printf("Time taken: %f seconds\n", time_taken);

    // Освобождение памяти на GPU
    cudaFree(d_results);

    return 0;
}
