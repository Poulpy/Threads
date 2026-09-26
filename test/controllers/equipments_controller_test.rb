require "test_helper"

class EquipmentsControllerTest < ActionDispatch::IntegrationTest
  test "it should return all equipments" do
    equipment_count = Equipment.all.count

    get v1_equipments_url
    json = JSON.parse(response.body)

    assert_response :success
    assert json.size, equipment_count
  end

  test "it should return all sewing equipment" do
    equipment_count = Equipment.where(category: :sewing).count
    get v1_equipments_url(category: :sewing), as: :json
    json = JSON.parse(response.body)

    assert_response :success
    assert json.size, equipment_count
  end

  test "it should return an error on an unknown category" do
    get v1_equipments_url(category: "machin"), as: :json
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "This category does not exist", json['error']
  end

  test "it should paginate" do
    get v1_equipments_url(page: 1), as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert json.size, V1::EquipmentsController::LIMIT
  end

  test "it should return an error on a negative page" do
    get v1_equipments_url(page: -1), as: :json
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "Page must be positive", json['error']
  end

  test "it should sort the equipements in reverse alphabetical order" do
    get v1_equipments_url(sort: "desc"), as: :json
    assert_response :success
  end
end
