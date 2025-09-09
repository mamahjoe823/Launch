;; problem-solver
;; Short & unique Clarity contract for problem solving + contract obtaining

(define-data-var project-counter uint u0)

(define-map projects ((id uint))
  ((owner principal)
   (problem (string-ascii 80))
   (solution (string-ascii 80))
   (status (string-ascii 15))))

;; Create a project with a problem
(define-public (create-project (problem (string-ascii 80)))
  (let ((id (var-get project-counter)))
    (begin
      (map-set projects id
        ((owner tx-sender)
         (problem problem)
         (solution "")
         (status "open")))
      (var-set project-counter (+ id u1))
      (ok id)
    )
  )
)

;; Submit a solution to an existing project
(define-public (solve-project (id uint) (solution (string-ascii 80)))
  (match (map-get? projects id)
    project
      (begin
        (map-set projects id
          ((owner (get owner project))
           (problem (get problem project))
           (solution solution)
           (status "solved")))
        (ok "Solution submitted successfully")
      )
    (err u1) ;; project not found
  )
)

;; Award a contract after solution
(define-public (obtain-contract (id uint))
  (match (map-get? projects id)
    project
      (if (is-eq (get status project) "solved")
          (begin
            (map-set projects id
              ((owner (get owner project))
               (problem (get problem project))
               (solution (get solution project))
               (status "contracted")))
            (ok "Contract awarded"))
          (err u2)) ;; must be solved first
    (err u3) ;; project not found
  )
)
