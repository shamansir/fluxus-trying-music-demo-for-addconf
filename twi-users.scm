(clear)

(define font "./DroidSans.ttf")

; twitter user structure
(define-struct twi-user
    (name screen-name followers-num
     tweets-num followers tweets
     label))

; quick text object
(define (qto _text)
    (build-extruded-type font _text .2))

; myself
(define me (make-twi-user
        "shaman" "shaman_sir"
        615 478 (list) (list)
        (qto "shaman")))

; draw user function
(define (draw-user _user)
    ; head
    (with-state
        (colour (vector 1 0 0))
        (translate (vector 0 1 0))
        (scale 0.6)
        (draw-sphere)
        ; eyes
        (colour (vector 1 1 1))
        (scale 0.2)
        (translate (vector 2 .2 6))
        (draw-sphere)
        (translate (vector -4 0 0))
        (draw-sphere))
    ; body
    (with-state
        (colour (vector 1 1 0))
        (translate (vector 0 -.4 0))
        (scale (vector 1.2 1.6 1))
        (draw-cube))
    ; arms
    (with-state
        (colour (vector 0 .5 0))
        (translate (vector -.9 -.2 0))
        (scale (vector .3 1.2 .5))
        (draw-cube))
    (with-state
        (colour (vector 0 .5 0))
        (translate (vector .9 -.2 0))
        (scale (vector .3 1.2 .5))
        (draw-cube))
    ; legs
    (with-state
        (colour (vector 0 0 .6))
        (translate (vector -.2 -1.8 0))
        (scale (vector .3 1.2 .5))
        (draw-cube))
    (with-state
        (colour (vector 0 0 .6))
        (translate (vector .2 -1.8 0))
        (scale (vector .3 1.2 .5))
        (draw-cube))
    ; name
    (with-primitive (twi-user-label _user)
        (identity)
        (translate (vector -1.3 -3.2 0))
        (scale .15))
)

; every frame
(every-frame
    (draw-user me))

