# unimported types  {'fq_nmod_t', 'fq_nmod_ctx_t'}
from flint.flintlib.fmpz cimport fmpz_t, fmpz_struct
from flint.flintlib.nmod_poly cimport nmod_poly_t
from flint.flintlib.flint cimport mp_ptr, mp_limb_t, slong, mp_srcptr, flint_rand_t, flint_bitcnt_t, ulong
from flint.flintlib.nmod cimport nmod_t
from flint.flintlib.nmod_mat cimport nmod_mat_t
from flint.flintlib.nmod_poly cimport nmod_poly_struct, nmod_poly_t

cdef extern from "flint/fq_nmod.h":
    # Type definitions **********************************************/
    ctypedef nmod_poly_t fq_nmod_t
    ctypedef nmod_poly_struct fq_nmod_struct

    ctypedef struct fq_nmod_ctx_struct:
        fmpz_struct p
        nmod_t mod

        int sparse_modulus
        int is_conway # whether field was generated using Flint Conway table (assures primitivity

        mp_limb_t *a
        slong *j
        slong len

        nmod_poly_t modulus
        nmod_poly_t inv

        char *var
    ctypedef fq_nmod_ctx_struct fq_nmod_ctx_t[1]

    ctypedef struct fq_nmod_poly_struct:
        fq_nmod_struct * coeffs
        slong alloc
        slong length
    ctypedef fq_nmod_poly_struct fq_nmod_poly_t[1]

    ctypedef struct fq_nmod_mat_struct:
        fq_nmod_struct * entries
        slong r
        slong s
        fq_nmod_struct ** rows
    ctypedef fq_nmod_mat_struct fq_nmod_mat_t[1]

    # Parsed from here **********************************************/
    void fq_nmod_ctx_init(fq_nmod_ctx_t ctx, const fmpz_t p, slong d, const char *var)
    int _fq_nmod_ctx_init_conway(fq_nmod_ctx_t ctx, const fmpz_t p, slong d, const char *var)
    void fq_nmod_ctx_init_conway(fq_nmod_ctx_t ctx, const fmpz_t p, slong d, const char *var)
    void fq_nmod_ctx_init_modulus(fq_nmod_ctx_t ctx, nmod_poly_t modulus, const char *var)
    void fq_nmod_ctx_clear(fq_nmod_ctx_t ctx)
    const nmod_poly_struct* fq_nmod_ctx_modulus(const fq_nmod_ctx_t ctx)
    long fq_nmod_ctx_degree(const fq_nmod_ctx_t ctx)
    fmpz_struct * fq_nmod_ctx_prime(const fq_nmod_ctx_t ctx)
    void fq_nmod_ctx_order(fmpz_t f, const fq_nmod_ctx_t ctx)
    # int fq_nmod_ctx_fprint(FILE * file, const fq_nmod_ctx_t ctx)
    void fq_nmod_ctx_print(const fq_nmod_ctx_t ctx)
    void fq_nmod_ctx_randtest(fq_nmod_ctx_t ctx)
    void fq_nmod_ctx_randtest_reducible(fq_nmod_ctx_t ctx)
    void fq_nmod_init(fq_nmod_t rop, const fq_nmod_ctx_t ctx)
    void fq_nmod_init2(fq_nmod_t rop, const fq_nmod_ctx_t ctx)
    void fq_nmod_clear(fq_nmod_t rop, const fq_nmod_ctx_t ctx)
    void _fq_nmod_sparse_reduce(mp_ptr R, slong lenR, const fq_nmod_ctx_t ctx)
    void _fq_nmod_dense_reduce(mp_ptr R, slong lenR, const fq_nmod_ctx_t ctx)
    void _fq_nmod_reduce(mp_ptr r, slong lenR, const fq_nmod_ctx_t ctx)
    void fq_nmod_reduce(fq_nmod_t rop, const fq_nmod_ctx_t ctx)
    void fq_nmod_add(fq_nmod_t rop, const fq_nmod_t op1, const fq_nmod_t op2, const fq_nmod_ctx_t ctx)
    void fq_nmod_sub(fq_nmod_t rop, const fq_nmod_t op1, const fq_nmod_t op2, const fq_nmod_ctx_t ctx)
    void fq_nmod_sub_one(fq_nmod_t rop, const fq_nmod_t op1, const fq_nmod_ctx_t ctx)
    void fq_nmod_neg(fq_nmod_t rop, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void fq_nmod_mul(fq_nmod_t rop, const fq_nmod_t op1, const fq_nmod_t op2, const fq_nmod_ctx_t ctx)
    void fq_nmod_mul_fmpz(fq_nmod_t rop, const fq_nmod_t op, const fmpz_t x, const fq_nmod_ctx_t ctx)
    void fq_nmod_mul_si(fq_nmod_t rop, const fq_nmod_t op, slong x, const fq_nmod_ctx_t ctx)
    void fq_nmod_mul_ui(fq_nmod_t rop, const fq_nmod_t op, ulong x, const fq_nmod_ctx_t ctx)
    void fq_nmod_sqr(fq_nmod_t rop, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void _fq_nmod_inv(mp_ptr * rop, mp_srcptr * op, slong len, const fq_nmod_ctx_t ctx)
    void fq_nmod_inv(fq_nmod_t rop, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void fq_nmod_gcdinv(fq_nmod_t f, fq_nmod_t inv, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void _fq_nmod_pow(mp_ptr * rop, mp_srcptr * op, slong len, const fmpz_t e, const fq_nmod_ctx_t ctx)
    void fq_nmod_pow(fq_nmod_t rop, const fq_nmod_t op, const fmpz_t e, const fq_nmod_ctx_t ctx)
    void fq_nmod_pow_ui(fq_nmod_t rop, const fq_nmod_t op, const ulong e, const fq_nmod_ctx_t ctx)
    void fq_nmod_sqrt(fq_nmod_t rop, const fq_nmod_t op1, const fq_nmod_ctx_t ctx)
    void fq_nmod_pth_root(fq_nmod_t rop, const fq_nmod_t op1, const fq_nmod_ctx_t ctx)
    int fq_nmod_is_square(const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    # int fq_nmod_fprint_pretty(FILE * file, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    int fq_nmod_print_pretty(const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    # void fq_nmod_fprint(FILE * file, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void fq_nmod_print(const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    char * fq_nmod_get_str(const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    char * fq_nmod_get_str_pretty(const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void fq_nmod_randtest(fq_nmod_t rop, flint_rand_t state, const fq_nmod_ctx_t ctx)
    void fq_nmod_randtest_not_zero(fq_nmod_t rop, flint_rand_t state, const fq_nmod_ctx_t ctx)
    void fq_nmod_randtest_dense(fq_nmod_t rop, flint_rand_t state, const fq_nmod_ctx_t ctx)
    void fq_nmod_rand(fq_nmod_t rop, flint_rand_t state, const fq_nmod_ctx_t ctx)
    void fq_nmod_rand_not_zero(fq_nmod_t rop, flint_rand_t state, const fq_nmod_ctx_t ctx)
    void fq_nmod_set(fq_nmod_t rop, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void fq_nmod_set_si(fq_nmod_t rop, const slong x, const fq_nmod_ctx_t ctx)
    void fq_nmod_set_ui(fq_nmod_t rop, const ulong x, const fq_nmod_ctx_t ctx)
    void fq_nmod_set_fmpz(fq_nmod_t rop, const fmpz_t x, const fq_nmod_ctx_t ctx)
    void fq_nmod_swap(fq_nmod_t op1, fq_nmod_t op2, const fq_nmod_ctx_t ctx)
    void fq_nmod_zero(fq_nmod_t rop, const fq_nmod_ctx_t ctx)
    void fq_nmod_one(fq_nmod_t rop, const fq_nmod_ctx_t ctx)
    void fq_nmod_gen(fq_nmod_t rop, const fq_nmod_ctx_t ctx)
    int fq_nmod_get_fmpz(fmpz_t rop, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void fq_nmod_get_nmod_poly(nmod_poly_t a, const fq_nmod_t b, const fq_nmod_ctx_t ctx)
    void fq_nmod_set_nmod_poly(fq_nmod_t a, const nmod_poly_t b, const fq_nmod_ctx_t ctx)
    void fq_nmod_get_nmod_mat(nmod_mat_t col, const fq_nmod_t a, const fq_nmod_ctx_t ctx)
    void fq_nmod_set_nmod_mat(fq_nmod_t a, const nmod_mat_t col, const fq_nmod_ctx_t ctx)
    int fq_nmod_is_zero(const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    int fq_nmod_is_one(const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    int fq_nmod_equal(const fq_nmod_t op1, const fq_nmod_t op2, const fq_nmod_ctx_t ctx)
    int fq_nmod_is_invertible(const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    int fq_nmod_is_invertible_f(fq_nmod_t f, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    int fq_nmod_cmp(const fq_nmod_t a, const fq_nmod_t b, const fq_nmod_ctx_t ctx)
    void _fq_nmod_trace(fmpz_t rop, mp_srcptr * op, slong len, const fq_nmod_ctx_t ctx)
    void fq_nmod_trace(fmpz_t rop, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void _fq_nmod_norm(fmpz_t rop, mp_srcptr * op, slong len, const fq_nmod_ctx_t ctx)
    void fq_nmod_norm(fmpz_t rop, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void _fq_nmod_frobenius(mp_ptr * rop, mp_srcptr * op, slong len, slong e, const fq_nmod_ctx_t ctx)
    void fq_nmod_frobenius(fq_nmod_t rop, const fq_nmod_t op, slong e, const fq_nmod_ctx_t ctx)
    int fq_nmod_multiplicative_order(fmpz_t ord, const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    int fq_nmod_is_primitive(const fq_nmod_t op, const fq_nmod_ctx_t ctx)
    void fq_nmod_bit_pack(fmpz_t f, const fq_nmod_t op, flint_bitcnt_t bit_size, const fq_nmod_ctx_t ctx)
    void fq_nmod_bit_unpack(fq_nmod_t rop, const fmpz_t f, flint_bitcnt_t bit_size, const fq_nmod_ctx_t ctx)
