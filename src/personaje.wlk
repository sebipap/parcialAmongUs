import nave.*

object votoEnBlanco {
	var property votos
	
	method serVotado(){
		votos += 1
	}
}

class Jugador {
	// color no se usa
	const mochila = []
	var property sospecha = 40
	var property tareasPendientes = []
	var estaImpugnado = false
	var property votos
	
	method esSospechoso() {
		return sospecha > 50
	}
	
	method buscarItem(item){
		mochila.add(item)
	}
	
	method aumentarNivelSospecha(valor){
		sospecha += valor
	}
	method impugnar() {
		estaImpugnado = true
	}
	
	method habilitar() {
		estaImpugnado = false
	}
	
	method llamarReunionDeEmergencia(){
		nave.realizarVotacion()
	}
	
	method serVotado(){
		votos += 1
	}
	
	method mochilaVacia(){
		return mochila == []
	}
	
	method votarEnBlanco(){
		
	}
}


class Troll inherits Tripulante{
	method votar(){
		if(estaImpugnado){
			self.votarEnBlanco()			
		}else{
			nave.personajesNoSospechosos().anyOne().serVotado()			
		}
	}
}

class Detective inherits Tripulante{
	method votar(){
		if(estaImpugnado){
			self.votarEnBlanco()			
		}else{
			nave.personajeMasSospechoso().serVotado()
		}
	}
}

class Materialista inherits Tripulante{
	method votar(){
		
		if(estaImpugnado){
			self.votarEnBlanco()			
		}else{
			nave.personajesMochilaVacia().anyOne().serVotado()
		}
		
	}
}

class Tripulante inherits Jugador{
	
	const property es = "tripulante"
		
	method realizarCualquierTarea(){
		self.tareasQuePuedeRealizar().anyOne().realizarTarea()
	}
	
	method tareasQuePuedeRealizar(){
		return tareasPendientes.filter({tarea => self.puedeRealizar(tarea)})
	}
	
	
	method puedeRealizar(tarea){
		return tarea.elementosNecesarios().all{elemento => mochila.contains(elemento)}
	}
	
	method realizarTarea(tarea){
		
		if(self.puedeRealizar(tarea)){
			tarea.realizar()
			self.aumentarNivelSospecha(tarea.sospechaQueGenera())
			nave.informar()
		}else{
			self.votarEnBlanco()
		}
		
	}
	
	method completoTodasSusTareas() {
			tareasPendientes = []
		}
		
	

}

class Impostor inherits Jugador{
	
	const property es = "impostor"
	const property completoTodasSusTareas = true
	
	
	method realizarTarea(_){
		
	}
	
	method realizarSabotaje(sabotaje){
		sabotaje.realizar()
	}
		
	method votar(){
		if(!estaImpugnado){
			nave.jugadorAlAzar().serVotado()
		}else{
			self.votarEnBlanco()
		}
	}
}





