defmodule XmlParseTest do
  use ExUnit.Case, async: true

  alias XmlBuildTest.{SimpleOne, SimpleTwo, SimpleThree, SimpleFour, HasManyOne, HasManyTwo, HasManyThree}

  test "Simple xml - 1 element" do
    xml = """
      <?xml version="1.0" encoding="UTF-8"?>
      <SimpleOne>
        <Id>1</Id>
        <Name>Test</Name>
      </SimpleOne>
    """

    assert SimpleOne.to_struct(xml) == %{id: 1}
  end

  test "Simple xml - 2 element" do
    xml = """
      <?xml version="1.0" encoding="UTF-8"?>
      <SimpleTwo>
        <Id>1</Id>
        <Name>Test</Name>
      </SimpleTwo>
    """

    assert SimpleTwo.to_struct(xml) == %{id: 1, name: "Test"}
  end

  test "Renamed tags" do
    xml = """
      <?xml version="1.0" encoding="UTF-8"?>
      <SIMPLEFour>
        <ID>1</ID>
        <Name>Test</Name>
      </SIMPLEFour>
    """

    assert SimpleFour.to_struct(xml) == %{id: 1, name: "Test"}
  end

  test "Nested xml" do
    xml = """
      <?xml version="1.0" encoding="UTF-8"?>
      <SimpleThree>
        <Id>1</Id>
        <Name>Test</Name>
        <SimpleTwo>
          <Id>2</Id>
          <Name>Sub</Name>
        </SimpleTwo>
      </SimpleThree>
    """

    assert SimpleThree.to_struct(xml) == %{id: 1, name: "Test", sub_element: %{id: 2, name: "Sub"}}
  end

  test "Parse simple has many" do
    xml = """
      <?xml version="1.0" encoding="UTF-8"?>
      <HasManyOne>
        <Name>Test1</Name>
        <Name>Test2</Name>
      </HasManyOne>
    """

    assert HasManyOne.to_struct(xml) == %{name: ["Test1", "Test2"]}
  end

  test "Parse nested has many" do
    xml = """
      <?xml version="1.0" encoding="UTF-8"?>
      <HasManyTwo>
        <SimpleOnes>
          <SimpleOne>
            <Id>1</Id>
          </SimpleOne>
          <SimpleOne>
            <Id>2</Id>
          </SimpleOne>
        </SimpleOnes>
      </HasManyTwo>
    """

    assert HasManyTwo.to_struct(xml) == %{simple_ones: [%{id: 1}, %{id: 2}]}
  end

  test "Parse nested has many wihtout root tag" do
    xml = """
      <?xml version="1.0" encoding="UTF-8"?>
      <HasManyThree>
        <SimpleOne>
          <Id>1</Id>
        </SimpleOne>
        <SimpleOne>
          <Id>2</Id>
        </SimpleOne>
      </HasManyThree>
    """

    assert HasManyThree.to_struct(xml) == %{simple_one: [%{id: 1}, %{id: 2}]}
  end
end
