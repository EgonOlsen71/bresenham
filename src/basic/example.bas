10 rem simple demo for the "bresemham" graphics package
20 rem ************************************************
30 if lf%=0 then lf%=1:load"graphics",8,1
100 print chr$(147);:poke 53280,15:poke 53281,1
110 sys 49152: rem init hires graphics
120 poke 780,0*16+1: rem set clear color (color*16+background)
130 sys 49158: rem clear hires screen color in 780
140 an=3.1415/8
150 a=0:b=0:c=0
160 f1=20:f2=5:f3=8
170 v1=160:v2=100
180 co=cos(an):si=sin(an)
200 sy=-0.5:sx=-0.05
210 for ct=1 to 2
220 for yr=3 to -4 step sy
230 for xr=3 to -3 step sx
240 zr=yr*yr-xr*xr
250 x=f1*(a+xr)+f3*(yr+c)*co+v1
260 y=f2*(b+zr)+f3*(yr+c)*si+v2
265 rem setup coordinates for point to plot
266 rem x in 780/781 (lo/hi), y in 782
268 xh=-(x>255):xl=x and 255
270 poke 780,xl:poke 781,xh:poke 782,y
280 sys 49161: rem plot point at x/y
285 rem setup coordinates for starting point of the line
290 poke 780,xl:poke 781,xh:poke 782,y+1
300 sys 49164: rem plot line's first point
305 rem setup coordinates for end point of the line
310 poke 780,xl:poke 781,xh:poke 782,199
320 sys 49170: rem clear the line
330 next:next
340 if ct=1 then gosub 1100:poke 780,0*16+1:sys 49158:sy=-0.05:sx=-0.5
350 next ct
360 for t=8192 to 8192+8000:poket,peek(t) or peek(t+8192):next
365 poke 53280,1
370 poke 198,0:wait 198,255:printchr$(147);:sys 49155:end: rem hires off
1000 rem copy image into upper memory to merge them later
1100 for t=8192 to 8192+8000:poket+8192,peek(t):next
1110 return
