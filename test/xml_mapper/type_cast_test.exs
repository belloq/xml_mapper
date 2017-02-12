defmodule XMLMapper.TypeCastTest do
  use ExUnit.Case, async: true

  test "convert to integer" do
    assert XMLMapper.Type.cast(:integer, "1") == 1
    assert XMLMapper.Type.cast(:integer, "12345") == 12345
    assert XMLMapper.Type.cast(:integer, "") == nil
    assert XMLMapper.Type.cast(:integer, "asd") == nil
  end

  test "convert to float" do
    assert XMLMapper.Type.cast(:float, "1.0") == 1.0
    assert XMLMapper.Type.cast(:float, "12345.67") == 12345.67
    assert XMLMapper.Type.cast(:float, "") == nil
    assert XMLMapper.Type.cast(:float, "asd") == nil
  end

  test "convert to string" do
    assert XMLMapper.Type.cast(:text, "123") == "123"
    assert XMLMapper.Type.cast(:text, "Test") == "Test"
  end

  test "convert to datetime" do
    assert XMLMapper.Type.cast(:datetime, "2017-02-11 01:25:35") == ~N[2017-02-11 01:25:35]
    assert XMLMapper.Type.cast(:datetime, "2017-02-11T01:25:35.766Z") == ~N[2017-02-11 01:25:35.766]
  end

  test "convert to boolean" do
    assert XMLMapper.Type.cast(:boolean, "true") == true
    assert XMLMapper.Type.cast(:boolean, "false") == false
    assert XMLMapper.Type.cast(:boolean, "") == false
    assert XMLMapper.Type.cast(:boolean, "asd") == false
  end
end
