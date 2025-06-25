(* Sieve of Eratosthenes with Möbius function - Fixed Overflow *)
fun mobius_k_sieve(n : int, k : int) =
    let
        val isprime = Array.array(n+1, true)
        val mob = Array.array(n+1, 1)
        
        val _ = Array.update(isprime, 0, false)
        val _ = Array.update(isprime, 1, false)
        
        fun sieve p =
            if p > n then ()
            else if Array.sub(isprime, p) then
                let
                    fun update_multiples i =
                        if i > n then ()
                        else (
                            Array.update(mob, i, ~1 * Array.sub(mob, i));
                            Array.update(isprime, i, false);
                            update_multiples (i + p)
                        )
                    
                    val pk = IntInf.toInt(IntInf.pow(IntInf.fromInt p, k))
                    fun zero_pk j =
                        if j > n then ()
                        else (
                            Array.update(mob, j, 0);
                            zero_pk (j + pk)
                        )
                in
                    update_multiples (2*p);
                    if pk <= n then zero_pk pk else ();
                    sieve (p + 1)
                end
            else sieve (p + 1)
        
        fun arrayToList arr = List.tabulate(n+1, fn i => Array.sub(arr, i))
    in
        sieve 2;
        (arrayToList isprime, arrayToList mob)
    end

(* Count k-free numbers with overflow protection *)
fun count_k_frees(n : IntInf.int, k : int) : IntInf.int =
    let
        val root = IntInf.toInt(
            IntInf.min(
                IntInf.fromInt(Real.floor(Math.pow(Real.fromLargeInt(IntInf.toLarge n), 1.0 / Real.fromInt k))),
                IntInf.fromInt(1000000)  (* Safety limit *)
            )
        )
        val (_, mobius_k) = mobius_k_sieve(root, k)
        
        fun sum_terms i acc =
            if i > root then acc
            else
                let
                    val dk = IntInf.pow(IntInf.fromInt i, k)
                in
                    if dk > n then sum_terms (i+1) acc
                    else sum_terms (i+1) (
                        IntInf.+(acc, 
                            IntInf.*(
                                IntInf.fromInt(List.nth(mobius_k, i)), 
                                IntInf.div(n, dk)
                            )
                        )
                    )
                end
    in
        sum_terms 1 (IntInf.fromInt 0)
    end

(* MAIN with better large number handling *)
val () = 
    let
        val test_value = 100
        val () = print "Testing with small value (100)...\n"
        val small_result = count_k_frees(IntInf.fromInt test_value, 2)
        val () = print ("Small test result: " ^ IntInf.toString small_result ^ "\n")
        
        val medium_value = IntInf.pow(IntInf.fromInt 2, 20)
        val () = print "Testing with medium value (2^20)...\n"
        val medium_result = count_k_frees(medium_value, 2)
        val () = print ("Medium test result: " ^ IntInf.toString medium_result ^ "\n")
        
        val large_value = IntInf.pow(IntInf.fromInt 2, 50)
        val () = print "Calculating for large value (2^50)...\n"
        val () = TextIO.flushOut TextIO.stdOut
        val large_result = count_k_frees(large_value, 2)
    in
        print ("Final result: " ^ IntInf.toString large_result ^ "\n")
    end