require "test_helper"

class EncargosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @encargo = encargos(:one)
  end

  test "should get index" do
    get encargos_url
    assert_response :success
  end

  test "should get new" do
    get new_encargo_url
    assert_response :success
  end

  test "should create encargo" do
    assert_difference('Encargo.count') do
      post encargos_url, params: { encargo: { cantidad_iva: @encargo.cantidad_iva, comentario: @encargo.comentario, contacto: @encargo.contacto, direccion_recog: @encargo.direccion_recog, fcobro_iva: @encargo.fcobro_iva, fentrada_and: @encargo.fentrada_and, fpago_coche: @encargo.fpago_coche, frecogida: @encargo.frecogida, nombre: @encargo.nombre } }
    end

    assert_redirected_to encargo_url(Encargo.last)
  end

  test "should show encargo" do
    get encargo_url(@encargo)
    assert_response :success
  end

  test "should get edit" do
    get edit_encargo_url(@encargo)
    assert_response :success
  end

  test "should update encargo" do
    patch encargo_url(@encargo), params: { encargo: { cantidad_iva: @encargo.cantidad_iva, comentario: @encargo.comentario, contacto: @encargo.contacto, direccion_recog: @encargo.direccion_recog, fcobro_iva: @encargo.fcobro_iva, fentrada_and: @encargo.fentrada_and, fpago_coche: @encargo.fpago_coche, frecogida: @encargo.frecogida, nombre: @encargo.nombre } }
    assert_redirected_to encargo_url(@encargo)
  end

  test "should destroy encargo" do
    assert_difference('Encargo.count', -1) do
      delete encargo_url(@encargo)
    end

    assert_redirected_to encargos_url
  end
end
