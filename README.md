# bzero
Some DIY bzero experiments

Testing of C bzero versions might be totally off if using `clang -O2` or
`gcc -O3`. They might totally rewrite C-versions vectorizing stuff or
replacing it with built-in or libc versions of bzero or memset.

So only `gcc -O2` works as might be naively expected.
