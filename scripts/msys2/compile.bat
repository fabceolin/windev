:: tutorial https://sites.google.com/miningmath.com/mms-dev/projeto-simsched/compilacao/windows-1/msys2-in-progress
:: montar diretorio com fontes do host
mount -o anon 10.0.2.2:/build y:

:: copia arquivos para windows com rsync do msys2
set MSYSTEM=MINGW64
c:\tools\msys64\usr\bin\bash.exe --login -c "rsync -r --exclude big-cases --exclude package* --exclude .git* --exclude build --exclude simsched/build --exclude qtitanribbon/build --exclude exportdata/build --exclude qtitanribbon/bin --exclude package --exclude doc --exclude qtitanribbon/documentation  --exclude deploy -v /Y/ /C/interface"      

:: remove build antiga
set PREFIX=/C/interface/build
set CI_PROJECT_DIR=/C/interface
c:\tools\msys64\usr\bin\bash.exe --login -c "rm -rf %PREFIX%"

:: cria diretorio de build
c:\tools\msys64\usr\bin\bash.exe --login -c "mkdir -p %PREFIX%; mkdir -p %PREFIX%/{src,bin,lib,include}"

:: dependencia bzip2
SET LIB_PREFIX=/mingw64
c:\tools\msys64\usr\bin\bash.exe --login -c "ranlib %LIB_PREFIX%/lib/libbz2.a; install -m644 %LIB_PREFIX%/include/bzlib.h %CI_PROJECT_DIR%/build/include; install -m644 %LIB_PREFIX%/libbz2.a %CI_PROJECT_DIR%/build/lib"

::dependencia zlib
c:\tools\msys64\usr\bin\bash.exe --login -c "ranlib %LIB_PREFIX%/libz.a; install -m644 %LIB_PREFIX%/zlib1.dll %PREFIX%/bin; install -m644 %LIB_PREFIX%/{zconf.h,zlib.h} %PREFIX%/include; install -m644 %LIB_PREFIX%/libz.a %PREFIX%/lib"

::dependecia icu
c:\tools\msys64\usr\bin\bash.exe --login -c ""

:: compila generic-optimization 
c:\tools\msys64\usr\bin\bash.exe --login -c "cd %CI_PROJECT_DIR%/generic-optimization; rm -rf build; mkdir build; cd build; export PKG_CONFIG_LIBDIR=/mingw64/lib/pkgconfig; export PKG_CONFIG_PATH=/mingw64; cmake -G'MSYS Makefiles' -DOPTIMIZER=CLP -DCMAKE_BUILD_TYPE=Debug-DCMAKE_INSTALL_PREFIX:PATH=%CI_PROJECT_DIR%/build ../src; make -j `nproc` install"

:: compila ioss 
c:\tools\msys64\usr\bin\bash.exe --login -c "cd %CI_PROJECT_DIR%/ioss; rm -rf build; mkdir build; cd build; export PKG_CONFIG_LIBDIR=/mingw64/lib/pkgconfig; export PKG_CONFIG_PATH=/mingw64; cmake -G 'MSYS Makefiles' -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=%CI_PROJECT_DIR%/build -DBOOST_ROOT=/mingw64 -DMINGW_INCLUDE_DIR=/mingw64/include -DPYTHON_EXECUTABLE=/mingw64/bin/python3.8.exe -DPYTHON_INCLUDE_DIRS=/mingw64/include/python3.8/ -DPYTHON_LIBRARIES=/mingw64/lib/libpython3.8.dll.a ../src; make -j `nproc` install"

:: compila exportdata
::
:: prepara ambiente visual studio
call "c:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools/VC/Auxiliary/Build/vcvarsall.bat" x64
cd c:\interface\simsched\exportdata
rm -rf build
mkdir -p build
cd build
cmake -DCSV=1 -DXLS=1 -DCMAKE_INSTALL_PREFIX=y:\install -DCMAKE_TOOLCHAIN_FILE=..\toolchains\windows-visualstudio-md.cmake -G"NMake Makefiles" ..\src

:: compila simsched
c:\tools\msys64\usr\bin\bash.exe --login -c "cd %CI_PROJECT_DIR%/ioss; rm -rf build; mkdir build; cd build; export PKG_CONFIG_LIBDIR=/mingw64/lib/pkgconfig:/mingw64/share/pkgconfig; export PKG_CONFIG_PATH=/mingw64; cmake -G 'MSYS Makefiles' -DCMAKE_INSTALL_PREFIX:PATH=%CI_PROJECT_DIR%/build -DMINGW_INCLUDE_DIR=/mingw64/include -DCSV=1 -DUNIT_TESTS=1 -DPYTHON_LIBRARIES=/mingw64/lib/libpython3.8.dll.a -DEIGEN3_INCLUDE_DIRS=/mingw64/include/eigen3 -DICU_ROOT=/mingw64 -DCLP_LIBRARY_DIRS=$PWD/include/lp ../src; make -j `nproc` install"

:: compila qtitan
call "c:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools/VC/Auxiliary/Build/vcvarsall.bat" x64
cd c:\interface\qtitanribbon
rm -rf build
mkdir -p build
cd build
qmake ..\QtitanRibbon.pro

:: compila interface
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=c:\interface\build -DCMAKE_TOOLCHAIN_FILE=c:\vcpkg-vtkqt\scripts\buildsystems\vcpkg.cmake -DBoost_USE_STATIC_LIBS=OFF -DBoost_USE_STATIC_RUNTIME=OFF -DQTITAN_DIR=c:\interface\qtitanribbon -DVTK_DIR=c:\vcpkg-vtkqt\installed\x64-windows\share\vtk -DVTK_PREFIX_INSTALL=c:\vcpkg-vtkqt\installed\x64-windows ..\src
