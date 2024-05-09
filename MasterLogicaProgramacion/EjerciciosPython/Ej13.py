def dividirArray(array, tamArray):
    
    if (len(array) <= tamArray):
        return [array]

    arrayRetorno = []
    subArr = []
    
    for i in range(0, len(array)):
        subArr.append(array[i])

        if (len(subArr) == tamArray):
            arrayRetorno.append(subArr)
            subArr = []

    if (len(subArr) < tamArray and len(subArr) != 0):
        arrayRetorno.append(subArr)

    return arrayRetorno

print(dividirArray([7,8,9,10,11], 2))