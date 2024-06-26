import { Pipe, PipeTransform } from '@angular/core';

@Pipe ({
    name: 'calculadora'
})
export class CalculadoraPipe implements PipeTransform {
    // dato (param1) | calculadora: otrodato (param2)
    transform(dato: any, otrodato: any) {
        let operaciones = `
            Suma: ${dato+otrodato} - 
            Resta: ${dato-otrodato} -
            Multiplicacion: ${dato*otrodato} -
            Division: ${dato/otrodato}
        `

        return operaciones;
    }
}