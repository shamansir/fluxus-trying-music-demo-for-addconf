(clear)

(define font "./DroidSans.ttf")

(start-audio "system:playback_3" 1024 44100)
(gain .01)

(load "source.scm")

; twitter user structure
(define-struct twi-user
    (name screen-name followers-num
     tweets-num followers tweets
     label))

(define twi-users (list))

; quick text object
(define (qto _text)
    (build-extruded-type font _text .2))

; load all users
(define twi-users (build-list (length twit-data)
    (lambda (pos)
       (let ((ulist (list-ref twit-data pos)))
            (make-twi-user
                   (list-ref ulist 0)  ; name
                   (list-ref ulist 1)  ; screen-name
                   (list-ref ulist 4)  ; followers-num
                   (list-ref ulist 3)  ; tweets-num
                   (list)              ; followers
                   (list-tail ulist 4) ; tweets
                   (qto (list-ref ulist 0))))))) ; label

; draw user function
(define (draw-user _user x-pos)
    (let ((h (* .001 (twi-user-followers-num _user)))
          (w (* .003 (twi-user-tweets-num _user))))

    ; position
    (translate (vector x-pos 0 0))
    ; head
    (with-state
        (colour (vector (gh 0) 0 0))
        (translate (vector 0 (- h .7) 0))
        (scale (* h .4))
        (draw-sphere)
        ; eyes
        (colour (vector 1 1 1))
        (scale .2)
        (translate (vector 2 .2 6))
        (draw-sphere)
        (translate (vector -4 0 0))
        (draw-sphere))
    ; body
    (with-state
        (colour (vector (gh 1) (gh 1) 0))
        (translate (vector 0 -.4 0))
        (scale (vector w h 1))
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
        (translate (vector (* 3 x-pos) -3.5 0))
        (scale .15))

))

; every frame
(every-frame
        (for-each (lambda (user)
              (draw-user user (sin (time))))
         twi-users))

