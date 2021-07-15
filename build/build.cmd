call mosm ..\src\asm\graphics.asm
call mospeed ..\src\basic\example.bas -memhole=8192-16191
call mospeed ..\src\basic\example2.bas -memhole=8192-24191
call mospeed ..\src\basic\example3.bas -memhole=8192-16191
call mospeed ..\src\basic\butterfly.bas -memhole=8192-16191

del graphics_AD.d64
c1541 -format graphics,gr d64 graphics_AD.d64
call ..\build\c1541 ..\build\graphics_AD.d64 -write ++example.prg example,p
call ..\build\c1541 ..\build\graphics_AD.d64 -write ++example2.prg example2,p
call ..\build\c1541 ..\build\graphics_AD.d64 -write ++example3.prg example3,p
call ..\build\c1541 ..\build\graphics_AD.d64 -write ++butterfly.prg butterfly,p
call ..\build\c1541 ..\build\graphics_AD.d64 -write graphics.prg graphics,p
call ..\build\c1541 ..\build\graphics_AD.d64 -write ..\gfx\butterfly.ve2 butterfly.ve2,s