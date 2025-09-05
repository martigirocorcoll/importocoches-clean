require "application_system_test_case"

class LlamadasTest < ApplicationSystemTestCase
  setup do
    @llamada = llamadas(:one)
  end

  test "visiting the index" do
    visit llamadas_url
    assert_selector "h1", text: "Llamadas"
  end

  test "creating a Llamada" do
    visit llamadas_url
    click_on "New Llamada"

    fill_in "Endpoint", with: @llamada.endpoint
    click_on "Create Llamada"

    assert_text "Llamada was successfully created"
    click_on "Back"
  end

  test "updating a Llamada" do
    visit llamadas_url
    click_on "Edit", match: :first

    fill_in "Endpoint", with: @llamada.endpoint
    click_on "Update Llamada"

    assert_text "Llamada was successfully updated"
    click_on "Back"
  end

  test "destroying a Llamada" do
    visit llamadas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Llamada was successfully destroyed"
  end
end
