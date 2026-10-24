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
            (error "Invalid expression")
            (list (string->number (list->string digits)) left)))))

(define (read-history chars history)
  (let loop ([left (cdr chars)] [digits '()])
    (if (and (pair? left) (char-numeric? (car left)))
        (loop (cdr left) (append digits (list (car left))))
        (if (null? digits)
            (error "Invalid expression")
            (let ([index (string->number (list->string digits))])
              (if (and (>= index 1) (<= index (length history)))
                  (list (list-ref (reverse history) (sub1 index)) left)
                  (error "Invalid expression")))))))

(define (eval-expr chars history)
  (let ([chars (skip-space chars)])
    (cond
      [(null? chars)
       (error "Invalid expression")]

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
             (error "Invalid expression")
             (list (/ x y) (cadr b))))]

      [(char=? (car chars) #\-)
       (let ([a (eval-expr (cdr chars) history)])
         (list (- (car a)) (cadr a)))]

      [(char-numeric? (car chars))
       (read-number chars)]

      [else
       (error "Invalid expression")])))

(define (eval-complete chars history)
  (let* ([answer (eval-expr chars history)]
         [remaining (skip-space (cadr answer))])
    (if (null? remaining)
        (car answer)
        (error "Unexpected trailing characters"))))

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
                    (lambda (e) (exn-message e))])
                (eval-complete (string->list line) history))])
         (if (string? result)
             (begin
               (display "Error: ")
               (displayln result)
               (eval-loop history next-id interactive?))
             (begin
               (display next-id)
               (display ": ")
               ;; whole numbers print without ".0" to match the sample outputs
               (display (if (integer? result)
                            result
                            (real->double-flonum result)))
               (newline)
               (eval-loop (cons result history)
                          (add1 next-id)
                          interactive?))))])))

(eval-loop '() 1 interactive?)