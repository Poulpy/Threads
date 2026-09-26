require "test_helper"

class EquipmentTest < ActiveSupport::TestCase
  test "equipment should have a category" do
    o = Equipment.new(
      category: nil
    )
    assert_not(o.save)
  end

  test "name should be present" do
    o = Equipment.new(category: :sewing, name: "")
    assert_not(o.save)
  end
end
