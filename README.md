# bzero
Some DIY bzero experiments

Testing of C bzero versions might be totally off if using `clang -O2` or
`gcc -O3`. They might totally rewrite C-versions vectorizing stuff or
replacing it with built-in or libc versions of bzero or memset.

So only `gcc -O2` works as might be naively expected.

Resuts on an oldish Xeon (E5520  @ 2.27GHz) w/o AVX:

    bzero_1:
    0=70 1=113 2=116 3=160 4=166 5=201 7=271 8=312 9=334 15=741 16=779 17=812 31=1266 32=1304 33=1358 63=2800 64=2184 65=1862 127=3338 128=3365 129=3397 255=6386 256=6419 257=6432 511=12462 512=12490 513=12522 1023=24660 1024=24677 1025=24683 2047=49821 2048=49999

    bzero_2:
    0=70 1=132 2=109 3=143 4=157 5=161 7=206 8=208 9=248 15=408 16=570 17=429 31=698 32=869 33=784 63=1496 64=1246 65=1457 127=2290 128=2356 129=2351 255=4572 256=4486 257=4509 511=8742 512=8809 513=8871 1023=17521 1024=17276 1025=17277 2047=35287 2048=35189

    bzero_3:
    0=109 1=113 2=105 3=106 4=387 5=379 7=376 8=376 9=376 15=376 16=375 17=411 31=467 32=471 33=475 63=595 64=598 65=601 127=748 128=752 129=781 255=772 256=768 257=772 511=796 512=799 513=823 1023=922 1024=926 1025=930 2047=1198 2048=1180

    bzero_4:
    0=65 1=128 2=109 3=127 4=98 5=113 7=130 8=95 9=111 15=149 16=95 17=110 31=165 32=91 33=115 63=207 64=185 65=143 127=237 128=182 129=190 255=356 256=285 257=297 511=652 512=593 513=609 1023=1306 1024=1243 1025=1277 2047=5152 2048=7462

    bzero_5:
    0=230 1=126 2=124 3=132 4=113 5=110 7=127 8=95 9=107 15=144 16=108 17=127 31=183 32=131 33=145 63=239 64=171 65=198 127=333 128=277 129=297 255=591 256=483 257=503 511=967 512=895 513=926 1023=1787 1024=1724 1025=1748 2047=5652 2048=4976

    bzero_6:
    0=51 1=125 2=119 3=92 4=86 5=87 7=80 8=71 9=76 15=67 16=56 17=75 31=68 32=233 33=79 63=71 64=47 65=79 127=87 128=56 129=92 255=103 256=79 257=115 511=154 512=138 513=162 1023=281 1024=265 1025=285 2047=570 2048=655

    bzero_7:
    0=42 1=80 2=76 3=73 4=73 5=77 7=67 8=61 9=68 15=149 16=55 17=75 31=63 32=51 33=79 63=67 64=43 65=79 127=83 128=56 129=92 255=99 256=79 257=115 511=151 512=138 513=162 1023=281 1024=261 1025=281 2047=616 2048=552

    bzero_8:
    0=86 1=76 2=80 3=73 4=76 5=67 7=63 8=80 9=71 15=250 16=76 17=67 31=54 32=79 33=71 63=67 64=96 65=89 127=79 128=126 129=115 255=221 256=197 257=188 511=222 512=297 513=310 1023=422 1024=497 1025=489 2047=823 2048=898

    bzero_0:
    0=87 1=83 2=88 3=92 4=82 5=79 7=79 8=155 9=75 15=75 16=64 17=63 31=64 32=63 33=71 63=71 64=71 65=91 127=94 128=94 129=94 255=128 256=127 257=128 511=210 512=190 513=186 1023=337 1024=317 1025=337 2047=629 2048=664

Results on a slighty newer laptop (i7-4850HQ CPU @ 2.30GHz) with AVX:

    bzero_1:
    0=39 1=53 2=71 3=97 4=107 5=140 7=172 8=195 9=224 15=373 16=387 17=446 31=913 32=752 33=760 63=1426 64=1427 65=1377 127=3577 128=2354 129=2656 255=5684 256=6728 257=5727 511=11006 512=9207 513=11026 1023=18433 1024=18539 1025=22289 2047=41337 2048=37005

    bzero_2:
    0=40 1=38 2=50 3=63 4=74 5=82 7=170 8=124 9=130 15=223 16=227 17=241 31=822 32=645 33=557 63=1355 64=1378 65=1395 127=2638 128=2665 129=2682 255=7749 256=7106 257=5701 511=12648 512=10357 513=12309 1023=22930 1024=21107 1025=20841 2047=41329 2048=41338

    bzero_3:
    0=235 1=136 2=125 3=180 4=138 5=125 7=125 8=125 9=124 15=125 16=125 17=125 31=125 32=125 33=125 63=124 64=125 65=125 127=125 128=124 129=143 255=143 256=142 257=149 511=172 512=153 513=175 1023=200 1024=189 1025=202 2047=288 2048=269

    bzero_4:
    0=54 1=71 2=60 3=110 4=56 5=64 7=59 8=57 9=68 15=69 16=47 17=60 31=83 32=60 33=60 63=98 64=62 65=69 127=126 128=92 129=100 255=199 256=175 257=166 511=334 512=299 513=349 1023=662 1024=676 1025=672 2047=1457 2048=1187

    bzero_5:
    0=57 1=90 2=66 3=90 4=74 5=68 7=63 8=48 9=57 15=74 16=50 17=62 31=93 32=56 33=71 63=113 64=78 65=90 127=160 128=131 129=137 255=300 256=224 257=243 511=495 512=425 513=429 1023=847 1024=790 1025=822 2047=1768 2048=1615

    bzero_6:
    0=48 1=54 2=65 3=54 4=73 5=51 7=37 8=38 9=43 15=37 16=32 17=41 31=35 32=26 33=41 63=35 64=26 65=43 127=43 128=29 129=45 255=60 256=51 257=58 511=106 512=98 513=101 1023=197 1024=189 1025=192 2047=381 2048=393

    bzero_7:
    0=46 1=50 2=61 3=47 4=64 5=38 7=34 8=33 9=39 15=33 16=29 17=38 31=38 32=23 33=38 63=34 64=26 65=43 127=40 128=29 129=46 255=61 256=51 257=57 511=106 512=98 513=101 1023=198 1024=189 1025=192 2047=381 2048=392

    bzero_8:
    0=77 1=53 2=35 3=65 4=56 5=50 7=30 8=41 9=107 15=26 16=34 17=31 31=29 32=34 33=32 63=35 64=38 65=34 127=41 128=52 129=49 255=61 256=75 257=74 511=106 512=115 513=112 1023=197 1024=189 1025=192 2047=402 2048=410

    bzero_0:
    0=112 1=78 2=79 3=129 4=89 5=84 7=95 8=72 9=69 15=89 16=77 17=74 31=98 32=86 33=83 63=109 64=70 65=70 127=75 128=74 129=75 255=83 256=82 257=83 511=105 512=105 513=106 1023=149 1024=149 1025=149 2047=241 2048=241

