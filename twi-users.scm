; twitter user structure
(define-struct twi-user
    (name screen_name followers_num
     tweets_num followers tweets))

; myself
(define me (make-twi-user
        "shaman" "shaman_sir"
        615 478 (list) (list)))

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
        (translate (vector 0 0 1))
        (scale 0.2)
        (draw-sphere))
    ; body
    (with-state
        (colour (vector 1 1 0))
        (translate (vector 0 -.4 0))
        (scale (vector 1.2 1.6 1))
        (draw-cube))
)

; every frame
(every-frame
    (draw-user me))