import personaje.*

object nave{
	const jugadores = []
	var nivelOxigeno
	
	method aumentarOxigeno(cantidad){
		nivelOxigeno += cantidad
	}
	
	method reducirOxigeno(cantidad){
		nivelOxigeno -= cantidad
		self.informar()
	}
	
	method losJugadoresTerminaronSusTareas(){
		return jugadores.all{jugador => jugador.completoTodasSusTareas()}		
	}
	
	method cantidadQueSon(tipo) {
		return jugadores.filter{jugador => jugador.es() == tipo}
	}
	
	method fueronExpulsadosTodosLosImpostores(){
		return self.cantidadQueSon("impostor") == 0
	}
	
	method quedanTantosImpostoresComoTripulantes(){
		return self.cantidadQueSon("tripulante") == self.cantidadQueSon("impostor")
	}
	
	method informar(){
		if(self.losJugadoresTerminaronSusTareas() || self.fueronExpulsadosTodosLosImpostores()){
			throw new Exception(message = "¡Ganaron los tripulantes!")
		}
		if(nivelOxigeno <= 0 || self.quedanTantosImpostoresComoTripulantes()){
			throw new Exception(message = "¡Ganaron los impostores!")
			
		}
	}
	

	method ganoVotoEnBlanco(){
		return votoEnBlanco.votos() > self.votosDelMasVotado() 
	}
	
	method realizarVotacion(){
		jugadores.forEach({jugador => jugador.votar()})
		if(!self.ganoVotoEnBlanco()){
			self.eliminarAlMasVotado()	
			self.informar()			
		}
		self.quitarImpugnaciones()
		
	}
	
	method quitarImpugnaciones(){
		jugadores.forEach({jugador => jugador.habilitar()})
		
	}
	
	method jugadorAlAzar(){
		return jugadores.anyOne()
	}
	
	method personajesNoSospechosos(){
		 return jugadores.filter{jugador => !jugador.esSospechoso()}
	}
	
	method votosDelMasVotado(){
		return jugadores.max({jugador => jugador.sospecha()}).votos()
	}
	
	method personajesMochilaVacia(){
 		return jugadores.filter{jugador => jugador.mochilaVacia()}
		
	}
	
	method personajesMasVotados(){
		return jugadores.filter{jugador => jugador.votos() == self.votosDelMasVotado()}
	}
	

	method eliminarAlMasVotado(){
		jugadores.remove(self.personajesMasVotados().anyOne()) 
	}
}