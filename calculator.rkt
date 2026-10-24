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

(define (read-history chars history)
  (let loop ([left (cdr chars)] [digits '()])
    (if (and (pair? left) (char-numeric? (car left)))
        (loop (cdr left) (append digits (list (car left))))
        (if (null? digits)
            (error "Invalid Expression")
            (let ([index (string->number (list->string digits))])
              (if (< index (length history))
                  (list (list-ref history index) left)
                  (error "Invalid Expression"))))))

(define (eval-expr chars history)
  (let ([chars (skip-space chars)])
    (cond
      [(null? chars)
       (error "Invalid Expression")]

      [(char=? (car chars) #\$)
       (read-history chars history)]

      [(char=? (car chars) #\+)
       (let* ([a (eval-expr (cdr chars) history)]
              [b (eval-expr (cadr a) history)])
         (list (+ (car a) (car b)) (cadr b)))]

      [(char=? (car chars) #\*)
       (let* ([a (eval-expr (cdr chars) history)]
              [b (eval-expr (cadr a) history)])
         (list (* (car a) (car b)) (cadr b)))]

      [(char=? (car chars) #\/)
       (let* ([a (eval-expr (cdr chars) history)]
              [b (eval-expr (cadr a) history)]
              [x (car a)]
              [y (car b)])
         (if (zero? y)
             (error "Invalid Expression")
             (list (quotient x y) (cadr b)))]

      [(char=? (car chars) #\-)
       (let ([a (eval-expr (cdr chars) history)])
         (list (- (car a)) (cadr a)))]

      [(char-numeric? (car chars))
       (read-number chars)]

      [else
       (error "Invalid Expression")])))

(define (eval-complete chars history)
  (let* ([answer (eval-expr chars history)]
         [remaining (skip-space (cadr answer))])
    (if (null? remaining)
        (car answer)
        (error "Invalid Expression"))))

;; basic tests
(displayln (eval-complete (string->list "+ 2 3") '()))
(displayln (eval-complete (string->list "* + 2 3 4") '()))
(displayln (eval-complete (string->list "- 5") '()))
(displayln (eval-complete (string->list "/ 8 2") '()))

;; history reference tests
(displayln (eval-complete (string->list "+ $0 3") '(5)))
(displayln (eval-complete (string->list "+ $0 $1") '(5 20)))

;; test that extra input is rejected
(displayln
 (with-handlers ([exn:fail? (lambda (_) "Rejected invalid expression")])
   (eval-complete (string->list "+ 2 3 xyz") '())))
