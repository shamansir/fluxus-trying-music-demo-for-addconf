(clear)

(define font "./DroidSans.ttf")

(start-audio "system:playback_3" 1024 44100)
(gain .01)

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
(define (draw-user _user x-pos)
    (let ((h (* .003 (twi-user-followers-num _user)))
          (w (* .004 (twi-user-tweets-num _user))))

    ; position
    (translate (vector x-pos 0 0))
    ; head
    (with-state
        (colour (vector (gh 0) 0 0))
        (translate (vector 0 (- h .7) 0))
        (scale h)
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
        (colour (vector (gh 1) (gh 1) 0))
        (translate (vector 0 -.4 0))
        (scale (vector h w 1))
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
        (translate (vector (+ x-pos -1.3) -3.2 0))
        (scale .15))

))

; every frame
(every-frame
    (draw-user me (sin (time))))

