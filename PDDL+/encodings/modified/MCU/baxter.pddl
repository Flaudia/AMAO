(define (domain paco3d)
(:requirements :typing :adl :fluents :time )


(:types link axis)

(:predicates 
(in-use)
(connected ?l1 - link ?l2 - link)
(affects ?l1 - link ?l2 - link)
(freeToMove ?l2 - link)
(increasing_angle-baxter ?l2 - link ?x - axis)
(decreasing_angle-baxter ?l2 - link ?x - axis)
(increasing_angle-gravity ?l2 - link)
(decreasing_angle-gravity ?l2 - link)
(fake ?l2 - link)
(reset ?l2 - link)
(vertical ?x - axis)
)



(:functions 
(angle ?l2 - link ?x - axis)
(speed-i)
(speed-d)
(speed-g)
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
:parameters (?l1 - link ?x - axis)
:precondition (and 
				(freeToMove ?l1)
				(vertical ?x)
				(> (angle ?l1 ?x) 0)
				(< (angle ?l1 ?x) 180)
				)
:effect (and
                    (decrease (angle ?l1 ?x) (* #t (speed-g)))
           )
)

(:process gravity-increase
:parameters (?l1 - link ?x - axis)
:precondition (and 
				(freeToMove ?l1)
				(vertical ?x)
				(> (angle ?l1 ?x) 180)
				(< (angle ?l1 ?x) 360)
				)
:effect (and
                    (increase (angle ?l1 ?x) (* #t (speed-g)))
           )
)


(:process propagate_gravity_increase
:parameters (?l2 - link ?l3 - link ?x - axis)
:precondition (and 
					(freeToMove ?l2)
				    (> (angle ?l2 ?x) 180)
				    (< (angle ?l2 ?x) 360)
					(vertical ?x)
					(affects ?l2 ?l3)
				)
:effect (and
                    (increase (angle ?l3 ?x) (* #t (speed-g)))
            )
)

(:process propagate_gravity_decrease
:parameters (?l2 - link ?l3 - link ?x - axis)
:precondition (and 
					(freeToMove ?l2)
					(> (angle ?l2 ?x) 0)
					(< (angle ?l2 ?x) 180)
					(affects ?l2 ?l3)
					(vertical ?x)
				)
:effect (and
                    (decrease (angle ?l3 ?x) (* #t (speed-g)))
            )
)


(:event back-to-zero
:parameters (?l3 - link ?x - axis)
:precondition (and (> (angle ?l3 ?x) 359) (fake ?l3) (not (reset ?l3)))
:effect  (and (not (fake ?l3)) (reset ?l3) (assign (angle ?l3 ?x) 0))
)

(:event resetting
:parameters (?l3 - link)
:precondition (and (reset ?l3) (not (fake ?l3)))
:effect  (and (fake ?l3) (not (reset ?l3)) )
)

(:event back-to-360
:parameters (?l3 - link ?x - axis)
:precondition (and  (< (angle ?l3 ?x) 0) (fake ?l3) (not (reset ?l3)))
:effect  (and (not (fake ?l3)) (reset ?l3) (assign (angle ?l3 ?x) 359))
)


)
