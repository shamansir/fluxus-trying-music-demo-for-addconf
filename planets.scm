(clear)

; CONSTANTS

(define astro-unit 11.74) ; distance from sun center to earth center
(define diameter-factor 0.3) ; diameter of earth
; in fact, astro-unit =~ diameter-factor * 11740, sun == 109 earths
; so when astro-unit == 11.74, diameter-factor = 0.01
; to demonstrate: a-u = 11.74 d-f = 0.3, sun = 10.9
(define year 20000) ; length of earth year, in msec

(define lfont "DroidSans.ttf")
(define 2pi (* 3.1415 2))

; STRUCTURES

(define-struct star (name diameter color))
(define-struct planet (p
                       label ; text object
                       diameter ; equatorial diameter
                       distance ; orbital radius
                       period ; orbital period
                       moons ; number of moons
                       color))
(define-struct star-system (star planets))

; HELPERS

; get current planet angle based on time (msec) and orbital period
; ang == (* (/ elapsed (* period year)) 2pi)
(define (curang _period)
    (* (/ (* (time) 1000) (* _period year)) 2pi))

; quick translate vector
(define (qtv _dist _period)
     (let ((_ang (curang _period)))
         (vector (* (* (cos _ang) _dist) astro-unit)
                 (* (* (sin _ang) _dist) astro-unit)
                 0)))

; quick scale vector
(define (qsv _diam)
    (vector (* _diam diameter-factor)
            (* _diam diameter-factor)
            (* _diam diameter-factor)))

; quick text object
(define (qto _text)
    (build-extruded-type lfont _text 0.2))

(define (build-orbit _dist)
    (build-torus 0.01 ; thickness
                 (* _dist astro-unit) ; radius
                 32 ; segments
                 32))

; PLANETS

(define sun (make-star "sun" 10.9 (vector 1 1 0)))

(define solar-system (make-star-system sun
    (list
                    ; see /wikipedia/Planet
                    ; par name             diamtr distn period mn color  r   g   b
         (make-planet sun (qto "mercury")  0.382  0.39   0.24 0  (vector 0.6 0.6 0.6))
         (make-planet sun (qto "venus")    0.95   0.72   0.62 0  (vector 0.8 0.8 0.4))
         (make-planet sun (qto "earth")    1.0    1.0    1.0  1  (vector 0.2 0.4 0.6))
         (make-planet sun (qto "mars")     0.11   1.52   1.88 2  (vector 1.0 0.1 0.0))
         (make-planet sun (qto "jupiter") 11.209  5.2   11.86 49 (vector 1.0 0.4 0.2))
         (make-planet sun (qto "saturn")   9.449  9.54  29.46 52 (vector 1.0 0.8 0.2))
         (make-planet sun (qto "uranus")   4.007 19.22  84.01 27 (vector 0.2 0.3 0.5))
         (make-planet sun (qto "neptune")  3.883 30.06 164.8  13 (vector 0.2 0.4 0.7)))))

(for-each (lambda (_planet)
                  (build-orbit (planet-distance _planet)))
          (star-system-planets solar-system))

; DRAWING

(define (draw-star _star)
    (with-state
        (colour (star-color _star))
        (translate (vector 0 0 0))
        (scale (qsv (star-diameter _star)))
        (draw-sphere)))

(define (draw-planet _planet)
     (let ((ts-v (qtv (planet-distance _planet) (planet-period _planet)))
           (sc-v (qsv (planet-diameter _planet))))
          ; planet
          (with-state
              (colour (planet-color _planet))
              (translate ts-v)
              (scale sc-v)
              (draw-sphere))
          ; label
          (with-primitive (planet-label _planet)
              (identity)
              (colour (planet-color _planet))
              (translate ts-v)
              (scale (vmul sc-v 2)))))

(define (render)
    (draw-star (star-system-star solar-system))
    (for-each draw-planet (star-system-planets solar-system)))

(every-frame (render))

