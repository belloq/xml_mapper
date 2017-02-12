ExUnit.start()

{:ok, files} = File.ls("./test/xml_mapper/support")

Enum.each files, fn(file) ->
  Code.require_file "xml_mapper/support/#{file}", __DIR__
end
