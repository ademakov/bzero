#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/time.h>

#include <nmmintrin.h>

//#define SIZE (128)
#define SIZE (255)

#define PADDING	(32)

#define PADDED_SIZE (SIZE + PADDING + PADDING)

char data[PADDED_SIZE];

typedef void (*func_t)(char *, size_t);

void bzero_0(char *s, size_t n);
void bzero_1(char *s, size_t n);
void bzero_2(char *s, size_t n);
void bzero_3(char *s, size_t n);
void bzero_4(char *s, size_t n);
void bzero_5(char *s, size_t n);
void bzero_6(char *s, size_t n);
void bzero_7(char *s, size_t n);
void bzero_8(char *s, size_t n);

uint64_t
get_time(void)
{
	struct timeval tm;
	gettimeofday(&tm, NULL);
	return tm.tv_sec * 1000000 + tm.tv_usec;
}

void
test(const char *name, func_t func)
{
	memset(data, 0xfa, PADDED_SIZE);

	uint64_t s, f;
	s = get_time();

	for (size_t i = 10000; i; i--) {
		func(data + PADDING, SIZE);
	}

	f = get_time();
	printf("%s: %llu\n", name, f - s);

	for (int i = 0; i < PADDED_SIZE; i++) {
		if (i < PADDING || i >= (SIZE + PADDING)) {
			if (data[i] != (char) 0xfa)
				printf("%d has no padding! %d\n", i, data[i]);
		} else {
			if (data[i] != 0)
				printf("%d has no zero!\n", i);
		}
	}
}

int
main()
{
    printf("%p\n", data);

	test("bzero_1", bzero_1);
	test("bzero_2", bzero_2);
	test("bzero_3", bzero_3);
	test("bzero_4", bzero_4);
	test("bzero_5", bzero_5);
	test("bzero_6", bzero_6);
	test("bzero_7", bzero_7);
	test("bzero_8", bzero_8);
	test("bzero_0", bzero_0);
	return 0;
}
