defmodule XMLMapper.EscapeTest do
  use ExUnit.Case, async: true

  test "escape" do
    assert XMLMapper.Value.escape("Lorem & ipsum") == "Lorem &amp; ipsum"
    assert XMLMapper.Value.escape("Lorem & <ipsum> 'dolor' \"sit\"") == "Lorem &amp; &lt;ipsum&gt; &apos;dolor&apos; &quot;sit&quot;"
    assert XMLMapper.Value.escape(42) == 42
  end
end
