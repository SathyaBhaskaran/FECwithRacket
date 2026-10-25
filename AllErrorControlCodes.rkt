

#lang racket
(require scheme/serialize)
(require plot)
(define binary-list-msg "Binary list expected")
(define list-of-lists-msg "List of lists expected")
(define binary-lists-msg "List of binary lists expected")
(define binary-element-msg "Binary element expected")
(define rectangular-matrix-msg "Rectangular matrix expected")
(define (binary-element? x) (or (= x 0) (= x 1)))
(define (binary-list? x) (or (null? x) (and (cons? x) (null? (filter (negate binary-element?) x)))))
(define (binary-lists? x) (or (null? x) (and (cons? x) (null? (filter (negate binary-list?) x)))))
(define (lists? x) (or (null? x) (and (cons? x) (null? (filter (negate cons?) x)))))
;(define binary/c (flat-named-contract binary-element-msg binary-element?))
(define binary/c (integer-in 0 1))
(define lists/c (flat-named-contract list-of-lists-msg lists?))
(define index-list/c (flat-contract (listof natural-number/c)))
(define binary-list/c (flat-named-contract binary-list-msg binary-list?))
(define binary-lists/c (flat-named-contract binary-lists-msg binary-lists?))
(define octal/c (integer-in 0 7))
(define octal-list/c (flat-contract (listof octal/c)))
(define (rectangular-matrix? m)
  (if (and (cons? m) (cons? (car m)))
      (null? (filter false? (let ([c (length (car m))])
                              (map (lambda(x) (= c (length x))) m))))
      #f))
(define rectangular-matrix/c (flat-named-contract rectangular-matrix-msg rectangular-matrix?))
(provide lists/c binary/c binary-list/c binary-lists/c index-list/c
         octal/c octal-list/c rectangular-matrix/c rectangular-matrix?)(define prim-polys-list
                                                                         '(((1 0 1 1))
                                                                           ((1 0 0 1 1))
                                                                           ((1 0 0 1 0 1) (1 1 1 1 0 1) (1 1 0 1 1 1))
                                                                           ((1 0 0 0 0 1 1) (1 1 0 0 1 1 1) (1 1 0 1 1 0 1))
                                                                           ((1 0 0 0 1 0 0 1)
                                                                            (1 0 0 0 1 1 1 1)
                                                                            (1 0 0 1 1 1 0 1)
                                                                            (1 1 1 1 0 1 1 1)
                                                                            (1 0 1 1 1 1 1 1)
                                                                            (1 1 0 1 0 1 0 1)
                                                                            (1 0 0 0 0 0 1 1)
                                                                            (1 1 0 0 1 0 1 1)
                                                                            (1 1 1 0 0 1 0 1))
                                                                           ((1 0 0 0 1 1 1 0 1)
                                                                            (1 0 1 1 0 1 0 0 1)
                                                                            (1 1 1 1 0 0 1 1 1)
                                                                            (1 0 0 1 0 1 0 1 1)
                                                                            (1 0 1 1 0 0 1 0 1)
                                                                            (1 0 1 1 0 0 0 1 1)
                                                                            (1 0 1 0 1 1 1 1 1)
                                                                            (1 1 1 0 0 0 0 1 1))
                                                                           ((1 0 0 0 0 1 0 0 0 1)
                                                                            (1 0 0 1 0 1 1 0 0 1)
                                                                            (1 1 0 0 1 1 0 0 0 1)
                                                                            (1 1 0 0 0 1 0 0 1 1)
                                                                            (1 0 0 0 1 0 1 1 0 1)
                                                                            (1 0 0 1 1 1 0 1 1 1)
                                                                            (1 1 0 1 1 0 0 0 0 1)
                                                                            (1 1 0 0 0 1 0 1 0 1)
                                                                            (1 0 1 0 1 1 0 1 1 1))
                                                                           ((1 0 0 0 0 0 0 1 0 0 1)
                                                                            (1 0 1 0 0 0 0 1 1 0 1)
                                                                            (1 1 1 1 1 1 1 1 0 0 1)
                                                                            (1 0 0 0 1 1 0 1 1 1 1)
                                                                            (1 1 1 0 1 0 0 1 1 0 1)
                                                                            (1 0 1 1 1 1 1 1 0 1 1)
                                                                            (1 0 0 0 0 0 1 1 0 1 1)
                                                                            (1 0 1 0 0 1 0 0 0 1 1)
                                                                            (1 0 1 0 0 1 1 0 0 0 1)
                                                                            (1 1 0 0 0 0 1 0 1 0 1)
                                                                            (1 1 0 1 1 0 1 1 1 1 1)
                                                                            (1 1 0 1 0 0 0 1 0 0 1))
                                                                           ((1 0 0 0 0 0 0 0 0 1 0 1)
                                                                            (1 0 0 1 0 0 1 0 0 1 0 1)
                                                                            (1 0 0 0 1 0 0 0 1 1 0 1)
                                                                            (1 0 0 0 0 0 1 0 1 1 0 1)
                                                                            (1 1 0 0 0 0 0 0 1 1 0 1)(1 1 1 1 0 0 0 0 1 0 1 1)
                                                                            (1 0 0 0 0 1 1 0 0 0 1 1)
                                                                            (1 0 0 1 0 1 1 1 0 0 1 1)
                                                                            (1 1 1 1 0 0 1 1 0 0 0 1)
                                                                            (1 0 1 0 1 0 1 0 1 0 1 1))
                                                                           ((1 0 0 0 0 0 1 0 1 0 0 1 1)
                                                                            (1 1 0 1 1 1 0 1 0 0 1 1 1)
                                                                            (1 1 1 0 1 0 1 0 1 1 0 1 1)
                                                                            (1 1 1 0 0 0 0 1 0 0 1 1 1)
                                                                            (1 0 0 1 0 0 0 0 0 1 1 0 1)
                                                                            (1 1 0 0 0 0 1 0 1 0 1 1 1)
                                                                            (1 1 1 1 1 1 0 1 1 1 0 1 1)
                                                                            (1 0 1 1 1 0 1 1 1 0 1 0 1)
                                                                            (1 0 0 0 1 1 1 0 1 1 1 1 1)
                                                                            (1 1 0 1 1 1 1 0 0 0 0 0 1))
                                                                           ((1 0 0 0 0 0 0 0 0 1 1 0 1 1)
                                                                            (1 0 0 1 1 0 1 0 1 1 0 0 0 1)
                                                                            (1 0 1 0 0 1 1 0 0 1 0 0 1 1)
                                                                            (1 0 0 1 1 1 0 1 0 0 1 1 1 1)
                                                                            (1 1 0 0 0 1 1 1 1 0 0 0 0 1)
                                                                            (1 0 0 0 1 1 1 0 1 0 0 0 1 1)
                                                                            (1 0 0 0 1 0 1 0 1 1 1 1 1 1)
                                                                            (1 0 1 1 1 1 1 1 1 1 1 1 1 1)
                                                                            (1 0 1 1 0 0 1 0 0 0 1 0 1 1)
                                                                            (1 0 1 1 0 1 1 1 1 1 1 1 0 1)
                                                                            (1 1 0 1 0 1 1 0 0 1 1 1 0 1)
                                                                            (1 1 0 1 1 1 1 0 0 1 1 0 0 1)
                                                                            (1 1 0 1 0 1 1 1 1 0 0 0 1 1))))
(define (scale-list lst n)
  (for/list ([i lst])
    (* i n)))
(define (pad-right lst n fn)
  (append lst (build-list n fn)))
(define (pad-left lst n fn)
  (append (build-list n fn) lst))
(define (modulo-lst lst n)
  (reverse (for/fold ([acc '()])([i (in-list lst)])
             (cons (modulo i n) acc))))
(define (longer x y)
  (letrec [(compare (lambda (x y)
                      (and (cons? x)
                           (or (null? y)
                               (compare (cdr x) (cdr y))))))](if (and (list? x) (list? y))
                                                                 (compare x y)
                                                                 (> (length x) (length y)))))
(define (multiply p1 p2)
  (let ([pl (sub1 (+ (length p1) (length p2)))]
        [l2 (length p2)][fill-func (lambda(x) (+ 0 0))])
    (for/fold ([acc (build-list pl fill-func)])([i (in-list p2)][j (in-range l2)])
      (map + acc (pad-left (pad-right (scale-list p1 i)
                                      (sub1 (- l2 j)) fill-func) j fill-func)))))
(define (binary-mult-poly p1 p2)
  (modulo-lst (multiply p1 p2) 2))

(define (printable-poly p)
  (let ([pl (length p)])
    (for/fold ([outp '()])([i (in-list (reverse p))][j (in-range pl)]) ;#:when (not (zero? i)))
      (cons (quasiquote ((unquote i) \* \x \^ (unquote j))) outp))))

(define (add-poly x y)
  (letrec ([add (lambda (x y acc)
                  (cond [(cons? x)
                         (cond [(cons? y) (add (cdr x) (cdr y) (cons (+ (car x) (car y)) acc))]
                               [else (add (cdr x) y (cons (car x) acc))])]
                        [else (cond [(cons? y) (add x (cdr y) (cons (car y) acc))]
                                    [else acc])]))])
    (if (and (cons? x) (cons? y))
        (add (reverse (remove-leading-zeros x))
             (reverse (remove-leading-zeros y)) '())
        #f)))
(define (add-poly2 p1 p2)
  (map (lambda(x y) (+ x y)) p1 p2))
(define (binary-add-poly p1 p2)
  (modulo-lst (add-poly p1 p2) 2))
(define (binary-add-poly2 p1 p2)
  (map (lambda(x y) (bitwise-xor x y)) p1 p2))
(define (remove-leading-zeros lst)(if (cons? lst)
                                      (if (zero? (car lst))
                                          (remove-leading-zeros (cdr lst))
                                          lst)
                                      '()))
(define (degree lst) (sub1 (length (remove-leading-zeros lst))))
(define (first-binary-remainder p1 p2)
  (if (> (degree p2) (degree p1))
      (remove-leading-zeros p1)
      (remove-leading-zeros
       (modulo-lst (add-poly p1
                             (multiply (first-binary-qut-term p1 p2) p2)) 2))))
(define (first-binary-qut-term p1 p2)
  (let ([l (- (degree p1) (degree p2))])
    (cond [(positive? l)
           (modulo-lst (pad-right
                        (list (car (remove-leading-zeros p2))) l
                        (lambda(x) (+ 0 0))) 2)]
          [(zero? l) (list 1)]
          [else (list 0)])))
(define (nth-binary-qut-term p1 p2 n)
  (if (> (length p2) n)
      (modulo-lst (pad-left (pad-right (list (list-ref p2 n))
                                       (- (- (length p1) (length p2)) n)
                                       (lambda(x) (+ 0 0))) n (lambda(x) (+ 0 0))) 2)
      '()))
(define (binary-list-2-decimal lst)
  (let rec ([l (reverse lst)][x 0][dp 0])
    (if (cons? l)
        (rec (cdr l)(+ x (* (expt 2 dp) (car l)))(add1 dp))
        x)))
(define (binary-poly-long-div x y)
  (letrec ([p1 (remove-leading-zeros x)]
           [p2 (remove-leading-zeros y)]
           [ql (- (degree p1) (degree p2))]
           [q (first-binary-qut-term p1 p2)]
           [r (first-binary-remainder p1 p2)]
           [fill-func (lambda(x) (+ 0 0))])
    (cond
      [(or (null? p1) (negative? ql)) (values '() (remove-leading-zeros x))]
      [else (for/fold ([qut q]
                       [rem r])([j (stop-before (in-range ql) (lambda(x) (< (degree rem) (degree p2))))])
              (values (binary-add-poly qut (first-binary-qut-term rem p2))
                      (first-binary-remainder rem p2)))])))
(define (bin-arr lst) (reverse lst))
(define (binary-add-poly-N lst)
  (let rec ([x lst][acc '(0 0)])
    (if (cons? x)
        (if (cons? (cdr x))
            (rec (cdr x) (binary-add-poly (car x) acc))
            (binary-add-poly (car x) acc))
        acc)))
(define (zeros l) (build-list l (lambda(x) 0)))
(define (ones l) (build-list l (lambda(x) 1)))
(define (zeros-ones-seq zl ol)
  (flatten (cons (zeros zl) (ones ol))))
(define (ones-zeros-seq ol zl)
  (flatten (cons (ones ol) (zeros zl))))
(define (zeros-ones-eql-seq l)
  (flatten (cons (zeros l) (ones l))))
(define (ones-zeros-eql-seq l)
  (flatten (cons (ones l) (zeros l))))
(define (zeros-ones-eql-repeat-seq l r)
  (let rec ([rl r] [acc (zeros-ones-eql-seq l)])
    (if (<= rl 1)
        (flatten acc)
        (rec (sub1 rl) (cons (zeros-ones-eql-seq l) acc)))))
(define (ones-zeros-eql-repeat-seq l r)
  (reverse (zeros-ones-eql-repeat-seq l r)))
(define (info-bits k)
  (let* ([rl (expt 2 (sub1 k))])
    (let rec ([i 1][j 2][z (/ rl 2)][acc (list (zeros-ones-eql-repeat-seq 1 rl))])
      (if (= i k)
          (transpose acc)
          (rec (add1 i) (* j 2) (/ z 2)
            (cons (zeros-ones-eql-repeat-seq j z) acc))))))(define (norm x) (if (cons? x) (cons (- (car x) 48) (norm (cdr x))) '()))
;(norm (bytes->list prim-poly-list))
(define (ormap-expt lst m)
  (if (cons? m)
      (filter (lambda(x) (begin (ormap (str-fn x) m))) lst)
      '()))
(define (andmap-expt lst m)
  (if (cons? m)
      (filter (lambda(x) (begin (ormap (str-fn x) m))) lst)
      '()))
(define lcp (lambda(x) (sub1 (string-length x))))

(define (str-fn x)
  (lambda(t)
    (when (positive? (lcp x)) (char=? (string-ref x (lcp x)) t))))

(define (log2 x)
  (if (zero? x)
      x
      (inexact->exact (truncate (/ (log x) (log 2))))))

(define (decimal-2-binary-list n)
  (if (= 0 n) '(0)
      (let ([mx (log2 n)])
        (let rec ([i 0][acc '()])
          (if (> i mx)
              (remove-leading-zeros acc)
              (rec (add1 i) (cons (if (bitwise-bit-set? n i) 1 0) acc)))))))

(define (ones-cmpl lst)
  (let rec ([lst lst][acc '()])
    (if (null? lst)
        (reverse acc)
        (rec (cdr lst) (cons (modulo (add1 (car lst)) 2) acc)))))

(define (octal-digit-2-binary-list x)
  (if (> x 7)
      #f(cond
          [(= x 0) '(0 0 0)]
          [(= x 1) '(0 0 1)]
          [(= x 2) '(0 1 0)]
          [(= x 3) '(0 1 1)]
          [else (decimal-2-binary-list x)])))
; (/ (- (modulo 33523 100) (modulo 33523 10)) 10) = 2
(define (octal-number-2-binary-list x)
  (let mul ([i 10])
    (if (<= i x)
        (mul (* i 10))
        (let rec ([n x][j (/ i 10)][acc '()])
          (if (> 1 (/ j 10))
              (flatten (reverse (cons (octal-digit-2-binary-list n) acc)))
              (rec (modulo n j) (/ j 10)
                (cons (octal-digit-2-binary-list (/ (- (modulo n i) (modulo n j)) j)) acc)))))))
(define (decimal-list-2-binary-lists lst)
  (let rec ([lst lst][acc '()])
    (if (null? lst)
        (reverse acc)
        (rec (cdr lst) (cons (decimal-2-binary-list (car lst)) acc)))))
(define (parity lst)
  (modulo (apply + lst) 2))
(define (prim-poly-test-list lst)
  (for/fold ([acc '()])([i (in-list lst)])
    (letrec ([fp (add1 (binary-list-2-decimal i))]
             [lp (add1 (expt 2 (sub1 (expt 2 (degree i)))))]
             [n (add1 (- lp fp))]
             [dvnd (build-list n (lambda(x) (decimal-2-binary-list (+ fp x))))])
      (cons (for/fold ([rem '()])([j (in-list dvnd)])
              (define-values (q r) (binary-poly-long-div j i))
              (cons r rem))
            acc))))
(define (is-prim-dvnd? x)
  (letrec [(runl (lambda (x y)
                   (cond
                     [(and (null? x) (zero? (sub1 y))) #t]
                     [(and (null? x) (zero? y)) #f]
                     [(and (cons? x) (zero? (sub1 y))) #f]
                     [else (runl (cdr x) (car x))])))]
    (if (zero? (car x))
        #f
        (runl (cdr x) (cadr x)))))

(define (gen-binary-prim-dvnd deg)(flatten (cons (cons 1 (zeros (sub1 deg))) '(1))))

(define (binary-qut x y)
  (begin (define-values (q r) (binary-poly-long-div x y)) q))
(define (binary-rem x y)
  (begin (define-values (q r) (binary-poly-long-div x y)) r))
(define (isprim? x)
  (letrec ([fp (degree x)]
           [lp (degree (decimal-2-binary-list (add1 (expt 2 (sub1 (expt 2 (degree x)))))))]
           [n (add1 (- lp fp))]
           [dvnd (build-list n (lambda(x) (gen-binary-prim-dvnd (+ fp x))))])
    (begin (define reml (for/fold ([rem '()])([j (in-list dvnd)])
                          (define-values (q r) (binary-poly-long-div j x))
                          ;
                          (printf "\n\n poly: ~a FINAL REMAINDER: ~a \n\n" j r)
                          (cons r rem)))
           (and (null? (car reml)) (andmap cons? (cdr reml))))))
(define (isprim2? x)
  (letrec ([fp (degree x)]
           [lp (degree (decimal-2-binary-list (add1 (expt 2 (sub1 (expt 2 (degree x)))))))]
           [n (add1 (- lp fp))]
           [dvnd (build-list n (lambda(x) (gen-binary-prim-dvnd (+ fp x))))])
    (let rec ([d dvnd])
      (if (null? (cdr d)) (null? (binary-rem (car d) x))
          (if (cons? (binary-rem (car d) x)) (rec (cdr d)) #f)))))
(define (cyclic-left-shift lst n)
  (append (drop lst n) (take lst n)))
(define (cyclic-left-shift2 lst n)
  (letrec ([rec (lambda (x n acc)
                  (if (zero? n)
                      (flatten (cons x acc))
                      (rec (cdr x) (sub1 n) (cons acc (car x)))))])
    (rec (cdr lst) (sub1 n) (cons (car lst) '()))))
(define (cyclic-right-shift lst n)
  (cyclic-left-shift lst (- (length lst) n)))
(define (info-bits2 k)
  (cons (build-list (if (= k (expt 2 (log2 k)))(log2 k)
                        (add1 (log2 k)))
                    (lambda(x) (+ 0 0)))
        (build-list (sub1 k) (lambda(x) (pad-left (decimal-2-binary-list (add1 x))
                                                  (- (log2 (sub1 k)) (degree (decimal-2-binary-list (add1 x))))
                                                  (lambda(x) (+ 0 0)))))))
(define (duplicate e n)
  (build-list n (lambda(x) e)))
(define (info-bits3 k)
  (build-list (expt 2 k) (lambda(x) (if (zero? x)
                                        (build-list k (lambda(x) (+ 0 0)))
                                        (pad-left (decimal-2-binary-list x)
                                                  (sub1 (- k (degree (decimal-2-binary-list x))))
                                                  (lambda(x) (+ 0 0)))))))
(define (info-bits1 k)
  (map (expt 2 k) (lambda(x) (if (zero? x)
                                 (build-list k (lambda(x) (+ 0 0)))
                                 (pad-left (decimal-2-binary-list x)
                                           (sub1 (- k (degree (decimal-2-binary-list x))))
                                           (lambda(x) (+ 0 0)))))))
(define (rect-mat-2-poly-list m)
  (let rec ([x m][acc '()])
    (if (null? x)
        (reverse acc)
        (rec (cdr x) (cons (remove-leading-zeros (car x)) acc)))))
(define (get-highest-degree m)
  (let* ([l (filter cons? (rect-mat-2-poly-list m))])
    (if (null? l)
        -1
        (let rec ([x l][d (degree (car l))])
          (if (null? x)
              d
              (if (> (degree (car x)) d)
                  (rec (cdr x) (degree (car x)))
                  (rec (cdr x) d)))))))
(define (algb-encode k gn-p)
  (let rec ([x (info-bits k)][acc '()])
    (if (cons? x)
        (rec (cdr x) (cons (binary-mult-poly (car x) gn-p) acc))
        (reverse acc))))
(define (algb-decode lst gn-p)(let rec ([x lst][acc '()])
                                (if (cons? x)
                                    (rec (cdr x) (cons (let-values ([(q r)(binary-poly-long-div (car x) gn-p)]) (list q r)) acc)) (reverse
                                                                                                                                   acc))))
(define (algb-decode-k lst k gn-p)
  (let rec ([x lst][acc '()])
    (if (cons? x)
        (rec (cdr x) (cons (let-values ([(q r)(binary-poly-long-div (car x) gn-p)]) (list q r)) acc)) (reverse
                                                                                                       acc))))
(define (syndrome-decode lst pm)
  (binary-mat-mult lst pm))
(define (get-prim-poly n lst) (car (list-ref lst (- n 3))))
(define (get-prim-poly-list n lst) (list-ref lst (- n 3)))
(define (gen-1bit-vec n)
  (build-list n (lambda(x) (cyclic-right-shift (decimal-2-binary-list (expt 2 (sub1 n))) x))))
;; this function checks if all cyclic permutations of all codes are in the list too
(define (check-cyclicity lst)
  (let rec ([l lst])
    (if (null? l)
        #t
        (let rec-i ([n (sub1 (length (car l)))])
          (if (= n 1)
              (rec (cdr l))
              (if (member (cyclic-left-shift (car l) n) lst)
                  (rec-i (sub1 n))
                  #f))))))
(define (check-additive-closure lst)
  (let ([nzl (filter cons? (rect-mat-2-poly-list lst))])
    (let rec ([l nzl])
      (if (null? l)
          #t
          (let rec-i ([x nzl])
            (if (null? x)
                (rec (cdr l))
                (if (member (remove-leading-zeros (binary-add-poly (car l) (car x))) (cons '() nzl))
                    (rec-i (cdr x))
                    #f)))))))
(define (check-additive-closure-n lst sl)
  (let ([nzl (filter cons? (rect-mat-2-poly-list lst))][nz-sl (filter cons? (rect-mat-2-poly-list sl))])
    (let rec ([l sl])
      (if (null? l)#t
          (let rec-i ([x nzl])
            (if (null? x)
                (rec (cdr l))
                (if (member (remove-leading-zeros (binary-add-poly (car l) (car x))) (cons '() nzl))
                    (rec-i (cdr x))
                    #f)))))))
(define (check-n-cyclicity lst n)
  (null? (filter false?
                 (flatten (map (lambda(x) (member (cyclic-left-shift x n) lst)) lst)))))
(define (group-list source n)
  (if (zero? n)
      #f
      (letrec ([rec (lambda (source acc)
                      (let-values ([(frst rst)
                                    (if (> (length source) n)
                                        (split-at source n)
                                        (values source '()))])
                        (if (cons? rst)
                            (rec rst (cons frst acc))
                            (reverse (cons source acc)))))])
        (if source (rec source '()) '()))))
(define (check-cyclicity-by-weight lst w)
  (let ([wl (filter (lambda(x) (= w (weight x))) lst)])
    (check-cyclicity wl)))
(define (check-n-cyclicity-by-weight lst w c)
  (let ([wl (filter (lambda(x) (= w (weight x))) lst)])
    (check-n-cyclicity wl c)))
(define (weight lst)
  (apply + lst))
(define (cw-weight-list lst)
  (map (lambda(x) (weight x)) lst))
;
(define (weight-enum lst)
  (build-list (add1 (length (car lst))) (lambda(x) (length (filter (lambda(y) (= x (weight y))) lst)))))
(define (filter-by-less-than-or-equal-degree n lst) (filter (lambda(x) (<= (degree x) n))
                                                            (filter(lambda(x) (cons? (remove-leading-zeros x))) lst)))
(define (filter-by-more-than-or-equal-degree n lst) (filter (lambda(x) (>= (degree x) n))
                                                            (filter
                                                             (lambda(x) (cons? (remove-leading-zeros x))) lst)))
(define (filter-between-degree m n lst)
  (filter-by-more-than-or-equal-degree m (filter-by-less-than-or-equal-degree n lst)))
(define (filter-by-less-than-or-equal-weight n lst) (filter (lambda(x) (<= (weight x) n)) lst))
(define (filter-by-more-than-or-equal-weight n lst) (filter (lambda(x) (>= (weight x) n)) lst))
(define (filter-between-weight m n lst)
  (filter-by-more-than-or-equal-weight m (filter-by-less-than-or-equal-weight n lst)))
(define (filter-by-weight w lst) (filter (lambda(x) (= (weight x) w)) lst))
(define (filter-info-bits-by-weight w k) (filter-by-weight w (info-bits k)))

(define (transpose4 lst)
  (map (lambda(x)
         (map (lambda(y)
                (list-ref y x)) lst)) (build-list (length (car lst)) values)))
(define (transpose lsts)
  (let rec ([x lsts][acc '()])
    (if (or (null? x) (null? (cdr x)) (null? (cadr x)))
        (reverse acc)
        (rec (map (lambda(y) (cdr y)) x) (cons (map (lambda(x) (car x)) x) acc)))))
(define (mat-mult p1 p2)
  (transpose (map (lambda(x) (map (lambda(y)
                                    (apply + (map (lambda(z) (* (list-ref x z) (list-ref y z)))
                                                  (build-list (length y) values)))) p1)) (transpose p2))))(define (binary-mat-mult3 p1 p2)
                                                                                                            (transpose (map (lambda(x) (map (lambda(y)
                                                                                                                                              (parity (map (lambda(z) (* (list-ref x z) (list-ref y z)))
                                                                                                                                                           (build-list (length y) values)))) p1)) (transpose p2))))
(define (add-orth-row lst)
  (if (null? (cdr lst))
      lst
      (let ([res (filter (lambda(l) (= (degree l) (degree (cdr (remove-leading-zeros (car lst))))))
                         (cdr (map (lambda(l) (remove-leading-zeros l)) lst)))])
        (if (cons? res)
            (cons (binary-add-poly (car res) (car lst)) (cdr lst))
            lst))))
(define (systematize-cyclic-top-row lst k)
  (let rec ([x (car lst)] [acc (cdr lst)])
    (let-values ([(h t) (split-at x k)])
      (if (= (binary-list-2-decimal h) (expt 2 (sub1 k)))
          (cons x acc)
          (let ([res (add-orth-row (cons x acc))])
            (if (and (cons? res) ((negate equal?) lst res))
                (rec (car res) acc)
                lst))))))
(define (make-rect m)
  (let* ([l (get-highest-degree (filter cons? (rect-mat-2-poly-list m)))] [fill-func (lambda(x) (+ 0 0))])
    (if (>= l 0)
        (let rec ([x (rect-mat-2-poly-list m)] [acc '()])
          (if (null? x)
              (reverse acc)
              (if (cons? (remove-leading-zeros (car x)))
                  (rec (cdr x) (cons (pad-left (car x) (- l (degree (car x))) fill-func) acc))
                  (rec (cdr x) (cons (pad-left '(0) l fill-func) acc)))))
        m)))
(define (make-rect-k m k)
  (let* ([l (sub1 k)] [fill-func (lambda(x) (+ 0 0))])
    (if (>= l 0)
        (let rec ([x (rect-mat-2-poly-list m)] [acc '()])
          (if (null? x)
              (reverse acc)
              (if (cons? (remove-leading-zeros (car x)))
                  (rec (cdr x) (cons (pad-left (car x) (- l (degree (car x))) fill-func) acc))
                  (rec (cdr x) (cons (pad-left '(0) l fill-func) acc)))))
        m)))
(define (systematize-cyclic-matrix m k)(let rec ([x m][i k][acc '()])
                                         (if (= i 0)
                                             (make-rect (reverse acc))
                                             (rec (cdr x) (sub1 i) (cons (car (systematize-cyclic-top-row x i)) acc)))))
(define (systematize-cyclic-matrix2 m)
  (let ([k (length m)])
    (let rec ([x m][i k][acc '()])
      (if (= i 0)
          (make-rect (reverse acc))
          (rec (cdr x) (sub1 i) (cons (car (systematize-cyclic-top-row x i)) acc))))))
(define (interchange-rows m r1 r2)
  (if (and (< r1 r2) (< r2 (length m)))
      (let rec ([x m][n 0][acc '()])
        (if (cons? x)
            (cond [(= n r1)
                   (rec (cdr x) (add1 n) (cons (list-ref m r2) acc))]
                  [(= n r2)
                   (rec (cdr x) (add1 n) (cons (list-ref m r1) acc))]
                  [else (rec (cdr x) (add1 n) (cons (car x) acc))])
            (reverse acc)))
      #f))
(define (interchange-cols m c1 c2)
  (if (and (< c1 c2) (< c2 (length (car m))))
      (transpose (interchange-rows (transpose m) c1 c2))
      #f))
(define (idn-mat k)
  (build-list k (lambda(x) (cyclic-right-shift (decimal-2-binary-list (expt 2 (sub1 k))) x))))
(define (row-subspace m k)
  (let-values ([(h t) (split-at m k)])
    h))
(define (col-subspace m k)
  (transpose (row-subspace (transpose m) k)))
(define (submatrix m k l)
  (col-subspace (row-subspace m k) l))
(define (is-systematic? m k)
  (equal? (submatrix m k k) (idn-mat k)))
(define (is-cyclic? m)
  (let* ([base (car m)][k (length m)])(let rec ([x (cdr m)][n 1])
                                        (if (= n k)
                                            #t
                                            (if (equal? (car x) (cyclic-right-shift base n))
                                                (rec (cdr x) (add1 n))
                                                #f )))))
(define systematic/c (lambda(x y) (flat-contract (is-systematic? x y))))
(define (decode-cyclic-cw cw n gp syn)
  (if (zero? (binary-list-2-decimal cw))
      cw
      (let rec ([x (pad-left cw (- n (length cw)) (lambda(x) (+ 0 0)))][l 0])
        (let-values ([(q r)(binary-poly-long-div x gp)])
          (if (or (null? r) (equal? r syn))
              (binary-add-poly cw (cyclic-right-shift (decimal-2-binary-list (expt 2 (sub1 n))) l))
              (rec (cyclic-left-shift x 1) (add1 l)))))))
(define (decode-all-cyclic-cw lst cw-lst n gp syn)
  (let rec ([x lst][acc '()])
    (if (cons? x)
        (let ([dec-cw (pad-left
                       (decode-cyclic-cw (car x) n gp syn)
                       (- n (length (car x))) (lambda(x) (+ 0 0)))])
          (if (member dec-cw cw-lst)
              (rec (cdr x) (cons dec-cw acc))
              #f))
        (reverse (remove-duplicates acc)))))
;(define (gen-n-bit-vectors2 n m)
; (filter (lambda(x) (= m (weight x))) (info-bits n)))
(define (gen-n-bit-vectors n m)
  (if (= m 1)
      (gen-1bit-vec n)
      (let rec ([acc (gen-1bit-vec n)][base (gen-1bit-vec n)][k m])
        (cond
          [(= k 0) (filter (lambda(x) (= m (weight x))) (remove-duplicates acc))]
          [else (rec
                    (append acc
                            (let ([sum (map (lambda(x) (map (lambda(y) (binary-add-poly x y)) acc)) base)])
                              (append* (car sum) (cdr sum))))
                  base
                  (if (= k m) (- k 2) (sub1 k)))]))))(define (flatten-l2 lst)
                                                       (let rec ([x lst] [acc '()])
                                                         (if (cons? (car x))
                                                             (rec (cdr x) (cons (append* (car x) (cdr x)) acc))
                                                             acc)))
(define (weave x y)
  (let rec ([l1 x][l2 y][acc '()])
    (cond [(and (cons? l1) (cons? l2)) (rec (cdr l1) (cdr l2) (cons (car l2) (cons (car l1) acc)))]
          [(and (cons? l1) (null? l2)) (rec (cdr l1) '() (cons (car l1) acc))]
          [(and (null? l1) (cons? l2)) (rec '() (cdr l2) (cons (car l2) acc))]
          [(and (null? l1) (null? l2)) (reverse acc)])))
(define (decimate lst)
  (let rec ([x lst][odd-acc '()][even-acc '()])
    (if (null? x)
        (append even-acc odd-acc)
        (if (null? (cdr x))
            (reverse (append even-acc (cons (car x) odd-acc)))
            (if (null? (cddr x))
                (reverse (append (cons (cadr x) even-acc) (cons (car x) odd-acc)))
                (rec (cddr x) (cons (car x) odd-acc) (cons (cadr x) even-acc)))))))
(define (add-selected-rows m lst)
  (let rec ([x m][y lst][acc '(0)])
    (if (or (null? x) (null? y))
        acc
        (if (zero? (car y))
            (rec (cdr x) (cdr y) acc)
            (rec (cdr x) (cdr y) (binary-add-poly (car x) acc))))))
(define (binary-mat-mult p1 p2)
  (make-rect-k (map (lambda(x) (add-selected-rows p2 x)) p1) (length (car p2))))
(define (RM-check-parity-sums2 r m)
  (check-add-parities-by-weight (assoc-parity-sums (RM-genmat r m)) (group-RM-gm-by-weight r m)))
(define (RM-check-parity-sums r m)
  (map (lambda(z) (map (lambda(y) (map (lambda(x) (add-parity-sums y x)) z))
                       (RM-genmat r m))) (drop-right (assoc-parity-sums (RM-genmat r m)) 1)))
(define (check-add-parities-by-weight ps-l r-l)
  (map (lambda(x) (map (lambda(y) (add-parity-sums y x)) r-l)) ps-l))
(define (gen-random-nbit-patterns n m np)
  (filter-by-weight m (map (lambda(x y) (flip-nth-bits x y)) (build-list np (lambda(x) (zeros n)))
                           (build-list np (lambda(x) (build-list m (lambda(x) (random n))))))))
(define (gen-nbit-patterns n m) (filter-by-weight m (info-bits n)))

(define (gen-nbit-patterns2 n m)
  (let ([res
         (if (= m 1)
             (gen-1bit-vec n)
             (let rec ([acc (gen-1bit-vec n)][base (gen-1bit-vec n)][k m])
               (cond
                 [(= k 0) (filter (lambda(x) (= m (weight x))) (remove-duplicates acc))]
                 [else (rec
                           (append acc
                                   (let ([sum
                                          ;(map (lambda(x) (map (lambda(y) (binary-add-poly x y)) acc)) base)
                                          (for*/fold ([acc1 '()])([x (in-list acc)][y (in-list base)])
                                            (cons (binary-add-poly x y) acc1))])
                                     ;
                                     (append* (car sum) (cdr sum))
                                     sum))
                         base
                         (if (= k m) (- k 2) (sub1 k)))])))]) (make-rect-k res n)))

(define (flip-matrix-cols m)
  (map (lambda(x) (reverse x)) m))
(define (flip-matrix m)
  (reverse (flip-matrix-cols m)))
(define (left-submatrix m p)
  (submatrix m (length m) (floor (/ (width m) p))))
(define (right-submatrix m p)
  (flip-matrix-cols (left-submatrix (flip-matrix-cols m) p)))
(define (remove-common lst1 lst2)
  (reverse (cons (filter (lambda(x) (false? (member x lst1))) lst2) (list lst1))))
(define (remove-common-from-list lsts lst2)
  (let rec ([x lsts][acc lst2])
    (if (cons? x)
        (rec (cdr x) (filter (lambda(y) (false? (member y (car x)))) acc))
        acc)))
(define (remove-common-from-lists lsts)
  (let rec ([x (list (car lsts))][acc (cdr lsts)])
    (if (cons? acc)(rec (cons (remove-common-from-list x (car acc)) x) (cdr acc))
        (reverse x))))
(define (RM-comb-submat-space m)
  (let rec ([x m][acc '()])
    (if (null? (cdr x))
        (reverse (cons (car x) acc))
        (rec (cdr (right-submatrix x 2)) (cons (car (left-submatrix x 2)) acc)))))
;(define (subrow-space-deci v d-p)
; (list-ref (group-list v (floor (/ (length v) (expt 2 (length d-p))))) d-p))
(define (subrow-space v s-p)
  (list-ref (group-list v (floor (/ (length v) (expt 2 (length s-p))))) (binary-list-2-decimal s-p)))
(define (subrow-split v)
  (map (lambda(x) (subrow-space v x)) (info-bits (log2 (weight v)))))


(define (subrow v s-b)
  (list-ref (group-list v (floor (/ (length v) 2))) s-b))
(define (zeros-triangle l)
  (build-list l (lambda(x) (zeros (add1 x)))))
(define (ones-triangle l)
  (build-list l (lambda(x) (ones (add1 x)))))
(define RM-25-w4-zeros
  '(((0 2 1 3) (4 6 5 7) (8 10 9 11) (12 14 13 15) (16 18 17 19) (20 22 21 23) (24 26 25 27) (28 30 29
                                                                                                 31))
    ((0 4 1 5) (2 6 3 7) (8 12 9 13) (10 14 11 15) (16 20 17 21) (18 22 19 23) (24 28 25 29) (26 30 27
                                                                                                 31))
    ((0 4 2 6) (1 5 3 7) (8 12 10 14) (9 13 11 15) (16 20 18 22) (17 21 19 23) (24 28 26 30) (25 29 27
                                                                                                 31))
    ((0 8 1 9) (2 10 3 11) (4 12 5 13) (6 14 7 15) (16 24 17 25) (18 26 19 27) (20 28 21 29) (22 30 23
                                                                                                 31))
    ((0 8 2 10) (1 9 3 11) (4 12 6 14) (5 13 7 15) (16 24 18 26) (17 25 19 27) (20 28 22 30) (21 29 23
                                                                                                 31))
    ((0 8 4 12) (1 9 5 13) (2 10 6 14) (3 11 7 15) (16 24 20 28) (17 25 21 29) (18 26 22 30) (19 27 23
                                                                                                 31))
    ((0 16 1 17) (2 18 3 19) (4 20 5 21) (6 22 7 23) (8 24 9 25) (10 26 11 27) (12 28 13 29) (14 30 1531))
    ((0 16 2 18) (1 17 3 19) (4 20 6 22) (5 21 7 23) (8 24 10 26) (9 25 11 27) (12 28 14 30) (13 29 15
                                                                                                 31))
    ((0 16 4 20) (1 17 5 21) (2 18 6 22) (3 19 7 23) (8 24 12 28) (9 25 13 29) (10 26 14 30) (11 27 15
                                                                                                 31))
    ((0 16 8 24) (1 17 9 25) (2 18 10 26) (3 19 11 27) (4 20 12 28) (5 21 13 29) (6 22 14 30) (7 23 15
                                                                                                 31))))
(define RM-24-w8-zeros
  '(((0 1) (2 3) (4 5) (6 7) (8 9) (10 11) (12 13) (14 15))
    ((0 2) (1 3) (4 6) (5 7) (8 10) (9 11) (12 14) (13 15))
    ((0 4) (1 5) (2 6) (3 7) (8 12) (9 13) (10 14) (11 15))
    ((0 8) (1 9) (2 10) (3 11) (4 12) (5 13) (6 14) (7 15))))
;'(((0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1) (0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))
; ((0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1) (0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))
; ((0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1) (0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1))
; ((0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1) (0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))
; ((0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1) (0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1))
; ((0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1) (0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1)))
;'((0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1)
; (0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 1)
; (0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1)
; (0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1)
; (0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 1)
; (0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1))
;'(((0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1) (0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1) (0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))
; ((0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1) (0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1) (0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))
; ((0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1) (0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1) (0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1))
; ((0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1) (0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1) (0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1)))
;'((0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1)
; (0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1)
; (0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1)
; (0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1))
(define RM-34-w2-zeros
  '(
    ((0 1 2 3 4 5 6 7) (8 9 10 11 12 13 14 15))
    ((0 1 2 3 8 9 10 11) (4 5 6 7 12 13 14 15))
    ((0 1 4 5 8 9 12 13) (2 3 6 7 10 11 14 15))
    ((0 2 4 6 8 10 12 14) (1 3 5 7 9 11 13 15)))
  )
(define RM-24-w4-zeros'(((0 1 2 3) (4 5 6 7) (8 9 10 11) (12 13 14 15))
                        ((0 1 4 5) (2 3 6 7) (8 9 12 13) (10 11 14 15))
                        ((0 2 4 6) (1 3 5 7) (8 10 12 14) (9 11 13 15))
                        ((0 1 8 9) (2 3 10 11) (4 5 12 13) (6 7 14 15))
                        ((0 2 8 10) (1 3 9 11) (4 6 12 14) (5 7 13 15))
                        ((0 4 8 12) (1 5 9 13) (2 6 10 14) (3 7 11 15))))
(define (RM-primary-zeros r m)
  (let rec ([x m][pr-l (build-list (expt 2 m) values)][acc '()])
    (if (zero? x)
        (reverse acc)
        (let ([dec (map (lambda(x) (decimate x)) (group-list (flatten pr-l) 4))])
          (rec (sub1 x) dec (cons dec acc))))))
(define (RM-zeros-pos-secondary-iter n pr-r)
  (let* (
         ;[wd (width pr-r)]
         ;
         [ele (map (lambda(x) (reverse (sort-by-degree (collect-elements pr-r x))))
                   ;
                   (map (lambda(x) (get-all-matching-pos 1 x)) (gen-nbit-patterns (length pr-r) n)))]
         [per (all-combinations pr-r n)]
         [ele (map (lambda(x) (reverse (sort-by-degree x))) per)]
         [z-pos (map (lambda(y) (map (lambda(x) (get-all-matching-pos 0 x)) y)) ele)]
         ;
         [z-pos-c (map (lambda(x) (sort (remove-duplicates (flatten x)) <)) z-pos)]
         ;
         [z-pos-g (map (lambda(x y) (flatten (cons x y))) z-pos)]
         [prd (map (lambda(x) (bitwise-AND-binary-polys x)) per)]
         [z-pos-nd (map (lambda(x) (remove-common-from-lists x)) z-pos)]
         [z-pos-ndg (map (lambda(x) (map (lambda(y) (group-list y (/ (length y)
                                                                     (/ (weight (car pr-r))
                                                                        (expt 2 (sub1 n)))))) x)) z-pos-nd)]
         [z-pos-flt (map (lambda(y) (map (lambda(x) (flatten x)) (transpose y))) z-pos-ndg)]
         [z-pos-dec (map (lambda(x) (group-list (decimate (sort (flatten x) >)) (sub1 (expt 2 n)))) z-pos-nd)]
         [par-w2 (assoc-parity-sums2 pr-r)]
         [dec-tree-func (lambda(par) (let rec ([x par][acc '()])
                                       (if (null? x)
                                           (reverse acc)
                                           (rec (cdr x) (cons (let rec1 ([y (decimate (car x))] [acc1 '()])
                                                                (if (equal? (car x) y)
                                                                    (cons (car x) (reverse acc1))
                                                                    (rec1 (decimate y)
                                                                          (cons y acc1)))) acc)))))]
         [dec-tree (dec-tree-func par-w2)]
         ;[cr-r (map (lambda(x) (map (lambda(y z) (subrow-space y z)) x (ones-triangle (length x)))) ele)]
         [par-bl-func (lambda(dt ep)
                        (map (lambda(w)
                               (remove-permutations (map (lambda(z)
                                                           (sort (group-list (flatten z) w)
                                                                 (lambda(x y) (< (car x) (car y)))))
                                                         (remove-duplicates (append* (car dt) (cdr dt)))))) (build-list (sub1 ep) (lambda(x) (expt 2 (+ x 2))))))]
         [par-bl (par-bl-func dec-tree 2)]
         [par-chk-all-w-func (lambda(pb-l)
                               (map (lambda(x)
                                      (check-add-parities-by-weight x
                                                                    (RM-genmat n (log2 (width pr-r))))) pb-l))]
         [par-chk-all-w (par-chk-all-w-func par-bl)]
         )
    ;cr-r
    ; ele prd
    ;z-pos z-pos-nd
    ;z-pos-ndg z-pos-flt z-pos-dec
    ; par-w2
    ; dec-tree
    ; par-bl
    ; (car par-bl)
    ; (dec-tree-func (car par-bl))
    ;; (par-bl-func (car par-bl) 3)
    ; par-chk-all-w
    ; (par-bl-func (dec-tree-func (car par-bl)) 3)
    (let-values ([(res res-pbc-l)
                  (if (> n 2)
                      (let rec ([x 2][acc-dt '()][acc-pbc '()])
                        (if (= x n)
                            (values
                             (reverse (remove-duplicates (cons par-w2
                                                               (map (lambda(x0)
                                                                      (map (lambda(x1)
                                                                             (map (lambda(x2) (sort x2 <)) x1)) x0))
                                                                    (append* (car acc-dt) (cdr acc-dt))))))
                             acc-pbc)
                            (let* ([pb-l1 (par-bl-func (dec-tree-func (car par-bl)) (add1 x))]
                                   [pbc-l (par-chk-all-w-func pb-l1)])
                              (rec (add1 x) (cons pb-l1 acc-dt) (cons pbc-l acc-pbc)))))
                      (values (map (lambda(x0)
                                     (map (lambda(x1)
                                            (map (lambda(x2) (sort x2 <)) x1)) x0))
                                   (reverse (remove-duplicates (cons par-w2 par-bl)))) '()))])
      (let* ([r n][m (log2 (width pr-r))]
                  [gm (reverse (RM-genmat r m))]
                  [group-sec-r (reverse (drop (reverse (group-RM-gm-by-weight r m)) 2))]
                  [gm-non1 (reverse (cdr (reverse gm)))]
                  [gm-sec-r (sort-by-weight (remove* pr-r gm-non1))]
                  [res-sec-r (reverse (cdr (reverse res)))];
                  [res1 (map (lambda(x y) (mcons x y)) gm-non1
                             ;
                             (append* (car res) (cdr res)))]
                  ;
                  [res2 (append (list (build-list (width pr-r) (lambda(x) (list x))))
                                ;
                                (map (lambda(x) (mcdr x))
                                     ;
                                     (sort res1 (lambda(x y) (> (degree (mcar x)) (degree (mcar y)))))))]
                  [res3 (map (lambda(x y)
                               (let* ([chk-p (flatten (check-add-parities-by-weight x y))]
                                      [chk-g (group-list chk-p (/ (length chk-p) (length y)))])
                                 (map (lambda(x1 y1) (mcons x1 y1)) chk-g x)))
                             res-sec-r group-sec-r)]
                  [res4 (map (lambda(x0) (sort x0 (lambda(x y) (> (degree (mcar x))
                                                                  (degree (mcar y)))))) res3)]
                  [res5 (map (lambda(x) (map (lambda(y) (mcdr y)) x)) res4)]
                  [res5-1 (append (append res5 (list par-w2))
                                  (list (assoc-parity-sums2 (list (ones (width pr-r))))))]
                  [res6 (append (append* (car res5) (cdr res5)) par-w2)]
                  [res7 (map (lambda(x y) (mcons x y)) (group-RM-gm-by-weight2 r m)
                             (append res6 (list (assoc-parity-sums2 (list (ones (width pr-r)))))))]
                  [res8 (sort res7 (lambda(x y) (> (degree (mcar x)) (degree (mcar y)))))]
                  [res9 (map (lambda(x) (mcdr x)) res8)]
                  )
        (begin
          ;
          (display (list
                    ;
                    res
                    ;;
                    res
                    ;;
                    res7
                    ;;
                    res8
                    ;;
                    res9
                    ;
                    res-pbc-l
                    ;
                    ))
          (values
           ;
           res
           ;
           res-sec-r
           ;
           res1
           ;
           res2
           ;
           gm-non1
           ;
           res3
           res5-1
           ;
           res5
           ;
           res6
           ;
           res7
           ;
           res8
           ;
           res9
           ;
           res-pbc-l
           )
          )))))(define (is-permutation? lst1 lst2)
                 (equal? (sort lst1 <) (sort lst2 <)))
(define (remove-head-permutations lst1 lsts)
  (filter (lambda(x) (not (is-permutation? (car lst1) (car x)))) lsts))
(define (remove-permutations lsts)
  (let rec ([x lsts][acc lsts])
    (if (null? x)
        (reverse acc)
        (rec (cdr x) (cons (car x) (remove-head-permutations (car x) acc))))))
(define (RM-zeros-pos-secondary-iter-rm2 r m)
  (RM-zeros-pos-secondary-iter r (RM-genrows-primary r m)))
(define (assoc-parity-sums gm)
  (RM-zeros-pos-secondary-iter-rm2 (- (log2 (width gm)) (log2 (weight (last (sort-by-weight gm)))))
                                   (log2 (width gm))))
(define (RM-genrows-secondary-iter n pr-r)
  (let* ([wd (width pr-r)]
         [cr-r (map (lambda(x) (bitwise-AND-binary-polys x))
                    ;
                    (map (lambda(x) (collect-elements pr-r x))
                         ;
                         (map (lambda(x) (get-all-matching-pos 1 x)) (gen-nbit-patterns (length pr-r) n)))
                    (all-combinations pr-r n))])
    (group-list (flatten cr-r) wd)))
(define (RM-genrows-secondary-iter-rm n r m)
  (RM-genrows-secondary-iter n (RM-genrows-primary r m)))
(define (RM-group-leading-zeros-gm m)
  (let ([wd (width m)])
    (map (lambda(x)
           (if (not-all-zeros? x)
               (build-list (sub1 (- wd (degree x))) values)
               (build-list (sub1 wd) values))) m)))
(define (RM-group-leading-zeros r m)
  (RM-group-leading-zeros-gm (RM-genrows-primary r m)))
(define (RM-genrows-comb r m)
  (let* ([pr-r (RM-genrows-primary r m)][wd (width pr-r)]
                                        [cr-r (map (lambda(x) (RM-genrows-secondary-iter x pr-r))
                                                   (build-list (sub1 r) (lambda(x) (+ x 2))))])
    (sort-by-degree (group-list (flatten (cons (ones (expt 2 m)) (cons pr-r cr-r))) wd))))
(define (bitwise-AND-binary-polys lst)
  (let rec ([x (cdr lst)][acc (car lst)])(if (cons? x)
                                             (if (not-all-zeros? (car x))
                                                 (rec (cdr x) (bitwise-AND-list (car x) acc))
                                                 (rec '() '(0)))
                                             acc)))
(define (mult-binary-polys lst)
  (let rec ([x (cdr lst)][acc (car lst)])
    (if (cons? x)
        (if (not-all-zeros? (car x))
            (rec (cdr x) (binary-mult-poly (car x) acc))
            (rec '() '(0)))
        acc)))
;(define (combinot-op p op)
; ())
(define (bitwise-AND-list lst1 lst2)
  (map (lambda(x y) (bitwise-and x y)) lst1 lst2))
(define (RM-genrows r m)
  (let* ([all-1s (ones (expt 2 m))]
         [pr-r (RM-genrows-primary r m)]
         [sc-r (RM-genrows-secondary pr-r)])
    (sort-by-degree (cons all-1s (remove-duplicates (append pr-r sc-r))))))
(define (RM-genrows-secondary pr-r)
  (let* ([sc-r (map (lambda(x) (map (lambda(y) (bitwise-AND-list x y)) pr-r)) pr-r)])
    ;(append* (car rows) (cdr rows))
    (sort-by-degree (remove-duplicates (append* (car sc-r) (cdr sc-r))))))


(define (RM-genrows-primary r m)
  (map (lambda(x) (zeros-ones-eql-repeat-seq x (/ (expt 2 m) (* 2 x))))
       (build-list m (lambda(x) (expt 2 x)))))
(define (RM-genrows-primary2 r m)
  (cons (ones (expt 2 m)) (map (lambda(x) (zeros-ones-eql-repeat-seq x (/ (expt 2 m) (* 2 x))))
                               (build-list m (lambda(x) (expt 2 x))))))
(define (RM-genrows2 r m)
  (let ([rows(cons (ones (expt 2 m))
                   (let* ([pr-r (map (lambda(x) (zeros-ones-eql-repeat-seq x (/ (expt 2 m) (* 2 x))))
                                     (build-list m (lambda(x) (expt 2 x))))]
                          ;[pr-r (append* (car pr-r0) (cdr pr-r0))]
                          [sc-r (map (lambda(x) (map (lambda(y) (bitwise-AND-list x y)) pr-r)) pr-r)])
                     (remove-duplicates (append pr-r (append* (car sc-r) (cdr sc-r))))))])
    ;(append* (car rows) (cdr rows))
    (sort-by-degree rows)))
(define (fact n)
  (if (positive? n)
      (apply * (build-list n (lambda(x) (add1 x)))) 1))
(define (weight-enum-n n)
  (cons 1 (map (lambda(r) (/ (fact n) (* (fact r) (fact (- n r))))) (build-list n (lambda(x) (add1 x))))))
(define (all-zeros? lst)
  (zero? (weight lst)))
(define not-all-zeros? (negate all-zeros?))
(define (all-ones? lst)
  (and (cons? lst) (= (length lst) (weight lst))))
(define not-all-ones? (negate all-ones?))
(define (width x) (length (car x)))
(define (add-binary-polys lst)
  (if (null? lst) '()
      (if (null? (cdr lst)) (car lst)
          (map (lambda(x) (parity x)) (transpose lst)))))
(define (add-binary-polys-0 lst)
  (let rec ([x lst][acc '(0)])
    (if (cons? x)
        (if (not-all-zeros? (car x))
            (rec (cdr x) (binary-add-poly (car x) acc))
            (rec (cdr x) acc))
        acc)))
(define (num-error-patterns n e)
  (/ (fact n) (* (fact e) (fact (- n e)))))
(define (num-error-patterns-upto n e)
  (sub1 (apply + (cons 1 (map
                          (lambda(r) (/ (fact n) (* (fact r) (fact (- n r)))))
                          (build-list e (lambda(x) (add1 x))))))))(define (algb-encode-to-file k gn-p out wl)
                                                                    (let rec ([x (info-bits k)][wrt-l '()][n 0])
                                                                      (if (cons? x)
                                                                          (begin
                                                                            (if (= n wl)
                                                                                (begin
                                                                                  (write wrt-l out)
                                                                                  (rec (cdr x) '() 0))
                                                                                (rec (cdr x) (cons (binary-list-2-decimal (binary-mult-poly (car x) gn-p)) wrt-l) (add1 n))))
                                                                          (write wrt-l out))))
(define (cyclic-hamming-encode p)
  (let* ([n (sub1 (expt 2 p))][k (- n p)][g (get-prim-poly p prim-polys-list)])
    (algb-encode k g)))
(define (add-n-bit-noise c r)
  (let* ([n (width c)][res
                       (map (lambda(x) (map (lambda(y) (binary-add-poly x y)) (gen-n-bit-vectors n r))) c)])
    (make-rect-k (append* (car res) (cdr res)) n)))
(define (add-noise-vectors c v)
  (let ([res (map (lambda(x) (add-noise-vector c x)) v)])
    (append* (car res) (cdr res))))
(define (add-noise-vector c v)
  (let* ([n (width c)][res (map (lambda(x) (binary-add-poly x v)) c)])
    (make-rect-k res n)))
(define (cyclic-hamming-decode l p)
  (let* ([n (sub1 (expt 2 p))][k (- n p)][g (get-prim-poly p prim-polys-list)])
    (algb-decode-k l k g)))
(define (estimate-hmg-code-file-size p)
  (let* ([n (sub1 (expt 2 p))][k (- n p)][g (get-prim-poly p prim-polys-list)])
    (* (expt 2 k) (* n 2))))
(define (cyclic-hamming-encode-fo-file p out wl)
  (let* ([n (sub1 (expt 2 p))][k (- n p)][g (get-prim-poly p prim-polys-list)])
    (algb-encode-to-file k g out wl)))
(define (algb-decode-from-file in gn-p k)
  (let rec ([x (read in)][acc '()])
    (if (not (eof-object? x))
        (rec (read in) (cons x acc))
        ;        (cons x acc))))
        (let ([ret (filter (negate (lambda(x) (eof-object? x))) (cons x acc))])
          (append* (car ret) (cdr ret))))))
(define (cyclic-hamming-decode-from-file p in)(let* ([n (sub1 (expt 2 p))][k (- n p)][g (get-prim-poly p prim-polys-list)])
                                                (algb-decode-from-file in g k)))
(define (estimate-opt-hmg-code-file-size p)
  (let* ([n (sub1 (expt 2 p))][k (- n p)][g (get-prim-poly p prim-polys-list)])
    (* (expt 2 k) 5)))
(define (cyclic-hmg-genmat p)
  (let* ([n (sub1 (expt 2 p))][k (- n p)][fill-func (lambda(x) 0)]
                              [g-base (list (flatten (cons (get-prim-poly p prim-polys-list)
                                                           (build-list (sub1 k) fill-func))))])
    (let rec ([l (sub1 k)][acc g-base])
      (if (= l 0)
          (reverse acc)
          (rec (sub1 l) (cons (cyclic-right-shift (car g-base) (- k l)) acc))))))
(define (cyclic-genmat g)
  (let* ([p (degree g)][n (sub1 (expt 2 p))][k (- n p)][fill-func (lambda(x) 0)]
                       [g-base (list (flatten (cons g
                                                    (build-list (sub1 k) fill-func))))])
    (let rec ([l (sub1 k)][acc g-base])
      (if (= l 0)
          (reverse acc)
          (rec (sub1 l) (cons (cyclic-right-shift (car g-base) (- k l)) acc))))))
(define (cyclic-genmat-n n g)
  (let* ([p (degree g)][k (- n p)][fill-func (lambda(x) 0)]
                       [g-base (list (flatten (cons g
                                                    (build-list (sub1 k) fill-func))))])
    (let rec ([l (sub1 k)][acc g-base])
      (if (= l 0)
          (reverse acc)
          (rec (sub1 l) (cons (cyclic-right-shift (car g-base) (- k l)) acc))))))
(define (cyclic-genmat-k k g)
  (let* ([p (degree g)][n (+ k p)][fill-func (lambda(x) 0)]
                       [g-base (list (flatten (cons g
                                                    (build-list (sub1 k) fill-func))))])
    (let rec ([l (sub1 k)][acc g-base])
      (if (= l 0)
          (reverse acc)
          (rec (sub1 l) (cons (cyclic-right-shift (car g-base) (- k l)) acc))))))
(define (encode-linear-code gm) (binary-mat-mult (info-bits (length gm)) gm))
(define (encode-linear-code-k k g) (binary-mat-mult (info-bits k) (cyclic-genmat-k k g)))
(define (encode-linear-code-l l gm) (binary-mat-mult (make-rect-k l (length gm)) gm))(define (encode-linear-code-b b gm) (binary-mat-mult (make-rect-k (info-bits b) (length gm)) gm))
(define (is-systematic?-2 m)
  (equal? (submatrix m (length m) (length m)) (idn-mat (length m))))
(define (encode-linear-code2 gm)
  (let* ([k (length gm)][n (width gm)][p-m (sub-mat gm 0 k k n)][i (info-bits k)])
    (if (is-systematic?-2 gm)
        (weave-padded i (binary-mat-mult i p-m))
        (binary-mat-mult (info-bits k) gm))))
(define (encode-cyclic-hmg g)
  (let* ([p (degree g)][n (sub1 (expt 2 p))][k (- n p)])
    (encode-linear-code-k k g)))
(define (encode-linear-code2-k k g) (binary-mat-mult (info-bits k) (cyclic-genmat-k k g)))
(define (encode-linear-code2-l l gm) (binary-mat-mult (make-rect-k l (length gm)) gm))
(define (is-code-identical? l1 l2)
  (equal? (sort (map(lambda(x) (binary-list-2-decimal x)) l1) <)
          (sort (map(lambda(x) (binary-list-2-decimal x)) l2) <)))
(define (is-code-identical?-gm gm1 gm2)
  (equal? (sort (map(lambda(x) (binary-list-2-decimal x)) (encode-linear-code gm1)) <)
          (sort (map(lambda(x) (binary-list-2-decimal x)) (encode-linear-code gm2)) <)))
(define (sorted-decimal-list l)
  (sort (map (lambda(x) (binary-list-2-decimal x)) l) <))
(define (split-as-rect lst n)
  (let rec ([acc (list (take lst n))] [t (drop lst n)])
    (if (cons? t)
        (rec (cons (take t n) acc) (drop t n))
        (reverse acc))))
(define (kronecker-interleave m)
  (append
   (group-list (flatten (weave (list-ref m 0) (list-ref m 1)))
               (/ (sqrt (length (flatten m))) 1))
   (group-list (flatten (weave (group-list (list-ref m 2)
                                           (sqrt (length (list-ref m 2))))
                               (list-ref m 3))) (/ (sqrt (length (flatten m))) 1))))
;
(define (kronecker-filter-rows mx r m)
  (let* ([l (width mx)][d (log2 l)]
                       [ret (map (lambda(x)
                                   (filter (lambda(y) (= x (weight y))) mx))
                                 (build-list (add1 (- m r)) (lambda(x) (expt 2 (+ x r)))))])(reverse (append* (car ret) (cdr ret)))))
(define (kronecker-filter-rows2 mx r m)
  (filter-by-more-than-or-equal-weight (expt 2 (- m r)) mx))

(define (kronecker-mat d)
  (let rec ([n d])
    (if (= n 1)
        (list '(1 1) '(0 1))
        (kronecker-interleave
         (list (rec (sub1 n)) (rec (sub1 n))
               (build-list (expt 4 (sub1 n)) (lambda(x) 0)) (rec (sub1 n)))))))
(define (kronecker-generic-mat m d)
  (let rec ([n d])
    (if (= n 1)
        m
        (let* ([mf (flatten m)][zf (zeros (length mf))])
          ;(kronecker-interleave
          (list (for/list ([i (in-range (length (flatten m)))])
                  (if (zero? (list-ref (flatten m) i)) (group-list zf (width m)) m)))))))
(define (kronecker-generic-interleave m)
  (append(group-list (flatten (weave (list-ref m 0) (list-ref m 1)))
                     (/ (sqrt (length (flatten m))) 1))
         (group-list (flatten (weave (group-list (list-ref m 2)
                                                 (sqrt (length (list-ref m 2))))
                                     (list-ref m 3))) (/ (sqrt (length (flatten m))) 1))))
(define (reed-muller-gen-km r m)
  (kronecker-filter-rows (kronecker-mat m) r m))
(define (reed-muller-gen-km2 r m)
  (kronecker-filter-rows2 (kronecker-mat m) r m))
(define (form-RM-parity-sums2 r m)
  (form-parity-sums (reed-muller-gen-km r m)))
(define (form-parity-sums m)
  (let* ([wd-x (width m)])
    (let rec ([x m][acc '()])
      (if (cons? x)
          (rec (cdr x) (cons (/ (- wd-x (weight (car x))) (weight (car x))) acc))
          (reverse acc)))))
(define (RM-all-cw-gen r m)
  (let ([g (reed-muller-gen-km r m)])
    (encode-linear-code (info-bits (length g)) g)))
(define (filter-by-runs-ele r m)
  (filter (lambda(x) (= r (cdr x))) m))
(define (filter-by-runs-ele-k r k)
  (filter (lambda(x) (= r (cdr x))) (runs-list-k k)))
(define (runs-list m)
  (let ([rl-l (map (lambda(x) (cons x (length (filter positive? (runs x))))) m)])
    rl-l))
(define (runs lst)
  (let rec ([x (remove-leading-zeros lst)][acc (build-list (add1 (length lst)) zeros)])
    (if (null? x)
        acc
        (let-values ([(n t) (first-run x)])
          (rec t (append (append (take acc n) (list (add1 (list-ref acc n)))) (drop acc (add1 n))))))))
(define (first-run lst)
  (let rec ([x (remove-leading-zeros lst)][n 0])
    (if (null? x)
        (values n x)
        (if (= 1 (car x))
            (rec (cdr x) (add1 n))(values n x)))))
(define (max-ele-w k w)
  (max-runs-ele (runs-list (gen-n-bit-vectors k w))))
(define (max-ele k)
  (max-runs-ele (runs-list (info-bits k))))
(define (runs-list-k k)
  (runs-list (info-bits k)))
(define (cyclic-shift-mat lst)
  (append (list lst) (map (lambda(x) (cyclic-left-shift lst x))
                          (build-list (sub1 (length lst)) (lambda(x) (add1 x))))))
(define (cyclic-shift-mat2 lst)
  (let rec ([x lst][k (length lst)][acc '()])
    (if (= k 0)
        (reverse acc)
        (rec (cyclic-right-shift x 1) (sub1 k) (cons (cyclic-right-shift x 1) acc)))))
(define (min-dist-mat m)
  (let rec ([x m][acc '()])
    (if (null? x)
        acc
        (let rec-i ([y m][acc-i '()])
          (if (null? y)
              (rec (cdr x) (cons acc-i acc))
              (rec-i (cdr y) (cons (weight (binary-add-poly (car x) (car y))) acc-i)))))))
(define (min-dist-gm0 gm)
  (min-dist (encode-linear-code gm)))
(define (min-dist m)
  (car (filter positive? (sort (flatten (min-dist-mat m)) <))))
(define (min-dist2-gm gm)
  (min-dist2 (encode-linear-code gm)))
(define (min-dist2 m)
  (let ([w-e (weight-enum m)])
    (if (and (cons? (cdr w-e)) (filter positive? (cdr w-e)))
        (let rec ([x (cdr w-e)][i 1])
          (if (positive? (car x))
              i
              (rec (cdr x) (add1 i)))) #f)))
(define (LB-parity-norm lst p min-p)
  (let ([l (transpose (take (cyclic-shift-mat lst) p))])(let rec ([x l])
                                                          (if (null? x)
                                                              (transpose l)
                                                              (if (>= (weight (car x)) min-p)
                                                                  (rec (cdr x))
                                                                  #f)))))
(define (max-runs-ele n)
  (let rec ([l 0][r 1][acc '()])
    (if (>= (length acc) n)
        (take (reverse (flatten acc)) n)
        (if (even? l)
            (rec (add1 l) (add1 r) (cons (build-list r (lambda(y) 1)) acc))
            (rec (add1 l) r (cons 0 acc))))))


(define (sub-mat m r1 r2 c1 c2)
  (map (lambda(x) (take (drop x c1) (- c2 c1))) (take (drop m r1) (- r2 r1))))
(define (systematic-hmg-gm p) (systematize-cyclic-matrix2 (cyclic-hmg-genmat p)))
(define (systematic-hmg-gm-k p k) (systematize-cyclic-matrix2 (cyclic-genmat-k k (get-prim-poly p
                                                                                                prim-polys-list))))
(define (systematic-hmg-gm-n n k) (systematize-cyclic-matrix2 (cyclic-genmat-k k (get-prim-poly
                                                                                  (- n k) prim-polys-list))))
(define (systematic-gm g) (systematize-cyclic-matrix2 (cyclic-genmat g)))
(define (systematic-gm-n n g) (systematize-cyclic-matrix2 (cyclic-genmat-n n g)))
(define (min-dist-g g)
  (min-dist2 (encode-linear-code (systematic-gm g))))
(define (min-dist-n n g)
  (min-dist2 (encode-linear-code (systematic-gm-n n g))))
(define (error-correct-level? m t)
  (zero? (apply + (cdr (weight-enum (filter-by-less-than-or-equal-weight (* t 2) m))))))
(define (error-detect-level? m t)
  (zero? (apply + (cdr (weight-enum (filter-by-less-than-or-equal-weight t m))))))(define (get-parity-mat-g n g)
                                                                                    (let-values ([(q r) (binary-poly-long-div (flatten (cons
                                                                                                                                        (cons 1 (build-list (sub1 n) (lambda(x) (- x x)))) '(1))) g)])
                                                                                      (systematic-gm-n n (reverse q))))
(define (get-prim-poly2 n)
  (map (lambda(x) (remove-leading-zeros (octal-number-2-binary-list x)))
       (filter (lambda(y) (= n (degree (octal-number-2-binary-list y)))) prim-polys-list)))
(define (get-parity-mat-p n p)
  (get-parity-mat-g n (get-prim-poly p prim-polys-list)))
(define (get-parity-mat-m gm)
  (let* ([n (width gm)][k (length gm)][p (- n k)])
    (transpose (append (idn-mat p) (sub-mat gm 0 k k n)))))
(define (null-space-prod-m gm)
  (binary-mat-mult gm (transpose (get-parity-mat-m gm))))
(define (null-space-prod g)
  (let ([gm (systematic-gm g)])
    (binary-mat-mult gm (transpose (get-parity-mat-m gm)))))
(define (null-space-prod-n n g)
  (let ([gm (systematic-gm-n n g)])
    (binary-mat-mult gm (transpose (get-parity-mat-m gm)))))
(define (syndrome-decode-gm lst gm)
  (binary-mat-mult lst (transpose (get-parity-mat-m gm))))
(define (syndrome-decode-check lst gm)
  (null? (filter positive? (flatten (binary-mat-mult lst (transpose (get-parity-mat-m gm)))))))
(define (flip-leading-bit lst)
  (if (cons? lst)
      (cons (modulo (add1 (car lst)) 2) (cdr lst))
      lst))
(define (flip-nth-bit lst n)
  (if (= n 0)
      (flip-leading-bit lst)
      (if (cons? lst)
          (cyclic-right-shift (flip-leading-bit (cyclic-left-shift lst n)) n)
          lst)))
(define (flip-nth-bits lst n-l)
  (car (make-rect-k (list (add-binary-polys (map (lambda(x) (flip-nth-bit lst x)) n-l))) (length lst))))(define (flip-leading-bit-if-error lst b)
                                                                                                          (if (and (cons? lst) ((negate =) b (car lst)))
                                                                                                              (cons (modulo (add1 (car lst)) 2) (cdr lst))
                                                                                                              lst))
(define (flip-nth-bit-if-error lst b n)
  (if (= n 0)
      (flip-leading-bit-if-error lst b)
      (if (and (cons? lst) ((negate =) b (list-ref lst n)))
          (cyclic-right-shift (flip-leading-bit-if-error (cyclic-left-shift lst n) b) n)
          lst)))
(define (flip-bits-if-error lst bp-l b-l)
  (let rec ([x bp-l][y b-l][acc lst])
    (if (cons? x)
        (rec (cdr x) (cdr y) (flip-nth-bit-if-error acc (car y) (car x)))
        acc)))
(define (syndrome-error-correct lst gm)
  (let ([s-l (syndrome-decode-gm (gen-1bit-vec (width lst)) gm)])
    (let rec ([x lst][acc '()])
      (if (null? x)
          (reverse acc)
          (let* ([r (car x)][e (car (syndrome-decode-gm (list r) gm))])
            (if (zero? (binary-list-2-decimal e))
                (rec (cdr x) (cons r acc))
                (let* ([s (member e s-l)])
                  (if s
                      (rec (cdr x) (cons (flip-nth-bit (car x) (- (length s-l) (length s))) acc))
                      (rec (cdr x) (cons (car x) acc))))))))))
(define (systematic-LB-gm7 n k v)
  (let* ([p (- n k)][pm (LB-parity-norm (max-runs-ele k) p 2)])
    (if (and (cons? pm) (null? (filter false? (flatten pm))))
        (transpose (append (idn-mat k) (reverse (remove-duplicates pm))))
        #f)))
(define (add-orth-row2 lst)
  (if (null? (cdr lst))
      lst
      (let ([res (filter (lambda(l) (= (degree l) (degree (cdr (remove-leading-zeros (car lst))))))
                         (cdr (map (lambda(l) (remove-leading-zeros l)) lst)))])
        (if (cons? res)
            (cons (binary-add-poly (car res) (car lst)) (cdr lst))
            lst))))
(define (systematize-top-row lst k)
  (let rec ([x (car lst)] [acc (cdr lst)])
    (let-values ([(h t) (split-at x k)])(if (= (binary-list-2-decimal h) (expt 2 (sub1 k)))
                                            (cons x acc)
                                            (let ([res (add-orth-row2 (cons x acc))])
                                              (if (and (cons? res) ((negate equal?) lst res))
                                                  (rec (car res) acc)
                                                  lst))))))
(define (systematize-matrix m)
  (let ([k (length m)])
    (let rec ([x m][i k][acc '()])
      (if (= i 0)
          (make-rect (reverse acc))
          (rec (cdr x) (sub1 i) (cons (car (systematize-top-row x i)) acc))))))
(define (systematic-LB-gm n k)
  (append (idn-mat k) (gen-n-bit-vectors (- n k) (sub1 (- n k)))))
(define (systematic-LB-gm-t k t)
  (transpose (append (idn-mat k) (make-rect-k (gen-n-bit-vectors k (- k t)) k))))
(define (check-cyclicity-g n g) (check-cyclicity (encode-linear-code (cyclic-genmat-n n g))))
(define (pad-matrix-rows m n)
  (append m (build-list (- n (length m)) (lambda(x) (build-list (width m) (lambda(y) 0))))))
(define (pad-matrix-cols m n)
  (let ([mt (transpose m)])
    (transpose (append mt (build-list (- n (length mt)) (lambda(x) (build-list (width mt) (lambda(y)
                                                                                            0))))))))
(define (pad-matrix m n k)
  (pad-matrix-cols (pad-matrix-rows m k) n))
(define (square-matrix? m)
  (= (length m) (width m)))
(define (weave-padded m1 m2)
  (let ([l1 (length m1)] [l2 (length m2)])
    (let ([w-m (if (longer m1 m2)
                   (weave m1 (pad-matrix-rows m2 l1))
                   (if (longer m2 m1)
                       (weave (pad-matrix-rows m1 l2) m2)
                       (weave m1 m2)))])
      (group-list (flatten w-m) (+ (width w-m) (length (cadr w-m)))))))
(define (U-V-constr g1 g2)
  (append (weave-padded g1 g1)
          (weave-padded (list (build-list (- (* 2 (width g1))
                                             (width g2)) (lambda(x) 0))) g2)))(define (RM-gen-UV r m)
                                                                                (let rec ([l1 r][l2 m])
                                                                                  (if (or (= l1 l2) (= l1 1))
                                                                                      (reed-muller-gen-km2 l1 l2)
                                                                                      (U-V-constr (rec l1 (sub1 l2)) (rec (sub1 l1) (sub1 l2))))))
(define (U-V-RM-constr g1 g2)
  (append (weave-RM g1 g1)
          (weave-RM (list (build-list (- (* 2 (width g1))
                                         (width g2)) (lambda(x) 0))) g2)))
(define (weave-RM m1 m2)
  (let ([l1 (length m1)] [l2 (length m2)])
    (let ([w-m (weave (pad-matrix-rows m1 l2) m2)])
      (group-list (flatten w-m) (+ (width w-m) (length (cadr w-m)))))))
(define (get-first-n-matching-pos n v lst)
  (let rec ([p 0][np 0][acc '()])
    (if (or (= p (length lst)) (= np n))
        (reverse acc)
        (if (equal? v (list-ref lst p))
            (rec (add1 p) (add1 np) (cons p acc))
            (rec (add1 p) np acc)))))
(define (get-all-matching-pos v lst)
  (let rec ([x lst][i 0][acc '()])
    (if (null? x)
        (reverse acc)
        (if (equal? v (car x))
            (rec (cdr x) (add1 i) (cons i acc))
            (rec (cdr x) (add1 i) acc)))))
(define (get-all-matching-pos2 v lst)
  (let ([np (length (filter (lambda(x) (= x v)) lst))])
    (get-first-n-matching-pos np v lst)))
(define (get-all-matching-pos3 v lst)
  (let rec ([p 0][np 0][acc '()])
    (if (= p (length lst))
        (reverse acc)
        (if (equal? v (list-ref lst p))
            (rec (add1 p) (add1 np) (cons p acc))
            (rec (add1 p) np acc)))))
(define (get-all-matching-pos-lists v lsts)
  (map (lambda(x) (get-all-matching-pos v x)) lsts))(define (get-all-matching-pos-patterns v n r)
                                                      (map (lambda(x) (get-all-matching-pos v x)) (gen-nbit-patterns2 n r)))
(define (form-RM-parity-sums r m)
  (form-parity-sums (RM-genmat r m)))
(define (form-RM-parity-groups m)
  (map (lambda(x) (group-list x (weight x))) m))
(define (all-combinations lst r)
  (remove-duplicates (collect-elements-lists lst (get-all-matching-pos-patterns 1 (length lst) r))))
(define (form-RM-parity-groups-RM r m)
  (form-RM-parity-groups (RM-genmat r m)))
(define (group-all-zeros-parity-groups m)
  (let*-values ([(all1 n-all1) (values (filter all-ones? m) (filter not-all-ones? m))]
                [(w) (weight (car n-all1))][(zl) (- (width n-all1) w)])
    (values all1 n-all1 w zl)))
(define (group-all-zeros-parity-groups-RM r m)
  (let ([gm (RM-genmat r m)])
    (group-all-zeros-parity-groups gm)))
(define (gen-RM-patterns l)
  (make-rect-k (build-list (sub1 l) (lambda(x) (binary-add-poly
                                                (build-list l (lambda(x) 1))
                                                (build-list (add1 x) (lambda(x) 1))))) l))
(define (assoc-parity-sums2 gm)
  (let* ([ps (form-parity-sums gm)])
    (let rec ([x gm][y (filter positive? ps)][acc '()])
      (if (null? x)
          (reverse acc)
          (if (all-ones? (car x))
              (group-list (get-all-matching-pos 1 (car x)) 1)
              (let ([pos-0s (get-all-matching-pos 0 (car x))][pos-1s (get-all-matching-pos 1 (car x))])
                (let rec1 ([p0 (group-list pos-0s (car y))][p1 pos-1s][acc1 '()])
                  (if (cons? p1)
                      (rec1 (cdr p0) (cdr p1) (cons (append (car p0) (list (car p1))) acc1))
                      (rec (cdr x) (cdr y) (cons (reverse acc1) acc))))))))))
(define (assoc-parity-sums1 gm)
  (let* ([ps (form-parity-sums gm)])
    (let rec ([x gm][y (filter positive? ps)][acc '()][w4-ps RM-24-w4-zeros][w2-ps RM-34-w2-zeros])
      (if (null? x)
          (reverse acc)
          (if (= 4 (weight (car x)))
              (rec (cdr x) (cdr y) (cons (car w4-ps) acc) (cdr w4-ps) w2-ps)(if (= 2 (weight (car x)))
                                                                                (rec (cdr x) (cdr y) (cons (car w2-ps) acc) w4-ps (cdr w2-ps))
                                                                                (if (all-ones? (car x))
                                                                                    (group-list (get-all-matching-pos 1 (car x)) 1)
                                                                                    (let ([pos-0s (get-all-matching-pos 0 (car x))][pos-1s (get-all-matching-pos 1 (car x))])
                                                                                      (let rec1 ([p0 (group-list pos-0s (car y))][p1 pos-1s][acc1 '()])
                                                                                        (if (cons? p1)
                                                                                            (rec1 (cdr p0) (cdr p1) (cons (append (car p0) (list (car p1))) acc1))
                                                                                            (rec (cdr x) (cdr y) (cons (reverse acc1) acc) w4-ps w2-ps)))))))))))
(define (RM-genmat r m) (RM-gen-UV r m))
(define (assoc-RM-parity-sums-gm gm)
  (let* ([not-all-1s (filter not-all-ones? gm)])
    (cons (build-list (width gm) (lambda(x) (list x))) (assoc-parity-sums not-all-1s))))
(define (all-non1-rows-check-sums gm)
  (map (lambda(y) (map (lambda(x) (add-parity-sums x y)) gm)) (assoc-RM-parity-sums-gm gm)))
(define (all-non1-rows-check-sums-by-weight gm)
  (map (lambda(x) (all-non1-rows-check-sums x)) (group-RM-gm-by-weight-gm (filter not-all-ones?
                                                                                  gm))))
(define (all-non1-rows-check-sums-by-weight-RM r m)
  (map (lambda(x) (all-non1-rows-check-sums x)) (group-RM-gm-by-weight-gm (filter not-all-ones?
                                                                                  (RM-genmat r m)))))
(define (assoc-RM-parity-sums r m)
  (let* ([gm (RM-genmat r m)][not-all-1s (cdr gm)])
    (cons (build-list (width gm) (lambda(x) (list x))) (assoc-parity-sums not-all-1s))))
(define (assoc-RM-parity-sums2 r m)
  (reverse (assoc-parity-sums (cdr (RM-gen-UV r m)))))
(define (RM-info-bits-length r m)
  (length (RM-gen-UV r m)))
(define (RM-info-bits-lengths rmin rmax mmin mmax)
  (for*/list ([r (in-range rmin mmin)][m (in-range mmin mmax)])
    (RM-info-bits-length r m)))
(define (MLD-decode lst)
  (if (< (length (filter zero? lst)) (length (filter positive? lst))) 1 0))
(define (collect-elements lst in-l)
  (let rec ([x in-l][acc '()])
    (if (null? x)(reverse acc)
        (rec (cdr x) (cons (list-ref lst (car x)) acc)))))
(define (collect-elements-lists lst in-ls)
  (let rec ([x in-ls][acc '()])
    (if (null? x)
        (reverse acc)
        (rec (cdr x) (cons (collect-elements lst (car x)) acc)))))
(define (add-parity-sums lst in-ls)
  (let rec ([x (collect-elements-lists lst in-ls)][acc '()])
    (if (null? x)
        (reverse acc)
        (rec (cdr x) (cons (parity (car x)) acc)))))
(define (group-by-all-possible-weights m)
  (map (lambda(x) (filter-by-weight x m)) (build-list (add1 (width m)) values)))
(define (group-RM-by-all-possible-weights r m)
  (let ([gm (RM-genmat r m)])
    (map (lambda(x) (filter-by-weight x gm)) (build-list (add1 (width gm)) values))))
(define (group-by-weight m w-l)
  (map (lambda(x) (filter-by-weight x m)) w-l))
(define (group-RM-gm-by-weight2 r m)
  (let ([res (filter cons? (group-by-weight (RM-genmat r m) (build-list m (lambda(x) (expt 2 (+ (- m r)
                                                                                                x))))))])
    (append* (car res) (cdr res))))
(define (group-RM-gm-by-weight r m)
  (filter cons? (group-by-weight (RM-genmat r m) (build-list m (lambda(x) (expt 2 (+ (- m r) x)))))))
(define (group-RM-gm-by-weight-gm gm)
  (let ([r (log2 (weight (last (sort-by-weight gm))))][m (log2 (width gm))])
    (filter cons? (group-by-weight gm (build-list m (lambda(x) (expt 2 (+ (- m r) x))))))))
(define (RM-weight-enum r m)
  (weight-enum (RM-genmat r m)))
(define (get-matching-row-RM-code-bit lst gm)
  (get-all-matching-pos lst gm))
(define (get-all-matching-RM-code-bits lsts gm)
  (map (lambda(x) (get-matching-row-RM-code-bit x gm)) lsts))
(define (get-all-matching-RM-code-bits-by-weight-gm gm)
  (flatten (map (lambda(x) (get-all-matching-RM-code-bits x gm)) (group-RM-gm-by-weight-gm gm))))
(define (get-all-matching-RM-code-bits-by-weight r m)
  (get-all-matching-RM-code-bits-by-weight-gm (RM-genmat r m)))
(define (RM-code-bits-by-weight gm)
  (let ([gm-w (group-RM-gm-by-weight-gm gm)])
    (values gm-w (map (lambda(x) (flatten (get-all-matching-RM-code-bits x gm))) gm-w))))
(define (MLD-row v r-l)
  (MLD-decode (add-parity-sums v (car (assoc-parity-sums r-l)))))
(define (RM-MLD-iter v pc-l)
  (map (lambda(x) (list (MLD-decode (add-parity-sums v x)))) pc-l))
;(define (RM-MLD-iter v r-l)
; (reverse (map (lambda(x) (list (MLD-decode (add-parity-sums v x)))) (assoc-parity-sums r-l))))
(define (MLD-error-correct-iter gm v r-l pc-l)
  (let* ([b-l (RM-MLD-iter v pc-l)])
    (values (flatten b-l)
            (flatten (make-rect-k (list (add-binary-polys (cons v (map binary-mult-poly b-l r-l)))) (width
                                                                                                     gm))))))
(define (decode-RM-vector v gm)
  (let*-values ([(gm-w-pos bp-pos) (RM-code-bits-by-weight gm)]
                [(pb-pos-w) (assoc-parity-sums gm)])
    (let rec ([gm-w gm-w-pos][pb-w pb-pos-w][vi v][iv '()])
      (if (cons? gm-w)
          (if (all-ones? (caar gm-w))
              (rec (cdr gm-w)
                (cdr pb-w)
                (binary-add-poly vi (binary-mult-poly (list (MLD-decode vi)) (caar gm-w)))
                (cons (MLD-decode vi) iv))
              (let-values ([(y x)
                            (MLD-error-correct-iter gm vi (car gm-w) (car pb-w))])
                (rec (cdr gm-w) (cdr pb-w) x (cons y iv))))
          (flip-bits-if-error (build-list (length gm) (lambda(z) 1))
                              (flatten bp-pos) (flatten (reverse iv)))
          ;(flatten iv)
          ))))
(define (decode-RM-vectors m gm)
  (map (lambda(x) (decode-RM-vector x gm)) m))
(define (degrees-list m)
  (let ([rl-l (map (lambda(x) (cons x (length (filter positive? (runs x))))) m)])
    rl-l))
(define (sort-by-runs-ele r m)
  (sort (map (lambda(x) (= r (cdr x))) m) <))
(define (sort-by-runs-ele-k r k)
  (sort (runs-list-k k) (lambda(x y) (> (degree x) (degree y)))))
(define (sort-by-degree m)
  (sort m (lambda(x y) (> (degree x) (degree y)))))
(define (sort-by-length m)
  (sort m (lambda(x y) (> (length x) (length y)))))
(define (reverse-sort-by-degree m)
  (reverse (sort-by-degree m)))
(define (sort-by-weight m)
  (sort m (lambda(x y) (> (weight x) (weight y)))))
(define (degree-list m)
  (map (lambda(x) (degree x)) m))
(define (is-degree-continuous? m)
  (equal? (build-list (length m) (lambda(x) (+ x (add1 (- (degree (car m)) (length m))))))
          (reverse (degree-list m))))
(define (sorted-rm-gen r m) (sort-by-degree (reed-muller-gen-km r m)))
(define (RM-degree-list r m)(degree-list (sorted-rm-gen r m)))
(define (get-missing-elements l1 l2)
  (let rec ([x l1][acc '()])
    (if (cons? x)
        (if (member (car x) l2)
            (rec (cdr x) acc)
            (rec (cdr x) (cons (car x) acc)))
        acc)))
(define (get-swappable-cols2 m)
  (map (lambda(x) (sub1 (- (width m) x)))
       (get-missing-elements (build-list (add1 (- (degree (first m)) (degree (last m))))
                                         (lambda(x) (+ x (degree (last m))))) (degree-list m))))
(define (get-col m n)
  (list-ref (transpose m) n))
(define (get-swappable-cols m)
  (let rec ([r 2][acc '()][ms m])
    (if (> r (length ms))
        (values ms acc)
        (if (is-degree-continuous? (take ms r))
            (rec (add1 r) acc ms)
            (let* ([sw-c1 (- (width ms) (degree (list-ref ms (- r 2))))]
                   [sw-c2 (sub1 (- (width ms) (degree (list-ref ms (sub1 r)))))]
                   [x (interchange-cols ms sw-c1 sw-c2)])
              (rec (add1 r) (cons (cons sw-c1 sw-c2) acc) x))))))
(define (interchange-cols-l m lc)
  (let rec ([x m][cols lc])
    (if (null? cols)
        x
        (rec (interchange-cols x (caar cols) (cdar cols)) (cdr cols)))))
(define (systematic-RM-gen r m)
  (let-values ([(sm smc) (get-swappable-cols (RM-gen-UV r m))])
    (values (systematize-matrix sm) smc)))
(define (encode-RM-all-cw r m)
  (let ([gm (RM-genmat r m)])
    (encode-linear-code gm)))
(define (encode-RM-code-l lst r m)
  (let ([gm (RM-genmat r m)])
    (encode-linear-code-l lst gm)))
(define (encode-RM-code-b b r m)
  (let ([gm (RM-genmat r m)])(encode-linear-code-b b gm)))
(define (regroup-list lst l)
  (group-list (flatten lst) l))
(provide prim-polys-list)
(provide/contract
 [binary-qut (binary-list/c binary-list/c . -> . binary-list/c)]
 [binary-rem (binary-list/c binary-list/c . -> . binary-list/c)]
 [log2 (natural-number/c . -> . natural-number/c)]
 [group-list ((listof any/c) natural-number/c . -> . (listof any/c))]
 [ones-cmpl (binary-list/c . -> . binary-list/c)]
 [octal-digit-2-binary-list (octal/c . -> . binary-list/c)] ;x)
 [octal-number-2-binary-list ((listof octal/c) . -> . binary-list/c)]; x)
 [decimal-2-binary-list (natural-number/c . -> . binary-list/c)];lst)
 [binary-list-2-decimal (binary-list/c . -> . natural-number/c)];lst)
 [parity (binary-list/c . -> . binary/c)]
 [isprim? (binary-list/c . -> . boolean?)];x)
 [cyclic-left-shift (->d ([m (listof any/c)]
                          [k (and/c positive? (</c (length m)))]) () [result (listof any/c)])];lst n
 [cyclic-right-shift (->d ([m (listof any/c)]
                           [k (and/c positive? (</c (length m)))]) () [result (listof any/c)])];lst n
 [info-bits2 (natural-number/c . -> . binary-lists/c)]
 [info-bits3 (natural-number/c . -> . binary-lists/c)]
 [info-bits1 (natural-number/c . -> . binary-lists/c)]
 [info-bits (natural-number/c . -> . binary-lists/c)]
 [rect-mat-2-poly-list (rectangular-matrix/c . -> . binary-lists/c)]
 [algb-encode (natural-number/c binary-list/c . -> . binary-lists/c)] ;(k gn-p)
 [algb-decode (binary-lists/c binary-list/c . -> . rectangular-matrix/c)] ;(lst gn-p)
 [algb-decode-k (binary-lists/c natural-number/c binary-list/c . -> . rectangular-matrix/c)] ;(lst k gn-p)
 [syndrome-decode (binary-lists/c binary-lists/c . -> . binary-lists/c)];lst gn-p)
 [get-prim-poly (natural-number/c (listof any/c) . -> . binary-list/c)];n lst)
 [get-prim-poly-list (natural-number/c (listof any/c) . -> . binary-lists/c)]
 [gen-1bit-vec (natural-number/c . -> . binary-lists/c)];n)
 [check-cyclicity (rectangular-matrix/c . -> . boolean?)];lst n)
 [check-additive-closure (binary-lists/c . -> . boolean?)]
 [check-additive-closure-n (binary-lists/c binary-lists/c . -> . boolean?)]
 [is-cyclic? (rectangular-matrix/c . -> . boolean?)]
 [check-cyclicity-by-weight (rectangular-matrix/c natural-number/c . -> . boolean?)]
 [check-n-cyclicity (->d ([m rectangular-matrix/c]
                          [n (and/c positive? (<=/c (sub1 (length (car m)))))]) () [result boolean?])] ;lst n)
 [check-n-cyclicity-by-weight (->d ([m rectangular-matrix/c] [w (and/c positive? (<=/c (sub1 (length
                                                                                              (car m)))))]
                                                             [n (and/c positive? (<=/c (sub1 (length (car m)))))])
                                   () [result boolean?])]
 [weight (binary-list/c . -> . natural-number/c)];lst)[cw-weight-list (binary-lists/c . -> . (listof natural-number/c))];lst)
 [weight-enum ((and/c binary-lists/c rectangular-matrix/c) . -> . (listof natural-number/c))]
 [transpose
  (->d ([m rectangular-matrix/c]) () [r (and/c rectangular-matrix/c
                                               (lambda(x) (= (length x) (length (car m)))))])]
 [mat-mult (->d ([m rectangular-matrix/c]
                 [r (and/c rectangular-matrix/c
                           (lambda(x) (= (length x) (length (car m)))))])
                () [result (and/c rectangular-matrix/c
                                  (lambda(x) (and (= (length x) (length m))
                                                  (= (length (car x)) (length (car r))))))])]
 [add-selected-rows (rectangular-matrix/c binary-list/c . -> . rectangular-matrix/c)]
 [binary-mat-mult (->d ([m rectangular-matrix/c]
                        [r (and/c rectangular-matrix/c
                                  (lambda(x) (= (length x) (length (car m)))))])
                       () [result (and/c rectangular-matrix/c
                                         (lambda(x) (and (= (length x) (length m))
                                                         (= (length (car x)) (length (car r))))))])]
 ;p1 p2)
 )
(provide/contract
 [bin-arr (binary-list/c . -> . binary-list/c)]
 [scale-list (binary-list/c natural-number/c . -> . binary-list/c)] ;(lst n)
 [pad-right ((listof any/c)
             natural-number/c
             (any/c . -> . any/c) . -> . (listof any/c))];(lst n fn)
 [pad-left ((listof any/c)
            natural-number/c
            (any/c . -> . any/c) . -> . (listof any/c))]; (lst n fn)
 [modulo-lst ((listof natural-number/c) natural-number/c . -> . binary-list/c)] ;(lst n)
 ; [longer (list/c natural-number/c . -> . (listof any/c))];(x y)
 [multiply ((listof any/c) (listof any/c) . -> . (listof any/c))];(p1 p2)
 [binary-mult-poly (binary-list/c binary-list/c . -> . binary-list/c)];(p1 p2)[printable-poly ((listof any/c) . -> . (listof any/c))];(p)
 [binary-add-poly (binary-list/c binary-list/c . -> . binary-list/c)] ; (x y)
 [binary-add-poly-N (binary-lists/c . -> . binary-list/c)]
 [remove-leading-zeros ((listof any/c) . -> . (listof any/c))] ;(lst)
 [degree ((listof any/c) . -> . (or/c -1 natural-number/c))] ;()
 [first-binary-remainder (binary-list/c binary-list/c . -> . binary-list/c)] ; (p1 p2)
 [first-binary-qut-term (binary-list/c binary-list/c . -> . binary-list/c)];(p1 p2)
 [nth-binary-qut-term (binary-list/c
                       binary-list/c natural-number/c . -> . binary-list/c)] ; (p1 p2 n)
 [binary-poly-long-div (binary-list/c
                        binary-list/c . -> .
                        (values binary-list/c binary-list/c))] ;(p1 p2)
 [longer (any/c any/c . -> . boolean?)]
 )
(provide/contract
 [add-orth-row (rectangular-matrix/c . -> . rectangular-matrix/c)] ; lst)
 [get-highest-degree ((listof any/c) . -> . natural-number/c)]
 [make-rect ((listof any/c) . -> . rectangular-matrix/c)]
 [make-rect-k ((listof any/c) positive? . -> . rectangular-matrix/c)]
 [is-systematic? (->d ([m rectangular-matrix/c]
                       [k (and/c positive? (<=/c (length m)) (<=/c (length (car m))))]) () [result boolean?])])
(provide/contract
 [systematize-cyclic-top-row (->d ([l binary-lists/c]
                                   [k (and/c natural-number/c
                                             (<=/c (length
                                                    (decimal-2-binary-list
                                                     (car (sort (map (lambda(x) (binary-list-2-decimal x)) l) >))))))])
                                  ()
                                  [r (and/c binary-lists/c
                                            (lambda(x) (= (binary-list-2-decimal
                                                           (take (remove-leading-zeros (car x)) k)) (expt 2 (sub1 k)))))])]
 [systematize-cyclic-matrix (->d ([m (and/c binary-lists/c (lambda(x) (is-cyclic? x)))]
                                  [k (and/c positive? (>/c 1)
                                            (=/c (add1 (- (length
                                                           (decimal-2-binary-list
                                                            (car (sort (map (lambda(x) (binary-list-2-decimal x)) m) >))))
                                                          (length
                                                           (decimal-2-binary-list
                                                            (car (sort (map (lambda(x) (binary-list-2-decimal x)) m)
                                                                       <))))))))])
                                 ()
                                 [r (and/c binary-lists/c (lambda(x) (is-systematic? x k)))])]
 [systematize-cyclic-matrix2 ((and/c binary-lists/c (lambda(x) (is-cyclic? x)))
                              . -> . (and/c binary-lists/c (lambda(x) (is-systematic? x (length x)))))]
 [interchange-rows (rectangular-matrix/c natural-number/c natural-number/c . -> . rectangular-matrix/c)];m r1 r2)
 [interchange-cols (rectangular-matrix/c natural-number/c natural-number/c . -> . rectangular-matrix/c)];m c1 c2)
 [idn-mat (natural-number/c . -> . rectangular-matrix/c)];k)
 [row-subspace (rectangular-matrix/c natural-number/c . -> . rectangular-matrix/c)];m k)
 [col-subspace (rectangular-matrix/c natural-number/c . -> . rectangular-matrix/c)];m k)
 [submatrix (rectangular-matrix/c natural-number/c natural-number/c . -> . rectangular-matrix/c)];m k l)
 [decode-cyclic-cw (binary-lists/c natural-number/c
                                   binary-list/c binary-list/c . -> . binary-lists/c)] ;cw n gp syn)
 [decode-all-cyclic-cw (binary-lists/c binary-lists/c natural-number/c
                                       binary-list/c binary-list/c . -> . (or/c binary-lists/c
                                                                                boolean?))];lst cw-lst n gp syn)
 [gen-n-bit-vectors (natural-number/c natural-number/c . -> . binary-lists/c)] ;n m)
 ; [gen-n-bit-vectors2 (natural-number/c natural-number/c . -> . binary-lists/c)] ;n m)
 [flatten-l2 (any/c . -> . any/c)];lst)
 [binary-element? (natural-number/c . -> . boolean?)]
 [binary-list? ((listof natural-number/c) . -> . boolean?)][decimate (->d ([x (and/c (listof any/c) (lambda(z) (even? (length z))))])
                                                                          ()
                                                                          [r (and/c (listof any/c) (lambda(z) (= (length z)(length x))))])]
 [weave (->d ([x (listof any/c)][y (and/c (listof any/c) (lambda(z) (= (length x)(length z))))])
             ()
             [r (and/c (listof any/c) (lambda(z) (= (length z)(* 2 (length x))))
                       (lambda(z) (equal? (decimate z) (append x y))))])]
 [duplicate (any/c natural-number/c . -> . (listof any/c))]
 [zeros (positive? . -> . any/c)]
 [ones (positive? . -> . any/c)]
 [zeros-ones-seq (positive? positive? . -> . any/c)]
 [ones-zeros-seq (positive? positive? . -> . any/c)]
 [zeros-ones-eql-seq (positive? . -> . any/c)]
 [ones-zeros-eql-seq (positive? . -> . any/c)]
 [zeros-ones-eql-repeat-seq (positive? positive? . -> . any/c)]
 [ones-zeros-eql-repeat-seq (positive? positive? . -> . any/c)]
 )
(provide
 filter-by-less-than-or-equal-degree
 filter-by-more-than-or-equal-degree
 filter-between-degree
 filter-by-less-than-or-equal-weight
 filter-by-more-than-or-equal-weight
 filter-between-weight
 filter-by-weight
 filter-info-bits-by-weight
 )
(provide/contract
 [fact (positive? . -> . positive?)]
 [weight-enum-n (positive? . -> . (listof positive?))]
 [all-zeros? (binary-list/c . -> . boolean?)][not-all-zeros? (binary-list/c . -> . boolean?)]
 [all-ones? (binary-list/c . -> . boolean?)]
 [width (rectangular-matrix/c . -> . positive?)]
 [add-binary-polys (binary-lists/c . -> . binary-list/c)]
 [num-error-patterns (positive? positive? . -> . positive?)]
 [num-error-patterns-upto (positive? positive? . -> . positive?)]
 [algb-encode-to-file (positive? binary-list/c any/c positive? . -> . rectangular-matrix/c)]
 [cyclic-hamming-encode (positive? . -> . rectangular-matrix/c)]
 [add-n-bit-noise (rectangular-matrix/c positive? . -> . rectangular-matrix/c)]
 [add-noise-vector (rectangular-matrix/c binary-list/c . -> . rectangular-matrix/c)]
 [cyclic-hamming-decode (positive? positive? . -> . rectangular-matrix/c)]
 [estimate-hmg-code-file-size (positive? . -> . rectangular-matrix/c)]
 [cyclic-hamming-encode-fo-file (positive? any/c positive? . -> . rectangular-matrix/c)]
 [algb-decode-from-file (any/c binary-list/c positive? . -> . rectangular-matrix/c)]
 [cyclic-hamming-decode-from-file (positive? any/c . -> . rectangular-matrix/c)]
 [estimate-opt-hmg-code-file-size (positive? . -> . rectangular-matrix/c)]
 [cyclic-hmg-genmat (positive? . -> . rectangular-matrix/c)]
 [cyclic-genmat ((listof any/c) . -> . (listof any/c))]
 [cyclic-genmat-n (positive? (listof any/c) . -> . (listof any/c))]
 [cyclic-genmat-k (positive? (listof any/c) . -> . (listof any/c))]
 [encode-linear-code (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [encode-linear-code-k (positive? binary-list/c . -> . rectangular-matrix/c)]
 [encode-linear-code-l (binary-lists/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [encode-linear-code-b (positive? rectangular-matrix/c . -> . rectangular-matrix/c)][is-systematic?-2 (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [encode-linear-code2 (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [encode-cyclic-hmg (binary-list/c . -> . rectangular-matrix/c)]
 [encode-linear-code2-k (positive? binary-list/c . -> . rectangular-matrix/c)]
 [encode-linear-code2-l (binary-lists/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [is-code-identical? (rectangular-matrix/c rectangular-matrix/c . -> . boolean?)]
 [is-code-identical?-gm (rectangular-matrix/c rectangular-matrix/c . -> . boolean?)]
 [sorted-decimal-list (positive? . -> . rectangular-matrix/c)]
 [split-as-rect (binary-list/c positive? . -> . rectangular-matrix/c)]
 [kronecker-interleave ((listof any/c) . -> . (listof any/c))]
 [kronecker-filter-rows (rectangular-matrix/c positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [kronecker-filter-rows2 (rectangular-matrix/c positive? positive? . -> . rectangular-matrix/c)]
 [kronecker-mat (positive? . -> . rectangular-matrix/c)]
 [reed-muller-gen-km (positive? positive? . -> . rectangular-matrix/c)]
 [reed-muller-gen-km2 (positive? positive? . -> . rectangular-matrix/c)]
 [form-RM-parity-sums2 (positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [form-parity-sums (rectangular-matrix/c . -> . lists/c)]
 [RM-all-cw-gen (positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [filter-by-runs-ele (positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [filter-by-runs-ele-k (positive? positive? . -> . rectangular-matrix/c)]
 [runs-list (rectangular-matrix/c . -> . lists/c)]
 [runs (binary-list/c . -> . rectangular-matrix/c)]
 [first-run (binary-list/c . -> . any)]
 [max-ele-w (positive? positive? . -> . rectangular-matrix/c)]
 [max-ele (positive? . -> . rectangular-matrix/c)][runs-list-k (positive? . -> . lists/c)]
 [cyclic-shift-mat ((listof any/c) . -> . (listof any/c))]
 [cyclic-shift-mat2 ((listof any/c) . -> . (listof any/c))]
 [min-dist-mat (rectangular-matrix/c . -> . lists/c)]
 [min-dist (rectangular-matrix/c . -> . natural-number/c)]
 [min-dist-gm0 (rectangular-matrix/c . -> . natural-number/c)]
 [min-dist2 (rectangular-matrix/c . -> . natural-number/c)]
 [LB-parity-norm (binary-list/c positive? positive? . -> . rectangular-matrix/c)]
 [max-runs-ele (positive? . -> . rectangular-matrix/c)]
 ;[filter-by-runs (positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [sub-mat (rectangular-matrix/c natural-number/c natural-number/c
                                natural-number/c natural-number/c . -> . rectangular-matrix/c)]
 [systematic-hmg-gm (positive? . -> . rectangular-matrix/c)]
 [systematic-hmg-gm-k (positive? positive? . -> . rectangular-matrix/c)]
 [systematic-hmg-gm-n (positive? positive? . -> . rectangular-matrix/c)]
 [systematic-gm (binary-list/c . -> . rectangular-matrix/c)]
 [systematic-gm-n (positive? binary-list/c . -> . rectangular-matrix/c)]
 [min-dist-g (binary-list/c . -> . rectangular-matrix/c)]
 [min-dist-n (positive? binary-list/c . -> . rectangular-matrix/c)]
 [error-correct-level? (rectangular-matrix/c positive? . -> . natural-number/c)]
 [error-detect-level? (rectangular-matrix/c positive? . -> . natural-number/c)]
 [get-parity-mat-g (positive? binary-list/c . -> . rectangular-matrix/c)]
 [get-prim-poly2 (positive? . -> . rectangular-matrix/c)]
 [get-parity-mat-p (positive? positive? . -> . rectangular-matrix/c)]
 [get-parity-mat-m (rectangular-matrix/c . -> . rectangular-matrix/c)][null-space-prod-m (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [null-space-prod (binary-list/c . -> . rectangular-matrix/c)]
 [null-space-prod-n (positive? binary-list/c . -> . rectangular-matrix/c)]
 [syndrome-decode-gm (rectangular-matrix/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [syndrome-decode-check (binary-list/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [flip-leading-bit (binary-list/c . -> . rectangular-matrix/c)]
 [flip-nth-bit (binary-list/c natural-number/c . -> . binary-list/c)]
 [flip-leading-bit-if-error (binary-list/c natural-number/c . -> . rectangular-matrix/c)]
 [flip-nth-bit-if-error (binary-list/c natural-number/c positive? . -> . rectangular-matrix/c)]
 [flip-bits-if-error (binary-list/c (listof natural-number/c) binary-list/c . -> . rectangular-matrix/c)]
 [syndrome-error-correct (binary-list/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [systematic-LB-gm7 (positive? positive? binary-list/c . -> . rectangular-matrix/c)]
 [add-orth-row2 (binary-list/c . -> . rectangular-matrix/c)]
 [systematize-top-row (binary-list/c positive? . -> . rectangular-matrix/c)]
 [systematize-matrix (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [systematic-LB-gm (positive? positive? . -> . rectangular-matrix/c)]
 [systematic-LB-gm-t (positive? positive? . -> . rectangular-matrix/c)]
 [check-cyclicity-g (positive? binary-list/c . -> . rectangular-matrix/c)]
 [pad-matrix-rows (rectangular-matrix/c positive? . -> . rectangular-matrix/c)]
 [pad-matrix-cols (rectangular-matrix/c positive? . -> . rectangular-matrix/c)]
 [pad-matrix (rectangular-matrix/c positive? positive? . -> . rectangular-matrix/c)]
 [square-matrix? (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [weave-padded (rectangular-matrix/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [U-V-constr (rectangular-matrix/c rectangular-matrix/c . -> . rectangular-matrix/c)][RM-gen-UV (positive? positive? . -> . rectangular-matrix/c)]
 [U-V-RM-constr (rectangular-matrix/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [weave-RM (rectangular-matrix/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [get-first-n-matching-pos (positive? any/c (listof any/c) . -> . (listof any/c))]
 [get-all-matching-pos3 (any/c any/c . -> . (listof natural-number/c))]
 [get-all-matching-pos2 (any/c any/c . -> . (listof natural-number/c))]
 [get-all-matching-pos (any/c any/c . -> . (listof natural-number/c))]
 [form-RM-parity-sums (positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [form-RM-parity-groups (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [form-RM-parity-groups-RM (positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 
 [assoc-parity-sums (rectangular-matrix/c . -> . lists/c)]
 [RM-genmat (positive? positive? . -> . rectangular-matrix/c)]
 [assoc-RM-parity-sums (positive? positive? . -> . rectangular-matrix/c)]
 [assoc-RM-parity-sums2 (positive? positive? . -> . rectangular-matrix/c)]
 [RM-info-bits-length (positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [RM-info-bits-lengths (positive? positive? positive? positive? . -> . rectangular-matrix/c)]
 [MLD-decode (binary-list/c . -> . rectangular-matrix/c)]
 [collect-elements ((listof any/c) index-list/c . -> . rectangular-matrix/c)]
 [collect-elements-lists (binary-list/c lists/c . -> . rectangular-matrix/c)]
 [add-parity-sums (binary-list/c lists/c . -> . (listof any/c))]
 [group-by-weight (rectangular-matrix/c list/c . -> . rectangular-matrix/c)]
 [group-RM-gm-by-weight (positive? positive? . -> . any/c)]
 [group-RM-gm-by-weight2 (positive? positive? . -> . any/c)][group-RM-gm-by-weight-gm (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [RM-weight-enum (positive? positive? . -> . rectangular-matrix/c)]
 [get-matching-row-RM-code-bit (binary-list/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [get-all-matching-RM-code-bits (lists/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [get-all-matching-RM-code-bits-by-weight-gm (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [get-all-matching-RM-code-bits-by-weight (positive? positive? . -> . rectangular-matrix/c)]
 [RM-code-bits-by-weight (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [MLD-row (binary-list/c lists/c . -> . rectangular-matrix/c)]
 [RM-MLD-iter (binary-list/c lists/c . -> . rectangular-matrix/c)]
 [MLD-error-correct-iter (rectangular-matrix/c binary-list/c lists/c lists/c . -> . rectangular-matrix/c)]
 [decode-RM-vector (binary-list/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [decode-RM-vectors (binary-lists/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 
 [degrees-list (rectangular-matrix/c . -> . list/c)]
 [sort-by-runs-ele (positive? positive? . -> . rectangular-matrix/c)]
 [sort-by-runs-ele-k (positive? positive? . -> . rectangular-matrix/c)]
 [sort-by-degree (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [sort-by-length (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [reverse-sort-by-degree (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [sort-by-weight (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [degree-list (rectangular-matrix/c . -> . index-list/c)][is-degree-continuous? (binary-lists/c . -> . boolean?)]
 [sorted-rm-gen (positive? positive? . -> . rectangular-matrix/c)]
 [RM-degree-list (positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [get-missing-elements (rectangular-matrix/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [get-swappable-cols2 (rectangular-matrix/c . -> . index-list/c)]
 [get-col (rectangular-matrix/c positive? . -> . rectangular-matrix/c)]
 [get-swappable-cols (rectangular-matrix/c . -> . index-list/c)]
 [interchange-cols-l (rectangular-matrix/c lists/c . -> . rectangular-matrix/c)]
 [systematic-RM-gen (positive? positive? . -> . any)]
 [encode-RM-all-cw (positive? positive? . -> . rectangular-matrix/c)]
 [encode-RM-code-l (binary-lists/c positive? positive? . -> . rectangular-matrix/c)]
 [encode-RM-code-b (positive? positive? positive? . -> . rectangular-matrix/c)]
 ;[cyclic-error-correct (positive? rectangular-matrix/c g . -> . rectangular-matrix/c)]
 [regroup-list (lists/c positive? . -> . lists/c)]
 )
(provide/contract
 [RM-check-parity-sums2 (positive? positive? . -> . any/c)]
 [RM-check-parity-sums (positive? positive? . -> . any/c)]
 [gen-random-nbit-patterns (positive? positive? positive? . -> . any/c)]
 [gen-nbit-patterns (positive? positive? . -> . rectangular-matrix/c)]
 [gen-nbit-patterns2 (positive? positive? . -> . rectangular-matrix/c)]
 ;[combinations (lst n . -> . any/c)]
 [flip-matrix-cols (rectangular-matrix/c . -> . any/c)]
 [flip-matrix (rectangular-matrix/c . -> . any/c)]
 [left-submatrix (rectangular-matrix/c positive? . -> . any/c)][right-submatrix (rectangular-matrix/c positive? . -> . any/c)]
 [remove-common (binary-list/c binary-list/c . -> . any/c)]
 [remove-common-from-list (binary-lists/c binary-list/c . -> . any/c)]
 [RM-comb-submat-space (rectangular-matrix/c . -> . any/c)]
 [RM-primary-zeros (positive? positive? . -> . any/c)]
 [RM-zeros-pos-secondary-iter-rm2 (positive? positive? . -> . any/c)]
 [RM-genrows-primary (positive? positive? . -> . any/c)]
 [RM-genrows-primary2 (positive? positive? . -> . any/c)]
 [RM-genrows2 (positive? positive? . -> . any/c)]
 [bitwise-AND-list (binary-list/c binary-list/c . -> . any/c)]
 [RM-genrows (positive? positive? . -> . any/c)]
 [is-permutation? (binary-list/c binary-list/c . -> . any/c)]
 [RM-genrows-secondary-iter-rm (positive? positive? positive? . -> . any/c)]
 [RM-group-leading-zeros-gm (rectangular-matrix/c . -> . any/c)]
 [RM-group-leading-zeros (positive? positive? . -> . any/c)]
 [RM-genrows-comb (positive? positive? . -> . any/c)]
 ;[subrow-space-deci (v d-p . -> . any/c)]
 [remove-common-from-lists (lists/c . -> . any/c)]
 [check-add-parities-by-weight (lists/c lists/c . -> . any/c)]
 [subrow-space (list/c binary-list/c . -> . any/c)]
 [subrow-split (list/c . -> . any/c)]
 ;[RM-subrow-split (v n . -> . any/c)]
 ;[subrow (v s-b . -> . any/c)]
 [subrow (list/c binary-list/c . -> . any/c)][zeros-triangle (positive? . -> . any/c)]
 [ones-triangle (positive? . -> . any/c)]
 [RM-zeros-pos-secondary-iter (positive? rectangular-matrix/c . -> . any/c)]
 [remove-head-permutations (binary-list/c rectangular-matrix/c . -> . any/c)]
 [remove-permutations (rectangular-matrix/c . -> . any/c)]
 [RM-genrows-secondary-iter (positive? rectangular-matrix/c . -> . any/c)]
 [bitwise-AND-binary-polys (binary-list/c . -> . any/c)]
 [mult-binary-polys (binary-lists/c . -> . any/c)]
 ;[combinot-op (p op . -> . any/c)]
 [RM-genrows-secondary (rectangular-matrix/c . -> . any/c)]
 ;[RM-genrows2 (positive? positive? . -> . any/c)]
 [get-all-matching-pos-patterns (any/c positive? positive? . -> . (listof index-list/c))]
 [all-combinations ((listof any/c) positive? . -> . (listof any/c))]
 )



(require plot)
(require racket/gui)
(require racket/serialize)
(define-values (wd ht) (get-display-size))
(define (node-vis
         #:title [title "Binary Search Trees"]
         #:frame-width [fr-wd (- wd 50)]
         #:frame-height [fr-ht (- wd 50)]
         #:cnv-width [cnv-wd (- wd 150)]
         #:cnv-height [cnv-ht (- ht 200)]
         bst-frame canvas)
  (define no-pen (make-object pen% "BLUE" 4 'solid))
  (define no-brush (make-object brush% "BLACK" 'transparent))
  (define blue-brush (make-object brush% "BLUE" 'solid))
  (define yellow-brush (make-object brush% "YELLOW" 'transparent))
  (define red-pen (make-object pen% "RED" 4 'solid))
  (define (draw-node xpos ypos dc text)
    ;(send dc set-pen no-pen)
    ;(send dc set-brush blue-brush)
    (send dc draw-ellipse xpos ypos 5 5)
    (send dc set-brush blue-brush)
    (send dc draw-text text (+ xpos 10) (- ypos 10))
    ;(send dc draw-rectangle xpos ypos 50 50)
    ;(send dc draw-rectangle xpos ypos 50 50)
    (send dc set-brush no-brush)
    (send dc set-pen red-pen)
    ;
    (let ([-pi (atan 0 -1)])
      ;
      (send dc draw-arc 75 75 150 150 (* 5/4 -pi) (* 7/4 -pi)))
    )
  (begin
    (send bst-frame show #t)
    (sleep/yield 0.5)
    ; traverse tree and draw tree(draw-node 1200 920 dc "100, 100")
    )
  title
  )
(define (draw-node xpos ypos dc text)
  (send dc set-pen (make-object pen% "RED" 4 'solid))
  (send dc draw-ellipse xpos ypos 5 5)
  (send dc draw-text text (+ xpos 10) (- ypos 10))
  )
(define-values (fr-wd fr-ht) (get-display-size))
(define frame (new frame% [label "sometghi"] [width fr-wd] [height fr-ht]))
(define canvas (new canvas% [parent frame]))
(define dc (send canvas get-dc))
;(node-vis frame canvas)
(define golay-poly '(1 0 1 0 0 1 1 0 1 1 1))
(define (add-overall-parity-bit gm)
  (transpose (append (transpose gm) (list (ones (length gm))))))
;(define golay-mat (add-overall-parity-bit (cyclic-shift-mat golay-poly)))
(define golay-mat (append (transpose (append (reverse (cyclic-shift-mat golay-poly))
                                             (list (ones (length golay-poly)))))
                          (list (ones (add1 (length golay-poly))))))
(define golay-gm (transpose (append golay-mat (idn-mat 12))))
(define (draw-trellis-path lst)
  (let* ([l (length lst)]
         [n-l-x (build-list l (lambda(x) (* (quotient fr-wd l) (add1 x))))]
         [n-l-y (build-list l (lambda(x) (* (quotient fr-ht l) (add1 x))))])
    (map (lambda(x y z) (draw-node x y dc (number->string z))) n-l-x n-l-y lst)))
(define (sampled-func a fn n k)
  (map (lambda(t) (* a (fn (* (* n t) (* 2 pi))))) (build-list n (lambda(x) (* x (/ 1 (* n k)))))))
(define (vector-dot-prod lst1 lst2)
  (apply + (map (lambda(x y) (* x y)) lst1 lst2)))
(define (is-orthogonal? lst1 lst2)
  (zero? (truncate (vector-dot-prod lst1 lst2))))(define (pair-2-mpair p)
                                                   (cons (first p) (last p)))
(define (list-2-sorted-mpairs lst)
  (map (lambda(x) (pair-2-mpair x)) (map (lambda(x) (sort x <)) (group-list lst 2))))
(define (check-cyclicity-interchage-rand-cols m)
  (check-cyclicity (encode-linear-code (swap-random-cols m))))
(define (check-cyclicity-interchage-rand-all-cols-RM r m)
  (check-cyclicity (swap-random-all-cols (encode-RM-all-cw r m))))
(define (check-cyclicity-interchage-rand-cols-RM r m)
  (check-cyclicity (swap-random-cols (encode-cyclic-RM r m))))
(define (check-cyclic-RM-cyclicity r m)
  (check-cyclicity (encode-cyclic-RM r m)))
(define (make-rect-k-ele m k ele)
  (let* ([l (sub1 k)] [fill-func (lambda(x) (+ 0 ele))])
    (if (>= l 0)
        (let rec ([x (rect-mat-2-poly-list m)] [acc '()])
          (if (null? x)
              (reverse acc)
              (if (cons? (remove-leading-zeros (car x)))
                  (rec (cdr x) (cons (pad-left (car x) (- l (degree (car x))) fill-func) acc))
                  (rec (cdr x) (cons (pad-left (list ele) l fill-func) acc)))))
        m)))
(define (info-bits-b2b-1s b1 b2 n)
  (let* ([ibl (add1 (- b2 b1))][ib (info-bits ibl)])
    (make-rect-k-ele (flip-matrix-cols (make-rect-k-ele (flip-matrix-cols ib) (- n b1) 1)) n 1)))
(define (info-bits-b2b b1 b2 n)
  (let* ([ibl (add1 (- b2 b1))][ib (info-bits ibl)])
    (make-rect-k (flip-matrix-cols (make-rect-k (flip-matrix-cols ib) (- n b1))) n)))
(define (encode-linear-code-b2b-1s b1 b2 gm)
  (binary-mat-mult (make-rect-k (info-bits-b2b b1 b2 (length gm)) (length gm)) gm))
(define (encode-linear-code-b2b b1 b2 gm)
  (binary-mat-mult (make-rect-k (info-bits-b2b b1 b2 (length gm)) (length gm)) gm))
(define (encode-RM-code-b2b b1 b2 r m)
  (encode-linear-code-b2b b1 b2 (RM-genmat r m)))
(define (swap-random-all-cols gm)
  (interchange-cols-l gm (list-2-sorted-mpairs (random-sel-all-l (build-list (width gm) values)))))(define (swap-random-cols m)
                                                                                                     (let ([c-l (list-2-sorted-mpairs (random-sel-all-l (build-list (width m) values)))])
                                                                                                       (interchange-cols-l m (take c-l (random (sub1 (length c-l)))))))
;(define (get-swappable-PC-cols r m)
; (swap-random-cols m))
(define (swap-random-cyclic-RM-cw-cols r m)
  (swap-random-cols (encode-cyclic-RM r m)))
(define (product-code gm1 gm2 lst)
  (remove-duplicates (encode-linear-code-l (regroup-list (encode-linear-code-l lst gm1) (length gm2))
                                           gm2)))
(define (info-bits-for-product-code gm1 gm2)
  (let*-values ([(l1 l2) (values (length gm1) (length gm2))]
                [(l) (* l1 l2)][(q r) (quotient/remainder l l1)]
                [(ib) (build-list q (lambda(x) (info-bits l1)))]
                [(ib) (append* (car ib) (cdr ib))])
    (append ib (take (info-bits l1) r))))
(define (long-div-test n)
  (let ([lst (cdr (info-bits n))])
    (let ([acc-i (map (lambda(x)
                        (map (lambda(y)
                               (map (lambda(z) (binary-add-poly (binary-mult-poly x y) z)) lst)) lst)) lst)])
      (let ([acc (append* (car acc-i) (cdr acc-i))])
        (let ([prd-acc (filter cons? (map (lambda(x) (remove-leading-zeros x)) (append* (car acc) (cdr
                                                                                                   acc))))])
          (list prd-acc
                (map (lambda(x) (map (lambda(y) (binary-qut x y)) lst)) prd-acc)
                (map (lambda(x) (map (lambda(y) (binary-rem x y)) lst)) prd-acc)))))))
(define (long-div-test-g g1 g2)
  (let ([lst (cdr (info-bits (degree g2)))])
    (let ([acc (map (lambda(z) (binary-add-poly (binary-mult-poly g1 g2) z)) lst)])
      (let* ([prd-acc (filter cons? (map (lambda(x) (remove-leading-zeros x)) acc))]
             [qut-acc (map (lambda(x) (binary-qut x g2)) prd-acc)]
             [rem-acc (map (lambda(x) (binary-rem x g2)) prd-acc)])
        (list prd-acc qut-acc rem-acc
              (length qut-acc) (length (remove-duplicates qut-acc))
              (length rem-acc) (length (remove-duplicates rem-acc)))))))
;(define (gen-binary-prim-dvnd deg)(flatten (cons (cons 1 (zeros (sub1 deg))) '(1))))
(define (factorize-poly g)
  (let ([lst (map (lambda(x) (remove-leading-zeros x)) (cddr (info-bits (add1 (ceiling (/ (degree g)
                                                                                          2))))))])
    (let* ([qut-acc (map (lambda(x) (binary-qut g x)) lst)]
           [rem-acc (map (lambda(x) (binary-rem g x)) lst)]
           [fac-v (map (lambda(x y z) (vector x y z)) lst qut-acc rem-acc)])
      (filter (lambda(x) (not (or (equal? (vector-ref x 0) '(1)) (equal? (vector-ref x 1) '(1)))))
              (filter (lambda(x) (null? (vector-ref x 2))) fac-v)
              ))))
(define flat-len (compose length flatten))
(define (BCH-gp d t) (remove-leading-zeros (mult-binary-polys (take (all-conj-prim-poly
                                                                     (get-prim-poly d prim-polys-list)) t))))
(define (genmat-row-delta gm1 gm2)
  (get-missing-elements gm1 gm2))
(define (GF2-root-factorize g)
  (let* ([d (degree g)][n (expt 2 d)]
                       [g-d (degree (cdr g))][p-l (take (cyclic-shift-mat (cdr g)) (- d g-d))]
                       [srt (reverse (append (reverse p-l) (reverse (cons (zeros d) (reverse (idn-mat d))))))])
    (let rec ([i (length srt)][acc srt])
      (if (>= i n)
          acc
          (if (positive? (car (last acc)))
              (let ([ele (car (make-rect-k (list (binary-add-poly
                                                  (binary-mult-poly (cdr (last acc)) '(1 0))
                                                  (cdr g))) d))])
                (if (member ele acc)
                    (rec (add1 i) acc)
                    (rec (add1 i) (append acc (list ele)))))
              (rec (add1 i) (append acc (list (cyclic-left-shift (last acc) 1)))))))))
(define (fill-ht ht keys values)
  (let rec ([k keys][v values])
    (if (and (cons? k) (cons? v))
        (begin
          (hash-set! ht (car k) (car v))
          (rec (cdr k) (cdr v)))
        ht)))
(define cc-property-list (list))
(define channel-codes-file-hash (make-hash))
(define channel-codes-func-hash (make-hash))(define (init-hash ht lst)
                                              (fill-ht ht lst (build-list (length lst) (lambda(x) (list-ref lst x)))))
(define ht10k (init-hash channel-codes-func-hash (RM-genmat 2 4)))
(define dir (build-path (find-system-path 'home-dir) "Technical" "Scheme"))
(define (exclusive-lists lst) (map (lambda(x) (list x (remove x lst))) lst))

;(define hash-file (open-output-file (build-path dir "rm_24_all_cw.txt")
;#:mode 'binary))

(define (hash-excl-list lst)
  (let* ([excl-l (exclusive-lists lst)]
         [keys (car (transpose excl-l))]
         [values (cadr (transpose excl-l))])
    (fill-ht (make-hash) keys values)))
(define (cyclic-genmat-n-k n k)
  (cyclic-genmat-n n (get-prim-poly (- n k) prim-polys-list)))
(define (add-rows-downward gm)
  (let rec ([x gm][acc '()])
    (if (null? (cddr x))
        (make-rect (reverse (cons (add-binary-polys x) acc)))
        (rec (cdr x) (cons (add-binary-polys x) acc)))))
(define (isprim?-2 x)
  (let* ([fp (degree x)]
         [p-l (get-prim-poly-list fp prim-polys-list)])
    (or (cons? (member x p-l)) (cons? (member (reverse x) p-l)))))
(define (solve-lin-eqs-unique-prim eq-l s-l)
  (let* ([i-l (cdr (info-bits (width eq-l)))]
         [r-l0 (map (lambda(x) (map (lambda(y) (parity (bitwise-AND-list x y))) eq-l)) i-l)]
         [r-l1 (map (lambda(x) (count (lambda(z) (equal? z x)) r-l0)) (info-bits (length s-l)))]
         [r-l2 (filter cons? (map (lambda(x)
                                    (get-all-matching-pos2 x r-l1)) (build-list (length r-l1) (lambda(x) (+ x 2)))))]
         [r-l3 (map (lambda(x) (cons (map (lambda(y) (parity (bitwise-AND-list x y))) eq-l) (list x))) i-l)]
         [r-l4 (sort r-l3 (lambda(x y) (< (binary-list-2-decimal (car x)) (binary-list-2-decimal (car y)))))]
         [r-l5 (filter (lambda(x) (isprim?-2 (cadr x)))
                       (filter (lambda(x) (>= (degree (cadr x)) 1))
                               (filter (lambda(x) (not-all-zeros? (cadr x))) r-l3)))]
         ;
         [hsh (make-weak-hash)] [hsh (fill-ht hsh r-l0 i-l)]
         )
    ; (hash-ref hsh s-l)
    (values r-l0 r-l1 r-l2 r-l3 r-l4 r-l5)
    ; hsh
    ))

(define (solve-lin-eqs eq-l s-l)
  (let* ([i-l (cdr (info-bits (width eq-l)))]
         [r-l (map (lambda(x) (map (lambda(y) (parity (bitwise-AND-list x y))) eq-l)) i-l)]
         [hsh (make-hash)] [hsh (fill-ht hsh r-l i-l)])
    (hash-ref hsh s-l)
    ; (values r-l i-l
    ;          hsh
    ;      )
    ))

(define (random-sel-all-l lst)
  (let rec ([x lst][acc '()])
    (let ([i (random (length x))])
      (if (cons? (cdr x))
          (rec (remove (list-ref x i) x) (cons (list-ref x i) acc))
          (cons (car x) acc)))))
(define (random-sel-all-k k)
  (random-sel-all-l (cdr (info-bits k))))
(define (random-sel-n-l n lst)
  (let rec ([x lst][j n][acc '()])
    (let ([i (random (length x))])
      (if (and (cons? (cdr x)) (positive? j))
          (rec (remove (list-ref x i) x) (sub1 j) (cons (list-ref x i) acc))
          acc))))
(define (random-sel-n-k n k)
  (random-sel-n-l n (cdr (info-bits k))))
(define (random-lin-eqs lst)
  (let ([eq-l (random-sel-n-k (length lst) (length lst))])
    (list eq-l (map (lambda(y) (parity (bitwise-AND-list lst y))) eq-l))))
(define (log-n x n)
  (if (zero? x)
      x
      (inexact->exact (truncate (/ (log x) (log n))))))

(define (powers-of-roots2 d)
  (let ([e-l (build-list (sub1 (expt 2 (sub1 d))) (lambda(x) (add1 x)))])
    e-l))

(define (powers-of-roots g)
  (let* ([d (degree g)][n (expt 2 d)]
                       [pow (take (decimate (build-list (/ n 2) (lambda(x) (add1 x)))) (/ n 4))]
                       [pow-2 (build-list (log2 n) (lambda(x) (expt 2 x)))]
                       [r-pows (map (lambda(x);
                                      (remove-duplicates
                                       (map (lambda(y) (modulo (* x y) (sub1 n))) pow-2)
                                       ;
                                       )
                                      ) pow)])
    ; (
    ; values pow
    ;
    pow-2
    ;
    r-pows
    (filter cons?
            (remove-common-from-lists
             r-pows
             )
            )
    ;    )
    ))

(define (conj-prim-poly p g)
  (let* ([d (degree g)]
         [pow-g (car (filter (lambda(x) (cons? (member p x))) (powers-of-roots g)))]
         [pow-f (build-list d (lambda(x) (add1 x)))]
         [m-id (reverse (decimal-2-binary-list (expt 2 (sub1 d))))]
         [n (sub1 (expt 2 d))][f-l (GF2-root-factorize g)]
         [eq-l0 (append (reverse (map (lambda(x) (list-ref f-l (add1
                                                                ;(list-ref pow-g (sub1 x))
                                                                (modulo (* p x) n)))) pow-f)) (list m-id))]
         [eq-l (map (lambda(x) (reverse x)) (transpose eq-l0))])
    ; (values (transpose eq-l0) eq-l
    (reverse (solve-lin-eqs eq-l (zeros d)))
    ; (solve-lin-eqs (transpose eq-l0) (zeros d))
    ;    )
    ))
(define (power-of-prim-ele g pw)
  (if (= -1 pw) (zeros (degree g))
      (let* ([d (degree g)][r-l (cdr (GF2-root-factorize g))][n (sub1 (expt 2 d))])
        (list-ref r-l (modulo pw n)))))
(define (all-conj-prim-poly g)
  (let* ([d (degree g)][eqs-res (reverse (decimal-2-binary-list (expt 2 (sub1 d))))]
                       [ib (info-bits d)][poly-pows-l (build-list (add1 d) (lambda(x) (add1 x)))]
                       [pow-r (powers-of-roots g)][pow-d (map (lambda(x) (car x)) pow-r)]
                       [pows-of-2 (map (lambda(x) (* (expt 2 x))) (build-list d values))]
                       [conj-p-l (map (lambda(x) (map (lambda(y) (* x y)) pows-of-2)) pow-d)]
                       [r-l (cdr (GF2-root-factorize g))][n (sub1 (expt 2 d))]
                       [power-of-prim-ele (lambda(pw) (list-ref r-l (modulo pw n)))]
                       [pow-roots (map (lambda(x) (map (lambda(y) (power-of-prim-ele y)) x)) conj-p-l)]
                       [is-mem (map (lambda(x) (member (car x) (cdr x))) pow-roots)]
                       [conj-pows-l (map (lambda(x y) (length(if (cons? x) (drop-right y (length x)) y))) is-mem pow-roots)]
                       [conj-poly-pows (map (lambda(x) (take poly-pows-l x)) conj-pows-l)]
                       [conj-roots-pows (map (lambda(x y) (map (lambda(z) (* x z)) y)) pow-d conj-poly-pows)]
                       [conj-roots (map (lambda(x) (map (lambda(y) (power-of-prim-ele y)) (reverse x)))
                                        conj-roots-pows)]
                       [conj-roots-deg-d (filter (lambda(x) (= d (length x))) conj-roots)]
                       [sols (map (lambda(x) (solve-lin-eqs (transpose x) eqs-res)) conj-roots)])
    (map (lambda(x) (append x '(1))) sols)))
(define (all-conj-prim-degree d)
  (map (lambda(x) (all-conj-prim-poly x)) (get-prim-poly-list d prim-polys-list)))
(define (degree-enum lst)
  (build-list (add1 (length (car lst))) (lambda(x) (length (filter (lambda(y) (= x (degree y)))
                                                                   (filter not-all-zeros? lst))))))
(define (group-by-degree lst)
  (let* ([x0 (filter not-all-zeros? lst)][x1 (reverse-sort-by-degree x0)]
                                         [x (degree-enum x1)])
    (map (lambda(z) (filter-by-degree x1 z)) (build-list (add1 (width x1)) values))))
(define (filter-by-degree lst d) (filter (lambda(x) (= (degree x) d)) (filter not-all-zeros? lst)))
(define (encode-cyclic-hmg-p p)
  (encode-linear-code (cyclic-hmg-genmat p)))
(define (cyclic-RM-genmat r m)
  (RM-genmat-cyclic r m))
(define (RM-genmat-cyclic r m)
  (let ([gm (RM-genmat r m)])
    (sub-mat gm 0 (length gm) 0 (sub1 (width gm)))))
(define (encode-cyclic-RM r m)
  (encode-linear-code (RM-genmat-cyclic r m)))
(define (get-RM-parity-mat-m sm smc)
  (let* ([n (width sm)][k (length sm)][p (- n k)][gm (interchange-cols-l sm smc)])
    (transpose (append (idn-mat p) (sub-mat gm 0 k k n)))))
(define (RM-parity-mat r m)
  (let-values ([(sm smc) (systematic-RM-gen r m)])
    (get-RM-parity-mat-m sm smc)
    ;(interchange-cols-l (get-parity-mat-m sm) smc)
    ; (get-parity-mat-m sm)
    ))
(define (null-space-prod-RM r m);(let ([r (log2 (weight (last (sort-by-weight gm))))][m (log2 (width gm))])
  (let-values ([(sm smc) (systematic-RM-gen r m)])
    (binary-mat-mult sm (transpose (RM-parity-mat r m)))))
(define (code-size-in-bytes-gm gm)
  (* (expt 2 (length gm)) (* 2 (width gm))))
(define (size c)  (length (flatten c)))
(define (size-info-bits n) (* n (expt 2 n)))
(define (is-irreducible? g)
  (null? (factorize-poly g)))
(define (irreducible-polys n)
  (cddr (map (lambda(x) (cdr x))
             (filter (lambda(x) (car x)) (map (lambda(x) (cons (is-irreducible? x) x)) (info-bits-for-gen-poly
                                                                                        n))))))
(define (info-bits-for-gen-poly n)
  (transpose (cons (ones (expt 2 (- n 2)))
                   (append (transpose (info-bits (- n 2))) (list (ones (expt 2 (- n 2))))))))
(define (info-bits-for-gen-poly-by-weight n w)
  (let* ([p-l (gen-nbit-patterns (- n 2) w)][p-l-l (length p-l)])
    (transpose (cons (ones p-l-l) (append (transpose p-l) (list (ones p-l-l)))))))
(define (cyclic-genmat-candidates n k)
  (map (lambda(x) (cyclic-genmat-n n x)) (info-bits-for-gen-poly (add1 (- n k)))))
(define (cyclic-genmat-candidates-by-weight n k w)
  (map (lambda(x) (cyclic-genmat-n n x)) (info-bits-for-gen-poly-by-weight (add1 (- n k)) w)))
(define (is-gm-same-dim? gm1 gm2)
  (and (= (length gm1) (length gm2))
       (= (width gm1) (width gm2))))
(define (cyclic-RM-equv-cw r m w)
  (let* ([rmc (encode-cyclic-RM r m)]
         [rmcg (RM-genmat-cyclic r m)]
         [rmc-gm-eqv rmcg];(interchange-rows rmcg 2 3)]
         [rmc-eqv (encode-linear-code rmc-gm-eqv)]
         [cyc-eq-gm (cyclic-genmat-candidates (sub1 (expt 2 m)) (apply + (take (weight-enum-n m) (add1
                                                                                                  r))))]
         [cyc-eq (map (lambda(x) (encode-linear-code x)) cyc-eq-gm)]
         [code-eqv (map (lambda(x) (is-code-identical? x rmc)) cyc-eq)]
         [length-eqv (map (lambda(x) (= (length x) (length rmc))) cyc-eq)][n-sp (map (lambda(x) (null-space-prod-m (systematize-matrix x))) cyc-eq-gm)]
         [n-sp-allz (filter (lambda(x) (all-zeros? (flatten x))) n-sp)]
         [cyc-eq-gm1 (cyclic-genmat-candidates-by-weight (sub1 (expt 2 m))
                                                         (apply + (take (weight-enum-n m) (add1 r))) w)]
         [cyc-eq1 (map (lambda(x) (encode-linear-code x)) cyc-eq-gm1)]
         [code-eqv1 (map (lambda(x) (is-code-identical? x rmc)) cyc-eq1)]
         [length-eqv1 (map (lambda(x) (= (length x) (length rmc))) cyc-eq1)]
         [n-sp1 (map (lambda(x) (null-space-prod-m (systematize-matrix x))) cyc-eq-gm1)]
         [n-sp-allz1 (filter (lambda(x) (all-zeros? (flatten x))) n-sp1)]
         )
    (values
     (length length-eqv)
     length-eqv code-eqv rmc
     n-sp
     n-sp-allz
     (filter (negate false?) code-eqv)
     rmc-gm-eqv
     (is-code-identical? rmc rmc-eqv)
     )))
(define (check-cyc-by-all-wght c)
  (map (lambda(x) (check-cyclicity-by-weight c x)) (build-list (add1 (width c)) values)))
(define (all-col-subspaces m)
  (map (lambda(x) (col-subspace m x)) (build-list (- (width m) 3) (lambda(x) (+ x 3)))))
(define (check-cols-cyc-by-all-wght c)
  (map (lambda(x) (map (lambda(y) (check-cyclicity-by-weight x y)) (build-list (add1 (width x))
                                                                               values)))
       (all-col-subspaces c)))
(define (check-cyc-by-all-wght-gm gm)
  (let ([c (encode-linear-code gm)])
    (map (lambda(x) (check-cyclicity-by-weight c x)) (build-list (add1 (width c)) values))))
(define (check-cyc-RM-cyc-by-all-wght r m)
  (let ([c (encode-cyclic-RM r m)])
    (null? (filter false? (map (lambda(x) (check-cyclicity-by-weight c x)) (build-list (add1 (width c))
                                                                                       values))))))
(define (check-RM-cyc-by-all-wght r m)
  (let ([c (encode-RM-all-cw r m)])
    (null? (filter false? (map (lambda(x) (check-cyclicity-by-weight c x)) (build-list (add1 (width c))
                                                                                       values))))))
(define (min-dist-gm gm)
  (min-dist2 (encode-linear-code gm)))(define (min-dist3 m)
                                        (let ([w-e (weight-enum m)])
                                          (if (and (cons? (cdr w-e)) (filter positive? (cdr w-e)))
                                              (let rec ([x (cdr w-e)][i 1])
                                                (if (positive? (car x))
                                                    i
                                                    (rec (cdr x) (add1 i)))) #f)))
(define (gen-all-nbit-patterns n m)
  (let ([l (expt 2 n)])
    (let rec ([i 1][acc '()])
      (if (> i l)
          (make-rect-k (reverse acc) n)
          (let ([ib (decimal-2-binary-list i)])
            (if (= (weight ib) m)
                (rec (add1 i) (cons ib acc))
                (rec (add1 i) acc)))))))
(define (binary-list-2-tree lst)
  (let ([acc (let rec ([x lst]) (if (cons? (cdr x))
                                    (list (list (car x) (rec (cdr x))))
                                    (list (list (car x)))))])
    acc))
(define (attach-pos cw1 cw2)
  (if (or (null? cw1) (null? cw2))
      #f
      (let rec ([x cw1][y cw2])
        (if (or (null? x) (null? y))
            0
            (if (= (caar x) (caar y))
                (list (append (list (caar x)) (list (rec (cadar x) (cadar y)))))
                ;                (values i y
                (append x y))
            ;                )
            ))))
(define (copy-subtree tree level)
  (let rec ([x tree] [acc '()] [l 0])
    (cond
      [(or (null? x) (>= l level)) (reverse acc)]
      [(cons? (car x))
       (rec (cdr x) (cons (rec (car x) '() 0) acc) (add1 l))]
      [else (rec (cdr x) (cons (car x) acc) (add1 l))])))
(define (prune tree)
  (let ([l-t (first tree)][r-t (second tree)])
    (define (rec x acc)(cond [(null? (flatten x)) (reverse acc)]
                             [(cons? x) (rec (rec (cdr x) '()) (rec (car x) acc))]
                             [else (cons x acc)])) (append (list (rec l-t '())) (list (rec r-t '())))))
(define trlst1 '(0 1 0 1 0 1))
(define trlst2 '(1 0 1 0 0 1))
(define trlst11 '(0 1 1 1 0 1))
(define trlst22 '(0 1 1 0 0 1))
(define tree1 (binary-list-2-tree trlst1))
(define tree2 (binary-list-2-tree trlst2))
(define tree11 (binary-list-2-tree trlst11))
(define tree22 (binary-list-2-tree trlst22))
(define tree3 (append (list (first tree1)) (list (first tree2))))
(define tree (attach-pos tree1 tree2))
(define (sub-tree tree level)
  (let rec ([x tree][i 0])
    (if (>= i level)
        x
        (if (= (length (car x)) 2)
            (rec (cadar x) (add1 i))
            x))))
(define (num-sub-tree tree)
  (let rec ([x tree][acc '()])
    (if (= (length (car x)) 2)
        (rec (cadar x) (cons (length x) acc))
        (reverse acc))))
(define (num-left-sub-tree tree)
  (num-sub-tree (list (first tree))))
(define (num-right-sub-tree tree)
  (num-sub-tree (list (last tree))))
(define (ltree tree)
  (list (car tree)))
(define (rtree tree)
  (cdr tree))
(define (select-subtree subtree tree level)
  (let rec ([l-t (ltree tree)][r-t (rtree tree)][i 0])
    (if (>= i level)(subtree tree)
        (list (if (cons? l-t) (if (not (equal? l-t r-t))
                                  (rec (first l-t) (last l-t) (add1 i))
                                  (rec (first l-t) '() (add1 i))) '())
              (if (cons? r-t) (if (not (equal? l-t r-t))
                                  (rec (first r-t) (last r-t) (add1 i))
                                  (rec '() (last r-t) (add1 i))) '())))))
;(remove-duplicates (prune tree3))
(define (num-nodes-info-bits-btree n)
  (apply + (build-list (add1 n) (lambda(x) (expt 2 x)))))
(define-serializable-struct ht-node (stat ht) #:transparent #:mutable)
(define (get-first-different-ele-pos lst1 lst2)
  (let rec ([x lst1][y lst2][i -1])
    (if (or (or (null? x) (null? y)) (not (equal? (car x) (car y))))
        (add1 i)
        (rec (cdr x) (cdr y) (add1 i)))))
(define (encode-linear-code-hash gm num)
  (let* ([k (length gm)][n (width gm)][all-1 (ones k)][st-p (add-binary-polys gm)]
                        [enc-f (lambda(z) (encode-linear-code-l (list z) gm))]
                        [st-nxt (car (enc-f (binary-add-poly all-1 '(1))))])
    (let rec ([x st-p][y st-nxt][i 2][acc (append (list st-nxt) (list st-p))])
      (if (> i num)
          (values
           (take (reverse (encode-linear-code gm)) num)
           (reverse (remove st-nxt acc))
           )
          (rec y (car (enc-f (binary-add-poly all-1 (decimal-2-binary-list i)))) (add1 i)
            (append (list (list-tail y (get-first-different-ele-pos x y))) acc))))))
(define (encode-linear-code-range gm st en)
  (let* ([k (length gm)][n (width gm)][enc-f (lambda(z) (encode-linear-code-l (list z) gm))])
    (let rec ([i st][acc '()])
      (if (> i en)
          acc
          (rec (add1 i) (append acc (enc-f (decimal-2-binary-list i))))))))
(define (encode-linear-code-last-n gm num)
  (let* ([k (length gm)][n (width gm)][en (sub1 (expt 2 k))])
    (encode-linear-code-range gm (add1 (- en num)) en)))
(define (num-cw-in-1-MB gm)
  (floor (/ (expt 2 (length gm)) (ceiling (/ (code-size-in-bytes-gm gm) (* 1024 1024))))))(define (%-cw-in-1-MB gm)
                                                                                            (* (/ (num-cw-in-1-MB gm) (expt 2 (length gm))) 100))
(define (split-in-k c k)
  (let* ([n (width c)][cs (sub1 (floor (/ (width c) k)))][cl (* k cs)]
                      [cols (build-list k (lambda(x) (build-list cs (lambda(y) (+ (* x cs) y)))))])
    (append
     (map (lambda(x) (sub-mat c 0 (length c) (first x) (add1 (last x)))) cols)
     (list (sub-mat c 0 (length c) cl (width c))))))
(define flat-length (compose length flatten))
(define (split-len-saving c)
  (map (lambda(x)
         (let ([c-sp (car (split-in-k c x))])
           (- (flat-length c-sp) (flat-length (remove-duplicates c-sp)))))
       (build-list (log2 (width c)) (lambda(x) (+ x 2)))))
(define (sort-by-decimal-value lst)
  (sort lst (lambda(x y) (<= (binary-list-2-decimal x) (binary-list-2-decimal y)))))
(define (sort-by-first-list lst)
  (sort lst (lambda(x y) (<= (binary-list-2-decimal (car x)) (binary-list-2-decimal (car y))))))
(define (split-sort c k)
  (reverse (sort-by-first-list (transpose (split-in-k c k)))))
(define (diff-indexes lst)
  (flatten (map (lambda(x) (get-first-n-matching-pos 1 x lst)) (remove-duplicates lst))))
(define (group-by-split-index lst d-i)
  (let rec ([x lst][y d-i][acc '()])
    (cond [(null? y) (reverse acc)]
          [(null? (cdr y)) (reverse (cons x acc))]
          [else (rec (drop x (- (cadr y) (car y))) (cdr y) (cons (take x (- (cadr y) (car y))) acc))])))
(define (split-sort-group lst k)
  (let* ([ssc (transpose (split-sort lst k))][i-l (diff-indexes (car ssc))]
                                             [sp-l (map (lambda(x) (group-by-split-index x i-l)) (cdr ssc))])
    (cons (remove-duplicates (car ssc)) sp-l)))
(define (gen-n-rnd-nos n max)
  (flatten (map (lambda(x) (random max)) (build-list n values))))
(define (gen-n-rnd-binary-lists n max)
  (map (lambda(x) (decimal-2-binary-list x)) (gen-n-rnd-nos n max)))(define (gen-n-rnd-rect-mat n k max)
                                                                      (make-rect-k (gen-n-rnd-binary-lists n max) k))
(define (random-info-bits-n n k)
  (let ([max-l 15])
    (if (> k max-l)
        (let* ([q (floor (/ k max-l))][r (modulo k max-l)])
          (let* ([sub-s0 (map (lambda(x) (gen-n-rnd-rect-mat n max-l (expt 2 max-l))) (build-list q
                                                                                                  values))]
                 [sub-l (gen-n-rnd-rect-mat n r (expt 2 r))])
            (let ([l-s (cons sub-l sub-s0)])
              (remove-duplicates (concat-rows l-s)))))
        (remove-duplicates (gen-n-rnd-rect-mat n k (expt 2 k))))))
;
(define (concat-rows lst)
  (map (lambda(x) (append* (car x) (cdr x))) (transpose lst)))
(define (encode-rnd-cw gm n)
  (encode-linear-code-l (random-info-bits-n n (length gm)) gm))
(define (encode-rnd-num-of-cw gm)
  (let* ([max-rnd (expt 2 31)][n-sct 2000][sct-n (random (abs (- n-sct 2)))]
                              [sct-max (random (floor (/ (expt 2 (length gm)) n-sct)))]
                              [ofst (decimal-2-binary-list (* n-sct sct-max))]
                              [i-b0 (map (lambda(x) (binary-add-poly ofst x))
                                         (random-info-bits-n sct-max (length gm)))]
                              ;[i-b (append* (car i-b0) (cdr i-b0))]
                              )
    ; i-b0
    (encode-linear-code-l i-b0 gm)
    ))
(define (equispaced-info-bits k nd nc max)
  (let* ([sts0 (map (lambda(x) (build-list nc (lambda(y) (+ y (floor (- (* (/ max nd) x) (* 2 nc)))))))
                    (build-list nd (lambda(x) (add1 x))))][sts (append* (car sts0) (cdr sts0))])
    (make-rect-k (map (lambda(x) (decimal-2-binary-list x)) sts) k)))
(define (equispaced-cw nd nc gm)
  (encode-linear-code-l (equispaced-info-bits (length gm) nd nc (expt 2 (length gm))) gm))
(define (info-bits-range-for-cyc-check gm)
  (list (expt 2 (floor (/ (length gm) 2))) (expt 2 (length gm) 2)))
(define (check-cyclicity-gm gm)
  (check-cyclicity (encode-linear-code gm)))
(define (info-bits-len-for-cyc-check gm)
  (floor (/ (length gm) 2)))(define (add-rows gm r-l rf)
                              (make-rect-k (append (append (take gm rf) (list (add-binary-polys (collect-elements gm r-l))))
                                                   (take-right gm (sub1 (- (length gm) rf)))) (width gm)))
(define (get-first-degree-discont-row m)
  (let* ([d-l (degree-list m)][dl-d (map (lambda(x y) (- x y)) d-l (cyclic-left-shift d-l 1))])
    (get-first-n-matching-pos 1 1 (drop-right dl-d 1))))
(define (weave-cols m)
  (transpose (group-list (flatten (transpose (append m m))) (length m))))
(define (swap-cyclicity-test-gm gm)
  (filter (negate false?) (map (lambda(x) (check-cyclicity-gm x))
                               (map (lambda(x) (interchange-cols gm (first x) (last x)))
                                    (get-all-matching-pos-patterns 1 (width gm) 2)))))
(define (matrix-all-cyclic-shifts m)
  (map (lambda(x) (map (lambda(y) (cyclic-left-shift y x)) m))
       (build-list (sub1 (width m)) (lambda(x) (add1 x)))))
(define (check-cyc-for-mat-list gm-l)
  (map (lambda(x) (check-cyclicity-gm x)) gm-l))
(define (check-cyc-for-cyclic-RM-mat-list r m)
  (check-cyc-for-mat-list (matrix-all-cyclic-shifts (cyclic-RM-genmat r m))))
(define (check-cyc-for-mat-all-cyclic-shifts gm)
  (map (lambda(x) (check-cyclicity-gm x)) (matrix-all-cyclic-shifts gm)))
(define (divide-info-bits-range k d)
  (let ([max (expt 2 k)])
    (map (lambda(x) (floor (* (/ max d) x))) (build-list d values))))
(define (diff-with-next-ele lst)
  (map (lambda(x y) (- x y)) lst (cyclic-left-shift lst 1)))
(define (check-parity-sums-RM-gm-rows r m r-l)
  (map (lambda(z) (map (lambda(y) (map (lambda(x) (add-parity-sums y x)) z)) r-l))
       (drop-right (assoc-parity-sums (RM-genmat r m)) 1)))
(define (RM-check-parity-sums-by-weight r m)
  (map (lambda(x) (check-parity-sums-RM-gm-rows r m x)) (drop-right (group-RM-gm-by-weight r m)
                                                                    1)))
(define (insert-row m v r)
  (append (take m r) (append (list v) (drop m r))))
(define (insert-col m v c)(transpose (insert-row (transpose m) v c)))
(define (append-col m v)
  (map (lambda(x y) (append x (list y))) m v))
(define (insert-rows m vl r)
  (append (take m r) (append vl (drop m r))))
(define (insert-cols m vl c)
  (transpose (insert-rows (transpose m) (transpose vl) c)))
(define (zeros-rectangle nr nc)
  (build-list nr (lambda(x) (zeros nc))))
(define (insert-rows-of-zeros m nr r)
  (append (take m r) (append (zeros-rectangle nr (width m)) (drop m r))))
(define (insert-cols-of-zeros m nc c)
  (transpose (insert-rows-of-zeros (transpose m) nc c)))
(define (insert-lists-of-cols-of-zeros m nr-l r-l)
  (let rec ([x nr-l][y r-l][acc m])
    (if (or (null? x) (null? y))
        acc
        (rec (cdr x) (cdr y) (insert-cols-of-zeros acc (car x) (car y))))))
(define (replace-row m v r)
  (append (take m r) (append (list v) (drop m (add1 r)))))
(define (replace-col m v c)
  (transpose (replace-row (transpose m) v c)))
(define (replace-rows m vl r)
  (append (take m r) (append vl (drop m (+ r (length vl))))))
(define (replace-cols-list m vl c)
  (transpose (replace-rows (transpose m) (transpose vl) c)))
(define (replace-cols m vl c-l)
  (let rec ([x (transpose vl)][y c-l][acc m])
    (if (or (null? x) (null? y))
        acc
        (rec (cdr x) (cdr y) (replace-col acc (car x) (car y))))))
(define (all-permutations-on-cols v c-l)
  (replace-cols (duplicate v (expt 2 (length c-l))) (info-bits (length c-l)) c-l))
(define (remove-reversed-duplicates lst)(remove-duplicates (append lst (map (lambda(x) (reverse x)) lst))))
(define (all-permutations lst1 lst2)
  (remove-duplicates (append-map (lambda(x) (map (lambda(y) (list x y)) lst1)) lst2)))
(define (all-permut-parity-table lst)
  (map (lambda(x) (cons x (modulo (vector-dot-prod (first x) (last x)) 2))) (all-combinations lst 2)))
(define (binary-mat-mult2 p1 p2)
  (transpose (map (lambda(x) (map (lambda(y) (modulo (vector-dot-prod x y) 2)) p1)) (transpose p2))))
(define (enlist-elements lst)
  (map (lambda(x) (list x)) lst))
(define (append-to-lists lsts lst)
  (map (lambda(x y) (append x (list y))) lsts lst))
(define (transpose2 m)
  (let rec ([x (cdr m)][acc (enlist-elements (car m))])
    (if (null? x)
        acc
        (rec (cdr x) (append-to-lists acc (car x))))))
(define (gen-random-cw-iter gm l)
  (let ([y (car (gen-random-nbit-patterns
                 (length gm) (floor (/ (length gm) 4)) 10))])
    (let rec ([x y][n l][acc '()])
      (if (< n 1)
          acc
          (rec x (sub1 n) (encode-linear-code-l (list y) gm))))))
(define (get-first-matching-pos v lst)
  (let ([m-p (member v lst)])
    (if (cons? m-p)
        (- (length lst) (length m-p))
        #f)))
(define (get-first-matching-pos2 v lst)
  (car (get-first-n-matching-pos 1 v lst)))
(define (GF2-power-diff lst1 lst2 g)
  (let* ([p-l (remove-duplicates (GF2-root-factorize g))]
         [p1 (get-first-matching-pos lst1 p-l)] [p2 (get-first-matching-pos lst2 p-l)])
    (if (> p1 p2)
        (- p1 p2)
        (- (+ (sub1 (length p-l)) p1) p2))))(define (kronecker-mat-l d lst)
                                              (let rec ([n d])
                                                (if (= n 1)
                                                    (list (list (first lst) (second lst)) (list (third lst) (last lst)))
                                                    ;(list '(1 1) '(0 1))
                                                    (kronecker-interleave
                                                     (list (rec (sub1 n)) (rec (sub1 n))
                                                           (build-list (expt 4 (sub1 n)) (lambda(x) 0)) (rec (sub1 n)))))))
(define (nested-map lsts fn)
  (let rec ([x lsts])
    (if (cons? (cdr x))
        (map (lambda(y) (flatten (fn y (rec (cdr x))))) (car x))
        x)))
(define (diagonal-bot-half-incl m)
  (map (lambda(x y) (take x y)) m
       (build-list (length m) (lambda(x) (add1 x)))))
(define (diagonal-top-half-incl m)
  (map (lambda(x y) (drop x y)) m
       (build-list (length m) values)))
(define (diagonal-top-half-excl m)
  (map (lambda(x y) (drop x y)) m
       (build-list (length m) (lambda(x) (add1 x)))))
(define (diagonal-bot-half-excl m)
  (map (lambda(x y) (take x y)) m
       (build-list (length m) values)))
(define (append-cols m v)
  (map (lambda(x y) (append x y)) m v))
(define (info-bits-combinations k n)
  (reverse (for*/fold ([acc '()])
                      ([i (info-bits n)] [j (info-bits n)] [k (info-bits n)]) (cons (append i (append j k)) acc))))
(define (append-all-permutations lst1 lst2)
  (remove-duplicates (append-map (lambda(x) (append-cols (duplicate x (length lst2)) lst2)) lst1)))
(define (append-all-permutations-lists2 lsts)
  (remove-duplicates (for*/fold ([acc (car lsts)]) ([i (cdr lsts)]) (append-all-permutations acc i))))
(define (group-into-submats m rb cb)
  (let* ([r (ceiling (/ (length m) rb))][c (ceiling (/ (width m) cb))][r-blk (group-list m r)]
                                        [c-blk (map (lambda(y) (map (lambda(x) (group-list x c)) y)) r-blk)])
    (group-list (append-map (lambda(y) (transpose y)) c-blk) cb)))(define (concat-lists-of-cols lsts)
                                                                    (group-list (for*/fold ([acc '()]) ([j (in-range (length (car lsts)))][i lsts])
                                                                                  (append acc (list-ref i j))) (apply + (map (lambda(x) (width x)) lsts))))
(define (transpose3 m)
  (append-map (lambda(x) (concat-lists-of-cols2 x))
              (map (lambda(x) (map (lambda(y) (transpose y)) x)) (transpose (group-into-submats m 4 4)))))
(define (concat-lists-of-cols2 lsts)
  (let rec ([x lsts][acc '()])
    (if (or (null? x) (null? (cdr x)) (null? (cadr x)))
        (reverse acc)
        (rec (map (lambda(y) (cdr y)) x) (cons (append-map (lambda(x) (car x)) x) acc)))))
; (define (transpose4 lst)
;   (map (lambda(x)
;          (map (lambda(y)
;                 (list-ref y x)) lst)) (build-list (length (car lst)) values)))
; 
;________________________________
(define (step-list-left lst)
  (map (lambda(x) (take lst x)) (build-list (length lst) (lambda(x) (add1 x)))))
(define (step-list-right lst)
  (map (lambda(x) (drop lst x)) (build-list (length lst) (lambda(x) (add1 x)))))
(define (step-list-2-side lst)
  (map (lambda(x y) (cons x (list y))) (step-list-left lst) (step-list-right lst)))
(define (all-internal-permutations lst)
  (define (all-permuts lst)
    (remove-duplicates
     (append-map (lambda(x) (append-map (lambda(y) (map (lambda(z) (append y z)) (cyclic-shift-mat
                                                                                  (last x))))
                                        (cyclic-shift-mat (first x)))) (drop-right (step-list-2-side lst) 1))))
  (append (map (lambda(x) (duplicate x (length lst))) lst)
          (remove-duplicates (append-map (lambda(x) (all-permuts x)) (cyclic-shift-mat lst)))))
(define (all-internal-permutations2 lst)
  (define (all-permuts lst)
    (let rec ([x (list (car lst))][y (cdr lst)][acc '()])
      (if (null? y)(remove-duplicates (append* (car acc) (cdr acc)))
          (rec (append x (list (car y))) (cdr y)
            (cons (append-cols (duplicate x (length y)) (cyclic-shift-mat y)) acc)))))
  (append-map (lambda(x) (all-permuts x)) (cyclic-shift-mat lst)))
(define (append-all-permutations2 lst1 lst2)
  (remove-duplicates (append-map (lambda(x) (map (lambda(y) (list x y)) lst1)) lst2)))
(define (append-all-permutations-lists lsts)
  (remove-duplicates (map (lambda(x) (flatten x))
                          (for*/fold ([acc (car lsts)]) ([i (cdr lsts)]) (append-all-permutations2 acc i)))))
(define (list-sqrd lst) (duplicate lst (length lst)))
(define (index-list-sqrd n) (list-sqrd (build-list n values)))
(define (all-permuts-by-sum lsts n)
  (filter (lambda(x) (= n (apply + x))) (append-all-permutations-lists lsts)))
(define (no-duplicates? lst)
  (let rec ([x lst] [acc '()])
    (if (null? x)
        #t
        (if (cons? (member (car x) acc))
            #f
            (rec (cdr x) (cons (car x) acc))))))
(define (all-distinct-ele-permuts lsts)
  (filter no-duplicates? (append-all-permutations-lists2 lsts)))
(provide/contract
 [add-overall-parity-bit (rectangular-matrix/c . -> . any/c)]
 [draw-trellis-path (binary-list/c . -> . any/c)]
 [sampled-func (positive? (any/c . -> . any/c) positive? positive? . -> . any/c)]
 [vector-dot-prod ((listof any/c) (listof any/c) . -> . (or/c inexact? natural-number/c))]
 [is-orthogonal? (binary-list/c binary-list/c . -> . binary-list/c)]
 [pair-2-mpair ((listof any/c) . -> . (listof any/c))][list-2-sorted-mpairs ((listof any/c) . -> . any/c)]
 [check-cyclicity-interchage-rand-cols (rectangular-matrix/c . -> . any/c)]
 [check-cyclicity-interchage-rand-all-cols-RM (positive? positive? . -> . any/c)]
 [check-cyclicity-interchage-rand-cols-RM (positive? positive? . -> . any/c)]
 [check-cyclic-RM-cyclicity (positive? positive? . -> . any/c)]
 [make-rect-k-ele (rectangular-matrix/c positive? binary-element? . -> . rectangular-matrix/c)]
 [info-bits-b2b-1s (natural-number/c positive? positive? . -> . rectangular-matrix/c)]
 [info-bits-b2b (natural-number/c positive? positive? . -> . rectangular-matrix/c)]
 [encode-linear-code-b2b-1s (natural-number/c positive? rectangular-matrix/c . -> . any/c)]
 [encode-linear-code-b2b (natural-number/c positive? rectangular-matrix/c . -> . any/c)]
 [encode-RM-code-b2b (natural-number/c positive? positive? positive? . -> . any/c)]
 [swap-random-all-cols (rectangular-matrix/c . -> . any/c)]
 [swap-random-cols (rectangular-matrix/c . -> . any/c)]
 ;[get-swappable-PC-cols (positive? positive? . -> . any/c)]
 [swap-random-cyclic-RM-cw-cols (positive? positive? . -> . any/c)]
 [product-code (rectangular-matrix/c rectangular-matrix/c binary-list/c . -> . any/c)]
 [info-bits-for-product-code (rectangular-matrix/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [long-div-test (positive? . -> . any/c) ]
 [long-div-test-g (binary-list/c binary-list/c . -> . any/c)]
 [gen-binary-prim-dvnd (positive? . -> . any/c)]
 [factorize-poly (binary-list/c . -> . any/c)]
 [flat-len (any/c . -> . any/c)]
 [BCH-gp (positive? positive? . -> . binary-list/c)]
 [genmat-row-delta (rectangular-matrix/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 ;[GF2-adjust (lst g . -> . any/c)]
 [GF2-root-factorize (binary-list/c . -> . any/c)]
 [fill-ht (hash? (listof string?) (listof any/c) . -> . any/c)]
 [init-hash (hash? binary-list/c . -> . any/c)]
 [exclusive-lists (binary-list/c . -> . any/c)]
 [hash-excl-list (binary-list/c . -> . any/c)]
 [cyclic-genmat-n-k (positive? positive? . -> . any/c)]
 [add-rows-downward (rectangular-matrix/c . -> . any/c)]
 [isprim?-2 (binary-list/c . -> . boolean?)]
 [solve-lin-eqs-unique-prim ((listof any/c) (listof any/c) . -> . (listof any/c))]
 [solve-lin-eqs ((listof any/c) (listof any/c) . -> . (listof any/c))]
 [random-sel-all-l (index-list/c . -> . any/c)]
 [random-sel-all-k (positive? . -> . any/c)]
 [random-sel-n-l (positive? index-list/c . -> . any/c)]
 [random-sel-n-k (positive? positive? . -> . any/c)]
 [random-lin-eqs ((listof any/c) . -> . (listof any/c))]
 [log-n (positive? positive? . -> . natural-number/c)]
 [powers-of-roots2 (positive? . -> . binary-lists/c)]
 [powers-of-roots (binary-list/c . -> . any/c)]
 [conj-prim-poly (positive? binary-list/c . -> . any/c)]
 [all-conj-prim-poly (binary-list/c . -> . any/c)]
 [all-conj-prim-degree (positive? . -> . any/c)]
 [degree-enum (binary-list/c . -> . any/c)][group-by-degree (binary-list/c . -> . any/c)]
 [filter-by-degree (binary-lists/c positive? . -> . binary-lists/c)]
 [encode-cyclic-hmg-p (positive? . -> . binary-lists/c)]
 [cyclic-RM-genmat (positive? positive? . -> . any/c)]
 [RM-genmat-cyclic (positive? positive? . -> . any/c)]
 [encode-cyclic-RM (positive? positive? . -> . any/c)]
 [get-RM-parity-mat-m (binary-lists/c (listof any/c) . -> . binary-lists/c)]
 [RM-parity-mat (positive? positive? . -> . any/c)]
 [null-space-prod-RM (positive? positive? . -> . any/c)]
 [code-size-in-bytes-gm (rectangular-matrix/c . -> . any/c)]
 [size (rectangular-matrix/c . -> . natural-number/c)]
 [size-info-bits (natural-number/c . -> . natural-number/c)]
 [is-irreducible? (binary-list/c . -> . boolean?)]
 [irreducible-polys (natural-number/c . -> . binary-lists/c)]
 [info-bits-for-gen-poly (natural-number/c . -> . rectangular-matrix/c)]
 [info-bits-for-gen-poly-by-weight (natural-number/c natural-number/c . -> . rectangular-matrix/c)]
 [cyclic-genmat-candidates (positive? positive? . -> . (listof rectangular-matrix/c))]
 [cyclic-genmat-candidates-by-weight (positive? positive? positive? . -> . (listof rectangular-matrix/c))]
 [is-gm-same-dim? (rectangular-matrix/c rectangular-matrix/c . -> . boolean?)]
 [cyclic-RM-equv-cw (positive? positive? positive? . -> . rectangular-matrix/c)]
 [check-cyc-by-all-wght (rectangular-matrix/c . -> . boolean?)]
 [all-col-subspaces (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [check-cols-cyc-by-all-wght (rectangular-matrix/c . -> . boolean?)]
 [check-cyc-by-all-wght-gm (rectangular-matrix/c . -> . boolean?)]
 [check-cyc-RM-cyc-by-all-wght (positive? positive? . -> . any/c)][check-RM-cyc-by-all-wght (positive? positive? . -> . boolean?)]
 [min-dist-gm (rectangular-matrix/c . -> . natural-number/c)]
 [min-dist3 (rectangular-matrix/c . -> . natural-number/c)]
 [gen-all-nbit-patterns (positive? positive? . -> . rectangular-matrix/c)]
 [binary-list-2-tree (binary-list/c . -> . (listof any/c))]
 ;[attach-pos (cw1 cw2)
 [attach-pos (binary-list/c binary-list/c . -> . natural-number/c)]
 [copy-subtree ((listof any/c) natural-number/c . -> . (listof any/c))]
 [prune ((listof any/c) . -> . (listof any/c))]
 [sub-tree ((listof any/c) natural-number/c . -> . (listof any/c))]
 [num-sub-tree ((listof any/c) . -> . natural-number/c)]
 [num-left-sub-tree ((listof any/c) . -> . natural-number/c)]
 [num-right-sub-tree ((listof any/c) . -> . natural-number/c)]
 [ltree ((listof any/c) . -> . (listof any/c))]
 [rtree ((listof any/c) . -> . (listof any/c))]
 [select-subtree ((listof any/c) (listof any/c) natural-number/c . -> . (listof any/c))]
 [num-nodes-info-bits-btree (positive? . -> . positive?)]
 [get-first-different-ele-pos (binary-list/c binary-list/c . -> . natural-number/c)]
 [encode-linear-code-hash (rectangular-matrix/c natural-number/c . -> . rectangular-matrix/c)]
 [encode-linear-code-range (rectangular-matrix/c natural-number/c positive? . -> . rectangular-matrix/c)]
 [encode-linear-code-last-n (rectangular-matrix/c natural-number/c . -> . rectangular-matrix/c)]
 [num-cw-in-1-MB (rectangular-matrix/c . -> . any/c)]
 [%-cw-in-1-MB (rectangular-matrix/c . -> . any/c)]
 [split-in-k (rectangular-matrix/c positive? . -> . any/c)][flat-length ((listof any/c) . -> . any/c)]
 [split-len-saving (rectangular-matrix/c . -> . (listof any/c))]
 [sort-by-decimal-value (binary-list/c . -> . binary-list/c)]
 [sort-by-first-list (binary-list/c . -> . binary-list/c)]
 [split-sort (rectangular-matrix/c positive? . -> . any/c)]
 [diff-indexes (binary-list/c . -> . any/c)]
 [group-by-split-index (rectangular-matrix/c index-list/c . -> . rectangular-matrix/c)]
 [split-sort-group (rectangular-matrix/c positive? . -> . any/c)]
 [gen-n-rnd-nos (natural-number/c positive? . -> . index-list/c)]
 [gen-n-rnd-binary-lists (natural-number/c positive? . -> . rectangular-matrix/c)]
 [gen-n-rnd-rect-mat (natural-number/c positive? positive? . -> . rectangular-matrix/c)]
 [random-info-bits-n (natural-number/c positive? . -> . rectangular-matrix/c)]
 [concat-rows (binary-list/c . -> . any/c)]
 [encode-rnd-cw (natural-number/c positive? . -> . rectangular-matrix/c)]
 [encode-rnd-num-of-cw (natural-number/c . -> . rectangular-matrix/c)]
 [equispaced-info-bits (positive? positive? positive? positive? . -> . rectangular-matrix/c)]
 [equispaced-cw (positive? positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [info-bits-range-for-cyc-check (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [check-cyclicity-gm (rectangular-matrix/c . -> . boolean?)]
 [info-bits-len-for-cyc-check (rectangular-matrix/c . -> . natural-number/c)]
 [add-rows (rectangular-matrix/c index-list/c natural-number/c . -> . (listof any/c))]
 [get-first-degree-discont-row (rectangular-matrix/c . -> . any/c)]
 [weave-cols (rectangular-matrix/c . -> . any/c)]
 [swap-cyclicity-test-gm (rectangular-matrix/c . -> . boolean?)][matrix-all-cyclic-shifts (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [check-cyc-for-mat-list ((listof rectangular-matrix/c) . -> . (listof boolean?))]
 [check-cyc-for-cyclic-RM-mat-list (positive? positive? . -> . (listof boolean?))]
 [check-cyc-for-mat-all-cyclic-shifts (rectangular-matrix/c . -> . (listof boolean?))]
 [divide-info-bits-range (positive? positive? . -> . rectangular-matrix/c)]
 [diff-with-next-ele (binary-list/c . -> . any/c)]
 [check-parity-sums-RM-gm-rows (positive? positive? rectangular-matrix/c . -> . rectangular-matrix/c)]
 [RM-check-parity-sums-by-weight (positive? positive? . -> . rectangular-matrix/c)]
 [insert-row (rectangular-matrix/c binary-list/c natural-number/c . -> . rectangular-matrix/c)]
 [insert-col (rectangular-matrix/c binary-list/c natural-number/c . -> . rectangular-matrix/c)]
 [append-col (rectangular-matrix/c binary-list/c . -> . rectangular-matrix/c)]
 [insert-rows (rectangular-matrix/c rectangular-matrix/c natural-number/c . -> . rectangular-matrix/c)]
 [insert-cols (rectangular-matrix/c rectangular-matrix/c natural-number/c . -> . rectangular-matrix/c)]
 [zeros-rectangle (positive? positive? . -> . rectangular-matrix/c)]
 [insert-rows-of-zeros (rectangular-matrix/c positive? natural-number/c . -> . rectangular-matrix/c)]
 [insert-cols-of-zeros (rectangular-matrix/c positive? natural-number/c . -> . rectangular-matrix/c)]
 [insert-lists-of-cols-of-zeros (rectangular-matrix/c (listof index-list/c) index-list/c . -> . rectangular-matrix/c)]
 [replace-row (rectangular-matrix/c binary-list/c natural-number/c . -> . rectangular-matrix/c)]
 [replace-col (rectangular-matrix/c binary-list/c natural-number/c . -> . rectangular-matrix/c)]
 [replace-rows (rectangular-matrix/c rectangular-matrix/c natural-number/c . -> . rectangular-matrix/c)]
 [replace-cols-list (rectangular-matrix/c rectangular-matrix/c natural-number/c . -> . rectangular-matrix/c)]
 [replace-cols (rectangular-matrix/c rectangular-matrix/c index-list/c . -> . rectangular-matrix/c)]
 [all-permutations-on-cols ((listof any/c) (listof any/c) . -> . (listof any/c))][remove-reversed-duplicates (binary-list/c . -> . any/c)]
 [all-permutations ((listof any/c) (listof any/c) . -> . (listof any/c))]
 [all-permut-parity-table (binary-list/c . -> . any/c)]
 ;[binary-mat-mult2 (p1 p2)]
 [enlist-elements ((listof any/c) . -> . (listof any/c))]
 [append-to-lists (binary-lists/c binary-list/c . -> . binary-lists/c)]
 [transpose2 (rectangular-matrix/c . -> . any/c)]
 [gen-random-cw-iter (rectangular-matrix/c positive? . -> . rectangular-matrix/c)]
 [get-first-matching-pos (any/c (listof any/c) . -> . natural-number/c)]
 [GF2-power-diff (binary-list/c binary-list/c binary-list/c . -> . any/c)]
 [kronecker-mat-l (positive? binary-list/c . -> . any/c)]
 [nested-map (binary-lists/c (any/c . -> . any/c) . -> . (listof any/c))]
 [diagonal-bot-half-incl (rectangular-matrix/c . -> . any/c)]
 [diagonal-top-half-incl (rectangular-matrix/c . -> . any/c)]
 [diagonal-top-half-excl (rectangular-matrix/c . -> . any/c)]
 [diagonal-bot-half-excl (rectangular-matrix/c . -> . any/c)]
 [transpose4 (binary-list/c . -> . any/c)]
 [step-list-left ((listof any/c) . -> . (listof any/c))]
 [append-all-permutations2 ((listof any/c) (listof any/c) . -> . (listof any/c))]
 [append-all-permutations-lists2 ((listof any/c) . -> . (listof any/c))]
 [list-sqrd ((listof any/c) . -> . rectangular-matrix/c)]
 [index-list-sqrd (index-list/c . -> . (listof index-list/c))]
 [all-permuts-by-sum ((listof any/c) positive? . -> . (listof any/c))]
 [all-distinct-ele-permuts ((listof any/c) . -> . (listof any/c))]
 [no-duplicates? ((listof any/c) . -> . boolean?)][step-list-right ((listof any/c) . -> . (listof any/c))]
 [step-list-2-side ((listof any/c) . -> . (listof any/c))]
 [all-internal-permutations ((listof any/c) . -> . (listof any/c))]
 [all-internal-permutations2 ((listof any/c) . -> . (listof any/c))]
 [append-cols (rectangular-matrix/c rectangular-matrix/c . -> . rectangular-matrix/c)]
 [info-bits-combinations (positive? positive? . -> . rectangular-matrix/c)]
 [append-all-permutations ((listof any/c) (listof any/c) . -> . (listof any/c))]
 [append-all-permutations-lists ((listof any/c) . -> . (listof any/c)) ]
 [group-into-submats (rectangular-matrix/c positive? positive? . -> . (listof any/c))]
 [concat-lists-of-cols ((listof any/c) . -> . (listof any/c))]
 [transpose3 (rectangular-matrix/c . -> . any/c)]
 [concat-lists-of-cols2 ((listof any/c) . -> . (listof any/c))]
 [power-of-prim-ele ((listof any/c) number? . -> . (listof any/c))]
 )
(require plot)
(define RS_63_57_all_pow_combs
  '((((-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1)
      (-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1))
     ((1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33)
      (32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1))
     ((2 1 -1 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34)
      (33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2))
     ((3 2 -1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35)
      (34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3))
     ((4 3 -1 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36)
      (35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4))
     ((5 4 -1 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37)
      (36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5))
     ((6 5 -1 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38)
      (37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6))
     ((7 6 -1 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39)
      (38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7))
     ((8 7 -1 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40)(39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8))
     ((9 8 -1 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41)
      (40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10
          9))
     ((10 9 -1 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42)
      (41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11
          10))
     ((11 10 -1 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43)
      (42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12
          11))
     ((12 11 -1 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44)
      (43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13
          12))
     ((13 12 -1 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45)
      (44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14
          13))
     ((14 13 -1 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46)
      (45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15
          14))
     ((15 14 -1 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47)
      (46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
          15))
     ((16 15 -1 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48)
      (47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17
          16))
     ((17 16 -1 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49)
      (48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18
          17))
     ((18 17 -1 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50)
      (49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19
          18))
     ((19 18 -1 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51)
      (50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20
          19))
     ((20 19 -1 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52)
      (51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21
          20))
     ((21 20 -1 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53)
      (52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22
          21))
     ((22 21 -1 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54)
      (53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23
          22))
     ((23 22 -1 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55)
      (54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24
          23))
     ((24 23 -1 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56)
      (55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25
          24))((25 24 -1 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57)
               (56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26
                   25))
              ((26 25 -1 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58)
               (57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27
                   26))
              ((27 26 -1 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59)
               (58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28
                   27))
              ((28 27 -1 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60)
               (59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29
                   28))
              ((29 28 -1 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61)
               (60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30
                   29))
              ((30 29 -1 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1)
               (61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31
                   30))
              ((31 30 -1 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
               (-1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
                   31))
              ((32 31 -1 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1)
               (0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33
                  32))
              ((33 32 -1 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2)
               (1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33))
              ((34 33 -1 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3)
               (2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34))
              ((35 34 -1 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4)
               (3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35))
              ((36 35 -1 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5)
               (4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36))
              ((37 36 -1 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6)
               (5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37))
              ((38 37 -1 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7)
               (6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38))
              ((39 38 -1 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8)
               (7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39))
              ((40 39 -1 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9)
               (8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40))
              ((41 40 -1 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11
                   10)
               (9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41))
              ((42 41 -1 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12
                   11)
               (10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42))
              ((43 42 -1 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13
                   12)
               (11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43))((44 43 -1 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14
                                                                                                            13)
                                                                                                        (12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44))
                                                                                                       ((45 44 -1 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15
                                                                                                            14)
                                                                                                        (13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45))
                                                                                                       ((46 45 -1 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16
                                                                                                            15)
                                                                                                        (14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46))
                                                                                                       ((47 46 -1 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17
                                                                                                            16)
                                                                                                        (15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47))
                                                                                                       ((48 47 -1 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18
                                                                                                            17)
                                                                                                        (16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49 48))
                                                                                                       ((49 48 -1 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19
                                                                                                            18)
                                                                                                        (17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50 49))
                                                                                                       ((50 49 -1 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20
                                                                                                            19)
                                                                                                        (18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51 50))
                                                                                                       ((51 50 -1 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21
                                                                                                            20)
                                                                                                        (19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52 51))
                                                                                                       ((52 51 -1 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22
                                                                                                            21)
                                                                                                        (20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53 52))
                                                                                                       ((53 52 -1 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23
                                                                                                            22)
                                                                                                        (21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54 53))
                                                                                                       ((54 53 -1 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24
                                                                                                            23)
                                                                                                        (22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55 54))
                                                                                                       ((55 54 -1 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25
                                                                                                            24)
                                                                                                        (23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56 55))
                                                                                                       ((56 55 -1 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26
                                                                                                            25)
                                                                                                        (24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57 56))
                                                                                                       ((57 56 -1 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27
                                                                                                            26)
                                                                                                        (25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58 57))
                                                                                                       ((58 57 -1 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28
                                                                                                            27)
                                                                                                        (26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59 58))
                                                                                                       ((59 58 -1 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29
                                                                                                            28)
                                                                                                        (27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60 59))
                                                                                                       ((60 59 -1 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 3029)
                                                                                                        (28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61 60))
                                                                                                       ((61 60 -1 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31
                                                                                                            30)
                                                                                                        (29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 61))
                                                                                                       ((62 61 -1 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32
                                                                                                            31)
                                                                                                        (30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1))
                                                                                                       ((0 62 -1 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32)
                                                                                                        (31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)))
    (((-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1)
      (-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1))
     ((-1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
      (31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61
          62))
     ((-1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
      (32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62
          0))
     ((-1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32)
      (33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1))
     ((-1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33)
      (34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2))
     ((-1 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34)
      (35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3))
     ((-1 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35)
      (36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4))
     ((-1 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36)
      (37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5))
     ((-1 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37)
      (38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6))
     ((-1 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38)
      (39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7))
     ((-1 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39)
      (40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8))
     ((-1 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39
          40)
      (41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9))
     ((-1 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
          41)
      (42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10))
     ((-1 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41
          42)
      (43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11))
     ((-1 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42
          43)
      (44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12))
     ((-1 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
          44)
      (45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13))((-1 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44
                                                                                                   45)
                                                                                               (46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14))
                                                                                              ((-1 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45
                                                                                                   46)
                                                                                               (47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))
                                                                                              ((-1 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46
                                                                                                   47)
                                                                                               (48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
                                                                                              ((-1 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
                                                                                                   48)
                                                                                               (49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17))
                                                                                              ((-1 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48
                                                                                                   49)
                                                                                               (50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18))
                                                                                              ((-1 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49
                                                                                                   50)
                                                                                               (51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19))
                                                                                              ((-1 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50
                                                                                                   51)
                                                                                               (52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20))
                                                                                              ((-1 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51
                                                                                                   52)
                                                                                               (53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21))
                                                                                              ((-1 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52
                                                                                                   53)
                                                                                               (54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22))
                                                                                              ((-1 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53
                                                                                                   54)
                                                                                               (55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23))
                                                                                              ((-1 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54
                                                                                                   55)
                                                                                               (56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24))
                                                                                              ((-1 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55
                                                                                                   56)
                                                                                               (57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25))
                                                                                              ((-1 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56
                                                                                                   57)
                                                                                               (58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26))
                                                                                              ((-1 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57
                                                                                                   58)
                                                                                               (59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27))
                                                                                              ((-1 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58
                                                                                                   59)
                                                                                               (60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28))
                                                                                              ((-1 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
                                                                                                   60)
                                                                                               (61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29))
                                                                                              ((-1 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 6061)
                                                                                               (62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30))
                                                                                              ((-1 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61
                                                                                                   62)
                                                                                               (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31))
                                                                                              ((-1 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0)
                                                                                               (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32))
                                                                                              ((-1 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1)
                                                                                               (2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33))
                                                                                              ((-1 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2)
                                                                                               (3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34))
                                                                                              ((-1 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3)
                                                                                               (4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35))
                                                                                              ((-1 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4)
                                                                                               (5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36))
                                                                                              ((-1 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5)
                                                                                               (6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37))
                                                                                              ((-1 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6)
                                                                                               (7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38))
                                                                                              ((-1 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7)
                                                                                               (8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39))
                                                                                              ((-1 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8)
                                                                                               (9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39
                                                                                                  40))
                                                                                              ((-1 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9)
                                                                                               (10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40
                                                                                                   41))
                                                                                              ((-1 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10)
                                                                                               (11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41
                                                                                                   42))
                                                                                              ((-1 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11)
                                                                                               (12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42
                                                                                                   43))
                                                                                              ((-1 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12)
                                                                                               (13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
                                                                                                   44))
                                                                                              ((-1 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13)
                                                                                               (14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44
                                                                                                   45))
                                                                                              ((-1 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)
                                                                                               (15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45
                                                                                                   46))
                                                                                              ((-1 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
                                                                                               (16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46
                                                                                                   47))
                                                                                              ((-1 49 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
                                                                                               (17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
                                                                                                   48))
                                                                                              ((-1 50 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17)(18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48
                                                                                                                                                                                          49))
                                                                                              ((-1 51 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18)
                                                                                               (19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49
                                                                                                   50))
                                                                                              ((-1 52 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19)
                                                                                               (20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50
                                                                                                   51))
                                                                                              ((-1 53 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
                                                                                               (21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51
                                                                                                   52))
                                                                                              ((-1 54 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21)
                                                                                               (22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52
                                                                                                   53))
                                                                                              ((-1 55 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
                                                                                               (23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53
                                                                                                   54))
                                                                                              ((-1 56 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23)
                                                                                               (24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54
                                                                                                   55))
                                                                                              ((-1 57 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24)
                                                                                               (25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55
                                                                                                   56))
                                                                                              ((-1 58 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25)
                                                                                               (26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56
                                                                                                   57))
                                                                                              ((-1 59 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26)
                                                                                               (27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57
                                                                                                   58))
                                                                                              ((-1 60 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27)
                                                                                               (28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58
                                                                                                   59))
                                                                                              ((-1 61 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28)
                                                                                               (29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
                                                                                                   60))
                                                                                              ((-1 62 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29)
                                                                                               (30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60
                                                                                                   61)))
    (((-1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
      (31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61
          62))
     ((0 -1 58 53 34 43 6 5 44 23 27 12 49 10 41 25 55 46 33 54 26 24 42 35 8 20 14 19 9 50 32 47)
      (60 29 17 3 22 45 56 52 59 48 13 21 4 7 36 16 30 40 11 28 61 38 2 18 15 37 62 1 39 31 51 57))
     ((1 58 -1 59 54 35 44 7 6 45 24 28 13 50 11 42 26 56 47 34 55 27 25 43 36 9 21 15 20 10 51 33)
      (48 61 30 18 4 23 46 57 53 60 49 14 22 5 8 37 17 31 41 12 29 62 39 3 19 16 38 0 2 40 32 52))
     ((2 53 59 -1 60 55 36 45 8 7 46 25 29 14 51 12 43 27 57 48 35 56 28 26 44 37 10 22 16 21 11 52)
      (34 49 62 31 19 5 24 47 58 54 61 50 15 23 6 9 38 18 32 42 13 30 0 40 4 20 17 39 1 3 41 33))
     ((3 34 54 60 -1 61 56 37 46 9 8 47 26 30 15 52 13 44 28 58 49 36 57 29 27 45 38 11 23 17 22 12)
      (53 35 50 0 32 20 6 25 48 59 55 62 51 16 24 7 10 39 19 33 43 14 31 1 41 5 21 18 40 2 4 42))((4 43 35 55 61 -1 62 57 38 47 10 9 48 27 31 16 53 14 45 29 59 50 37 58 30 28 46 39 12 24 18 23)
                                                                                                  (13 54 36 51 1 33 21 7 26 49 60 56 0 52 17 25 8 11 40 20 34 44 15 32 2 42 6 22 19 41 3 5))
                                                                                                 ((5 6 44 36 56 62 -1 0 58 39 48 11 10 49 28 32 17 54 15 46 30 60 51 38 59 31 29 47 40 13 25 19)
                                                                                                  (24 14 55 37 52 2 34 22 8 27 50 61 57 1 53 18 26 9 12 41 21 35 45 16 33 3 43 7 23 20 42 4))
                                                                                                 ((6 5 7 45 37 57 0 -1 1 59 40 49 12 11 50 29 33 18 55 16 47 31 61 52 39 60 32 30 48 41 14 26)
                                                                                                  (20 25 15 56 38 53 3 35 23 9 28 51 62 58 2 54 19 27 10 13 42 22 36 46 17 34 4 44 8 24 21 43))
                                                                                                 ((7 44 6 8 46 38 58 1 -1 2 60 41 50 13 12 51 30 34 19 56 17 48 32 62 53 40 61 33 31 49 42 15)
                                                                                                  (27 21 26 16 57 39 54 4 36 24 10 29 52 0 59 3 55 20 28 11 14 43 23 37 47 18 35 5 45 9 25 22))
                                                                                                 ((8 23 45 7 9 47 39 59 2 -1 3 61 42 51 14 13 52 31 35 20 57 18 49 33 0 54 41 62 34 32 50 43)
                                                                                                  (16 28 22 27 17 58 40 55 5 37 25 11 30 53 1 60 4 56 21 29 12 15 44 24 38 48 19 36 6 46 10 26))
                                                                                                 ((9 27 24 46 8 10 48 40 60 3 -1 4 62 43 52 15 14 53 32 36 21 58 19 50 34 1 55 42 0 35 33 51)
                                                                                                  (44 17 29 23 28 18 59 41 56 6 38 26 12 31 54 2 61 5 57 22 30 13 16 45 25 39 49 20 37 7 47 11))
                                                                                                 ((10 12 28 25 47 9 11 49 41 61 4 -1 5 0 44 53 16 15 54 33 37 22 59 20 51 35 2 56 43 1 36 34)
                                                                                                  (52 45 18 30 24 29 19 60 42 57 7 39 27 13 32 55 3 62 6 58 23 31 14 17 46 26 40 50 21 38 8 48))
                                                                                                 ((11 49 13 29 26 48 10 12 50 42 62 5 -1 6 1 45 54 17 16 55 34 38 23 60 21 52 36 3 57 44 2 37)
                                                                                                  (35 53 46 19 31 25 30 20 61 43 58 8 40 28 14 33 56 4 0 7 59 24 32 15 18 47 27 41 51 22 39 9))
                                                                                                 ((12 10 50 14 30 27 49 11 13 51 43 0 6 -1 7 2 46 55 18 17 56 35 39 24 61 22 53 37 4 58 45 3)
                                                                                                  (38 36 54 47 20 32 26 31 21 62 44 59 9 41 29 15 34 57 5 1 8 60 25 33 16 19 48 28 42 52 23 40))
                                                                                                 ((13 41 11 51 15 31 28 50 12 14 52 44 1 7 -1 8 3 47 56 19 18 57 36 40 25 62 23 54 38 5 59 46)
                                                                                                  (4 39 37 55 48 21 33 27 32 22 0 45 60 10 42 30 16 35 58 6 2 9 61 26 34 17 20 49 29 43 53 24))
                                                                                                 ((14 25 42 12 52 16 32 29 51 13 15 53 45 2 8 -1 9 4 48 57 20 19 58 37 41 26 0 24 55 39 6 60)
                                                                                                  (47 5 40 38 56 49 22 34 28 33 23 1 46 61 11 43 31 17 36 59 7 3 10 62 27 35 18 21 50 30 44 54))
                                                                                                 ((15 55 26 43 13 53 17 33 30 52 14 16 54 46 3 9 -1 10 5 49 58 21 20 59 38 42 27 1 25 56 40 7)
                                                                                                  (61 48 6 41 39 57 50 23 35 29 34 24 2 47 62 12 44 32 18 37 60 8 4 11 0 28 36 19 22 51 31 45))
                                                                                                 ((16 46 56 27 44 14 54 18 34 31 53 15 17 55 47 4 10 -1 11 6 50 59 22 21 60 39 43 28 2 26 57 41)
                                                                                                  (8 62 49 7 42 40 58 51 24 36 30 35 25 3 48 0 13 45 33 19 38 61 9 5 12 1 29 37 20 23 52 32))
                                                                                                 ((17 33 47 57 28 45 15 55 19 35 32 54 16 18 56 48 5 11 -1 12 7 51 60 23 22 61 40 44 29 3 27 58)
                                                                                                  (42 9 0 50 8 43 41 59 52 25 37 31 36 26 4 49 1 14 46 34 20 39 62 10 6 13 2 30 38 21 24 53))
                                                                                                 ((18 54 34 48 58 29 46 16 56 20 36 33 55 17 19 57 49 6 12 -1 13 8 52 61 24 23 62 41 45 30 4 28)
                                                                                                  (59 43 10 1 51 9 44 42 60 53 26 38 32 37 27 5 50 2 15 47 35 21 40 0 11 7 14 3 31 39 22 25))
                                                                                                 ((19 26 55 35 49 59 30 47 17 57 21 37 34 56 18 20 58 50 7 13 -1 14 9 53 62 25 24 0 42 46 31 5)
                                                                                                  (29 60 44 11 2 52 10 45 43 61 54 27 39 33 38 28 6 51 3 16 48 36 22 41 1 12 8 15 4 32 40 23))
                                                                                                 ((20 24 27 56 36 50 60 31 48 18 58 22 38 35 57 19 21 59 51 8 14 -1 15 10 54 0 26 25 1 43 47 32)
                                                                                                  (6 30 61 45 12 3 53 11 46 44 62 55 28 40 34 39 29 7 52 4 17 49 37 23 42 2 13 9 16 5 33 41))
                                                                                                 ((21 42 25 28 57 37 51 61 32 49 19 59 23 39 36 58 20 22 60 52 9 15 -1 16 11 55 1 27 26 2 44 48)
                                                                                                  (33 7 31 62 46 13 4 54 12 47 45 0 56 29 41 35 40 30 8 53 5 18 50 38 24 43 3 14 10 17 6 34))
                                                                                                 ((22 35 43 26 29 58 38 52 62 33 50 20 60 24 40 37 59 21 23 61 53 10 16 -1 17 12 56 2 28 27 3 45)
                                                                                                  (49 34 8 32 0 47 14 5 55 13 48 46 1 57 30 42 36 41 31 9 54 6 19 51 39 25 44 4 15 11 18 7))
                                                                                                 ((23 8 36 44 27 30 59 39 53 0 34 51 21 61 25 41 38 60 22 24 62 54 11 17 -1 18 13 57 3 29 28 4)
                                                                                                  (46 50 35 9 33 1 48 15 6 56 14 49 47 2 58 31 43 37 42 32 10 55 7 20 52 40 26 45 5 16 12 19))
                                                                                                 ((24 20 9 37 45 28 31 60 40 54 1 35 52 22 62 26 42 39 61 23 25 0 55 12 18 -1 19 14 58 4 30 29)
                                                                                                  (5 47 51 36 10 34 2 49 16 7 57 15 50 48 3 59 32 44 38 43 33 11 56 8 21 53 41 27 46 6 17 13))
                                                                                                 ((25 14 21 10 38 46 29 32 61 41 55 2 36 53 23 0 27 43 40 62 24 26 1 56 13 19 -1 20 15 59 5 31)
                                                                                                  (30 6 48 52 37 11 35 3 50 17 8 58 16 51 49 4 60 33 45 39 44 34 12 57 9 22 54 42 28 47 7 18))
                                                                                                 ((26 19 15 22 11 39 47 30 33 62 42 56 3 37 54 24 1 28 44 41 0 25 27 2 57 14 20 -1 21 16 60 6)
                                                                                                  (32 31 7 49 53 38 12 36 4 51 18 9 59 17 52 50 5 61 34 46 40 45 35 13 58 10 23 55 43 29 48 8))
                                                                                                 ((27 9 20 16 23 12 40 48 31 34 0 43 57 4 38 55 25 2 29 45 42 1 26 28 3 58 15 21 -1 22 17 61)
                                                                                                  (7 33 32 8 50 54 39 13 37 5 52 19 10 60 18 53 51 6 62 35 47 41 46 36 14 59 11 24 56 44 30 49))
                                                                                                 ((28 50 10 21 17 24 13 41 49 32 35 1 44 58 5 39 56 26 3 30 46 43 2 27 29 4 59 16 22 -1 23 18)(62 8 34 33 9 51 55 40 14 38 6 53 20 11 61 19 54 52 7 0 36 48 42 47 37 15 60 12 25 57 45 31))
                                                                                                 ((29 32 51 11 22 18 25 14 42 50 33 36 2 45 59 6 40 57 27 4 31 47 44 3 28 30 5 60 17 23 -1 24)
                                                                                                  (19 0 9 35 34 10 52 56 41 15 39 7 54 21 12 62 20 55 53 8 1 37 49 43 48 38 16 61 13 26 58 46))
                                                                                                 ((30 47 33 52 12 23 19 26 15 43 51 34 37 3 46 60 7 41 58 28 5 32 48 45 4 29 31 6 61 18 24 -1)
                                                                                                  (25 20 1 10 36 35 11 53 57 42 16 40 8 55 22 13 0 21 56 54 9 2 38 50 44 49 39 17 62 14 27 59))
                                                                                                 ((31 60 48 34 53 13 24 20 27 16 44 52 35 38 4 47 61 8 42 59 29 6 33 49 46 5 30 32 7 62 19 25)
                                                                                                  (-1 26 21 2 11 37 36 12 54 58 43 17 41 9 56 23 14 1 22 57 55 10 3 39 51 45 50 40 18 0 15 28))
                                                                                                 ((32 29 61 49 35 54 14 25 21 28 17 45 53 36 39 5 48 62 9 43 60 30 7 34 50 47 6 31 33 8 0 20)
                                                                                                  (26 -1 27 22 3 12 38 37 13 55 59 44 18 42 10 57 24 15 2 23 58 56 11 4 40 52 46 51 41 19 1 16))
                                                                                                 ((33 17 30 62 50 36 55 15 26 22 29 18 46 54 37 40 6 49 0 10 44 61 31 8 35 51 48 7 32 34 9 1)
                                                                                                  (21 27 -1 28 23 4 13 39 38 14 56 60 45 19 43 11 58 25 16 3 24 59 57 12 5 41 53 47 52 42 20 2))
                                                                                                 ((34 3 18 31 0 51 37 56 16 27 23 30 19 47 55 38 41 7 50 1 11 45 62 32 9 36 52 49 8 33 35 10)
                                                                                                  (2 22 28 -1 29 24 5 14 40 39 15 57 61 46 20 44 12 59 26 17 4 25 60 58 13 6 42 54 48 53 43 21))
                                                                                                 ((35 22 4 19 32 1 52 38 57 17 28 24 31 20 48 56 39 42 8 51 2 12 46 0 33 10 37 53 50 9 34 36)
                                                                                                  (11 3 23 29 -1 30 25 6 15 41 40 16 58 62 47 21 45 13 60 27 18 5 26 61 59 14 7 43 55 49 54 44))
                                                                                                 ((36 45 23 5 20 33 2 53 39 58 18 29 25 32 21 49 57 40 43 9 52 3 13 47 1 34 11 38 54 51 10 35)
                                                                                                  (37 12 4 24 30 -1 31 26 7 16 42 41 17 59 0 48 22 46 14 61 28 19 6 27 62 60 15 8 44 56 50 55))
                                                                                                 ((37 56 46 24 6 21 34 3 54 40 59 19 30 26 33 22 50 58 41 44 10 53 4 14 48 2 35 12 39 55 52 11)
                                                                                                  (36 38 13 5 25 31 -1 32 27 8 17 43 42 18 60 1 49 23 47 15 62 29 20 7 28 0 61 16 9 45 57 51))
                                                                                                 ((38 52 57 47 25 7 22 35 4 55 41 60 20 31 27 34 23 51 59 42 45 11 54 5 15 49 3 36 13 40 56 53)
                                                                                                  (12 37 39 14 6 26 32 -1 33 28 9 18 44 43 19 61 2 50 24 48 16 0 30 21 8 29 1 62 17 10 46 58))
                                                                                                 ((39 59 53 58 48 26 8 23 36 5 56 42 61 21 32 28 35 24 52 60 43 46 12 55 6 16 50 4 37 14 41 57)
                                                                                                  (54 13 38 40 15 7 27 33 -1 34 29 10 19 45 44 20 62 3 51 25 49 17 1 31 22 9 30 2 0 18 11 47))
                                                                                                 ((40 48 60 54 59 49 27 9 24 37 6 57 43 62 22 33 29 36 25 53 61 44 47 13 56 7 17 51 5 38 15 42)
                                                                                                  (58 55 14 39 41 16 8 28 34 -1 35 30 11 20 46 45 21 0 4 52 26 50 18 2 32 23 10 31 3 1 19 12))
                                                                                                 ((41 13 49 61 55 60 50 28 10 25 38 7 58 44 0 23 34 30 37 26 54 62 45 48 14 57 8 18 52 6 39 16)
                                                                                                  (43 59 56 15 40 42 17 9 29 35 -1 36 31 12 21 47 46 22 1 5 53 27 51 19 3 33 24 11 32 4 2 20))
                                                                                                 ((42 21 14 50 62 56 61 51 29 11 26 39 8 59 45 1 24 35 31 38 27 55 0 46 49 15 58 9 19 53 7 40)
                                                                                                  (17 44 60 57 16 41 43 18 10 30 36 -1 37 32 13 22 48 47 23 2 6 54 28 52 20 4 34 25 12 33 5 3))
                                                                                                 ((43 4 22 15 51 0 57 62 52 30 12 27 40 9 60 46 2 25 36 32 39 28 56 1 47 50 16 59 10 20 54 8)
                                                                                                  (41 18 45 61 58 17 42 44 19 11 31 37 -1 38 33 14 23 49 48 24 3 7 55 29 53 21 5 35 26 13 34 6))
                                                                                                 ((44 7 5 23 16 52 1 58 0 53 31 13 28 41 10 61 47 3 26 37 33 40 29 57 2 48 51 17 60 11 21 55)
                                                                                                  (9 42 19 46 62 59 18 43 45 20 12 32 38 -1 39 34 15 24 50 49 25 4 8 56 30 54 22 6 36 27 14 35))
                                                                                                 ((45 36 8 6 24 17 53 2 59 1 54 32 14 29 42 11 62 48 4 27 38 34 41 30 58 3 49 52 18 61 12 22)
                                                                                                  (56 10 43 20 47 0 60 19 44 46 21 13 33 39 -1 40 35 16 25 51 50 26 5 9 57 31 55 23 7 37 28 15))
                                                                                                 ((46 16 37 9 7 25 18 54 3 60 2 55 33 15 30 43 12 0 49 5 28 39 35 42 31 59 4 50 53 19 62 13)
                                                                                                  (23 57 11 44 21 48 1 61 20 45 47 22 14 34 40 -1 41 36 17 26 52 51 27 6 10 58 32 56 24 8 38 29))
                                                                                                 ((47 30 17 38 10 8 26 19 55 4 61 3 56 34 16 31 44 13 1 50 6 29 40 36 43 32 60 5 51 54 20 0)
                                                                                                  (14 24 58 12 45 22 49 2 62 21 46 48 23 15 35 41 -1 42 37 18 27 53 52 28 7 11 59 33 57 25 9 39))
                                                                                                 ((48 40 31 18 39 11 9 27 20 56 5 62 4 57 35 17 32 45 14 2 51 7 30 41 37 44 33 61 6 52 55 21)
                                                                                                  (1 15 25 59 13 46 23 50 3 0 22 47 49 24 16 36 42 -1 43 38 19 28 54 53 29 8 12 60 34 58 26 10))
                                                                                                 ((49 11 41 32 19 40 12 10 28 21 57 6 0 5 58 36 18 33 46 15 3 52 8 31 42 38 45 34 62 7 53 56)
                                                                                                  (22 2 16 26 60 14 47 24 51 4 1 23 48 50 25 17 37 43 -1 44 39 20 29 55 54 30 9 13 61 35 59 27))
                                                                                                 ((50 28 12 42 33 20 41 13 11 29 22 58 7 1 6 59 37 19 34 47 16 4 53 9 32 43 39 46 35 0 8 54)
                                                                                                  (57 23 3 17 27 61 15 48 25 52 5 2 24 49 51 26 18 38 44 -1 45 40 21 30 56 55 31 10 14 62 36 60))
                                                                                                 ((51 61 29 13 43 34 21 42 14 12 30 23 59 8 2 7 60 38 20 35 48 17 5 54 10 33 44 40 47 36 1 9)
                                                                                                  (55 58 24 4 18 28 62 16 49 26 53 6 3 25 50 52 27 19 39 45 -1 46 41 22 31 57 56 32 11 15 0 37))
                                                                                                 ((52 38 62 30 14 44 35 22 43 15 13 31 24 60 9 3 8 61 39 21 36 49 18 6 55 11 34 45 41 48 37 2)
                                                                                                  (10 56 59 25 5 19 29 0 17 50 27 54 7 4 26 51 53 28 20 40 46 -1 47 42 23 32 58 57 33 12 16 1))((53 2 39 0 31 15 45 36 23 44 16 14 32 25 61 10 4 9 62 40 22 37 50 19 7 56 12 35 46 42 49 38)
                                                                                                                                                                                                (3 11 57 60 26 6 20 30 1 18 51 28 55 8 5 27 52 54 29 21 41 47 -1 48 43 24 33 59 58 34 13 17))
                                                                                                                                                                                               ((54 18 3 40 1 32 16 46 37 24 45 17 15 33 26 62 11 5 10 0 41 23 38 51 20 8 57 13 36 47 43 50)
                                                                                                                                                                                                (39 4 12 58 61 27 7 21 31 2 19 52 29 56 9 6 28 53 55 30 22 42 48 -1 49 44 25 34 60 59 35 14))
                                                                                                                                                                                               ((55 15 19 4 41 2 33 17 47 38 25 46 18 16 34 27 0 12 6 11 1 42 24 39 52 21 9 58 14 37 48 44)
                                                                                                                                                                                                (51 40 5 13 59 62 28 8 22 32 3 20 53 30 57 10 7 29 54 56 31 23 43 49 -1 50 45 26 35 61 60 36))
                                                                                                                                                                                               ((56 37 16 20 5 42 3 34 18 48 39 26 47 19 17 35 28 1 13 7 12 2 43 25 40 53 22 10 59 15 38 49)
                                                                                                                                                                                                (45 52 41 6 14 60 0 29 9 23 33 4 21 54 31 58 11 8 30 55 57 32 24 44 50 -1 51 46 27 36 62 61))
                                                                                                                                                                                               ((57 62 38 17 21 6 43 4 35 19 49 40 27 48 20 18 36 29 2 14 8 13 3 44 26 41 54 23 11 60 16 39)
                                                                                                                                                                                                (50 46 53 42 7 15 61 1 30 10 24 34 5 22 55 32 59 12 9 31 56 58 33 25 45 51 -1 52 47 28 37 0))
                                                                                                                                                                                               ((58 1 0 39 18 22 7 44 5 36 20 50 41 28 49 21 19 37 30 3 15 9 14 4 45 27 42 55 24 12 61 17)
                                                                                                                                                                                                (40 51 47 54 43 8 16 62 2 31 11 25 35 6 23 56 33 60 13 10 32 57 59 34 26 46 52 -1 53 48 29 38))
                                                                                                                                                                                               ((59 39 2 1 40 19 23 8 45 6 37 21 51 42 29 50 22 20 38 31 4 16 10 15 5 46 28 43 56 25 13 62)
                                                                                                                                                                                                (18 41 52 48 55 44 9 17 0 3 32 12 26 36 7 24 57 34 61 14 11 33 58 60 35 27 47 53 -1 54 49 30))
                                                                                                                                                                                               ((60 31 40 3 2 41 20 24 9 46 7 38 22 52 43 30 51 23 21 39 32 5 17 11 16 6 47 29 44 57 26 14)
                                                                                                                                                                                                (0 19 42 53 49 56 45 10 18 1 4 33 13 27 37 8 25 58 35 62 15 12 34 59 61 36 28 48 54 -1 55 50))
                                                                                                                                                                                               ((61 51 32 41 4 3 42 21 25 10 47 8 39 23 53 44 31 52 24 22 40 33 6 18 12 17 7 48 30 45 58 27)
                                                                                                                                                                                                (15 1 20 43 54 50 57 46 11 19 2 5 34 14 28 38 9 26 59 36 0 16 13 35 60 62 37 29 49 55 -1 56))
                                                                                                                                                                                               ((62 57 52 33 42 5 4 43 22 26 11 48 9 40 24 54 45 32 53 25 23 41 34 7 19 13 18 8 49 31 46 59)
                                                                                                                                                                                                (28 16 2 21 44 55 51 58 47 12 20 3 6 35 15 29 39 10 27 60 37 1 17 14 36 61 0 38 30 50 56 -1)))))
(define-values (all_63_57_div_pows_pairs_sums all_63_57_qut_prods_pairs
                                              all_63_57_poly_sum_pairs)
  (values (car RS_63_57_all_pow_combs) (second RS_63_57_all_pow_combs) (third
                                                                        RS_63_57_all_pow_combs)))
(define (append-with-duplicates lst n)
  (let ([dup (duplicate lst (sub1 n))])
    (append* lst dup)))
(define (shift-left lst)
  (append (cdr lst) (list (car lst))))
(define (convol-sum lst1 lst2)
  (let* ([lpl (- (+ (length lst1) (length lst2)) 2)]
         [p-lst1 (pad-left (reverse lst1) lpl (lambda(x) 0))]
         [p-lst2 (pad-right (pad-left lst2 (sub1 (length lst1)) (lambda(x) 0))
                            (sub1 (length lst1)) (lambda(x) 0))])
    (let rec ([x p-lst1][y p-lst2][i 1][acc '()])
      (if (>= i (+ (length lst1) (length lst2)))
          acc
          (rec (shift-left x) y (add1 i)
            (cons (vector-dot-prod (take (drop x (- lpl (sub1 i))) i)
                                   (take (drop y (- lpl (sub1 i))) i)) acc))))))
(define (merge-distinct-ele lst1 lst2)
  (let rec ([x lst1][acc lst2])(if (null? x)
                                   (sort acc <)
                                   ;                                   acc
                                   (if (member (car x) acc)
                                       (rec (cdr x) (remove (car x) acc))
                                       (rec (cdr x) (cons (car x) acc))))))
(define (merge-distinct-ele-lists lsts)
  (remove-duplicates (map (lambda(x) (flatten x))
                          (for*/fold ([acc (car lsts)]) ([i (cdr lsts)]) (merge-distinct-ele acc i)))))
(define (prim-poly-candidates deg)
  (map (lambda(x) (flatten (cons (cons 1 x) '(1)))) (info-bits (- deg 2))))
(define (split-genmat-cols m)
  (list (map (lambda(x) (take x (length m))) m) (map (lambda(x) (drop x (length m))) m)))
(define (systematize-cyclic-matrix3 m)
  (let* ([s-m (split-genmat-cols m)][i-cls (car s-m)][pcc (last s-m)]
                                    [all-a1s (map (lambda(x) (get-all-matching-pos 1 x)) i-cls)])
    (let rec ([x (drop-right all-a1s 1)][acc pcc])
      (if (null? x)
          (append-cols (idn-mat (length i-cls)) (make-rect acc))
          (if (cons? (cdr (last x)))
              (rec (drop-right x 1)
                (replace-row acc (add-binary-polys (collect-elements acc (last x))) (car (last x))))
              (rec (drop-right x 1) acc))))))
(define (systematic-gm-n-3 n g) (systematize-cyclic-matrix3 (cyclic-genmat-n n g)))
(define (isprim?-3 p)
  (if (and (= 1 (car p)) (= 1 (parity p)) (= 1 (last p)))
      (let* ([a1s (get-all-matching-pos 1 p)][np (map (lambda(x) (+ x (- (second a1s) (car a1s)))) a1s)]
                                             [n (sub1 (expt 2 (degree p)))])
        (let rec ([il1 (drop a1s 2)][fcz (car np)][il2 (cdr np)][acc (list (drop a1s 2) np)])
          (if (or (null? (cdr (merge-distinct-ele il1 il2))) (>= fcz (- n (degree p))))
              ;(list (last acc) (merge-distinct-ele il1 il2))
              (= n (car (merge-distinct-ele il1 il2)))
              ;              (if (= (car il1) n)
              ;                  #t il1)
              (let* ([mp (merge-distinct-ele il1 il2)]
                     [il2 (map (lambda(x) (+ x (- (car mp) fcz))) (cons fcz il2))])
                (if (or (null? mp) (null? il2))
                    #f
                    (rec (cdr mp) (car il2) (cdr il2) (cons (list (cdr mp) (cdr il2)) acc))))))) #f))
(define (all-2-comb lst)
  (let rec ([x lst][acc '()])(if (null? (cdr x))
                                 (reverse acc)
                                 (rec (cdr x) (append (map (lambda(z) (list (car x) z)) (cdr x)) acc)))))
(define (all-comb lst n)
  (let rec ([i 2][acc (all-2-comb lst)])
    (if (= i n)
        (reverse acc)
        (rec (add1 i) (remove-duplicates (map (lambda(x) (sort x <))
                                              (append-map
                                               (lambda (x y)
                                                 (map (lambda(z) (cons z x))
                                                      (remove* x y))) acc (duplicate lst (length acc)))))))))
(define (target-bins n sz gap)
  (build-list n (lambda(x) (cons (cons
                                  (+ (* x sz) (* x gap))
                                  (+ (* (add1 x) sz) (* x gap))) 0))))
(define (random-n n range)
  (build-list n (lambda(x) (random range))))
(define (in-range? n x y)
  (and (>= n x) (<= n y)))
(define (empty-bins bin-l rn cn)
  (let rec ([x rn][y cn][acc bin-l])
    (if (or (null? x) (null? y))
        acc
        (let ([mch (filter (lambda(z) (and (in-range? (car x) (caar (first z)) (cdar (first z)))
                                           (in-range? (car y) (caar (last z)) (cdar (last z))))) acc)])
          (rec (cdr x) (cdr y) (remove* mch acc))))))
(define (m-l lst) (map (lambda(y)
                         (apply * (map (lambda(x) (if (positive? x) (num-error-patterns 4 x) 1)) y))) lst))
(define (check-linear-indp m)
  (map (lambda(x) (equal? x (add-binary-polys (remove x m)))) m))
(define (BCH-gm d t)
  (let* ([g (BCH-gp d t)][n (sub1 (expt 2 d))])
    (cyclic-genmat-n n g)))
(define (get-prime-factors n)
  (if (> (log2 n) (length prime-n))
      prime-n
      (take prime-n (log2 n))))(define prime-n '(2 3 5 7 11 13 17 19 23 31))
(define (all-interger-permuts n)
  (append-all-permutations-lists2 (list-sqrd (build-list n values))))
(define (prime-powers-to-number pr-l)
  (apply * (map (lambda(w y) (expt w y)) (take prime-n (length pr-l)) pr-l)))
(define (all-powers-of-primes n)
  (let ([pows (map (lambda(x) (map (lambda(w y) (expt w y)) (take prime-n n) x))
                   (all-interger-permuts n))])
    (map (lambda(x) (apply * x)) pows)))
(define (mult-prime-powers lst1 lst2)
  (prime-powers-to-number (map (lambda(x y) (+ x y)) lst1 lst2)))
(define (div-prime-powers lst1 lst2)
  (prime-powers-to-number (map (lambda(x y) (- x y)) lst1 lst2)))
(define (lcm2 lst1 lst2)
  (decimal-2-binary-list
   (lcm (binary-list-2-decimal lst1) (binary-list-2-decimal lst2))))
(define (lcm-polys gp-l)
  (for*/fold ([acc (car gp-l)]) ([i (cdr gp-l)]) (lcm2 acc i)))
(define (systematic-BCH-gm d t)
  (systematize-cyclic-matrix3 (BCH-gm d t)))
(define (count-all-ele lst)
  (map (lambda(x) (cons x (count (lambda(z) (equal? z x)) lst))) (remove-duplicates lst)))
(define (BCH-parity-mat d t)
  (let* ([g (get-prim-poly d prim-polys-list)][n (sub1 (expt 2 d))][r-l (cdr (GF2-root-factorize g))]
                                              [o-pow-l (map (lambda(x) (sub1 (* 2 (add1 x)))) (build-list 5 values))]
                                              [power-of-prim-ele (lambda(pw) (list-ref r-l (modulo pw n)))]
                                              [res (build-list n (lambda(x)
                                                                   (flatten (build-list t
                                                                                        (lambda(y)
                                                                                          (power-of-prim-ele
                                                                                           (* x (list-ref o-pow-l y))))
                                                                                        ))))])
    ; (append (list (car res)) (reverse (cdr res)))
    (reverse res)
    ))
(define (BCH-gm-parity-check d t)
  (all-zeros? (flatten (binary-mat-mult (BCH-gm d t) (BCH-parity-mat d t)))))(define (BCH-syst-gm-parity-check d t)
                                                                               (all-zeros? (flatten (binary-mat-mult (systematic-BCH-gm d t) (BCH-parity-mat d t)))))
(define (eval-RS-poly g p-l e-p)
  (let* ([n (sub1 (expt 2 (degree g)))][r-l (cdr (GF2-root-factorize g))]
                                       [power-of-prim-ele (lambda(pw)
                                                            (if (= -1 pw) (zeros (degree g))
                                                                (list-ref r-l (modulo pw n))))]
                                       [poly-ele-powers (map (lambda(x) (* x e-p))
                                                             (get-all-matching-pos-pred
                                                              (negate negative?) (reverse p-l)))]
                                       [poly-ele-coeff (map (lambda(x) (power-of-prim-ele x)) poly-ele-powers)]
                                       [RS-poly-cff (map (lambda(x y) (power-of-prim-ele (+ x y)))
                                                         poly-ele-powers (filter
                                                                          (negate negative?) (reverse p-l)))])
    (add-binary-polys RS-poly-cff)))
(define (run-rows-sum-weight m)
  (let* ([o-t (reverse (make-rect (ones-triangle (length m))))]
         [rr-s-w (map (lambda(x y) (cons y (weight x))) (binary-mat-mult o-t m) o-t)]
         [rr-s-w-srt (sort rr-s-w (lambda(x y) (< (cdr x) (cdr y))))]
         [min-cw-w (cdar rr-s-w-srt)]
         [min-w-ib (filter (lambda(x) (= min-cw-w (cdr x))) rr-s-w-srt)])
    min-w-ib))
(define (add-dependent-row m r-l)
  (make-rect (append m (list (add-binary-polys (collect-elements m r-l))))))
(define (remove-all-even-duplicates m)
  (let* ([c-e (count-all-ele m)][o-de (filter (lambda(x) (odd? (cdr (assoc x c-e)))) m)])
    (if (cons? o-de)
        (map (lambda(x) (car x)) (count-all-ele o-de))
        '())))
(define (remove-duplicated-elements m)
  (let rec ([x m][acc m])
    (if (null? x)
        acc
        (if (cons? (member (car x) (cdr x)))
            (rec (cdr x) (remove* (list (car x)) acc))
            (rec (cdr x) acc)))))
(define (BCH-cw-remainders cw d t)
  (map (lambda(x) (binary-rem cw x)) (take (all-conj-prim-poly (get-prim-poly d prim-polys-list)) t)))
(define (powers-of-roots-d d)
  (powers-of-roots (get-prim-poly d prim-polys-list)))(define (pow-binary-poly g p)
                                                        (let rec ([x 1][acc g])
                                                          (if (>= x p)
                                                              acc
                                                              (rec (add1 x) (binary-mult-poly acc g)))))
(define (mult-GF2-pows p1 p2 g)
  (if (or (= p1 -1) (= p2 -1)) -1 (power-eqv-of-prim-ele
                                   (power-of-prim-ele g (modulo (+ p1 p2) (sub1 (expt 2 (degree g))))) g)))
(define (add-GF2-pows p-lst g)
  (if (null? p-lst) -1
      (let* ([n (sub1 (expt 2 (degree g)))][p-l p-lst]
                                           [r-l (cdr (GF2-root-factorize g))]
                                           [power-of-prim-ele (lambda(pw) (if (= -1 pw) (zeros (degree g))
                                                                              (list-ref r-l (modulo pw n))))])
        (if (null? p-l) 0
            (if (null? (cdr p-l)) (car p-l)
                (power-eqv-of-prim-ele (add-binary-polys (map (lambda(x) (power-of-prim-ele x)) p-l))
                                       g))))))
(define (power-eqv-of-prim-ele e g)
  (sub1 (get-first-matching-pos e (GF2-root-factorize g))))
(define (get-all-matching-pos-pred proc lst)
  (let rec ([p 0][np 0][acc '()])
    (if (= p (length lst))
        (reverse acc)
        (if (proc (list-ref lst p))
            (rec (add1 p) (add1 np) (cons p acc))
            (rec (add1 p) np acc)))))
(define (duplicate-append lst n)
  (let ([dup (duplicate lst n)])
    (append* (car dup) (cdr dup))))
(define (first-common-ele lst1 lst2)
  (let rec ([x lst1])
    (if (null? x)
        x
        (if (member (car x) lst2)
            (car x)
            (rec (cdr x))))))
(define (add-GF2-pows-2D p-lsts g)
  (let* ([n (sub1 (expt 2 (degree g)))][r-l (cdr (GF2-root-factorize g))]
                                       [power-of-prim-ele (lambda(pw) (if (= -1 pw) (zeros (degree g))
                                                                          (list-ref r-l (modulo pw n))))]
                                       [r-sum (lambda(p-l) (if (null? p-l) 0(if (null? (cdr p-l)) (car p-l) (power-eqv-of-prim-ele
                                                                                                             (add-binary-polys
                                                                                                              (map (lambda(x)
                                                                                                                     (power-of-prim-ele x)) p-l)) g))))])
    (map (lambda(x) (r-sum x)) p-lsts)))
(define (RS-poly num-r g)
  (let rec ([x 2][acc '((0) (1 2) (3))])
    (let* ([zp (add1 x)][z-f0 (map (lambda(b) (map (lambda(d) (+ d zp)) b)) (drop-right acc 1))]
                        [z-f (append z-f0 (list (list (+ zp (last (last acc))))))]
                        [s-f0 (map (lambda(a b) (append a b)) (cdr acc) z-f0)
                              ;                              (append acc '((0))) (cons '(0) z-f))
                              ]
                        [s-f (cons (car acc) (append s-f0 (list (list (+ zp (last (last acc)))))))]
                        ;[add-GF2-pows (lambda(p-l) ())]
                        )
      (if (= x num-r)
          ;(values
          (append (add-GF2-pows-2D (drop-right acc 1) g)
                  (list (modulo (last (last acc)) (sub1 (expt 2 (degree g))))))
          ;acc
          ;)
          (rec zp s-f)))))
(define (RS-poly-deg d num-r)
  (RS-poly num-r (get-prim-poly d prim-polys-list)))
(define (sampled-unit-sin k n)
  (sampled-func 1 sin k n))
(define (sampled-unit-cos k n)
  (sampled-func 1 cos k n))
(define (sampled-func-fq a fn fq n k)
  (map (lambda(t) (* a (fn (* (* (* n t) (* 2 pi)) fq)))) (build-list n (lambda(x) (* x (/ 1 (* n k)))))))
(define (sampled-unit-sin-fq fq k n)
  (sampled-func-fq 1 sin fq k n))
(define (sampled-unit-cos-fq fq k n)
  (sampled-func-fq 1 cos fq k n))
(define (dft lst)
  (let* ([n (length lst)])
    (map (lambda(x) (make-rectangular (round (real-part x))
                                      (round (imag-part x)))) (car (mat-mult (list lst) (dft-kernel n))))))
(define (dft-kernel n)
  (build-list n (lambda(x) (map (lambda(r i) (make-rectangular r (- 0 i)))(sampled-unit-cos-fq x n n) (sampled-unit-sin-fq x n n)))))
(define (phase-shifted-sin ps fq n)
  (take (drop (sampled-unit-sin-fq fq (sub1 (* 2 n)) n) ps) n))
(define (add-GF2-pows-3D p-lsts g)
  (let* ([n (sub1 (expt 2 (degree g)))][r-l (cdr (GF2-root-factorize g))]
                                       [power-of-prim-ele (lambda(pw)
                                                            (if (= -1 pw) (zeros (degree g))
                                                                (list-ref r-l (modulo pw n))))]
                                       [r-sum (lambda(p-l)
                                                (if (null? p-l) 0 (if (null? (cdr p-l)) (car p-l) (power-eqv-of-prim-ele
                                                                                                   (add-binary-polys
                                                                                                    (map (lambda(x) (power-of-prim-ele x))
                                                                                                         p-l))
                                                                                                   g))))])
    (map (lambda(y) (map (lambda(x) (r-sum x))) y) p-lsts)))
(define (encode-RS-poly p g num-r) (mult-RS-polys p (RS-poly num-r g) g num-r))
(define (cyclic-RS-genmat d t)
  (let* ([g (get-prim-poly d prim-polys-list)][n (sub1 (expt 2 (degree g)))][num-r (* 2 t)])
    (cyclic-RS-genmat-k g (- n num-r) num-r)))
(define (cyclic-RS-genmat-n g n num-r)
  (cyclic-RS-genmat-k g (- n num-r) num-r))
(define (cyclic-RS-genmat-k g k num-r)
  (let* ([RS-g (RS-poly num-r g)][RS-gb (flatten (map (lambda(x) (power-of-prim-ele g x)) RS-g))]
                                 [RS-gm-1st-r (pad-right RS-g (sub1 k)
                                                         ;(* (add1 (length RS-g)) (degree g))
                                                         (lambda(x) -1))]
                                 [RS-gm-non-1st-r (map (lambda(x) (cyclic-right-shift RS-gm-1st-r x))
                                                       (build-list (sub1 k) add1)
                                                       ;(build-list (sub1 k) (lambda(x) (* (add1 x) (degree g))))
                                                       )])
    (cons RS-gm-1st-r RS-gm-non-1st-r)
    ;(build-list (sub1 k) (lambda(x) (* (add1 x) (degree g))))
    ))
(define (remove-rows lst r-l)
  (if (null? r-l) lst
      (remove* (collect-elements lst r-l) lst)))
(define (all-RS-zero-pows? lst)
  (null? (filter (lambda(x) (not (= -1 x))) lst)))
(define (cyclic-RS-genmat-n-bin g n num-r)
  (map (lambda(y) (flatten (map (lambda(x) (power-of-prim-ele g x)) y))) (cyclic-RS-genmat-n g n num-r)))
(define (cyclic-RS-genmat-k-bin g k num-r)
  (map (lambda(y) (flatten (map (lambda(x) (power-of-prim-ele g x)) y))) (cyclic-RS-genmat-k g k
                                                                                             num-r)))
(define (gen-RS-prim-dvnd deg)
  (flatten (cons (cons 0 (build-list (sub1 deg) (lambda(x) -1))) '(0))))
(define (RS-prim-poly-test-deg d pw)
  (map (lambda(x) (eval-RS-poly (get-prim-poly d prim-polys-list) x pw))
       (map (lambda(x) (gen-RS-prim-dvnd x))
            (build-list (sub1 (expt 2 (degree (get-prim-poly d prim-polys-list)))) (lambda(x) (+ x 1))))))
(define (sampled-fixpt-sin k n)
  (map (lambda(x) (inexact->exact (round x))) (sampled-func 1000 sin k n)))
(define (sampled-fixpt-cos k n)
  (map (lambda(x) (inexact->exact (round x))) (sampled-func 1000 cos k n)))
(define (sampled-fixpt-sin-fq fq k n)
  (map (lambda(x) (inexact->exact (round x))) (sampled-func-fq 10 sin fq k n)))
(define (sampled-fixpt-cos-fq fq k n)
  (map (lambda(x) (inexact->exact (round x))) (sampled-func-fq 10 cos fq k n)))
(define (fixpt-cos-freqs n)
  (let ([n-fq (* n 4)])
    (build-list n-fq (lambda(x) (sampled-fixpt-cos-fq (/ (add1 x) n-fq) n-fq n)))))
(define (fixpt-sin-freqs n)
  (let ([n-fq (* n 4)])
    (build-list n-fq (lambda(x) (sampled-fixpt-sin-fq (/ (add1 x) n-fq) n-fq n)))))
(define (plot-sinc n-fq)
  (let* ([sinc (map (lambda(x) (apply + x)) (transpose (fixpt-cos-freqs n-fq)))]
         [max-s (car (sort sinc >))] [min-s (car (sort sinc <))])
    (plot (points (map vector (build-list (length sinc) values) sinc) #:y-max (+ 100 max-s)
                  #:y-min (- min-s 100)))))
(define (plot-sinc2 n-fq)
  (let* ([sinc (map (lambda(x) (apply + x)) (transpose (fixpt-sin-freqs n-fq)))]
         [max-s (car (sort sinc >))] [min-s (car (sort sinc <))])
    (plot (points (map vector (build-list (length sinc) values) sinc) #:y-max (+ 100 max-s)
                  #:y-min (- min-s 100)))))
(define (add-cols m c-l p)
  (transpose (add-rows (transpose m) c-l p)))(define (num-non-cyc-cw c)
                                               (let rec ([x c][acc-nc 0][acc-cy 0])
                                                 (if (null? x)
                                                     (list 'non-cyclic: acc-nc 'cyclic: acc-cy)
                                                     (let* ([s-ele (cyclic-shift-mat (car x))][s-ele-l (length s-ele)][x-l (length x)]
                                                                                              [non-s-ele (remove* s-ele x)]
                                                                                              [non-s-ele-l (length non-s-ele)]
                                                                                              [diff-l (- x-l non-s-ele-l)])
                                                       (rec non-s-ele (+ acc-nc (- s-ele-l diff-l)) (+ acc-cy diff-l))))))
(define (num-non-cyc-cw-gm gm)
  (num-non-cyc-cw (encode-linear-code gm)))
(define (group-cols m n)
  (group-list (transpose m) n))
(define (get-parity-cols gm)
  (let* ([n (width gm)][k (length gm)][p (- n k)]) (sub-mat (systematize-cyclic-matrix3 gm) 0 k k n)))
(define (encode-parity-bits gm)
  (let* ([pm (get-parity-cols gm)][l (if (> (length gm) 10) 8 (length gm))][ib (info-bits l)]
                                  [pm-g (group-list pm l)]
                                  [c-pm (map (lambda(x) (encode-linear-code x)) pm-g)]
                                  [c-ecb (map (lambda(z) (map (lambda(x y) (list x y)) ib
                                                              (encode-linear-code z)) pm-g))][k (length gm)])
    (let* ([rl (expt 2 (sub1 k))])
      (let rec ([i 1][j 2][z (/ rl 2)]
                     [acc (list (zeros-ones-eql-repeat-seq 1 rl))])
        (if (= i k)
            (transpose acc)
            (rec (add1 i) (* j 2) (/ z 2)
              (cons (zeros-ones-eql-repeat-seq j z) acc)))))))
(define (encode-systematic-RM-code r m)
  (let-values ([(sm smc) (systematic-RM-gen r m)])
    (let* ([pm (get-RM-parity-mat-m sm smc)])
      (append-cols (info-bits (length pm)) (encode-linear-code pm)))))
;[encode-systematic-RM-code (positive? positive? . -> . rectangular-matrix/c)]
(define (is-cyclic?-2 m)
  (let* ([c-sm (cyclic-shift-mat (car m))][c-sm-rmv (remove* m c-sm)])
    (= (length c-sm-rmv) (- (length c-sm) (length m)))))
(define (info-bits-op k)
  (for*/fold ([acc '()])
             ([i (expt 2 (sub1 k))] [k 3]) i))(define (info-bits-op2 k)
                                                (let rec ([i 0])
                                                  (if (= i (expt 2 (sub1 k))) i (rec (add1 i)))))
(define (check-cyclicity-gm2 gm)
  (check-cyclicity2 (encode-linear-code gm)))
(define (check-cyclicity2 lst)
  (let rec ([l (filter (lambda(x) (and (= 1 (car x)) (= 1 (last x)))) lst)])
    (if (null? l)
        #t
        (let rec-i ([n (sub1 (length (car l)))])
          (if (= n 1)
              (rec (cdr l))
              (if (member (cyclic-left-shift (car l) n) lst)
                  (rec-i (sub1 n))
                  #f))))))
(define (sampled-non-prdc-func fn n)
  (map (lambda(t) (fn t)) (build-list n values)))
(define fn (lambda(x) (+ (* 12 (expt (cos x) 2)) (- 0 (* 3 (cos x))) (* 13 x) 22)))
(define (plot-func fn n)
  (let* ([fn-r (sampled-non-prdc-func fn 100)][max-s (car (sort fn-r >))][min-s (car (sort fn-r <))])
    (plot (points (map vector (build-list (length fn-r) values) fn-r) #:y-max (+ 100 max-s) #:y-min (- min-s 100)))))
(define (split-leading-RS-zeros lst)
  (let rec ([x lst][acc '()])
    (if (cons? x)
        (if (= -1 (car x))
            (rec (cdr x) (cons (car x) acc))
            (values acc x))
        (values acc x))))
(define (remove-leading-RS-zeros lst)
  (let rec ([x lst][acc '()])
    (if (cons? x)
        (if (= -1 (car x))
            (rec (cdr x) (cons (car x) acc)) x) x)))
(define (RS-poly-degree p)
  (let-values ([(s1 s2) (split-leading-RS-zeros p)])
    (if (cons? s2) (sub1 (length s2)) -1)))
(define (all-GF2-div-pairs-diffs g)
  (let*([n (sub1 (expt 2 (degree g)))][lst (build-list (add1 n) (lambda(x) (sub1 x)))])
    (map (lambda(x) (map (lambda(y) (add-GF2-pows (list x y) g)) lst)) lst)))(define (add-GF2-pows-2D-opti2 p-lsts g grt-r)
                                                                               (map (lambda(x) (power-eqv-of-prim-ele
                                                                                                (cdr (assoc (flatten (map (lambda(x) (modulo x (sub1 (expt 2 (degree g))))) x))
                                                                                                            grt-r)) g)) p-lsts))
(define (weighted-add-RS-genmat-parity-rows r-l p-l g num-r n)
  (add-RS-polys-rect (map (lambda(x) (binary-list->pow-list x g))
                          (make-rect-k (map (lambda(x) (pow-list->binary-list x g))
                                            (filter (and cons? cons?)
                                                    (map (lambda(x y) (mult-RS-polys x (list y)
                                                                                     g num-r)) r-l p-l)))
                                       (* n (degree g)))) g num-r))
(define (add-RS-polys p1 p2 g)
  (if (null? p1) p2 (if (null? p2) p1 (if (= (length p1) (length p2)) (add-GF2-pows-2D (transpose (list p1
                                                                                                        p2)) g)
                                          (if (longer p2 p1)
                                              (add-GF2-pows-2D (transpose
                                                                (list p2 (pad-left p1 (- (length p2) (length p1))
                                                                                   (lambda(x) -1)))) g)
                                              (add-GF2-pows-2D
                                               (transpose (list p1 (pad-left p2 (- (length p1) (length p2))
                                                                             (lambda(x) -1)))) g))))))
(define (add-RS-polys-rect p-lst g num-r)
  (let* ([n (sub1 (expt 2 (degree g)))][r-l (cdr (GF2-root-factorize g))]
                                       [power-of-prim-ele (lambda(pw) (if (= -1 pw) (zeros (degree g))
                                                                          (list-ref r-l (modulo pw n))))]
                                       [power-eqv-of-prim-ele
                                        (lambda(e) (if (all-zeros? e) -1 (get-first-matching-pos e r-l)))]
                                       [pow-list->binary-list (lambda(p-l)
                                                                (if (null? p-l) p-l (flatten
                                                                                     (map (lambda(x)
                                                                                            (power-of-prim-ele x))
                                                                                          p-l))))]
                                       [binary-list->pow-list (lambda(b-l)
                                                                (if (null? b-l) b-l
                                                                    (map (lambda(x) (power-eqv-of-prim-ele x)) b-l)))])
    (binary-list->pow-list (group-list (add-binary-polys
                                        (make-rect-k (map (lambda(x) (pow-list->binary-list x))
                                                          p-lst) (* (degree g) (length (car p-lst))))) (degree g)))))
(define (add-RS-polys-rect2 p-lst g r-l num-r)
  (let* ([n (sub1 (expt 2 (degree g)))][power-of-prim-ele (lambda(pw) (if (= -1 pw) (zeros (degree g))
                                                                          (list-ref r-l (modulo pw n))))]
                                       [power-eqv-of-prim-ele
                                        (lambda(e) (if (all-zeros? e) -1 (get-first-matching-pos e r-l)))][pow-list->binary-list (lambda(p-l)
                                                                                                                                   (if (null? p-l) p-l (flatten
                                                                                                                                                        (map (lambda(x)
                                                                                                                                                               (power-of-prim-ele x))
                                                                                                                                                             p-l))))]
                                                                                                          [binary-list->pow-list (lambda(b-l)
                                                                                                                                   (if (null? b-l) b-l
                                                                                                                                       (map (lambda(x) (power-eqv-of-prim-ele x)) b-l)))])
    (binary-list->pow-list (group-list (add-binary-polys
                                        (make-rect-k (map (lambda(x) (pow-list->binary-list x))
                                                          p-lst) (* (degree g) (length (car p-lst))))) (degree g)))))
(define (RS-poly-syndromes p g num-r)
  (map (lambda(x) (eval-RS-poly g p x)) (build-list num-r (lambda(x) (add1 x)))))
(define (cyclic-RS-genmat-k-2 RS-g k num-r)
  (let* ([RS-gm-1st-r (pad-right RS-g (sub1 k)
                                 ;(* (add1 (length RS-g)) (degree g))
                                 (lambda(x) -1))]
         [RS-gm-non-1st-r (map (lambda(x) (cyclic-right-shift RS-gm-1st-r x))
                               (build-list (sub1 k) add1)
                               ;(build-list (sub1 k) (lambda(x) (* (add1 x) (degree g))))
                               )])
    (cons RS-gm-1st-r RS-gm-non-1st-r)
    ;(build-list (sub1 k) (lambda(x) (* (add1 x) (degree g))))
    ))
(define (binary-poly-long-div-2 p1 p2) ; computes quotient/remainder for p1/p2
  (let* ([a1s-p1 (get-all-matching-pos 1 p1)][a1s-p2 (get-all-matching-pos 1 p2)]
                                             [n-p1 (map (lambda(x) (+ x (- (car a1s-p1) (car a1s-p2)))) a1s-p1)]
                                             [n1 (sub1 (expt 2 (degree p1)))][n2 (sub1 (expt 2 (degree p2)))])
    (let rec ([il1 (cdr a1s-p1)][il2 (cdr n-p1)][acc (list (car a1s-p2 2))][fcz (length (cdr n-p1))])
      (if (or (null? (merge-distinct-ele il1 il2)) (>= fcz (- n-p1 (degree p2))))
          (values il1 il2)
          (let* ([mp (merge-distinct-ele il1 il2)]
                 [il2 (map (lambda(x) (+ x (- (car mp) fcz))) (cons fcz il2))])
            (if (or (null? mp) (null? il2))
                #f
                (rec (cdr mp) (car il2) (cdr il2) (cons (list (cdr mp) (cdr il2)) acc))))))) #f)
(define (pow-list->binary-list p-l g)
  (let* ([n (sub1 (expt 2 (degree g)))][r-l (cdr (GF2-root-factorize g))]
                                       [power-of-prim-ele (lambda(pw) (if (= -1 pw) (zeros (degree g))
                                                                          (list-ref r-l (modulo pw n))))])
    (if (null? p-l) p-l (flatten (map (lambda(x) (power-of-prim-ele x)) p-l)))))
(define (binary-list->pow-list b-l g)
  (if (null? b-l) b-l(let* ([n (sub1 (expt 2 (degree g)))][b-l (group-list b-l (degree g))][r-l (cdr (GF2-root-factorize g))]
                                                          [power-eqv-of-prim-ele
                                                           (lambda(e) (if (all-zeros? e) -1 (get-first-matching-pos e r-l)))])
                       (map (lambda(x) (power-eqv-of-prim-ele x)) b-l))))
(define (insert-random-RS-zeros p k)
  (map (lambda(x y) (if (zero? x) y x))
       (map (lambda(x) (if (positive? x) -1 x)) (car (gen-random-nbit-patterns (length p) k 10))) p))
(define (RS-idn-mat k)
  (let* ([lst (append '(0) (duplicate -1 (sub1 k)))])
    (append (list lst) (reverse (map (lambda(x) (cyclic-left-shift lst x))
                                     (build-list (sub1 k) (lambda(x) (add1 x))))))))
(define (systematize-RS-matrix m g)
  (let*-values ([(s-m) (split-genmat-cols m)][(i-cls) (car s-m)][(pcc) m][(n-r) (- (width m) (length m))]
                                             [(RS-g)(RS-poly n-r g)][(drsg) (degree RS-g)])
    (let rec ([x (drop-right pcc 1)][i 1][acc (take-right pcc 1)])
      (if (>= i (length m))
          ;          (append-cols (RS-idn-mat (length i-cls)) acc)
          acc
          (if (> i drsg)
              ;              acc
              (rec (drop-right x 1) (add1 i) (cons (weighted-add-RS-genmat-parity-rows
                                                    (cons (last x) (take acc (add1 drsg))) RS-g g n-r
                                                    (width m)) acc))
              (rec (drop-right x 1) (add1 i) (cons (weighted-add-RS-genmat-parity-rows
                                                    (cons (last x) acc) (take RS-g (add1 i)) g n-r
                                                    (width m)) acc)))))))
(define (RS-genmat g t)
  (cyclic-RS-genmat-n g (sub1 (expt 2 (degree g))) (* 2 t)))
(define (systematic-RS-matrix g t)
  (systematize-RS-matrix (RS-genmat g t) g))
(define (all-RS-noise-shifted-syndromes rs-e g t)
  (map (lambda(x) (RS-poly-syndromes x g (* 2 t))) (cyclic-shift-mat
                                                    (cons rs-e (duplicate -1 (- (expt 2 (degree g)) 2))))))
(define (all-len1-RS-noise-symbols g)
  (remove-duplicates (append* (map (lambda(x) (cyclic-shift-mat (cons x (duplicate -1 (- (expt 2
                                                                                               (degree g)) 2)))))
                                   (build-list (sub1 (expt 2 (degree g))) values)))))
(define (all-len1-RS-noise-shifted-syndromes g t)
  (map (lambda(x) (RS-poly-syndromes x g (* 2 t))) (all-len1-RS-noise-symbols g)))
(define (all-len1-RS-noise-shifted-syndromes2 g t)(let* ([syn-l (map (lambda(x) (cons (RS-poly-syndromes x g (* 2 t)) (list x)))
                                                                     (all-len1-RS-noise-symbols g))]
                                                         [i-b (info-bits (degree g))])
                                                    (filter cons? (map (lambda(x) (filter (lambda(y) (equal? x (caar y))) syn-l)) i-b))))
;(define lst1 (map (lambda(x) (filter )) (all-len1-RS-noise-shifted-syndromes2 g1 2) (lambda(x y)
; (> (degree (caar x)) (degree (caar y))))))
(define (num-RS-err-patterns g num-e)
  (let ([n (sub1 (expt 2 (degree g)))])
    (* (num-error-patterns n num-e) (expt n num-e))))
(define (all-len1-RS-noise-added-shifted-syndromes RS-v g t)
  (map (lambda(x) (RS-poly-syndromes (add-RS-polys RS-v x g) g (* 2 t))) (all-len1-RS-noise-symbols
                                                                          g)))
;(define num-dup-RS-len1-synd
; (map (lambda(y) (- (length RS_63_57_all_1_err_syndromes) (length (remove-duplicates
;(map (lambda(x) (take x y))     RS_63_57_all_1_err_syndromes)))))
;(build-list 3 add1)))

(define (binary-poly-gcd p1 p2)
  (let rec ([x p1][y p2][q-acc '()])
    (let*-values ([(q r) (binary-poly-long-div x y)]
                  [(acc-r-d) (if (cons? r) (degree r) -1)][(y-d) (if (cons? y) (degree y) -1)])
      (cond [(= acc-r-d -1) y]
            ;[(>= acc-r-d y-d) 1]
            [(rec y r (cons (list q r) q-acc))]))))
(define (binary-poly-gcd2 p1 p2)
  (list (factorize-poly p1) (factorize-poly p2)))
(define (random-binary-poly n) (decimal-2-binary-list (car (random-n 1 n))))
(define (add-RS_63_57-polys p1 p2)
  (let ([gr-l all_63_57_poly_sum_pairs])
    (map (lambda(x y) (list-ref (list-ref gr-l (add1 x)) (add1 y))) p1 p2)))
(define (RS-poly-div-itr p1 p2 gr-l g)
  (let* ([r-l gr-l][f-qd (list-ref (list-ref (car r-l) (add1 (car p1))) (add1 (car p2)))]
                   ;[f-qdv0 (map (lambda(x) (mult-GF2-pows x f-qd g)) p2)]
                   [f-qdv (map (lambda(x) (list-ref (list-ref (second r-l) (add1 x)) (add1 f-qd))) p2)]
                   [add-RS_63_57-polys-inl (lambda(p1 p2)
                                             (let ([gr-l all_63_57_poly_sum_pairs])
                                               (map (lambda(x y) (list-ref
                                                                  (list-ref gr-l (add1 x)) (add1 y))) p1 p2)))]
                   [f-dv (add-RS_63_57-polys-inl p1 (append f-qdv (duplicate -1 (- (length p1) (length
                                                                                                p2)))))])(list f-qd f-qdv f-dv)))
(define (RS_63_57-poly-div-itr p1 p2 g) (RS-poly-div-itr p1 p2 RS_63_57_local g))
(define RS_63_57_local
  (map (lambda(y) (map (lambda(x) (flatten x)) y))
       (list all_63_57_div_pows_pairs_sums all_63_57_qut_prods_pairs all_63_57_poly_sum_pairs)))
(define (RS_63_57-poly-div p1 p2 g num-r)
  (let*-values ([(r-l) RS_63_57_local][(p-21 p2) (split-leading-RS-zeros p2)][(p2l) (length p2)]
                                      [(pq1 pq2) (split-at p1 p2l)][(n) (sub1 (expt 2 (degree g)))])
    (let rec ([pn p1][acc '()][i 1])
      (let*-values ([(p-11 p1) (split-leading-RS-zeros pn)]
                    [(RS_63_57-poly-div-itr-inline)
                     (lambda (p1)
                       (let* ([f-qd (list-ref (list-ref (car r-l) (add1 (car p1))) (add1 (car p2)))]
                              [f-qdv (map (lambda(x) (list-ref (list-ref (second r-l) (add1 x)) (add1 f-qd))) p2)]
                              [add-RS_63_57-polys-inl
                               (lambda(p1 p2) (let ([gr-l all_63_57_poly_sum_pairs])
                                                (map (lambda(x y) (list-ref (list-ref gr-l (add1 x)) (add1 y))) p1 p2)))]
                              [f-dv (add-RS_63_57-polys-inl p1 (append f-qdv (duplicate -1 (- (length p1) (length
                                                                                                           p2)))))])
                         (list f-qd f-qdv f-dv)))]
                    [(res) (RS_63_57-poly-div-itr-inline p1)]
                    ;[(res) (mult-GF2-pows (car p1) (car p2) g)]
                    [(res-z res-nz)(split-leading-RS-zeros (last res))])
        (if (or (null? pn) (< (RS-poly-degree res-nz) (RS-poly-degree p2)) (= -1 (- (RS-poly-degree res-nz))))
            (list (reverse (flatten (cons (car res) acc))) res-nz)
            (rec res-nz (flatten (cons (if (cons? res-z) (cdr res-z) '()) (cons (car res) acc))) (add1 i)))))))
(define (encode-RS-poly2 p g num-r)
  (let* ([sub-p (map (lambda(x) (map (lambda(y) (mult-GF2-pows x y g)) (RS-poly num-r g))) p)])
    (let rec ([x (cdr (reverse sub-p))][i 1][acc (last sub-p)])
      (if (null? x) acc
          (rec (cdr x) (add1 i) (add-RS-polys (append (car x) (duplicate -1 i)) acc g))))))
(define (mult-RS-polys p-1 p-2 g num-r)
  (if (or (null? (remove-leading-RS-zeros p-1)) (null? (remove-leading-RS-zeros p-2))) '()
      (let* ([n (sub1 (expt 2 (degree g)))][r-l (cdr (GF2-root-factorize g))]
                                           [power-of-prim-ele (lambda(pw) (if (= -1 pw) (zeros (degree g))
                                                                              (list-ref r-l (modulo pw n))))]
                                           [power-eqv-of-prim-ele
                                            (lambda(e) (if (all-zeros? e) -1 (get-first-matching-pos e r-l)))]
                                           [mult-GF2-pows-inl (lambda(x y) (if (or (= x -1) (= y -1)) -1
                                                                               (power-eqv-of-prim-ele
                                                                                (power-of-prim-ele (+ x y)))))]
                                           [mult-GF2-pows-row (lambda(z) (map (lambda(x y) (mult-GF2-pows-inl x
                                                                                                              y))(duplicate z (length p-1)) p-1))])
        (let rec ([x (reverse (drop-right p-2 1))][i 1][acc (list (mult-GF2-pows-row (last p-2)))])
          (if (null? x) (flatten (list (remove-leading-RS-zeros (add-RS-polys-rect2 acc g r-l num-r))))
              (rec (cdr x) (add1 i) (cons (append (mult-GF2-pows-row (car x)) (duplicate -1 i)) acc)))))))
(define (mult-RS-polys2 p1 p2 g num-r)
  (let* ([n (sub1 (expt 2 (degree g)))][sub-p (map (lambda(x) (map (lambda(y) (mult-GF2-pows x y g))
                                                                   p1)) p2)])
    (let rec ([x (reverse (drop-right sub-p 1))][i 1][acc (list (last sub-p))])
      (if (null? x) (remove-leading-RS-zeros (add-RS-polys-rect acc g num-r))
          (rec (cdr x) (add1 i) (cons (append (car x) (duplicate -1 i)) acc))))))
(define (RS_63_57-gcd p1 p2 g num-r)
  (let rec ([x p1][y p2][q-acc '()])
    (let* ([acc (RS_63_57-poly-div x y g num-r)][acc-r-d (RS-poly-degree (last acc))][y-d (RS-poly-degree y)])
      (cond [(= acc-r-d -1) (list acc-r-d y-d x y q-acc (RS-poly-syndromes y g num-r))]
            ;[(>= acc-r-d y-d) 1]
            [(rec y (last acc) (cons (list acc (RS-poly-syndromes (car acc) g num-r)
                                           (RS-poly-syndromes (last acc) g num-r)) q-acc))]))))
(define (mult-RS_63_57-poly p1 p2)
  (let* ([r-l (second RS_63_57_local)][f-prd0 (map (lambda(x) (list-ref r-l (add1 x))) p2)])
    (let rec ([x (reverse (drop-right f-prd0 1))][i 1]
                                                 [acc (list (map (lambda(y) (list-ref (last f-prd0) (add1 y))) p1))])
      (if (null? x) (remove-leading-RS-zeros (add-RS-polys-rect2 acc gp r-l num-rt))
          (rec (cdr x) (add1 i) (cons (append (map (lambda(y) (list-ref (car x) (add1 y))) p1) (duplicate -1
                                                                                                          i))
                                      acc))))))
(define (extract-leading-RS-zeros lst)
  (let rec ([x lst][acc '()])
    (if (cons? x)
        (if (= -1 (car x))
            (rec (cdr x) (cons (car x) acc)) acc) acc)))
(define (divide-GF2-pows x y g) (if (or (= -1 x) (= -1 y)) -1
                                    (if (= 1 y) (mult-GF2-pows x (modulo -1 (sub1 (expt 2 (degree g)))) g)
                                        (mult-GF2-pows x (- 0 y) g))))
(define (divide-RS-polys p-n p-d g num-r)
  (let* ([pn (remove-leading-RS-zeros p-n)][pd (remove-leading-RS-zeros p-d)]
                                           [nd (RS-poly-degree pn)][dd (RS-poly-degree pd)]
                                           [qd (- nd dd)][n (sub1 (expt 2 (degree g)))]
                                           [q (duplicate -1 nd)][r-l (cdr (GF2-root-factorize g))]
                                           [power-of-prim-ele (lambda(pw) (if (= -1 pw) (zeros (degree g))
                                                                              (list-ref r-l (modulo pw n))))]
                                           [power-eqv-of-prim-ele
                                            (lambda(e) (if (all-zeros? e) -1 (get-first-matching-pos e r-l)))][mult-GF2-pows-inl (lambda(x y) (if (or (= x -1) (= y -1)) -1
                                                                                                                                                  (power-eqv-of-prim-ele
                                                                                                                                                   (power-of-prim-ele (modulo (+ x y) n)))))]
                                                                                                              [mult-GF2-qut-row (lambda(x z) (if (= -1 z) (duplicate z (add1 nd))
                                                                                                                                                 (map (lambda(x y) (mult-GF2-pows-inl x y))
                                                                                                                                                      (duplicate z (add1 nd)) x)))]
                                                                                                              [divide-GF2-pows (lambda(x y) (if (or (= -1 x) (= -1 y)) -1 (if (= 1 y)
                                                                                                                                                                              (mult-GF2-pows-inl x (modulo -1
                                                                                                                                                                                                           (sub1 (expt 2 (degree g))))) (mult-GF2-pows-inl x (- 0 y)))))]
                                                                                                              [pded-pd (append pd (duplicate -1 qd))]
                                                                                                              [cyclic-pd (take (reverse (cyclic-shift-mat pded-pd)) qd)]
                                                                                                              [f-qt (divide-GF2-pows (car pn) (car pd))]
                                                                                                              [f-qt-rp (mult-GF2-qut-row pded-pd f-qt)]
                                                                                                              [z (add-RS-polys-rect (list f-qt-rp pn) g num-r)])
    (if (> (RS-poly-degree pn) (RS-poly-degree pd))
        (let rec ([x z][y cyclic-pd][q-acc (list f-qt)][i 1])
          (if (null? y) (list (reverse q-acc) (take-right x dd))
              (if (= -1 (list-ref x i)) (rec x (cdr y) (cons -1 q-acc) (add1 i))
                  (rec (add-RS-polys-rect (list (mult-GF2-qut-row (car y) (divide-GF2-pows (list-ref x i) (car
                                                                                                           pd))) x) g num-r)
                    (cdr y) (cons (divide-GF2-pows (list-ref x i) (car pd)) q-acc) (add1 i)))))
        (if (null? (cdr pd)) (list z '(-1)) (list (list f-qt) z)))))
(define (RS-syndromes-equation p g num-r)
  (reverse (map (lambda(x) (power-eqv-of-prim-ele x g)) (RS-poly-syndromes p g num-r))))
(define (random-n-symb-RS-error-pattern g ne)
  (let* ([bit-p-l (gen-random-nbit-patterns (sub1 (expt 2 (degree g))) ne 100)][bit-p (car (shuffle bit-p-l))]
                                                                               [sym-l (random-n ne (sub1 (expt 2 (degree g))))])
    (let rec ([x bit-p][y sym-l][acc '()])
      (if (or (null? x) (null? y)) acc
          (if (= (car x) 0) (rec (cdr x) y (cons -1 acc)) (rec (cdr x) (cdr y) (cons (car y) acc)))))))
(define (add-random-n-symb-RS-error v g ne)
  (add-RS-polys v (random-n-symb-RS-error-pattern g ne) g))
(define (replace-element lst pos ele)
  (append (take lst pos) (append (list ele) (drop lst (add1 pos)))))
(define (n-symb-RS-error-pattern g ne)
  (let* ([bit-p-l (gen-random-nbit-patterns (sub1 (expt 2 (degree g))) ne 100)]
         [bit-p (list-ref bit-p-l (random (sub1 (length bit-p-l))))]
         [sym-l (random-n ne (sub1 (expt 2 (degree g))))])
    (let rec ([x bit-p][y sym-l][acc '()])
      (if (or (null? x) (null? y)) acc
          (if (= (car x) 0) (rec (cdr x) y (cons -1 acc)) (rec (cdr x) (cdr y) (cons (car y) acc)))))))
(define (add-n-symb-RS-error v g ne)(add-RS-polys v (n-symb-RS-error-pattern g ne) g))
(define (check-binary-poly-sum sv cv)
  (let rec ([x sv][y (transpose cv)])
    (if (or (null? x) (null? y)) #t
        (if (= (car x) (parity (car y))) (rec (cdr x) (cdr y)) #f))))
(define (info-bits-sums il) (append* (map (lambda(x) (map (lambda(y) (cons (list x y)
                                                                           (list (add-binary-polys (list x y)))))
                                                          (info-bits il))) (info-bits il))))
(define (RS-zeros n) (duplicate -1 n))
(define (RS-poly-2-pow-pos-list v)
  (list (reverse (get-all-matching-pos-pred (negate negative?) (reverse v)))
        (reverse (filter (negate negative?) (reverse v)))))
(define (pow-pos-list-2-RS-poly v g)
  (let* ([n (sub1 (expt 2 (degree g)))][p-p (list (car v) (last v))])
    (let rec ([x (car p-p)][y (last p-p)][acc (RS-zeros n)])
      (if (or (null? x) (null? y)) (remove-leading-RS-zeros (reverse acc))
          (rec (cdr x) (cdr y) (replace-element acc (car x) (car y)))))))
;(define (RS_63_57_len2-syndromes-sum-chk len1-syn RS-v g t)
; (let* ([isum (info-bits-sums (degree g))]
; (let rec ([x RS_63_57_all_1_err_syndromes_sorted]))
; (if (check-binary-poly-sum (car x) cv) (car y)
;(rec (cdr x) (cdr y))
; (if (= t 2)
; (map (lambda(x) (RS-poly-syndromes (add-RS-polys RS-v x g) g (* 2 t))) (all-len1-RS-noise-symbols g)))
(define (RS-gcd p1 p2 g num-r)
  (let rec ([x (remove-leading-RS-zeros p1)][y (remove-leading-RS-zeros p2)][q-acc '()]
                                            [acc-qd (RS-poly-degree (car (divide-RS-polys (remove-leading-RS-zeros
                                                                                           p1) (remove-leading-RS-zeros p2) g num-r)))]
                                            [acc-rd (RS-poly-degree (last (divide-RS-polys (remove-leading-RS-zeros
                                                                                            p1) (remove-leading-RS-zeros p2) g num-r)))])
    (if (or (null? x) (null? y) (or (= acc-qd -1) (= acc-rd -1)) (> (length q-acc) 1))
        (let* ([lq (car (divide-RS-polys p1 x g num-r))] ;(map (lambda(x) )
               [lq-rss (RS-poly-syndromes lq g (sub1 (expt 2 (degree g))))]
               [lq-inv-e-p (map (lambda(x) (add1 x)) (get-all-matching-pos (zeros (degree g)) lq-rss))]
               [lq-e-p (map (lambda(x) (divide-GF2-pows 0 x g)) lq-inv-e-p)]) (list lq y lq-rss lq-inv-e-p lq-e-p))
        (let* ([acc (divide-RS-polys x y g num-r)][acc-q-d (RS-poly-degree (car acc))]
                                                  [acc-r-d (RS-poly-degree (last acc))][y-d (RS-poly-degree y)]
                                                  [prd-chk (add-RS-polys(mult-RS-polys (flatten (list y)) (flatten (list (car acc))) g num-r)
                                                                        (last acc) g)])
          (rec (remove-leading-RS-zeros y) (remove-leading-RS-zeros (last acc))
            (cons (list x y (RS-poly-degree x) acc prd-chk (RS-poly-degree prd-chk))
                  q-acc) acc-q-d acc-r-d)))))
(define (RS-decode-eucl v g t)
  (let* ([num-r (* (add1 t) 2)][z-2 (cons 0 (RS-zeros num-r))][z-1 (RS-syndromes-equation v g num-r)]
                               [s (divide-RS-polys z-2 z-1 g num-r)]
                               [s-1 (car s)][s-2 '(0)]);[gcd (RS-gcd z-2 z-1 g num-r)])
    (let rec ([z-p z-1][z (last s)][q s-1][si1 s-1][si2 s-2][q-acc '()])
      (if (or (< (degree z-p) (degree z)) (< (degree z) (degree si1))
              ;(equal? (remove-leading-RS-zeros z-p) (remove-leading-RS-zeros z))
              (null? (remove-leading-RS-zeros z)) (null? (remove-leading-RS-zeros si1)))
          ;          (let* ([lq (car (divide-RS-polys p1 x g num-r))] ;(map (lambda(x) )
          ;                 [lq-rss (RS-poly-syndromes lq g (sub1 (expt 2 (degree g))))]
          ;                 [lq-inv-e-p (map (lambda(x) (add1 x)) (get-all-matching-pos (zeros (degree g)) lq-rss))]
          ;                 [lq-e-p (map (lambda(x) (divide-GF2-pows 0 x g)) lq-inv-e-p)]) (list (list lq y lq-rss lq-                                                                                            inv-e-p lq-e-p))
          (list si2 (RS-error-locs si2 g num-r) ;(add-RS-polys si2 (mult-RS-polys si1 (car (divide-RS-polys                  z-p z g num-r)) g num-r) g)
                q z z-p si1 q-acc (divide-RS-polys (mult-RS-polys si2 z-1 g num-r)
                                                   (cons 0 (RS-zeros (- num-r 2))) g num-r)
                (divide-RS-polys (mult-RS-polys si2 z-1 g num-r) z-2 g num-r))
          (let* ([d-r (divide-RS-polys z-p z g num-r)]
                 [qi (add-RS-polys si2 (mult-RS-polys si1 (car d-r) g num-r) g)])
            ;)
            (rec z (last d-r) (car d-r) qi si1 (cons (list z (last d-r) (car d-r) qi si1) q-acc)))))))
(define (RS-error-locs s-p g num-r)
  (let* ([lq-rss (RS-poly-syndromes s-p g (sub1 (expt 2 (degree g))))]
         [lq-inv-e-p (map (lambda(x) (add1 x)) (get-all-matching-pos (zeros (degree g)) lq-rss))]
         [lq-e-p (map (lambda(x) (divide-GF2-pows 0 x g)) lq-inv-e-p)])
    (list (list lq-rss lq-inv-e-p lq-e-p))))
(define (erase-n-random-RS-symbs v g ne)
  (let* ([e-p (n-symb-RS-error-pattern g ne)])
    (let rec ([x v][y e-p][acc '()])
      (if (or (null? x) (null? y))
          (reverse acc)
          (if (= -1 (car y))
              (rec (cdr x) (cdr y) (cons (car x) acc))
              (rec (cdr x) (cdr y) (cons '* acc)))))))
(define (erase-n-random-bits v ne)
  (let* ([e-p (car (gen-random-nbit-patterns (length v) ne 10))])
    (let rec ([x v][y e-p][acc '()])
      (if (or (null? x) (null? y))
          (reverse acc)(if (= 0 (car y))
                           (rec (cdr x) (cdr y) (cons (car x) acc))
                           (rec (cdr x) (cdr y) (cons '* acc)))))))
(define (prd-chk p1 p2 g num-r div-fn)
  (let* ([acc (div-fn p1 p2 g num-r)]
         [prd (add-RS-polys (mult-RS-polys (flatten (list p2)) (flatten (list (car acc))) g num-r) (last acc)
                            g)])
    (equal? p1 prd)))
(define (RS-eucl-dec-test-rand-poly g t)
  (let* ([p (random-n-symb-RS-error-pattern g t)][p1 (random-n-symb-RS-error-pattern g t)][pos-l1 (car
                                                                                                   (RS-poly-2-pow-pos-list p1))]
                                                 [n (sub1 (expt 2 (degree g)))][num-r (* 2 t)]
                                                 [pos-l (car (RS-poly-2-pow-pos-list p))][res0 (RS-decode-eucl p g (add1
                                                                                                                    t))]
                                                 [res (last (last (second res0)))][res00 (RS-decode-eucl p1 g t)]
                                                 [res1 (last (last (second res00)))])
    (list num-r p res0 res (equal? res pos-l) (length p) (length p1) p1 res1 (equal? res pos-l1))))
(define (RS-eucl-dec-test-rand-corrtd-poly g t)
  (let* ([rs-p (encode-random-RS-poly g (* (add1 t) 2))][er-p (random-n-symb-RS-error-pattern g t)][p
                                                                                                    (add-RS-polys er-p rs-p g)]
                                                        [p1 (random-n-symb-RS-error-pattern g t)][pos-l1
                                                                                                  (car (RS-poly-2-pow-pos-list p1))]
                                                        [n (sub1 (expt 2 (degree g)))][num-r (* 2 t)]
                                                        [pos-l (car (RS-poly-2-pow-pos-list p))][res0 (RS-decode-eucl p g
                                                                                                                      t)]
                                                        [res (last (last (second res0)))][res00 (RS-decode-eucl p1 g t)]
                                                        [res1 (last (last (second res00)))])
    (list res0 rs-p (car (RS-poly-2-pow-pos-list rs-p)) er-p p (RS-poly-syndromes rs-p g num-r) (RS-poly-syndromes p g num-r)
          (RS-poly-syndromes er-p g num-r) res pos-l)))
(define (RS-eucl-dec-test-rand-poly-all-permuts g t)
  (let* ([p (random-n-symb-RS-error-pattern g t)][n (sub1 (expt 2 (degree g)))][num-r (* 2 t)]
                                                 [res (map (lambda(x) (list (cons x (cdr p)) (RS-syndromes-equation
                                                                                              (cons x (cdr p)) g num-r)
                                                                            (RS-decode-eucl (cons x (cdr p)) g num-r) g num-r))
                                                           (build-list n values))])
    res))
(define (RS-eucl-dec-test-sums-of-rand-poly-all-permuts g t rs-p)
  (let* ([n (sub1 (expt 2 (degree g)))][num-r (* 2 t)][p (add-RS-polys rs-p (random-n-symb-RS-error-pattern g t) g)]
                                       [res (map (lambda(x) (list (cons x (cdr p)) (RS-syndromes-equation
                                                                                    (cons x (cdr p)) g num-r)
                                                                  (RS-decode-eucl (cons x (cdr p)) g num-r) g num-r))
                                                 (build-list n values))])res))
(define (RS-eucl-dec-test g t p)
  (let* ([n (sub1 (expt 2 (degree g)))][num-r (* 2 t)]
                                       [res (map (lambda(x) (list (RS-poly-syndromes (cons x (cdr p)) g num-r)
                                                                  (cons x (cdr p)) (RS-syndromes-equation
                                                                                    (cons x (cdr p)) g num-r)
                                                                  (RS-decode-eucl (cons x (cdr p)) g num-r) g num-r))
                                                 (build-list n values))])
    res))
(define (RS-1-err-brute-force-test v g t pos)
  (let* ([n (sub1 (expt 2 (degree g)))][num-r (* 2 t)]
                                       [res (append* (map (lambda(x x1) (reverse (replace-element v x x1)))
                                                          (duplicate pos n) (build-list n (lambda(x) (lambda(x) (sub1 n))))))])
    (list res (map (lambda(x) (RS-poly-syndromes x g num-r)) res))))
(define (RS-2-err-brute-force-test v g t pos1 pos2)
  (let* ([n (sub1 (expt 2 (degree g)))][num-r (* 2 t)]
                                       [res (append* (map (lambda(x x1) (map (lambda(y y1) (reverse
                                                                                            (replace-element
                                                                                             (replace-element v x x1) y y1)))
                                                                             (duplicate pos1 n) (build-list n values)))
                                                          (duplicate pos2 n) (build-list n (lambda(x) (sub1 n)))))])
    (list res (map (lambda(x) (RS-poly-syndromes x g num-r)) res))))
(define (random-2-symb-RS-error-pattern g) (random-n-symb-RS-error-pattern g 2))
(define (random-3-symb-RS-error-pattern g) (random-n-symb-RS-error-pattern g 3))
(define (encode-random-RS-poly g num-r)
  (let* ([n (sub1 (expt 2 (degree g)))][k (- n num-r)]
                                       [cw (encode-RS-poly (take (random-n-symb-RS-error-pattern g num-r) k) g
                                                           num-r)]
                                       [res (list cw (length cw) (= n (length cw)) (RS-poly-syndromes cw g num-r))])
    cw))
(define (power-eqv-of-prim-ele-list e-l g)
  (let* ([pow-l (GF2-root-factorize g)])
    (map (lambda(x) (sub1 (get-first-matching-pos x pow-l))) e-l)))
(define (power-eqv-of-RS-poly-pos p g)
  (power-eqv-of-prim-ele-list (make-rect-k (map (lambda(x) (decimal-2-binary-list x))
                                                (car (RS-poly-2-pow-pos-list p))) (degree g)) g))
(define (power-eqv-of-rand-RS-poly-pos g)
  (let* ([n (sub1 (expt 2 (degree g)))][p (random-n-symb-RS-error-pattern g (floor (/ n 3)))]
                                       [rs-p-l (RS-poly-2-pow-pos-list p)][p-l (power-eqv-of-RS-poly-pos p g)])
    (list p rs-p-l p-l)))(define (RS-poly-derivative p g)
                           (cond [(= 1 (length p)) '(-1)] [(= 2 (length p)) (drop-right p 1)] [(= 3 (length p)) (list (second p))]
                                 [(let rec ([x (cddr (reverse p))][acc (list (cadr (reverse p)))])
                                    (if (< (length x) 2) acc (rec (cddr x) (cons (cadr x) acc))))]))
(define (eval-RS-poly-derivative p g d)
  (power-eqv-of-prim-ele (eval-RS-poly g (RS-poly-derivative p g) d) g))
(define (eval-RS-poly-derivative-list p g d-l)
  (map (lambda(x) (eval-RS-poly-derivative p g x)) d-l))
(define (eval-RS-poly-root-list p g r-l)
  (map (lambda(x) (eval-RS-poly g p x)) r-l))
(define (eval-RS-poly-root-list-2 p g r-l)
  (map (lambda(x) (eval-RS-poly g (car (divide-RS-polys
                                        (car (divide-RS-polys p (list (last p)) g num-rt)) (list x 0) g num-rt)) x)) r-l))
(define (eval-RS-poly-fraction-root np dp g r)
  (divide-GF2-pows (power-eqv-of-prim-ele (eval-RS-poly g np r) g)
                   (power-eqv-of-prim-ele (eval-RS-poly g dp r) g) g))
(define (eval-RS-poly-fraction-root-list np dp g r-l)
  (map (lambda(x y) (divide-GF2-pows (power-eqv-of-prim-ele x g) (power-eqv-of-prim-ele y g) g))
       (eval-RS-poly-root-list np g r-l) (eval-RS-poly-root-list dp g r-l)))
(define (eval-RS-poly-deriv-fraction-root-list np dp g r-l)
  (eval-RS-poly-fraction-root-list np (RS-poly-derivative dp g) g r-l))
(define (eval-RS-poly-fraction2-root-list np dp g r-l)
  (map (lambda(x y) (divide-GF2-pows (power-eqv-of-prim-ele x g) (power-eqv-of-prim-ele y g) g))
       (eval-RS-poly-root-list np g r-l) (eval-RS-poly-root-list-2 dp g r-l)))
(define (eval-RS-poly-deriv-fractions-root-list np-l dp g r-l)
  (map (lambda(x) (eval-RS-poly-fraction-root-list x (RS-poly-derivative dp g) g r-l)) np-l))
(define (eval-RS-poly-fractions2-root-list np-l dp g r-l)
  (map (lambda(x) (eval-RS-poly-fraction2-root-list (add-RS-polys dp (append x '(-1)) g) dp g r-l)) np-l))
(define (eucl-dec-end-2-end-test g t)
  (let* ([res (RS-eucl-dec-test-rand-corrtd-poly g t)]
         [res1 (eval-RS-poly-deriv-fractions-root-list (take (cddar res) 4) (caar res) g (second (caadar
                                                                                                  res)))]
         [res2 (eval-RS-poly-deriv-fractions-root-list (take (cddar res) 4) (caar res) g (third (caadar res)))]
         [res3 (eval-RS-poly-fractions2-root-list (take (cddar res) 4) (caar res) g (second (caadar res)))]
         [res4 (eval-RS-poly-fractions2-root-list (take (cddar res) 4) (caar res) g (third (caadar res)))])
    (list res res1 res2 res3 res4)));tests
(define-values (gp num-rt) (values '(1 0 0 0 0 1 1) 6))
(define rgp (reverse gp))
(define rRS-p (RS-poly num-rt rgp))
(define RS-p (RS-poly num-rt gp))
(define g1 '(1 0 0 1 1))
(define g2 '(1 0 1 0 0 1))
(define g3 (get-prim-poly 7 prim-polys-list))
(provide/contract
 [append-with-duplicates ((listof any/c) positive? . -> . any/c)]
 [shift-left ((listof any/c) . -> . any/c)]
 [convol-sum ((listof any/c) (listof any/c) . -> . any/c)]
 [merge-distinct-ele ((listof any/c) (listof any/c) . -> . any/c)]
 [merge-distinct-ele-lists ((listof any/c) . -> . any/c)]
 [prim-poly-candidates ((and/c positive? (>/c 3)) . -> . any/c)]
 [split-genmat-cols (rectangular-matrix/c . -> . any/c)]
 [systematic-gm-n-3 (positive? binary-list/c . -> . any/c)]
 [systematize-cyclic-matrix3 (rectangular-matrix/c . -> . rectangular-matrix/c)]
 [isprim?-3 ((listof any/c) . -> . any/c)]
 [all-2-comb ((listof any/c) . -> . any/c)]
 [all-comb ((listof any/c) positive? . -> . any/c)]
 [target-bins (positive? (listof any/c) positive? . -> . any/c)]
 [random-n (positive? positive? . -> . any/c)]
 [in-range? (positive? number? number? . -> . any/c)]
 [empty-bins ((listof any/c) (listof any/c) (listof any/c) . -> . any/c)]
 [m-l (rectangular-matrix/c . -> . any/c)][check-linear-indp (rectangular-matrix/c . -> . any/c)]
 [BCH-gm ((and/c positive? (>/c 3)) (and/c positive? (>=/c 2)) . -> . any/c)]
 [get-prime-factors (positive? . -> . any/c)]
 [all-interger-permuts (positive? . -> . any/c)]
 [prime-powers-to-number ((listof any/c) . -> . any/c)]
 [all-powers-of-primes (positive? . -> . any/c)]
 [mult-prime-powers ((listof any/c) (listof any/c) . -> . any/c)]
 [div-prime-powers ((listof any/c) (listof any/c) . -> . any/c)]
 [lcm2 ((listof any/c) (listof any/c) . -> . any/c)]
 [lcm-polys ((listof any/c) . -> . any/c)]
 [systematic-BCH-gm ((and/c positive? (>/c 3)) (and/c positive? (>=/c 2)) . -> . any/c)]
 [count-all-ele ((listof any/c) . -> . any/c)]
 [BCH-parity-mat ((and/c positive? (>/c 3)) (and/c positive? (>=/c 2)) . -> . any/c)]
 [BCH-gm-parity-check ((and/c positive? (>/c 3)) (and/c positive? (>=/c 2)) . -> . any/c)]
 [BCH-syst-gm-parity-check ((and/c positive? (>/c 3)) (and/c positive? (>=/c 2)) . -> . any/c)]
 [eval-RS-poly (binary-list/c positive? positive? . -> . any/c)]
 [run-rows-sum-weight (rectangular-matrix/c . -> . any/c)]
 [add-dependent-row (rectangular-matrix/c (listof any/c) . -> . any/c)]
 [remove-all-even-duplicates (rectangular-matrix/c . -> . any/c)]
 [remove-duplicated-elements (rectangular-matrix/c . -> . any/c)]
 [BCH-cw-remainders ((listof any/c) (and/c positive? (>/c 3)) (and/c positive? (>=/c 2)) . -> . any/c)]
 [powers-of-roots-d ((and/c positive? (>/c 3)) . -> . any/c)]
 [pow-binary-poly (binary-list/c positive? . -> . any/c)]
 [mult-GF2-pows (number? number? binary-list/c . -> . any/c)]
 [add-GF2-pows ((listof any/c) binary-list/c . -> . any/c)][power-eqv-of-prim-ele ((listof any/c) binary-list/c . -> . any/c)]
 [get-all-matching-pos-pred (procedure? (listof any/c) . -> . any/c)]
 [duplicate-append ((listof any/c) positive? . -> . any/c)]
 [first-common-ele ((listof any/c) (listof any/c) . -> . any/c)]
 [add-GF2-pows-2D ((listof any/c) binary-list/c . -> . any/c)]
 [RS-poly ((and/c positive? (>=/c 4)) binary-list/c . -> . any/c)]
 [RS-poly-deg (binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [sampled-unit-sin (positive? positive? . -> . (listof any/c))]
 [sampled-unit-cos (positive? positive? . -> . (listof any/c))]
 [sampled-func-fq (positive? positive? positive? positive? positive? . -> . (listof any/c))]
 [sampled-unit-sin-fq (positive? positive? positive? . -> . (listof any/c))]
 [sampled-unit-cos-fq (positive? positive? positive? . -> . (listof any/c))]
 [dft ((listof any/c) . -> . any/c)]
 [dft-kernel (positive? . -> . any/c)]
 [phase-shifted-sin (positive? positive? positive? . -> . any/c)]
 [add-GF2-pows-3D ((listof any/c) binary-list/c . -> . any/c)]
 [encode-RS-poly ((listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [cyclic-RS-genmat ((and/c positive? (>/c 3)) (and/c positive? (>=/c 2)) . -> . any/c)]
 [cyclic-RS-genmat-n (binary-list/c positive? (and/c positive? (>=/c 4)) . -> . any/c)]
 [cyclic-RS-genmat-k (binary-list/c positive? (and/c positive? (>=/c 4)) . -> . any/c)]
 [remove-rows ((listof any/c) (listof any/c) . -> . any/c)]
 [all-RS-zero-pows? ((listof any/c) . -> . any/c)]
 [cyclic-RS-genmat-n-bin (binary-list/c positive? (and/c positive? (>=/c 4)) . -> . any/c)]
 [cyclic-RS-genmat-k-bin (binary-list/c positive? (and/c positive? (>=/c 4)) . -> . any/c)][gen-RS-prim-dvnd ((and/c positive? (>/c 3)) . -> . (listof number?))]
 [RS-prim-poly-test-deg ((and/c positive? (>/c 3)) (and/c positive? (>=/c 4)) . -> . any/c)]
 [sampled-fixpt-sin (positive? positive? . -> . any/c)]
 [sampled-fixpt-cos (positive? positive? . -> . any/c)]
 [sampled-fixpt-sin-fq (positive? positive? positive? . -> . any/c)]
 [sampled-fixpt-cos-fq (positive? positive? positive? . -> . any/c)]
 [fixpt-cos-freqs (positive? . -> . any/c)]
 [fixpt-sin-freqs (positive? . -> . any/c)]
 [plot-sinc (positive? . -> . any/c)]
 [plot-sinc2 (positive? . -> . any/c)]
 [add-cols (rectangular-matrix/c rectangular-matrix/c positive? . -> . rectangular-matrix/c)]
 [num-non-cyc-cw (rectangular-matrix/c . -> . number?)]
 [num-non-cyc-cw-gm (rectangular-matrix/c . -> . number?)]
 [group-cols (rectangular-matrix/c positive? . -> . any/c)]
 [get-parity-cols (rectangular-matrix/c . -> . any/c)]
 [encode-parity-bits (rectangular-matrix/c . -> . any/c)]
 [encode-systematic-RM-code (positive? rectangular-matrix/c . -> . any/c)]
 [is-cyclic?-2 (rectangular-matrix/c . -> . any/c)]
 [info-bits-op (positive? . -> . any/c)]
 [info-bits-op2 (positive? . -> . any/c)]
 [check-cyclicity-gm2 (rectangular-matrix/c . -> . boolean?)]
 [check-cyclicity2 (rectangular-matrix/c . -> . boolean?)]
 [sampled-non-prdc-func (positive? positive? . -> . any/c)]
 [plot-func (positive? positive? . -> . any/c)]
 [split-leading-RS-zeros ((listof any/c) . -> . any/c)][remove-leading-RS-zeros ((listof any/c) . -> . any/c)]
 [RS-poly-degree ((listof any/c) . -> . any/c)]
 [all-GF2-div-pairs-diffs (binary-list/c . -> . any/c)]
 [add-GF2-pows-2D-opti2 ((listof any/c) binary-list/c (listof any/c) . -> . any/c)]
 [weighted-add-RS-genmat-parity-rows ((listof any/c) (listof any/c) binary-list/c (and/c positive? (>=/c
                                                                                                    4)) positive? . -> . any/c)]
 [add-RS-polys ((listof any/c) (listof any/c) binary-list/c . -> . any/c)]
 [add-RS-polys-rect ((listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [add-RS-polys-rect2 ((listof any/c) binary-list/c (listof any/c) (and/c positive? (>=/c 4)) . -> . any/c)]
 [RS-poly-syndromes ((listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [cyclic-RS-genmat-k-2 (binary-list/c positive? (and/c positive? (>=/c 4)) . -> . any/c)]
 [binary-poly-long-div-2 ((listof any/c) (listof any/c) . -> . any/c)] ; computes quotient/remainder for p1/p2
 [pow-list->binary-list ((listof any/c) binary-list/c . -> . any/c)]
 [binary-list->pow-list ((listof any/c) binary-list/c . -> . any/c)]
 [insert-random-RS-zeros ((listof any/c) positive? . -> . any/c)]
 [RS-idn-mat (positive? . -> . any/c)]
 [systematize-RS-matrix (rectangular-matrix/c binary-list/c . -> . any/c)]
 [RS-genmat (binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 [systematic-RS-matrix (binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 [all-RS-noise-shifted-syndromes ((listof any/c) binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 [all-len1-RS-noise-symbols (binary-list/c . -> . any/c)]
 [all-len1-RS-noise-shifted-syndromes (binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 [all-len1-RS-noise-shifted-syndromes2 (binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 [num-RS-err-patterns (binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)][all-len1-RS-noise-added-shifted-syndromes ((listof any/c) binary-list/c (and/c positive? (>=/c 2)) .
                                                                                                                                         -> . any/c)]
 [binary-poly-gcd (binary-list/c binary-list/c . -> . any/c)]
 [binary-poly-gcd2 (binary-list/c binary-list/c . -> . any/c)]
 [random-binary-poly (positive? . -> . any/c)]
 [add-RS_63_57-polys ((listof any/c) (listof any/c) . -> . any/c)]
 [RS-poly-div-itr ((listof any/c) (listof any/c) (listof any/c) binary-list/c . -> . any/c)]
 [RS_63_57-poly-div-itr ((listof any/c) (listof any/c) binary-list/c . -> . any/c)]
 [RS_63_57-poly-div ((listof any/c) (listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [encode-RS-poly2 ((listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [mult-RS-polys ((listof any/c) (listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [mult-RS-polys2 ((listof any/c) (listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [RS_63_57-gcd ((listof any/c) (listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [mult-RS_63_57-poly ((listof any/c) (listof any/c) . -> . any/c)]
 [extract-leading-RS-zeros ((listof number?) . -> . any/c)]
 [divide-GF2-pows (number? number? binary-list/c . -> . any/c)]
 [divide-RS-polys ((listof number?) (listof number?) binary-list/c (and/c positive? (>=/c 4)) . -> .
                                    any/c)]
 [RS-syndromes-equation ((listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [random-n-symb-RS-error-pattern (binary-list/c positive? . -> . any/c)]
 [add-random-n-symb-RS-error ((listof any/c) binary-list/c positive? . -> . any/c)]
 [replace-element ((listof any/c) natural-number/c any/c . -> . any/c)]
 [n-symb-RS-error-pattern (binary-list/c positive? . -> . any/c)]
 [add-n-symb-RS-error ((listof any/c) binary-list/c positive? . -> . any/c)]
 [check-binary-poly-sum ((listof any/c) (listof any/c) . -> . any/c)]
 [info-bits-sums (binary-lists/c . -> . any/c)][RS-zeros (positive? . -> . any/c)]
 [RS-poly-2-pow-pos-list ((listof any/c). -> . any/c)]
 [pow-pos-list-2-RS-poly ((listof any/c) binary-list/c . -> . any/c)]
 [RS-gcd ((listof any/c) (listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [RS-decode-eucl ((listof any/c) binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 [RS-error-locs ((listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [erase-n-random-RS-symbs ((listof any/c) binary-list/c positive? . -> . any/c)]
 [erase-n-random-bits ((listof any/c) positive? . -> . any/c)]
 ;[check-RS-poly-2-pos-con ((listof any/c) binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [prd-chk ((listof any/c) (listof any/c) binary-list/c (and/c positive? (>=/c 4)) procedure? . -> . any/c)]
 [RS-eucl-dec-test-rand-poly (binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 [RS-eucl-dec-test-rand-corrtd-poly (binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 [RS-eucl-dec-test-rand-poly-all-permuts (binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 [RS-eucl-dec-test-sums-of-rand-poly-all-permuts (binary-list/c (and/c positive? (>=/c 2)) (listof any/c)
                                                                . -> . any/c)]
 [RS-eucl-dec-test (binary-list/c (and/c positive? (>=/c 2)) positive? . -> . any/c)]
 [RS-1-err-brute-force-test ((listof any/c) binary-list/c (and/c positive? (>=/c 2)) natural-number/c . -> .
                                            any/c)]
 [RS-2-err-brute-force-test ((listof any/c) binary-list/c (and/c positive? (>=/c 2)) natural-number/c
                                            natural-number/c . -> . any/c)]
 [random-2-symb-RS-error-pattern (binary-list/c . -> . any/c)]
 [random-3-symb-RS-error-pattern (binary-list/c . -> . any/c)]
 [encode-random-RS-poly ( binary-list/c (and/c positive? (>=/c 4)) . -> . any/c)]
 [power-eqv-of-prim-ele-list ((listof any/c) binary-list/c . -> . any/c)]
 [power-eqv-of-RS-poly-pos ((listof any/c) binary-list/c . -> . any/c)]
 [power-eqv-of-rand-RS-poly-pos ( binary-list/c . -> . any/c)][RS-poly-derivative ((listof any/c) binary-list/c . -> . any/c)]
 [eval-RS-poly-derivative ((listof any/c) binary-list/c (and/c positive? (>/c 3)) . -> . any/c)]
 [eval-RS-poly-derivative-list ((listof any/c) binary-list/c (listof any/c) . -> . any/c)]
 [eval-RS-poly-root-list ((listof any/c) binary-list/c (listof any/c) . -> . any/c)]
 [eval-RS-poly-root-list-2 ((listof any/c) binary-list/c (listof any/c) . -> . any/c)]
 [eval-RS-poly-fraction-root ((listof any/c) (listof any/c) binary-list/c positive? . -> . any/c)]
 [eval-RS-poly-fraction-root-list ((listof any/c) (listof any/c) binary-list/c (listof any/c) . -> . any/c)]
 [eval-RS-poly-deriv-fraction-root-list ((listof any/c) (listof any/c) binary-list/c (listof any/c) . -> .
                                                        any/c)]
 [eval-RS-poly-fraction2-root-list ((listof any/c) (listof any/c) binary-list/c (listof any/c) . -> . any/c)]
 [eval-RS-poly-deriv-fractions-root-list ((listof any/c) (and/c positive? (>/c 3)) binary-list/c (listof
                                                                                                  any/c) . -> . any/c)]
 [eval-RS-poly-fractions2-root-list ((listof any/c) (and/c positive? (>/c 3)) binary-list/c (listof any/c) .
                                                    -> . any/c)]
 [eucl-dec-end-2-end-test (binary-list/c (and/c positive? (>=/c 2)) . -> . any/c)]
 )



(define (mult-GF2-pows-table g)
  (let* ([n (expt 2 (degree g))])
    (group-list (append* (map (lambda(x) (map (lambda(y) (list (list x y) (mult-GF2-pows x y g)))
                                              (build-list n sub1))) (build-list n sub1))) 8)))
(define (div-GF2-pows-table g)
  (let* ([n (expt 2 (degree g))])
    (group-list (append* (map (lambda(x) (map (lambda(y) (list (list x y) (divide-GF2-pows x y g)))
                                              (build-list n sub1))) (build-list n sub1))) 8)))
(define (RS-decode-berl v g t)
  (let* ([num-r (* (add1 t) 2)][z-2 (cons 0 (RS-zeros num-r))][z-1 (RS-syndromes-equation v g num-r)]
                               [s (divide-RS-polys z-2 z-1 g num-r)]
                               [s-1 (car s)][s-2 '(0)]);[gcd (RS-gcd z-2 z-1 g num-r)])
    (let rec ([z-p z-1][z (last s)][q s-1][si1 s-1][si2 s-2][q-acc '()])
      (if (or (< (degree z-p) (degree z)) (< (degree z) (degree si1))
              ;(equal? (remove-leading-RS-zeros z-p) (remove-leading-RS-zeros z))
              (null? (remove-leading-RS-zeros z)) (null? (remove-leading-RS-zeros si1)))
          ;          (let* ([lq (car (divide-RS-polys p1 x g num-r))] ;(map (lambda(x) )
                 ;                 [lq-rss (RS-poly-syndromes lq g (sub1 (expt 2 (degree g))))]
                 ;                 [lq-inv-e-p (map (lambda(x) (add1 x)) (get-all-matching-pos (zeros (degree g)) lq-rss))]
                 ;                 [lq-e-p (map (lambda(x) (divide-GF2-pows 0 x g)) lq-inv-e-p)]) (list (list lq y lq-rss lq-inv-e-p lq-e-p))
            (list si2 (RS-error-locs si2 g num-r) ;(add-RS-polys si2 (mult-RS-polys si1 (car (divide-RS-polys z-p z g num-r)) g num-r) g)
    q z z-p si1 q-acc (divide-RS-polys (mult-RS-polys si2 z-1 g num-r)
                                       (cons 0 (RS-zeros (- num-r 2))) g num-r)
    (divide-RS-polys (mult-RS-polys si2 z-1 g num-r) z-2 g num-r))
  (let* ([d-r (divide-RS-polys z-p z g num-r)]
         [qi (add-RS-polys si2 (mult-RS-polys si1 (car d-r) g num-r) g)])
    ;)
    (rec z (last d-r) (car d-r) qi si1 (cons (list z (last d-r) (car d-r) qi si1) q-acc)))))))
;(define-values (bp1 bp2 bp3) (values (random-binary-poly 10000) (random-binary-poly 10000)
;(random-binary-poly 4000)))
;
;(define bp4 (mult-binary-polys (list bp1 bp3)))
;(define bp5 (mult-binary-polys (list bp2 bp3)))
;
;(define bp6 (binary-poly-gcd bp4 bp5))
;(define bp7 (binary-poly-gcd2 bp4 bp5))
;;(define outp (list bp6 bp7))
;(define (test) (begin
(define-values (gptest num-rtest) (values '(1 0 0 0 0 1 1) 6))
(define rgptest (reverse gptest))
(define rRS-ptest (RS-poly num-rtest rgp))
(define RS-ptest (RS-poly num-rtest gptest))
(define g1test '(1 0 0 1 1))
(define g2test '(1 0 1 0 0 1))
(define g3test (get-prim-poly 7 prim-polys-list))
(define-values (pi1 pi2 pi3) (values (append (append (random-n 3 15) '(-1 -1 -1)) (random-n 3 15))
                                     (append (append (random-n 3 15) '(-1 -1 -1)) (random-n 3 15))
                                     (append (append (random-n 3 15) '(-1 -1 -1)) (random-n 3 15))))

; ;(define-values (pi1 pi2 pi3) (values
; ;
; '(47 48 41 34 2 50 22 11 60 53 7 57 59 48 42 31 11
;      ;
;      34 -1 -1 -1 -1 2 40 59 18 14 34 47 29 14 54 55 56)
; ;
; '(17 4 50 30 5 20 48 10 39 51 5 37 41 40 61 -1 -1 -1 59 7 52 28 24 22 58 57 19 8 23
;      40)
; ;
; '(4 33 5 44 33 34 21 18 11 42 36 61 -1 -1 27 14 35 1 62 23 10 57 39 19 40 55)))
; 


;(define-values (pi11 pi12) (values (reverse pi1) (reverse pi2)))
;
;(define-values (e1 e2) (values (random-n 14 63) (random-n 8 63)))
;
(define p1 (encode-RS-poly (take pi1 9) g1 num-rt))
(define p2 (encode-RS-poly (take pi2 9) g1 num-rt))
(define p1-g1 (encode-RS-poly (build-list 9 values) g1 num-rt))
(define p2-g1 (encode-RS-poly (reverse (build-list 9 values)) g1 num-rt))
;
;(define p1-rct (map (lambda(x) (encode-RS-poly (shuffle x) gp num-r)) (duplicate pi1 5)))
;(define p2-rct (map (lambda(x) (encode-RS-poly (shuffle x) gp num-r)) (duplicate pi2 5)))
;
;(define p1-rct-s1 (time (add-RS-polys-rect p1-rct gp num-r)))
;(define p2-rct-s1 (time (add-RS-polys-rect p2-rct gp num-r)))
;
;(define r-l (cdr (GF2-root-factorize gp)))
;
;(define p1-rct-s2 (time (add-RS-polys-rect2 p1-rct gp r-l num-r)))
;(define p2-rct-s2 (time (add-RS-polys-rect2 p2-rct gp r-l num-r)))
;
;(equal? p1-rct-s1 p1-rct-s2)
;(equal? p2-rct-s1 p2-rct-s2)
;;;(define-values (p3-1 p3-2) (values (time (mult-RS-polys p1 p2 gp num-r)) (time (mult-RS_63_57-poly p1 p2))))
;
;(equal? p3-1 p3-2)
;
;(define-values (p4-1 p4-2 p5-1 p5-2) (values (time (mult-RS-polys RS-p pi1 gp num-r))
;(time (mult-RS-polys RS-p pi2 gp num-r))
;(time (mult-RS_63_57-poly RS-p pi1))
;(time (mult-RS_63_57-poly RS-p pi2))))
;
;(equal? p4-1 p1)
;(equal? p4-2 p2)
;(equal? p5-1 p1)
;(equal? p5-2 p2)
;
;(values (map (lambda(x) (RS-poly-syndromes x gp num-r)) (list p1 p2 p3-1 p3-2 p4-1 p4-2 p5-1 p5-2)))
;(values (map (lambda(x) (RS-poly-syndromes (shuffle x) gp num-r)) (list p4-1 p4-2 p5-1 p5-2)))
;
;
;(define-values (pi4-1 pi4-2 pi5-1 pi5-2) (values
;(time (mult-RS_63_57-poly
       ;       (mult-RS-polys (mult-RS-polys pi2 pi1 gp num-r) RS-p gp num-r)
       ;       RS-p))
;(time (mult-RS_63_57-poly
       ;       (mult-RS-polys (mult-RS-polys pi1 pi2 gp num-r) RS-p gp num-r)
       ;       RS-p))
;(time (mult-RS_63_57-poly (mult-RS_63_57-poly
                           ;                           (mult-RS_63_57-poly pi2 pi1) RS-p) RS-p))
;(time (mult-RS_63_57-poly (mult-RS_63_57-poly
                           ;                           (mult-RS_63_57-poly pi1 pi2) RS-p) RS-p))))
;
;(equal? pi4-1 p3-1)
;(equal? pi4-2 p3-2)
;(equal? pi5-1 p3-1)
;(equal? pi5-2 p3-2)
;
;(values (map (lambda(x) (RS-poly-syndromes x gp num-r)) (list pi4-1 pi4-2 pi5-1 pi5-2)))
;(values (map (lambda(x) (RS-poly-syndromes (shuffle x) gp num-r)) (list pi4-1 pi4-2 pi5-1 pi5-2)))
;
;(define pd-1 (time (car (divide-RS-polys p3-1 p2 gp num-r))))
;(define pd-2 (time (car (divide-RS-polys p3-1 p1 gp num-r))))
;
;
;(values (equal? pd-1 p1) (equal? pd-2 p2) (RS-poly-syndromes pd-1 gp num-r) (RS-poly-syndromes pd-2 gp num-r))
;
;(values (mult-RS-polys p2 p1 g num-r) (mult-RS_63_57-poly p2 p1) (mult-RS-polys2 p2 p1 g num-r));
;(values (map (lambda(x) (RS-poly-syndromes x g num-r))
;(list (mult-RS-polys p1 p2 g num-r) (mult-RS_63_57-poly p1 p2) (mult-RS-polys2 p1 p2 g num-r))))
;
;(values (map (lambda(x) (RS-poly-syndromes x g num-r))
;(list (mult-RS-polys p2 p1 g num-r) (mult-RS_63_57-poly p2 p1) (mult-RS-polys2 p2 p1 g num-r))))
;
;(values (map (lambda(x) (RS-poly-syndromes (shuffle x) g num-r))
;(list (mult-RS-polys (reverse p1) p2 g num-r)
      ;      (mult-RS_63_57-poly (reverse p1) p2) (mult-RS-polys2 (reverse p1) p2 g num-r))))
;
;(values (map (lambda(x) (RS-poly-syndromes (shuffle x) g num-r))
;(list (mult-RS-polys (reverse p2) p1 g num-r)
      ;      (mult-RS_63_57-poly (reverse p2) p1) (mult-RS-polys2 (reverse p2) p1 g num-r))))
;
;(values (map (lambda(x) (RS-poly-syndromes (reverse x) g num-r))
;(list (mult-RS-polys p1 p2 g num-r) (mult-RS_63_57-poly p1 p2) (mult-RS-polys2 p1 p2 g num-r))))
;
;(values (map (lambda(x) (RS-poly-syndromes (reverse x) g num-r))
;(list (mult-RS-polys p2 p1 g num-r) (mult-RS_63_57-poly p2 p1) (mult-RS-polys2 p2 p1 g num-r))))
;
;(values (map (lambda(x) (RS-poly-syndromes (shuffle x) g num-r))
;(list (mult-RS-polys p1 p2 g num-r) (mult-RS_63_57-poly p1 p2) (mult-RS-polys2 p1 p2 g num-r))))
;
;(values (map (lambda(x) (RS-poly-syndromes (shuffle x) g num-r))
;(list (mult-RS-polys p2 p1 g num-r) (mult-RS_63_57-poly p2 p1) (mult-RS-polys2 p2 p1 g num-r))))
;(define p4 (divide-RS-poly p3 p2 g num-r))
;(define p5 (divide-RS-poly p3 p1 g num-r))
;
;(define sp1 (RS-poly-syndromes p1 g num-r))
(define sp2 (RS-poly-syndromes p2 gp num-rt))
(define spi3 (RS-poly-syndromes pi3 gp num-rt))
;(define sp4 (RS-poly-syndromes (second p4) g num-r))
;(define sp5 (RS-poly-syndromes (second p5) g num-r))
;;;
;
;(define-values (pe1 pe2) (values (add-RS-polys p3-1 e1 gp) (add-RS-polys p3-1 e2 gp)))
;
;(define-values (p1e1 p2e1) (values (add-RS-polys p1 e1 gp) (add-RS-polys p2 e1 gp)))
;(define-values (p1e2 p2e2) (values (add-RS-polys p1 e2 gp) (add-RS-polys p2 e2 gp)))
;(define qe1 (divide-RS-polys pe1 p1 gp num-r))
;(define qe2 (divide-RS-polys pe1 p2 gp num-r));(define qe3 (divide-RS-polys pe2 p1 gp num-r))
;(define qe4 (divide-RS-polys pe2 p2 gp num-r))
;(define p6 (mult-RS-polys p1 pe2 gp num-r))
;(define p7 (mult-RS-polys pe1 p2 gp num-r))
;(define p8 (mult-RS-polys pe1 pe2 gp num-r))
;
;(define sqe1 (list (RS-poly-syndromes e1 gp num-r)
;(RS-poly-syndromes (car qe1) gp num-r) (RS-poly-syndromes (last qe1) gp num-r)))
;(define sqe2 (list (RS-poly-syndromes e1 gp num-r)
;(RS-poly-syndromes (car qe2) gp num-r) (RS-poly-syndromes (last qe2) gp num-r)))
;;
;(define sqe3 (list (RS-poly-syndromes e2 gp num-r)
;(RS-poly-syndromes (car qe3) gp num-r) (RS-poly-syndromes (last qe3) gp num-r)))
;(define sqe4 (list (RS-poly-syndromes e2 gp num-r)
;(RS-poly-syndromes (car qe4) gp num-r) (RS-poly-syndromes (last qe4) gp num-r)))
;
;
;(define sp6 (RS-poly-syndromes p6 gp num-r))
;(define sp7 (RS-poly-syndromes p7 gp num-r))
;(define sp8 (RS-poly-syndromes p8 gp num-r))
;
(define gcd (add-RS-polys (encode-RS-poly pi3 gp num-rt) pi3 gp))
(define p3-gcd (mult-RS-polys p1 gcd gp num-rt))
(define p4-gcd (mult-RS-polys p2 gcd gp num-rt))
;(define rsgcd (RS-gcd p3-gcd p4-gcd gp num-r))
;(values rsgcd (encode-RS-poly gcd gp num-r) (length (encode-RS-poly gcd gp num-r)) (length (second rsgcd))
;(divide-RS-polys p3-gcd (second rsgcd) gp num-r) (divide-RS-polys p4-gcd (second rsgcd) gp num-r)
;(RS-poly-syndromes gcd gp num-r) (RS-poly-syndromes (last (divide-RS-polys p4-gcd (second  rsgcd) gp num-r)) gp num-r)
;(RS-poly-syndromes p3-gcd gp num-r) (RS-poly-syndromes p4-gcd gp num-r))
;
;(values sqe1 sqe2 sqe3 sqe4)
;(values e1 qe1 e1 qe2 e2 qe3 e2 qe4)
;(define rp1 (encode-RS-poly pi1 rgp num-r))
;(define rp2 (encode-RS-poly pi2 rgp num-r))
;;
;(define rp3-1 (time (mult-RS-polys rp1 rp2 rgp num-r)))
;(define rgcd (encode-RS-poly pi3 rgp num-r))
;(define rp3-gcd (mult-RS-polys rp1 rgcd rgp num-r))
;(define rp4-gcd (mult-RS-polys rp2 rgcd rgp num-r))
;
;(define rsyn (list (RS-poly-syndromes rp1 rgp num-r) (RS-poly-syndromes rp2 rgp num-r)
;(RS-poly-syndromes rp3-1 rgp num-r)
;;r)
;;
;;
;
;
;
;(define gcd-rct (map (lambda(x y) (RS-gcd x y gp num-r)) p1-rct p2-rct))
;;(define gcd-rct-sh (map (lambda(x y) (RS-gcd (shuffle x) (shuffle y) gp num-r)) p1-rct p2-rct))
(define dvnd '(0 -1 -1 -1 -1 -1 -1))
(define pl1 '(11 -1 -1 -1 4 -1 -1 7 -1 -1 -1))
;(map (lambda(x) (list x (RS-gcd dvnd (RS-syndromes-equation x g1 num-rt)
;g1 num-rt))) (car (shuffle (cyclic-shift-mat pl1))))
;(map (lambda(x) (list x (RS-gcd dvnd (RS-syndromes-equation x g1 num-rt)
;g1 num-rt))) (car (shuffle (cyclic-shift-mat (shuffle pl1)))))
;(map (lambda(x) (list x (RS-decode-eucl x g1 (/ num-rt 2)))) (car (shuffle (cyclic-shift-mat pl1))))
;(map (lambda(x) (list x (RS-decode-eucl x g1 (/ num-rt 2)))) (car (shuffle (cyclic-shift-mat (shuffle pl1)))))
;(RS-decode-eucl pl1 g1 num-r)
;(RS-gcd2 dvnd (RS-syndromes-equation pl1 g1 num-r) g1 num-r)
(define pl2 '(4 -1 -1 -1 -1 -1 3 -1 -1 7 -1 -1 -1))
;(RS-gcd dvnd (RS-syndromes-equation pl2 g1 num-r) g1 num-r)
;TEST CODE____________
(define gm1 (systematic-hmg-gm 3))
(define gm2 (systematic-hmg-gm 4))
(define gm3 (RM-genmat 2 4))
(define gm4 (RM-genmat 3 5))
(define i-0 (gen-random-nbit-patterns (* (length gm3) (length gm4))
                                      (+ (length gm3) (length gm4))
                                      300))
(define i0 (gen-random-nbit-patterns (* (length gm1) (length gm2))
                                     (+ (length gm1) (length gm2))
                                     300))
(define is0 (info-bits-for-product-code gm1 gm2))
(define is-0 (info-bits-for-product-code gm3 gm4))(define i1 (map (lambda(x) (group-list x (length gm1))) i0))
(define i2 (map (lambda(x) (group-list x (length gm2))) i0))
(define is1 (regroup-list is0 (length gm1)))
(define is2 (regroup-list (transpose is0) (length gm2)))
;
;(define i2 '((0 0 0 1) (0 0 1 1) (0 0 0 0) (1 1 0 0) (0 0 0 0) (1 1 0 0) (1 0 1 0) (0 0 1 0) (1 0 0 0) (0 1 1 1) (0 0 1 0)))
;
(define c1 (map (lambda(x) (encode-linear-code-l x gm1)) i1))
(define c2 (map (lambda(x) (encode-linear-code-l x gm2)) i2))
(define c3 (encode-linear-code-l (car i1) gm1))
(define c4 (encode-linear-code-l (car i2) gm2))
(define c5 (regroup-list (take c3 (length gm2)) (length gm2)))
(define c6 (regroup-list (transpose (take c4 (length gm1))) (length gm1)))
(define c7 (encode-linear-code-l c5 gm2))
(define c8 (encode-linear-code-l c6 gm1))
(define cs1 (encode-linear-code-l is1 gm1))
(define cs2 (encode-linear-code-l is2 gm2))
(define cs3 (regroup-list cs1 (length gm2)))
(define cs4 (regroup-list (transpose cs2) (length gm1)))
(define cs5 (encode-linear-code-l cs3 gm2))


(define cs6 (encode-linear-code-l cs4 gm1))
