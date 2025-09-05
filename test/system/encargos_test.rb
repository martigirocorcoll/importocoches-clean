require "application_system_test_case"

class EncargosTest < ApplicationSystemTestCase
  setup do
    @encargo = encargos(:one)
  end

  test "visiting the index" do
    visit encargos_url
    assert_selector "h1", text: "Encargos"
  end

  test "creating a Encargo" do
    visit encargos_url
    click_on "New Encargo"

    fill_in "Cantidad iva", with: @encargo.cantidad_iva
    fill_in "Comentario", with: @encargo.comentario
    fill_in "Contacto", with: @encargo.contacto
    fill_in "Direccion recog", with: @encargo.direccion_recog
    fill_in "Fcobro iva", with: @encargo.fcobro_iva
    fill_in "Fentrada and", with: @encargo.fentrada_and
    fill_in "Fpago coche", with: @encargo.fpago_coche
    fill_in "Frecogida", with: @encargo.frecogida
    fill_in "Nombre", with: @encargo.nombre
    click_on "Create Encargo"

    assert_text "Encargo was successfully created"
    click_on "Back"
  end

  test "updating a Encargo" do
    visit encargos_url
    click_on "Edit", match: :first

    fill_in "Cantidad iva", with: @encargo.cantidad_iva
    fill_in "Comentario", with: @encargo.comentario
    fill_in "Contacto", with: @encargo.contacto
    fill_in "Direccion recog", with: @encargo.direccion_recog
    fill_in "Fcobro iva", with: @encargo.fcobro_iva
    fill_in "Fentrada and", with: @encargo.fentrada_and
    fill_in "Fpago coche", with: @encargo.fpago_coche
    fill_in "Frecogida", with: @encargo.frecogida
    fill_in "Nombre", with: @encargo.nombre
    click_on "Update Encargo"

    assert_text "Encargo was successfully updated"
    click_on "Back"
  end

  test "destroying a Encargo" do
    visit encargos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Encargo was successfully destroyed"
  end
end
