0 rem simple demo for the flood filler
1 rem ********************************
2 if lf%=0 then lf%=1:load"graphics",8,1
10 sys 49152
20 poke 780,1:sys 49158
30 x1=100:y1=50:x2=300:y2=50:gosub 1000
40 x1=50:y1=150:x2=300:y2=150:gosub 1000
50 x1=50:y1=50:x2=50:y2=150:gosub 1000
60 x1=300:y1=50:x2=300:y2=150:gosub 1000
61 x1=100:y1=150:x2=150:y2=120:gosub 1000
62 x1=200:y1=150:x2=150:y2=120:gosub 1000
63 x1=20:y1=0:x2=80:y2=100:gosub 1000
64 x1=80:y1=100:x2=120:y2=0:gosub 1000
65 x1=200:x2=280:y1=90:y2=90:gosub 1000
66 x1=200:x2=200:y1=90:y2=50:gosub 1000
67 x1=280:x2=280:y1=90:y2=50:gosub 1000
68 x1=180:y1=138:x2=260:y2=90:gosub 1000
70 x=100:y=100:gosub 2000
80 end
1000 poke 780,x1 and 255:poke 781,-(x1>255):poke 782,y1:sys 49164
1010 poke 780,x2 and 255:poke 781,-(x2>255):poke 782,y2:sys 49167
1020 return
2000 poke 780,x and 255:poke 781,-(x>255):poke 782,y:sys 49176
2010 return