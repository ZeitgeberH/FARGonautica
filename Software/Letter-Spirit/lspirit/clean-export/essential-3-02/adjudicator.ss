;=============================================================================
; adjudicator.ss : Adjudicator codelets
;=============================================================================

; [comparer]-----------------------------------------------------------------
; Adjudicator codelet, JAR 3/5/98
;
; Adjudicator codelets progressing with difficulty, 4/21/98
;
(define comparer-codelet
  (lambda (part nvtype)
    (lambda (gen)
      (if *graphics* (draw-codelet "Comparer-codelet" gen))
      (codemsg "Comparer-codelet from generation ~s~%" gen)
      (codemsg "  looking for norm violation ~s~%" nvtype)
      (if *graphics*
	  (draw-codelet-message
	   (format "looking for norm violation ~s~%"
		   nvtype)))
      (let*
	  ([partname (car part)]
	   [type (lookup 'topology (eval partname))]
	   [partprops (lookup partname *relative-nvs*)]
	   [oldprops (find partname *relative-nvs*)]
	   [comparison (compare-nv-type part nvtype)]
	   [already (subtract (mapcar car (cadr oldprops)) '(tips))]
	   [tiptypes (not-atoms (map cadr (cadr oldprops)))])
	(if
	    (not (or
		  (member? nvtype already)
		  (eq? comparison 'same)
		  (and (eq? 'tips nvtype)
		       (or
			(eq? type 'loop)
			(eq? type 'dot)
			(member? comparison tiptypes)
			(eq? (cadr comparison) '*no-move*)))))
	    (set! *relative-nvs*
		  (condcons
		   (list partname
			 (cons
			  (list nvtype comparison)
			  partprops))
	       (remove oldprops *relative-nvs*))))
	(if (< (n-sided-die 2) 2)
	    (begin
	      (add-to-coderack
	       (comparer-codelet (roulette *fillers*) (roulette *nv-types*))
	       'comparer-codelet
	       *medium-urgency*
	       (add1 gen))
	      (codemsg " comparer-codelet spun.~%")))))))

; [stenographer]------------------------------------------------------------
; notes the difference between norms and observed features, but literally
(define stenographer-codelet
  (lambda (part nvtype)
    (lambda (gen)
      (if *graphics* (draw-codelet "Stenographer-codelet" gen))
      (codemsg "Stenographer-codelet from generation ~s~%" gen)
      (codemsg "  looking for norm violation ~s~%" nvtype)
      (if *graphics*
	  (draw-codelet-message
	   (format "looking for norm violation ~s~%"
		   nvtype)))
      (let*
	  ([partname (car part)]
	   [type (lookup 'topology (eval partname))]
	   [partprops (lookup partname *val-to-val-nvs*)]
	   [oldprops (find partname *val-to-val-nvs*)]
	   [comparison (val-to-val-nv-type part nvtype)]
	   [already (subtract (mapcar car (cadr oldprops)) '(tips))]
	   [tiptypes (map car (not-atoms (map cadr (cadr oldprops))))])
	(if
	    (not (or
		  (member? nvtype already)
		  (eq? comparison 'none)
		  (eq? (car comparison) (cadr comparison))
		  (and (eq? 'tips nvtype)
		       (or
			(eq? type 'loop)
			(eq? type 'dot)
			(member? (car comparison) tiptypes)
			(eq? (caadr comparison) (cadadr comparison))))))
	    (set! *val-to-val-nvs*
		  (condcons
		   (list partname
			 (cons
			  (list nvtype comparison)
			  partprops))
	       (remove oldprops *val-to-val-nvs*))))
	(if (< (n-sided-die 2) 2)
	    (begin
	      (add-to-coderack
	       (stenographer-codelet
		(roulette *fillers*) (roulette *nv-types*))
	       'stenographer-codelet
	       *medium-urgency*
	       (add1 gen))
	      (codemsg " stenographer-codelet spun.~%")))))))

; [constable]---------------------------------------------------------------

(define constable-codelet
  (lambda (artype)
    (lambda (gen)
      (if *graphics* (draw-codelet "Constable-codelet" gen))
      (codemsg "Constable-codelet from generation ~s~%" gen)
      (let* ([enforced? (rule-type artype)]
	     [care? (member? artype *rules-to-notice*)])
	(codemsg "  looking for rule violation ~s~%" artype)
	(if *graphics*
	    (draw-codelet-message
	      (format "looking for rule violation ~s~%"
		artype)))
	(begin
	  (if (and enforced? care?)
	      (set! *abstract-rules* (condcons artype *abstract-rules*)))
	  (if (< (n-sided-die 2) 2)
	      (begin
		(add-to-coderack
		 (constable-codelet (roulette *rule-types*))
		 'constable-codelet
		 *medium-urgency*
		 (add1 gen))
		(codemsg " constable-codelet spun.~%"))))))))


; just keep all the motifs of a type together
(define worm-codelet
  (lambda (mtftype)
    (lambda (gen)
      (begin
	(if *graphics* (draw-codelet "Worm-codelet" gen))
	(codemsg "Worm-codelet from generation ~s~%" gen)
	(codemsg "  looking for motif ~s~%" mtftype)
	(if *graphics*
	    (draw-codelet-message
	     (format "looking for motif ~s~%"
		     mtftype)))
	(case mtftype
	  [literal (set! *literal-motifs*
			 (condcons (worm-type mtftype) *literal-motifs*))]
	  [translate (set! *translate-motifs*
			   (condcons (worm-type mtftype) *translate-motifs*))]
	  [turn-180 (set! *turn-180-motifs*
			  (condcons (worm-type mtftype) *turn-180-motifs*))]
	  [turn-90 (set! *turn-90-motifs*
			  (condcons (worm-type mtftype) *turn-90-motifs*))]
	  [turn-45 (set! *turn-45-motifs*
			  (condcons (worm-type mtftype) *turn-45-motifs*))])
	(if (< (n-sided-die 2) 2)
	    (begin
	      (add-to-coderack
	       (worm-codelet (roulette *motif-types*))
	       'worm-codelet
	       *medium-urgency*
	       (add1 gen))
	      (codemsg " worm-codelet spun.~%")))))))

; far end is in Thematic Focus
; near end is in the current letter's SPs (the *workspace*)
; bridges stored in *bridges*

(set! *sp-types*
      '(*relative-nvs* *val-to-val-nvs* *abstract-rules* *literal-motifs*
		       *translate-motifs* *turn-180-motifs*
		       *turn-90-motifs* *turn-45-motifs*))

(set! *favored-tf-levels*
      '((*letter-rows* 1)
	(*two-time-sps* 2)
	(*occasional-sps* 4)
	(*common-sps* 8)
	(*frequent-sps* 16)
	(*universal-sps* 32)))

(define bridge-back-codelet
  (lambda (levelname)
    (lambda (gen)
      (codemsg "Bridge-back codelet from generation ~s~%" gen)
      (codemsg " bridge from ~s to current letter~%" levelname)
      (let* ([sp-type (weighted-roulette *favored-sp-types*)]
	     [far-end (bridge-far-start-what sp-type levelname)])
	; fizzle if we find no SP there at all, or if we find
	; an abstract-rule that doesn't apply to this letter
	(if (or
	     (null? far-end)
	     (and
	      (eq? sp-type '*abstract-rules*)
	      (not (member? far-end (whole-rule-norms *answer*)))))
	    (codemsg " Bridge-back fizzled on level ~s -- no relevant SP~%"
		     levelname)
	    (let*
		([near-where (bridge-near-where sp-type)]
		 [near-choices (bridge-near-choices near-where)]
		 [test-near-end
		  (lambda (choice)
		    (sp-match levelname sp-type choice far-end))]
		 [valid-near-ends
		  (remove-item '() (map test-near-end near-choices))])
	      ; (printf "Bridge-back~%")
	      (if (null? valid-near-ends)
		  (let
		      ([new-bridge
			(list 'demote sp-type levelname far-end)])
		    (set! *bridges* (condcons new-bridge *bridges*))
		    (set! temp-jolts
			  (cons
			   (list 'back-not-found sp-type levelname
				 far-end)
			   temp-jolts))
		    (thermostat
		     150 (* 0.9 (fail-importance sp-type levelname far-end)))
		    (codemsg " Letter lacks SP from Thematic Focus~%"))
		  (let*
		      ([match (length-roulette valid-near-ends)]
		       [new-bridge
			(list 'promote sp-type levelname far-end
			      match)])
		    (set! temp-jolts
			  (cons
			   (list 'back-found sp-type levelname match)
			   temp-jolts))
		    (thermostat -25
				(* 2.7 (importance sp-type levelname match)))
		    (set! *bridges* (condcons new-bridge *bridges*))))))))))

(define bridge-ahead-codelet
  (lambda (gen)
      (codemsg "bridge-ahead codelet from generation ~s~%" gen)
      (codemsg " bridge from current letter~%")
      (let* ([sp-type (weighted-roulette *favored-sp-types*)]
	     [near-where (bridge-near-where sp-type)]
	     [near-choices (bridge-near-choices near-where)])
	(if (null? near-choices)
	    (codemsg " There are no SPs of type ~s~%" sp-type)
	    (let
		([near-end (roulette near-choices)])
	      (let
		  ([far-match
		    (if (motif-type? sp-type)
			(best-TF-motif-match sp-type near-end)
			(bridge-highest-far-match
			 sp-type near-end
			 (reverse *thematic-focus*)))])
		(if (null? far-match)
		    (let
			([new-bridge
			  (list 'add sp-type near-end)])
		      (set! *bridges* (condcons new-bridge *bridges*))
		      (set! temp-jolts
			    (cons
			     (list 'ahead-not-found sp-type near-end)
			     temp-jolts))
		      (thermostat
		       (+ 20
			  (* 26.666667 *full-levels*))
		       (* 3 (sp-prob sp-type near-end)))
		      (codemsg " SP not in Thematic Focus yet ~%"))
		    (let*
			([far-level (car far-match)]
			 [far-sp (cadr far-match)]
			 [match (caddr far-match)]
			 [new-bridge
			  (list 'promote sp-type far-level far-sp match)])
		      ; we'll count level here
		      (thermostat
		       -25 (* 1.2 (importance sp-type far-level match)))
		      ; (thermostat 0 (* 50 (sp-prob sp-type match)))
		      (set! temp-jolts
			    (cons
			     (list 'ahead-found sp-type far-level far-sp)
			     temp-jolts))
		      (set! *bridges*
			    (condcons new-bridge *bridges*))))))))))

; just determines the order of the bridges for eventual TF update (if any)

(define promoter-codelet
  (lambda (gen)
    (codemsg "Promoter codelet from generation ~s~%" gen)
    (codemsg " Promote SP in Thematic Focus~%")
    (if (null? *bridges*)
	(begin
	  (codemsg "No bridges left!~%")
	  (codemsg "  >>>Fizzle<<<~%"))
	(let
	    ([bridge (roulette *bridges*)])
	  (set! *bridges* (remove-item bridge *bridges*))
	  (set! *promotions* (cons bridge *promotions*))))))

(define update-tf
  (lambda ()
    (begin
      (set! *library*  ; must also yank old entry, if any
	    (condcons (library-entry) *library*))
      (handle-promotion))))
      
; deterministic promotion and probabilistic demotion
; items in promote bridge are
; add '*letter-rows* sp-type workspace-sp
; promote sp-type levelname tf-sp workspace-sp
; demote sp-type levelname tf-sp

(define handle-promotion
  (lambda ()
    (if (not (null? *promotions*))
	(let ([bridge (car *promotions*)])
	  (set! *promotions* (cdr *promotions*))
	  (case (car bridge)
	    [add
	     (if (not (and (motif-type? (cadr bridge))
			   (member? '*no-move* (caddr bridge))))
		 (add-to-tf '*letter-rows* (cadr bridge) (caddr bridge)))]
	    [promote
	     (if (prob-decision? (promote-prob (caddr bridge) (cadr bridge)))
		 (promote-in-tf (cadr bridge) (caddr bridge)
				(nth 4 bridge) (nth 5 bridge)))]
	    [demote
	     (if (prob-decision? (demote-prob (caddr bridge) (cadr bridge)))
		 (demote-in-tf (cadr bridge) (caddr bridge)
			       (nth 4 bridge)))])
	  (handle-promotion)))))

(define ahead-fail-test
  (lambda (sp-type sp)
    (begin
      (set! *temperature* 50)
      (thermostat 100 (* 50 (sp-prob sp-type sp)))
      *temperature*)))

(define ahead-success-test
  (lambda (sp-type sp)
    (begin
      (set! *temperature* 50)
      (thermostat 0 (* 50 (sp-prob sp-type sp)))
      *temperature*)))

(define back-fail-test
  (lambda (sp-type level sp)
    (begin
      (set! *temperature* 50)
      (thermostat 100 (* 6 (fail-importance sp-type level sp)))
      *temperature*)))


(define back-success-test
  (lambda (sp-type level sp)
    (begin
      (set! *temperature* 50)
      (thermostat 0 (* 6 (importance sp-type level sp)))
      *temperature*)))
