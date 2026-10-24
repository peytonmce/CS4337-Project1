
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
              (if (and (>= index 1) (<= index (length history)))
                  (list (list-ref history (sub1 index)) left)
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

;; check whether the program should run in interactive mode
(define args
  (vector->list (current-command-line-arguments)))

(define interactive?
  (not (or (member "-b" args)
           (member "--batch" args))))

;; read and evaluate expressions until quit or end of input
(define (eval-loop history next-id interactive?)
  (when interactive?
    (display "> ")
    (flush-output))

  (let ([line (read-line)])
    (cond
      [(eof-object? line)
       (void)]

      [(string=? line "quit")
       (void)]

      [else
       (let ([result
              (with-handlers
                  ([exn:fail?
                    (lambda (_) 'invalid-expression)])
                (eval-complete (string->list line) history))])
         (if (eq? result 'invalid-expression)
             (begin
               (displayln "Error: Invalid Expression")
               (eval-loop history next-id interactive?))
             (begin
               (display next-id)
               (display ": ")
               (display (real->double-flonum result))
               (newline)
               (eval-loop (cons result history)
                          (add1 next-id)
                          interactive?))))])))

(eval-loop '() 1 interactive?)
