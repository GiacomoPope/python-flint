from cpython.list cimport PyList_GET_SIZE

from flint.pyflint cimport global_random_state
from flint.flintlib.fmpz_mod cimport fmpz_mod_neg, fmpz_mod_set_fmpz
from flint.flintlib.fmpz_mod_poly cimport *
from flint.flintlib.fmpz_mod_poly_factor cimport *
from flint.flintlib.fmpz cimport(
    fmpz_init,
    fmpz_clear,
    fmpz_is_one
)
from flint.flintlib.fmpz_vec cimport _fmpz_vec_init, _fmpz_vec_clear

from flint.types.fmpz cimport fmpz, any_as_fmpz
from flint.types.fmpz_mod cimport fmpz_mod_ctx, fmpz_mod
from flint.types.fmpz_poly cimport fmpz_poly

from flint.flint_base.flint_base cimport flint_poly
from flint.utils.typecheck cimport typecheck

from flint.utils.flint_exceptions import DomainError

cdef class fmpz_mod_poly_ctx:
    r"""
    Context object for creating :class:`~.fmpz_mod_poly` initalised 
    with a modulus :math:`N`.

        >>> fmpz_mod_poly_ctx(2**127 - 1)
        fmpz_mod_poly_ctx(170141183460469231731687303715884105727)

    """
    def __cinit__(self):
        pass

    def __dealloc__(self):
        pass

    def __init__(self, mod):
        # Allow context to be made from fmpz_mod_ctx
        if typecheck(mod, fmpz_mod_ctx):
            self.mod = mod
        else: # Otherwise attempt to create context from moduli
            self.mod = fmpz_mod_ctx(mod)

    def modulus(self):
        """
        Return the modulus from the context as an ``fmpz``
        type

            >>> R = fmpz_mod_poly_ctx(2**127 - 1)
            >>> R.modulus()
            170141183460469231731687303715884105727

        """
        return self.mod.modulus()

    def is_prime(self):
        """
        Return whether the modulus is prime

            >>> fmpz_mod_poly_ctx(2**127).is_prime()
            False
            >>> fmpz_mod_poly_ctx(2**127 - 1).is_prime()
            True
        """
        return self.mod.is_prime()

    def zero(self):
        """
        Return the zero element of this polynomial ring

            >>> R = fmpz_mod_poly_ctx(163)
            >>> R.zero()
            0
        """
        cdef fmpz_mod_poly res
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self)
        fmpz_mod_poly_zero(res.val, self.mod.val)
        return res

    def one(self):
        """
        Return the one element of this polynomial ring

            >>> R = fmpz_mod_poly_ctx(163)
            >>> R.one()
            1
        """
        cdef fmpz_mod_poly res
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self)
        fmpz_mod_poly_one(res.val, self.mod.val)
        return res

    def gen(self):
        """
        Return the generator of the polynomial: `x`

            >>> R = fmpz_mod_poly_ctx(163)
            >>> R.gen()
            x
        """
        cdef fmpz_mod_poly res
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self)
        fmpz_mod_poly_set_coeff_ui(res.val, 1, 1, self.mod.val)
        return res

    def random_element(self, degree=3, monic=False, irreducible=False):
        """
        Return a random element of degree ``degree``. If ``monic`` is ``True``,
        ensures the output is monic. If ``irreducible`` is ``True``, ensures
        that the output is irreducible.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R.random_element()
            >>> f.degree()
            3
            >>> f = R.random_element(degree=123)
            >>> f.degree()
            123
            >>> f = R.random_element(monic=True)
            >>> f.is_monic()
            True
            >>> f = R.random_element(degree=13, monic=True, irreducible=True)
            >>> f.degree()
            13
            >>> f.is_monic()
            True
            >>> f.is_irreducible()
            True
        """
        cdef slong length
        if not (isinstance(monic, bool) and isinstance(irreducible, bool)):
            raise ValueError("Both `monic` and `irreducible` must be of type bool")

        length = degree + 1
        if length <= 0:
            raise ValueError("The degree argument must be non-negative")

        cdef fmpz_mod_poly res
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self)
        if (monic and irreducible):
            fmpz_mod_poly_randtest_monic_irreducible(
                res.val, global_random_state, length, self.mod.val
            )
        elif monic:
            fmpz_mod_poly_randtest_monic(
                res.val, global_random_state, length, self.mod.val
            )
        elif irreducible:
            fmpz_mod_poly_randtest_irreducible(
                res.val, global_random_state, length, self.mod.val
            )
        else:
            fmpz_mod_poly_randtest(
                res.val, global_random_state, length, self.mod.val
            )
        return res


    cdef set_list_as_fmpz_mod_poly(self, fmpz_mod_poly_t poly, val):
        cdef long i, n
        cdef fmpz_t x

        n = PyList_GET_SIZE(val)
        fmpz_mod_poly_fit_length(poly, n, self.mod.val)
        
        # TODO: should we support conversion from nmod?
        fmpz_init(x)
        for i in range(n):
            if typecheck(val[i], fmpz_mod):
                if self.mod != (<fmpz_mod>(val[i])).ctx:
                    raise ValueError("moduli must match")
                fmpz_mod_poly_set_coeff_fmpz(
                    poly, i, (<fmpz_mod>(val[i])).val, self.mod.val
                )
            elif typecheck(val[i], fmpz):
                fmpz_mod_poly_set_coeff_fmpz(
                    poly, i, (<fmpz>(val[i])).val, self.mod.val
                )
            else:
                val_fmpz = any_as_fmpz(val[i])
                if val_fmpz is NotImplemented:
                    fmpz_clear(x)
                    raise TypeError(f"unsupported coefficient in list")
                fmpz_mod_poly_set_coeff_fmpz(
                    poly, i, (<fmpz>(val_fmpz)).val, self.mod.val
                )
        fmpz_clear(x)
        return 0

    cdef set_any_as_fmpz_mod_poly(self, fmpz_mod_poly_t poly, obj):
        if typecheck(obj, list):
            return self.set_list_as_fmpz_mod_poly(poly, obj)

        # Set val from fmpz_mod_poly 
        if typecheck(obj, fmpz_mod_poly):
            if self != (<fmpz_mod_poly>obj).ctx:
                raise ValueError("moduli must match")
            fmpz_mod_poly_set(
                poly, (<fmpz_mod_poly>obj).val, self.mod.val
            )
            return 0

        # Convert fmpz_mod to constant poly
        if typecheck(obj, fmpz_mod):
            if self.mod != (<fmpz_mod>obj).ctx:
                raise ValueError("moduli must match")
            fmpz_mod_poly_set_fmpz(
                poly, (<fmpz_mod>obj).val, self.mod.val
            )
            return 0

        # Reduced fmpz_poly modulo mod
        if typecheck(obj, fmpz_poly):
            fmpz_mod_poly_set_fmpz_poly(
                poly, (<fmpz_poly>obj).val, self.mod.val
            )
            return 0

        # Lastly try and convert to an fmpz
        obj = any_as_fmpz(obj)
        if obj is NotImplemented:
            return NotImplemented
        fmpz_mod_poly_set_fmpz(
            poly, (<fmpz>obj).val, self.mod.val
        )
        return 0

    cdef any_as_fmpz_mod_poly(self, obj):
        # Convert fmpz_mod_poly
        if typecheck(obj, fmpz_mod_poly):
            if self != (<fmpz_mod_poly>obj).ctx:
                raise ValueError("moduli must match")
            return obj
        
        cdef fmpz_mod_poly res
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self)
        check = self.set_any_as_fmpz_mod_poly(res.val, obj)
        if check is NotImplemented:
            return NotImplemented
        
        return res

    def __eq__(self, other):
        # Most often, we expect both `fmpz_mod_poly` to be pointing 
        # to the same ctx, so this seems the fastest way to check
        if self is other:
            return True
        
        # If they're not the same object in memory, they may have the
        # same modulus, which is good enough
        if typecheck(other, fmpz_mod_poly_ctx):
            return self.mod == (<fmpz_mod_poly_ctx>other).mod
        return False
    
    def __hash__(self):
        return hash(self.modulus())

    def __str__(self):
        return f"Context for fmpz_mod_poly with modulus: {self.modulus()}"

    def __repr__(self):
        return f"fmpz_mod_poly_ctx({self.modulus()})"

    def __call__(self, val):
        return fmpz_mod_poly(val, self)

    def minpoly(self, vals):
        """
        Returns a minimal generating polynomial for sequence `vals`.

        A minimal generating polynomial is a monic polynomial, of minimal degree `d`, 
        that annihilates any consecutive `d+1` terms in seq.

        Assumes that the modulus is prime.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> R.minpoly([1,1,2,3,5,8])
            x^2 + 162*x + 162
            >>> R.minpoly([2,4,6,8,10])
            x^2 + 161*x + 1
        """
        cdef fmpz_mod_poly res

        if not self.is_prime():
            raise NotImplementedError("minpoly algorithm assumes that the modulus is prime")

        if not isinstance(vals, (list, tuple)):
            raise ValueError("Input must be a list or tuple of points")

        n = len(vals)
        xs = _fmpz_vec_init(n)
        for i in range(n):
            check = self.mod.set_any_as_fmpz_mod(&xs[i], vals[i])
            if check is NotImplemented:
                _fmpz_vec_clear(xs, n)
                raise ValueError(f"Unable to cast {vals[i]} to an `fmpz_mod`")
        
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self)
        fmpz_mod_poly_minpoly(res.val, xs, n, self.mod.val)

        _fmpz_vec_clear(xs, n)
        return res

cdef class fmpz_mod_poly(flint_poly):
    """
    The *fmpz_mod_poly* type represents univariate polynomials
    over integer modulo an arbitrary-size modulus. 
    For wordsize modulus, see :class:`~.nmod_poly`.

    An *fmpz_mod_poly* element is constructed from an :class:`~.fmpz_mod_poly_ctx`
    either by passing it as an argument to the type, or
    by directly calling the context:

        >>> fmpz_mod_poly([1,-2,3], fmpz_mod_poly_ctx(2**127 - 1))
        3*x^2 + 170141183460469231731687303715884105725*x + 1
        >>> R = fmpz_mod_poly_ctx(2**127 - 1)
        >>> R([4,5,6])
        6*x^2 + 5*x + 4

    """
    def __cinit__(self, val, ctx):
        if not typecheck(ctx, fmpz_mod_poly_ctx):
            raise TypeError
        self.ctx = ctx
        fmpz_mod_poly_init(self.val, self.ctx.mod.val)

    def __dealloc__(self):
        if self.ctx is not None:
            fmpz_mod_poly_clear(self.val, self.ctx.mod.val)

    def __init__(self, val, ctx):
        check = self.ctx.set_any_as_fmpz_mod_poly(self.val, val)
        if check is NotImplemented:
            raise TypeError

    def __pos__(self):
        return self

    def __neg__(self):
        cdef fmpz_mod_poly res
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_neg(res.val, self.val, self.ctx.mod.val)
        return res

    def __add__(self, other):
        cdef fmpz_mod_poly res
        other = self.ctx.any_as_fmpz_mod_poly(other)
        if other is NotImplemented:
            return other

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_add(
            res.val, self.val, (<fmpz_mod_poly>other).val, self.ctx.mod.val
        )
        return res

    def __radd__(self, other):
        return self.__add__(other)

    @staticmethod
    def _sub_(left, right):
        cdef fmpz_mod_poly res
    
        # Case when left and right are already fmpz_mod_poly
        if typecheck(left, fmpz_mod_poly) and typecheck(right, fmpz_mod_poly):
            if not (<fmpz_mod_poly>left).ctx == (<fmpz_mod_poly>right).ctx:
                raise ValueError("moduli must match")

        # Case when right is not fmpz_mod_poly, try to convert to fmpz
        elif typecheck(left, fmpz_mod_poly):
            right = (<fmpz_mod_poly>left).ctx.any_as_fmpz_mod_poly(right)
            if right is NotImplemented:
                return NotImplemented

        # Case when left is not fmpz_mod_poly, try to convert to fmpz
        else:
            left = (<fmpz_mod_poly>right).ctx.any_as_fmpz_mod_poly(left)
            if left is NotImplemented:
                return NotImplemented

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, (<fmpz_mod_poly>left).ctx)
        fmpz_mod_poly_sub(
                res.val, (<fmpz_mod_poly>left).val, (<fmpz_mod_poly>right).val, res.ctx.mod.val
        )
        return res

    def __sub__(s, t):
        return fmpz_mod_poly._sub_(s, t)

    def __rsub__(s, t):
        return fmpz_mod_poly._sub_(t, s)

    def __mul__(self, other):
        # TODO:
        # Allow scalar multiplication for efficiency, rather 
        # than casting `other` to a polynomial?
        cdef fmpz_mod_poly res
        other = self.ctx.any_as_fmpz_mod_poly(other)
        if other is NotImplemented:
            return other

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_mul(
            res.val, self.val, (<fmpz_mod_poly>other).val, self.ctx.mod.val
        )
        return res

    def __rmul__(self, other):
        return self.__mul__(other)

    def exact_division(self, right):
        """
        TODO
        """
        cdef bint check
        cdef fmpz_mod_poly res

        # Case when right is not fmpz_mod_poly, try to convert to fmpz
        right = self.ctx.any_as_fmpz_mod_poly(right)
        if right is NotImplemented:
            return NotImplemented

        if right == 0:
            raise ZeroDivisionError(f"Cannot divide by zero")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        check = fmpz_mod_poly_divides(
            res.val, self.val, (<fmpz_mod_poly>right).val, res.ctx.mod.val
        )
        if check == 0:
            raise ValueError(
                f"{right} does not divide {self}"
            )

        return res

    def _div_(self, other):
        cdef fmpz_mod_poly res

        other = self.ctx.mod.any_as_fmpz_mod(other)
        if other is NotImplemented:
            return NotImplemented
        
        if other == 0:
            raise ZeroDivisionError(f"Cannot divide by zero")

        if not other.is_unit():
            raise ZeroDivisionError(f"Cannot divide by {other} modulo {self.ctx.modulus()}")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_scalar_div_fmpz(
            res.val, self.val, (<fmpz_mod>other).val, res.ctx.mod.val
        )

        return res

    def __div__(s, t):
        return fmpz_mod_poly._div_(s, t)

    def __truediv__(s, t):
        return fmpz_mod_poly._div_(s, t)

    @staticmethod
    def _floordiv_(left, right):
        cdef fmpz_mod_poly res

        # Case when left and right are already fmpz_mod_poly
        if typecheck(left, fmpz_mod_poly) and typecheck(right, fmpz_mod_poly):
            if not (<fmpz_mod_poly>left).ctx == (<fmpz_mod_poly>right).ctx:
                raise ValueError("moduli must match")

        # Case when right is not fmpz_mod_poly, try to convert to fmpz
        elif typecheck(left, fmpz_mod_poly):
            right = (<fmpz_mod_poly>left).ctx.any_as_fmpz_mod_poly(right)
            if right is NotImplemented:
                return NotImplemented

        # Case when left is not fmpz_mod_poly, try to convert to fmpz
        else:
            left = (<fmpz_mod_poly>right).ctx.any_as_fmpz_mod_poly(left)
            if left is NotImplemented:
                return NotImplemented

        if not right.leading_coefficient().is_unit():
            raise ZeroDivisionError(f"The leading term of {right} must be a unit modulo N")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, (<fmpz_mod_poly>left).ctx)
        fmpz_mod_poly_div(
            res.val, (<fmpz_mod_poly>left).val, (<fmpz_mod_poly>right).val, res.ctx.mod.val
        )
        return res 

    def __floordiv__(self, other):
        return fmpz_mod_poly._floordiv_(self, other)

    def __rfloordiv__(self, other):
        return fmpz_mod_poly._floordiv_(other, self)

    def __pow__(self, e, mod=None):
        if mod is not None:
            raise NotImplementedError

        cdef fmpz_mod_poly res
        if e < 0:
            raise ValueError("Exponent must be non-negative")

        cdef ulong e_ulong = e
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_pow(
            res.val, self.val, e_ulong, self.ctx.mod.val
        )
        return res
          
    def left_shift(self, slong n):
        """
        Returns ``self`` shifted left by ``n`` coefficients by inserting 
        zero coefficients. This is equivalent to multiplying the polynomial
        by x^n

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.left_shift(0)
            3*x^2 + 2*x + 1
            >>> f.left_shift(1)
            3*x^3 + 2*x^2 + x
            >>> f.left_shift(4)
            3*x^6 + 2*x^5 + x^4

        """
        cdef fmpz_mod_poly res
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)

        if n < 0:
            raise ValueError("Value must be shifted by a non-negative integer")

        if n > 0:
            fmpz_mod_poly_shift_left(
                res.val, self.val, n, self.ctx.mod.val
            )
        else: # do nothing, just copy self
            fmpz_mod_poly_set(
                res.val, self.val, self.ctx.mod.val
            )

        return res

    def right_shift(self, slong n):
        """
        Returns ``self`` shifted right by ``n`` coefficients. 
        This is equivalent to the floor division of the polynomial
        by x^n

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.right_shift(0)
            3*x^2 + 2*x + 1
            >>> f.right_shift(1)
            3*x + 2
            >>> f.right_shift(4)
            0
        """
        cdef fmpz_mod_poly res

        if n < 0:
            raise ValueError("Value must be shifted by a non-negative integer")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)

        if n > 0:
            fmpz_mod_poly_shift_right(
                res.val, self.val, n, self.ctx.mod.val
            )
        else: # do nothing, just copy self
            fmpz_mod_poly_set(
                res.val, self.val, self.ctx.mod.val
            )

        return res

    @staticmethod
    def _mod_(left, right):
        cdef fmpz_t f
        cdef fmpz_mod_poly res

        # Case when left and right are already fmpz_mod_poly
        if typecheck(left, fmpz_mod_poly) and typecheck(right, fmpz_mod_poly):
            if not (<fmpz_mod_poly>left).ctx == (<fmpz_mod_poly>right).ctx:
                raise ValueError("moduli must match")

        # Case when right is not fmpz_mod_poly, try to convert to fmpz
        elif typecheck(left, fmpz_mod_poly):
            right = (<fmpz_mod_poly>left).ctx.any_as_fmpz_mod_poly(right)
            if right is NotImplemented:
                return NotImplemented

        # Case when left is not fmpz_mod_poly, try to convert to fmpz
        else:
            left = (<fmpz_mod_poly>right).ctx.any_as_fmpz_mod_poly(left)
            if left is NotImplemented:
                return NotImplemented

        if right == 0:
            raise ZeroDivisionError(f"Cannot reduce modulo zero")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, (<fmpz_mod_poly>left).ctx)
        fmpz_init(f)
        fmpz_mod_poly_rem_f(
            f, res.val, (<fmpz_mod_poly>left).val, (<fmpz_mod_poly>right).val, res.ctx.mod.val
        )
        if not fmpz_is_one(f):
            fmpz_clear(f)
            raise ValueError(
                f"Cannot compute remainder of {left} modulo {right}"
            )

        return res

    def __mod__(s, t):
        return fmpz_mod_poly._mod_(s, t)

    def __rmod__(s, t):
        return fmpz_mod_poly._mod_(t, s)    

    def __richcmp__(self, other, int op):
        cdef bint res
        if op != 2 and op != 3:
            raise TypeError("fmpz_mod_poly cannot be ordered")

        if not typecheck(other, fmpz_mod_poly):
            other = self.ctx.any_as_fmpz_mod_poly(other)

        if typecheck(other, fmpz_mod_poly):
            res = (self.ctx == (<fmpz_mod_poly>other).ctx) and \
                  fmpz_mod_poly_equal(self.val, (<fmpz_mod_poly>other).val, self.ctx.mod.val)
            if op == 2:
                return res
            else:
                return not res
        else:
            return NotImplemented

    def __getitem__(self, long i):
        cdef fmpz_mod x
        x = fmpz_mod.__new__(fmpz_mod)
        x.ctx = self.ctx.mod
        if i < 0:
            return x
        fmpz_mod_poly_get_coeff_fmpz(
            x.val, self.val, i, self.ctx.mod.val
        )
        return x

    def __setitem__(self, long i, x):
        if i < 0:
            raise ValueError("cannot assign to index < 0 of polynomial")
        v = self.ctx.mod.any_as_fmpz_mod(x)
        if v is NotImplemented:
            raise TypeError
        fmpz_mod_poly_set_coeff_fmpz(
            self.val, i, (<fmpz_mod>v).val, self.ctx.mod.val
        )

    def __len__(self):
        return fmpz_mod_poly_length(self.val, self.ctx.mod.val)

    def __hash__(self):
        return hash(tuple(self.coeffs()))

    def __call__(self, input):
        if typecheck(input, fmpz_mod_poly):
            return self.compose(input)
        elif isinstance(input, (list, tuple)):
            return self.multipoint_evaluate(input)
        else:
            return self.evaluate(input)
    
    def evaluate(self, input):
        """
        TODO
        """
        cdef fmpz_mod res
        val = self.ctx.mod.any_as_fmpz_mod(input)
        if val is NotImplemented:
            raise TypeError(f"Cannot evaluate the polynomial with input: {input}")

        res = fmpz_mod.__new__(fmpz_mod)
        res.ctx = self.ctx.mod
        fmpz_mod_poly_evaluate_fmpz(res.val, self.val, (<fmpz_mod>val).val, self.ctx.mod.val)
        return res

    def multipoint_evaluate(self, vals):
        """
        Returns a list of values computed from evaluating
        ``self`` at the ``n`` values given in the vector ``val``
        
        TODO: We could allow passing as an optional input the
        subproduct tree, which would allow for faster, repeated
        multipoint evaluations

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3,4,5])
            >>> [f(x) for x in [-1,-2,-3]]
            [fmpz_mod(3, 163), fmpz_mod(57, 163), fmpz_mod(156, 163)]
            >>> f.multipoint_evaluate([-1,-2,-3])
            [fmpz_mod(3, 163), fmpz_mod(57, 163), fmpz_mod(156, 163)]
        """
        cdef fmpz_mod f

        if not isinstance(vals, (list, tuple)):
            raise ValueError("Input must be a list of points")
        
        n = len(vals)
        xs = _fmpz_vec_init(n)
        for i in range(n):
            check = self.ctx.mod.set_any_as_fmpz_mod(&xs[i], vals[i])
            if check is NotImplemented:
                _fmpz_vec_clear(xs, n)
                raise ValueError(f"Unable to cast {vals[i]} to an `fmpz_mod`")
        
        # Call for multipoint eval, iterative horner will be used
        # for small arrays (len < 32) and a fast eval for larger ones
        # using a subproduct tree
        ys = _fmpz_vec_init(n)
        fmpz_mod_poly_evaluate_fmpz_vec(ys, self.val, xs, n, self.ctx.mod.val)

        evaluations = []
        for i in range(n):
            f = fmpz_mod.__new__(fmpz_mod)
            f.ctx = self.ctx.mod
            fmpz_mod_set_fmpz(f.val, &ys[i], self.ctx.mod.val)
            evaluations.append(f)

        _fmpz_vec_clear(xs, n)
        _fmpz_vec_clear(ys, n)

        return evaluations

    def compose(self, input):
        """
        TODO
        """
        cdef fmpz_mod_poly res
        val = self.ctx.any_as_fmpz_mod_poly(input)
        if val is NotImplemented:
            raise TypeError(f"Cannot compose the polynomial with input: {input}")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_compose(res.val, self.val, (<fmpz_mod_poly>val).val, self.ctx.mod.val) 
        return res    

    cpdef long length(self):
        """
        Return the length of the polynomial

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.length()
            3
            
        """
        return fmpz_mod_poly_length(self.val, self.ctx.mod.val)

    cpdef long degree(self):
        """
        Return the degree of the polynomial

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.degree()
            2

        """
        return fmpz_mod_poly_degree(self.val, self.ctx.mod.val)

    def is_zero(self):
        """
        Return ``True`` if the polynomial is the zero polynomial
        and ``False`` otherwise

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R(0)
            >>> f.is_zero()
            True
        """
        return 0 != fmpz_mod_poly_is_zero(self.val, self.ctx.mod.val)
    
    def is_one(self):
        """
        Return ``True`` if the polynomial is the zero polynomial
        and `Fal`se` otherwise

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R(1)
            >>> f.is_one()
            True
        """
        return 0 != fmpz_mod_poly_is_one(self.val, self.ctx.mod.val)
    
    def is_gen(self):
        """
        Return ``True`` if the polynomial is the zero polynomial
        and ``False`` otherwise

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([0,1])
            >>> f.is_gen()
            True
        """
        return 0 != fmpz_mod_poly_is_gen(self.val, self.ctx.mod.val)

    def is_constant(self):
        """
        Return ``True`` if this is a constant polynomial.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> x.is_constant()
            False
            >>> R(123).is_constant()
            True
        """
        return self.degree() <= 0

    def constant_coefficient(self):
        """
        Return the constant coefficient of this polynomial.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.constant_coefficient()
            fmpz_mod(1, 163)
        """
        return self[0]

    def leading_coefficient(self):
        """
        Return the leading coefficient of this polynomial.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.leading_coefficient()
            fmpz_mod(3, 163)
        """
        return self[self.degree()]

    def reverse(self, degree=None):
        """
        Return a polynomial with the coefficients of this polynomial
        reversed.

        If ``degree`` is not None, the output polynomial will be zero-padded
        or truncated before being reversed. NOTE: degree must be non-negative.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3,4,5])
            >>> f.reverse()
            x^4 + 2*x^3 + 3*x^2 + 4*x + 5
            >>> f.reverse(degree=1)
            x + 2
            >>> f.reverse(degree=100)
            x^100 + 2*x^99 + 3*x^98 + 4*x^97 + 5*x^96
        """
        cdef fmpz_mod_poly res
        cdef slong d
        
        if degree is not None:
            d = degree
            if d != degree or d < 0:
                raise ValueError(f"degree argument must be a non-negative integer, got {degree}")
        else:
            d = fmpz_mod_poly_degree(self.val, self.ctx.mod.val)

        length = d + 1

        res =  fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_reverse(res.val, self.val, length, self.ctx.mod.val)
        return res

    def truncate(self, slong n):
        r"""
        Notionally truncate the polynomial to have length ``n``. If 
        ``n`` is larger than the length of the input, then ``self`` is
        returned. If ``n`` is not positive, then the zero polynomial 
        is returned.

        Effectively returns this polynomial :math:`\mod x^n`.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.truncate(3) == f
            True
            >>> f.truncate(2)
            2*x + 1
            >>> f.truncate(1)
            1
            >>> f.truncate(0)
            0
            >>> f.truncate(-1)
            0

        """
        cdef fmpz_mod_poly res

        length = fmpz_mod_poly_degree(self.val, self.ctx.mod.val)
        res =  fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)

        if n <= 0: # return zero
            return res
        elif n > length: # do nothing
            fmpz_mod_poly_set(
                res.val, self.val, self.ctx.mod.val
            )
        else:
            fmpz_mod_poly_set_trunc(
                res.val, self.val, n, self.ctx.mod.val
            )
        return res

    def is_monic(self):
        """
        Return whether this polynomial is monic.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = x**2 + 5*x + 3
            >>> f.is_monic()
            True
            >>> f = 5*x**2 + x + 3
            >>> f.is_monic()
            False
        """
        return self.leading_coefficient().is_one()

    def monic(self, check=True):
        """
        Return this polynomial divided by its leading coefficient.

        If ``check`` is True, raises ValueError if the leading coefficient 
        is not invertible modulo N. If ``check`` is False and the leading 
        coefficient is not invertible, the output is undefined.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.monic()
            x^2 + 55*x + 109
        """
        cdef fmpz_mod_poly res
        cdef fmpz_t f

        res =  fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        if not check:
            fmpz_mod_poly_make_monic(
                res.val, self.val, self.ctx.mod.val
            )
        else:
            fmpz_init(f) 
            fmpz_mod_poly_make_monic_f(
                f, res.val, self.val, self.ctx.mod.val
            )
            if not fmpz_is_one(f):
                fmpz_clear(f)
                raise ValueError(f"Leading coefficient is not invertible")
        return res

    def is_irreducible(self):
        """
        Return whether this polynomial is irreducible.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = x**2 + 5*x + 3
            >>> f.is_irreducible()
            True
            >>> f = x**2 + x + 3
            >>> f.is_irreducible()
            False
        """
        return 1 == fmpz_mod_poly_is_irreducible(self.val, self.ctx.mod.val)

    def is_squarefree(self):
        """
        Return whether this polynomial is squarefree.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = (x + 1)**2 * (x + 3)
            >>> f.is_squarefree()
            False
            >>> f = (x + 1) * (x + 3)
            >>> f.is_squarefree()
            True

        """
        return 1 == fmpz_mod_poly_is_squarefree(self.val, self.ctx.mod.val)

    def square(self):
        """
        Returns the square of ``self``

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.square()
            9*x^4 + 12*x^3 + 10*x^2 + 4*x + 1
        """
        cdef fmpz_mod_poly res

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_sqr(
            res.val, self.val, self.ctx.mod.val
        )
        return res

    def mulmod(self, other, modulus):
        """
        Computes the multiplication of ``self`` with ``other``
        modulo the polynomial ``modulus``

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = 30*x**6 + 104*x**5 + 76*x**4 + 33*x**3 + 70*x**2 + 44*x + 65
            >>> g = 43*x**6 + 91*x**5 + 77*x**4 + 113*x**3 + 71*x**2 + 132*x + 60
            >>> mod = x**4 + 93*x**3 + 78*x**2 + 72*x + 149
            >>> 
            >>> f.mulmod(g, mod)
            106*x^3 + 44*x^2 + 53*x + 77
        """
        cdef fmpz_mod_poly res
        
        other = self.ctx.any_as_fmpz_mod_poly(other)
        if other is NotImplemented:
            raise TypeError(f"Cannot interpret {other} as a polynomial")

        modulus = self.ctx.any_as_fmpz_mod_poly(modulus)
        if modulus is NotImplemented:
            raise TypeError(f"Cannot interpret {modulus} as a polynomial")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)

        fmpz_mod_poly_mulmod(
            res.val, self.val, (<fmpz_mod_poly>other).val, (<fmpz_mod_poly>modulus).val, res.ctx.mod.val
        )
        return res

    def powmod(self, e, modulus):
        """
        Returns ``self`` raised to the power ``e`` modulo ``modulus``:
        :math:`f^e \mod g`

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = 30*x**6 + 104*x**5 + 76*x**4 + 33*x**3 + 70*x**2 + 44*x + 65
            >>> g = 43*x**6 + 91*x**5 + 77*x**4 + 113*x**3 + 71*x**2 + 132*x + 60
            >>> mod = x**4 + 93*x**3 + 78*x**2 + 72*x + 149
            >>> 
            >>> f.powmod(123, mod) 
            3*x^3 + 25*x^2 + 115*x + 161
        """
        cdef fmpz_mod_poly res

        modulus = self.ctx.any_as_fmpz_mod_poly(modulus)
        if modulus is NotImplemented:
            raise TypeError(f"Cannot interpret {modulus} as a polynomial")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_powmod_ui_binexp(
            res.val, self.val, <ulong>e, (<fmpz_mod_poly>modulus).val, res.ctx.mod.val
        )
        return res

    def divmod(self, other):
        """
        Return `Q`, `R` such that for ``self`` = `F` and ``other`` = `G`,
        `F = Q*G + R`

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([123, 129, 63, 14, 51, 76, 133])
            >>> g = R([106, 134, 32, 41, 158, 115, 115])
            >>> f.divmod(g)
            (21, 106*x^5 + 156*x^4 + 131*x^3 + 43*x^2 + 86*x + 16)
        """
        cdef fmpz_t f
        cdef fmpz_mod_poly Q, R

        other = self.ctx.any_as_fmpz_mod_poly(other)
        if other is NotImplemented:
            raise TypeError(f"Cannot interpret {other} as a polynomial")

        if other == 0:
            raise ZeroDivisionError(f"Cannot compute divmod as {other =}")

        Q = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        R = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)

        fmpz_init(f)
        fmpz_mod_poly_divrem_f(
            f, Q.val, R.val, self.val, (<fmpz_mod_poly>other).val, self.ctx.mod.val
        )
        if not fmpz_is_one(f):
            fmpz_clear(f)
            raise ValueError(
                f"Cannot compute divmod of {self} with {other}"
            )

        return Q, R

    def __divmod__(self, other):
        return self.divmod(other)

    def __rdivmod__(self, other):
        other = self.ctx.any_as_fmpz_mod_poly(other)
        if other is NotImplemented:
            return other
        return other.divmod(self)

    def gcd(self, other):
        """
        Return the greatest common divisor of self and other.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = x*(x + 1)
            >>> f.gcd(x+1)
            x + 1
            >>> f.gcd(x*x)
            x

        """
        cdef fmpz_mod_poly res

        if not self.ctx.is_prime():
            raise NotImplementedError("gcd algorithm assumes that the modulus is prime")
                 
        other = self.ctx.any_as_fmpz_mod_poly(other)
        if other is NotImplemented:
            raise TypeError(f"Cannot interpret {other} as a polynomial")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_gcd(
            res.val, self.val, (<fmpz_mod_poly>other).val, self.ctx.mod.val
        )
        return res

    def xgcd(self, other):
        r"""
        Computes the extended gcd of self and other: (`G`, `S`, `T`)
        where `G` is the ``gcd(self, other)`` and `S`, `T` are such that:

        :math:`G = \textrm{self}*S +  \textrm{other}*T`

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([143, 19, 37, 138, 102, 127, 95])
            >>> g = R([139, 9, 35, 154, 87, 120, 24])
            >>> f.xgcd(g)
            (x^3 + 128*x^2 + 123*x + 91, 17*x^2 + 49*x + 104, 21*x^2 + 5*x + 25)

        """
        cdef fmpz_mod_poly G, S, T
        cdef fmpz_t f

        other = self.ctx.any_as_fmpz_mod_poly(other)
        if other is NotImplemented:
            raise TypeError(f"Cannot interpret {other} as a polynomial")

        G = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        S = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        T = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)

        fmpz_init(f)
        fmpz_mod_poly_xgcd_f(
            f, G.val, S.val, T.val, self.val, (<fmpz_mod_poly>other).val, self.ctx.mod.val
        )
        if not fmpz_is_one(f):
            fmpz_clear(f)
            raise ValueError(
                f"Cannot compute xgcd of {self} with {other}"
            )
        return (G, S, T)

    def derivative(self):
        """
        The formal derivative of this polynomial

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = 111*x**4 + 58*x**3 + 98*x**2 + 117*x + 7
            >>> f.derivative()
            118*x^3 + 11*x^2 + 33*x + 117

        """
        cdef fmpz_mod_poly res
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_derivative(
            res.val, self.val, self.ctx.mod.val
        )
        return res

    def integral(self):
        """
        The formal integral of this polynomial. The constant term
        from boundary conditions is picked to be zero.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = 118*x**3 + 11*x**2 + 33*x + 117
            >>> f.integral()
            111*x^4 + 58*x^3 + 98*x^2 + 117*x

        """ 
        new_coeffs = [0] + [c/n for n, c in enumerate(self.coeffs(), 1)]
        return self.ctx(new_coeffs)

    def discriminant(self):
        """
        Return the discriminant of ``self``.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = 6*x**4 + 7*x**3 + 7*x**2 + 8*x + 6
            >>> f.discriminant()
            fmpz_mod(50, 163)

        """
        cdef fmpz_mod res

        if not self.ctx.is_prime():
            raise NotImplementedError("discriminant algorithm assumes that the base is a field")

        res = fmpz_mod.__new__(fmpz_mod)
        res.ctx = self.ctx.mod
        fmpz_mod_poly_discriminant(
            res.val, self.val, self.ctx.mod.val
        )
        return res

    def radical(self):
        """
        Return the radical of ``self``, the product of the irreducible
        factors of the polynomial. This is also referred to as the
        square-free part of the polynomial.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = (x + 1)**3 * (x + 2)
            >>> f.radical()
            x^2 + 3*x + 2

        """
        if not self.ctx.is_prime():
            raise NotImplementedError("radical algorithm assumes that the base is a field")

        return self.exact_division(self.gcd(self.derivative()))

    def inverse_mod(self, other):
        """
        Returns the inverse of ``self`` modulo ``other``

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = f = R([123, 129, 63, 14, 51, 76, 133])
            >>> f = R([123, 129, 63, 14, 51, 76, 133])
            >>> g = R([139, 9, 35, 154, 87, 120, 24])
            >>> f.inverse_mod(g)
            41*x^5 + 121*x^4 + 47*x^3 + 41*x^2 + 6*x + 5
        """
        cdef fmpz_mod_poly res 
        cdef fmpz_t f

        other = self.ctx.any_as_fmpz_mod_poly(other)
        if other is NotImplemented:
            raise TypeError(f"Cannot interpret {other} as a polynomial")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        res.ctx = self.ctx
        fmpz_init(f)
        fmpz_mod_poly_invmod_f(
            f, res.val, self.val, (<fmpz_mod_poly>other).val, res.ctx.mod.val
        )
        if not fmpz_is_one(f):
            fmpz_clear(f)
            raise ValueError(
                f"Cannot compute inverse of {self} modulo {other}"
            )
        return res

    def inverse_series_trunc(self, slong n):
        """
        Returns the inverse of ``self`` modulo `x^n`.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([123, 129, 63, 14, 51, 76, 133])
            >>> f.inverse_series_trunc(3)
            159*x^2 + 151*x + 110
            >>> f.inverse_series_trunc(4)
            23*x^3 + 159*x^2 + 151*x + 110
            >>> f.inverse_series_trunc(5)
            45*x^4 + 23*x^3 + 159*x^2 + 151*x + 110
        """
        cdef fmpz_t f
        cdef fmpz_mod_poly res 

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_init(f)
        fmpz_mod_poly_inv_series_f(
            f, res.val, self.val, n, res.ctx.mod.val
        )
        if not fmpz_is_one(f):
            fmpz_clear(f)
            raise ValueError(
                f"Cannot compute inverse series of {self} modulo x^{n}"
            )
        return res

    def resultant(self, other):
        """
        Returns the resultant of ``self`` with ``other``.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3,4,5])
            >>> g = R([9,8,7])
            >>> f.resultant(g)
            fmpz_mod(57, 163)

        """
        cdef fmpz_mod res 

        other = self.ctx.any_as_fmpz_mod_poly(other)
        if other is NotImplemented:
            raise TypeError(f"Cannot interpret {other} as a polynomial")

        res = fmpz_mod.__new__(fmpz_mod)
        res.ctx = self.ctx.mod
        fmpz_mod_poly_resultant(
            res.val, self.val, (<fmpz_mod_poly>other).val, self.ctx.mod.val
        )
        return res

    def sqrt(self):
        """
        If ``self`` is a perfect square, compute the square root

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,1])
            >>> (f*f).sqrt()
            x + 1

        """
        cdef fmpz_mod_poly res
        cdef int check

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        check = fmpz_mod_poly_sqrt(
            res.val, self.val, res.ctx.mod.val
        )
        if check != 1:
            raise ValueError(
                f"Cannot compute square-root {self}"
            )
        return res

    def sqrt_trunc(self, slong n):
        """
        Returns the squareroot of ``self`` modulo `x^n`.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = R([1,2,3])
            >>> h = f.sqrt_trunc(5)
            >>> h
            82*x^4 + 162*x^3 + x^2 + x + 1
            >>> h.mulmod(h, x**5) == f
            True

        """
        cdef fmpz_mod_poly res

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_sqrt_series(
            res.val, self.val, n, res.ctx.mod.val
        )
        return res

    def inverse_sqrt_trunc(self, slong n):
        """
        Returns the inverse squareroot of ``self`` modulo `x^n`.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> h = f.inverse_sqrt_trunc(5)
            >>> h
            78*x^4 + 2*x^3 + 162*x + 1
            >>> (h*h).inverse_series_trunc(5) == f
            True
        """
        cdef fmpz_mod_poly res

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_invsqrt_series(
            res.val, self.val, n, res.ctx.mod.val
        )
        return res

    def inflate(self, ulong n):
        r"""
        Returns the result of the polynomial `f = \textrm{self}` to
        `f(x^n)`

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,2,3])
            >>> f.inflate(10)
            3*x^20 + 2*x^10 + 1

        """
        cdef fmpz_mod_poly res

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_inflate(
            res.val, self.val, n, res.ctx.mod.val
        )
        return res

    def deflate(self, ulong n):
        r"""
        Returns the result of the polynomial `f = \textrm{self}` to
        `f(x^{1/n})`

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,0,2,0,3])
            >>> f
            3*x^4 + 2*x^2 + 1
            >>> f.deflate(2)
            3*x^2 + 2*x + 1

        """
        cdef fmpz_mod_poly res

        n_max = fmpz_mod_poly_deflation(
            self.val, self.ctx.mod.val
        )
        if n > n_max:
            raise ValueError(f"Cannot deflate with {n = }, maximum allowed value is {n_max = }")

        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_deflate(
            res.val, self.val, n, res.ctx.mod.val
        )
        return res

    def deflation(self):
        r"""
        Returns the tuple (g, n) where for `f = \textrm{self}` to
        `g = f(x^{1/n})` where n is the largest allowed integer

            >>> R = fmpz_mod_poly_ctx(163)
            >>> f = R([1,0,2,0,3])
            >>> f
            3*x^4 + 2*x^2 + 1
            >>> f.deflate(2)
            3*x^2 + 2*x + 1

        """
        cdef fmpz_mod_poly res
        if self.is_zero():
            return self, 1
        n = fmpz_mod_poly_deflation(
            self.val, self.ctx.mod.val
        )
        res = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
        fmpz_mod_poly_deflate(
            res.val, self.val, n, res.ctx.mod.val
        )
        return res, int(n)

    def factor_squarefree(self):
        """
        Factors self into irreducible, squarefree factors, returning a tuple
        ``(c, factors)`` where `c` is the content of the coefficients and
        factors is a list of ``(poly, exp)`` pairs.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = (x + 1) * (x + 2)
            >>> f.factor_squarefree()
            (fmpz_mod(1, 163), [(x^2 + 3*x + 2, 1)])
            >>> f = (x + 1) * (x + 2)**5
            >>> f.factor_squarefree()
            (fmpz_mod(1, 163), [(x + 1, 1), (x + 2, 5)])
        """
        cdef fmpz_mod_poly_factor_t fac
        cdef int i

        if not self.ctx.is_prime():
            raise NotImplementedError("factor_squarefree algorithm assumes that the modulus is prime")

        fmpz_mod_poly_factor_init(fac, self.ctx.mod.val)
        fmpz_mod_poly_factor_squarefree(fac, self.val, self.ctx.mod.val)

        res = [0] * fac.num

        cdef fmpz_mod_poly u
        for i in range(fac.num):
            u = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
            fmpz_mod_poly_set(u.val, &fac.poly[i], self.ctx.mod.val)
            exp = fac.exp[i]
            res[i] = (u, exp)
        return self.leading_coefficient(), res

    def factor(self, algorithm=None):
        """
        Factors self into irreducible factors, returning a tuple
        ``(c, factors)`` where `c` is the content of the coefficients and
        factors is a list of ``(poly, exp)`` pairs.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = 6*x**4 + 7*x**3 + 7*x**2 + 8*x + 6
            >>> f.factor()
            (fmpz_mod(6, 163), [(x^4 + 137*x^3 + 137*x^2 + 110*x + 1, 1)])
            >>> f = (x + 1)**3 * (x + 2)
            >>> f.factor()
            (fmpz_mod(1, 163), [(x + 1, 3), (x + 2, 1)])
        """
        cdef fmpz_mod_poly_factor_t fac
        cdef int i

        if not self.ctx.is_prime():
            raise NotImplementedError("factor algorithm assumes that the modulus is prime")
                 
        fmpz_mod_poly_factor_init(fac, self.ctx.mod.val)
        if algorithm == None:
            fmpz_mod_poly_factor(fac, self.val, self.ctx.mod.val)
        elif algorithm == "cantor_zassenhaus":
            fmpz_mod_poly_factor_cantor_zassenhaus(fac, self.val, self.ctx.mod.val)
        elif algorithm == "kaltofen_shoup":
            fmpz_mod_poly_factor_kaltofen_shoup(fac, self.val, self.ctx.mod.val)
        elif algorithm == "berlekamp":
            fmpz_mod_poly_factor_berlekamp(fac, self.val, self.ctx.mod.val)
        else:
            raise ValueError("unknown algorithm")
        
        res = [0] * fac.num

        cdef fmpz_mod_poly u
        for i in range(fac.num):
            u = fmpz_mod_poly.__new__(fmpz_mod_poly, None, self.ctx)
            fmpz_mod_poly_set(u.val, &fac.poly[i], self.ctx.mod.val)
            exp = fac.exp[i]
            res[i] = (u, exp)
        return self.leading_coefficient(), res

    def roots(self, multiplicities=True):
        r"""
        Return the roots of the polynomial in :math:`(\mathbb{Z}/N\mathbb{Z})^*`
        Requires that the modulus `N` is prime.

            >>> R = fmpz_mod_poly_ctx(163)
            >>> x = R.gen()
            >>> f = (x - 1) * (x - 2)**3 * (x - 3)**5
            >>> f.roots()
            [(fmpz_mod(1, 163), 1), (fmpz_mod(2, 163), 3), (fmpz_mod(3, 163), 5)]
            >>> f.roots(multiplicities=False)
            [fmpz_mod(1, 163), fmpz_mod(2, 163), fmpz_mod(3, 163)]
        """
        cdef fmpz_mod_poly_factor_t fac
        cdef int i, with_multiplicity

        if multiplicities:
            with_multiplicity = 1

        if not self.ctx.is_prime():
            raise NotImplementedError("factor algorithm assumes that the modulus is prime")
                 
        fmpz_mod_poly_factor_init(fac, self.ctx.mod.val)
        fmpz_mod_poly_roots(fac, self.val, with_multiplicity, self.ctx.mod.val)
        res = [0] * fac.num

        cdef fmpz_mod root
        for i in range(fac.num):
            root = fmpz_mod.__new__(fmpz_mod)
            root.ctx = self.ctx.mod
            fmpz_mod_poly_get_coeff_fmpz(
                root.val, &fac.poly[i], 0, self.ctx.mod.val
            )
            fmpz_mod_neg(
                root.val, root.val, root.ctx.val
            )
            if multiplicities:
                mul = fac.exp[i]
                res[i] = (root, mul)
            else:
                res[i] = root
        return res

    def complex_roots(self):
        """
        This method is not implemented for polynomials in
        :math:`(\mathbb{Z}/N\mathbb{Z})[X]`
        """
        raise DomainError("Cannot compute compex roots for polynomials over integers modulo N")
