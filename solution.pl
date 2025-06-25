:- set_prolog_flag(stack_limit, 8_000_000_000).

:- use_module(library(apply)).
:- use_module(library(clpfd)).

% Count square-free numbers below N using inclusion-exclusion
count_square_free(N, Result) :-
    MaxPrime is integer(floor(sqrt(N))),
    sieve(MaxPrime, Primes),
    inclusion_exclusion(Primes, N, Result).

% Sieve of Eratosthenes to find primes up to Limit
sieve(Limit, Primes) :-
    numlist(2, Limit, Numbers),
    sieve_helper(Numbers, Primes).

sieve_helper([], []).
sieve_helper([P|Xs], [P|Primes]) :-
    exclude(is_multiple(P), Xs, Filtered),
    sieve_helper(Filtered, Primes).

is_multiple(P, X) :- X mod P =:= 0.

% Inclusion-exclusion principle implementation
inclusion_exclusion(Primes, N, Result) :-
    length(Primes, L),
    findall(S,
        (between(1, L, K),
         combination(Primes, K, Combo),
         product_square(Combo, Sqr),
         Sqr =< N,
         S is (-1)^K * (N // Sqr)
        ), Terms),
    sum_list(Terms, Sum),
    Result is N + Sum.

% Generate combinations of K elements from list
combination(List, K, Combo) :-
    length(Combo, K),
    sublist(Combo, List).

sublist([], _).
sublist([X|Xs], [X|Ys]) :- sublist(Xs, Ys).
sublist(Xs, [_|Ys]) :- sublist(Xs, Ys).

% Calculate product of squares for inclusion-exclusion
product_square([], 1).
product_square([P|Ps], Product) :-
    product_square(Ps, Rest),
    Product is P^2 * Rest.

% Main execution
main :-
    N is 2^50,
    time(count_square_free(N, Result)),
    format('Square-free numbers below 2^50: ~d~n', [Result]).