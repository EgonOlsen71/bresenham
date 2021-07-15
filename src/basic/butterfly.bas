0 if lf=0 then lf=1:load"graphics",8,1
10 poke 45,0:poke 46,64:poke 47,0:poke 48,64:clr:lf=1
20 cx=2:cy=1
100 gosub 4000
1000 gosub 40000:gosub 50000
1010 open 2,8,2,f$:er%=0:do%=0:poke 781,2:sys 65478:gosub 2000
1015 gosub 3000
1020 gosub 42000
1030 if do%<>0 or er%<>0 then 5000
1040 on by+1 gosub 10000,11000,12000,13000,,,,,,,16000,17000,18000
1050 goto 1020

1999 rem read header
2000 t$="":for i=0to2
2010 get b$:t$=t$+b$:next
2020 if t$<>"ve2" then er%=1
2030 return

2999 rem read feature set
3000 gosub 43000: rem min x coord, we don't care
3010 gosub 43000: rem max x coord, we don't care
3020 gosub 43000: rem min y coord, we don't care
3030 gosub 43000: rem max y coord, we don't care
3040 gosub 43000: rem res x, don't care
3050 gosub 43000: rem res y, don't care
3060 gosub 42000: cx = by: rem x byte count
3070 gosub 42000: cy = by: rem y byte count
3080 gosub 43000: rem feature word, don't care
3090 return


4000 print chr$(147);:poke 646,0:poke 53280,15
4010 poke 53281,1
4020 ll$=chr$(0)
4030 print chr$(147);
4050 return

5000 rem end
5010 sys 65484:close 2:poke 53280,1
5020 if er%=1 then sys49155:print "error reading file!"
5030 goto 5030

9999 rem read point
10000 gosub 44000:jp=wo:gosub 45000:kp=wo
10010 gosub 63000:return

10999 rem read line
11000 gosub 44000:x1=wo:gosub 45000:y1=wo
11010 gosub 44000:x2=wo:gosub 45000:y2=wo
11020 gosub 60000:return

11999 rem read rectangle
12000 gosub 44000:xa=wo:gosub 45000:ya=wo
12010 gosub 44000:xs=wo:gosub 45000:ys=wo
12020 x1=xa:y1=ya:x2=xs:y2=ya:gosub 60000
12030 x1=xs:y1=ya:x2=xs:y2=ys:gosub 60000
12040 x1=xs:y1=ys:x2=xa:y2=ys:gosub 60000
12050 x1=xa:y1=ys:x2=xa:y2=ya:gosub 60000
12060 return

12999 rem read square
13000 gosub 44000:xa=wo:gosub 45000:ya=wo
13010 gosub 46000:xs=wo+xa:ys=wo+ya
13020 gosub 12020
13060 return

15999 rem read multi-dot
16000 gosub 42000
16010 for i=1 to by
16020 gosub 10000
16030 next:return

16999 rem read multi-line
17000 gosub 42000:ee=by
17010 gosub 44000:x1=wo:gosub 45000:y1=wo
17020 for i=1 to ee-1
17030 gosub 44000:x2=wo:gosub 45000:y2=wo
17040 gosub 60000:x1=x2:y1=y2
17050 next:return

17999 rem read polyfill
18000 gosub 42000:ee=by:xs=0:ys=0
18010 gosub 44000:x1=wo:gosub 45000:y1=wo
18015 xs=xs+x1:ys=ys+y1
18020 for i=1 to ee-1
18030 gosub 44000:x2=wo:gosub 45000:y2=wo
18035 xs=xs+x2:ys=ys+y2
18040 gosub 60000:x1=x2:y1=y2
18050 next
18060 jp=xs/ee:kp=ys/ee
18070 gosub 63200: return

40000 poke 53280,15
40100 f$="butterfly.ve2"
40110 return

41999 rem read byte
42000 so=st:if so=64 then do%=1:return
42010 if so<>0 then er%=1:return
42020 get by$:by=asc(by$+ll$)
42030 return

42999 rem read word
43000 so=st:if so=64 then do%=1:return
43010 if so<>0 then er%=1:return
43020 get by$:b1=asc(by$+ll$)
43030 get by$:b2=asc(by$+ll$)
43040 wo=b1+256*b2:return

43999 rem read either byte or word for x
44000 if cx=1 then gosub 42000:wo=by
44010 if cx=2 then gosub 43000
44020 return

44999 rem read either byte or word for y
45000 if cy=1 then gosub 42000:wo=by
45010 if cy=2 then gosub 43000
45020 return

45999 rem read either word or byte depending on x/y
46000 if cx>cy then 44000
46010 goto 45000

50000 sys 49152:poke 780,1:sys 49158
50040 return


59999 rem draws a line
60000 if x1=x2 and y1=y2 then jp=x1:kp=y1:gosub 63000:return
60010 hx=-(x1>255):lx=x1 and 255
60020 poke 780,lx:poke 781,hx:poke 782,y1:sys 49164
60030 hx=-(x2>255):lx=x2 and 255
60040 poke 780,lx:poke 781,hx:poke 782,y2:sys 49167
60050 return

62999 rem plots a point
63000 hx=-(jp>255):lx=jp and 255
63020 poke 780,lx:poke 781,hx:poke 782,kp:sys 49161
63030 return

63199 rem fill
63200 hx=-(jp>255):lx=jp and 255
63210 poke 780,lx:poke 781,hx:poke 782,kp:sys 49176
63320 return
