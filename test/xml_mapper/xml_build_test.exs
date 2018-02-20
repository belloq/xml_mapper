defmodule XmlBuildTest do
  use ExUnit.Case, async: true

  alias XmlBuildTest.{SimpleOne, SimpleTwo, SimpleThree, SimpleFour, HasManyOne, HasManyTwo, HasManyThree}

  test "Simple struct - 1 element" do
    assert SimpleOne.to_xml(%{id: 1}) == ~s|<?xml version="1.0" encoding="UTF-8"?><SimpleOne><Id>1</Id></SimpleOne>|
  end

  test "Simple struct - 1 element - undefined element" do
    assert SimpleOne.to_xml(%{id: 1, undefined: "Test"}) == ~s|<?xml version="1.0" encoding="UTF-8"?><SimpleOne><Id>1</Id></SimpleOne>|
  end

  test "Simple struct - 2 element" do
    assert SimpleTwo.to_xml(%{id: 1, name: "Test"}) == ~s|<?xml version="1.0" encoding="UTF-8"?><SimpleTwo><Id>1</Id><Name>Test</Name></SimpleTwo>|
  end

  test "Simple struct - escape" do
    assert SimpleTwo.to_xml(%{id: 1, name: "Test & test"}) == ~s|<?xml version="1.0" encoding="UTF-8"?><SimpleTwo><Id>1</Id><Name>Test &amp; test</Name></SimpleTwo>|
  end

  test "Nested struct" do
    assert SimpleThree.to_xml(%{id: 1, name: "Test", sub_element: %{id: 2, name: "Sub"}}) == ~s|<?xml version="1.0" encoding="UTF-8"?><SimpleThree><Id>1</Id><Name>Test</Name><SimpleTwo><Id>2</Id><Name>Sub</Name></SimpleTwo></SimpleThree>|
  end

  test "Nested struct - escape" do
    assert SimpleThree.to_xml(%{id: 1, name: "Test", sub_element: %{id: 2, name: "Sub & <sub>"}}) == ~s|<?xml version="1.0" encoding="UTF-8"?><SimpleThree><Id>1</Id><Name>Test</Name><SimpleTwo><Id>2</Id><Name>Sub &amp; &lt;sub&gt;</Name></SimpleTwo></SimpleThree>|
  end

  test "Renamed tags struct" do
    assert SimpleFour.to_xml(%{id: 1, name: "Test"}) == ~s|<?xml version="1.0" encoding="UTF-8"?><SIMPLEFour><ID>1</ID><Name>Test</Name></SIMPLEFour>|
  end

  test "Simple has many" do
    assert HasManyOne.to_xml(%{name: ["Test1", "Test2"]}) == ~s|<?xml version="1.0" encoding="UTF-8"?><HasManyOne><Name>Test1</Name><Name>Test2</Name></HasManyOne>|
  end

  test "Nested has many" do
    assert HasManyTwo.to_xml(%{simple_ones: [%{id: 1}, %{id: 2}]}) == ~s|<?xml version="1.0" encoding="UTF-8"?><HasManyTwo><SimpleOnes><SimpleOne><Id>1</Id></SimpleOne><SimpleOne><Id>2</Id></SimpleOne></SimpleOnes></HasManyTwo>|
  end

  test "Nested has many without root tag" do
    assert HasManyThree.to_xml(%{simple_one: [%{id: 1}, %{id: 2}]}) == ~s|<?xml version="1.0" encoding="UTF-8"?><HasManyThree><SimpleOne><Id>1</Id></SimpleOne><SimpleOne><Id>2</Id></SimpleOne></HasManyThree>|
  end

  test "Build xml with partial dataset" do
    assert SimpleTwo.to_xml(%{id: 1}) == ~s|<?xml version="1.0" encoding="UTF-8"?><SimpleTwo><Id>1</Id></SimpleTwo>|
  end

  test "Build nested xml with partial dataset" do
    assert SimpleThree.to_xml(%{id: 1}) == ~s|<?xml version="1.0" encoding="UTF-8"?><SimpleThree><Id>1</Id></SimpleThree>|
  end
end
