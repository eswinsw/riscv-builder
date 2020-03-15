#!/bin/bash

wget https://mesa.freedesktop.org/archive/mesa-20.0.1.tar.xz
dnf builddep mesa
tar -xf mesa-20.0.1.tar.xz && cd mesa-20.0.1
meson --prefix=/usr builddir/ -Dgallium-drivers=virgl -Ddri-drivers= -Dvulkan-drivers= -Dglx=xlib
ninja -C builddir/ install
