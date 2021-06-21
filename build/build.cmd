call mosm ..\src\asm\graphics.asm
call mospeed ..\src\basic\example.bas -memhole=8192-24191
call mospeed ..\src\basic\example2.bas -memhole=8192-24191

del graphics_AD.d64
c1541 -format graphics,gr d64 graphics_AD.d64
call ..\build\c1541 ..\build\graphics_AD.d64 -write ++example.prg example,p
call ..\build\c1541 ..\build\graphics_AD.d64 -write ++example2.prg example2,p
call ..\build\c1541 ..\build\graphics_AD.d64 -write graphics.prg graphics,p
