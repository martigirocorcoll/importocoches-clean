require "test_helper"

class ImportedCarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @imported_car = imported_cars(:one)
  end

  test "should get index" do
    get imported_cars_url
    assert_response :success
  end

  test "should get new" do
    get new_imported_car_url
    assert_response :success
  end

  test "should create imported_car" do
    assert_difference('ImportedCar.count') do
      post imported_cars_url, params: { imported_car: { ad_image_urls: @imported_car.ad_image_urls, brand: @imported_car.brand, fuel_type: @imported_car.fuel_type, horsepower: @imported_car.horsepower, long_description_cat: @imported_car.long_description_cat, long_description_en: @imported_car.long_description_en, long_description_es: @imported_car.long_description_es, long_description_fr: @imported_car.long_description_fr, mileage: @imported_car.mileage, model: @imported_car.model, real_image_urls: @imported_car.real_image_urls, video_urls: @imported_car.video_urls, year: @imported_car.year } }
    end

    assert_redirected_to imported_car_url(ImportedCar.last)
  end

  test "should show imported_car" do
    get imported_car_url(@imported_car)
    assert_response :success
  end

  test "should get edit" do
    get edit_imported_car_url(@imported_car)
    assert_response :success
  end

  test "should update imported_car" do
    patch imported_car_url(@imported_car), params: { imported_car: { ad_image_urls: @imported_car.ad_image_urls, brand: @imported_car.brand, fuel_type: @imported_car.fuel_type, horsepower: @imported_car.horsepower, long_description_cat: @imported_car.long_description_cat, long_description_en: @imported_car.long_description_en, long_description_es: @imported_car.long_description_es, long_description_fr: @imported_car.long_description_fr, mileage: @imported_car.mileage, model: @imported_car.model, real_image_urls: @imported_car.real_image_urls, video_urls: @imported_car.video_urls, year: @imported_car.year } }
    assert_redirected_to imported_car_url(@imported_car)
  end

  test "should destroy imported_car" do
    assert_difference('ImportedCar.count', -1) do
      delete imported_car_url(@imported_car)
    end

    assert_redirected_to imported_cars_url
  end
end
