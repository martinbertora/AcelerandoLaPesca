# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "C:/Users/jmber/esp/esp-idf/components/bootloader/subproject"
  "D:/Proyectointegrador1/programaenC/AcelerandoLaPesca/build/bootloader"
  "D:/Proyectointegrador1/programaenC/AcelerandoLaPesca/build/bootloader-prefix"
  "D:/Proyectointegrador1/programaenC/AcelerandoLaPesca/build/bootloader-prefix/tmp"
  "D:/Proyectointegrador1/programaenC/AcelerandoLaPesca/build/bootloader-prefix/src/bootloader-stamp"
  "D:/Proyectointegrador1/programaenC/AcelerandoLaPesca/build/bootloader-prefix/src"
  "D:/Proyectointegrador1/programaenC/AcelerandoLaPesca/build/bootloader-prefix/src/bootloader-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "D:/Proyectointegrador1/programaenC/AcelerandoLaPesca/build/bootloader-prefix/src/bootloader-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "D:/Proyectointegrador1/programaenC/AcelerandoLaPesca/build/bootloader-prefix/src/bootloader-stamp${cfgdir}") # cfgdir has leading slash
endif()
