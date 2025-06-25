# LP_project_euler_193

2016006492 % 924 = 192

192 + 1 = 193

Problema:
    A positive integer is called squarefree, if no square of a prime divides N, thus 1, 2, 3, 5, 6, 7, 10, 11 are squarefree, but not 4, 8, 9, 12.
    How many squarefree numbers are there below 2^50?

Resposta: 684465067343069

Algoritmo:

    Crivo de Erastótenes com função de Möbiu: 

        Número k-livre: Um número inteiro é chamado k-livre se não é divisível por p^k para nenhum primo p.
        Square-free então seria 2-livre, ou seja, o número não possui quadrado perfeito como divisor.

        mobius_k_sieve(n, k): 
            entrada:    n: Limite superior para o crivo. n = 2^50
                        k: Potência usada para definir se um número é k-livre. k = 2
            saída:      Um array mob tal o valor da função de Möbius k-generalizada para cada 1 <= i <= n
        
        count_kfree(n, k):
            entrada:    n: Limite superior para o crivo. n = 2^50
                        k: Potência usada para definir se um número é k-livre. k = 2
            saída: números k-livres até n, usando o array gerado por mobius_k_sieve(sq, k)
    




