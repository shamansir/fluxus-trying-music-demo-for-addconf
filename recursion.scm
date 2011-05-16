(define (draw-row count)
     (cond
         ((not (zero? count))
               (draw-cube)
               (translate (vector 1.1 0 0))
               (draw-row (- count 1)))))

(every-frame (draw-row 10))
