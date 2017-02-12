defmodule XmlBuildTest.SimpleOne do
  use XMLMapper

  element :id, :integer
end

defmodule XmlBuildTest.SimpleTwo do
  use XMLMapper

  element :id, :integer
  element :name, :text
end

defmodule XmlBuildTest.SimpleThree do
  use XMLMapper

  element :id, :integer
  element :name, :text
  element :sub_element, XmlBuildTest.SimpleTwo, tag: "SimpleTwo"
end

defmodule XmlBuildTest.SimpleFour do
  use XMLMapper

  tag "SIMPLEFour"

  element :id, :integer, tag: "ID"
  element :name, :text
end

defmodule XmlBuildTest.HasManyOne do
  use XMLMapper

  has_many :name, :text
end

defmodule XmlBuildTest.HasManyTwo do
  use XMLMapper

  has_many :simple_ones, XmlBuildTest.SimpleOne
end

defmodule XmlBuildTest.HasManyThree do
  use XMLMapper

  has_many :simple_one, XmlBuildTest.SimpleOne, without_root: true
end
