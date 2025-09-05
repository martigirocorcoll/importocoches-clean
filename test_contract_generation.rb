#!/usr/bin/env ruby
# Script para probar la generación de contratos

require 'net/http'
require 'uri'
require 'json'

# Test data for particular (individual)
particular_params = {
  car_id: "430111792",
  marca_model: "BMW X5 xDrive30d",
  km: "45000",
  primera_matriculacion: "Jun.-23",
  chassis: "WBAJZ01050G123456",
  venta_total: "65000",
  deposito: "3000",
  fianza: "0",
  descripcion_traducida: "BMW X5 xDrive30d con paquete M Sport, navegación profesional, asientos de cuero, techo panorámico, sistema de sonido Harman Kardon",
  
  # Cliente particular (dejar empresa y nrt vacíos)
  empresa: "",
  nrt: "",
  nombre: "Juan Pérez García",
  nia: "123456X",
  domicilio: "Av. Meritxell 123, AD500 Andorra la Vella"
}

# Test data for empresa (company)
empresa_params = {
  car_id: "430111792",
  marca_model: "BMW X5 xDrive30d",
  km: "45000",
  primera_matriculacion: "Jun.-23",
  chassis: "WBAJZ01050G123456",
  venta_total: "65000",
  deposito: "3000",
  fianza: "2000",
  descripcion_traducida: "BMW X5 xDrive30d con paquete M Sport, navegación profesional, asientos de cuero, techo panorámico, sistema de sonido Harman Kardon",
  
  # Cliente empresa
  empresa: "Tech Solutions SL",
  nrt: "L-123456-T",
  nombre: "María López Fernández",
  nia: "987654Y",
  domicilio: "C/ Prat de la Creu 50, AD500 Andorra la Vella"
}

puts "Generación de Contratos de Reserva - Test"
puts "=" * 50
puts ""
puts "Para probar la generación de contratos:"
puts ""
puts "1. Asegúrate de que el servidor Rails está corriendo (rails server)"
puts "2. Ve a: http://localhost:3000/contracts/new"
puts "3. Ingresa en tu navegador y autentícate"
puts ""
puts "4. Prueba con CLIENTE PARTICULAR:"
puts "   - ID del Coche: #{particular_params[:car_id]}"
puts "   - Marca y Modelo: #{particular_params[:marca_model]}"
puts "   - Kilómetros: #{particular_params[:km]}"
puts "   - 1ª Matriculación: #{particular_params[:primera_matriculacion]}"
puts "   - Chasis: #{particular_params[:chassis]}"
puts "   - Precio: #{particular_params[:venta_total]}€"
puts "   - Depósito: #{particular_params[:deposito]}€"
puts "   - Fianza: #{particular_params[:fianza]}€"
puts "   - Nombre: #{particular_params[:nombre]}"
puts "   - NIA: #{particular_params[:nia]}"
puts "   - Domicilio: #{particular_params[:domicilio]}"
puts "   - DEJAR VACÍO: Empresa y NRT"
puts ""
puts "5. Prueba con CLIENTE EMPRESA:"
puts "   - Todos los datos del vehículo iguales"
puts "   - Empresa: #{empresa_params[:empresa]}"
puts "   - NRT: #{empresa_params[:nrt]}"
puts "   - Administrador: #{empresa_params[:nombre]}"
puts "   - Documento: #{empresa_params[:nia]}"
puts "   - Domicilio: #{empresa_params[:domicilio]}"
puts ""
puts "Al hacer click en 'Generar Contrato PDF' se abrirá el PDF en una nueva pestaña."
puts ""
puts "VERIFICAR:"
puts "- Formato correcto del contrato"
puts "- Cálculo correcto del pago restante"
puts "- Diferencia entre particular y empresa en las cláusulas"
puts "- Si se incluye ID del coche, verificar que carga datos de la API"