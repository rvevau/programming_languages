#include <stdio.h>
#include <math.h>
#include <time.h>  // Для работы с замером времени

#define NDEC 16


void idec(double x, int ndec, char cdec[])
{
    int i;
    double y;

    y = fabs(x);

    for (i = 0; i < ndec; i++) {
        y = 10. * (y - floor(y));
        cdec[i] = '0' + (int)y;
    }
    cdec[ndec - 1] = '\0'; /* Завершаем строку нулевым символом */
}

double series(int m, int id)
{
    int k;
    double ak, eps, p, s, t;
    double expm(double x, double y);
#define eps 1e-17

    s = 0.;

    /* Суммируем серию до id */
    for (k = 0; k < id; k++) {
        ak = 8 * k + m;
        p = id - k;
        t = expm(p, ak);
        s = s + t / ak;
        s = s - (int)s;
    }

    /* Считаем несколько членов, где k >= id */
    for (k = id; k <= id + 100; k++) {
        ak = 8 * k + m;
        t = pow(16., (double)(id - k)) / ak;
        if (t < eps) break;
        s = s + t;
        s = s - (int)s;
    }
    return s;
}

double expm(double p, double ak)
{
    int i, j;
    double p1, pt, r;
#define ntp 25
    static double tp[ntp];
    static int tp1 = 0;

    /* Инициализируем таблицу степеней двойки */
    if (tp1 == 0) {
        tp1 = 1;
        tp[0] = 1.;

        for (i = 1; i < ntp; i++) tp[i] = 2. * tp[i - 1];
    }

    if (ak == 1.) return 0.;

    /* Находим наибольшую степень двойки, не превышающую p */
    for (i = 0; i < ntp; i++) if (tp[i] > p) break;

    pt = tp[i - 1];
    p1 = p;
    r = 1.;

    /* Алгоритм двоичного возведения в степень по модулю ak */
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


int main()
{
    double pid, s1, s2, s3, s4;
    double series(int m, int n);
    void idec(double x, int m, char c[]);
    int id = 100000000;
    char cdec[NDEC];
    // Замер времени
    clock_t start_time, end_time;
    double time_taken;

    // Начало замера времени
    start_time = clock();

    /* Вычисляем части формулы BBP */
    s1 = series(1, id);
    s2 = series(4, id);
    s3 = series(5, id);
    s4 = series(6, id);
    pid = 4. * s1 - 2. * s2 - s3 - s4;
    pid = pid - (int)pid + 1.;

    /* Преобразуем в десятичные цифры */
    idec(pid, NDEC, cdec);

    /* Выводим результат */
    printf("Position: %i Decimal digits: %s\n", id, cdec);


    // Конец замера времени
    end_time = clock();

    // Вычисляем время выполнения
    time_taken = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;

    // Выводим время выполнения
    printf("Time taken: %f seconds\n", time_taken);

    return 0;
}