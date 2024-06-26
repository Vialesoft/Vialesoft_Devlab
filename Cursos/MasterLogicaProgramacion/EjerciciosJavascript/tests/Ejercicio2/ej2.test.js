const esPalindromo = require("./ej2");

test("Comprobar si la función 'esPalindromo' está definida", () => {
    expect(esPalindromo).toBeDefined();
});

test("Comprobar si un palíndromo es correcto", () => {
    expect(esPalindromo("abba")).toEqual(true);
});

test("Comprobar si detecta que una palabra no es palíndromo", () => {
    expect(esPalindromo("pepe")).toEqual(false);
});

