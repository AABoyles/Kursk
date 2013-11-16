breed[infantries infantry]
breed[tanks tank]
breed[deathstars deathstar]



turtles-own [
  range         ;over how many patches can agents attack
  power         ;how strong an accurate attack will be
  oDefense      ;Original Defense
  defense       ;how strong an attack an individual can endure
  speed         ;how many patches an agent can cover in a tick
  soviet?       ;True for Soviets, false for Germans
  target        ;who the agent is shooting at
  tempDef       ;temporary HP loss
  accuracy      ;Accuracy
  amount        ;How Many
]

globals [ initGermans initRussians x y GermanRetreat? GermanCapture?]

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  set GermanRetreat? false;
  set GermanCapture? false;
  createSoviets
  createGermans
  set initGermans (sum [amount] of turtles with [soviet? = false])
  set initRussians (sum [amount] of turtles with [soviet?])
end

to createSoviets   
  set-default-shape infantries "person"
  create-infantries 200 * 12 / Units_per_Unit_Represented [ 
    set x random-normal 11 1
    set y random-normal 0 4
    if x > 16 [ set x 15.9 ]
    if y > 16 [ set y 15.9 ]
    if x < -16 [ set x -15.9 ]
    if y < -16 [ set y -15.9 ]
    setxy  x y
    facexy -2 0
    set color red
    set speed .1
    set range 2
    set power .5
    set defense 1
    set accuracy .5
    set amount Units_per_Unit_Represented
    set oDefense amount * defense
    set soviet? true]  
  
  set-default-shape tanks "tank"
  create-tanks 52  * 12 / Units_per_Unit_Represented [ 
    set x random-normal 11 1
    set y random-normal 0 3
    if x > 16 [ set x 15.9 ]
    if y > 16 [ set y 15.9 ]
    if x < -16 [ set x -15.9 ]
    if y < -16 [ set y -15.9 ]
    setxy  x y
    facexy -2 0
    set color red
    set size 1.4 
    set speed .1
    set range 3
    set power 12
    set defense 10
    set accuracy 3
    set amount Units_per_Unit_Represented
    set oDefense amount * defense
    set soviet? true]
end

to createGermans    
  set-default-shape infantries "person"
  create-infantries 36  * 36 / Units_per_Unit_Represented [ 
     setxy random-normal -15.8 .25 random-normal -3 2
    facexy 11 0
    set color grey
    set speed .17 
    set range 2
    set power .6
    set defense 1.2
    set accuracy .7
    set amount Units_per_Unit_Represented
    set oDefense amount * defense
    set soviet? false]  
  
  ;German 3rd Panzerkorps
  set-default-shape tanks "tank"
  create-tanks 12 * 12 / Units_per_Unit_Represented [ 
    setxy -16 -1
    facexy 11 0
    set color grey
    set size 1.4 
    set speed .17
    set range 5
    set power 25
    set defense 13
    set accuracy 16
    set amount Units_per_Unit_Represented
    set oDefense amount * defense
    set soviet? false]
  
    set-default-shape tanks "tank"
  
  ;German 1st Panzerkorps
  create-tanks 12  * 12 / Units_per_Unit_Represented [ 
    setxy -16 -3
    facexy 11 0
    set color grey
    set size 1.4 
    set speed .17
    set range 5 
    set power 30
    set defense 13
        set oDefense amount * defense
    set accuracy 16
    set amount Units_per_Unit_Represented
    set soviet? false]
  
  ;German 2nd Panzerkorps
  create-tanks 12  * 12 / Units_per_Unit_Represented [
    setxy -16 -5
    facexy 11 0
    set color grey
    set size 1.4 
    set speed .17
    set range 5 
    set power 30
    set defense 13
        set oDefense amount * defense
    set accuracy 16
    set amount Units_per_Unit_Represented
    set soviet? false]  
end

to drawXXIV
  ;German 3rd Panzerkorps
  set-default-shape tanks "tank"
  create-tanks 12  * 12 / Units_per_Unit_Represented [ 
    setxy -16 -1
    facexy 11 0
    set color grey
    set size 1.4 
    set speed .2
    set range 5
    set power 30
    set defense 13
        set oDefense amount * defense
    set accuracy 16
    set amount Units_per_Unit_Represented
    set soviet? false]
end

to advance
  ask turtles [
    ifelse ( (target != 0) and (target != nobody ) )
      [face target]
      [if (soviet? = false) [facexy 11 0]
        right ((random-float 10) - 5)
        ask turtles in-radius range [
          ifelse ([soviet?] of myself != soviet?) 
            [ask myself [ set target myself ]]
            [if patch-ahead 1 = nobody
              [facexy 11 0]]]]
    if not ( soviet? and (ticks < 16) ) [
    forward speed
    ]
  ]
end

to retreat
  ask turtles[
    facexy min-pxcor min-pycor
    ifelse (soviet? = true)
      [ifelse ( (target != 0) and (target != nobody ) )
        [face target]
        [right ((random-float 10) - 5)
          ask turtles in-radius range [
            if ([soviet?] of myself != soviet?) 
              [ask myself [ set target myself ]]]]]  
      [if( (target = 0) or (target = nobody ) )
        [right ((random-float 10) - 5)
          ask turtles in-radius range [
            if ([soviet?] of myself != soviet?) 
              [ask myself [ set target myself ]]]]]
      forward speed]
end

to renforce
  ask turtles with [soviet?] [
    facexy 11 0
    ifelse (soviet? = false)
      [ifelse ( (target != 0) and (target != nobody ) )
        [face target]
        [right ((random-float 10) - 5)
          ask turtles in-radius range [
            if ([soviet?] of myself != soviet?) 
              [ask myself [ set target myself ]]]]]  
      [if( (target = 0) or (target = nobody ) )
        [right ((random-float 10) - 5)
          ask turtles in-radius range [
            if ([soviet?] of myself != soviet?) 
              [ask myself [ set target myself ]]]]]
      forward speed]
end

to attack
  ask turtles [ 
    if ( target != 0 and target != nobody) [
      create-link-to target [ 
       set color [color] of myself 
       hide-link  
      ]
      if ( target != 0 and target != nobody) [
      ask target [ 
        set tempDef tempDef + (power * ( ( random-normal .5 .25 ) *   [accuracy] of myself ) / ( ( [xcor] of myself - xcor  ) * ( [xcor] of myself - xcor  )  +  ( [ycor] of myself - ycor ) *  ( [ycor] of myself - ycor ))    * ([oDefense] of myself / [defense] of myself / [amount] of myself))
      ]]
      ;if ( random-float 1 > 0.8 ) [ ask target [ set defense (defense - (((random-normal ([power] of myself) 3)) * (([defense] of myself)/[oDefense] of myself)))]]]
      ]]
end

to do
  ask turtles [
          set x floor(  tempDef / defense )
          set amount amount - max fput x [ 0 ]
          set tempDef 0
          if ( amount < 1 ) [die]
  ]
end

to do-plots
  set-current-plot "Forces"
  set-current-plot-pen "Soviet"
  plot (sum [amount] of turtles with [soviet?] )
  set-current-plot-pen "German"
  plot (sum [amount] of turtles with [soviet? = false] )
end

to go
  clear-links
  if XXIV_Activated? and (ticks = 50)
  [drawXXIV]
  ifelse (German_Retreat? and (ticks > 100)) 
  [retreat]
  [advance]
  attack
  if (count turtles with [soviet? = false] = 0) 
    [output-print "Soviet Victory."
    stop]
  if (sum [amount] of turtles at-points [[11 0]] with [soviet? = false] > 0) [
      output-print "German Capture."
      set GermanCapture? true
      renforce
      ;todo if captured, Soviets head toward 11 0
      if (Deathmatch? = false) [stop]]
  if (sum [amount] of turtles at-points [[-16 -16]] with [soviet? = false] > 0) [
      output-print "German Retreat."
      ;todo if captured, Soviets head toward 11 0
      set GermanRetreat? true
      if (Deathmatch? = false) [stop]]
  if (sum [amount] of turtles with [soviet? = true] = 0)
    [if (German_Retreat? = true ) [output-print "German Escape."]
    stop]
  do
  ask links [ hide-link ]
  tick
  do-plots
end
@#$#@#$#@
GRAPHICS-WINDOW
2
10
747
776
-1
-1
15.64
1
10
1
1
1
0
0
0
1
-30
16
-30
16
1
1
1
ticks
30.0

PLOT
752
437
1079
716
Forces
Time
Forces
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"German" 1.0 0 -16777216 true "" ""
"Soviet" 1.0 0 -2674135 true "" ""

BUTTON
748
10
850
72
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
748
73
850
135
Run
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
748
137
888
170
German_Retreat?
German_Retreat?
0
1
-1000

SWITCH
748
172
888
205
XXIV_Activated?
XXIV_Activated?
1
1
-1000

OUTPUT
751
720
1078
776
32

SWITCH
748
207
888
240
Deathmatch?
Deathmatch?
1
1
-1000

SLIDER
1044
17
1077
227
Units_per_Unit_Represented
Units_per_Unit_Represented
1
24
12
1
1
Units
VERTICAL

MONITOR
752
390
848
435
German Losses
(initGermans - sum [amount] of turtles with [soviet? = false] ) 
0
1
11

MONITOR
983
390
1079
435
Russian Losses
( initRussians - sum [amount] of turtles with [soviet?] ) 
0
1
11

MONITOR
984
342
1079
387
Russian Tanks
sum [amount] of tanks with[soviet?]
17
1
11

MONITOR
984
295
1079
340
Russian Foot
sum [amount] of infantries with [soviet?]
17
1
11

MONITOR
752
343
848
388
German Tanks
\nsum [amount] of tanks with[soviet? = false]
17
1
11

MONITOR
752
296
848
341
German Foot
sum [amount] of infantries with [soviet? = false]
17
1
11

@#$#@#$#@
## WHAT IS IT?

This section could give a general understanding of what the model is trying to show or explain.

## HOW IT WORKS

This section could explain what rules the agents use to create the overall behavior of the model.

## HOW TO USE IT

This section could explain how to use the model, including a description of each of the items in the interface tab.

## THINGS TO NOTICE

This section could give some ideas of things for the user to notice while running the model.

## THINGS TO TRY

This section could give some ideas of things for the user to try to do (move sliders, switches, etc.) with the model.

## EXTENDING THE MODEL

This section could give some ideas of things to add or change in the procedures tab to make the model more complicated, detailed, accurate, etc.

## NETLOGO FEATURES

This section could point out any especially interesting or unusual features of NetLogo that the model makes use of, particularly in the Procedures tab.  It might also point out places where workarounds were needed because of missing features.

## RELATED MODELS

This section could give the names of models in the NetLogo Models Library or elsewhere which are of related interest.

## CREDITS AND REFERENCES

This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

airplane 2
true
0
Polygon -7500403 true true 150 26 135 30 120 60 120 90 18 105 15 135 120 150 120 165 135 210 135 225 150 285 165 225 165 210 180 165 180 150 285 135 282 105 180 90 180 60 165 30
Line -7500403 false 120 30 180 30
Polygon -7500403 true true 105 255 120 240 180 240 195 255 180 270 120 270

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

deathstar
true
0
Circle -7500403 true true 0 0 300
Line -16777216 false 150 300 150 120
Circle -16777216 false false 96 6 108
Line -16777216 false 150 105 150 75
Line -16777216 false 150 30 150 45
Line -16777216 false 120 60 135 60
Line -16777216 false 165 60 180 60
Rectangle -2674135 false false 105 150 195 270
Rectangle -2674135 true false 105 150 195 270
Rectangle -16777216 true false 150 150 195 165
Rectangle -16777216 true false 105 255 150 270
Rectangle -16777216 true false 180 210 195 270
Rectangle -16777216 true false 105 150 120 210
Rectangle -16777216 true false 105 210 195 225
Rectangle -16777216 true false 135 150 150 255

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

tank
true
0
Rectangle -7500403 true true 144 0 159 105
Rectangle -6459832 true false 195 45 255 255
Rectangle -16777216 false false 195 45 255 255
Rectangle -6459832 true false 45 45 105 255
Rectangle -16777216 false false 45 45 105 255
Line -16777216 false 45 75 255 75
Line -16777216 false 45 105 255 105
Line -16777216 false 45 60 255 60
Line -16777216 false 45 240 255 240
Line -16777216 false 45 225 255 225
Line -16777216 false 45 195 255 195
Line -16777216 false 45 150 255 150
Polygon -7500403 true true 90 60 60 90 60 240 120 255 180 255 240 240 240 90 210 60
Rectangle -16777216 false false 135 105 165 120
Polygon -16777216 false false 135 120 105 135 101 181 120 225 149 234 180 225 199 182 195 135 165 120
Polygon -16777216 false false 240 90 210 60 211 246 240 240
Polygon -16777216 false false 60 90 90 60 89 246 60 240
Polygon -16777216 false false 89 247 116 254 183 255 211 246 211 237 89 236
Rectangle -16777216 false false 90 60 210 90
Rectangle -16777216 false false 143 0 158 105

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="Deathmatch?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="German_Retreat?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Units_per_Unit_Represented">
      <value value="12"/>
      <value value="8"/>
      <value value="4"/>
      <value value="2"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="XXIV_Activated?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="historical" repetitions="2000" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>(initGermans - count turtles with [soviet? = false] ) * Units_per_Unit_Represented</metric>
    <metric>(initRussians - count turtles with [soviet?] ) * Units_per_Unit_Represented</metric>
    <enumeratedValueSet variable="Deathmatch?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="German_Retreat?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="deathstar?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Units_per_Unit_Represented">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="XXIV_Activated?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="XXIV" repetitions="400" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>( initRussians - sum [amount] of turtles with [soviet?] )</metric>
    <metric>(initGermans - sum [amount] of turtles with [soviet? = false] )</metric>
    <metric>sum [amount] of turtles with [soviet?]</metric>
    <metric>sum [amount] of turtles with [soviet? = false]</metric>
    <metric>GermanCapture?</metric>
    <enumeratedValueSet variable="Deathmatch?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Units_per_Unit_Represented">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="deathstar?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="German_Retreat?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="XXIV_Activated?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Retreat" repetitions="400" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>( initRussians - sum [amount] of turtles with [soviet?] )</metric>
    <metric>(initGermans - sum [amount] of turtles with [soviet? = false] )</metric>
    <metric>sum [amount] of turtles with [soviet?]</metric>
    <metric>sum [amount] of turtles with [soviet? = false]</metric>
    <metric>GermanRetreat?</metric>
    <enumeratedValueSet variable="Deathmatch?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Units_per_Unit_Represented">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="deathstar?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="German_Retreat?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="XXIV_Activated?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0

@#$#@#$#@
0
@#$#@#$#@
