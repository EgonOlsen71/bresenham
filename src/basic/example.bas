10 rem another demo for the "bresemham" graphics package
20 rem *************************************************
30 if lf%=0 then lf%=1:load"graphics",8,1
50 gosub 10000
55 sys 49152: rem init hires graphics
60 gosub 1000

150 for x=1 to 319 step 3
160 xc=x:y=40:gosub 1100:xc=50*si(x)+100:y=x/1.6:gosub 1200
170 next

190 gosub 1000
200 for x=0 to 318 step 2 
210 xc=x:y=40*co(x)+100:gosub 1100
215 xc=50*si(x)+100:y=x/1.6:gosub 1200
220 next
230 goto 60

1000 poke 780,0*16+1: rem set clear color (color*16+background)
1010 sys 49158: rem clear hires screen color in 780
1020 return

1100 rem setup coordinates for starting point of the line
1110 xh=-(xc>255):xl=xc and 255
1120 poke 780,xl:poke 781,xh:poke 782,y+1
1130 sys 49164: rem set coordinates
1140 return

1200 rem setup coordinates for end point of the line
1210 xh=-(xc>255):xl=xc and 255
1220 poke 780,xl:poke 781,xh:poke 782,y+1
1230 sys 49167: rem draw line
1240 return

10000 rem setup sin/cos tables
10005 print chr$(147);"setting up sin/cos tables..."
10010 dim si(319),co(319)
10020 for x=0 to 319:si(x)=sin(x/30):co(x)=cos(x/20)
10030 poke 53280,x and 255:next:return