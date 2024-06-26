def invertirEntero(num):
    numStr = str(num)

    numInvertidoStr = numStr[::-1]

    return int(numInvertidoStr)

print(invertirEntero(867))