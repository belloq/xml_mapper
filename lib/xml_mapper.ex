defmodule XMLMapper do
  defmacro __using__(_) do
    quote do
      import XMLMapper

      Module.register_attribute(__MODULE__, :elements, accumulate: true)
      Module.register_attribute(__MODULE__, :root_tag, [])
      Module.put_attribute(__MODULE__, :root_tag, "#{__MODULE__}" |> String.split(".") |> List.last)

      @before_compile XMLMapper

      # Map to XML

      def to_xml(struct, include_doc_type \\ true) do
        xml_content =
          struct
          |> generate

        if include_doc_type do
          doc_type() <> xml_content
        else
          xml_content
        end
      end

      def generate(struct) when is_map(struct) do
        xml_content =
          elements()
          |> Enum.reverse
          |> Enum.map(fn(e) -> generate(e, struct, 0) end)
          |> Enum.join

        generate({root_tag(), __MODULE__, []}, xml_content, false, 0)
      end
      def generate({name, type, opts}, struct, indent) when is_map(struct) and indent == 0 do
        no_escape = Keyword.get(opts, :no_escape, false)
        content =
          if no_escape == true do
            Map.get(struct, name)
          else
            XMLMapper.Value.escape(Map.get(struct, name))
          end
        generate({name, type, opts}, List.flatten([content]), Code.ensure_loaded?(type), indent + 1)
      end
      def generate(_tuple, [nil], is_module, _indent) when is_module == true do
        ""
      end
      def generate({name, type, opts}, content, is_module, indent) when is_module == true do
        tag = tag_name(name, opts)
        nested_content =
          content
          |> Enum.map(fn(c) -> "#{type.to_xml(c, false)}" end)
          |> Enum.join

        if opts[:multi] && opts[:without_root] != true do
          generate({name, type, opts}, nested_content, false, indent)
        else
          nested_content
        end
      end
      def generate({name, type, opts}, content, _is_module, _indent) do
        tag = tag_name(name, opts)
        xml(tag, List.flatten([content]), opts[:multi], "")
      end

      defp tag_name(name, opts) do
        if is_nil(opts[:tag]) do
          Macro.camelize(to_string(name))
        else
          opts[:tag]
        end
      end

      def xml(tag, [content | tail], multi, xml) do
        xml(tag, tail, multi, [xml | xml(tag, content, multi, "")])
      end
      def xml(_tag, content, _multi, _xml) when not is_list(content) and is_nil(content) do
        [""]
      end
      def xml(tag, content, multi, _xml) when not is_list(content) do
        ["<#{tag}>#{content}</#{tag}>"]
      end
      def xml(_tag, [], _multi, xml) do
        xml |> Enum.join
      end

      defp doc_type do
        ~s|<?xml version="1.0" encoding="UTF-8"?>|
      end

      # XML to Map

      def to_struct(xml) do
        xml = String.replace(xml, ~r/\sxmlns=\".*\"/, "")
        {:ok, tuples, _} = :erlsom.simple_form(xml)

        parse(tuples)
      end

      def parse(tuples) when is_tuple(tuples) do
        parse(elem(tuples, 2), %{})
      end
      def parse([{tag, attrs, content} | tail], struct) do
        element = Enum.find(elements(), nil, fn({name, type, opts}) ->
          tag_name(name, opts) == to_string(tag)
        end)

        unless is_nil(element) do
          key =
            elem(element, 0)
            |> to_string
            |> Macro.underscore
            |> String.to_atom

          value = XMLMapper.Type.cast(elem(element, 1), content, elem(element, 2))

          if elem(element, 2)[:multi] do
            value_list = Map.get(struct, key, []) ++ [value]
            parse(tail, Map.merge(struct, %{key => List.flatten(value_list)}))
          else
            parse(tail, Map.merge(struct, %{key => value}))
          end
        else
          parse(tail, struct)
        end
      end
      def parse([], struct) do
        struct
      end
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def elements, do: @elements

      def root_tag, do: @root_tag
    end
  end

  defmacro element(name, type, opts \\ []) do
    quote do
      Module.put_attribute(__MODULE__, :elements, {unquote(name), unquote(type), unquote(opts)})
    end
  end

  defmacro has_many(name, type, opts \\ []) do
    quote do
      Module.put_attribute(__MODULE__, :elements, {unquote(name), unquote(type), unquote(opts) ++ [multi: true]})
    end
  end

  defmacro tag(value) do
    quote do
      Module.put_attribute(__MODULE__, :root_tag, unquote(value))
    end
  end
end
