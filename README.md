# XMLMapper

A simple XML mapper for Elixir.

## Installation

```elixir
def deps do
  [{:xml_mapper, "~> 1.0.0"}]
end
```

## Example
```elixir
defmodule Category do
  use XMLMapper

  element :id, :integer, tag: "ID"
  has_many :products, Product
end

defmodule Product do
  use XMLMapper

  tag "ProductItem"

  element :id, :integer, tag: "ID"
  element :name, :text
end

Category.to_xml(%{id: 1, products: [%{id: 1, name: "Product1"}, %{id: 2, name: "Product2"}]})
#=> "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Category><ID>1</ID><Products><ProductItem><ID>1</ID><Name>Product1</Name></ProductItem><ProductItem><ID>2</ID><Name>Product2</Name></ProductItem></Products></Category>"

Product.to_struct("<ProductItem><ID>2</ID><Name>Product2</Name></ProductItem>")
#=> %{id: 2, name: "Product2"}
```

## TODO
- [ ] default values
- [ ] value parser callback
- [x] escape html characters
- [ ] cdata
- [ ] prefixes
- [ ] override tag name of sub-items in has_many
