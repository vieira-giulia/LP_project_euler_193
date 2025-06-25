""" Crivo de Eratóstenes com cálculo da função de Möbius generalizada """
def mobius_k_sieve(n, k):
    isprime = [1]*(n + 1)  # Lista booleana para marcar primos
    isprime[0] = isprime[1] = 0  # 0 e 1 não são primos
    mob = [0] + [1]*(n)  # Inicia lista de Möbius generalizada: mob[0] = 0, demais começam em 1
    for p in range(2, n + 1):  # Para cada número de 2 até n
        if isprime[p]:  # Se é primo
            mob[p] *= -1  # Inverte sinal do mobius
            for i in range(2*p, n + 1, p):  # Marca múltiplos como não primos
                isprime[i] = 0
                mob[i] *= -1  # Inverte sinal de mobius
            sq = pow(p, k)  # Calcula p^k
            if sq <= n: 
                for j in range(sq, n + 1, sq): mob[j] = 0 # Zera mobius para múltiplos de p^k
    return isprime, mob  # Retorna lista de primos e mobius


"""Conta números k-livres até n"""
def count_kfree(n, k):
    # Redefinição da função de Möbius para números livres de potências k
    sq = int(pow(n, 1/k))  # Define limite superior √[k](n)
    _, mobius_k = mobius_k_sieve(sq, k)  # Calcula função de Möbius até sq
    # Soma μ_k(d) * floor(n / d^k)
    return sum([mobius_k[i]*(n//pow(i, k)) for i in range(1, sq + 1)])


"""Caso de teste: conta números quadrado-livres até 2^50"""
if __name__ == "__main__":
    print(count_kfree(2**50, 2))
