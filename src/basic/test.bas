10 rem another demo for the "bresemham" graphics package
20 rem *************************************************
30 if lf%=0 then lf%=1:load"graphics",8,1
50 sys 49152: rem init hires graphics
60 gosub 1000

150 xc=256:y=40:gosub 1100
160 xc=195:y=100:gosub 1200

200 end

1000 poke 780,0*16+1: rem set clear color (color*16+background)
1010 sys 49158: rem clear hires screen color in 780
1020 return

1100 rem setup coordinates for starting point of the line
1110 xh=-(xc>255):xl=xc and 255
1120 poke 780,xl:poke 781,xh:poke 782,y+1
1130 sys 49164: rem set coordinates
1136 print chr$(147);"1: ";xc,y,xl,xh
1140 return

1200 rem setup coordinates for end point of the line
1210 xh=-(xc>255):xl=xc and 255
1220 poke 780,xl:poke 781,xh:poke 782,y+1
1230 sys 49167: rem draw line
1236 print "2: ";xc,y
1240 return