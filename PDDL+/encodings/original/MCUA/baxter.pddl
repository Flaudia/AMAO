(define (domain paco3d)


(:types link axis)

(:constants ZAXES - axis)

(:predicates 
(in-use) 
(connected ?l1 - link ?l2 - link)
(affects ?l1 - link ?l2 - link)
(freeToMove ?l2 - link)
(increasing_angle-baxter ?l2 - link ?x - axis)
(decreasing_angle-baxter ?l2 - link ?x - axis)
(increasing_angle-gravity ?l2 - link)
(decreasing_angle-gravity ?l2 - link)
)



(:functions 
(angle ?l2 - link ?x - axis)
(speed-i)
(speed-d)
(speed-g ?l2 - link)
)


(:action start_movement_increase
:parameters (?l1 - link ?l2 - link ?x - axis)
:precondition (and
		(connected ?l1 ?l2)
		(not (in-use))
		)
:effect (and
		(in-use)
		(not (freeToMove ?l2))
		(not (freeToMove ?l1))
		(increasing_angle-baxter ?l2 ?x)
))

(:action stop_movement_increase
:parameters (?l1 - link ?l2 - link ?x - axis)
:precondition (and
		(increasing_angle-baxter ?l2 ?x)
		(connected ?l1 ?l2)
		)
:effect (and
		(not (in-use))
		(freeToMove ?l2)
		(freeToMove ?l1)
		(not (increasing_angle-baxter ?l2 ?x))
))


(:process move_angle_increase
:parameters (?l2 - link ?x - axis)
:precondition (and 
					(increasing_angle-baxter ?l2 ?x) 
				)
:effect (and
                    (increase (angle ?l2 ?x) (* #t (speed-i)))
            )
)

(:action start_movement_decrease
:parameters (?l1 - link ?l2 - link ?x - axis)
:precondition (and
		(connected ?l1 ?l2)
		(not (in-use))
		)
:effect (and
		(in-use)
		(not (freeToMove ?l2))
		(not (freeToMove ?l1))
		(decreasing_angle-baxter ?l2 ?x)
))

(:action stop_movement_decrease
:parameters (?l1 - link ?l2 - link ?x - axis)
:precondition (and
		(decreasing_angle-baxter ?l2 ?x)
		(connected ?l1 ?l2)
		)
:effect (and
		(not (in-use))
		(freeToMove ?l2)
		(freeToMove ?l1)
		(not (decreasing_angle-baxter ?l2 ?x))
))


(:process move_angle_decrease
:parameters (?l2 - link ?x - axis)
:precondition (and 
					(decreasing_angle-baxter ?l2 ?x) 
				)
:effect (and
                    (decrease (angle ?l2 ?x) (* #t (speed-d)))
            )
)


(:process propagate_move_angle_decrease
:parameters (?l2 - link ?l3 - link ?x - axis)
:precondition (and 
					(decreasing_angle-baxter ?l2 ?x)
					(affects ?l2 ?l3)
				)
:effect (and
                    (decrease (angle ?l3 ?x) (* #t (speed-d)))
            )
)

(:process propagate_move_angle_increase
:parameters (?l2 - link ?l3 - link ?x - axis)
:precondition (and 
					(increasing_angle-baxter ?l2 ?x)
					(affects ?l2 ?l3)
				)
:effect (and
                    (increase (angle ?l3 ?x) (* #t (speed-i)))
            )
)


(:process gravity-decrease
:parameters (?l1 - link)
:precondition (and 
				(freeToMove ?l1)
				(> (angle ?l1 ZAXES) 0)
				(< (angle ?l1 ZAXES) 180)
				)
:effect (and
                    (decrease (angle ?l1 ZAXES) (* #t (speed-g ?l1)))
					(decreasing_angle-gravity ?l1)
           )
)

(:process gravity-increase
:parameters (?l1 - link)
:precondition (and 
				(freeToMove ?l1)
				(> (angle ?l1 ZAXES) 180)
				(< (angle ?l1 ZAXES) 360)
				)
:effect (and
                    (increase (angle ?l1 ZAXES) (* #t (speed-g ?l1)))
					(increasing_angle-gravity ?l1)
           )
)


(:process uniform-speed-increase-gravity
:parameters (?l1 - link)
:precondition (and 
				(increasing_angle-gravity ?l1)
				)
:effect (and
                (increase (speed-g ?l1) (* #t 0.1))
					
           )
)



(:process propagate_gravity_increase
:parameters (?l2 - link ?l3 - link)
:precondition (and 
					(increasing_angle-gravity ?l2)
					(affects ?l2 ?l3)
				)
:effect (and
                    (increase (angle ?l3 ZAXES) (* #t (speed-g ?l2)))
            )
)

(:process propagate_gravity_decrease
:parameters (?l2 - link ?l3 - link)
:precondition (and 
					(decreasing_angle-gravity ?l2)
					(affects ?l2 ?l3)
				)
:effect (and
                    (decrease (angle ?l3 ZAXES) (* #t (speed-g ?l2)))
            )
)

(:event stop-gravity-decrease
:parameters (?l3 - link)
:precondition (and (= (angle ?l3 ZAXES) 0) (decreasing_angle-gravity ?l3))
:effect  (and (not (decreasing_angle-gravity ?l3)) (assign (speed-g ?l3) 0) )
)

(:event stop-gravity-increase
:parameters (?l3 - link)
:precondition (and (= (angle ?l3 ZAXES) 360) (increasing_angle-gravity ?l3))
:effect  (and (not (increasing_angle-gravity ?l3)) (assign (speed-g ?l3) 0) )
)

(:event stop-gravity-because-mov-1
:parameters (?l3 - link)
:precondition (and (not (freeToMove ?l3)) (decreasing_angle-gravity ?l3))
:effect  (and (not (decreasing_angle-gravity ?l3)) (assign (speed-g ?l3) 0) )
)

(:event stop-gravity-because-mov-2
:parameters (?l3 - link)
:precondition (and (not (freeToMove ?l3)) (increasing_angle-gravity ?l3))
:effect (and (not (increasing_angle-gravity ?l3)) (assign (speed-g ?l3) 0) )
)


(:event back-to-zero
:parameters (?l3 - link ?x - axis)
:precondition (> (angle ?l3 ?x) 360)
:effect (assign (angle ?l3 ?x) 0)
)

(:event back-to-360
:parameters (?l3 - link ?x - axis)
:precondition (< (angle ?l3 ?x) 0)
:effect  (assign (angle ?l3 ?x) 360)
)


)
