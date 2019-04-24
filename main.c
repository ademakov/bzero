#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/time.h>

#include <nmmintrin.h>

#define MAXSIZE (4096)

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
void bzero_9(char *s, size_t n);
void bzero_A(char *s, size_t n);
void bzero_B(char *s, size_t n);

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
test(const char *name, func_t func, unsigned size)
{
	unsigned i = 0;

	printf("%s:\n", name);
	if (size) {
		for (; i < 32; i++) {
			unsigned t = test_size(func, size);
			printf(" %u=%u", size, t);
		}
		printf("\n");
		return;
	}

	for (; i < 16; i++) {
		unsigned t = test_size(func, i);
		printf(" %u=%u", i, t);
	}
	printf("\n");
	for (; i < 32; i++) {
		unsigned t = test_size(func, i);
		printf(" %u=%u", i, t);
	}
	printf("\n");

	for (i = 32; i < MAXSIZE; i *= 2) {
		unsigned n[] = { i, i + 1, i + 2, i + 3, i + 4,
				 i + i/2 - 2, i + i/2 - 1, i + i/2, i + i/2 + 1, i + i/2 + 2,
				 i*2 - 4, i*2 - 3, i*2 - 2, i*2 - 1 };
		for (unsigned j = 0; j < sizeof n / sizeof *n; j++) {
			unsigned k = n[j];
			unsigned t = test_size(func, k);
			printf(" %u=%u", k, t);
		}
		printf("\n");
	}

	unsigned t = test_size(func, MAXSIZE);
	printf(" %d=%u\n\n", MAXSIZE, t);
}

int
main(int ac, char *av[])
{
	if (ac < 2) {
		test("bzero_1", bzero_1, 0);
		test("bzero_2", bzero_2, 0);
		test("bzero_3", bzero_3, 0);
		test("bzero_4", bzero_4, 0);
		test("bzero_5", bzero_5, 0);
		test("bzero_6", bzero_6, 0);
		test("bzero_7", bzero_7, 0);
		test("bzero_8", bzero_8, 0);
		test("bzero_9", bzero_9, 0);
		test("bzero_A", bzero_A, 0);
		test("bzero_B", bzero_B, 0);
		test("bzero_0", bzero_0, 0);
	} else {
		char *s = av[1];

		unsigned size = 0;
		if (ac > 2)
			size = atoi(av[2]);

		for (int c = *s++; c; c = *s++) {
			switch(c) {
			case '0':
				test("bzero_0", bzero_0, size);
				break;
			case '1':
				test("bzero_1", bzero_1, size);
				break;
			case '2':
				test("bzero_2", bzero_2, size);
				break;
			case '3':
				test("bzero_3", bzero_3, size);
				break;
			case '4':
				test("bzero_4", bzero_4, size);
				break;
			case '5':
				test("bzero_5", bzero_5, size);
				break;
			case '6':
				test("bzero_6", bzero_6, size);
				break;
			case '7':
				test("bzero_7", bzero_7, size);
				break;
			case '8':
				test("bzero_8", bzero_8, size);
				break;
			case '9':
				test("bzero_9", bzero_9, size);
				break;
			case 'A': case 'a':
				test("bzero_A", bzero_A, size);
				break;
			case 'B': case 'b':
				test("bzero_B", bzero_B, size);
				break;
			}
		}
	}
	return 0;
}
