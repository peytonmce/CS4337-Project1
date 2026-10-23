
#lang racket

;; basic prefix calculator

(define (skip-space chars)
  (cond
    [(null? chars) chars]
    [(char-whitespace? (car chars))
     (skip-space (cdr chars))]
    [else chars]))

(define (read-number chars)
  (let loop ([left chars] [digits '()])
    (if (and (pair? left) (char-numeric? (car left)))
        (loop (cdr left) (append digits (list (car left))))
        (if (null? digits)
            (error "Invalid Expression")
            (list (string->number (list->string digits)) left)))))

(define (eval-expr chars)
  (let ([chars (skip-space chars)])
    (cond
      [(null? chars)
       (error "Invalid Expression")]

      [(char=? (car chars) #\+)
       (let* ([a (eval-expr (cdr chars))]
              [b (eval-expr (cadr a))])
         (list (+ (car a) (car b)) (cadr b)))]

      [(char=? (car chars) #\*)
       (let* ([a (eval-expr (cdr chars))]
              [b (eval-expr (cadr a))])
         (list (* (car a) (car b)) (cadr b)))]

      [(char=? (car chars) #\/)
       (let* ([a (eval-expr (cdr chars))]
              [b (eval-expr (cadr a))]
              [x (car a)]
              [y (car b)])
         (if (zero? y)
             (error "Invalid Expression")
             (list (quotient x y) (cadr b))))]

      [(char=? (car chars) #\-)
       (let ([a (eval-expr (cdr chars))])
         (list (- (car a)) (cadr a)))]

      [(char-numeric? (car chars))
       (read-number chars)]

      [else
       (error "Invalid Expression")])))

;; evaluate an expression and make sure nothing is left over
(define (eval-complete chars)
  (let* ([answer (eval-expr chars)]
         [remaining (skip-space (cadr answer))])
    (if (null? remaining)
        (car answer)
        (error "Invalid Expression"))))

;; quick tests
(displayln (eval-complete (string->list "+ 2 3")))
(displayln (eval-complete (string->list "* + 2 3 4")))
(displayln (eval-complete (string->list "- 5")))
(displayln (eval-complete (string->list "/ 8 2")))

;; test that extra input is rejected
(displayln
 (with-handlers ([exn:fail? (lambda (_) "Rejected invalid expression")])
   (eval-complete (string->list "+ 2 3 xyz"))))
