from flint.flintlib.fq cimport fq_t, fq_struct, fq_ctx_t
from flint.flintlib.fq_poly cimport fq_poly_t
from flint.flintlib.flint cimport flint_rand_t, slong
from flint.flintlib.nmod_mat cimport nmod_mat_t
from flint.flintlib.fmpz_mod_mat cimport fmpz_mod_mat_t

cdef extern from "flint/fq_mat.h":
    # Type definitions **********************************************/
    ctypedef struct fq_mat_struct:
        fq_struct * entries
        slong r
        slong s
        fq_struct ** rows
    ctypedef fq_mat_struct fq_mat_t[1]

    # Parsed from here **********************************************/
    void fq_mat_init(fq_mat_t mat, slong rows, slong cols, const fq_ctx_t ctx)
    void fq_mat_init_set(fq_mat_t mat, const fq_mat_t src, const fq_ctx_t ctx)
    void fq_mat_clear(fq_mat_t mat, const fq_ctx_t ctx)
    void fq_mat_set(fq_mat_t mat, const fq_mat_t src, const fq_ctx_t ctx)
    fq_struct * fq_mat_entry(const fq_mat_t mat, slong i, slong j)
    void fq_mat_entry_set(fq_mat_t mat, slong i, slong j, const fq_t x, const fq_ctx_t ctx)
    slong fq_mat_nrows(const fq_mat_t mat, const fq_ctx_t ctx)
    slong fq_mat_ncols(const fq_mat_t mat, const fq_ctx_t ctx)
    void fq_mat_swap(fq_mat_t mat1, fq_mat_t mat2, const fq_ctx_t ctx)
    void fq_mat_swap_entrywise(fq_mat_t mat1, fq_mat_t mat2, const fq_ctx_t ctx)
    void fq_mat_zero(fq_mat_t mat, const fq_ctx_t ctx)
    void fq_mat_one(fq_mat_t mat, const fq_ctx_t ctx)
    void fq_mat_swap_rows(fq_mat_t mat, slong * perm, slong r, slong s, const fq_ctx_t ctx)
    void fq_mat_swap_cols(fq_mat_t mat, slong * perm, slong r, slong s, const fq_ctx_t ctx)
    void fq_mat_invert_rows(fq_mat_t mat, slong * perm, const fq_ctx_t ctx)
    void fq_mat_invert_cols(fq_mat_t mat, slong * perm, const fq_ctx_t ctx)
    void fq_mat_set_nmod_mat(fq_mat_t mat1, const nmod_mat_t mat2, const fq_ctx_t ctx)
    void fq_mat_set_fmpz_mod_mat(fq_mat_t mat1, const fmpz_mod_mat_t mat2, const fq_ctx_t ctx)
    void fq_mat_concat_vertical(fq_mat_t res, const fq_mat_t mat1, const fq_mat_t mat2, const fq_ctx_t ctx)
    void fq_mat_concat_horizontal(fq_mat_t res, const fq_mat_t mat1, const fq_mat_t mat2, const fq_ctx_t ctx)
    int fq_mat_print_pretty(const fq_mat_t mat, const fq_ctx_t ctx)
    # int fq_mat_fprint_pretty(FILE * file, const fq_mat_t mat, const fq_ctx_t ctx)
    int fq_mat_print(const fq_mat_t mat, const fq_ctx_t ctx)
    # int fq_mat_fprint(FILE * file, const fq_mat_t mat, const fq_ctx_t ctx)
    void fq_mat_window_init(fq_mat_t window, const fq_mat_t mat, slong r1, slong c1, slong r2, slong c2, const fq_ctx_t ctx)
    void fq_mat_window_clear(fq_mat_t window, const fq_ctx_t ctx)
    void fq_mat_randtest(fq_mat_t mat, flint_rand_t state, const fq_ctx_t ctx)
    int fq_mat_randpermdiag(fq_mat_t mat, flint_rand_t state, fq_struct * diag, slong n, const fq_ctx_t ctx)
    void fq_mat_randrank(fq_mat_t mat, flint_rand_t state, slong rank, const fq_ctx_t ctx)
    void fq_mat_randops(fq_mat_t mat, flint_rand_t state, slong count, const fq_ctx_t ctx)
    void fq_mat_randtril(fq_mat_t mat, flint_rand_t state, int unit, const fq_ctx_t ctx)
    void fq_mat_randtriu(fq_mat_t mat, flint_rand_t state, int unit, const fq_ctx_t ctx)
    int fq_mat_equal(const fq_mat_t mat1, const fq_mat_t mat2, const fq_ctx_t ctx)
    int fq_mat_is_zero(const fq_mat_t mat, const fq_ctx_t ctx)
    int fq_mat_is_one(const fq_mat_t mat, const fq_ctx_t ctx)
    int fq_mat_is_empty(const fq_mat_t mat, const fq_ctx_t ctx)
    int fq_mat_is_square(const fq_mat_t mat, const fq_ctx_t ctx)
    void fq_mat_add(fq_mat_t C, const fq_mat_t A, const fq_mat_t B, const fq_ctx_t ctx)
    void fq_mat_sub(fq_mat_t C, const fq_mat_t A, const fq_mat_t B, const fq_ctx_t ctx)
    void fq_mat_neg(fq_mat_t A, const fq_mat_t B, const fq_ctx_t ctx)
    void fq_mat_mul(fq_mat_t C, const fq_mat_t A, const fq_mat_t B, const fq_ctx_t ctx)
    void fq_mat_mul_classical(fq_mat_t C, const fq_mat_t A, const fq_mat_t B, const fq_ctx_t ctx)
    void fq_mat_mul_KS(fq_mat_t C, const fq_mat_t A, const fq_mat_t B, const fq_ctx_t ctx)
    void fq_mat_submul(fq_mat_t D, const fq_mat_t C, const fq_mat_t A, const fq_mat_t B, const fq_ctx_t ctx)
    void fq_mat_mul_vec(fq_struct * c, const fq_mat_t A, const fq_struct * b, slong blen, const fq_ctx_t ctx)
    void fq_mat_mul_vec_ptr(fq_struct * const * c, const fq_mat_t A, const fq_struct * const * b, slong blen, const fq_ctx_t ctx)
    void fq_mat_vec_mul(fq_struct * c, const fq_struct * a, slong alen, const fq_mat_t B, const fq_ctx_t ctx)
    void fq_mat_vec_mul_ptr(fq_struct * const * c, const fq_struct * const * a, slong alen, const fq_mat_t B, const fq_ctx_t ctx)
    int fq_mat_inv(fq_mat_t B, fq_mat_t A, const fq_ctx_t ctx)
    slong fq_mat_lu(slong * P, fq_mat_t A, int rank_check, const fq_ctx_t ctx)
    slong fq_mat_lu_classical(slong * P, fq_mat_t A, int rank_check, const fq_ctx_t ctx)
    slong fq_mat_lu_recursive(slong * P, fq_mat_t A, int rank_check, const fq_ctx_t ctx)
    slong fq_mat_rref(fq_mat_t B, const fq_mat_t A, const fq_ctx_t ctx)
    slong fq_mat_reduce_row(fq_mat_t A, slong * P, slong * L, slong n, const fq_ctx_t ctx)
    void fq_mat_solve_tril(fq_mat_t X, const fq_mat_t L, const fq_mat_t B, int unit, const fq_ctx_t ctx)
    void fq_mat_solve_tril_classical(fq_mat_t X, const fq_mat_t L, const fq_mat_t B, int unit, const fq_ctx_t ctx)
    void fq_mat_solve_tril_recursive(fq_mat_t X, const fq_mat_t L, const fq_mat_t B, int unit, const fq_ctx_t ctx)
    void fq_mat_solve_triu(fq_mat_t X, const fq_mat_t U, const fq_mat_t B, int unit, const fq_ctx_t ctx)
    void fq_mat_solve_triu_classical(fq_mat_t X, const fq_mat_t U, const fq_mat_t B, int unit, const fq_ctx_t ctx)
    void fq_mat_solve_triu_recursive(fq_mat_t X, const fq_mat_t U, const fq_mat_t B, int unit, const fq_ctx_t ctx)
    int fq_mat_solve(fq_mat_t X, const fq_mat_t A, const fq_mat_t B, const fq_ctx_t ctx)
    int fq_mat_can_solve(fq_mat_t X, const fq_mat_t A, const fq_mat_t B, const fq_ctx_t ctx)
    void fq_mat_similarity(fq_mat_t M, slong r, fq_t d, const fq_ctx_t ctx)
    void fq_mat_charpoly_danilevsky(fq_poly_t p, const fq_mat_t M, const fq_ctx_t ctx)
    void fq_mat_charpoly(fq_poly_t p, const fq_mat_t M, const fq_ctx_t ctx)
    void fq_mat_minpoly(fq_poly_t p, const fq_mat_t M, const fq_ctx_t ctx)
