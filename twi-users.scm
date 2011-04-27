(define user '("shaman" 220 340))

(define (draw-user user)
    (colour (vector 1 0 0))
    (draw-sphere)) 

(every-frame
    (draw-user user))