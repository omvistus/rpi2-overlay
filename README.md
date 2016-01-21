All ebuilds built successfully with with:

    CFLAGS="-O2 -march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -mtls-dialect=gnu2 -fomit-frame-pointer"
    .
    .
    .
    USE="${USE} gles"
