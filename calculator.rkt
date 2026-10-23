
#lang racket

;; basic prefix calculator

(define (skip-space chars)
  (cond
    [(null? chars) chars]
    [(char-whitespace? (car chars))
     (skip-space (cdr chars))]
    [else chars]))

;; returns the number and the rest of the expression
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
      [(null? chars) (error "Invalid Expression")]
      [(char=? (car chars) #\+)
       (let* ([a (eval-expr (cdr chars))]
              [b (eval-expr (cadr a))])
         (list (+ (car a) (car b)) (cadr b)))]
      [(char=? (car chars) #\*)
       (let* ([a (eval-expr (cdr chars))]
              [b (eval-expr (cadr a))])
         (list (* (car a) (car b)) (cadr b)))]
      [(char=? (car chars) #\-)
       (let ([a (eval-expr (cdr chars))])
         (list (- (car a)) (cadr a)))]
      [(char-numeric? (car chars))
       (read-number chars)]
      [else (error "Invalid Expression")])))

;; quick tests
(displayln (car (eval-expr (string->list "+ 2 3"))))
(displayln (car (eval-expr (string->list "* + 2 3 4"))))
(displayln (car (eval-expr (string->list "- 5"))))
