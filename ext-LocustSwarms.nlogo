breed [scouts scout]

breed [particles particle]

scouts-own 
[
  start-point
  steps-since-bestval-update   ; steps since optima in search path determined
]

patches-own
[
  val  ; each patch has a "fitness" value associated with it
       ; the goal of the particle swarm is to find the patch with the best fitness value
]

particles-own
[
  subgroup            ; swarms corrsponding scout
  loi-x               ; location of interest x coord
  loi-y               
  time-at-loi         ; time spent around location of interest
  best-lois-x         ; list of all optima searched
  best-lois-y
]

turtles-own
[
  vx                  ; velocity in the x direction
  vy                  ; velocity in the y direction
  personal-best-val   ; best value I've run across so far
  personal-best-x     ; x coordinate of that best value
  personal-best-y     ; x coordinate of that best value
]

globals
[
  global-best-x    ; x coordinate of best value found by the swarm
  global-best-y    ; y coordinate of best value found by the swarm
  global-best-val  ; highest value found by the swarm
  true-best-patch  ; patch with the best value
  scout-heading-change  ; for scout pathing
  counter
  it-counter
  l-sg             ; scouts that have swarms assigned to them
]

to setup-search-landscape
  ifelse test-function = "random"
  [ random-landscape ]
  [ ifelse test-function = "sphere"
    [ sphere-landscape ]
    [ ifelse test-function = "rosenbrock"
      [ rosenbrock-landscape ]
      [ ifelse test-function = "beale"
        [ beale-landscape ]
        [ ifelse test-function = "booth"
          [ booth-landscape ]
          [ ifelse test-function = "ackley"
            [ ackley-landscape ]
            [ ifelse test-function = "fourmodal"
              [ fourmodal-landscape ]
              []
            ]
          ]
        ]
      ]
    ]
  ]
  color-landscape
end

to color-landscape
  let t1 0.1 
  let t2 0.2
  let t3 0.3
  let t4 0.4
  let t5 0.5
  let t6 0.6
  let t7 0.7
  let t8 0.8
  let t9 0.9
 
  ; scale color patches for greater detail
  ask patches
  [
    ifelse val <= t1
    [ set pcolor scale-color red val 0.0 t1 ]
    [ ifelse val <= t2
      [ set pcolor scale-color orange val t1 t2 ]
      [ ifelse val <= t3
        [ set pcolor scale-color yellow val t2 t3 ]
        [ ifelse val <= t4
          [ set pcolor scale-color lime val t3 t4 ]
          [ ifelse val <= t5
            [ set pcolor scale-color cyan val t4 t5 ]
            [ ifelse val <= t6
              [ set pcolor scale-color blue val t5 t6 ]
              [ ifelse val <= t7
                [ set pcolor scale-color violet val t6 t7 ]
                [ ifelse val <= t8
                  [ set pcolor scale-color magenta val t7 t8 ]
                  [ ifelse val <= t9
                    [ set pcolor scale-color gray val t8 1.0];t9 ]
                    [ set pcolor scale-color gray val t8 1.0];set pcolor scale-color pink val t9 1.0 ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
end

to random-landscape
  ;; make a landscape with hills and valleys
  ask patches [ set val random-float 1.0 ]
  ;; slightly smooth out the landscape
  repeat landscape-smoothness [ diffuse val 1 ]
  let min-val min [val] of patches
  let max-val max [val] of patches
  ; normalize the values to be between 0 and 1
  ask patches [ set val 0.99999 * (val - min-val) / (max-val - min-val)  ]

  ; make it so that there is only one global optimum, and its value is 1.0
  ask max-one-of patches [val]
  [
    set val 1.0
    set true-best-patch self
  ]

end

to sphere-landscape
  ask patches
  [
    set val (pxcor ^ 2) + (pycor ^ 2)
  ]

  let min-val min [val] of patches
  let max-val max [val] of patches
  ; normalize the values to be between 0 and 1
  ask patches [ set val 1 - (0.99999 * (val - min-val) / (max-val - min-val))  ]

  ; make it so that there is only one global optimum, and its value is 1.0
  ask max-one-of patches [val]
  [
    set val 1.0
    set true-best-patch self
  ]
  
end

to rosenbrock-landscape
  let tx 0
  let ty 0
  let nmr 0.005
  
  ask patches
  [
    set tx pxcor * nmr
    set ty pycor * nmr
    set val 100 * (ty - tx ^ 2) ^ 2 + (tx - 1) ^ 2
  ]

  let min-val min [val] of patches
  let max-val max [val] of patches
  ; normalize the values to be between 0 and 1
  ask patches [ set val 1 - (0.99999 * (val - min-val) / (max-val - min-val))  ]

  ; make it so that there is only one global optimum, and its value is 1.0
  ask max-one-of patches [val]
  [
    set val 1.0
    set true-best-patch self
  ]
    
end

to beale-landscape
  let tx 0
  let ty 0
  let nmr 4.5 / 100
  
  ask patches
  [
    set tx pxcor * nmr
    set ty pycor * nmr
    set val (1.5 - tx + tx * ty) ^ 2 + (2.25 - tx + tx * ty ^ 2) ^ 2 + (2.625 - tx + tx * ty ^ 3) ^ 2 
  ]

  let min-val min [val] of patches
  let max-val max [val] of patches
  ; normalize the values to be between 0 and 1
  ask patches [ set val 1 - (0.99999 * (val - min-val) / (max-val - min-val))  ]

  ; make it so that there is only one global optimum, and its value is 1.0
  ask max-one-of patches [val]
  [
    set val 1.0
    set true-best-patch self
  ]
      
end

to booth-landscape
  let tx 0
  let ty 0
  let nmr 0.1
  
  ask patches
  [
    set tx pxcor * nmr
    set ty pycor * nmr
    set val (tx + 2 * ty - 7) ^ 2 + (2 * tx + ty - 5) ^ 2
  ]

  let min-val min [val] of patches
  let max-val max [val] of patches
  ; normalize the values to be between 0 and 1
  ask patches [ set val 1 - (0.99999 * (val - min-val) / (max-val - min-val))  ]

  ; make it so that there is only one global optimum, and its value is 1.0
  ask max-one-of patches [val]
  [
    set val 1.0
    set true-best-patch self
  ]  
end

to ackley-landscape
  let tx 0
  let ty 0
  let nmr 0.05
  
  ask patches
  [
    set tx pxcor * nmr
    set ty pycor * nmr
    set val (-20) * exp ((-0.2) * sqrt (0.5 * (tx ^ 2 + ty ^ 2))) - exp (0.5 * (cos (2 * pi * tx) + cos (2 * pi * ty))) + e + 20
  ]

  let min-val min [val] of patches
  let max-val max [val] of patches
  ; normalize the values to be between 0 and 1
  ask patches [ set val 1 - (0.99999 * (val - min-val) / (max-val - min-val))  ]

  ; make it so that there is only one global optimum, and its value is 1.0
  ask max-one-of patches [val]
  [
    set val 1.0
    set true-best-patch self
  ]
end

to fourmodal-landscape
  ask patches 
  [
    ifelse pxcor >= 0
    [ ifelse pxcor >= 100
      [ set val (200 - pxcor) ]
      [ set val pxcor ]
    ]
    [ ifelse pxcor >= -100
      [ set val (- pxcor) ]
      [ set val (200 + pxcor) ]
    ]
    ifelse pycor >= 0
    [ ifelse pycor >= 100
      [ set val val + (200 - pycor) ]
      [ set val val + pycor ]
    ]
    [ ifelse pycor >= -100
      [ set val val + (- pycor) ]
      [ set val val + (200 + pycor) ]
    ]    
  ]
  ask patch 50 50 [ set val 1.0 ]
  ask patch -50 -50 [set val 0.99999 ]

  let min-val min [val] of patches
  let max-val max [val] of patches
  ; normalize the values to be between 0 and 1
  ask patches [ set val 0.99999 * (val - min-val) / (max-val - min-val)  ]

  ; make it so that there is only one global optimum, and its value is 1.0
  ask max-one-of patches [val]
  [
    set val 1.0
    set true-best-patch self
  ]

end

to setup-pso
  clear-all
  setup-search-landscape

  ; create particles and place them randomly in the world
  create-turtles population-size
  [
    setxy random-xcor random-ycor
    ; give the particles normally distributed random initial velocities for both x and y directions
    set vx random-normal 0 1
    set vy random-normal 0 1
    ; the starting spot is the particle's current best location.
    set personal-best-val val
    set personal-best-x xcor
    set personal-best-y ycor

    ; choose a random basic NetLogo color, but not gray
    set color one-of (remove-item 0 base-colors)
    ; make the particles a little more visible
    set size 4
  ]
  update-highlight
  reset-ticks
end

to go-pso
  ask turtles [
    ; should the particles draw trails, or not?
    ifelse trails-mode = "None" [ pen-up ] [ pen-down ]

    ; update the "personal best" location for each particle,
    ; if they've found a new value better than their previous "personal best"
    if val > personal-best-val
    [
      set personal-best-val val
      set personal-best-x xcor
      set personal-best-y ycor
    ]
  ]

  ; update the "global best" location for the swarm, if necessary.
  ask max-one-of turtles [personal-best-val]
  [
    if global-best-val < personal-best-val
    [
      set global-best-val personal-best-val
      set global-best-x personal-best-x
      set global-best-y personal-best-y
    ]
  ]
  if global-best-val = [val] of true-best-patch
    [ stop ]

  if (trails-mode != "Traces")
    [ clear-drawing ]

  ask turtles
  [
    set vx particle-inertia * vx
    set vy particle-inertia * vy

    ; Technical note:
    ;   In the canonical PSO, the "(1 - particle-inertia)" term isn't present in the
    ;   mathematical expressions below.  It was added because it allows the
    ;   "particle-inertia" slider to vary particles motion on the the full spectrum
    ;   from moving in a straight line (1.0) to always moving towards the "best" spots
    ;   and ignoring its previous velocity (0.0).

    ; change my velocity by being attracted to the "personal best" value I've found so far
    facexy personal-best-x personal-best-y
    let dist distancexy personal-best-x personal-best-y
    set vx vx + (1 - particle-inertia) * attraction-to-personal-best * (random-float 1.0) * dist * dx
    set vy vy + (1 - particle-inertia) * attraction-to-personal-best * (random-float 1.0) * dist * dy

    ; change my velocity by being attracted to the "global best" value anyone has found so far
    facexy global-best-x global-best-y
    set dist distancexy global-best-x global-best-y
    set vx vx + (1 - particle-inertia) * attraction-to-global-best * (random-float 1.0) * dist * dx
    set vy vy + (1 - particle-inertia) * attraction-to-global-best * (random-float 1.0) * dist * dy

    ; speed limits are particularly necessary because we are dealing with a toroidal (wrapping) world,
    ; which means that particles can start warping around the world at ridiculous speeds
    if (vx > particle-speed-limit) [ set vx particle-speed-limit ]
    if (vx < 0 - particle-speed-limit) [ set vx 0 - particle-speed-limit ]
    if (vy > particle-speed-limit) [ set vy particle-speed-limit ]
    if (vy < 0 - particle-speed-limit) [ set vy 0 - particle-speed-limit ]

    ; face in the direction of my velocity
    facexy (xcor + vx) (ycor + vy)
    ; and move forward by the magnitude of my velocity
    forward sqrt (vx * vx + vy * vy)

  ]
  update-highlight
  tick
end

to setup
  clear-all
  setup-search-landscape

  set it-counter 10
  set scout-heading-change 90 / it-counter
  set counter 0
  
  let r-sx (random 201) - 100
  let r-sy (random 201) - 100

  ; create scouts and place them at random starting position
  create-scouts num-scouts
  [
    setxy r-sx r-sy
    
    set steps-since-bestval-update 0
    set personal-best-val val
    set personal-best-x xcor
    set personal-best-y ycor
    
    set color black
    ; make the particles a little more visible
    set size 4    
  ]
  

  ; iterate forward through scouts, setting
  ; initial headings as some portion of 360 based on num-scouts
  ; scouts created first to make use of who numbers starting at 0
  foreach sort scouts 
  [
    ask ?
    [ 
      set heading (360 / num-scouts) * who
      set vx scouting-speed
      set vy 1
    ]  
  ]
  
  ; create particles and place them randomly in the world
  create-particles population-size
  [
    setxy random-xcor random-ycor
    ; give the particles normally distributed random initial velocities for both x and y directions
    set vx random-normal 0 1
    set vy random-normal 0 1
    ; the starting spot is the particle's current best location.
    set personal-best-val val
    set personal-best-x xcor
    set personal-best-y ycor
    
    set loi-x (list)
    set loi-y (list)
    set best-lois-x (list)
    set best-lois-y (list)
    set time-at-loi 0
    set subgroup random num-scouts

    
    ; choose a random basic NetLogo color, but not gray
    set color one-of (remove-item 0 base-colors)
    ; make the particles a little more visible
    set size 4
  ]

  ; determine which scouts have swarms assigned to them
  set l-sg (list)
  ask scouts
  [
    if any? particles with [subgroup = [who] of myself]
    [
      set l-sg lput who l-sg
    ]
  ]
  
  update-highlight
  reset-ticks
end

to go
  
  ask scouts [
    ifelse trails-mode = "None" [ pen-up ] [ pen-down ]  
    
    if val > global-best-val
    [
      set global-best-val val
      set global-best-x xcor
      set global-best-y ycor
    ]
    
    if steps-since-bestval-update > 4 [
      ; personal-best-val decays
      set personal-best-val personal-best-val * 0.99
    ]    

    ifelse val > personal-best-val ;+ 0.001
    [
      set personal-best-val val
      set personal-best-x xcor
      set personal-best-y ycor
      ask patch-here [
        set pcolor red 
      ]
      set steps-since-bestval-update 1
    ]
    [ set steps-since-bestval-update steps-since-bestval-update + 1 ]

    if steps-since-bestval-update = 4
    [
      ask patch personal-best-x personal-best-y [
        set pcolor white
      ] 
      
      if any? particles with [subgroup = [who] of myself]
      [
        ; relay optimum to swarm
        ask one-of particles with [subgroup = [who] of myself]
        [
          set loi-x lput [personal-best-x] of myself loi-x
          set loi-y lput [personal-best-y] of myself loi-y
          sort-locations
          
          ask other particles with [subgroup = [subgroup] of myself]
          [
            if not empty? loi-x and first loi-x != first [loi-x] of myself 
            [ 
              set time-at-loi 0 
              set personal-best-val 0
            ]
            set loi-x [loi-x] of myself
            set loi-y [loi-y] of myself
          ]
        ]        
      ]
    ]

    
    ; and move forward by the magnitude of my velocity
    forward sqrt (vx * vx + vy * vy)
    
    ; rotate heading to right
    set heading heading + scout-heading-change
    if heading >= 360 [ set heading heading - 360 ]
  ]
  ; for pathing purposes
  set counter counter + 1
  if counter = it-counter [
    set counter 0
    ifelse it-counter < 20 
    [ set it-counter it-counter * 2 ]
    [ set it-counter it-counter + 20 ]
    set scout-heading-change 90 / it-counter
  ]
  
  
  
  
  ask particles [
    ; should the particles draw trails, or not?
    ifelse trails-mode = "None" [ pen-up ] [ pen-down ]

    ; update the "personal best" location for each particle,
    ; if they've found a new value better than their previous "personal best"
    if val > personal-best-val
    [
      set personal-best-val val
      set personal-best-x xcor
      set personal-best-y ycor
    ]
  ]

  ; update the "global best" location for the swarm, if necessary.
  ask max-one-of particles [personal-best-val]
  [
    if global-best-val < personal-best-val
    [
      set global-best-val personal-best-val
      set global-best-x personal-best-x
      set global-best-y personal-best-y
    ]
  ]
  if global-best-val = [val] of true-best-patch
    [ stop ]

  if (trails-mode != "Traces")
    [ clear-drawing ]

  ask particles
  [
    set vx particle-inertia * vx
    set vy particle-inertia * vy

    ; Technical note:
    ;   In the canonical PSO, the "(1 - particle-inertia)" term isn't present in the
    ;   mathematical expressions below.  It was added because it allows the
    ;   "particle-inertia" slider to vary particles motion on the the full spectrum
    ;   from moving in a straight line (1.0) to always moving towards the "best" spots
    ;   and ignoring its previous velocity (0.0).

    ; change my velocity by being attracted to the "global best" value anyone has found so far
    if not empty? loi-x
    [
      facexy first loi-x first loi-y
      let dist distancexy first loi-x first loi-y
      set vx vx + (1 - particle-inertia) * (random-float 1.0) * dist * dx
      set vy vy + (1 - particle-inertia) * (random-float 1.0) * dist * dy
      
      if time-at-loi != 0 and dist < 15 [ set time-at-loi time-at-loi + 1 ]
      if dist < 5 and time-at-loi = 0 [ set time-at-loi time-at-loi + 1 ]
    ]


    

    ; speed limits are particularly necessary because we are dealing with a toroidal (wrapping) world,
    ; which means that particles can start warping around the world at ridiculous speeds
    if (vx > particle-speed-limit) [ set vx particle-speed-limit ]
    if (vx < 0 - particle-speed-limit) [ set vx 0 - particle-speed-limit ]
    if (vy > particle-speed-limit) [ set vy particle-speed-limit ]
    if (vy < 0 - particle-speed-limit) [ set vy 0 - particle-speed-limit ]

    ; face in the direction of my velocity
    facexy (xcor + vx) (ycor + vy)
    ; and move forward by the magnitude of my velocity
    forward sqrt (vx * vx + vy * vy)

  ]
  

  ; for each swarm
  foreach l-sg
  [
    if any? particles with [subgroup = ?]
    [
      if [time-at-loi] of min-one-of particles with [subgroup = ?] [time-at-loi] = 25
      [
        ; time to fan out and re-converge
        let c 0
        let tc count particles with [subgroup = ?]
        foreach sort particles with [subgroup = ?]
        [
          ask ?
          [
            set heading 0 + (360 / tc) * c * ((random-float 0.2) + 0.9)
            set time-at-loi time-at-loi + 1            
            set vx particle-speed-limit * cos ((- heading) + 90)
            set vy particle-speed-limit * sin ((- heading) + 90)
            forward sqrt (vx * vx + vy * vy)
          ]
          set c c + 1

        ]
      ]
      
      if [time-at-loi] of min-one-of particles with [subgroup = ?] [time-at-loi] > 50
      [
        ; time to move onto the next location
        
        ask max-one-of particles with [subgroup = ?] [personal-best-val]
        [
          ifelse length loi-x > 1[
            ; is the best location found during convergence worth looking at
            ifelse personal-best-val > [val] of patch first but-first loi-x first but-first loi-y and
            (sqrt ((personal-best-x - first loi-x) ^ 2 + (personal-best-y - first loi-y) ^ 2)) > 2 and
            already-used-point? = 0
            [
              set best-lois-x lput personal-best-x best-lois-x
              set best-lois-y lput personal-best-y best-lois-y
              set loi-x lput personal-best-x but-first loi-x
              set loi-y lput personal-best-y but-first loi-y
              
              sort-locations
              
              ask other particles with [subgroup = ?]
              [
                set loi-x [loi-x] of myself
                set loi-y [loi-y] of myself
                set best-lois-x [best-lois-x] of myself
                set best-lois-y [best-lois-y] of myself
              ]
            ]
            [
              set loi-x but-first loi-x
              set loi-y but-first loi-y
              ask other particles with [subgroup = ?]
              [
                set loi-x but-first loi-x
                set loi-y but-first loi-y
              ]
            ]
          ]
          [   
            set best-lois-x lput personal-best-x best-lois-x
            set best-lois-y lput personal-best-y best-lois-y
            
            ifelse empty? loi-x
            [ 
              set loi-x lput personal-best-x loi-x
              set loi-y lput personal-best-y loi-y
            ]
            [
              set loi-x lput personal-best-x but-first loi-x
              set loi-y lput personal-best-y but-first loi-y
            ]
            sort-locations
            
            ask other particles with [subgroup = ?]
            [
              set loi-x [loi-x] of myself
              set loi-y [loi-y] of myself
              set best-lois-x [best-lois-x] of myself
              set best-lois-y [best-lois-y] of myself
            ]
          ]
        ]
        
        ask particles with [subgroup = ?]
        [
          set time-at-loi 0
          set personal-best-val 0
        ]
      ]
    ]
  ]
  
  update-highlight
  tick
end

; called by particle
to sort-locations
  let temp-loi-x loi-x
  let temp-loi-y loi-y
        
  let temp-loi-xy sort-lois temp-loi-x temp-loi-y
   
  set temp-loi-x (list)
  set temp-loi-y (list)
        
  let temp-xy 0
    
  foreach temp-loi-xy
  [
    set temp-xy ?
    set temp-loi-x fput item 0 temp-xy temp-loi-x
    set temp-loi-y fput item 1 temp-xy temp-loi-y
  ]  
  
  set loi-x temp-loi-x
  set loi-y temp-loi-y
end

to-report sort-lois [lx ly]
  let lxy (list)
  let c length lx
  
  while [c > 0]
  [
    set c c - 1
    set lxy fput (list item c lx item c ly) lxy
  ]
  
  report sort-by [[val] of patch item 0 ?2 item 1 ?2 > [val] of patch item 0 ?1 item 1 ?1] lxy
end

; has area already been searched
to-report already-used-point?
  let c length best-lois-x
  while [c > 0]
  [
    set c c - 1
    if item c best-lois-x = personal-best-x and item c best-lois-y = personal-best-y
    [ report 1 ]
  ]
  report 0
end

to update-highlight
  ifelse highlight-mode = "Best found"
  [ watch patch global-best-x global-best-y ]
  [
    ifelse highlight-mode = "True best"
    [  watch true-best-patch ]
    [  reset-perspective ]
  ]
end


; Copyright 2008 Uri Wilensky.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
265
10
676
442
200
200
1.0
1
10
1
1
1
0
1
1
1
-200
200
-200
200
1
1
1
ticks
30.0

BUTTON
165
220
245
253
NIL
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

SLIDER
10
50
225
83
population-size
population-size
1
100
25
1
1
NIL
HORIZONTAL

SLIDER
700
20
915
53
attraction-to-personal-best
attraction-to-personal-best
0
2
0
0.1
1
NIL
HORIZONTAL

SLIDER
700
60
915
93
attraction-to-global-best
attraction-to-global-best
0
2
1
0.1
1
NIL
HORIZONTAL

SLIDER
700
100
855
133
particle-inertia
particle-inertia
0
1.0
0.9
0.01
1
NIL
HORIZONTAL

CHOOSER
130
395
225
440
trails-mode
trails-mode
"None" "Tails" "Traces"
2

SLIDER
700
140
855
173
particle-speed-limit
particle-speed-limit
1
20
10
1
1
NIL
HORIZONTAL

CHOOSER
20
395
125
440
highlight-mode
highlight-mode
"None" "Best found" "True best"
2

MONITOR
65
305
177
350
best-value-found
global-best-val
4
1
11

SLIDER
10
10
225
43
landscape-smoothness
landscape-smoothness
0
100
3
1
1
NIL
HORIZONTAL

TEXTBOX
50
370
215
388
Visualization Options
14
0.0
1

SLIDER
5
95
140
128
num-scouts
num-scouts
2
50
3
1
1
NIL
HORIZONTAL

CHOOSER
705
210
843
255
test-function
test-function
"random" "sphere" "rosenbrock" "beale" "booth" "ackley" "fourmodal"
6

BUTTON
40
215
127
248
NIL
setup-pso
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
50
260
117
293
NIL
go-pso
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
170
260
233
293
NIL
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

SLIDER
15
145
187
178
scouting-speed
scouting-speed
1
25
15
1
1
NIL
HORIZONTAL

@#$#@#$#@
## How To Use

Setup-PSO will setup the basic PSO algorithm on the search space, this MUST BE run using the Go-PSO button. Likewise, Setup will setup the extended Locust Swarm algorithm and MUST BE run using the Go button. 

The attraction sliders only work for the PSO algorithm.

The search space can be changed using the test function chooser, four-modal is the function designed specifically for testing this algorithm. 

Landscape smoothness slider applies only to the random landscape. All other landscapes are setup automatically on the given world dimensions. 

## COPYRIGHT AND LICENSE

Copyright 2008 Uri Wilensky.

![CC BY-NC-SA 3.0](http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

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
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment1" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;rosenbrock&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment2-pso" repetitions="100" runMetricsEveryStep="false">
    <setup>setup-pso</setup>
    <go>go-pso</go>
    <timeLimit steps="1000"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;rosenbrock&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-2" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment2-pso-2" repetitions="100" runMetricsEveryStep="false">
    <setup>setup-pso</setup>
    <go>go-pso</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-s-3" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-s-1" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-s-7" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-s-15" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-n-25" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-n-50" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-n-75" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-n-115" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-st-1" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scouting-speed">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-st-3" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scouting-speed">
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-st-7" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scouting-speed">
      <value value="7"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment1-st-15" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>global-best-val</metric>
    <enumeratedValueSet variable="test-function">
      <value value="&quot;fourmodal&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-scouts">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scouting-speed">
      <value value="15"/>
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
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
1
@#$#@#$#@
