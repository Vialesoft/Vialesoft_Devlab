class Reloj {
    constructor(){
    }

    relojRapido() {
        setInterval(() => {
            const fecha = new Date();
            const horas = fecha.getHours();
            const minutos = fecha.getMinutes();
            const segundos = fecha.getSeconds();
    
            console.log(`${horas}:${minutos}:${segundos}`);
        }, 1000);
    }

    encender(){
        this.relojRapido();
    }
}

let mi_Reloj = new Reloj();
mi_Reloj.encender();