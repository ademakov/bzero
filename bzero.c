#include <stdint.h>
#include <string.h>

#include <emmintrin.h>

void
bzero_0(char *s, size_t n)
{
	memset(s, 0, n);
}

void
bzero_1(char *s, size_t n)
{
#pragma clang loop unroll(disable)
	while (n--)
		*s++ = 0;
}

void
bzero_2(char *s, size_t n)
{
	char *e = s + n;
#pragma clang loop unroll(disable)
	while (s < e)
		*s++ = 0;
}

void
bzero_3(char *s, size_t n)
{
	asm volatile("cld; rep; stosb" : "+D"(s), "+c"(n) : "a"(0) : "memory", "cc");
}

void
bzero_4(char *s, const size_t n)
{
	char *e = s + (n & ~64);

	if (s != e) {
#pragma clang loop unroll(disable)
		do {
			((int64_t *) s)[0] = 0;
			((int64_t *) s)[1] = 0;
			((int64_t *) s)[2] = 0;
			((int64_t *) s)[3] = 0;
			((int64_t *) s)[4] = 0;
			((int64_t *) s)[5] = 0;
			((int64_t *) s)[6] = 0;
			((int64_t *) s)[7] = 0;

			s += 64;
		} while (s < e);

		if ((n & 63) == 0)
			return;
	} else {
		if (n == 0)
			return;
	}

	if ((n & 32) != 0) {
		((int64_t *) s)[0] = 0;
		((int64_t *) s)[1] = 0;
		((int64_t *) s)[2] = 0;
		((int64_t *) s)[3] = 0;

		if ((n & 31) == 0)
			return;

		s += 32;
	}

	if ((n & 16) != 0) {
		((int64_t *) s)[0] = 0;
		((int64_t *) s)[1] = 0;

		if ((n & 15) == 0)
			return;

		s += 16;
	}

	if ((n & 8) != 0) {
		((int64_t *) s)[0] = 0;

		if ((n & 7) == 0)
			return;

		s += 8;
	}

	if ((n & 4) != 0) {
		((int32_t *) s)[0] = 0;

		if ((n & 3) == 0)
			return;

		s += 4;
	}

	if ((n & 2) != 0) {
		((int16_t *) s)[0] = 0;

		if ((n & 1) == 0)
			return;

		s += 2;
	}

	((int8_t *) s)[0] = 0;
}

void
bzero_5(char *s, size_t n)
{
	char *e = s + (n & ~64);
	__m128i zero = _mm_setzero_si128();

	if (s != e) {
#pragma clang loop unroll(disable)
		do {
			_mm_storeu_si128(&(((__m128i *) s)[0]), zero);
			_mm_storeu_si128(&(((__m128i *) s)[1]), zero);
			_mm_storeu_si128(&(((__m128i *) s)[2]), zero);
			_mm_storeu_si128(&(((__m128i *) s)[3]), zero);

			s += 64;
		} while (s < e);

		if ((n & 63) == 0)
			return;
	} else {
		if (n == 0)
			return;
	}

	if ((n & 32) != 0) {
		_mm_storeu_si128(&(((__m128i *) s)[0]), zero);
		_mm_storeu_si128(&(((__m128i *) s)[1]), zero);

		if ((n & 31) == 0)
			return;

		s += 32;
	}

	if ((n & 16) != 0) {
		_mm_storeu_si128(&(((__m128i *) s)[0]), zero);

		if ((n & 15) == 0)
			return;

		s += 16;
	}

	if ((n & 8) != 0) {
		((int64_t *) s)[0] = 0;

		if ((n & 7) == 0)
			return;

		s += 8;
	}

	if ((n & 4) != 0) {
		((int32_t *) s)[0] = 0;

		if ((n & 3) == 0)
			return;

		s += 4;
	}

	if ((n & 2) != 0) {
		((int16_t *) s)[0] = 0;

		if ((n & 1) == 0)
			return;

		s += 2;
	}

	((int8_t *) s)[0] = 0;
}
