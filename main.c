#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/time.h>

#include <nmmintrin.h>

#define MAXSIZE (2048)

#define PADDING	(32)
#define PADDED_SIZE(size) (size + PADDING + PADDING)

char data[PADDED_SIZE(MAXSIZE)];

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

uint64_t
test_size(func_t func, size_t size)
{
	size_t padded_size = PADDED_SIZE(size);
	memset(data, 0xfa, padded_size);

	uint64_t s, f;
	s = get_time();

	char *just_data = data + PADDING;
	for (size_t i = 10000; i; i--) {
		func(just_data, size);
	}

	f = get_time();

	for (int i = 0; i < padded_size; i++) {
		if (i < PADDING || i >= (size + PADDING)) {
			if (data[i] != (char) 0xfa) {
				printf("\n%d has no padding! %d\n", i, data[i]);
				exit(1);
			}
		} else {
			if (data[i] != 0) {
				printf("\n%d has no zero!\n", i);
				exit(1);
			}
		}
	}

	return f - s;
}

void
test(const char *name, func_t func)
{
	unsigned t0 = test_size(func, 0);
	unsigned t1 = test_size(func, 1);
	unsigned t2 = test_size(func, 2);
	printf("%s:\n0=%u 1=%u 2=%u", name, t0, t1, t2);

	for (int i = 4; i < MAXSIZE; i *= 2) {
		int i3 = i - 1, i4 = i, i5 = i + 1;
		unsigned t3 = test_size(func, i3);
		unsigned t4 = test_size(func, i4);
		unsigned t5 = test_size(func, i5);
		printf(" %d=%u %d=%u %d=%u", i3, t3, i4, t4, i5, t5);
	}

	int i6 = MAXSIZE - 1, i7 = MAXSIZE;
	unsigned t6 = test_size(func, i6);
	unsigned t7 = test_size(func, i7);
	printf(" %d=%u %d=%u\n\n", i6, t6, i7, t7);
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
