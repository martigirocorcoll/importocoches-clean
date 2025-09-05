require "test_helper"

class LlamadasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @llamada = llamadas(:one)
  end

  test "should get index" do
    get llamadas_url
    assert_response :success
  end

  test "should get new" do
    get new_llamada_url
    assert_response :success
  end

  test "should create llamada" do
    assert_difference('Llamada.count') do
      post llamadas_url, params: { llamada: { endpoint: @llamada.endpoint } }
    end

    assert_redirected_to llamada_url(Llamada.last)
  end

  test "should show llamada" do
    get llamada_url(@llamada)
    assert_response :success
  end

  test "should get edit" do
    get edit_llamada_url(@llamada)
    assert_response :success
  end

  test "should update llamada" do
    patch llamada_url(@llamada), params: { llamada: { endpoint: @llamada.endpoint } }
    assert_redirected_to llamada_url(@llamada)
  end

  test "should destroy llamada" do
    assert_difference('Llamada.count', -1) do
      delete llamada_url(@llamada)
    end

    assert_redirected_to llamadas_url
  end
end
