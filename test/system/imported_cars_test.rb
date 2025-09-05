require "application_system_test_case"

class ImportedCarsTest < ApplicationSystemTestCase
  setup do
    @imported_car = imported_cars(:one)
  end

  test "visiting the index" do
    visit imported_cars_url
    assert_selector "h1", text: "Imported Cars"
  end

  test "creating a Imported car" do
    visit imported_cars_url
    click_on "New Imported Car"

    fill_in "Ad image urls", with: @imported_car.ad_image_urls
    fill_in "Brand", with: @imported_car.brand
    fill_in "Fuel type", with: @imported_car.fuel_type
    fill_in "Horsepower", with: @imported_car.horsepower
    fill_in "Long description cat", with: @imported_car.long_description_cat
    fill_in "Long description en", with: @imported_car.long_description_en
    fill_in "Long description es", with: @imported_car.long_description_es
    fill_in "Long description fr", with: @imported_car.long_description_fr
    fill_in "Mileage", with: @imported_car.mileage
    fill_in "Model", with: @imported_car.model
    fill_in "Real image urls", with: @imported_car.real_image_urls
    fill_in "Video urls", with: @imported_car.video_urls
    fill_in "Year", with: @imported_car.year
    click_on "Create Imported car"

    assert_text "Imported car was successfully created"
    click_on "Back"
  end

  test "updating a Imported car" do
    visit imported_cars_url
    click_on "Edit", match: :first

    fill_in "Ad image urls", with: @imported_car.ad_image_urls
    fill_in "Brand", with: @imported_car.brand
    fill_in "Fuel type", with: @imported_car.fuel_type
    fill_in "Horsepower", with: @imported_car.horsepower
    fill_in "Long description cat", with: @imported_car.long_description_cat
    fill_in "Long description en", with: @imported_car.long_description_en
    fill_in "Long description es", with: @imported_car.long_description_es
    fill_in "Long description fr", with: @imported_car.long_description_fr
    fill_in "Mileage", with: @imported_car.mileage
    fill_in "Model", with: @imported_car.model
    fill_in "Real image urls", with: @imported_car.real_image_urls
    fill_in "Video urls", with: @imported_car.video_urls
    fill_in "Year", with: @imported_car.year
    click_on "Update Imported car"

    assert_text "Imported car was successfully updated"
    click_on "Back"
  end

  test "destroying a Imported car" do
    visit imported_cars_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Imported car was successfully destroyed"
  end
end
