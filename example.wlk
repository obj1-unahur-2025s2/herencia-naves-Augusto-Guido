class Nave{
  var velocidad
  var direccionRespectoAlSol
  var combustible

  method cargarCombustible(cantidad){
    combustible += cantidad
  }

  method descargarCombustible(cantidad){
    combustible = (combustible - cantidad).max(0)
  }

  method acelerar(cuanto){ 
    velocidad = (velocidad + cuanto).min(100000)
  }

  method desacelerar(cuanto){
    velocidad = (velocidad - cuanto).max(0)
  }
  
  method irHaciaElSol(){
    direccionRespectoAlSol = 10
  }

  method escaparDelSol(){
    direccionRespectoAlSol = -10
  }

  method ponerseParalelolAlSol(){
    direccionRespectoAlSol = 0
  }

  method acercarseUnPocoAlSol(){
    direccionRespectoAlSol = (direccionRespectoAlSol + 1).min(10)
  }

  method alejarseUnPocoAlSol(){
    direccionRespectoAlSol = (direccionRespectoAlSol - 1).max(-10)
  }

  method prepararViaje(){
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  method estaTranquila() = combustible >= 4000 and velocidad < 12000

  method escapar()
  method avisar()
  method recibirAmenaza(){
    self.escapar()
    self.avisar()
  }

  method estaDeRelajo() = self.estaTranquila()
}

class NaveBaliza inherits Nave{
  var color
  var cambioDeColor = false

  method cambiarColorDeBaliza(colorNuevo){
    color = colorNuevo
    cambioDeColor = true
  }

  method color() = color

  override method  prepararViaje(){
    super()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParalelolAlSol()
  }

  override method estaTranquila(){
    return super() && color != "rojo"
  }

  override method escapar(){
    self.irHaciaElSol()
  }

  override method avisar(){
    color = "rojo"
  }

  override method estaDeRelajo() = super() and cambioDeColor
}

class NaveDePasajeros inherits Nave{
  var property cantidadDePasajeros
  
  var comida
  var bebida
  var comidaServida = 0
  

  method comida() = comida
  method bebida() = bebida

  method cargarComida(cantidad){
    comida += cantidad
  }

  method descargarComida(cantidad){
    comida = (comida - cantidad).max(0)
    comidaServida += cantidad
  }

  method descargarBebida(cantidad){
    bebida = (bebida - cantidad).max(0)
  }

  method cargarBebida(cantidad){
    bebida += cantidad
  }

  override method prepararViaje(){
    super()
    self.cargarComida(4 * cantidadDePasajeros)
    self.cargarBebida(6 * cantidadDePasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method escapar(){
    velocidad = (velocidad * 2).min(100000)
  }

  override method avisar(){
    self.descargarComida(cantidadDePasajeros)
    self.descargarBebida(cantidadDePasajeros * 2)
  }

  override method estaDeRelajo(){
    return super() and comidaServida < 50
  }
}

class NaveDeCombate inherits Nave{
  var estaInvisible
  var misilesDesplegados
  const property mensajesEmitidos = []


  method ponerseInvisible(){
    estaInvisible = true
  }

  method ponerseVisible(){
    estaInvisible = false
  }

  method estaInvisible(){
    return  estaInvisible
  }

  method desplegarMisiles(){
    misilesDesplegados = true
  }

  method replegarMisiles(){
    misilesDesplegados = false
  }

  method misilesDesplegados() = misilesDesplegados

  method emitirMensaje(mensaje){
    mensajesEmitidos.add(mensaje)
  }

  method primerMensajeEmitido() = mensajesEmitidos.first()
  method ultimoMensajeEmitido() = mensajesEmitidos.last()
  method esEscueta(){
    not mensajesEmitidos.any({mensaje => mensaje.length() > 30})
  }

  method emitoMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

  override method prepararViaje(){
    super()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    mensajesEmitidos.add("Saliendo en mision")
  }

  override method estaTranquila(){
    return super() and not self.misilesDesplegados()
  }

  override method escapar(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  override method avisar(){
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveHospital inherits NaveDePasajeros{
  var estanPreparadosLosQuirofanos

  method prepararQuirofanos(){
    estanPreparadosLosQuirofanos = true
  }

  method desprepararQuirofanos(){
    estanPreparadosLosQuirofanos = false
  }

  override method estaTranquila(){
    return super() && not estanPreparadosLosQuirofanos
  }
}

class NaveDeCombateSigilosa inherits NaveDeCombate{
  override method estaTranquila(){
    return super() && self.estaInvisible()
  }
}

