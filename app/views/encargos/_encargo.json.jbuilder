json.extract! encargo, :id, :nombre, :fpago_coche, :frecogida, :fentrada_and, :fcobro_iva, :contacto, :cantidad_iva, :direccion_recog, :comentario, :created_at, :updated_at
json.url encargo_url(encargo, format: :json)
