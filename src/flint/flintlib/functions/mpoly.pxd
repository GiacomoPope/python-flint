from flint.flintlib.types.flint cimport flint_bitcnt_t, flint_rand_t, fmpz_struct, slong, ulong
from flint.flintlib.types.mpoly cimport mpoly_ctx_t, ordering_t

# unknown type mpoly_heap1_s
# unknown type mpoly_heap_s


cdef extern from "flint/mpoly.h":
    void mpoly_ctx_init(mpoly_ctx_t ctx, slong nvars, const ordering_t ord)
    void mpoly_ctx_clear(mpoly_ctx_t mctx)
    ordering_t mpoly_ordering_randtest(flint_rand_t state)
    void mpoly_ctx_init_rand(mpoly_ctx_t mctx, flint_rand_t state, slong max_nvars)
    int mpoly_ordering_isdeg(const mpoly_ctx_t ctx)
    int mpoly_ordering_isrev(const mpoly_ctx_t cth)
    void mpoly_ordering_print(ordering_t ord)
    void mpoly_monomial_add(ulong * exp_ptr, const ulong * exp2, const ulong * exp3, slong N)
    void mpoly_monomial_add_mp(ulong * exp_ptr, const ulong * exp2, const ulong * exp3, slong N)
    void mpoly_monomial_sub(ulong * exp_ptr, const ulong * exp2, const ulong * exp3, slong N)
    void mpoly_monomial_sub_mp(ulong * exp_ptr, const ulong * exp2, const ulong * exp3, slong N)
    int mpoly_monomial_overflows(ulong * exp2, slong N, ulong mask)
    int mpoly_monomial_overflows_mp(ulong * exp_ptr, slong N, flint_bitcnt_t bits)
    int mpoly_monomial_overflows1(ulong exp, ulong mask)
    void mpoly_monomial_set(ulong * exp2, const ulong * exp3, slong N)
    void mpoly_monomial_swap(ulong * exp2, ulong * exp3, slong N)
    void mpoly_monomial_mul_ui(ulong * exp2, const ulong * exp3, slong N, ulong c)
    int mpoly_monomial_is_zero(const ulong * exp, slong N)
    int mpoly_monomial_equal(const ulong * exp2, const ulong * exp3, slong N)
    void mpoly_get_cmpmask(ulong * cmpmask, slong N, ulong bits, const mpoly_ctx_t mctx)
    int mpoly_monomial_lt(const ulong * exp2, const ulong * exp3, slong N, const ulong * cmpmask)
    int mpoly_monomial_gt(const ulong * exp2, const ulong * exp3, slong N, const ulong * cmpmask)
    int mpoly_monomial_cmp(const ulong * exp2, const ulong * exp3, slong N, const ulong * cmpmask)
    int mpoly_monomial_divides(ulong * exp_ptr, const ulong * exp2, const ulong * exp3, slong N, ulong mask)
    int mpoly_monomial_divides_mp(ulong * exp_ptr, const ulong * exp2, const ulong * exp3, slong N, flint_bitcnt_t bits)
    int mpoly_monomial_divides1(ulong * exp_ptr, const ulong exp2, const ulong exp3, ulong mask)
    int mpoly_monomial_divides_tight(slong e1, slong e2, slong * prods, slong num)
    flint_bitcnt_t mpoly_exp_bits_required_ui(const ulong * user_exp, const mpoly_ctx_t mctx)
    flint_bitcnt_t mpoly_exp_bits_required_ffmpz(const fmpz_struct * user_exp, const mpoly_ctx_t mctx)
    flint_bitcnt_t mpoly_exp_bits_required_pfmpz(fmpz_struct * const * user_exp, const mpoly_ctx_t mctx)
    void mpoly_max_fields_ui_sp(ulong * max_fields, const ulong * poly_exps, slong len, ulong bits, const mpoly_ctx_t mctx)
    void mpoly_max_fields_fmpz(fmpz_struct * max_fields, const ulong * poly_exps, slong len, ulong bits, const mpoly_ctx_t mctx)
    void mpoly_max_degrees_tight(slong * max_exp, ulong * exps, slong len, slong * prods, slong num)
    int mpoly_monomial_exists(slong * index, const ulong * poly_exps, const ulong * exp, slong len, slong N, const ulong * cmpmask)
    void mpoly_search_monomials(slong ** e_ind, ulong * e, slong * e_score, slong * t1, slong * t2, slong * t3, slong lower, slong upper, const ulong * a, slong a_len, const ulong * b, slong b_len, slong N, const ulong * cmpmask)
    int mpoly_term_exp_fits_ui(ulong * exps, ulong bits, slong n, const mpoly_ctx_t mctx)
    int mpoly_term_exp_fits_si(ulong * exps, ulong bits, slong n, const mpoly_ctx_t mctx)
    void mpoly_get_monomial_ui(ulong * exps, const ulong * poly_exps, ulong bits, const mpoly_ctx_t mctx)
    void mpoly_get_monomial_ffmpz(fmpz_struct * exps, const ulong * poly_exps, flint_bitcnt_t bits, const mpoly_ctx_t mctx)
    void mpoly_get_monomial_pfmpz(fmpz_struct ** exps, const ulong * poly_exps, flint_bitcnt_t bits, const mpoly_ctx_t mctx)
    void mpoly_set_monomial_ui(ulong * exp1, const ulong * exp2, ulong bits, const mpoly_ctx_t mctx)
    void mpoly_set_monomial_ffmpz(ulong * exp1, const fmpz_struct * exp2, flint_bitcnt_t bits, const mpoly_ctx_t mctx)
    void mpoly_set_monomial_pfmpz(ulong * exp1, fmpz_struct * const * exp2, flint_bitcnt_t bits, const mpoly_ctx_t mctx)
    void mpoly_pack_vec_ui(ulong * exp1, const ulong * exp2, ulong bits, slong nfields, slong len)
    void mpoly_pack_vec_fmpz(ulong * exp1, const fmpz_struct * exp2, flint_bitcnt_t bits, slong nfields, slong len)
    void mpoly_unpack_vec_ui(ulong * exp1, const ulong * exp2, ulong bits, slong nfields, slong len)
    void mpoly_unpack_vec_fmpz(fmpz_struct * exp1, const ulong * exp2, flint_bitcnt_t bits, slong nfields, slong len)
    int mpoly_repack_monomials(ulong * exps1, ulong bits1, const ulong * exps2, ulong bits2, slong len, const mpoly_ctx_t mctx)
    void mpoly_pack_monomials_tight(ulong * exp1, const ulong * exp2, slong len, const slong * mults, slong num, slong bits)
    void mpoly_unpack_monomials_tight(ulong * e1, ulong * e2, slong len, slong * mults, slong num, slong bits)
    void mpoly_main_variable_terms1(slong * i1, slong * n1, const ulong * exp1, slong l1, slong len1, slong k, slong num, slong bits)
    # int _mpoly_heap_insert(mpoly_heap_s * heap, ulong * exp, void * x, slong * next_loc, slong * heap_len, slong N, const ulong * cmpmask)
    # void _mpoly_heap_insert1(mpoly_heap1_s * heap, ulong exp, void * x, slong * next_loc, slong * heap_len, ulong maskhi)
    # void * _mpoly_heap_pop(mpoly_heap_s * heap, slong * heap_len, slong N, const ulong * cmpmask)
    # void * _mpoly_heap_pop1(mpoly_heap1_s * heap, slong * heap_len, ulong maskhi)
