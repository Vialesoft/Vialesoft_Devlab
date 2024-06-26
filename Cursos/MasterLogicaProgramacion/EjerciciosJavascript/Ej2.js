function esPalindromo(palabra) {
    var palabraAlReves = palabra.toUpperCase().split("").reverse().join("");

    return palabraAlReves == palabra.toUpperCase();
}

console.log(esPalindromo("ABBA"));
console.log(esPalindromo("ABAB"));