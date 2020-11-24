;;; 1: (expmod base 64 m)
(remainder (square (expmod base 32 m)))
(remainder (square (remainder (square (expmod base 16 m)))))
(remainder (square (remainder (square (remainder (square (expmod base 8 m)))))))
(remainder (square (remainder (square (remainder (square (remainder (square (expmod base 4 m)))))))))
(remainder (square (remainder (square (remainder (square (remainder (square (remainder (square (expmod base 2 m)))))))))))
(remainder (square (remainder (square (remainder (square (remainder (square (remainder (square (remainder (square (expmod base 1 m)))))))))))))
(remainder (square (remainder (square (remainder (square (remainder (square (remainder (square (remainder (square (remainder (* base (expmod base 0 m)))))))))))))))

;;; 2: (expmod base 64 m)
(remainder (fast-expt base 64) m)
(remainder (square (fast-expt base 32)))
(remainder (square (square (fast-expt base 16))))
(remainder (square (square (square (fast-expt base 8)))))
(remainder (square (square (square (square (fast-expt base 4)))))))
(remainder (square (square (square (square (square (fast-expt base 2)))))))
(remainder (square (square (square (square (square (fast-expt base 2)))))))
(remainder (square (square (square (square (square (square (fast-expt base 1))))))))