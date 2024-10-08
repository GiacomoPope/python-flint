from flint.flintlib.types.flint cimport flint_bitcnt_t, flint_rand_t, fmpz_struct, fmpz_t, mp_bitcnt_t, mp_limb_t, mp_ptr, mp_srcptr, slong, ulong
from flint.flintlib.types.fmpq cimport fmpq_struct, fmpq_t
from flint.flintlib.types.fmpz cimport fmpz_poly_factor_t, fmpz_poly_t, fmpz_preinvn_t
from flint.flintlib.types.nmod cimport nmod_poly_factor_t, nmod_poly_t

# unknown type FILE
# unknown type fmpz_poly_mul_precache_t
# unknown type fmpz_poly_powers_precomp_t


cdef extern from "flint/fmpz_poly.h":
    void fmpz_poly_init(fmpz_poly_t poly)
    void fmpz_poly_init2(fmpz_poly_t poly, slong alloc)
    void fmpz_poly_realloc(fmpz_poly_t poly, slong alloc)
    void fmpz_poly_fit_length(fmpz_poly_t poly, slong len)
    void fmpz_poly_clear(fmpz_poly_t poly)
    void _fmpz_poly_normalise(fmpz_poly_t poly)
    void _fmpz_poly_set_length(fmpz_poly_t poly, slong newlen)
    void fmpz_poly_attach_truncate(fmpz_poly_t trunc, const fmpz_poly_t poly, slong n)
    void fmpz_poly_attach_shift(fmpz_poly_t trunc, const fmpz_poly_t poly, slong n)
    slong fmpz_poly_length(const fmpz_poly_t poly)
    slong fmpz_poly_degree(const fmpz_poly_t poly)
    void fmpz_poly_set(fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void fmpz_poly_set_si(fmpz_poly_t poly, slong c)
    void fmpz_poly_set_ui(fmpz_poly_t poly, ulong c)
    void fmpz_poly_set_fmpz(fmpz_poly_t poly, const fmpz_t c)
    int _fmpz_poly_set_str(fmpz_struct * poly, const char * str)
    int fmpz_poly_set_str(fmpz_poly_t poly, const char * str)
    char * _fmpz_poly_get_str(const fmpz_struct * poly, slong len)
    char * fmpz_poly_get_str(const fmpz_poly_t poly)
    char * _fmpz_poly_get_str_pretty(const fmpz_struct * poly, slong len, const char * x)
    char * fmpz_poly_get_str_pretty(const fmpz_poly_t poly, const char * x)
    void fmpz_poly_zero(fmpz_poly_t poly)
    void fmpz_poly_one(fmpz_poly_t poly)
    void fmpz_poly_zero_coeffs(fmpz_poly_t poly, slong i, slong j)
    void fmpz_poly_swap(fmpz_poly_t poly1, fmpz_poly_t poly2)
    void _fmpz_poly_reverse(fmpz_struct * res, const fmpz_struct * poly, slong len, slong n)
    void fmpz_poly_reverse(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    void fmpz_poly_truncate(fmpz_poly_t poly, slong newlen)
    void fmpz_poly_set_trunc(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    void fmpz_poly_randtest(fmpz_poly_t f, flint_rand_t state, slong len, flint_bitcnt_t bits)
    void fmpz_poly_randtest_unsigned(fmpz_poly_t f, flint_rand_t state, slong len, flint_bitcnt_t bits)
    void fmpz_poly_randtest_not_zero(fmpz_poly_t f, flint_rand_t state, slong len, flint_bitcnt_t bits)
    void fmpz_poly_randtest_no_real_root(fmpz_poly_t p, flint_rand_t state, slong len, flint_bitcnt_t bits)
    void fmpz_poly_randtest_irreducible1(fmpz_poly_t pol, flint_rand_t state, slong len, mp_bitcnt_t bits)
    void fmpz_poly_randtest_irreducible2(fmpz_poly_t pol, flint_rand_t state, slong len, mp_bitcnt_t bits)
    void fmpz_poly_randtest_irreducible(fmpz_poly_t pol, flint_rand_t state, slong len, mp_bitcnt_t bits)
    void fmpz_poly_get_coeff_fmpz(fmpz_t x, const fmpz_poly_t poly, slong n)
    slong fmpz_poly_get_coeff_si(const fmpz_poly_t poly, slong n)
    ulong fmpz_poly_get_coeff_ui(const fmpz_poly_t poly, slong n)
    fmpz_struct * fmpz_poly_get_coeff_ptr(const fmpz_poly_t poly, slong n)
    fmpz_struct * fmpz_poly_lead(const fmpz_poly_t poly)
    void fmpz_poly_set_coeff_fmpz(fmpz_poly_t poly, slong n, const fmpz_t x)
    void fmpz_poly_set_coeff_si(fmpz_poly_t poly, slong n, slong x)
    void fmpz_poly_set_coeff_ui(fmpz_poly_t poly, slong n, ulong x)
    int fmpz_poly_equal(const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    int fmpz_poly_equal_trunc(const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    int fmpz_poly_is_zero(const fmpz_poly_t poly)
    int fmpz_poly_is_one(const fmpz_poly_t poly)
    int fmpz_poly_is_unit(const fmpz_poly_t poly)
    int fmpz_poly_is_gen(const fmpz_poly_t poly)
    void _fmpz_poly_add(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_add(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void fmpz_poly_add_series(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void _fmpz_poly_sub(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_sub(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void fmpz_poly_sub_series(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void fmpz_poly_neg(fmpz_poly_t res, const fmpz_poly_t poly)
    void fmpz_poly_scalar_abs(fmpz_poly_t res, const fmpz_poly_t poly)
    void fmpz_poly_scalar_mul_fmpz(fmpz_poly_t poly1, const fmpz_poly_t poly2, const fmpz_t x)
    void fmpz_poly_scalar_mul_si(fmpz_poly_t poly1, const fmpz_poly_t poly2, slong x)
    void fmpz_poly_scalar_mul_ui(fmpz_poly_t poly1, const fmpz_poly_t poly2, ulong x)
    void fmpz_poly_scalar_mul_2exp(fmpz_poly_t poly1, const fmpz_poly_t poly2, ulong exp)
    void fmpz_poly_scalar_addmul_si(fmpz_poly_t poly1, const fmpz_poly_t poly2, slong x)
    void fmpz_poly_scalar_addmul_ui(fmpz_poly_t poly1, const fmpz_poly_t poly2, ulong x)
    void fmpz_poly_scalar_addmul_fmpz(fmpz_poly_t poly1, const fmpz_poly_t poly2, const fmpz_t x)
    void fmpz_poly_scalar_submul_fmpz(fmpz_poly_t poly1, const fmpz_poly_t poly2, const fmpz_t x)
    void fmpz_poly_scalar_fdiv_fmpz(fmpz_poly_t poly1, const fmpz_poly_t poly2, const fmpz_t x)
    void fmpz_poly_scalar_fdiv_si(fmpz_poly_t poly1, const fmpz_poly_t poly2, slong x)
    void fmpz_poly_scalar_fdiv_ui(fmpz_poly_t poly1, const fmpz_poly_t poly2, ulong x)
    void fmpz_poly_scalar_fdiv_2exp(fmpz_poly_t poly1, const fmpz_poly_t poly2, ulong x)
    void fmpz_poly_scalar_tdiv_fmpz(fmpz_poly_t poly1, const fmpz_poly_t poly2, const fmpz_t x)
    void fmpz_poly_scalar_tdiv_si(fmpz_poly_t poly1, const fmpz_poly_t poly2, slong x)
    void fmpz_poly_scalar_tdiv_ui(fmpz_poly_t poly1, const fmpz_poly_t poly2, ulong x)
    void fmpz_poly_scalar_tdiv_2exp(fmpz_poly_t poly1, const fmpz_poly_t poly2, ulong x)
    void fmpz_poly_scalar_divexact_fmpz(fmpz_poly_t poly1, const fmpz_poly_t poly2, const fmpz_t x)
    void fmpz_poly_scalar_divexact_si(fmpz_poly_t poly1, const fmpz_poly_t poly2, slong x)
    void fmpz_poly_scalar_divexact_ui(fmpz_poly_t poly1, const fmpz_poly_t poly2, ulong x)
    void fmpz_poly_scalar_mod_fmpz(fmpz_poly_t poly1, const fmpz_poly_t poly2, const fmpz_t p)
    void fmpz_poly_scalar_smod_fmpz(fmpz_poly_t poly1, const fmpz_poly_t poly2, const fmpz_t p)
    slong _fmpz_poly_remove_content_2exp(fmpz_struct * pol, slong len)
    void _fmpz_poly_scale_2exp(fmpz_struct * pol, slong len, slong k)
    void _fmpz_poly_bit_pack(mp_ptr arr, const fmpz_struct * poly, slong len, flint_bitcnt_t bit_size, int negate)
    int _fmpz_poly_bit_unpack(fmpz_struct * poly, slong len, mp_srcptr arr, flint_bitcnt_t bit_size, int negate)
    void _fmpz_poly_bit_unpack_unsigned(fmpz_struct * poly, slong len, mp_srcptr arr, flint_bitcnt_t bit_size)
    void fmpz_poly_bit_pack(fmpz_t f, const fmpz_poly_t poly, flint_bitcnt_t bit_size)
    void fmpz_poly_bit_unpack(fmpz_poly_t poly, const fmpz_t f, flint_bitcnt_t bit_size)
    void fmpz_poly_bit_unpack_unsigned(fmpz_poly_t poly, const fmpz_t f, flint_bitcnt_t bit_size)
    void _fmpz_poly_mul_classical(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_mul_classical(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_mullow_classical(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2, slong n)
    void fmpz_poly_mullow_classical(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void _fmpz_poly_mulhigh_classical(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2, slong start)
    void fmpz_poly_mulhigh_classical(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong start)
    void _fmpz_poly_mulmid_classical(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_mulmid_classical(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_mul_karatsuba(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_mul_karatsuba(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_mullow_karatsuba_n(fmpz_struct * res, const fmpz_struct * poly1, const fmpz_struct * poly2, slong n)
    void fmpz_poly_mullow_karatsuba_n(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void _fmpz_poly_mulhigh_karatsuba_n(fmpz_struct * res, const fmpz_struct * poly1, const fmpz_struct * poly2, slong len)
    void fmpz_poly_mulhigh_karatsuba_n(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong len)
    void _fmpz_poly_mul_KS(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_mul_KS(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_mullow_KS(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2, slong n)
    void fmpz_poly_mullow_KS(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void _fmpz_poly_mul_SS(fmpz_struct * output, const fmpz_struct * input1, slong length1, const fmpz_struct * input2, slong length2)
    void fmpz_poly_mul_SS(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_mullow_SS(fmpz_struct * output, const fmpz_struct * input1, slong length1, const fmpz_struct * input2, slong length2, slong n)
    void fmpz_poly_mullow_SS(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void _fmpz_poly_mul(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_mul(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_mullow(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2, slong n)
    void fmpz_poly_mullow(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void fmpz_poly_mulhigh_n(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void _fmpz_poly_mulhigh(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2, slong start)
    # void fmpz_poly_mul_SS_precache_init(fmpz_poly_mul_precache_t pre, slong len1, slong bits1, const fmpz_poly_t poly2)
    # void fmpz_poly_mul_precache_clear(fmpz_poly_mul_precache_t pre)
    # void _fmpz_poly_mullow_SS_precache(fmpz_struct * output, const fmpz_struct * input1, slong len1, fmpz_poly_mul_precache_t pre, slong trunc)
    # void fmpz_poly_mullow_SS_precache(fmpz_poly_t res, const fmpz_poly_t poly1, fmpz_poly_mul_precache_t pre, slong n)
    # void fmpz_poly_mul_SS_precache(fmpz_poly_t res, const fmpz_poly_t poly1, fmpz_poly_mul_precache_t pre)
    void _fmpz_poly_sqr_KS(fmpz_struct * rop, const fmpz_struct * op, slong len)
    void fmpz_poly_sqr_KS(fmpz_poly_t rop, const fmpz_poly_t op)
    void _fmpz_poly_sqr_karatsuba(fmpz_struct * rop, const fmpz_struct * op, slong len)
    void fmpz_poly_sqr_karatsuba(fmpz_poly_t rop, const fmpz_poly_t op)
    void _fmpz_poly_sqr_classical(fmpz_struct * rop, const fmpz_struct * op, slong len)
    void fmpz_poly_sqr_classical(fmpz_poly_t rop, const fmpz_poly_t op)
    void _fmpz_poly_sqr(fmpz_struct * rop, const fmpz_struct * op, slong len)
    void fmpz_poly_sqr(fmpz_poly_t rop, const fmpz_poly_t op)
    void _fmpz_poly_sqrlow_KS(fmpz_struct * res, const fmpz_struct * poly, slong len, slong n)
    void fmpz_poly_sqrlow_KS(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    void _fmpz_poly_sqrlow_karatsuba_n(fmpz_struct * res, const fmpz_struct * poly, slong n)
    void fmpz_poly_sqrlow_karatsuba_n(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    void _fmpz_poly_sqrlow_classical(fmpz_struct * res, const fmpz_struct * poly, slong len, slong n)
    void fmpz_poly_sqrlow_classical(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    void _fmpz_poly_sqrlow(fmpz_struct * res, const fmpz_struct * poly, slong len, slong n)
    void fmpz_poly_sqrlow(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    void _fmpz_poly_pow_multinomial(fmpz_struct * res, const fmpz_struct * poly, slong len, ulong e)
    void fmpz_poly_pow_multinomial(fmpz_poly_t res, const fmpz_poly_t poly, ulong e)
    void _fmpz_poly_pow_binomial(fmpz_struct * res, const fmpz_struct * poly, ulong e)
    void fmpz_poly_pow_binomial(fmpz_poly_t res, const fmpz_poly_t poly, ulong e)
    void _fmpz_poly_pow_addchains(fmpz_struct * res, const fmpz_struct * poly, slong len, const int * a, int n)
    void fmpz_poly_pow_addchains(fmpz_poly_t res, const fmpz_poly_t poly, ulong e)
    void _fmpz_poly_pow_binexp(fmpz_struct * res, const fmpz_struct * poly, slong len, ulong e)
    void fmpz_poly_pow_binexp(fmpz_poly_t res, const fmpz_poly_t poly, ulong e)
    void _fmpz_poly_pow_small(fmpz_struct * res, const fmpz_struct * poly, slong len, ulong e)
    void _fmpz_poly_pow(fmpz_struct * res, const fmpz_struct * poly, slong len, ulong e)
    void fmpz_poly_pow(fmpz_poly_t res, const fmpz_poly_t poly, ulong e)
    void _fmpz_poly_pow_trunc(fmpz_struct * res, const fmpz_struct * poly, ulong e, slong n)
    void fmpz_poly_pow_trunc(fmpz_poly_t res, const fmpz_poly_t poly, ulong e, slong n)
    void _fmpz_poly_shift_left(fmpz_struct * res, const fmpz_struct * poly, slong len, slong n)
    void fmpz_poly_shift_left(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    void _fmpz_poly_shift_right(fmpz_struct * res, const fmpz_struct * poly, slong len, slong n)
    void fmpz_poly_shift_right(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    ulong fmpz_poly_max_limbs(const fmpz_poly_t poly)
    slong fmpz_poly_max_bits(const fmpz_poly_t poly)
    void fmpz_poly_height(fmpz_t height, const fmpz_poly_t poly)
    void _fmpz_poly_2norm(fmpz_t res, const fmpz_struct * poly, slong len)
    void fmpz_poly_2norm(fmpz_t res, const fmpz_poly_t poly)
    mp_limb_t _fmpz_poly_2norm_normalised_bits(const fmpz_struct * poly, slong len)
    void _fmpz_poly_gcd_subresultant(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_gcd_subresultant(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    int _fmpz_poly_gcd_heuristic(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    int fmpz_poly_gcd_heuristic(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_gcd_modular(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_gcd_modular(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_gcd(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_gcd(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_xgcd_modular(fmpz_t r, fmpz_struct * s, fmpz_struct * t, const fmpz_struct * f, slong len1, const fmpz_struct * g, slong len2)
    void fmpz_poly_xgcd_modular(fmpz_t r, fmpz_poly_t s, fmpz_poly_t t, const fmpz_poly_t f, const fmpz_poly_t g)
    void _fmpz_poly_xgcd(fmpz_t r, fmpz_struct * s, fmpz_struct * t, const fmpz_struct * f, slong len1, const fmpz_struct * g, slong len2)
    void fmpz_poly_xgcd(fmpz_t r, fmpz_poly_t s, fmpz_poly_t t, const fmpz_poly_t f, const fmpz_poly_t g)
    void _fmpz_poly_lcm(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_lcm(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_resultant_modular(fmpz_t res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_resultant_modular(fmpz_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void fmpz_poly_resultant_modular_div(fmpz_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, const fmpz_t div, slong nbits)
    void _fmpz_poly_resultant_euclidean(fmpz_t res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_resultant_euclidean(fmpz_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_resultant(fmpz_t res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_resultant(fmpz_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_discriminant(fmpz_t res, const fmpz_struct * poly, slong len)
    void fmpz_poly_discriminant(fmpz_t res, const fmpz_poly_t poly)
    void _fmpz_poly_content(fmpz_t res, const fmpz_struct * poly, slong len)
    void fmpz_poly_content(fmpz_t res, const fmpz_poly_t poly)
    void _fmpz_poly_primitive_part(fmpz_struct * res, const fmpz_struct * poly, slong len)
    void fmpz_poly_primitive_part(fmpz_poly_t res, const fmpz_poly_t poly)
    int _fmpz_poly_is_squarefree(const fmpz_struct * poly, slong len)
    int fmpz_poly_is_squarefree(const fmpz_poly_t poly)
    int _fmpz_poly_divrem_basecase(fmpz_struct * Q, fmpz_struct * R, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, int exact)
    void fmpz_poly_divrem_basecase(fmpz_poly_t Q, fmpz_poly_t R, const fmpz_poly_t A, const fmpz_poly_t B)
    int _fmpz_poly_divrem_divconquer_recursive(fmpz_struct * Q, fmpz_struct * BQ, fmpz_struct * W, const fmpz_struct * A, const fmpz_struct * B, slong lenB, int exact)
    int _fmpz_poly_divrem_divconquer(fmpz_struct * Q, fmpz_struct * R, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, int exact)
    void fmpz_poly_divrem_divconquer(fmpz_poly_t Q, fmpz_poly_t R, const fmpz_poly_t A, const fmpz_poly_t B)
    int _fmpz_poly_divrem(fmpz_struct * Q, fmpz_struct * R, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, int exact)
    void fmpz_poly_divrem(fmpz_poly_t Q, fmpz_poly_t R, const fmpz_poly_t A, const fmpz_poly_t B)
    int _fmpz_poly_div_basecase(fmpz_struct * Q, fmpz_struct * R, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, int exact)
    void fmpz_poly_div_basecase(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_poly_t B)
    int _fmpz_poly_divremlow_divconquer_recursive(fmpz_struct * Q, fmpz_struct * BQ, const fmpz_struct * A, const fmpz_struct * B, slong lenB, int exact)
    int _fmpz_poly_div_divconquer_recursive(fmpz_struct * Q, fmpz_struct * temp, const fmpz_struct * A, const fmpz_struct * B, slong lenB, int exact)
    int _fmpz_poly_div_divconquer(fmpz_struct * Q, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, int exact)
    void fmpz_poly_div_divconquer(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_poly_t B)
    int _fmpz_poly_div(fmpz_struct * Q, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, int exact)
    void fmpz_poly_div(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_rem_basecase(fmpz_struct * R, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB)
    void fmpz_poly_rem_basecase(fmpz_poly_t R, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_rem(fmpz_struct * R, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB)
    void fmpz_poly_rem(fmpz_poly_t R, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_div_root(fmpz_struct * Q, const fmpz_struct * A, slong len, const fmpz_t c)
    void fmpz_poly_div_root(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_t c)
    void _fmpz_poly_divexact(fmpz_struct * Q, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB)
    void fmpz_poly_divexact(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_preinvert(fmpz_struct * B_inv, const fmpz_struct * B, slong n)
    void fmpz_poly_preinvert(fmpz_poly_t B_inv, const fmpz_poly_t B)
    void _fmpz_poly_div_preinv(fmpz_struct * Q, const fmpz_struct * A, slong len1, const fmpz_struct * B, const fmpz_struct * B_inv, slong len2)
    void fmpz_poly_div_preinv(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_poly_t B, const fmpz_poly_t B_inv)
    void _fmpz_poly_divrem_preinv(fmpz_struct * Q, fmpz_struct * A, slong len1, const fmpz_struct * B, const fmpz_struct * B_inv, slong len2)
    void fmpz_poly_divrem_preinv(fmpz_poly_t Q, fmpz_poly_t R, const fmpz_poly_t A, const fmpz_poly_t B, const fmpz_poly_t B_inv)
    fmpz_struct ** _fmpz_poly_powers_precompute(const fmpz_struct * B, slong len)
    # void fmpz_poly_powers_precompute(fmpz_poly_powers_precomp_t pinv, fmpz_poly_t poly)
    void _fmpz_poly_powers_clear(fmpz_struct ** powers, slong len)
    # void fmpz_poly_powers_clear(fmpz_poly_powers_precomp_t pinv)
    void _fmpz_poly_rem_powers_precomp(fmpz_struct * A, slong m, const fmpz_struct * B, slong n, fmpz_struct ** const powers)
    # void fmpz_poly_rem_powers_precomp(fmpz_poly_t R, const fmpz_poly_t A, const fmpz_poly_t B, const fmpz_poly_powers_precomp_t B_inv)
    int _fmpz_poly_divides(fmpz_struct * Q, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB)
    int fmpz_poly_divides(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_poly_t B)
    slong fmpz_poly_remove(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void fmpz_poly_divlow_smodp(fmpz_struct * res, const fmpz_poly_t f, const fmpz_poly_t g, const fmpz_t p, slong n)
    void fmpz_poly_divhigh_smodp(fmpz_struct * res, const fmpz_poly_t f, const fmpz_poly_t g, const fmpz_t p, slong n)
    void _fmpz_poly_inv_series_basecase(fmpz_struct * Qinv, const fmpz_struct * Q, slong Qlen, slong n)
    void fmpz_poly_inv_series_basecase(fmpz_poly_t Qinv, const fmpz_poly_t Q, slong n)
    void _fmpz_poly_inv_series_newton(fmpz_struct * Qinv, const fmpz_struct * Q, slong Qlen, slong n)
    void fmpz_poly_inv_series_newton(fmpz_poly_t Qinv, const fmpz_poly_t Q, slong n)
    void _fmpz_poly_inv_series(fmpz_struct * Qinv, const fmpz_struct * Q, slong Qlen, slong n)
    void fmpz_poly_inv_series(fmpz_poly_t Qinv, const fmpz_poly_t Q, slong n)
    void _fmpz_poly_div_series_basecase(fmpz_struct * Q, const fmpz_struct * A, slong Alen, const fmpz_struct * B, slong Blen, slong n)
    void _fmpz_poly_div_series_divconquer(fmpz_struct * Q, const fmpz_struct * A, slong Alen, const fmpz_struct * B, slong Blen, slong n)
    void _fmpz_poly_div_series(fmpz_struct * Q, const fmpz_struct * A, slong Alen, const fmpz_struct * B, slong Blen, slong n)
    void fmpz_poly_div_series_basecase(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_poly_t B, slong n)
    void fmpz_poly_div_series_divconquer(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_poly_t B, slong n)
    void fmpz_poly_div_series(fmpz_poly_t Q, const fmpz_poly_t A, const fmpz_poly_t B, slong n)
    void _fmpz_poly_pseudo_divrem_basecase(fmpz_struct * Q, fmpz_struct * R, ulong * d, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, const fmpz_preinvn_t inv)
    void fmpz_poly_pseudo_divrem_basecase(fmpz_poly_t Q, fmpz_poly_t R, ulong * d, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_pseudo_divrem_divconquer(fmpz_struct * Q, fmpz_struct * R, ulong * d, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, const fmpz_preinvn_t inv)
    void fmpz_poly_pseudo_divrem_divconquer(fmpz_poly_t Q, fmpz_poly_t R, ulong * d, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_pseudo_divrem_cohen(fmpz_struct * Q, fmpz_struct * R, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB)
    void fmpz_poly_pseudo_divrem_cohen(fmpz_poly_t Q, fmpz_poly_t R, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_pseudo_rem_cohen(fmpz_struct * R, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB)
    void fmpz_poly_pseudo_rem_cohen(fmpz_poly_t R, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_pseudo_divrem(fmpz_struct * Q, fmpz_struct * R, ulong * d, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, const fmpz_preinvn_t inv)
    void fmpz_poly_pseudo_divrem(fmpz_poly_t Q, fmpz_poly_t R, ulong * d, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_pseudo_div(fmpz_struct * Q, ulong * d, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, const fmpz_preinvn_t inv)
    void fmpz_poly_pseudo_div(fmpz_poly_t Q, ulong * d, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_pseudo_rem(fmpz_struct * R, ulong * d, const fmpz_struct * A, slong lenA, const fmpz_struct * B, slong lenB, const fmpz_preinvn_t inv)
    void fmpz_poly_pseudo_rem(fmpz_poly_t R, ulong * d, const fmpz_poly_t A, const fmpz_poly_t B)
    void _fmpz_poly_derivative(fmpz_struct * rpoly, const fmpz_struct * poly, slong len)
    void fmpz_poly_derivative(fmpz_poly_t res, const fmpz_poly_t poly)
    void _fmpz_poly_nth_derivative(fmpz_struct * rpoly, const fmpz_struct * poly, ulong n, slong len)
    void fmpz_poly_nth_derivative(fmpz_poly_t res, const fmpz_poly_t poly, ulong n)
    void _fmpz_poly_evaluate_divconquer_fmpz(fmpz_t res, const fmpz_struct * poly, slong len, const fmpz_t a)
    void fmpz_poly_evaluate_divconquer_fmpz(fmpz_t res, const fmpz_poly_t poly, const fmpz_t a)
    void _fmpz_poly_evaluate_horner_fmpz(fmpz_t res, const fmpz_struct * f, slong len, const fmpz_t a)
    void fmpz_poly_evaluate_horner_fmpz(fmpz_t res, const fmpz_poly_t f, const fmpz_t a)
    void _fmpz_poly_evaluate_fmpz(fmpz_t res, const fmpz_struct * f, slong len, const fmpz_t a)
    void fmpz_poly_evaluate_fmpz(fmpz_t res, const fmpz_poly_t f, const fmpz_t a)
    void _fmpz_poly_evaluate_divconquer_fmpq(fmpz_t rnum, fmpz_t rden, const fmpz_struct * f, slong len, const fmpz_t anum, const fmpz_t aden)
    void fmpz_poly_evaluate_divconquer_fmpq(fmpq_t res, const fmpz_poly_t f, const fmpq_t a)
    void _fmpz_poly_evaluate_horner_fmpq(fmpz_t rnum, fmpz_t rden, const fmpz_struct * f, slong len, const fmpz_t anum, const fmpz_t aden)
    void fmpz_poly_evaluate_horner_fmpq(fmpq_t res, const fmpz_poly_t f, const fmpq_t a)
    void _fmpz_poly_evaluate_fmpq(fmpz_t rnum, fmpz_t rden, const fmpz_struct * f, slong len, const fmpz_t anum, const fmpz_t aden)
    void fmpz_poly_evaluate_fmpq(fmpq_t res, const fmpz_poly_t f, const fmpq_t a)
    mp_limb_t _fmpz_poly_evaluate_mod(const fmpz_struct * poly, slong len, mp_limb_t a, mp_limb_t n, mp_limb_t ninv)
    mp_limb_t fmpz_poly_evaluate_mod(const fmpz_poly_t poly, mp_limb_t a, mp_limb_t n)
    void fmpz_poly_evaluate_fmpz_vec(fmpz_struct * res, const fmpz_poly_t f, const fmpz_struct * a, slong n)
    double _fmpz_poly_evaluate_horner_d(const fmpz_struct * poly, slong n, double d)
    double fmpz_poly_evaluate_horner_d(const fmpz_poly_t poly, double d)
    double _fmpz_poly_evaluate_horner_d_2exp(slong * exp, const fmpz_struct * poly, slong n, double d)
    double fmpz_poly_evaluate_horner_d_2exp(slong * exp, const fmpz_poly_t poly, double d)
    double _fmpz_poly_evaluate_horner_d_2exp2(slong * exp, const fmpz_struct * poly, slong n, double d, slong dexp)
    void _fmpz_poly_monomial_to_newton(fmpz_struct * poly, const fmpz_struct * roots, slong n)
    void _fmpz_poly_newton_to_monomial(fmpz_struct * poly, const fmpz_struct * roots, slong n)
    void fmpz_poly_interpolate_fmpz_vec(fmpz_poly_t poly, const fmpz_struct * xs, const fmpz_struct * ys, slong n)
    void _fmpz_poly_compose_horner(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_compose_horner(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_compose_divconquer(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_compose_divconquer(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void _fmpz_poly_compose(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2)
    void fmpz_poly_compose(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2)
    void fmpz_poly_inflate(fmpz_poly_t result, const fmpz_poly_t input, ulong inflation)
    void fmpz_poly_deflate(fmpz_poly_t result, const fmpz_poly_t input, ulong deflation)
    ulong fmpz_poly_deflation(const fmpz_poly_t input)
    void _fmpz_poly_taylor_shift_horner(fmpz_struct * poly, const fmpz_t c, slong n)
    void fmpz_poly_taylor_shift_horner(fmpz_poly_t g, const fmpz_poly_t f, const fmpz_t c)
    void _fmpz_poly_taylor_shift_divconquer(fmpz_struct * poly, const fmpz_t c, slong n)
    void fmpz_poly_taylor_shift_divconquer(fmpz_poly_t g, const fmpz_poly_t f, const fmpz_t c)
    void _fmpz_poly_taylor_shift_multi_mod(fmpz_struct * poly, const fmpz_t c, slong n)
    void fmpz_poly_taylor_shift_multi_mod(fmpz_poly_t g, const fmpz_poly_t f, const fmpz_t c)
    void _fmpz_poly_taylor_shift(fmpz_struct * poly, const fmpz_t c, slong n)
    void fmpz_poly_taylor_shift(fmpz_poly_t g, const fmpz_poly_t f, const fmpz_t c)
    void _fmpz_poly_compose_series_horner(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2, slong n)
    void fmpz_poly_compose_series_horner(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void _fmpz_poly_compose_series_brent_kung(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2, slong n)
    void fmpz_poly_compose_series_brent_kung(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void _fmpz_poly_compose_series(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_struct * poly2, slong len2, slong n)
    void fmpz_poly_compose_series(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_poly_t poly2, slong n)
    void _fmpz_poly_revert_series(fmpz_struct * Qinv, const fmpz_struct * Q, slong Qlen, slong n)
    void fmpz_poly_revert_series(fmpz_poly_t Qinv, const fmpz_poly_t Q, slong n)
    int _fmpz_poly_sqrtrem_classical(fmpz_struct * res, fmpz_struct * r, const fmpz_struct * poly, slong len)
    int fmpz_poly_sqrtrem_classical(fmpz_poly_t b, fmpz_poly_t r, const fmpz_poly_t a)
    int _fmpz_poly_sqrtrem_divconquer(fmpz_struct * res, fmpz_struct * r, const fmpz_struct * poly, slong len, fmpz_struct * temp)
    int fmpz_poly_sqrtrem_divconquer(fmpz_poly_t b, fmpz_poly_t r, const fmpz_poly_t a)
    int _fmpz_poly_sqrt_classical(fmpz_struct * res, const fmpz_struct * poly, slong len, int exact)
    int fmpz_poly_sqrt_classical(fmpz_poly_t b, const fmpz_poly_t a)
    int _fmpz_poly_sqrt_KS(fmpz_struct * res, const fmpz_struct * poly, slong len)
    int fmpz_poly_sqrt_KS(fmpz_poly_t b, const fmpz_poly_t a)
    int _fmpz_poly_sqrt_divconquer(fmpz_struct * res, const fmpz_struct * poly, slong len, int exact)
    int fmpz_poly_sqrt_divconquer(fmpz_poly_t b, const fmpz_poly_t a)
    int _fmpz_poly_sqrt(fmpz_struct * res, const fmpz_struct * poly, slong len)
    int fmpz_poly_sqrt(fmpz_poly_t b, const fmpz_poly_t a)
    int _fmpz_poly_sqrt_series(fmpz_struct * res, const fmpz_struct * poly, slong len, slong n)
    int fmpz_poly_sqrt_series(fmpz_poly_t b, const fmpz_poly_t a, slong n)
    void _fmpz_poly_power_sums_naive(fmpz_struct * res, const fmpz_struct * poly, slong len, slong n)
    void fmpz_poly_power_sums_naive(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    void fmpz_poly_power_sums(fmpz_poly_t res, const fmpz_poly_t poly, slong n)
    void _fmpz_poly_power_sums_to_poly(fmpz_struct * res, const fmpz_struct * poly, slong len)
    void fmpz_poly_power_sums_to_poly(fmpz_poly_t res, const fmpz_poly_t Q)
    void _fmpz_poly_signature(slong * r1, slong * r2, const fmpz_struct * poly, slong len)
    void fmpz_poly_signature(slong * r1, slong * r2, const fmpz_poly_t poly)
    void fmpz_poly_hensel_build_tree(slong * link, fmpz_poly_t * v, fmpz_poly_t * w, const nmod_poly_factor_t fac)
    void fmpz_poly_hensel_lift(fmpz_poly_t G, fmpz_poly_t H, fmpz_poly_t A, fmpz_poly_t B, const fmpz_poly_t f, const fmpz_poly_t g, const fmpz_poly_t h, const fmpz_poly_t a, const fmpz_poly_t b, const fmpz_t p, const fmpz_t p1)
    void fmpz_poly_hensel_lift_without_inverse(fmpz_poly_t Gout, fmpz_poly_t Hout, const fmpz_poly_t f, const fmpz_poly_t g, const fmpz_poly_t h, const fmpz_poly_t a, const fmpz_poly_t b, const fmpz_t p, const fmpz_t p1)
    void fmpz_poly_hensel_lift_only_inverse(fmpz_poly_t Aout, fmpz_poly_t Bout, const fmpz_poly_t G, const fmpz_poly_t H, const fmpz_poly_t a, const fmpz_poly_t b, const fmpz_t p, const fmpz_t p1)
    void fmpz_poly_hensel_lift_tree_recursive(slong * link, fmpz_poly_t * v, fmpz_poly_t * w, fmpz_poly_t f, slong j, slong inv, const fmpz_t p0, const fmpz_t p1)
    void fmpz_poly_hensel_lift_tree(slong * link, fmpz_poly_t * v, fmpz_poly_t * w, fmpz_poly_t f, slong r, const fmpz_t p, slong e0, slong e1, slong inv)
    slong _fmpz_poly_hensel_start_lift(fmpz_poly_factor_t lifted_fac, slong * link, fmpz_poly_t * v, fmpz_poly_t * w, const fmpz_poly_t f, const nmod_poly_factor_t local_fac, slong N)
    slong _fmpz_poly_hensel_continue_lift(fmpz_poly_factor_t lifted_fac, slong * link, fmpz_poly_t * v, fmpz_poly_t * w, const fmpz_poly_t f, slong prev, slong curr, slong N, const fmpz_t p)
    void fmpz_poly_hensel_lift_once(fmpz_poly_factor_t lifted_fac, const fmpz_poly_t f, const nmod_poly_factor_t local_fac, slong N)
    int _fmpz_poly_print(const fmpz_struct * poly, slong len)
    int fmpz_poly_print(const fmpz_poly_t poly)
    int _fmpz_poly_print_pretty(const fmpz_struct * poly, slong len, const char * x)
    int fmpz_poly_print_pretty(const fmpz_poly_t poly, const char * x)
    # int _fmpz_poly_fprint(FILE * file, const fmpz_struct * poly, slong len)
    # int fmpz_poly_fprint(FILE * file, const fmpz_poly_t poly)
    # int _fmpz_poly_fprint_pretty(FILE * file, const fmpz_struct * poly, slong len, const char * x)
    # int fmpz_poly_fprint_pretty(FILE * file, const fmpz_poly_t poly, const char * x)
    int fmpz_poly_read(fmpz_poly_t poly)
    int fmpz_poly_read_pretty(fmpz_poly_t poly, char **x)
    # int fmpz_poly_fread(FILE * file, fmpz_poly_t poly)
    # int fmpz_poly_fread_pretty(FILE * file, fmpz_poly_t poly, char **x)
    void fmpz_poly_get_nmod_poly(nmod_poly_t Amod, const fmpz_poly_t A)
    void fmpz_poly_set_nmod_poly(fmpz_poly_t A, const nmod_poly_t Amod)
    void fmpz_poly_set_nmod_poly_unsigned(fmpz_poly_t A, const nmod_poly_t Amod)
    void _fmpz_poly_CRT_ui_precomp(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_t m1, mp_srcptr poly2, slong len2, mp_limb_t m2, mp_limb_t m2inv, fmpz_t m1m2, mp_limb_t c, int sign)
    void _fmpz_poly_CRT_ui(fmpz_struct * res, const fmpz_struct * poly1, slong len1, const fmpz_t m1, mp_srcptr poly2, slong len2, mp_limb_t m2, mp_limb_t m2inv, int sign)
    void fmpz_poly_CRT_ui(fmpz_poly_t res, const fmpz_poly_t poly1, const fmpz_t m, const nmod_poly_t poly2, int sign)
    void _fmpz_poly_product_roots_fmpz_vec(fmpz_struct * poly, const fmpz_struct * xs, slong n)
    void fmpz_poly_product_roots_fmpz_vec(fmpz_poly_t poly, const fmpz_struct * xs, slong n)
    void _fmpz_poly_product_roots_fmpq_vec(fmpz_struct * poly, const fmpq_struct * xs, slong n)
    void fmpz_poly_product_roots_fmpq_vec(fmpz_poly_t poly, const fmpq_struct * xs, slong n)
    void _fmpz_poly_bound_roots(fmpz_t bound, const fmpz_struct * poly, slong len)
    void fmpz_poly_bound_roots(fmpz_t bound, const fmpz_poly_t poly)
    void _fmpz_poly_num_real_roots_sturm(slong * n_neg, slong * n_pos, const fmpz_struct * pol, slong len)
    slong fmpz_poly_num_real_roots_sturm(const fmpz_poly_t pol)
    slong _fmpz_poly_num_real_roots(const fmpz_struct * pol, slong len)
    slong fmpz_poly_num_real_roots(const fmpz_poly_t pol)
    void _fmpz_poly_cyclotomic(fmpz_struct * a, ulong n, mp_ptr factors, slong num_factors, ulong phi)
    void fmpz_poly_cyclotomic(fmpz_poly_t poly, ulong n)
    ulong _fmpz_poly_is_cyclotomic(const fmpz_struct * poly, slong len)
    ulong fmpz_poly_is_cyclotomic(const fmpz_poly_t poly)
    void _fmpz_poly_cos_minpoly(fmpz_struct * coeffs, ulong n)
    void fmpz_poly_cos_minpoly(fmpz_poly_t poly, ulong n)
    void _fmpz_poly_swinnerton_dyer(fmpz_struct * coeffs, ulong n)
    void fmpz_poly_swinnerton_dyer(fmpz_poly_t poly, ulong n)
    void _fmpz_poly_chebyshev_t(fmpz_struct * coeffs, ulong n)
    void fmpz_poly_chebyshev_t(fmpz_poly_t poly, ulong n)
    void _fmpz_poly_chebyshev_u(fmpz_struct * coeffs, ulong n)
    void fmpz_poly_chebyshev_u(fmpz_poly_t poly, ulong n)
    void _fmpz_poly_legendre_pt(fmpz_struct * coeffs, ulong n)
    void fmpz_poly_legendre_pt(fmpz_poly_t poly, ulong n)
    void _fmpz_poly_hermite_h(fmpz_struct * coeffs, ulong n)
    void fmpz_poly_hermite_h(fmpz_poly_t poly, ulong n)
    void _fmpz_poly_hermite_he(fmpz_struct * coeffs, ulong n)
    void fmpz_poly_hermite_he(fmpz_poly_t poly, ulong n)
    void _fmpz_poly_fibonacci(fmpz_struct * coeffs, ulong n)
    void fmpz_poly_fibonacci(fmpz_poly_t poly, ulong n)
    void arith_eulerian_polynomial(fmpz_poly_t res, ulong n)
    void _fmpz_poly_eta_qexp(fmpz_struct * f, slong r, slong len)
    void fmpz_poly_eta_qexp(fmpz_poly_t f, slong r, slong n)
    void _fmpz_poly_theta_qexp(fmpz_struct * f, slong r, slong len)
    void fmpz_poly_theta_qexp(fmpz_poly_t f, slong r, slong n)
    void fmpz_poly_CLD_bound(fmpz_t res, const fmpz_poly_t f, slong n)
