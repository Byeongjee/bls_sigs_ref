#!/usr/bin/env sage
# vim: syntax=python
#
# (C) 2019 Riad S. Wahby <rsw@cs.stanford.edu>
#
# common routines and definitions for G1

import hashlib

from hash_to_field import hash_to_base, hkdf_extract, hkdf_expand, OS2IP
from util import print_iv, is_debug

# BLS12-381 G1 curve
ell_u = -0xd201000000010000
p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
F = GF(p)
Ell = EllipticCurve(F, [0,4])
h = 3 * 11**2 * 10177**2 * 859267**2 * 52437899**2 # co-factor for G1
assert h == (ell_u-1)**2 // 3
assert Ell.order() % h == 0
q = Ell.order() // h
assert q == (ell_u**4 - ell_u**2 + 1)

# convenient and fast way of converting field elements to vectors
ZZR.<XX> = PolynomialRing(ZZ)

# the lexically greater of x and p-x is negative
def sgn0(x):
    xi_values = ZZR(x)

    # return sign if sign is nonzero, else return sign_i
    sign = 0
    def select_sign(sign_i):
        sign_sq = sign * sign  # 1 if sign is nonzero, else 0
        return (1 - sign_sq) * sign_i + sign_sq * sign

    # walk through each element of the vector repr of x to find the sign
    thresh = (x.base_ring().order() - 1) // 2
    for xi in reversed(list(xi_values)):
        sign = select_sign(-2 * (xi > thresh) + (xi > 0))
    return select_sign(1)

def Hp(msg, ctr):
    return hash_to_base(msg, ctr, '', p, 1, 64, hashlib.sha256)

def Hp2(msg, ctr):
    return hash_to_base(msg, ctr, '', p, 2, 64, hashlib.sha256)

def Hr(msg):
    prk = hkdf_extract(None, msg, hashlib.sha256)
    okm = hkdf_expand(prk, None, 48, hashlib.sha256)
    return OS2IP(okm) % q

# print out a point on g1
def print_g1_hex(P, margin=8):
    print " " * margin + " x = 0x%x" % int(P[0])
    print " " * margin + " y = 0x%x" % int(P[1])

# print an intermediate value comprising a point on g1
def print_iv_g1(P, name, fn):
    if not is_debug():
        return
    print_iv(None, name, fn)
    print_g1_hex(P)
